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
    // other receiver arrays empty
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
      addressPrefixes: [
        '10.68.0.0/16'
        '10.75.0.0/16'
      ]
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

// Route Table with a single route.
// Note: We remove self-references by using resourceId() function directly.
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

// Storage Accounts (two examples)
// Storage account for devdatabphc
resource storageDevDatabphc 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccounts_devdatabphc_name
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    defaultToOAuthAuthentication: true
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: [
        {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworks_DevTest_Network_name, 'default')
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: { keyType: 'Account', enabled: true }
        blob: { keyType: 'Account', enabled: true }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// Storage account for devtestnetwork93cd (similar structure)
resource storageDevTestNetwork 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccounts_devtestnetwork93cd_name
  location: 'eastus'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'Storage'
  properties: {
    defaultToOAuthAuthentication: true
    allowCrossTenantReplication: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: { keyType: 'Account', enabled: true }
        blob: { keyType: 'Account', enabled: true }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

// Web Connections for Azure Blob (example for one connection)
resource connectionBlob1 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_1_name
  location: 'eastus'
  kind: 'V1'
  properties: {
    displayName: 'DMI-DataLake-SP-Conn'
    statuses: [
      {
        status: 'Error'
        target: 'token'
        error: {}
      }
    ]
    customParameterValues: {}
    createdTime: '2025-01-16T15:17:59.0159123Z'
    changedTime: '2025-01-16T15:17:59.0159123Z'
    api: {
      name: 'azureblob'
      displayName: 'Azure Blob Storage'
      description: 'Connect to Azure Blob Storage to perform CRUD operations.'
      iconUri: 'https://conn-afd-prod-endpoint-bmc9bqahasf3grgk.b01.azurefd.net/releases/v1.0.1718/azureblob/icon.png'
      brandColor: '#804998'
      id: resourceId('Microsoft.Web/locations/managedApis', 'azureblob')
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.Web/connections/${connections_azureblob_1_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

// (Repeat similar resource definitions for connections_azureblob_2_name_resource through connections_azureblob_5_name_resource)

// Virtual Network with subnets and peering
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-03-01' = {
  name: virtualNetworks_DevTest_Network_name
  location: 'eastus'
  tags: {
    Factory: 'dmi-projects-factory'
  }
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.59.40.0/24'
      ]
    }
    // Note: Do not set "id" in subnets; use resourceId() in dependencies.
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefixes: [
            '10.59.40.128/27'
          ]
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'default'
        properties: {
          addressPrefixes: [
            '10.59.40.0/25'
          ]
          routeTable: {
            id: resourceId('Microsoft.Network/routeTables', routeTables_DevTest_RouteTable_name)
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                'eastus'
                'westus'
                'westus3'
              ]
            },            {
              service: 'Microsoft.KeyVault'
              locations: ['*']
            }
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
  }
}

// Virtual Network Peering (for production peering)
// We reference the remote prod VNet via resourceId()
resource vnetPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-03-01' = {
  name: '${virtualNetworks_DevTest_Network_name}/Prod-devtest-peering'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_Prod_VirtualNetwork_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    remoteAddressSpace: {
      addressPrefixes: [
        '10.59.30.0/24'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.59.30.0/24'
      ]
    }
  }
  dependsOn: [
    virtualNetwork
  ]
}

// (Continue with the remaining resources, ensuring that any references to an "id" of a sibling resource use the resourceId() function instead of a direct property reference. Remove self–references to break cycles.)

// Note: In this revised module, circular dependencies have been addressed by not using properties from sibling resources directly and by relying on resourceId() function calls.
// You can further split this file into additional modules (e.g. storage.bicep, web.bicep, etc.) once this base module is verified.

