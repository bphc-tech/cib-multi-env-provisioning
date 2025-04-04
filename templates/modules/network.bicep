// ==========================================================
// Extended Networking Module for Factory Resources
// This module creates networking resources for the environment.
// ==========================================================

// ----------------------------------------------------------
// Parameters
// ----------------------------------------------------------
@description('Azure blob connection name 1')
param connections_azureblob_1_name string
@description('Azure blob connection name 2')
param connections_azureblob_2_name string
@description('Azure blob connection name 3')
param connections_azureblob_3_name string
@description('Azure blob connection name 4')
param connections_azureblob_4_name string
@description('Azure blob connection name 5')
param connections_azureblob_5_name string
@description('Action group name for email alerts')
param actionGroups_Email_Alicia_name string
@description('VPN connection name')
param connections_PA_VPN_name string
@description('Name for the network interface')
param networkInterfaces_vm2_name string
@description('Storage Account names')
param storageAccounts_devdatabphc_name string
param storageAccounts_testnetwork93cd_name string
@description('Local Network Gateway name')
param localNetworkGateways_LocalNetworkGateway_name string
@description('Route Table name')
param routeTables_RouteTable_name string
@description('Virtual Network name')
param virtualNetworks_Network_name string
@description('Public IP name')
param publicIPAddresses_GatewayIP_name string
@description('Metric alert names')
param metricAlerts_EmailOnADFActionFailure_name string
param metricAlerts_EmailOnADFPipelineFailure_name string
@description('Private DNS Zone names')
param privateDnsZones_privatelink_dfs_core_windows_net_name string
param privateDnsZones_privatelink_blob_core_windows_net_name string
param privateDnsZones_privatelink_datafactory_azure_net_name string
@description('Private Endpoint names')
param privateEndpoints_dmiprojectsstorage_private_endpoint_name string
param privateEndpoints_dmi_projects_factory_private_endpoint_name string
@description('Virtual Network Gateway name')
param virtualNetworkGateways_VirtualNetworkGateway1_name string
@description('External IDs')
param factories_data_modernization_externalid string
param factories_dmi_projects_factory_externalid string
param storageAccounts_dmiprojectsstorage_externalid string
param virtualNetworks_Prod_VirtualNetwork_externalid string

// ==========================================================
// Resources
// ==========================================================

resource actionGroup 'Microsoft.Insights/actionGroups@2023-09-01-preview' = {
  name: actionGroups_Email_Alicia_name
  location: 'Global'
  properties: {
    groupShortName: actionGroups_Email_Alicia_name
    enabled: true
    emailReceivers: [
      {
        name: 'Email0_-EmailAction-'
        emailAddress: 'AMarkoe@bphc.org'
        useCommonAlertSchema: true
      }
    ]
  }
}

resource localNG 'Microsoft.Network/localNetworkGateways@2024-03-01' = {
  name: localNetworkGateways_LocalNetworkGateway_name
  location: 'eastus'
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: [
        '10.68.0.0/16'
        '10.75.0.0/16'
      ]
    }
    gatewayIpAddress: '140.241.253.162'
  }
}

resource dnsBlob 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_blob_core_windows_net_name
  location: 'global'
  properties: {}
}

resource dnsDataFactory 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_datafactory_azure_net_name
  location: 'global'
  properties: {}
}

resource dnsDFS 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_dfs_core_windows_net_name
  location: 'global'
  properties: {}
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  name: publicIPAddresses_GatewayIP_name
  location: 'eastus'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '4.246.194.241'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource routeTable 'Microsoft.Network/routeTables@2024-03-01' = {
  name: routeTables_RouteTable_name
  location: 'eastus'
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

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: virtualNetworks_Network_name
  location: 'eastus'
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

resource virtualNetworkGateway 'Microsoft.Network/virtualNetworkGateways@2020-11-01' = {
  name: virtualNetworkGateways_VirtualNetworkGateway1_name
  location: 'eastus'
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
