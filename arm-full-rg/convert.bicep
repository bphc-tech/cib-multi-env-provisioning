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

resource actionGroups_Email_Alicia_name_resource 'microsoft.insights/actionGroups@2023-09-01-preview' = {
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

resource localNetworkGateways_DevTest_LocalNetworkGateway_name_resource 'Microsoft.Network/localNetworkGateways@2024-03-01' = {
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

resource privateDnsZones_privatelink_blob_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_blob_core_windows_net_name
  location: 'global'
  properties: {}
}

resource privateDnsZones_privatelink_datafactory_azure_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_datafactory_azure_net_name
  location: 'global'
  properties: {}
}

resource privateDnsZones_privatelink_dfs_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatelink_dfs_core_windows_net_name
  location: 'global'
  properties: {}
}

resource publicIPAddresses_DevTest_GatewayIP_name_resource 'Microsoft.Network/publicIPAddresses@2024-03-01' = {
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

resource routeTables_DevTest_RouteTable_name_resource 'Microsoft.Network/routeTables@2024-03-01' = {
  name: routeTables_DevTest_RouteTable_name
  location: 'eastus'
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'AllowAzureTraffic'
        id: routeTables_DevTest_RouteTable_name_AllowAzureTraffic.id
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'Internet'
        }
        type: 'Microsoft.Network/routeTables/routes'
      }
    ]
  }
}

