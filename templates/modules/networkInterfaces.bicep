// ==========================================================
// Network Interfaces Module
// This module creates a network interface for the specified VM.
// ==========================================================

@description('Name for the network interface (e.g., vm2)') 
param networkInterfaceName string

@description('Subnet resource ID for the NIC')
param subnetId string

@description('Location for the NIC. Defaulting to eastus to match the VNet region.')
param location string = 'eastus'

@description('Network Security Group (NSG) to associate with the NIC (Optional)')
param networkSecurityGroupId string = ''

@description('Public IP address resource ID to associate with the NIC (Optional)')
param publicIpId string = ''

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
          privateIPAllocationMethod: 'Dynamic' // Dynamic IP allocation
          publicIPAddress: publicIpId != '' ? {
            id: publicIpId
          } : null  // Conditionally associate Public IP if provided
        }
      }
    ]
    // Associate NSG if provided
    networkSecurityGroup: networkSecurityGroupId != '' ? {
      id: networkSecurityGroupId
    } : null
  }
}

// ----------------------------------------------------------
// Output the NIC ID
// ----------------------------------------------------------
output networkInterfaceId string = nic.id
