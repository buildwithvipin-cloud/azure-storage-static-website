# Security Policy

## Scope

This is a learning and portfolio repository. Do not use it to store credentials, production state, confidential information, or employer/customer data.

## Reporting

For this public demo, do not publish secrets or sensitive details in issues. If you discover a credential has been exposed, revoke or rotate it immediately, inspect Azure activity logs, and remove the exposed value from repository history where appropriate.

## Security design

- Website files served by the Azure Storage static website endpoint are publicly readable by design.
- HTTPS-only traffic and TLS 1.2 minimum are configured for the Storage Account.
- The baseline GitHub Actions workflow has read-only repository permissions and does not deploy to Azure.
- Terraform state, plans and local variable files are excluded from version control.
- For production use, use a secured remote state backend and short-lived authentication such as workload identity federation where supported.