resource storageAccounts_devtestnetwork93cd_name_resource 'Microsoft.Storage/storageAccounts@2023-05-01' = {
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
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource connections_azureblob_1_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_1_name
  location: 'eastus'
  kind: 'V1'
  properties: {
    displayName: ' DMI-DataLake-SP-Conn'
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
      description: 'Microsoft Azure Storage provides a massively scalable, durable, and highly available storage for data on the cloud, and serves as the data storage solution for modern applications. Connect to Blob Storage to perform various operations such as create, update, get and delete on blobs in your Azure Storage account.'
      iconUri: 'https://conn-afd-prod-endpoint-bmc9bqahasf3grgk.b01.azurefd.net/releases/v1.0.1718/1.0.1718.3954/azureblob/icon.png'
      brandColor: '#804998'
      id: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/providers/Microsoft.Web/locations/eastus/managedApis/azureblob'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com:443/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.Web/connections/${connections_azureblob_1_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

resource connections_azureblob_2_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_2_name
  location: 'eastus'
  kind: 'V1'
  properties: {
    displayName: 'sp_to_adls2_blob_conn_v2'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {}
    createdTime: '2025-01-21T16:19:05.4312617Z'
    changedTime: '2025-02-11T20:36:26.9405376Z'
    api: {
      name: 'azureblob'
      displayName: 'Azure Blob Storage'
      description: 'Microsoft Azure Storage provides a massively scalable, durable, and highly available storage for data on the cloud, and serves as the data storage solution for modern applications. Connect to Blob Storage to perform various operations such as create, update, get and delete on blobs in your Azure Storage account.'
      iconUri: 'https://conn-afd-prod-endpoint-bmc9bqahasf3grgk.b01.azurefd.net/releases/v1.0.1718/1.0.1718.3954/azureblob/icon.png'
      brandColor: '#804998'
      id: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/providers/Microsoft.Web/locations/eastus/managedApis/azureblob'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com:443/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.Web/connections/${connections_azureblob_2_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

resource connections_azureblob_3_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_3_name
  location: 'eastus'
  kind: 'V1'
  properties: {
    displayName: 'sp_to_adls2_blob_conn_v3'
    statuses: [
      {
        status: 'Error'
        target: 'token'
        error: {}
      }
    ]
    customParameterValues: {}
    createdTime: '2025-01-21T17:27:23.5612256Z'
    changedTime: '2025-01-21T17:27:23.5612256Z'
    api: {
      name: 'azureblob'
      displayName: 'Azure Blob Storage'
      description: 'Microsoft Azure Storage provides a massively scalable, durable, and highly available storage for data on the cloud, and serves as the data storage solution for modern applications. Connect to Blob Storage to perform various operations such as create, update, get and delete on blobs in your Azure Storage account.'
      iconUri: 'https://conn-afd-prod-endpoint-bmc9bqahasf3grgk.b01.azurefd.net/releases/v1.0.1718/1.0.1718.3954/azureblob/icon.png'
      brandColor: '#804998'
      id: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/providers/Microsoft.Web/locations/eastus/managedApis/azureblob'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com:443/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.Web/connections/${connections_azureblob_3_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

resource connections_azureblob_4_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_4_name
  location: 'eastus'
  kind: 'V1'
  properties: {
    displayName: 'sp_to_adls2_blob_conn_v4'
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {}
    createdTime: '2025-01-21T17:44:55.538087Z'
    changedTime: '2025-02-23T20:22:26.9091778Z'
    api: {
      name: 'azureblob'
      displayName: 'Azure Blob Storage'
      description: 'Microsoft Azure Storage provides a massively scalable, durable, and highly available storage for data on the cloud, and serves as the data storage solution for modern applications. Connect to Blob Storage to perform various operations such as create, update, get and delete on blobs in your Azure Storage account.'
      iconUri: 'https://conn-afd-prod-endpoint-bmc9bqahasf3grgk.b01.azurefd.net/releases/v1.0.1718/1.0.1718.3954/azureblob/icon.png'
      brandColor: '#804998'
      id: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/providers/Microsoft.Web/locations/eastus/managedApis/azureblob'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com:443/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.Web/connections/${connections_azureblob_4_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

resource connections_azureblob_5_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_azureblob_5_name
  location: 'eastus'
  kind: 'V1'
  properties: {
    displayName: 'BlobConnectionForSharePointData_v3'
    statuses: [
      {
        status: 'Error'
        target: 'token'
        error: {}
      }
    ]
    customParameterValues: {}
    createdTime: '2025-01-21T18:12:50.5945745Z'
    changedTime: '2025-01-21T18:12:50.5945745Z'
    api: {
      name: 'azureblob'
      displayName: 'Azure Blob Storage'
      description: 'Microsoft Azure Storage provides a massively scalable, durable, and highly available storage for data on the cloud, and serves as the data storage solution for modern applications. Connect to Blob Storage to perform various operations such as create, update, get and delete on blobs in your Azure Storage account.'
      iconUri: 'https://conn-afd-prod-endpoint-bmc9bqahasf3grgk.b01.azurefd.net/releases/v1.0.1718/1.0.1718.3954/azureblob/icon.png'
      brandColor: '#804998'
      id: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/providers/Microsoft.Web/locations/eastus/managedApis/azureblob'
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com:443/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.Web/connections/${connections_azureblob_5_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}

resource serverfarms_ASP_DevTestNetwork_b27f_name_resource 'Microsoft.Web/serverfarms@2024-04-01' = {
  name: serverfarms_ASP_DevTestNetwork_b27f_name
  location: 'East US'
  sku: {
    name: 'FC1'
    tier: 'FlexConsumption'
    size: 'FC1'
    family: 'FC'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource metricAlerts_EmailOnADFActionFailure_name_resource 'microsoft.insights/metricAlerts@2018-03-01' = {
  name: metricAlerts_EmailOnADFActionFailure_name
  location: 'global'
  tags: {
    TeamResource: 'DMI_ADF'
  }
  properties: {
    severity: 1
    enabled: true
    scopes: [
      factories_data_modernization_externalid
    ]
    evaluationFrequency: 'PT1H'
    windowSize: 'PT1H'
    criteria: {
      allOf: [
        {
          threshold: 1
          name: 'Metric1'
          metricNamespace: 'Microsoft.DataFactory/factories'
          metricName: 'ActivityFailedRuns'
          operator: 'GreaterThanOrEqual'
          timeAggregation: 'Count'
          skipMetricValidation: false
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    autoMitigate: true
    targetResourceType: 'Microsoft.DataFactory/factories'
    targetResourceRegion: 'eastus'
    actions: [
      {
        actionGroupId: actionGroups_Email_Alicia_name_resource.id
        webHookProperties: {}
      }
    ]
  }
}

resource metricAlerts_EmailOnADFPipelineFailure_name_resource 'microsoft.insights/metricAlerts@2018-03-01' = {
  name: metricAlerts_EmailOnADFPipelineFailure_name
  location: 'global'
  tags: {
    TeamResource: 'DMI_ADF'
  }
  properties: {
    severity: 1
    enabled: true
    scopes: [
      factories_data_modernization_externalid
    ]
    evaluationFrequency: 'PT1H'
    windowSize: 'PT1H'
    criteria: {
      allOf: [
        {
          threshold: 1
          name: 'Metric1'
          metricNamespace: 'Microsoft.DataFactory/factories'
          metricName: 'PipelineFailedRuns'
          operator: 'GreaterThanOrEqual'
          timeAggregation: 'Count'
          skipMetricValidation: false
          criterionType: 'StaticThresholdCriterion'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    autoMitigate: true
    targetResourceType: 'Microsoft.DataFactory/factories'
    targetResourceRegion: 'eastus'
    actions: [
      {
        actionGroupId: actionGroups_Email_Alicia_name_resource.id
        webHookProperties: {}
      }
    ]
  }
}

resource networkInterfaces_test_vm2_name_resource 'Microsoft.Network/networkInterfaces@2024-03-01' = {
  name: networkInterfaces_test_vm2_name
  location: 'eastus'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'Ipv4config'
        id: '${networkInterfaces_test_vm2_name_resource.id}/ipConfigurations/Ipv4config'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAddress: '10.59.40.5'
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworks_DevTest_Network_name_default.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_devdatabphc 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'devdatabphc'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '10.59.40.7'
      }
    ]
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_dev_gprpt185_v1 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'dev-gprpt185-v1'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.59.40.7'
      }
    ]
  }
}

resource privateDnsZones_privatelink_datafactory_azure_net_name_dmi_projects_factory_eastus 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_datafactory_azure_net_name_resource
  name: 'dmi-projects-factory.eastus'
  properties: {
    metadata: {
      creator: 'created by private endpoint dmi-projects-factory-private-endpoint with resource guid 7337ffa8-1f2f-420c-8156-80a8a0068893'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.59.40.11'
      }
    ]
  }
}

resource privateDnsZones_privatelink_dfs_core_windows_net_name_dmiprojectsstorage 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_dfs_core_windows_net_name_resource
  name: 'dmiprojectsstorage'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '10.59.40.12'
      }
    ]
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_vpngw000000 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'vpngw000000'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.59.40.132'
      }
    ]
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_vpngw000001 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'vpngw000001'
  properties: {
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.59.40.133'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_blob_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_datafactory_azure_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_datafactory_azure_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_dfs_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatelink_dfs_core_windows_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource privateEndpoints_dmi_projects_factory_private_endpoint_name_resource 'Microsoft.Network/privateEndpoints@2024-03-01' = {
  name: privateEndpoints_dmi_projects_factory_private_endpoint_name
  location: 'eastus'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_dmi_projects_factory_private_endpoint_name
        id: '${privateEndpoints_dmi_projects_factory_private_endpoint_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_dmi_projects_factory_private_endpoint_name}'
        properties: {
          privateLinkServiceId: factories_dmi_projects_factory_externalid
          groupIds: [
            'dataFactory'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: virtualNetworks_DevTest_Network_name_default.id
    }
    ipConfigurations: []
    customDnsConfigs: []
  }
}

resource privateEndpoints_dmiprojectsstorage_private_endpoint_name_resource 'Microsoft.Network/privateEndpoints@2024-03-01' = {
  name: privateEndpoints_dmiprojectsstorage_private_endpoint_name
  location: 'eastus'
  tags: {
    Factory: 'dmi-projects-factory'
  }
  properties: {
    privateLinkServiceConnections: [
      {
        name: '${privateEndpoints_dmiprojectsstorage_private_endpoint_name}_08bf6a5e-2dd5-4317-88b1-58df2a79d039'
        id: '${privateEndpoints_dmiprojectsstorage_private_endpoint_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_dmiprojectsstorage_private_endpoint_name}_08bf6a5e-2dd5-4317-88b1-58df2a79d039'
        properties: {
          privateLinkServiceId: storageAccounts_dmiprojectsstorage_externalid
          groupIds: [
            'dfs'
          ]
          privateLinkServiceConnectionState: {
            status: 'Disconnected'
            description: 'storage account being deleted'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    subnet: {
      id: virtualNetworks_DevTest_Network_name_default.id
    }
    ipConfigurations: []
    customDnsConfigs: []
  }
}

resource routeTables_DevTest_RouteTable_name_AllowAzureTraffic 'Microsoft.Network/routeTables/routes@2024-03-01' = {
  name: '${routeTables_DevTest_RouteTable_name}/AllowAzureTraffic'
  properties: {
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'Internet'
  }
  dependsOn: [
    routeTables_DevTest_RouteTable_name_resource
  ]
}

resource virtualNetworks_DevTest_Network_name_resource 'Microsoft.Network/virtualNetworks@2024-03-01' = {
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
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    dhcpOptions: {
      dnsServers: []
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        id: virtualNetworks_DevTest_Network_name_GatewaySubnet.id
        properties: {
          addressPrefixes: [
            '10.59.40.128/27'
          ]
          serviceEndpoints: []
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
      {
        name: 'default'
        id: virtualNetworks_DevTest_Network_name_default.id
        properties: {
          addressPrefixes: [
            '10.59.40.0/25'
          ]
          routeTable: {
            id: routeTables_DevTest_RouteTable_name_resource.id
          }
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                'eastus'
                'westus'
                'westus3'
              ]
            }
            {
              service: 'Microsoft.KeyVault'
              locations: [
                '*'
              ]
            }
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
        type: 'Microsoft.Network/virtualNetworks/subnets'
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'Prod-devtest-peering'
        id: virtualNetworks_DevTest_Network_name_Prod_devtest_peering.id
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
        type: 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings'
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_DevTest_Network_name_GatewaySubnet 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' = {
  name: '${virtualNetworks_DevTest_Network_name}/GatewaySubnet'
  properties: {
    addressPrefixes: [
      '10.59.40.128/27'
    ]
    serviceEndpoints: []
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_DevTest_Network_name_resource
  ]
}

resource virtualNetworks_DevTest_Network_name_Prod_devtest_peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2024-03-01' = {
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
    virtualNetworks_DevTest_Network_name_resource
  ]
}

resource storageAccounts_devdatabphc_name_resource 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccounts_devdatabphc_name
  location: 'eastus'
  tags: {
    'ms-resource-usage': 'azure-cloud-shell'
  }
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: true
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    routingPreference: {
      routingChoice: 'MicrosoftRouting'
      publishMicrosoftEndpoints: false
      publishInternetEndpoints: false
    }
    isSftpEnabled: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    isHnsEnabled: true
    networkAcls: {
      resourceAccessRules: [
        {
          tenantId: 'ff5b5bc8-925b-471f-942a-eb176c03ab36'
          resourceId: factories_data_modernization_externalid
        }
      ]
      bypass: 'Logging, Metrics, AzureServices'
      virtualNetworkRules: [
        {
          id: virtualNetworks_DevTest_Network_name_default.id
          action: 'Allow'
          state: 'Succeeded'
        }
      ]
      ipRules: [
        {
          value: '104.174.117.148'
          action: 'Allow'
        }
        {
          value: '140.241.253.162'
          action: 'Allow'
        }
        {
          value: '20.140.48.136/30'
          action: 'Allow'
        }
        {
          value: '20.140.48.192/29'
          action: 'Allow'
        }
        {
          value: '20.140.56.144/28'
          action: 'Allow'
        }
        {
          value: '20.140.56.192/26'
          action: 'Allow'
        }
        {
          value: '20.140.64.136/30'
          action: 'Allow'
        }
        {
          value: '20.140.64.144/29'
          action: 'Allow'
        }
        {
          value: '20.140.72.136/30'
          action: 'Allow'
        }
        {
          value: '20.140.72.144/29'
          action: 'Allow'
        }
        {
          value: '20.140.77.232/30'
          action: 'Allow'
        }
        {
          value: '20.140.152.76/30'
          action: 'Allow'
        }
        {
          value: '20.140.152.88/29'
          action: 'Allow'
        }
        {
          value: '20.141.16.148/30'
          action: 'Allow'
        }
        {
          value: '52.127.49.128/29'
          action: 'Allow'
        }
        {
          value: '52.127.49.192/26'
          action: 'Allow'
        }
        {
          value: '52.127.55.216/29'
          action: 'Allow'
        }
        {
          value: '52.235.251.108/30'
          action: 'Allow'
        }
        {
          value: '20.140.48.116/30'
          action: 'Allow'
        }
        {
          value: '20.140.56.116/30'
          action: 'Allow'
        }
        {
          value: '20.140.64.116/30'
          action: 'Allow'
        }
        {
          value: '20.140.72.116/30'
          action: 'Allow'
        }
        {
          value: '20.140.152.72/30'
          action: 'Allow'
        }
        {
          value: '52.127.48.68/30'
          action: 'Allow'
        }
      ]
      defaultAction: 'Deny'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Hot'
  }
}

resource storageAccounts_devdatabphc_name_default 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccounts_devdatabphc_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
  }
}

resource storageAccounts_devtestnetwork93cd_name_default 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccounts_devtestnetwork93cd_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_devdatabphc_name_default 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: storageAccounts_devdatabphc_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_devtestnetwork93cd_name_default 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: storageAccounts_devtestnetwork93cd_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_devdatabphc_name_default 'Microsoft.Storage/storageAccounts/queueServices@2023-05-01' = {
  parent: storageAccounts_devdatabphc_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_devtestnetwork93cd_name_default 'Microsoft.Storage/storageAccounts/queueServices@2023-05-01' = {
  parent: storageAccounts_devtestnetwork93cd_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_devdatabphc_name_default 'Microsoft.Storage/storageAccounts/tableServices@2023-05-01' = {
  parent: storageAccounts_devdatabphc_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_devtestnetwork93cd_name_default 'Microsoft.Storage/storageAccounts/tableServices@2023-05-01' = {
  parent: storageAccounts_devtestnetwork93cd_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource sites_SharePointDataExtractionFunction_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_SharePointDataExtractionFunction_name_resource
  name: 'ftp'
  location: 'East US'
  properties: {
    allow: true
  }
}

resource sites_SharePointDataExtractionFunction_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2024-04-01' = {
  parent: sites_SharePointDataExtractionFunction_name_resource
  name: 'scm'
  location: 'East US'
  properties: {
    allow: true
  }
}

resource sites_SharePointDataExtractionFunction_name_web 'Microsoft.Web/sites/config@2024-04-01' = {
  parent: sites_SharePointDataExtractionFunction_name_resource
  name: 'web'
  location: 'East US'
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v4.0'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$SharePointDataExtractionFunction'
    scmType: 'None'
    use32BitWorkerProcess: false
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    publicNetworkAccess: 'Enabled'
    cors: {
      allowedOrigins: [
        'https://portal.azure.com'
      ]
      supportCredentials: false
    }
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'FtpsOnly'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 100
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {}
  }
}

resource sites_SharePointDataExtractionFunction_name_sites_SharePointDataExtractionFunction_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2024-04-01' = {
  parent: sites_SharePointDataExtractionFunction_name_resource
  name: '${sites_SharePointDataExtractionFunction_name}.azurewebsites.net'
  location: 'East US'
  properties: {
    siteName: 'SharePointDataExtractionFunction'
    hostNameType: 'Verified'
  }
}

resource connections_PA_DevTest_VPN_name_resource 'Microsoft.Network/connections@2024-03-01' = {
  name: connections_PA_DevTest_VPN_name
  location: 'eastus'
  properties: {
    virtualNetworkGateway1: {
      id: virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name_resource.id
      properties: {}
    }
    localNetworkGateway2: {
      id: localNetworkGateways_DevTest_LocalNetworkGateway_name_resource.id
      properties: {}
    }
    connectionType: 'IPsec'
    connectionProtocol: 'IKEv2'
    routingWeight: 0
    enableBgp: false
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    ipsecPolicies: []
    trafficSelectorPolicies: []
    expressRouteGatewayBypass: false
    enablePrivateLinkFastPath: false
    dpdTimeoutSeconds: 45
    connectionMode: 'Default'
    gatewayCustomBgpIpAddresses: []
  }
}

resource privateDnsZones_privatelink_datafactory_azure_net_name_b2ncwt4cv53qk 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_datafactory_azure_net_name_resource
  name: 'b2ncwt4cv53qk'
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_DevTest_Network_name_resource.id
    }
  }
}

resource privateDnsZones_privatelink_blob_core_windows_net_name_o4fztdlrog5ou 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_blob_core_windows_net_name_resource
  name: 'o4fztdlrog5ou'
  location: 'global'
  properties: {
    registrationEnabled: true
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_DevTest_Network_name_resource.id
    }
  }
}

resource privateDnsZones_privatelink_dfs_core_windows_net_name_o4fztdlrog5ou 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatelink_dfs_core_windows_net_name_resource
  name: 'o4fztdlrog5ou'
  location: 'global'
  properties: {
    registrationEnabled: false
    resolutionPolicy: 'Default'
    virtualNetwork: {
      id: virtualNetworks_DevTest_Network_name_resource.id
    }
  }
}

resource privateEndpoints_dmi_projects_factory_private_endpoint_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2024-03-01' = {
  name: '${privateEndpoints_dmi_projects_factory_private_endpoint_name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink.datafactory.azure.net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_datafactory_azure_net_name_resource.id
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_dmi_projects_factory_private_endpoint_name_resource
  ]
}

