// ==========================================================
// Network Interfaces Module
// This module creates a network interface for the specified VM.
// ==========================================================

@description('Environment name (e.g. dev, uat, prod)')
param env string

@description('Name for the network interface (e.g., test-vm)') 
param networkInterfaceName string

@description('Subnet resource ID for the NIC')
param subnetId string

@description('Location for the NIC. Defaulting to eastus to match the VNet region.')
param location string = 'eastus'

// Compose network interface name based on environment
var nicName = '${env}-${networkInterfaceName}'

// ----------------------------------------------------------
// Create the Network Interface
// ----------------------------------------------------------
resource nic 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: nicName
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: subnetId
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// ----------------------------------------------------------
// Output the NIC ID
// ----------------------------------------------------------
output networkInterfaceId string = nic.id
