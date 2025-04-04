// ==========================================================
// Factory Deployment Template (Modularized)
// ==========================================================

@description('Factory name parameter (e.g. "data-modernization")')
param factoryName string

@description('Service Principal Key for SharePoint Online List Jan 28')
param SharePointOnlineList_Jan28_servicePrincipalKey string

// Networking-related parameters
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
param virtualNetworkGateways_VirtualNetworkGateway1_name string
param privateEndpoints_dmi_projects_factory_private_endpoint_name string
param factories_data_modernization_externalid string
param factories_dmi_projects_factory_externalid string
param storageAccounts_dmiprojectsstorage_externalid string
param virtualNetworks_Prod_VirtualNetwork_externalid string

// Parameters for activity log alerts and alert scope
@description('Name for the activity log alert Devdatabphc')
param activityLogAlertDevdatabphcName string

@description('Name for the activity log alert sa_AdmAct')
param activityLogAlertSaName string

@description('Name for the activity log alert VNet')
param activityLogAlertVNetName string

@description('Scope for the alerts')
param alertScope string

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
    activityLogAlertDevdatabphcName: activityLogAlertDevdatabphcName
    activityLogAlertSaName: activityLogAlertSaName
    location: 'global'
    alertScope: alertScope
    activityLogAlertVNetName: activityLogAlertVNetName
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
