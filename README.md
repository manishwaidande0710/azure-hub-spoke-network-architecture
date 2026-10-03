# Enterprise Azure Hub-and-Spoke Network Architecture

An automated, Infrastructure-as-Code (IaC) Virtual Network topology designed for enterprise workload isolation, centralized security routing, and cross-spoke communication at **$0 compute cost**.

## 📌 Architecture Topology
\\\	ext
                           ┌──────────────────────────────┐
                           │      HUB VNET (10.0.0.0/16)  │
                           │  - GatewaySubnet             │
                           │  - AzureFirewallSubnet       │
                           │  - AzureBastionSubnet        │
                           │  - snet-hub-mgmt             │
                           └──────────────┬───────────────┘
                                          │
                     ┌────────────────────┴────────────────────┐
        VNet Peering │ (AllowForwardedTraffic = true)          │ VNet Peering
                     ▼                                         ▼
  ┌─────────────────────────────┐           ┌─────────────────────────────┐
  │ SPOKE 1: Workloads-Dev      │           │ SPOKE 2: Workloads-Prod     │
  │ Address: 10.1.0.0/16        │           │ Address: 10.2.0.0/16        │
  │ - snet-dev-frontend         │           │ - snet-prod-app             │
  │ - snet-dev-backend          │           │ - snet-prod-db              │
  │ - NSG & ASG Microsegment    │           │ - NSG & ASG Microsegment    │
  │ - UDR: 0.0.0.0/0 -> Hub IP  │           │ - UDR: 0.0.0.0/0 -> Hub IP  │
  └─────────────────────────────┘           └─────────────────────────────┘
\\\

## 🚀 Key Features & AZ-104 Exam Concepts
- **CIDR & Subnet Sizing**: Implements non-overlapping address spaces with full accommodation for Azure's 5 reserved IP addresses per subnet.
- **Dedicated Subnets**: Enforces required naming and sizing standards for \GatewaySubnet\, \AzureFirewallSubnet\ (min /26), and \AzureBastionSubnet\ (min /26).
- **Bidirectional VNet Peering**: Configures cross-network peering with \llowForwardedTraffic\ enabled for NVA routing.
- **Non-Transitive Routing Resolution**: Demonstrates that spokes cannot communicate across peering without a central router/firewall via User-Defined Routes (UDRs).
- **Zero Compute Cost**: Operates entirely at the Azure network control plane without provisioned billable instances.

## 📂 Repository Structure
\\\	ext
├── main.bicep                 # Master deployment orchestrator
├── modules/
│   ├── hub/                   # Hub VNet and infrastructure subnets
│   │   └── hub-network.bicep
│   ├── spokes/                # Development and Production spoke VNets
│   │   └── spokes-networks.bicep
│   ├── peering/               # Bidirectional VNet peering configuration
│   │   └── vnet-peering.bicep
│   └── nsg-udr/               # NSGs, ASGs, and custom Route Tables
│       └── security-and-routing.bicep
├── tests/
│   └── validate-network.ps1   # Automated network compliance validation suite
└── docs/
    ├── vnet-architecture.md   # IP allocation scheme and subnet sizing
    ├── vnet-peering-deep-dive.md # Peering lifecycle and non-transitive rules
    └── nsg-udr-routing-guide.md  # NSG evaluation order and UDR next-hops
\\\

## 🛠️ Deployment Instructions
Deploy the entire topology to your resource group using Azure CLI:
\\\ash
az deployment group create \
  --resource-group rg-governance-lab \
  --template-file main.bicep
\\\
"@ | Out-File -FilePath README.md -Encoding utf8
git add .
git commit -m "feat(network): add master Bicep orchestrator, test suite, and comprehensive README"
git push origin main
