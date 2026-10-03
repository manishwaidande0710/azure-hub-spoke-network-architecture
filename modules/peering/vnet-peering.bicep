param hubVNetName string = 'vnet-hub-core'
param devVNetName string = 'vnet-spoke-dev'
param prodVNetName string = 'vnet-spoke-prod'

// Reference Existing VNets
resource hubVNet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: hubVNetName
}

resource devVNet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: devVNetName
}

resource prodVNet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: prodVNetName
}

// 1. Hub -> Spoke Dev Peering
resource hubToDevPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: hubVNet
  name: 'peer-hub-to-dev'
  properties: {
    remoteVirtualNetwork: {
      id: devVNet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

// 2. Spoke Dev -> Hub Peering
resource devToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: devVNet
  name: 'peer-dev-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVNet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

// 3. Hub -> Spoke Prod Peering
resource hubToProdPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: hubVNet
  name: 'peer-hub-to-prod'
  properties: {
    remoteVirtualNetwork: {
      id: prodVNet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}

// 4. Spoke Prod -> Hub Peering
resource prodToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  parent: prodVNet
  name: 'peer-prod-to-hub'
  properties: {
    remoteVirtualNetwork: {
      id: hubVNet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
  }
}
