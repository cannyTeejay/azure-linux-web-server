# Azure Linux Web Server

A hands-on cloud infrastructure project built with Microsoft Azure, Ubuntu Linux, Nginx, Bash, and Terraform. The project demonstrates how to deploy, secure, monitor, and automate a Linux web server in Azure.

## Project Overview

The goal of this project is to develop practical cloud engineering and infrastructure administration skills by deploying a Linux web server and progressively bringing the infrastructure under Infrastructure as Code (IaC) management.

The initial infrastructure was created in the Azure Portal. Terraform is now being used to manage the existing resource group, virtual network, and subnet, with additional resources planned for migration into Terraform.

## Architecture

The project uses the following Azure components:

- **Azure Virtual Network:** `vnet-cloud-project` — `10.10.0.0/16`
- **Subnet:** `snet-web` — `10.10.1.0/24`
- **Network Security Group:** `nsg-web`
- **Virtual Machine:** `vm-web-01`, running Ubuntu Linux
- **Nginx:** Serves the custom web dashboard over HTTP
- **Azure Public IP and Network Interface:** Provide external access and VM connectivity

The resources are deployed in the South Africa North Azure region.

See [Architecture Documentation](architecture/architecture.md).

## Technologies Used

- Microsoft Azure
- Ubuntu Linux
- Nginx
- Bash scripting
- Terraform and AzureRM provider
- Azure CLI
- Git and GitHub
- Networking, SSH, UFW, and NSG security rules

## Key Features

- Linux virtual machine deployment and administration
- Nginx web server installation and configuration
- Network segmentation using a virtual network and subnet
- Network security rules for HTTP and restricted SSH access
- SSH public-key authentication
- Host-based firewall configuration with UFW
- Bash automation for server setup
- Linux service, resource, and log monitoring
- Terraform configuration, resource imports, and infrastructure plan validation
- Troubleshooting and technical documentation

## Security

The project applies several basic security practices:

- SSH access is restricted to an authorised client IP through the NSG.
- HTTP traffic is permitted for access to the web dashboard.
- UFW is configured to allow the required SSH and HTTP traffic.
- SSH public-key authentication is enabled and password authentication is disabled.
- Terraform plans are reviewed before any infrastructure changes are applied.
- Credentials, private keys, and Terraform state files are excluded from version control.

## Automation

The `scripts/setup-server.sh` script automates key server setup tasks, including installing Nginx, configuring firewall rules, enabling and restarting the service, and checking service status and listening ports.

## Terraform and Infrastructure as Code

Terraform is used to manage existing Azure infrastructure that was initially deployed through the Azure Portal. Rather than recreating the resources, I imported them into Terraform state and reconciled the configuration with the deployed infrastructure.

### Resources managed by Terraform

- Azure Resource Group
- Virtual Network and Subnet
- Network Security Group and Subnet Association
- Public IP Address
- Network Interface
- Linux Virtual Machine

### Validation workflow

```powershell
cd terraform
terraform init
terraform fmt
terraform validate
terraform plan
terraform state list
```

The configuration was validated, and `terraform plan` reported that no changes were needed. This confirms that the managed resources match the current Terraform configuration.

I review Terraform plans before making changes to avoid accidental modifications or replacement of existing infrastructure.

## Project Status

**Deployed — Terraform configuration reconciled.**

The Ubuntu Linux virtual machine is running Nginx, and the website remains accessible. Eight existing Azure resources are tracked in Terraform state, with the latest plan reporting no changes.

Future improvements may include more complete security-rule management, automated deployment, HTTPS, monitoring, and cost optimisation.

## Troubleshooting and Lessons Learned

During development, I encountered and resolved issues involving:

- Azure CLI authentication and local extension permissions
- Terraform resource references incorrectly written as quoted strings
- Importing existing Azure resources into Terraform state
- Reconciling subnet outbound-access settings
- Validating Terraform configuration and reviewing infrastructure plans

These experiences helped me understand the relationship between Terraform configuration, Terraform state, Azure resources, and provider defaults.

See [Troubleshooting Documentation](docs/troubleshooting.md).

## Repository Structure

```text
azure-linux-web-server/
├── architecture/
├── docs/
│   ├── linux-setup.md
│   ├── networking.md
│   ├── security.md
│   ├── troubleshooting.md
│   └── terraform.md
├── nginx/
├── scripts/
│   └── setup-server.sh
├── screenshots/
├── terraform/
│   └── main.tf
├── website/
│   └── index.html
└── README.md
```

## Documentation

- [Architecture](architecture/architecture.md)
- [Linux Setup](docs/linux-setup.md)
- [Networking](docs/networking.md)
- [Security](docs/security.md)
- [Troubleshooting Log](docs/troubleshooting.md)
- [Terraform Implementation](docs/terraform.md)

## Project Status

**In progress.** The Linux web server is deployed and the current Terraform configuration matches the imported resource group, virtual network, and subnet. The next milestone is managing the existing NSG and its rules through Terraform.

## Learning Outcomes

This project provides practical experience with Linux server administration, cloud networking, access control, Bash automation, troubleshooting, and Infrastructure as Code using Terraform.



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