resource virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name_resource 'Microsoft.Network/virtualNetworkGateways@2024-03-01' = {
  name: virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name
  location: 'eastus'
  properties: {
    enablePrivateIpAddress: false
    ipConfigurations: [
      {
        name: 'default'
        id: '${virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name_resource.id}/ipConfigurations/default'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_DevTest_GatewayIP_name_resource.id
          }
          subnet: {
            id: virtualNetworks_DevTest_Network_name_GatewaySubnet.id
          }
        }
      }
    ]
    natRules: []
    virtualNetworkGatewayPolicyGroups: []
    enableBgpRouteTranslationForNat: false
    disableIPSecReplayProtection: false
    sku: {
      name: 'VpnGw1'
      tier: 'VpnGw1'
    }
    gatewayType: 'Vpn'
    vpnType: 'RouteBased'
    enableBgp: false
    activeActive: false
    bgpSettings: {
      asn: 65515
      bgpPeeringAddress: '10.59.40.158'
      peerWeight: 0
      bgpPeeringAddresses: [
        {
          ipconfigurationId: '${virtualNetworkGateways_DevTest_VirtualNetworkGateway1_name_resource.id}/ipConfigurations/default'
          customBgpIpAddresses: []
        }
      ]
    }
    vpnGatewayGeneration: 'Generation1'
    allowRemoteVnetTraffic: false
    allowVirtualWanTraffic: false
  }
}

