// ===================================================
// Parameters
// ===================================================
param factoryName string
@secure()
param SharePointOnlineList_Jan28_servicePrincipalKey string

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
    description: 'Ingest data from SharePoint into ADLS. Columns are adjusted as needed.'
    activities: [
      // Activity: LTS_Clients_To_ADLS
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
        outputs: [
          {
            referenceName: 'raw_SpLts_Clients'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      },           {  // Activity: LTS_Staff_To_ADLS
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
            referenceName: 'raw_SpLts_Staff'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      },            { // Activity: ETO_MHL_and_HSB_clients_To_ADLS
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
            referenceName: 'raw_SqlEto_Clients'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
        outputs: [
          {
            referenceName: 'sqlserver_eto_clients_raw_sink'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      },            { // Activity: execADLS_Raw_To_ADLS_Processed
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
        policy: { secureInput: true }
        typeProperties: {
          pipeline: {
            referenceName: 'ADLS_Raw_To_ADLS_Processed'
            type: 'PipelineReference'
          }
        }
      }
    ]
  }
}

// ===================================================
// Datasets
// ===================================================

// Dataset: SQLServer_ETO_Clients_raw_sink
resource sqlserverEtoClientsRawSink 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: 'sqlserver_eto_clients_raw_sink'
  properties: {
    type: 'DelimitedText'
    linkedServiceName: {
      referenceName: 'SecureLinkedServiceADLS'
      type: 'LinkedServiceReference'
    }
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileSystem: 'raw'
        folderPath: 'sqlserver/eto/clients'
      }
      columnDelimiter: ','
      rowDelimiter: '\n'
      encodingName: 'UTF-8'
      escapeChar: '\\'
      quoteChar: '"'
    }
  }
}

// (Additional resources for datasets, linked services, integration runtimes, and triggers would follow.)
// Ensure that any redcap-related items are removed.
