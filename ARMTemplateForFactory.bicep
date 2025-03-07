// ===================================================
// Parameters
// ===================================================
param factoryName string = 'data-modernization'  // Use a unique name per environment (e.g., data-modernization-dev)
param ADLSGen2_NotSelfHosted_Feb1_properties_typeProperties_url string = 'https://devdatabphc.dfs.core.windows.net/'
param AzureKeyVault_LinkedService_properties_typeProperties_baseUrl string = 'https://dmi-dev-keyvault.vault.azure.net/'
param SecureLinkedServiceADLS_properties_typeProperties_url string = 'https://devdatabphc.dfs.core.windows.net/'
param SharePointOnlineList_Jan28_properties_typeProperties_servicePrincipalId string = 'afb856b0-75c5-4f53-bda2-48ef4163d6d8'
@secure()
param SharePointOnlineList_Jan28_servicePrincipalKey string  // Supplied as a secure parameter
param SqlServerDMBPHCETO_properties_typeProperties_server string = 'DC-DEV-V01'
param SqlServerDMBPHCETO_properties_typeProperties_database string = 'DM-BPHC-ETO'
param SqlServerDMBPHCETO_properties_typeProperties_userName string = 'SQLETO'
param SqlServerETO_properties_typeProperties_server string = 'DC-DEV-V01'
param SqlServerETO_properties_typeProperties_database string = 'ETO'
param SqlServerETO_properties_typeProperties_userName string = 'SQLETO'

// ===================================================
// Main Data Factory Resource
// ===================================================
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: resourceGroup().location
  properties: {}
}

// ===================================================
// Pipelines
// ===================================================

