targetScope = 'resourceGroup'

param location string = 'centralindia'

// 1. Hub Network Module
module hub './modules/hub/hub-network.bicep' = {
  name: 'deploy-hub-network'
  params: {
    location: location
    hubVNetName: 'vnet-hub-core'
    hubVNetPrefix: '10.0.0.0/16'
  }
}

// 2. Spokes Network Module
module spokes './modules/spokes/spokes-networks.bicep' = {
  name: 'deploy-spokes-networks'
  params: {
    location: location
    devVNetName: 'vnet-spoke-dev'
    devVNetPrefix: '10.1.0.0/16'
    prodVNetName: 'vnet-spoke-prod'
    prodVNetPrefix: '10.2.0.0/16'
  }
}

// 3. Security and User-Defined Routing Module
module securityRouting './modules/nsg-udr/security-and-routing.bicep' = {
  name: 'deploy-security-and-routing'
  params: {
    location: location
  }
}

// 4. Bidirectional VNet Peering Module (Depends on Hub and Spokes)
module peering './modules/peering/vnet-peering.bicep' = {
  name: 'deploy-vnet-peering'
  params: {
    hubVNetName: 'vnet-hub-core'
    devVNetName: 'vnet-spoke-dev'
    prodVNetName: 'vnet-spoke-prod'
  }
  dependsOn: [
    hub
    spokes
  ]
}

output hubId string = hub.outputs.hubVNetId
output devId string = spokes.outputs.devVNetId
output prodId string = spokes.outputs.prodVNetId
