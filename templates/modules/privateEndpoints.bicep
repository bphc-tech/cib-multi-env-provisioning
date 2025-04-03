// ==========================================================
// Private Endpoints Module
// This module creates private endpoints for the factory and storage resources.
// IMPORTANT: Replace the placeholder values for 'subnetId', 'targetResourceId1', and 'targetResourceId2'
// with the actual values from your environment.
// ==========================================================

@description('Name for the first private endpoint')
param privateEndpoint1Name string

@description('Name for the second private endpoint')
param privateEndpoint2Name string

@description('Subnet ID for the private endpoints')
param subnetId string

@description('Target resource ID for the first private endpoint (for factory)')
param targetResourceId1 string

@description('Target resource ID for the second private endpoint (for storage)')
param targetResourceId2 string

@description('Location for the private endpoints. Defaulting to eastus to match the VNet region.')
param location string = 'eastus'

// ----------------------------------------------------------
// Create private endpoint for the factory resource
// ----------------------------------------------------------
resource privateEndpoint1 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: privateEndpoint1Name
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${privateEndpoint1Name}-plsc'
        properties: {
          privateLinkServiceId: targetResourceId1
          groupIds: [
            'default'
          ]
        }
      }
    ]
  }
}

// ----------------------------------------------------------
// Create private endpoint for the storage resource
// ----------------------------------------------------------
resource privateEndpoint2 'Microsoft.Network/privateEndpoints@2021-03-01' = {
  name: privateEndpoint2Name
  location: location
  properties: {
    subnet: {
      id: subnetId
    }
    privateLinkServiceConnections: [
      {
        name: '${privateEndpoint2Name}-plsc'
        properties: {
          privateLinkServiceId: targetResourceId2
          groupIds: [
            'blob'
          ]
        }
      }
    ]
  }
}

// ----------------------------------------------------------
// Output the IDs of the created private endpoints
// ----------------------------------------------------------
output privateEndpoint1Id string = privateEndpoint1.id
output privateEndpoint2Id string = privateEndpoint2.id
