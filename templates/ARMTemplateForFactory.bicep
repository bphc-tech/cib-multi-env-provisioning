// ==========================================================
// Updated Deployment Template for Factory Resources (UAT)
// Deploying everything to East US for consistency.
// Includes (9) modules correctly referenced.
// ==========================================================

@description('Factory name parameter (e.g. "data-modernization-uat")')
param factoryName string

@secure()
@description('Service principal key for SharePoint connection')
param SharePointOnlineList_Jan28_servicePrincipalKey string

@secure()
@description('Shared key for the VPN connection')
param vpnSharedKey string

// -----------------------------
// Parameters
// -----------------------------
param connections_azureblob_1_name string = 'azureblob-1-uat'
param connections_azureblob_2_name string = 'azureblob-2-uat'
param connections_azureblob_3_name string = 'azureblob-3-uat'
param connections_azureblob_4_name string = 'azureblob-4-uat'
param connections_azureblob_5_name string = 'azureblob-5-uat'
param actionGroups_Email_Alicia_name string = 'Email_Alicia-uat'
param connections_PA_VPN_name string = 'PA-VPN-uat'
param networkInterfaces_vm2_name string = 'vm2-uat'
param storageAccounts_devdatabphc_name string = 'databphc-uat'
param routeTables_RouteTable_name string = 'RouteTable-uat'
param virtualNetworks_Network_name string = 'VNet-uat'
param storageAccounts_testnetwork93cd_name string = 'testnetwork93cd-uat'
param publicIPAddresses_GatewayIP_name string = 'GatewayIP-uat'
param metricAlerts_EmailOnADFActionFailure_name string = 'EmailOnADFActionFailure-uat'
param metricAlerts_EmailOnADFPipelineFailure_name string = 'EmailOnADFPipelineFailure-uat'
param localNetworkGateways_LocalNetworkGateway_name string = 'LocalNetworkGateway-uat'
param privateDnsZones_privatelink_dfs_core_windows_net_name string = 'privatelink.dfs.core.windows.net-uat'
param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net-uat'
param privateDnsZones_privatelink_datafactory_azure_net_name string = 'privatelink.datafactory.azure.net-uat'
param privateEndpoints_dmiprojectsstorage_private_endpoint_name string = 'dmiprojectsstorage-private-endpoint-uat'
param virtualNetworkGateways_VirtualNetworkGateway1_name string = 'VirtualNetworkGateway1-uat'
param privateEndpoints_dmi_projects_factory_private_endpoint_name string = 'dmi-projects-factory-private-endpoint-uat'
param factories_data_modernization_externalid string
param factories_dmi_projects_factory_externalid string
param storageAccounts_dmiprojectsstorage_externalid string
param virtualNetworks_Prod_VirtualNetwork_externalid string

// -----------------------------
// Module Calls
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
    vpnSharedKey: vpnSharedKey
  }
}

module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  params: {
    storageAccount1Name: storageAccounts_devdatabphc_name
    storageAccount2Name: storageAccounts_testnetwork93cd_name
    location: 'eastus'
  }
}

module dataFactoryModule 'modules/datafactory.bicep' = {
  name: 'dataFactoryModule'
  params: {
    dataFactoryName: factoryName
    location: 'eastus'
  }
}

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
    clientId: 'your-client-id'
    clientSecret: 'your-client-secret'
    tenantId: 'your-tenant-id'
  }
}

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

module monitoringModule 'modules/monitoring.bicep' = {
  name: 'monitoringModule'
  params: {
    metricAlertADFActionFailureName: metricAlerts_EmailOnADFActionFailure_name
    metricAlertADFPipelineFailureName: metricAlerts_EmailOnADFPipelineFailure_name
    activityLogAlertDevdatabphcName: 'AdmAct_devdatabphc'
    activityLogAlertSaName: 'sa_AdmAct'
    activityLogAlertVNetName: 'AdmAct_VNet'
    location: 'global'
    alertScope: resourceId('Microsoft.Network/virtualNetworks', virtualNetworks_Network_name)
  }
}

module networkInterfacesModule 'modules/networkInterfaces.bicep' = {
  name: 'networkInterfacesModule'
  params: {
    networkInterfaceName: networkInterfaces_vm2_name
    subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_Network_name, 'default')
    location: 'eastus'
  }
}

module vpnConnectionModule 'modules/vpnConnection.bicep' = {
  name: 'vpnConnectionModule'
  params: {
    vpnConnectionName: connections_PA_VPN_name
    gatewayId: resourceId('Microsoft.Network/virtualNetworkGateways', virtualNetworkGateways_VirtualNetworkGateway1_name)
    connectionType: 'IPsec'
    routingWeight: 10
    enableBgp: false
    sharedKey: vpnSharedKey
    location: 'eastus'
  }
}

module publicIPAddressesModule 'modules/publicIPAddresses.bicep' = {
  name: 'publicIPAddressesModule'
  params: {
    publicIPAddresses_GatewayIP_name: publicIPAddresses_GatewayIP_name
    location: 'eastus'
  }
}
