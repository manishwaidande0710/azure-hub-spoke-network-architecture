# Enterprise Azure Hub-and-Spoke Network Architecture

An automated, production-grade Virtual Network (VNet) topology designed for enterprise isolation, centralized security routing, and cross-workload connectivity at ** compute cost**.

## 📌 Architecture Highlights
- **Hub Virtual Network**: Centralized network services anchor with dedicated enterprise subnets (\GatewaySubnet\, \AzureFirewallSubnet\, \AzureBastionSubnet\, \ManagementSubnet\).
- **Spoke Virtual Networks**: Isolated environments for \Workloads-Dev\ and \Workloads-Prod\.
- **Bidirectional VNet Peering**: Low-latency, high-bandwidth interconnects configured with \AllowForwardedTraffic\.
- **User-Defined Routes (UDRs)**: Custom Route Tables forcing inter-spoke and egress traffic through the Hub virtual appliance, demonstrating non-transitive routing.
- **Network Security Groups (NSGs) & ASGs**: Subnet-level and application-level micro-segmentation.
- **Private DNS Resolution**: Centralized private zone (\corp.internal\) with auto-registration.

## 📂 Repository Layout
\\\	ext
├── modules/
│   ├── hub/          # Core Hub VNet and infrastructure subnets (Bicep)
│   ├── spokes/       # Dev and Prod spoke VNets (Bicep)
│   ├── peering/      # Bidirectional VNet peering configuration (Bicep)
│   └── nsg-udr/      # Security rules and routing tables (Bicep/JSON)
├── tests/            # Automated connectivity and routing verification
└── docs/             # AZ-104 networking cheat-sheets and architecture diagrams
\\\
"@ | Out-File -FilePath README.md -Encoding utf8
@"
param location string = 'centralindia'
param hubVNetName string = 'vnet-hub-core'
param hubVNetPrefix string = '10.0.0.0/16'

// Dedicated Subnet Prefixes
param gatewaySubnetPrefix string = '10.0.0.0/24'
param firewallSubnetPrefix string = '10.0.1.0/24'
param bastionSubnetPrefix string = '10.0.2.0/24'
param mgmtSubnetPrefix string = '10.0.3.0/24'

resource hubVNet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: hubVNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        hubVNetPrefix
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet' // Strict name required for VPN/ExpressRoute
        properties: {
          addressPrefix: gatewaySubnetPrefix
        }
      }
      {
        name: 'AzureFirewallSubnet' // Strict name required for Azure Firewall (min /26)
        properties: {
          addressPrefix: firewallSubnetPrefix
        }
      }
      {
        name: 'AzureBastionSubnet' // Strict name required for Azure Bastion (min /26)
        properties: {
          addressPrefix: bastionSubnetPrefix
        }
      }
      {
        name: 'snet-hub-mgmt' // Shared management and jumpbox subnet
        properties: {
          addressPrefix: mgmtSubnetPrefix
        }
      }
    ]
  }
}

output hubVNetId string = hubVNet.id
output hubVNetName string = hubVNet.name
