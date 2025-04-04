// ==========================================================
// Web Connections Module
// Creates Microsoft.Web/connections resources for azureblob connections.
// Uses managed identity and secure runtime variables for authentication.
// ==========================================================

@description('Array of connection names for azureblob connections')
param connectionNames array

@description('Location for the connections (defaults to eastus)')
param location string = 'eastus'

@description('Azure Active Directory Tenant ID')
param tenantId string

@description('Client ID of the managed identity or service principal')
param clientId string

@description('Client secret for the service principal (use secure pipeline secret)')
param clientSecret string

// ----------------------------------------------------------
// Create a connection resource for each provided connection name
// ----------------------------------------------------------
resource webConnections 'Microsoft.Web/connections@2021-02-01' = [for name in connectionNames: {
  name: name
  location: location
  properties: {
    displayName: name
    api: {
      id: format('/subscriptions/{0}/providers/Microsoft.Web/locations/{1}/managedApis/azureblob', subscription().subscriptionId, location)
    }
    authentication: {
      type: 'ActiveDirectoryOAuth'
      parameters: {
        clientId: clientId
        clientSecret: clientSecret
        tenantId: tenantId
        audience: 'https://management.azure.com/'
      }
    }
  }
}]

// ----------------------------------------------------------
// Output the IDs of the created web connections
// ----------------------------------------------------------
output connectionIds array = [for name in connectionNames: resourceId('Microsoft.Web/connections', name)]
