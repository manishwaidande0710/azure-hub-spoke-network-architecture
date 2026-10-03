param location string = 'centralindia'

// Spoke 1: Development VNet
param devVNetName string = 'vnet-spoke-dev'
param devVNetPrefix string = '10.1.0.0/16'
param devFrontendSubnetPrefix string = '10.1.1.0/24'
param devBackendSubnetPrefix string = '10.1.2.0/24'

// Spoke 2: Production VNet
param prodVNetName string = 'vnet-spoke-prod'
param prodVNetPrefix string = '10.2.0.0/16'
param prodAppSubnetPrefix string = '10.2.1.0/24'
param prodDbSubnetPrefix string = '10.2.2.0/24'

// 1. Deploy Spoke Dev VNet
resource devVNet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: devVNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        devVNetPrefix
      ]
    }
    subnets: [
      {
        name: 'snet-dev-frontend'
        properties: {
          addressPrefix: devFrontendSubnetPrefix
        }
      }
      {
        name: 'snet-dev-backend'
        properties: {
          addressPrefix: devBackendSubnetPrefix
        }
      }
    ]
  }
}

// 2. Deploy Spoke Prod VNet
resource prodVNet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: prodVNetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        prodVNetPrefix
      ]
    }
    subnets: [
      {
        name: 'snet-prod-app'
        properties: {
          addressPrefix: prodAppSubnetPrefix
        }
      }
      {
        name: 'snet-prod-db'
        properties: {
          addressPrefix: prodDbSubnetPrefix
        }
      }
    ]
  }
}

output devVNetId string = devVNet.id
output prodVNetId string = prodVNet.id
