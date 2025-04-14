@description('Name for the first private endpoint (e.g., for the Data Factory).')
param privateEndpoint1Name string

@description('Name for the second private endpoint (e.g., for the Storage Account).')
param privateEndpoint2Name string

@description('Subnet ID for the private endpoints. This should be the subnet where the private endpoints will be created.')
param subnetId string

@description('Target resource ID for the first private endpoint (e.g., the Data Factory resource ID).')
param targetResourceId1 string

@description('Target resource ID for the second private endpoint (e.g., the Storage Account resource ID).')
param targetResourceId2 string

@description('Location for the private endpoints. Defaults to eastus to match the VNet region.')
param location string = 'eastus'

// ----------------------------------------------------------
// Create private endpoint for the Data Factory resource
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
            'datafactory'  // Correct group ID for Data Factory
          ]
        }
      }
    ]
  }
}

// ----------------------------------------------------------
// Create private endpoint for the Storage Account resource
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
            'blob'  // Correct group ID for Blob Storage
          ]
        }
      }
    ]
  }
}

// ----------------------------------------------------------
// Output the IDs of the created private endpoints
// ----------------------------------------------------------
@description('The resource ID of the first private endpoint (e.g., for the Data Factory).')
output privateEndpoint1Id string = privateEndpoint1.id

@description('The resource ID of the second private endpoint (e.g., for the Storage Account).')
output privateEndpoint2Id string = privateEndpoint2.id
