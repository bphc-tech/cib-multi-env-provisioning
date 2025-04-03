// ==========================================================
// Public IP Addresses Module
// This module creates public IP addresses for the VPN gateway.
// ==========================================================

@description('Environment name (e.g. dev, uat, prod)')
param env string

@description('Name for the public IP address (e.g., gateway-ip)')
param publicIPName string

@description('Location for the public IP address. Defaulting to eastus.')
param location string = 'eastus'

var publicIpName = '${env}-${publicIPName}'

// ----------------------------------------------------------
// Create the Public IP Address
// ----------------------------------------------------------
resource publicIp 'Microsoft.Network/publicIPAddresses@2021-03-01' = {
  name: publicIpName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// ----------------------------------------------------------
// Output the Public IP Address ID
// ----------------------------------------------------------
output publicIpId string = publicIp.id
