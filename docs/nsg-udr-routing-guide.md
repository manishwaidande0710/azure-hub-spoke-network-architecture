# NSG, ASG, and User-Defined Routing (UDR) Guide (AZ-104)

## 1. Network Security Group (NSG) Mechanics
- **Stateful**: If an inbound packet is allowed, return traffic is automatically permitted regardless of outbound rules.
- **Priority**: Evaluated from 100 to 4096 (lower numbers take precedence).

### Default Built-in Rules (Cannot be deleted, only overridden):
| Inbound Default Rules | Outbound Default Rules |
| :--- | :--- |
| 65000: \AllowVNetInBound\ | 65000: \AllowVNetOutBound\ |
| 65001: \AllowAzureLoadBalancerInBound\ | 65001: \AllowInternetOutBound\ |
| 65500: \DenyAllInBound\ | 65500: \DenyAllOutBound\ |

---

## 2. Inbound vs. Outbound Evaluation Order
\\\	ext
INBOUND TRAFFIC:
Traffic -> [Subnet NSG] (Evaluated 1st) -> [NIC NSG] (Evaluated 2nd) -> VM

OUTBOUND TRAFFIC:
VM -> [NIC NSG] (Evaluated 1st) -> [Subnet NSG] (Evaluated 2nd) -> Destination
\\\

---

## 3. Application Security Groups (ASGs)
- Used as source or destination in NSG rules.
- Eliminates hardcoded private IP addresses in security rules.
- **Exam Rule**: All network interfaces assigned to an ASG must belong to the **same Virtual Network**.

---

## 4. User-Defined Routes (UDR) Next Hop Types
| Next Hop Type | Usage Scenario |
| :--- | :--- |
| **VirtualAppliance** | Routes packets to a Firewall, Router, or Proxy private IP (e.g. \10.0.1.4\). |
| **VirtualNetworkGateway** | Routes packets through a VPN Gateway or ExpressRoute. |
| **Internet** | Routes packets directly to the public internet. |
| **None** | Drops/blackholes the traffic. |
