// ==========================================================
// Updated UAT Deployment Template for Factory Resources
// ==========================================================

@description('Factory name parameter (set this to a UAT value, e.g. "data-modernization-uat")')
param factoryName string

// -----------------------------
// Network Module Parameters (inherited from DevTest)
// -----------------------------
param connections_azureblob_1_name string = 'azureblob-1'
param connections_azureblob_2_name string = 'azureblob-2'
param connections_azureblob_3_name string = 'azureblob-3'
param connections_azureblob_4_name string = 'azureblob-4'
param connections_azureblob_5_name string = 'azureblob-5'
param actionGroups_Email_Alicia_name string = 'Email_Alicia'
param connections_PA_DevTest_VPN_name string = 'PA-UAT-VPN'
param networkInterfaces_test_vm2_name string = 'uat-vm2'
param storageAccounts_devdatabphc_name string = 'uatdatabphc'
param routeTables_DevTest_RouteTable_name string = 'UAT-RouteTable'
param virtualNetworks_DevTest_Network_name string = 'UAT-VNet'
param serverfarms_ASP_DevTestNetwork_b27f_name string = 'ASP-UATNetwork'
param storageAccounts_devtestnetwork93cd_name string = 'uattestnetwork93cd'
param SharePointOnlineList_Jan28_servicePrincipalKey string
param sites_SharePointDataExtractionFunction_name string = 'SharePointDataExtractionFunction'
param publicIPAddresses_DevTest_GatewayIP_name string = 'UAT-GatewayIP'
param metricAlerts_EmailOnADFActionFailure_name string = 'EmailOnADFActionFailure'
param metricAlerts_EmailOnADFPipelineFailure_name string = 'EmailOnADFPipelineFailure'
param localNetworkGateways_DevTest_LocalNetworkGateway_name string = 'UAT-LocalNetworkGateway'
param privateDnsZones_privatelink_dfs_core_windows_net_name string = 'privatelink.dfs.core.windows.net'
param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net'
param privateDnsZones_privatelink_datafactory_azure_net_name string = 'privatelink.datafactory.azure.net'
param privateEndpoints_dmiprojectsstorage_private_endpoint_name string = 'uat-dmiprojectsstorage-private-endpoint'
param virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name string = 'UAT-VirtualNetworkGateway1'
param privateEndpoints_dmi_projects_factory_private_endpoint_name string = 'uat-dmi-projects-factory-private-endpoint'
param factories_data_modernization_externalid string
param factories_dmi_projects_factory_externalid string
param storageAccounts_dmiprojectsstorage_externalid string
param virtualNetworks_Prod_VirtualNetwork_externalid string

