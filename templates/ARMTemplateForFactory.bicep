// ==========================================================
// Main Deployment Template for Factory Resources
// ==========================================================

@description('Factory name parameter')
param factoryName string

// (Other global parameters you need go here)

// Network Module Parameters (passed from the main template)
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

// ==========================================================
// Module Call for Networking Resources
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
    factories_data_modernization_externalid: factories_data_modernization_externalids
    factories_dmi_projects_factory_externalid: factories_dmi_projects_factory_externalid
    storageAccounts_dmiprojectsstorage_externalid: storageAccounts_dmiprojectsstorage_externalid
    virtualNetworks_Prod_VirtualNetwork_externalid: virtualNetworks_Prod_VirtualNetwork_externalid
  }
}

// ==========================================================
// (Other resource definitions can follow here)
// ==========================================================

/*
Note:
- This main template now calls the network module and passes all the network-related parameters.
- Ensure that your module (modules/network.bicep) uses these parameters as needed.
- Remove or update any unused parameters as necessary.
*/
