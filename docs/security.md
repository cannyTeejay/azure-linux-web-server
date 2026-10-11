# Security Configuration

## Azure Network Security Group

The project uses an Azure Network Security Group named `nsg-web`.

Inbound traffic is restricted to the following:

| Protocol | Port | Source | Purpose |
|---|---:|---|---|
| TCP | 22 | Administrator public IP | SSH administration |
| TCP | 80 | Internet | Web traffic |

All other inbound traffic is denied by the Azure NSG's default deny rule.

## Linux Firewall

The Ubuntu server uses UFW (Uncomplicated Firewall).

Configured inbound rules:

| Protocol | Port | Purpose |
|---|---:|---|
| TCP | 22 | SSH |
| TCP | 80 | HTTP |

The Azure NSG provides the external network filtering layer, while UFW provides an additional firewall layer on the Linux server.

## SSH Authentication

The VM uses SSH public-key authentication rather than password authentication.

The private SSH key is stored locally and is not committed to GitHub.


## Linux User Management

A dedicated `sysadmin` account was created for administrative tasks.

The account was added to the Linux `sudo` group rather than using the root account directly.

This follows the principle of least privilege and provides an auditable administrative account.

## Firewall Layers

The server uses two network security layers:

1. Azure Network Security Group
2. Ubuntu UFW firewall

The Azure NSG restricts SSH access to the administrator's public IP, while HTTP is publicly accessible.

UFW allows the required application and administration ports on the Linux server.