// ==========================================================
// Module Call for Extended Networking Resources
// ==========================================================
module networkModule 'modules/network.bicep' = {
  name: 'networkModule'
  params: {
    connections_azureblob_1_name: connections_azureblob_1_name
    connections_azureblob_2_name: connections_azureblob_2_name
    connections_azureblob_3_name: connections_azureblob_3_name
    connections_azureblob_4_name: connections_azureblob_4_name
    connections_azureblob_5_name: connections_azureblob_5_name
    actionGroups_Email_Alicia_name: actionGroups_Email_Alicia_name
    connections_PA_DevTest_VPN_name: connections_PA_DevTest_VPN_name
    networkInterfaces_test_vm2_name: networkInterfaces_test_vm2_name
    storageAccounts_devdatabphc_name: storageAccounts_devdatabphc_name
    routeTables_DevTest_RouteTable_name: routeTables_DevTest_RouteTable_name
    virtualNetworks_DevTest_Network_name: virtualNetworks_DevTest_Network_name
    serverfarms_ASP_DevTestNetwork_b27f_name: serverfarms_ASP_DevTestNetwork_b27f_name
    storageAccounts_devtestnetwork93cd_name: storageAccounts_devtestnetwork93cd_name
    sites_SharePointDataExtractionFunction_name: sites_SharePointDataExtractionFunction_name
    publicIPAddresses_DevTest_GatewayIP_name: publicIPAddresses_DevTest_GatewayIP_name
    metricAlerts_EmailOnADFActionFailure_name: metricAlerts_EmailOnADFActionFailure_name
    metricAlerts_EmailOnADFPipelineFailure_name: metricAlerts_EmailOnADFPipelineFailure_name
    localNetworkGateways_DevTest_LocalNetworkGateway_name: localNetworkGateways_DevTest_LocalNetworkGateway_name
    privateDnsZones_privatelink_dfs_core_windows_net_name: privateDnsZones_privatelink_dfs_core_windows_net_name
    privateDnsZones_privatelink_blob_core_windows_net_name: privateDnsZones_privatelink_blob_core_windows_net_name
    privateDnsZones_privatelink_datafactory_azure_net_name: privateDnsZones_privatelink_datafactory_azure_net_name
    privateEndpoints_dmiprojectsstorage_private_endpoint_name: privateEndpoints_dmiprojectsstorage_private_endpoint_name
    virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name: virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name
    privateEndpoints_dmi_projects_factory_private_endpoint_name: privateEndpoints_dmi_projects_factory_private_endpoint_name
    factories_data_modernization_externalid: factories_data_modernization_externalid
    factories_dmi_projects_factory_externalid: factories_dmi_projects_factory_externalid
    storageAccounts_dmiprojectsstorage_externalid: storageAccounts_dmiprojectsstorage_externalid
    virtualNetworks_Prod_VirtualNetwork_externalid: virtualNetworks_Prod_VirtualNetwork_externalid
  }
}

// ==========================================================
// Additional Application & Service Resources for UAT
// ==========================================================
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: resourceGroup().location
  properties: {}
}

resource activityLogAlert 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: 'UAT-DataFactoryAlert'
  location: 'global'
  properties: {
    scopes: [
      dataFactory.id
    ]
    condition: {
      allOf: [
        {
          field: 'status'
          equals: 'Failed'
        }
      ]
    }
    actions: [
      {
        actionGroupId: resourceId('Microsoft.Insights/actionGroups', actionGroups_Email_Alicia_name)
      }
    ]
  }
}

resource storageAccount1 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccounts_devdatabphc_name
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {}
}

resource storageAccount2 'Microsoft.Storage/storageAccounts@2021-04-01' = {
  name: storageAccounts_devtestnetwork93cd_name
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'Storage'
  properties: {}
}

resource azureblobConnection1 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_1_name
  location: resourceGroup().location
  properties: {
    displayName: connections_azureblob_1_name
  }
}

resource azureblobConnection2 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_2_name
  location: resourceGroup().location
  properties: {
    displayName: connections_azureblob_2_name
  }
}

resource azureblobConnection3 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_3_name
  location: resourceGroup().location
  properties: {
    displayName: connections_azureblob_3_name
  }
}

resource azureblobConnection4 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_4_name
  location: resourceGroup().location
  properties: {
    displayName: connections_azureblob_4_name
  }
}

resource azureblobConnection5 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_5_name
  location: resourceGroup().location
  properties: {
    displayName: connections_azureblob_5_name
  }
}

resource webApp 'Microsoft.Web/sites@2021-02-01' = {
  name: sites_SharePointDataExtractionFunction_name
  location: resourceGroup().location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|3.1'
    }
  }
}

// ==========================================================
// VPN Connection Resource (Temporarily Disabled)
// ==========================================================
// Note: The VPN connection shared key is not available yet.
// When you obtain the actual shared key from the admin, uncomment the block below 
// and replace 'YourSharedKeyHere' with the real value.
/*
resource vpnConnection 'Microsoft.Network/connections@2020-11-01' = {
  name: connections_PA_DevTest_VPN_name
  location: resourceGroup().location
  properties: {
    connectionType: 'IPSec'
    virtualNetworkGateway1: {
      id: virtualNetworkGateway.id
    }
    localNetworkGateway2: {
      id: localNG.id
    }
    routingWeight: 10
    sharedKey: 'YourSharedKeyHere'
  }
}
*/