// Pipeline: Raw_to_ADLS (Data Ingestion)
resource rawToAdls 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  parent: dataFactory
  name: 'Raw_to_ADLS'
  properties: {
    description: 'Ingest data from SharePoint into ADLS. Columns are adjusted (e.g. using "ColorTag" when an empty column is required).'
    activities: [
      {
        name: 'LTS_Clients_To_ADLS'
        type: 'Copy'
        dependsOn: []
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureInput: true
          secureOutput: true
        }
        typeProperties: {
          source: {
            type: 'SharePointOnlineListSource'
            query: '$select=UID,AssignedShelter,FirstName,LastName,DOB,Created,StartDate,EndDate'
          }
          sink: {
            type: 'DelimitedTextSink'
            storeSettings: {
              type: 'AzureBlobFSWriteSettings'
              copyBehavior: 'FlattenHierarchy'
            }
            formatSettings: {
              type: 'DelimitedTextWriteSettings'
              fileExtension: '.txt'
              quoteAllText: true
            }
          }
        }
        inputs: [
          {
            referenceName: 'SharePoint_LTS_Clients'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
        // Changed output reference to an existing dataset.
        outputs: [
          {
            referenceName: 'raw_SpLts_Clients'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      },      {
        name: 'LTS_Staff_To_ADLS'
        type: 'Copy'
        dependsOn: []
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureInput: true
          secureOutput: true
        }
        typeProperties: {
          source: {
            type: 'SharePointOnlineListSource'
            query: '$select=Id,Name,Modified,Created,EMail,IsSiteAdmin,Deleted,Department,JobTitle,FirstName,LastName,WorkPhone,UserName,Office'
          }
          sink: {
            type: 'DelimitedTextSink'
            storeSettings: {
              type: 'AzureBlobFSWriteSettings'
              copyBehavior: 'FlattenHierarchy'
            }
            formatSettings: {
              type: 'DelimitedTextWriteSettings'
              fileExtension: '.txt'
              quoteAllText: true
            }
          }
        }
        inputs: [
          {
            referenceName: 'SharePoint_LTS_Staff_Names'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
        outputs: [
          {
            referenceName: 'User_Information_List_raw_sink'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      },      {
        name: 'ETO_MHL_and_HSB_clients_To_ADLS'
        type: 'Copy'
        dependsOn: [
          {
            activity: 'LTS_Clients_To_ADLS'
            dependencyConditions: [ 'Completed' ]
          },          {
            activity: 'LTS_Staff_To_ADLS'
            dependencyConditions: [ 'Completed' ]
          }
        ]
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureInput: true
          secureOutput: true
        }
        typeProperties: {
          source: {
            type: 'SqlServerSource'
            sqlReaderQuery: {
              type: 'Expression'
              value: 'WITH LanguageCorrection AS ( ... )' // Replace with your actual query.
            }
          }
          sink: {
            type: 'DelimitedTextSink'
            storeSettings: {
              type: 'AzureBlobFSWriteSettings'
            }
            formatSettings: {
              type: 'DelimitedTextWriteSettings'
              fileExtension: '.txt'
              quoteAllText: true
            }
          }
        }
        inputs: [
          {
            referenceName: 'SQLServerETOQuery'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
        outputs: [
          {
            referenceName: 'SQLServer_ETO_Clients_raw_sink'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      },      {
        name: 'execADLS_Raw_To_ADLS_Processed'
        type: 'ExecutePipeline'
        dependsOn: [
          {
            activity: 'LTS_Clients_To_ADLS'
            dependencyConditions: [ 'Completed' ]
          },          {
            activity: 'LTS_Staff_To_ADLS'
            dependencyConditions: [ 'Completed' ]
          },          {
            activity: 'ETO_MHL_and_HSB_clients_To_ADLS'
            dependencyConditions: [ 'Completed' ]
          }
        ]
        policy: {
          secureInput: true
        }
        typeProperties: {
          pipeline: {
            referenceName: 'ADLS_Raw_To_ADLS_Processed'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
        }
      }
    ]
  }
}

// Pipeline: ADLS_Raw_To_ADLS_Processed (Data Transformation)
resource adlsRawToAdlsProcessed 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  parent: dataFactory
  name: 'ADLS_Raw_To_ADLS_Processed'
  properties: {
    description: 'Transform raw data in ADLS and output processed data back to ADLS.'
    activities: [
      {
        name: 'DataFlow_ETL_Data_for_CIB'
        description: 'Execute the ETL_Data_for_CIB Data flow.'
        type: 'ExecuteDataFlow'
        dependsOn: []
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: true
          secureInput: true
        }
        userProperties: []
        typeProperties: {
          dataFlow: {
            referenceName: 'ETL_Data_for_CIB'
            type: 'DataFlowReference'
            parameters: {}
            datasetParameters: {
              SpLtsStaff: {}
              SpLtsClients: {}
              SqlEtoClients: {}
              sinkCombinedClients: {}
            }
          }
          staging: {}
          compute: {
            coreCount: 8
            computeType: 'General'
          }
          traceLevel: 'Fine'
        }
      }
    ]
    policy: {
      elapsedTimeMetric: {}
    }
    annotations: []
  }
}

//
// ===================================================
// Integration Runtimes
// ===================================================

// Managed Integration Runtime (managedIR)
resource managedIR 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  parent: dataFactory
  name: 'NotSelfHostedIrForADLS'
  properties: {
    type: 'Managed'
    description: 'IR for connecting to ADLS Gen2 in Data flows.'
    typeProperties: {
      computeProperties: {
        location: 'East US'
        dataFlowProperties: {
          computeType: 'General'
          coreCount: 8
          timeToLive: 10
          cleanup: false
          customProperties: []
        }
        pipelineExternalComputeScaleProperties: {
          timeToLive: 60
          numberOfPipelineNodes: 1
          numberOfExternalNodes: 1
        }
      }
    }
    managedVirtualNetwork: {
      type: 'ManagedVirtualNetworkReference'
      referenceName: 'default'
    }
  }
}

// Self-hosted Integration Runtime
resource integrationRuntime1 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  parent: dataFactory
  name: 'integrationRuntime1'
  properties: {
    type: 'SelfHosted'
    description: 'SelfHosted IR for on-prem SQL Server.'
    typeProperties: {}
  }
}

//
// ===================================================
// Dataflows
// ===================================================

// Dataflow: ETL_Data_for_CIB
resource etlDataForCIB 'Microsoft.DataFactory/factories/dataflows@2018-06-01' = {
  parent: dataFactory
  name: 'ETL_Data_for_CIB'
  properties: {
    description: 'Transform raw datasets for CIB and output processed data.'
    type: 'MappingDataFlow'
    typeProperties: {
      sources: [
        {
          name: 'SpLtsStaff'
          dataset: {
            referenceName: 'raw_SpLts_Staff'
            type: 'DatasetReference'
          }
        },        {
          name: 'SpLtsClients'
          dataset: {
            referenceName: 'raw_SpLts_Clients'
            type: 'DatasetReference'
          }
        },        {
          name: 'SqlEtoClients'
          dataset: {
            referenceName: 'raw_SqlEto_Clients'
            type: 'DatasetReference'
          }
        }
      ]
      sinks: [
        {
          name: 'sinkCombinedClients'
          dataset: {
            referenceName: 'sink_CIB_LTS_MHL_and_HSB_clients'
            type: 'DatasetReference'
          }
          rejectedDataLinkedService: {
            referenceName: 'ADLSGen2_NotSelfHosted_Feb1'
            type: 'LinkedServiceReference'
          }
        }
      ]
      transformations: [
        { name: 'ClientsWithStaffFLName' },        { name: 'ClientsWithStaffFullName' },        { name: 'unionClients' },        { name: 'selectLtsColumns' }
      ]
    }
  }
}

//
// ===================================================
// Datasets
// ===================================================
resource rawSpLtsStaff 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: 'raw_SpLts_Staff'
  properties: {
    linkedServiceName: {
      referenceName: 'ADLSGen2_NotSelfHosted_Feb1'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: 'lts_staff_User_Information_List.csv'
        folderPath: 'raw/sp_lts'
        fileSystem: 'cib-referral-system'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: []
  }
}

resource rawSpLtsClients 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: 'raw_SpLts_Clients'
  properties: {
    linkedServiceName: {
      referenceName: 'ADLSGen2_NotSelfHosted_Feb1'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: 'lts_clients_Mass_Cass_Guest_Tracker.csv'
        folderPath: 'raw/sp_lts'
        fileSystem: 'cib-referral-system'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: []
  }
}

resource rawSqlEtoClients 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: 'raw_SqlEto_Clients'
  properties: {
    linkedServiceName: {
      referenceName: 'ADLSGen2_NotSelfHosted_Feb1'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: 'eto_MHL_and_HSB_clients.csv'
        folderPath: 'raw/sql_eto'
        fileSystem: 'cib-referral-system'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: []
  }
}

resource sinkCIBLTSMHLandHSBClients 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: 'sink_CIB_LTS_MHL_and_HSB_clients'
  properties: {
    linkedServiceName: {
      referenceName: 'ADLSGen2_NotSelfHosted_Feb1'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: 'CIB_LTS_MHL_and_HSB_clients.csv'
        folderPath: 'processed/CIB_Referral_Automation'
        fileSystem: 'cib-referral-system'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: []
  }
}

//
// ===================================================
// Linked Services
// ===================================================
resource adlsLS 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: dataFactory
  name: 'ADLSGen2_NotSelfHosted_Feb1'
  properties: {
    description: 'Linked service using NotSelfHostedIrForADLS (Managed Virtual Network).'
    annotations: []
    type: 'AzureBlobFS'
    typeProperties: {
      url: ADLSGen2_NotSelfHosted_Feb1_properties_typeProperties_url
    }
    connectVia: {
      referenceName: 'NotSelfHostedIrForADLS'
      type: 'IntegrationRuntimeReference'
    }
  }
}

resource keyVaultLS 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: dataFactory
  name: 'AzureKeyVault_LinkedService'
  properties: {
    description: 'Linked service for accessing secrets from the key vault.'
    annotations: []
    type: 'AzureKeyVault'
    typeProperties: {
      baseUrl: AzureKeyVault_LinkedService_properties_typeProperties_baseUrl
    }
  }
}

resource secureAdlsLS 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: dataFactory
  name: 'SecureLinkedServiceADLS'
  properties: {
    description: 'Secure linked service for ADLS using managed identity.'
    annotations: []
    type: 'AzureBlobFS'
    typeProperties: {
      url: SecureLinkedServiceADLS_properties_typeProperties_url
    }
    connectVia: {
      referenceName: 'NotSelfHostedIrForADLS'
      type: 'IntegrationRuntimeReference'
    }
  }
}

resource sharePointLS 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: dataFactory
  name: 'SharePointOnlineList_Jan28'
  properties: {
    description: 'Linked service for SharePoint Online.'
    annotations: []
    type: 'SharePointOnlineList'
    typeProperties: {
      siteUrl: 'https://bphc.sharepoint.com/sites/Guest-Registry'
      tenantId: 'ff5b5bc8-925b-471f-942a-eb176c03ab36'
      servicePrincipalId: SharePointOnlineList_Jan28_properties_typeProperties_servicePrincipalId
      // Revert to using secure parameter for SharePoint key because Key Vault references are not supported.
      servicePrincipalKey: {
         type: 'SecureString'
         value: SharePointOnlineList_Jan28_servicePrincipalKey
      }
      servicePrincipalCredentialType: 'ServicePrincipalKey'
    }
  }
}

resource sqlServerDMBPHCETOLS 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: dataFactory
  name: 'SqlServerDMBPHCETO'
  properties: {
    description: 'Linked service for SQL Server DMBPHCETO.'
    annotations: []
    type: 'SqlServer'
    typeProperties: {
      server: SqlServerDMBPHCETO_properties_typeProperties_server
      database: SqlServerDMBPHCETO_properties_typeProperties_database
      encrypt: 'mandatory'
      trustServerCertificate: true
      authenticationType: 'SQL'
      userName: SqlServerDMBPHCETO_properties_typeProperties_userName
      password: {
        type: 'AzureKeyVaultSecretReference'
        secretName: 'SqlServerDMBPHCETO-password'
        secretVersion: ''
        store: {
          id: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DMI-Dev/providers/Microsoft.KeyVault/vaults/dmi-dev-keyvault'
        }
      }
      alwaysEncryptedSettings: {
        alwaysEncryptedAkvAuthType: 'ManagedIdentity'
      }
    }
    connectVia: {
      referenceName: 'NotSelfHostedIrForADLS'
      type: 'IntegrationRuntimeReference'
    }
  }
}

