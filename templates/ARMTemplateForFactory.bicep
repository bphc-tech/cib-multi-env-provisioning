// ==========================================================
// Updated Deployment Template for Factory Resources
// ==========================================================

@description('Factory name parameter')
param factoryName string

// -----------------------------
// Network Module Parameters
// -----------------------------
param connections_azureblob_1_name string = 'azureblob-1'
param connections_azureblob_2_name string = 'azureblob-2'
param connections_azureblob_3_name string = 'azureblob-3'
param connections_azureblob_4_name string = 'azureblob-4'
param connections_azureblob_5_name string = 'azureblob-5'
param actionGroups_Email_Alicia_name string = 'Email_Alicia'
param connections_PA_VPN_name string = 'PA-VPN'
param networkInterfaces_vm2_name string = 'vm2'
param storageAccounts_devdatabphc_name string = 'databphc'
param routeTables_RouteTable_name string = 'RouteTable'
param virtualNetworks_Network_name string = 'VNet'
param serverfarms_ASP_Network_name string = 'ASP-Network'
param storageAccounts_testnetwork93cd_name string = 'testnetwork93cd'
param SharePointOnlineList_Jan28_servicePrincipalKey string
param sites_SharePointDataExtractionFunction_name string = 'SharePointDataExtractionFunction'
param publicIPAddresses_GatewayIP_name string = 'GatewayIP'
param metricAlerts_EmailOnADFActionFailure_name string = 'EmailOnADFActionFailure'
param metricAlerts_EmailOnADFPipelineFailure_name string = 'EmailOnADFPipelineFailure'
param localNetworkGateways_LocalNetworkGateway_name string = 'LocalNetworkGateway'
param privateDnsZones_privatelink_dfs_core_windows_net_name string = 'privatelink.dfs.core.windows.net'
param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net'
param privateDnsZones_privatelink_datafactory_azure_net_name string = 'privatelink.datafactory.azure.net'
param privateEndpoints_dmiprojectsstorage_private_endpoint_name string = 'dmiprojectsstorage-private-endpoint'
param virtualNetworkGateways_VirtualNetworkGateway1_name string = 'VirtualNetworkGateway1'
param privateEndpoints_dmi_projects_factory_private_endpoint_name string = 'dmi-projects-factory-private-endpoint'
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
    connections_PA_VPN_name: connections_PA_VPN_name
    networkInterfaces_vm2_name: networkInterfaces_vm2_name
    storageAccounts_devdatabphc_name: storageAccounts_devdatabphc_name
    routeTables_RouteTable_name: routeTables_RouteTable_name
    virtualNetworks_Network_name: virtualNetworks_Network_name
    serverfarms_ASP_Network_name: serverfarms_ASP_Network_name
    storageAccounts_testnetwork93cd_name: storageAccounts_testnetwork93cd_name
    sites_SharePointDataExtractionFunction_name: sites_SharePointDataExtractionFunction_name
    publicIPAddresses_GatewayIP_name: publicIPAddresses_GatewayIP_name
    metricAlerts_EmailOnADFActionFailure_name: metricAlerts_EmailOnADFActionFailure_name
    metricAlerts_EmailOnADFPipelineFailure_name: metricAlerts_EmailOnADFPipelineFailure_name
    localNetworkGateways_LocalNetworkGateway_name: localNetworkGateways_LocalNetworkGateway_name
    privateDnsZones_privatelink_dfs_core_windows_net_name: privateDnsZones_privatelink_dfs_core_windows_net_name
    privateDnsZones_privatelink_blob_core_windows_net_name: privateDnsZones_privatelink_blob_core_windows_net_name
    privateDnsZones_privatelink_datafactory_azure_net_name: privateDnsZones_privatelink_datafactory_azure_net_name
    privateEndpoints_dmiprojectsstorage_private_endpoint_name: privateEndpoints_dmiprojectsstorage_private_endpoint_name
    virtualNetworkGateways_VirtualNetworkGateway1_name: virtualNetworkGateways_VirtualNetworkGateway1_name
    privateEndpoints_dmi_projects_factory_private_endpoint_name: privateEndpoints_dmi_projects_factory_private_endpoint_name
    factories_data_modernization_externalid: factories_data_modernization_externalid
    factories_dmi_projects_factory_externalid: factories_dmi_projects_factory_externalid
    storageAccounts_dmiprojectsstorage_externalid: storageAccounts_dmiprojectsstorage_externalid
    virtualNetworks_Prod_VirtualNetwork_externalid: virtualNetworks_Prod_VirtualNetwork_externalid
  }
}

// ==========================================================
// Additional Application & Service Resources
// ==========================================================
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: resourceGroup().location
  properties: {}
}

resource activityLogAlert 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: 'DataFactoryAlert'
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
  name: storageAccounts_testnetwork93cd_name
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
