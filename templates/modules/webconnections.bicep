// ==========================================================
// Web Connections Module
// This module creates Microsoft.Web/connections resources for azureblob connections.
// It accepts an array of connection names and deploys a connection for each.
// ==========================================================

@description('Array of connection names for azureblob connections')
param connectionNames array

@description('Location for the connections (defaults to eastus)')
param location string = 'eastus'

@description('Client ID for authentication')
param clientId string

@description('Client Secret for authentication')
@secure()
param clientSecret string

@description('Tenant ID for authentication')
param tenantId string

// ----------------------------------------------------------
// Create a connection resource for each provided connection name
// Use an API version that is supported
// ----------------------------------------------------------
resource webConnections 'Microsoft.Web/connections@2016-06-01' = [for name in connectionNames: {
  name: name
  location: location
  properties: {
    displayName: name
    api: {
      id: resourceId('Microsoft.Web/locations/managedApis', location, 'azureblob')
    }
    parameterValues: {
      authentication: {
        type: 'ActiveDirectoryOAuth'
        clientId: clientId
        clientSecret: clientSecret
        tenantId: tenantId
      }
    }
  }
}]

// ----------------------------------------------------------
// Output the IDs of the created web connections
// ----------------------------------------------------------
output connectionIds array = [for name in connectionNames: {
  resourceId: resourceId('Microsoft.Web/connections', name)
}]
