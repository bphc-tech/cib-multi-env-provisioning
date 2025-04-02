// ==========================================================
// Network Interfaces Module (Optional)
// This module creates a network interface, for example for test-vm2.
// ==========================================================

@description('Name for the network interface (e.g., test-vm2)')
param networkInterfaceName string

@description('Subnet resource ID for the NIC')
param subnetId string

@description('Location for the NIC. Defaulting to eastus to match the VNet region.')
param location string = 'eastus'

// ----------------------------------------------------------
// Create the Network Interface
// ----------------------------------------------------------
resource nic 'Microsoft.Network/networkInterfaces@2021-08-01' = {
  name: networkInterfaceName
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
