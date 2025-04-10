// ==========================================================
// Updated Deployment Template for Factory Resources (UAT)
// Deploying everything to East US for consistency.
// Includes (9) modules correctly referenced.
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

// -----------------------------
// Parameters
// -----------------------------
@description('Name of the first Azure Blob connection')
param connections_azureblob_1_name string = 'azureblob-1-uat'

@description('Name of the second Azure Blob connection')
param connections_azureblob_2_name string = 'azureblob-2-uat'

@description('Name of the third Azure Blob connection')
param connections_azureblob_3_name string = 'azureblob-3-uat'

@description('Name of the fourth Azure Blob connection')
param connections_azureblob_4_name string = 'azureblob-4-uat'

@description('Name of the fifth Azure Blob connection')
param connections_azureblob_5_name string = 'azureblob-5-uat'

@description('Name of the action group for email notifications')
param actionGroups_Email_Alicia_name string = 'Email_Alicia-uat'

@description('Name of the VPN connection')
param connections_PA_VPN_name string = 'PA-VPN-uat'

@description('Name of the network interface for VM2')
param networkInterfaces_vm2_name string = 'vm2-uat'

@description('Name of the first storage account')
param storageAccounts_devdatabphc_name string = 'databphc-uat'

@description('Name of the route table')
param routeTables_RouteTable_name string = 'RouteTable-uat'

@description('Name of the virtual network')
param virtualNetworks_Network_name string = 'VNet-uat'

@description('Name of the second storage account')
param storageAccounts_testnetwork93cd_name string = 'testnetwork93cd-uat'

@description('Name of the public IP address for the gateway')
param publicIPAddresses_GatewayIP_name string = 'GatewayIP-uat'

@description('Name of the metric alert for ADF action failure')
param metricAlerts_EmailOnADFActionFailure_name string = 'EmailOnADFActionFailure-uat'

@description('Name of the metric alert for ADF pipeline failure')
param metricAlerts_EmailOnADFPipelineFailure_name string = 'EmailOnADFPipelineFailure-uat'

@description('Name of the local network gateway')
param localNetworkGateways_LocalNetworkGateway_name string = 'LocalNetworkGateway-uat'

@description('Name of the private DNS zone for DFS')
param privateDnsZones_privatelink_dfs_core_windows_net_name string = 'privatelink.dfs.core.windows.net-uat'

@description('Name of the private DNS zone for Blob storage')
param privateDnsZones_privatelink_blob_core_windows_net_name string = 'privatelink.blob.core.windows.net-uat'

@description('Name of the private DNS zone for Data Factory')
param privateDnsZones_privatelink_datafactory_azure_net_name string = 'privatelink.datafactory.azure.net-uat'

@description('Name of the private endpoint for the storage account')
param privateEndpoints_dmiprojectsstorage_private_endpoint_name string = 'dmiprojectsstorage-private-endpoint-uat'

@description('Name of the virtual network gateway')
param virtualNetworkGateways_VirtualNetworkGateway1_name string = 'VirtualNetworkGateway1-uat'

@description('Name of the private endpoint for the Data Factory')
param privateEndpoints_dmi_projects_factory_private_endpoint_name string = 'dmi-projects-factory-private-endpoint-uat'

@description('External ID for the modernization factory')
param factories_data_modernization_externalid string

@description('External ID for the projects factory')
param factories_dmi_projects_factory_externalid string

@description('External ID for the storage account')
param storageAccounts_dmiprojectsstorage_externalid string

@description('External ID for the production virtual network')
param virtualNetworks_Prod_VirtualNetwork_externalid string

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
    privateEndpoints_dmi_projects_factory_private_endpoint_name: privateEndpoints_dmi_projects_factory_private_endpoint_name
    virtualNetworkGateways_VirtualNetworkGateway1_name: virtualNetworkGateways_VirtualNetworkGateway1_name
    factories_data_modernization_externalid: factories_data_modernization_externalid
    factories_dmi_projects_factory_externalid: factories_dmi_projects_factory_externalid
    storageAccounts_dmiprojectsstorage_externalid: storageAccounts_dmiprojectsstorage_externalid
    virtualNetworks_Prod_VirtualNetwork_externalid: virtualNetworks_Prod_VirtualNetwork_externalid
    vpnSharedKey: vpnSharedKey
  }
}

// Storage Module
module storageModule 'modules/storage.bicep' = {
  name: 'storageModule'
  params: {
    storageAccount1Name: storageAccounts_devdatabphc_name
    storageAccount2Name: storageAccounts_testnetwork93cd_name
    location: 'eastus'
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
    location: 'eastus'
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
    location: 'eastus'
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
    targetResourceId1: factories_dmi_projects_factory_externalid
    targetResourceId2: storageAccounts_dmiprojectsstorage_externalid
    location: 'eastus'
  }
  dependsOn: [
    networkModule
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
    location: 'global'
    alertScope: resourceId('Microsoft.Network/virtualNetworks', virtualNetworks_Network_name)
  }
  dependsOn: [
    networkModule
  ]
}

// Network Interfaces Module
module networkInterfacesModule 'modules/networkInterfaces.bicep' = {
  name: 'networkInterfacesModule'
  params: {
    networkInterfaceName: networkInterfaces_vm2_name
    subnetId: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_Network_name, 'default')
    location: 'eastus'
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
    connectionType: 'IPsec'
    routingWeight: 10
    enableBgp: false
    sharedKey: vpnSharedKey
    location: 'eastus'
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
    location: 'eastus'
  }
  dependsOn: [
    networkModule
  ]
}
