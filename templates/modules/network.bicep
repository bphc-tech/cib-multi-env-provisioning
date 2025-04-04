// ==========================================================
// Extended Networking Module for Factory Resources
// This module creates networking resources for the environment.
// ==========================================================

// Parameters
param connections_azureblob_1_name string
param connections_azureblob_2_name string
param connections_azureblob_3_name string
param connections_azureblob_4_name string
param connections_azureblob_5_name string
param actionGroups_Email_Alicia_name string
param connections_PA_VPN_name string
param networkInterfaces_vm2_name string
param storageAccounts_devdatabphc_name string
param storageAccounts_testnetwork93cd_name string
param localNetworkGateways_LocalNetworkGateway_name string
param routeTables_RouteTable_name string
param virtualNetworks_Network_name string
param publicIPAddresses_GatewayIP_name string
param metricAlerts_EmailOnADFActionFailure_name string
param metricAlerts_EmailOnADFPipelineFailure_name string
param privateDnsZones_privatelink_dfs_core_windows_net_name string
param privateDnsZones_privatelink_blob_core_windows_net_name string
param privateDnsZones_privatelink_datafactory_azure_net_name string
param privateEndpoints_dmiprojectsstorage_private_endpoint_name string
param privateEndpoints_dmi_projects_factory_private_endpoint_name string
param virtualNetworkGateways_VirtualNetworkGateway1_name string
param factories_data_modernization_externalid string
param factories_dmi_projects_factory_externalid string
param storageAccounts_dmiprojectsstorage_externalid string
param virtualNetworks_Prod_VirtualNetwork_externalid string

// -------- Resources --------

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
        '10.68.0.0/16',  // Added commas between address prefixes
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
        '10.59.40.0/24' // Added comma
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.59.40.128/27'
        }
      },
      {
        name: 'default'
        properties: {
          addressPrefix: '10.59.40.0/25'
        }
      }
    ]
  }
}

var gatewaySubnetId = resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_Network_name, 'GatewaySubnet')
var publicIPId = resourceId('Microsoft.Network/publicIPAddresses', publicIPAddresses_GatewayIP_name)

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
            id: gatewaySubnetId
          }
          publicIPAddress: {
            id: publicIPId
          }
        }
      }
    ]
  }
}
