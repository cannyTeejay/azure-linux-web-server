## Infrastructure as Code with Terraform

The existing Azure network was initially created manually and then brought under Terraform management. I wrote Terraform configuration for the resource group, virtual network, and subnet, imported those existing resources into Terraform state, and reconciled the configuration until `terraform plan` reported no changes.

### Terraform workflow

```powershell
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform state list
```

I review every plan before considering an apply. I do not apply plans that propose unexpected changes to existing infrastructure.

See [Terraform implementation and import notes](docs/terraform.md) and [Troubleshooting log](docs/troubleshooting.md).

## Security and state management

- SSH (TCP/22) is restricted to my permitted client IP in the Network Security Group.
- HTTP (TCP/80) is allowed for public access to the Nginx web page.
- Ubuntu UFW allows the required SSH and HTTP traffic.
- SSH key authentication is enabled; SSH password authentication is disabled.
- Terraform state and plan files are excluded from Git because they can contain sensitive infrastructure details.
- No credentials, private keys, subscription IDs, or secrets should be committed to this repository.