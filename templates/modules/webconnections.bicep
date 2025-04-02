// ==========================================================
// Web Connections Module
// This module creates Microsoft.Web/connections resources for azureblob connections.
// It accepts an array of connection names and deploys a connection for each.
// ==========================================================

@description('Array of connection names for azureblob connections (e.g., [\'azureblob-1\', \'azureblob-2\', ...])')
param connectionNames array

@description('Location for the connections. Defaulting to eastus for the 2021-02-01 API version.')
param location string = 'eastus'

// ----------------------------------------------------------
// Create a connection resource for each provided connection name
// ----------------------------------------------------------
resource webConnections 'Microsoft.Web/connections@2021-02-01' = [for name in connectionNames: {
  name: name
  location: location
  properties: {
    // Define connection-specific properties here.
    // Example: Basic properties for Azure Blob connection:
    displayName: name
    api: {
      id: '/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/managedApis/azureblob'
    }
    authentication: {
      type: 'ActiveDirectoryOAuth'  // Example auth type, adjust based on needs
      parameters: {
        clientId: 'your-client-id'  // Example client ID, replace as needed
        clientSecret: 'your-client-secret'  // Example secret, replace as needed
        tenant: 'your-tenant-id'  // Example tenant ID, replace as needed
      }
    }
  }
}]

// ----------------------------------------------------------
// Output the IDs of the created web connections by computing each resource ID
// ----------------------------------------------------------
output connectionIds array = [for name in connectionNames: resourceId('Microsoft.Web/connections', name)]