resource virtualNetworks_DevTest_Network_name_default 'Microsoft.Network/virtualNetworks/subnets@2024-03-01' = {
  name: '${virtualNetworks_DevTest_Network_name}/default'
  properties: {
    addressPrefixes: [
      '10.59.40.0/25'
    ]
    routeTable: {
      id: routeTables_DevTest_RouteTable_name_resource.id
    }
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
        locations: [
          'eastus'
          'westus'
          'westus3'
        ]
      }
      {
        service: 'Microsoft.KeyVault'
        locations: [
          '*'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_DevTest_Network_name_resource
  ]
}

resource storageAccounts_devtestnetwork93cd_name_default_app_package_sharepointdataextractionfunction_534bc44 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccounts_devtestnetwork93cd_name_default
  name: 'app-package-sharepointdataextractionfunction-534bc44'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_devtestnetwork93cd_name_resource
  ]
}

resource storageAccounts_devtestnetwork93cd_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccounts_devtestnetwork93cd_name_default
  name: 'azure-webjobs-hosts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_devtestnetwork93cd_name_resource
  ]
}

resource storageAccounts_devtestnetwork93cd_name_default_azure_webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccounts_devtestnetwork93cd_name_default
  name: 'azure-webjobs-secrets'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_devtestnetwork93cd_name_resource
  ]
}

