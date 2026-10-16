# Terraform: Azure Infrastructure as Code

## Goal

Bring the existing Azure network resources under Terraform management without recreating them or making unreviewed changes.

## Resources currently represented in Terraform

| Terraform address | Azure resource | Configuration |
|---|---|---|
| `azurerm_resource_group.cloud_project` | `rg-cloud-project` | Resource group in South Africa North |
| `azurerm_virtual_network.cloud_project` | `vnet-cloud-project` | Address space `10.10.0.0/16` |
| `azurerm_subnet.web` | `snet-web` | Address prefix `10.10.1.0/24` |

## Tooling and configuration

- Terraform CLI installed on Windows.
- Azure CLI installed for Azure authentication.
- AzureRM provider configured in `terraform/main.tf`.
- Azure CLI authentication used for the local Terraform workflow.

The provider configuration currently uses AzureRM `~> 4.0`. Review the official provider documentation when upgrading versions.

## Workflow used

From the `terraform/` directory:

```powershell
terraform init
terraform fmt
terraform validate
terraform plan
```

`terraform init` initializes the working directory and downloads provider dependencies. `terraform fmt` formats the HCL. `terraform validate` checks configuration syntax and internal consistency. `terraform plan` previews proposed infrastructure changes.

## Importing resources that already existed

Because the resource group, virtual network, and subnet had been created manually in Azure, the initial plan proposed creating them again. Instead of applying that plan, I imported each existing resource into Terraform state.

The general Azure resource ID pattern used was:

```text
/subscriptions/<SUBSCRIPTION_ID>/resourceGroups/<RESOURCE_GROUP>/providers/Microsoft.Network/virtualNetworks/<VNET_NAME>
```

For a subnet, append:

```text
/subnets/<SUBNET_NAME>
```

The resource group was imported using its resource ID. The virtual network and subnet were imported using their respective Azure resource IDs. Subscription IDs are intentionally represented as placeholders in this documentation.

After importing, I checked state with:

```powershell
terraform state list
```

Then I ran `terraform plan` and adjusted configuration to match the intended existing settings. The final plan reported:

```text
No changes. Your infrastructure matches the configuration.
```

This confirms that the resources represented in the current configuration match the Terraform state and the provider's view of Azure at plan time. It does not mean every Azure resource in the subscription is managed by Terraform.

## Important safety practice

Always inspect `terraform plan` before applying. If the plan proposes unexpected updates, replacements, or deletions, stop and reconcile the configuration first.

Do not commit these files to Git:

- `terraform.tfstate`
- `terraform.tfstate.backup`
- `*.tfplan`
- local credential files or secrets

Terraform state can contain sensitive values and detailed infrastructure metadata. For a team or production setup, consider a secured remote backend with access controls and locking.

## Planned next steps

1. Add Terraform resources for the existing Network Security Group and its individual security rules.
2. Import those resources into Terraform state.
3. Reconcile the NSG configuration and verify the plan.
4. Add the existing public IP, network interface, and virtual machine to Terraform in a controlled sequence.
5. Verify each import and review each plan before any apply.
