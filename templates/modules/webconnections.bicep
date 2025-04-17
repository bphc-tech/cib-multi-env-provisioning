// ==========================================================
// Web Connections Module
// This module creates Microsoft.Web/connections resources for Azure Blob connections.
// It accepts an array of connection names and deploys a connection for each.
// ==========================================================

@description('Array of connection names for Azure Blob connections.')
param connectionNames array

@description('Location for the connections (defaults to eastus).')
param location string = 'eastus'

@description('Azure Active Directory Client ID for authentication.')
param clientId string

@description('Azure Active Directory Client Secret for authentication (secure).')
@secure()
param clientSecret string

@description('Azure Active Directory Tenant ID for authentication.')
param tenantId string

// ----------------------------------------------------------
// Create a connection resource for each provided connection name
// ----------------------------------------------------------
resource webConnections 'Microsoft.Web/connections@2016-06-01' = [for name in connectionNames: {
  name: name
  location: toLower(location) // Ensure location is in lowercase
  properties: {
    displayName: name
    api: {
      // Correct API ID for Azure Blob
      id: '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${toLower(location)}/managedApis/azureblob'
    }
    parameterValues: {
      authentication: {
        type: 'ActiveDirectoryOAuth'
        clientId: clientId
        secret: clientSecret
        tenant: tenantId
        audience: 'https://storage.azure.com/'
      }
    }
  }
}]

// ----------------------------------------------------------
// Output the IDs of the created web connections
// ----------------------------------------------------------
@description('Array of resource IDs for the created web connections.')
output connectionIds array = [for name in connectionNames: {
  resourceId: resourceId('Microsoft.Web/connections', name)
}]
