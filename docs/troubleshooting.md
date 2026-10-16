# Troubleshooting Log

This log records issues encountered while building the Azure Linux web server project and how they were resolved. It is useful to keep the symptom, root cause, fix, and verification together.

## 1. Terraform could not authenticate through Azure CLI

**Symptom**

Terraform plan failed while building the Azure Resource Manager authorizer. The error said that a tenant ID could not be determined.

**Investigation**

Azure CLI returned an error indicating `Permission denied` for a local extension metadata file under:

```text
%USERPROFILE%\.azure\cliextensions\account\azext_account\azext_metadata.json
```

**Resolution**

The Azure CLI extension issue was addressed before retrying Terraform authentication. Azure CLI was then used to sign in and select/verify the appropriate subscription.

**Lesson learned**

An authentication error shown by Terraform can be caused by an underlying Azure CLI problem. Test Azure CLI directly before changing Terraform provider configuration. Never delete the entire `.azure` directory as a first troubleshooting step, because it can contain local CLI configuration and authentication data.

## 2. Azure CLI reported that no subscriptions were found

**Symptom**

After installing Azure CLI, it reported that no subscriptions were found.

**Resolution / verification**

The next step was to authenticate with the Microsoft account that has access to the Azure subscription and check the available accounts/subscriptions:

```powershell
az login
az account list --output table
az account show --output table
```

If the expected subscription does not appear, verify that the correct account and tenant were used and that the account has access to an active Azure subscription.

**Lesson learned**

Installing Azure CLI does not automatically authenticate the user or guarantee that the signed-in account has a subscription.

## 3. Terraform treated resource references as literal strings

**Symptom**

Terraform reported an unsupported Azure location and displayed a location value that looked like a quoted Terraform expression. The plan also showed resource names in fields where resource references were expected.

**Root cause**

Resource references had been wrapped in quotation marks, for example:

```hcl
location = "azurerm_resource_group.cloud_project.location"
```

Quoted text is treated as a string, not an expression.

**Fix**

Remove the quotation marks from Terraform references:

```hcl
location            = azurerm_resource_group.cloud_project.location
resource_group_name = azurerm_resource_group.cloud_project.name
virtual_network_name = azurerm_virtual_network.cloud_project.name
```

**Verification**

Ran:

```powershell
terraform fmt
terraform validate
terraform plan
```

The configuration then validated and Terraform generated a plan.

## 4. Terraform planned to create resources that already existed

**Symptom**

The plan initially showed three resources to add: the resource group, virtual network, and subnet.

**Root cause**

Those resources had been created manually in Azure, but they were not yet recorded in the local Terraform state.

**Fix**

Imported the existing resources into the corresponding Terraform addresses using `terraform import` and their Azure resource IDs.

**Verification**

Checked the state with:

```powershell
terraform state list
```

Then reviewed `terraform plan` again.

**Lesson learned**

Terraform configuration describes desired infrastructure, while Terraform state maps configuration addresses to real resources. Importing existing resources avoids attempting to recreate them.

## 5. Terraform proposed enabling default outbound access on the subnet

**Symptom**

After import, the plan proposed an in-place subnet update:

```text
default_outbound_access_enabled: false -> true
```

**Root cause**

The existing subnet's setting differed from the value Terraform expected when the argument was omitted.

**Fix**

Verified the setting in Azure and explicitly configured the intended existing value in the subnet resource:

```hcl
default_outbound_access_enabled = false
```

**Verification**

Ran `terraform plan` again. The final result reported:

```text
No changes. Your infrastructure matches the configuration.
```

**Lesson learned**

Provider defaults can create differences between imported infrastructure and configuration. Verify the real setting and explicitly document important network behavior instead of applying an unexplained change.

## Troubleshooting principles used

- Read the full error message and identify which tool produced it.
- Test the underlying tool directly (for example, Azure CLI before Terraform).
- Avoid destructive cleanup commands until the affected file or setting is understood.
- Inspect the plan before applying any infrastructure change.
- Import existing infrastructure instead of attempting to recreate it.
- Redact subscription IDs, tenant IDs, public IPs where appropriate, usernames, and other sensitive details from public screenshots and logs.
