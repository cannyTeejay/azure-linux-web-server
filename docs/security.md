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