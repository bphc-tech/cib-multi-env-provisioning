// ==========================================================
// Simplified Factory Deployment Template (Vanilla Resources)
// ==========================================================

@description('Factory name parameter (e.g. "data-modernization")')
param factoryName string

// -----------------------------
// Parameters
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
param storageAccounts_testnetwork93cd_name string = 'testnetwork93cd'
param SharePointOnlineList_Jan28_servicePrincipalKey string
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

// -----------------------------
// Module Call: Extended Networking Resources
// -----------------------------
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
    storageAccounts_testnetwork93cd_name: storageAccounts_testnetwork93cd_name
    localNetworkGateways_LocalNetworkGateway_name: localNetworkGateways_LocalNetworkGateway_name
    routeTables_RouteTable_name: routeTables_RouteTable_name
    virtualNetworks_Network_name: virtualNetworks_Network_name
    publicIPAddresses_GatewayIP_name: publicIPAddresses_GatewayIP_name
    metricAlerts_EmailOnADFActionFailure_name: metricAlerts_EmailOnADFActionFailure_name
    metricAlerts_EmailOnADFPipelineFailure_name: metricAlerts_EmailOnADFPipelineFailure_name
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

// -----------------------------
// Module Call: Storage Accounts
// -----------------------------
module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  params: {
    storageAccount1Name: storageAccounts_devdatabphc_name
    storageAccount2Name: storageAccounts_testnetwork93cd_name
    location: 'eastus'
  }
}

// -----------------------------
// Module Call: Data Factory
// -----------------------------
module dataFactoryModule 'modules/datafactory.bicep' = {
  name: 'dataFactoryModule'
  params: {
    dataFactoryName: factoryName
    location: 'eastus'
  }
}

// -----------------------------
// Module Call: Web Connections
// -----------------------------
module webConnectionsModule 'modules/webconnections.bicep' = {
  name: 'webConnectionsModule'
  params: {
    connectionNames: [
      connections_azureblob_1_name
      connections_azureblob_2_name
      connections_azureblob_3_name
      connections_azureblob_4_name
      connections_azureblob_5_name
    ]
    location: 'eastus'
  }
}

// -----------------------------
// Module Call: Private Endpoints
// -----------------------------
module privateEndpointsModule 'modules/privateEndpoints.bicep' = {
  name: 'privateEndpointsModule'
  params: {
    privateEndpoint1Name: privateEndpoints_dmi_projects_factory_private_endpoint_name
    privateEndpoint2Name: privateEndpoints_dmiprojectsstorage_private_endpoint_name
    subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_Network_name, 'default')
    targetResourceId1: factories_dmi_projects_factory_externalid
    targetResourceId2: storageAccounts_dmiprojectsstorage_externalid
    location: 'eastus'
  }
}

// -----------------------------
// Module Call: Monitoring & Alerts
// -----------------------------
module monitoringModule 'modules/monitoring.bicep' = {
  name: 'monitoringModule'
  params: {
    metricAlertADFActionFailureName: metricAlerts_EmailOnADFActionFailure_name
    metricAlertADFPipelineFailureName: metricAlerts_EmailOnADFPipelineFailure_name
    activityLogAlertDevdatabphcName: 'AdmAct_devdatabphc'
    activityLogAlertSaName: 'sa_AdmAct'
    location: 'global'
    alertScope: resourceId('Microsoft.Network/virtualNetworks', virtualNetworks_Network_name)
  }
}

// -----------------------------
// Module Call: Network Interfaces
// -----------------------------
module networkInterfacesModule 'modules/networkInterfaces.bicep' = {
  name: 'networkInterfacesModule'
  params: {
    networkInterfaceName: networkInterfaces_vm2_name
    subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_Network_name, 'default')
    location: 'eastus'
  }
}
