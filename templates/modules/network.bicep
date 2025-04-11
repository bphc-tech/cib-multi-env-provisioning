// ==========================================================
// Extended Networking Module for Factory Resources
// This module creates networking resources for the environment.
// Revised to support secret-based VPN shared key and ensure modularity.
// ==========================================================

// -----------------------------
// Parameters
// -----------------------------
@description('Location for the resources.')
param location string

@description('Name of the first Azure Blob connection')
param connections_azureblob_1_name string

@description('Name of the second Azure Blob connection')
param connections_azureblob_2_name string

@description('Name of the third Azure Blob connection')
param connections_azureblob_3_name string

@description('Name of the fourth Azure Blob connection')
param connections_azureblob_4_name string

@description('Name of the fifth Azure Blob connection')
param connections_azureblob_5_name string

@description('Name of the action group for email notifications')
param actionGroups_Email_Alicia_name string

@description('Name of the VPN connection')
param connections_PA_VPN_name string

@description('Name of the network interface for VM2')
param networkInterfaces_vm2_name string

@description('Name of the first storage account')
param storageAccounts_devdatabphc_name string

@description('Name of the second storage account')
param storageAccounts_testnetwork93cd_name string

@description('Name of the local network gateway')
param localNetworkGateways_LocalNetworkGateway_name string

@description('Name of the route table')
param routeTables_RouteTable_name string

@description('Name of the virtual network')
param virtualNetworks_Network_name string

@description('Name of the public IP address for the gateway')
param publicIPAddresses_GatewayIP_name string

@description('Name of the metric alert for ADF action failure')
param metricAlerts_EmailOnADFActionFailure_name string

@description('Name of the metric alert for ADF pipeline failure')
param metricAlerts_EmailOnADFPipelineFailure_name string

@description('Name of the private DNS zone for DFS')
param privateDnsZones_privatelink_dfs_core_windows_net_name string

@description('Name of the private DNS zone for Blob storage')
param privateDnsZones_privatelink_blob_core_windows_net_name string

@description('Name of the private DNS zone for Data Factory')
param privateDnsZones_privatelink_datafactory_azure_net_name string

@description('Name of the private endpoint for the storage account')
param privateEndpoints_dmiprojectsstorage_private_endpoint_name string

@description('Name of the private endpoint for the Data Factory')
param privateEndpoints_dmi_projects_factory_private_endpoint_name string

@description('Name of the virtual network gateway')
param virtualNetworkGateways_VirtualNetworkGateway1_name string

@description('External ID for the modernization factory')
param factories_data_modernization_externalid string

@description('External ID for the projects factory')
param factories_dmi_projects_factory_externalid string

@description('External ID for the storage account')
param storageAccounts_dmiprojectsstorage_externalid string

@description('External ID for the production virtual network')
param virtualNetworks_Prod_VirtualNetwork_externalid string

@secure()
@description('Shared key for the VPN connection')
param vpnSharedKey string

// -----------------------------
// Resources
// -----------------------------

// Action Group for email notifications
resource actionGroup 'Microsoft.Insights/actionGroups@2023-09-01-preview' = {
  name: actionGroups_Email_Alicia_name
  location: location // Use the location parameter
  properties: {
    groupShortName: actionGroups_Email_Alicia_name
    enabled: true
    emailReceivers: [
      {
        name: 'EmailReceiver'
        emailAddress: 'AMarkoe@bphc.org'
        useCommonAlertSchema: true
      }
    ]
  }
}

// Local Network Gateway
resource localNG 'Microsoft.Network/localNetworkGateways@2024-03-01' = {
  name: localNetworkGateways_LocalNetworkGateway_name
  location: location // Use the location parameter
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: [
        '10.68.0.0/16', '10.75.0.0/16'
      ]
    }
    gatewayIpAddress: '140.241.253.162'
  }
}

// Private DNS Zones
resource dnsBlob 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_blob_core_windows_net_name
  location: location // Use the location parameter
  properties: {}
}

resource dnsDataFactory 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_datafactory_azure_net_name
  location: location // Use the location parameter
  properties: {}
}

resource dnsDFS 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_dfs_core_windows_net_name
  location: location // Use the location parameter
  properties: {}
}

// Public IP Address for the Gateway
resource publicIP 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  name: publicIPAddresses_GatewayIP_name
  location: location // Use the location parameter
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

// Route Table
resource routeTable 'Microsoft.Network/routeTables@2024-03-01' = {
  name: routeTables_RouteTable_name
  location: location // Use the location parameter
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'AllowAzureTraffic'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
      }
    ]
  }
}

// Virtual Network
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_Network_name
  location: location // Use the location parameter
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.59.40.0/24'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.59.40.128/27'
        }
      }
      {
        name: 'default'
        properties: {
          addressPrefix: '10.59.40.0/25'
        }
      }
    ]
  }
}

// Virtual Network Gateway
resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name: virtualNetworkGateways_VirtualNetworkGateway1_name
  location: location // Use the location parameter
  properties: {
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    ipConfigurations: [
      {
        name: 'default'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_Network_name, 'GatewaySubnet')
          }
          publicIPAddress: {
            id: resourceId('Microsoft.Network/publicIPAddresses', publicIPAddresses_GatewayIP_name)
          }
        }
      }
    ]
  }
}

// VPN Connection
resource vpnConnection 'Microsoft.Network/connections@2020-11-01' = {
  name: connections_PA_VPN_name
  location: location // Using location parameter to avert error in arm template
  properties: {
    connectionType: 'IPSec'
    virtualNetworkGateway1: {
      id: virtualNetworkGateway.id
    }
    localNetworkGateway2: {
      id: localNG.id
    }
    routingWeight: 10
    sharedKey: vpnSharedKey
  }
}
