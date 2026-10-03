# Hub-and-Spoke Network Architecture & Sizing Guide (AZ-104)

## IP Addressing Plan
| Network / Subnet | CIDR Block | Total IPs | Usable IPs | Purpose |
| :--- | :--- | :--- | :--- | :--- |
| **Hub VNet** | \10.0.0.0/16\ | 65,536 | - | Core connectivity & shared services |
| ├── \GatewaySubnet\ | \10.0.0.0/24\ | 256 | 251 | VPN Gateway / ExpressRoute |
| ├── \AzureFirewallSubnet\ | \10.0.1.0/24\ | 256 | 251 | Centralized ingress/egress firewall |
| ├── \AzureBastionSubnet\ | \10.0.2.0/24\ | 256 | 251 | Secure browser RDP/SSH access |
| └── \snet-hub-mgmt\ | \10.0.3.0/24\ | 256 | 251 | Jumpbox & monitoring management |
| **Spoke 1 (Dev)** | \10.1.0.0/16\ | 65,536 | - | Development application workloads |
| **Spoke 2 (Prod)** | \10.2.0.0/16\ | 65,536 | - | Production enterprise workloads |

## AZ-104 Key Exam Takeaways
1. **Azure Reserved IPs**: Every subnet loses 5 IP addresses (.0 network, .1 default gateway, .2/.3 DNS, .255 broadcast).
2. **Subnet Delegation**: Services like Azure App Service or Azure SQL Managed Instance require subnet delegation; no other resources can be placed in a delegated subnet.
3. **GatewaySubnet Restrictions**: Cannot assign an NSG to the GatewaySubnet.
