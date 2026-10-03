param location string = 'centralindia'

// 1. Application Security Groups (Zero Cost)
resource webASG 'Microsoft.Network/applicationSecurityGroups@2023-09-01' = {
  name: 'asg-web-servers'
  location: location
}

resource dbASG 'Microsoft.Network/applicationSecurityGroups@2023-09-01' = {
  name: 'asg-db-servers'
  location: location
}

// 2. Network Security Group for Workloads
resource workloadNSG 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: 'nsg-spoke-workloads'
  location: location
  properties: {
    securityRules: [
      {
        name: 'Allow-HTTPS-Inbound'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: 'Internet'
          destinationApplicationSecurityGroups: [
            {
              id: webASG.id
            }
          ]
        }
      }
      {
        name: 'Allow-Web-to-Database'
        properties: {
          priority: 200
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '1433' // SQL Server port
          sourceApplicationSecurityGroups: [
            {
              id: webASG.id
            }
          ]
          destinationApplicationSecurityGroups: [
            {
              id: dbASG.id
            }
          ]
        }
      }
      {
        name: 'Deny-All-Other-Subnet-Traffic'
        properties: {
          priority: 4000
          direction: 'Inbound'
          access: 'Deny'
          protocol: '*'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

// 3. User-Defined Route Table (UDR) forcing traffic through Central Hub Firewall
resource spokeRouteTable 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-spoke-to-hub'
  location: location
  properties: {
    routes: [
      {
        name: 'Route-To-Spoke2-Via-Hub'
        properties: {
          addressPrefix: '10.2.0.0/16' // Destination: Spoke 2
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.1.4' // Hub Firewall / NVA IP
        }
      }
      {
        name: 'Route-All-Internet-Via-Hub'
        properties: {
          addressPrefix: '0.0.0.0/0' // Force all outbound egress to Hub
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: '10.0.1.4'
        }
      }
    ]
  }
}

output nsgId string = workloadNSG.id
output routeTableId string = spokeRouteTable.id
