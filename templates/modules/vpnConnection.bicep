// ==========================================================
// VPN Connection Module
// This module creates a VPN connection between two virtual networks or between on-premises and Azure.
// ==========================================================

@description('Name of the VPN connection')
param vpnConnectionName string

@description('Resource ID of the local network gateway or remote gateway')
param gatewayId string

@description('The connection type (e.g., IPsec, ExpressRoute, etc.)')
param connectionType string = 'IPsec'

@description('The routing weight for the VPN connection')
param routingWeight int = 10

@description('Enable or disable the BGP setting for the VPN connection')
param enableBgp bool = false

@description('Shared key for the VPN connection')
param sharedKey string

@description('Location for the VPN connection. Defaulting to eastus.')
param location string = 'eastus'

// ----------------------------------------------------------
// Create the VPN connection resource
// ----------------------------------------------------------
resource vpnConnection 'Microsoft.Network/connections@2021-03-01' = {
  name: vpnConnectionName
  location: location
  properties: {
    connectionType: connectionType
    routingWeight: routingWeight
    enableBgp: enableBgp
    sharedKey: sharedKey
    peer: {
      id: gatewayId
    }
  }
}

// ----------------------------------------------------------
// Output the VPN connection ID
// ----------------------------------------------------------
output vpnConnectionId string = vpnConnection.id
