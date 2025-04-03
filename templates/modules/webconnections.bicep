// ==========================================================
// Web Connections Module
// This module creates Microsoft.Web/connections resources for azureblob connections.
// It accepts an array of connection names and deploys a connection for each.
// ==========================================================

@description('Array of connection names for azureblob connections')
param connectionNames array

@description('Location for the connections (defaults to eastus)')
param location string = 'eastus'

// ----------------------------------------------------------
// Create a connection resource for each provided connection name
// ----------------------------------------------------------
resource webConnections 'Microsoft.Web/connections@2021-02-01' = [for name in connectionNames: {
  name: name
  location: location
  properties: {
    // Define connection-specific properties here.
    displayName: name
    api: {
      id: '/subscriptions/{subscriptionId}/providers/Microsoft.Web/locations/{location}/managedApis/azureblob'
    }
    authentication: {
      type: 'ActiveDirectoryOAuth'  // Adjust auth type as needed
      parameters: {
        clientId: 'your-client-id'  // Replace with actual client ID
        clientSecret: 'your-client-secret'  // Replace with actual secret
        tenant: 'your-tenant-id'  // Replace with actual tenant ID
      }
    }
  }
}]

// ----------------------------------------------------------
// Output the IDs of the created web connections
// ----------------------------------------------------------
output connectionIds array = [for name in connectionNames: resourceId('Microsoft.Web/connections', name)]
