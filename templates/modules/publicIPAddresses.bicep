// ==========================================================
// Public IP Addresses Module
// This module creates a public IP address for the VPN gateway.
// ==========================================================

@description('Name for the public IP address (e.g., gateway-ip).')
param publicIPAddresses_GatewayIP_name string

@description('Location for the public IP address. Defaults to eastus.')
param location string = 'eastus'

// ----------------------------------------------------------
// Create the Public IP Address
// ----------------------------------------------------------
resource publicIp 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIPAddresses_GatewayIP_name
  location: location
  sku: {
    name: 'Standard'  // Standard SKU for better performance and availability
    tier: 'Regional'  // Regional tier for the public IP
  }
  properties: {
    publicIPAllocationMethod: 'Static'  // Static allocation for consistent IP address
  }
}

// ----------------------------------------------------------
// Output the Public IP Address ID
// ----------------------------------------------------------
@description('The resource ID of the created public IP address.')
output publicIpId string = publicIp.id