resource sqlServerETOls 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: dataFactory
  name: 'SqlServerETO'
  properties: {
    description: 'Linked service for SQL Server ETO.'
    annotations: []
    type: 'SqlServer'
    typeProperties: {
      server: SqlServerETO_properties_typeProperties_server
      database: SqlServerETO_properties_typeProperties_database
      encrypt: 'mandatory'
      trustServerCertificate: true
      authenticationType: 'SQL'
      userName: SqlServerETO_properties_typeProperties_userName
      password: {
        type: 'AzureKeyVaultSecretReference'
        secretName: 'SqlServerETO-password'
        secretVersion: ''
        store: {
          id: '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DMI-Dev/providers/Microsoft.KeyVault/vaults/dmi-dev-keyvault'
        }
      }
      alwaysEncryptedSettings: {
        alwaysEncryptedAkvAuthType: 'ManagedIdentity'
      }
    }
    connectVia: {
      referenceName: 'NotSelfHostedIrForADLS'
      type: 'IntegrationRuntimeReference'
    }
  }
}

//
// ===================================================
// Triggers
// ===================================================
resource dailyTriggerCIB 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
  parent: dataFactory
  name: 'dailyTrigger_CIB_LTS_MHL_and_HSB'
  properties: {
    description: 'Daily update for SharePoint and SQL Server data to ADLS Gen2.'
    annotations: []
    pipelines: [
      {
        pipelineReference: {
          referenceName: 'ADLS_Raw_To_ADLS_Processed'
          type: 'PipelineReference'
        }
        parameters: {}
      }
    ]
    type: 'ScheduleTrigger'
    typeProperties: {
      recurrence: {
        frequency: 'Day'
        interval: 1
        startTime: '2025-02-11T13:42:00'
        timeZone: 'Eastern Standard Time'
      }
    }
  }
}

//
// ===================================================
// End of Complete Revised File
// ===================================================
