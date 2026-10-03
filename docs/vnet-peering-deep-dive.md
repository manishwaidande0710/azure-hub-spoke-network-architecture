# Azure Virtual Network Peering Deep-Dive (AZ-104)

## 1. Core Peering Characteristics
- Uses Microsoft’s private backbone network; traffic does **not** cross the public internet.
- Subnets across peered networks communicate using private IP addresses.
- **Address Space Constraint**: IP address prefixes must **not** overlap.

---

## 2. Peering Status Lifecycle
| State | Condition |
| :--- | :--- |
| **Initiated** | Peering has been created in one direction only. Traffic is blocked. |
| **Connected** | Peering has been configured in both directions. Traffic flows. |
| **Disconnected** | One side was deleted or modified. |

---

## 3. The Non-Transitive Routing Rule
\\\	ext
[Spoke 1 (Dev)] <==== Peering ====> [Hub VNet] <==== Peering ====> [Spoke 2 (Prod)]
       |                                                                  |
       X---------------- Cannot Communicate Directly --------------------X
\\\
- VNet Peering does **not** support transitive routing.
- Spoke 1 cannot send packets to Spoke 2 across the Hub via peering alone.
- **Solution**: Deploy a Network Virtual Appliance (NVA) / Azure Firewall in the Hub, and create **User-Defined Routes (UDRs)** on the Spoke subnets pointing to the NVA IP.

---

## 4. Gateway Transit Settings
- **Allow Gateway Transit**: Enabled on the Hub VNet so spokes can route on-premises traffic through the Hub's VPN/ExpressRoute Gateway.
- **Use Remote Gateways**: Enabled on Spoke VNets to leverage the Hub's gateway. (Cannot be enabled if the spoke already has its own gateway).
