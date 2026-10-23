# Project 1: Host a Static Website Using Azure Storage

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform&logoColor=white)
![Azure](https://img.shields.io/badge/Microsoft_Azure-Storage-0078D4?logo=microsoftazure&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-validation-2088FF?logo=githubactions&logoColor=white)

A portfolio-ready demonstration of hosting a static website with Azure Storage, provisioned using Terraform and validated with GitHub Actions.

## Architecture

```text
Browser
  |
  | HTTPS (public read access by design)
  v
Azure Storage static website endpoint
  |
  +-- $web/index.html
  +-- $web/404.html
  +-- $web/styles.css

Terraform provisions:
  +-- Resource Group
  +-- Standard StorageV2 account (LRS)
  +-- Static website configuration
  +-- Website blobs
```

## What this project creates

- Resource group: `rg-static-website-demo`
- Storage Account: `buildvipinsitedemo123` (must be globally unique; change if unavailable)
- Performance: Standard
- Redundancy: Locally redundant storage (LRS)
- Static website index: `index.html`
- Error document: `404.html`
- HTTPS-only Storage Account traffic and TLS 1.2 minimum
- Website files uploaded to the `$web` container
- GitHub Actions workflow for Terraform formatting and validation

## Important security and cost notes

- The static website endpoint is publicly readable. Never publish confidential or personal data.
- Static website hosting does not provide built-in authentication/authorization. For authenticated sites, consider Azure Static Web Apps or another architecture.
- This repository intentionally does not configure a remote Terraform backend. Local Terraform state is excluded by `.gitignore`; do not commit it. For team or production use, configure a secured remote backend with restricted access, encryption and recovery controls.
- Azure resources can incur charges. LRS and a small static website are economical for a demo, but storage, transactions, data transfer, monitoring and optional CDN/Front Door can incur costs.
- CDN is optional and omitted from the baseline to keep the first project simple.
- Do not use production credentials or employer/customer configuration.

## Prerequisites

1. An Azure subscription and permission to create resource groups and Storage Accounts.
2. [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) installed.
3. [Terraform](https://developer.hashicorp.com/terraform/install) installed (1.6+).
4. Git installed.
5. An Azure region supported by your subscription.

## Deploy with Terraform

### 1. Clone the repository

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/azure-storage-static-website.git
cd azure-storage-static-website
```

Replace `YOUR_GITHUB_USERNAME` with your GitHub username.

### 2. Sign in to Azure

```bash
az login
az account list --output table
az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
az account show --output table
```

Confirm that the selected subscription is the intended learning subscription.

### 3. Configure local variables

Copy `terraform.tfvars.example` to `terraform.tfvars` and set your subscription ID, region, and a globally unique Storage Account name. The local file is ignored by Git.

Example:

```hcl
subscription_id      = "00000000-0000-0000-0000-000000000000"
resource_group_name  = "rg-static-website-demo"
location             = "eastus"
storage_account_name = "replacewithunique123"
```

Storage Account naming rules: 3-24 characters, lowercase letters and numbers only. The name must be globally unique across Azure.

### 4. Initialize and validate

```bash
terraform init
terraform fmt -check -recursive
terraform validate
terraform plan -out=tfplan
```

Review the plan before applying. The saved plan is ignored by Git and must not be published.

### 5. Deploy

```bash
terraform apply tfplan
```

Confirm the plan before proceeding. Terraform creates the resource group, Storage Account, static website configuration and website files.

### 6. Test the website

```bash
terraform output -raw static_website_url
```

Open the returned URL in a browser. Also test the error page by opening a nonexistent path under the website endpoint.

Azure may take a short time after provisioning before the endpoint responds.

## Deploy manually in Azure Portal (alternative)

1. Sign in at https://portal.azure.com.
2. Create resource group `rg-static-website-demo`.
3. Create a globally unique Storage Account in the same region:
   - Performance: Standard
   - Redundancy: LRS
   - Account kind: StorageV2
4. Open **Data management → Static website**.
5. Enable static website hosting.
6. Set index document to `index.html` and error document to `404.html`, then save.
7. Open **Containers → `$web`**.
8. Upload the files from the `website/` directory, including `index.html`, `404.html`, and `styles.css`.
9. Copy the Primary endpoint from the Static website page and test it in a browser.

If you deploy through Terraform, do not independently modify the same resources in the Portal unless you understand how Terraform will reconcile those changes.

## Cleanup: delete all demo resources

**Warning:** This deletes the resource group and everything inside it. Confirm the resource group contains only resources created for this demo.

```bash
terraform destroy
```

Review and confirm the destroy plan. If you created resources manually or Terraform state is unavailable, verify the resource group contents in Azure Portal before deleting it.

## GitHub Actions

The included workflow runs on pull requests and pushes to `main`. It checks Terraform formatting and validates the configuration without logging into Azure or deploying resources.

For a production repository, pin third-party GitHub Actions to verified full commit SHAs and update them intentionally. Protect `main`, require CI checks, and enable secret scanning and dependency alerts where available.

## Repository structure

```text
.
├── .github/workflows/terraform-ci.yml
├── website/
│   ├── index.html
│   ├── 404.html
│   └── styles.css
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars.example
├── .gitignore
├── SECURITY.md
├── LICENSE
└── README.md
```

## Learning outcomes

- Azure Storage static website hosting
- Terraform resource dependencies, variables and outputs
- Version-controlled infrastructure and CI validation
- Basic Azure Storage security settings
- Cost awareness and safe resource cleanup

## Official documentation

- [Host a static website in Azure Storage](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website-how-to)
- [Static website hosting in Azure Storage: limitations and pricing](https://learn.microsoft.com/en-us/azure/storage/blobs/storage-blob-static-website)
- [Terraform on Azure](https://learn.microsoft.com/en-us/azure/developer/terraform/)
- [GitHub Actions security hardening](https://docs.github.com/en/actions/security-for-github-actions/security-guides/security-hardening-for-github-actions)
