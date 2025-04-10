// ==========================================================
// Private Endpoints Module
// This module creates private endpoints for the factory and storage resources.
// It ensures secure connectivity to Azure services via private links.
// ==========================================================

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
            'default'  // Ensure 'default' is correct for the service you're using (e.g., Azure Data Factory).
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
            'blob'  // Ensure 'blob' is correct for the storage service you're connecting to (e.g., Azure Blob Storage).
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
