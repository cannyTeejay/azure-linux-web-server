# Architecture Overview

## Purpose

This project hosts a static/custom web dashboard on an Ubuntu virtual machine in Microsoft Azure. Nginx serves the web page, and the network is configured to allow HTTP traffic while restricting SSH access.

## Current architecture

```text
Internet
   |
   | HTTP (TCP/80)
   v
Azure Public IP
   |
Network Interface
   |
Network Security Group (NSG)
   |  Allow HTTP from intended sources
   |  Restrict SSH (TCP/22) to permitted client IP
   v
Virtual Network: vnet-cloud-project
Address space: 10.10.0.0/16
   |
Subnet: snet-web
Address prefix: 10.10.1.0/24
   |
Ubuntu VM: vm-web-01
   |
Nginx
   |
website/index.html
```

## Azure resources

| Resource | Name |
|---|---|
| Resource group | `rg-cloud-project` |
| Virtual network | `vnet-cloud-project` |
| Virtual network address space | `10.10.0.0/16` |
| Subnet | `snet-web` |
| Subnet address range | `10.10.1.0/24` |
| Network Security Group | `nsg-web` |
| Virtual machine | `vm-web-01` |
| Region | South Africa North |

## Security controls

- Network Security Group rules control traffic reaching the VM.
- SSH (TCP/22) is restricted to the permitted client IP.
- HTTP (TCP/80) is allowed so the website can be reached.
- Ubuntu UFW is enabled with the required ports allowed.
- SSH public-key authentication is enabled; password authentication is disabled.

Confirm the current Azure rule configuration before claiming that it matches this summary. Do not publish private keys, credentials, or sensitive account identifiers.

## Automation and infrastructure as code

The Bash setup script installs and configures Nginx, enables UFW rules for SSH and HTTP, restarts/enables the Nginx service, and checks the service and listening ports.

Terraform currently manages the resource group, virtual network, and subnet. The planned next phase is to import and manage the existing NSG and its rules, followed by the public IP, network interface, and VM.

## Validation

Useful checks include:

```bash
sudo systemctl status nginx
sudo ss -tulpn
sudo ufw status
```

From the Terraform directory:

```powershell
terraform validate
terraform plan
terraform state list
```

Add a screenshot of the deployed site and a diagram image if available. Keep account IDs, private IP details that should not be public, and credentials out of screenshots.
