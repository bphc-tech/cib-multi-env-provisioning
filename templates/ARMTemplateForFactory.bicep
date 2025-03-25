// ===================================================
// Main Data Factory Deployment Template
// ===================================================

// Parameters (only include those needed by this template)
param factoryName string = 'data-modernization'
@secure()
param SharePointOnlineList_Jan28_servicePrincipalKey string

// (Other parameters for non-network resources go here...)
// For example, parameters for linked services, datasets, etc.

// ===================================================
// Main Data Factory Resource Definition
// ===================================================
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: resourceGroup().location
  properties: {}
}

// ===================================================
// Other Resource Definitions
// ===================================================
// (Define any resources that are not part of the network module here)
// ...

// ===================================================
// Network Module Deployment
// ===================================================
// The network-related resources have been moved to a module for modularization.
// Uncomment the following module call to deploy the network resources.
// Ensure the corresponding module file is located at './modules/network.bicep'.

module networkModule 'modules/network.bicep' = {
  name: 'networkDeployment'
  params: {
    connections_azureblob_1_name: 'azureblob-1'
    connections_azureblob_2_name: 'azureblob-2'
    connections_azureblob_3_name: 'azureblob-3'
    connections_azureblob_4_name: 'azureblob-4'
    connections_azureblob_5_name: 'azureblob-5'
    actionGroups_Email_Alicia_name: 'Email_Alicia'
    connections_PA_DevTest_VPN_name: 'PA-DevTest-VPN'
    networkInterfaces_test_vm2_name: 'test-vm2'
    storageAccounts_devdatabphc_name: 'devdatabphc'
    routeTables_DevTest_RouteTable_name: 'DevTest-RouteTable'
    virtualNetworks_DevTest_Network_name: 'DevTest-Network'
    serverfarms_ASP_DevTestNetwork_b27f_name: 'ASP-DevTestNetwork-b27f'
    storageAccounts_devtestnetwork93cd_name: 'devtestnetwork93cd'
    sites_SharePointDataExtractionFunction_name: 'SharePointDataExtractionFunction'
    publicIPAddresses_DevTest_GatewayIP_name: 'DevTest-GatewayIP'
    metricAlerts_EmailOnADFActionFailure_name: 'EmailOnADFActionFailure'
    metricAlerts_EmailOnADFPipelineFailure_name: 'EmailOnADFPipelineFailure'
    localNetworkGateways_DevTest_LocalNetworkGateway_name: 'DevTest-LocalNetworkGateway'
    privateDnsZones_privatelink_dfs_core_windows_net_name: 'privatelink.dfs.core.windows.net'
    privateDnsZones_privatelink_blob_core_windows_net_name: 'privatelink.blob.core.windows.net'
    privateDnsZones_privatelink_datafactory_azure_net_name: 'privatelink.datafactory.azure.net'
    privateEndpoints_dmiprojectsstorage_private_endpoint_name: 'dmiprojectsstorage-private-endpoint'
    virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name: 'DevTest-VirtualNetworkGateway1'
    privateEndpoints_dmi_projects_factory_private_endpoint_name: 'dmi-projects-factory-private-endpoint'
    factories_data_modernization_externalid: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.DataFactory/factories/data-modernization'
    factories_dmi_projects_factory_externalid: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.DataFactory/factories/dmi-projects-factory'
    storageAccounts_dmiprojectsstorage_externalid: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.Storage/storageAccounts/dmiprojectsstorage'
    virtualNetworks_Prod_VirtualNetwork_externalid: '/subscriptions/2b7c117e-2dba-4c4a-9cd0-e1f0dfe74b03/resourceGroups/Prod-Network/providers/Microsoft.Network/virtualNetworks/Prod-VirtualNetwork'
  }
}

// ===================================================
// (Other resources, outputs, etc.)
// ===================================================