resource storageAccounts_devdatabphc_name_default_cib_referral_system 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccounts_devdatabphc_name_default
  name: 'cib-referral-system'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_devdatabphc_name_resource
  ]
}

resource storageAccounts_devdatabphc_name_default_redcap_idb_hsb 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccounts_devdatabphc_name_default
  name: 'redcap-idb-hsb'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_devdatabphc_name_resource
  ]
}

resource storageAccounts_devdatabphc_name_default_sbhc_system 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-05-01' = {
  parent: storageAccounts_devdatabphc_name_default
  name: 'sbhc-system'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [
    storageAccounts_devdatabphc_name_resource
  ]
}

resource storageAccounts_devtestnetwork93cd_name_default_AzureFunctionsDiagnosticEvents202501 'Microsoft.Storage/storageAccounts/tableServices/tables@2023-05-01' = {
  parent: Microsoft_Storage_storageAccounts_tableServices_storageAccounts_devtestnetwork93cd_name_default
  name: 'AzureFunctionsDiagnosticEvents202501'
  properties: {}
  dependsOn: [
    storageAccounts_devtestnetwork93cd_name_resource
  ]
}

resource sites_SharePointDataExtractionFunction_name_resource 'Microsoft.Web/sites@2024-04-01' = {
  name: sites_SharePointDataExtractionFunction_name
  location: 'East US'
  kind: 'functionapp,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: 'sharepointdataextractionfunction.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: 'sharepointdataextractionfunction.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_DevTestNetwork_b27f_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    dnsConfiguration: {}
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 100
      minimumElasticInstanceCount: 0
    }
    functionAppConfig: {
      deployment: {
        storage: {
          type: 'blobcontainer'
          value: 'https://${storageAccounts_devtestnetwork93cd_name}.blob.core.windows.net/app-package-sharepointdataextractionfunction-534bc44'
          authentication: {
            type: 'storageaccountconnectionstring'
            storageAccountConnectionStringName: 'DEPLOYMENT_STORAGE_CONNECTION_STRING'
          }
        }
      }
      runtime: {
        name: 'python'
        version: '3.11'
      }
      scaleAndConcurrency: {
        maximumInstanceCount: 100
        instanceMemoryMB: 2048
      }
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    ipMode: 'IPv4'
    vnetBackupRestoreEnabled: false
    customDomainVerificationId: '75849B57EA929F8D35F9BE8C564388DD1E600F2B539580D345549A87ECD357B0'
    containerSize: 1536
    dailyMemoryTimeQuota: 0
    httpsOnly: true
    endToEndEncryptionEnabled: false
    redundancyMode: 'None'
    publicNetworkAccess: 'Enabled'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
  dependsOn: [
    storageAccounts_devtestnetwork93cd_name_resource
  ]
}
