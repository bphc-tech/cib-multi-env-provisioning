// =============================
// Parameters
// =============================
param connections_azureblob_1_name string = 'azureblob-1'
param connections_azureblob_2_name string = 'azureblob-2'
param connections_azureblob_3_name string = 'azureblob-3'
param connections_azureblob_4_name string = 'azureblob-4'
param connections_azureblob_5_name string = 'azureblob-5'
param actionGroups_Email_Alicia_name string = 'Email_Alicia'
param connections_PA_DevTest_VPN_name string = 'PA-DevTest-VPN'
param networkInterfaces_test_vm2_name string = 'test-vm2'
param storageAccounts_devdatabphc_name string = 'devdatabphc'
param routeTables_DevTest_RouteTable_name string = 'DevTest-RouteTable'
param virtualNetworks_DevTest_Network_name string = 'DevTest-Network'
param serverfarms_ASP_DevTestNetwork_b27f_name string = 'ASP-DevTestNetwork-b27f'
param storageAccounts_devtestnetwork93cd_name string = 'devtestnetwork93cd'
param sites_SharePointDataExtractionFunction_name string = 'SharePointDataExtractionFunction'
param publicIPAddresses_DevTest_GatewayIP_name string = 'DevTest-GatewayIP'
param metricAlerts_EmailOnADFActionFailure_name string = 'EmailOnADFActionFailure'
param metricAlerts_EmailOnADFPipelineFailure_name string = 'EmailOnADFPipelineFailure'
param localNetworkGateways_DevTest_LocalNetworkGateway_name string = 'DevTest-LocalNetworkGateway'
param privateDnsZones_privatelink_dfs_core_windows_net_name string = 'privatelink.dfs.core.windows.net'
param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net'
param privateDnsZones_privatelink_datafactory_azure_net_name string = 'privatelink.datafactory.azure.net'
param privateEndpoints_dmiprojectsstorage_private_endpoint_name string = 'dmiprojectsstorage-private-endpoint'
param virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name string = 'DevTest-VirtualNetworkGateway1'
param privateEndpoints_dmi_projects_factory_private_endpoint_name string = 'dmi-projects-factory-private-endpoint'
param factories_data_modernization_externalid string = '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.DataFactory/factories/data-modernization'
param factories_dmi_projects_factory_externalid string = '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.DataFactory/factories/dmi-projects-factory'
param storageAccounts_dmiprojectsstorage_externalid string = '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.Storage/storageAccounts/dmiprojectsstorage'
param virtualNetworks_Prod_VirtualNetwork_externalid string = '/subscriptions/2b7c117e-2dba-4c4a-9cd0-e1f0dfe74b03/resourceGroups/Prod-Network/providers/Microsoft.Network/virtualNetworks/Prod-VirtualNetwork'

// =============================
// Resources
// =============================

// Action Group for email alerts
resource actionGroup 'microsoft.insights/actionGroups@2023-09-01-preview' = {
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
    smsReceivers: []
    webhookReceivers: []
    eventHubReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
    armRoleReceivers: []
  }
}

// Local Network Gateway
resource localNG 'Microsoft.Network/localNetworkGateways@2024-03-01' = {
  name: localNetworkGateways_DevTest_LocalNetworkGateway_name
  location: 'eastus'
  properties: {
    localNetworkAddressSpace: {
      addressPrefixes: ['10.68.0.0/16', '10.75.0.0/16']
    }
    gatewayIpAddress: '140.241.253.162'
  }
}

// Private DNS Zones
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

// Public IP for Virtual Network Gateway
resource publicIP 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
  name: publicIPAddresses_DevTest_GatewayIP_name
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
    ipTags: []
  }
}

// Route Table with a single route
resource routeTable 'Microsoft.Network/routeTables@2024-03-01' = {
  name: routeTables_DevTest_RouteTable_name
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

// Note: Continue adding other resource definitions as needed.
// You can reference parameters using resourceId() and format your arrays inline (with commas only between items, no extra newline characters).
// This module is now prepared to be referenced from your main template via the "module" keyword.

