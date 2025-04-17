// ==========================================================
// Web Connections Module
// This module creates Microsoft.Web/connections resources for Azure Blob connections.
// It accepts an array of connection names and deploys a connection for each.
// ==========================================================

@description('Array of connection names for Azure Blob connections.')
param connectionNames array

@description('Location for the connections (defaults to eastus).')
param location string = 'eastus'

@secure()
@description('Azure Blob storage key for storage account databphc1uat. This value should come from the GitHub secret DATABPHC1UAT_STORAGE_KEY.')
param DATABPHC1UAT_STORAGE_KEY string

@description('Storage account ID for the connection.')
param storageid string = 'databphc1uat'

// ----------------------------------------------------------
// Create a connection resource for each provided connection name
// ----------------------------------------------------------
resource webConnections 'Microsoft.Web/connections@2016-06-01' = [for name in connectionNames: {
  name: name
  location: toLower(location) // Ensure location is in lowercase
  properties: {
    displayName: name
    api: {
      // API ID for Azure Blob
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${toLower(location)}/managedApis/azureblob'
    }
    parameterValues: {
      authentication: {
        type: 'Key'
        storageId: storageid
        key: DATABPHC1UAT_STORAGE_KEY
      }
    }
  }
}]

// ----------------------------------------------------------
// Output the IDs of the created web connections
// ----------------------------------------------------------
@description('Array of resource IDs for the created web connections.')
output connectionIds array = [for name in connectionNames: resourceId('Microsoft.Web/connections', name)]
