// ==========================================================
// Updated Deployment Template for Factory Resources (UAT)
// Deploying everything to East US for consistency.
// Includes all required modules correctly referenced.
// ==========================================================

@description('Factory name parameter (e.g. "data-modernization-uat")')
param factoryName string = 'data-modernization-uat'

@secure()
@description('Service principal key for SharePoint connection')
param SharePointOnlineList_Jan28_servicePrincipalKey string

@secure()
@description('Shared key for the VPN connection')
param vpnSharedKey string

@secure()
@description('Azure Service Principal Client ID')
param clientId string

@secure()
@description('Azure Service Principal Client Secret')
param clientSecret string

@description('Azure Active Directory Tenant ID')
param tenantId string

@description('Location for all resources (e.g., eastus).')
param location string = 'eastus'

// -----------------------------
// Module Calls
// -----------------------------

// Networking Module
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
    routeTables_RouteTable_name: routeTables_RouteTable_name
    virtualNetworks_Network_name: virtualNetworks_Network_name
    publicIPAddresses_GatewayIP_name: publicIPAddresses_GatewayIP_name
    metricAlerts_EmailOnADFActionFailure_name: metricAlerts_EmailOnADFActionFailure_name
    metricAlerts_EmailOnADFPipelineFailure_name: metricAlerts_EmailOnADFPipelineFailure_name
    privateDnsZones_privatelink_dfs_core_windows_net_name: privateDnsZones_privatelink_dfs_core_windows_net_name
    privateDnsZones_privatelink_blob_core_windows_net_name: privateDnsZones_privatelink_blob_core_windows_net_name
    privateDnsZones_privatelink_datafactory_azure_net_name: privateDnsZones_privatelink_datafactory_azure_net_name
    privateEndpoints_dmiprojectsstorage_private_endpoint_name: privateEndpoints_dmiprojectsstorage_private_endpoint_name
    privateEndpoints_dmi_projects_factory_private_endpoint_name: privateEndpoints_dmi_projects_factory_private_endpoint_name
    factories_data_modernization_externalid: factories_data_modernization_externalid
    factories_dmi_projects_factory_externalid: factories_dmi_projects_factory_externalid
    localNetworkGateways_LocalNetworkGateway_name: localNetworkGateways_LocalNetworkGateway_name
    storageAccounts_dmiprojectsstorage_externalid: storageAccounts_dmiprojectsstorage_externalid
    virtualNetworkGateways_VirtualNetworkGateway1_name: virtualNetworkGateways_VirtualNetworkGateway1_name
    virtualNetworks_Prod_VirtualNetwork_externalid: virtualNetworks_Prod_VirtualNetwork_externalid
    vpnSharedKey: vpnSharedKey
    location: location
  }
}

// Storage Module
module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  params: {
    storageAccount1Name: storageAccounts_devdatabphc_name
    storageAccount2Name: storageAccounts_testnetwork93cd_name
    location: location
  }
  dependsOn: [
    networkModule
  ]
}

// Data Factory Module
module dataFactoryModule 'modules/datafactory.bicep' = {
  name: 'dataFactoryModule'
  params: {
    dataFactoryName: factoryName
    location: location
  }
  dependsOn: [
    networkModule
  ]
}

// Web Connections Module
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
    location: location
    clientId: clientId
    clientSecret: clientSecret
    tenantId: tenantId
  }
  dependsOn: [
    storageModule
    dataFactoryModule
  ]
}

// Private Endpoints Module
module privateEndpointsModule 'modules/privateEndpoints.bicep' = {
  name: 'privateEndpointsModule'
  params: {
    privateEndpoint1Name: privateEndpoints_dmi_projects_factory_private_endpoint_name
    privateEndpoint2Name: privateEndpoints_dmiprojectsstorage_private_endpoint_name
    subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_Network_name, 'default')
    targetResourceId1: dataFactoryModule.outputs.dataFactoryId
    targetResourceId2: storageModule.outputs.storage1Id
    location: location
  }
  dependsOn: [
    storageModule
    dataFactoryModule
  ]
}

// Monitoring Module
module monitoringModule 'modules/monitoring.bicep' = {
  name: 'monitoringModule'
  params: {
    metricAlertADFActionFailureName: metricAlerts_EmailOnADFActionFailure_name
    metricAlertADFPipelineFailureName: metricAlerts_EmailOnADFPipelineFailure_name
    activityLogAlertDevdatabphcName: 'AdmAct_devdatabphc'
    activityLogAlertSaName: 'sa_AdmAct'
    activityLogAlertVNetName: 'AdmAct_VNet'
    location: location
    alertScope: dataFactoryModule.outputs.dataFactoryId // Reference the ADF resource ID
  }
  dependsOn: [
    dataFactoryModule
  ]
}

// Network Interfaces Module
module networkInterfacesModule 'modules/networkInterfaces.bicep' = {
  name: 'networkInterfacesModule'
  params: {
    networkInterfaceName: networkInterfaces_vm2_name
    subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_Network_name, 'default')
    location: location
  }
  dependsOn: [
    networkModule
  ]
}

// VPN Connection Module
module vpnConnectionModule 'modules/vpnConnection.bicep' = {
  name: 'vpnConnectionModule'
  params: {
    vpnConnectionName: connections_PA_VPN_name
    gatewayId: resourceId('Microsoft.Network/virtualNetworkGateways', virtualNetworkGateways_VirtualNetworkGateway1_name)
    localGatewayId: resourceId('Microsoft.Network/localNetworkGateways', localNetworkGateways_LocalNetworkGateway_name)
    connectionType: 'IPsec'
    routingWeight: 10
    enableBgp: false
    sharedKey: vpnSharedKey
    location: location
  }
  dependsOn: [
    networkModule
    publicIPAddressesModule
  ]
}

// Public IP Addresses Module
module publicIPAddressesModule 'modules/publicIPAddresses.bicep' = {
  name: 'publicIPAddressesModule'
  params: {
    publicIPAddresses_GatewayIP_name: publicIPAddresses_GatewayIP_name
    location: location
  }
  dependsOn: [
    networkModule
  ]
}
