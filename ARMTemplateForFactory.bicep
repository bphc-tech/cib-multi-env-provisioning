param factoryName string = 'data-modernization'

@secure()
param MySQL_REDCap_password string

@secure()
param SecureLinkedServiceADLS_accountKey string

@secure()
param SharePointOnlineList_Jan28_servicePrincipalKey string

@secure()
param SqlServerDMBPHCETO_password string

@secure()
param SqlServerETO_password string

param ADLSGen2_NotSelfHosted_Feb1_properties_typeProperties_url string = 'https://devdatabphc.dfs.core.windows.net/'
param AzureKeyVault_LinkedService_properties_typeProperties_baseUrl string = 'https://dmi-dev-keyvault.vault.azure.net/'
param MySQL_REDCap_properties_typeProperties_server string = 'REDCap-BE'
param MySQL_REDCap_properties_typeProperties_database string = 'redcap'
param MySQL_REDCap_properties_typeProperties_username string = 'AMarkoe'
param SecureLinkedServiceADLS_properties_typeProperties_url string = 'https://devdatabphc.dfs.core.windows.net/'
param SharePointOnlineList_Jan28_properties_typeProperties_servicePrincipalId string = 'afb856b0-75c5-4f53-bda2-48ef4163d6d8'
param SqlServerDMBPHCETO_properties_typeProperties_server string = 'DC-DEV-V01'
param SqlServerDMBPHCETO_properties_typeProperties_database string = 'DM-BPHC-ETO'
param SqlServerDMBPHCETO_properties_typeProperties_userName string = 'SQLETO'
param SqlServerETO_properties_typeProperties_server string = 'DC-DEV-V01'
param SqlServerETO_properties_typeProperties_database string = 'ETO'
param SqlServerETO_properties_typeProperties_userName string = 'SQLETO'
param ADF_to_ADLSGen2_devtestbphc_properties_privateLinkResourceId string = '/subscriptions/694b4cac-9702-4274-97ff-3c3e1844a8dd/resourceGroups/DevTest-Network/providers/Microsoft.Storage/storageAccounts/devdatabphc'
param ADF_to_ADLSGen2_devtestbphc_properties_groupId string = 'dfs'

var factoryId = 'Microsoft.DataFactory/factories/${factoryName}'

resource factory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: factoryName
  location: resourceGroup().location
  properties: {}
}

resource factoryName_ADLS_Raw_To_ADLS_Processed 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  parent: factory
  name: 'ADLS_Raw_To_ADLS_Processed'
  properties: {
    description: 'Take the raw data in ADLS, transform it and put it back into ADLS processed.'
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
  dependsOn: [
    factoryName_ETL_Data_for_CIB
  ]
}

resource factoryName_MySQL_REDCap_and_ETO 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  parent: factory
  name: 'MySQL_REDCap_and_ETO'
  properties: {
    activities: [
      {
        name: 'MySQLToADLS'
        type: 'Copy'
        dependsOn: []
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'MySqlSource'
            query: 'SELECT \n    project_id, \n    event_id,  \n    record,  \n    MAX(CASE WHEN field_name = \'shelter_id\' THEN value END) AS `shelter_id`,\n    MAX(CASE WHEN field_name = \'date_of_screening\' THEN value END) AS `date_of_screening`,\n    MAX(CASE WHEN field_name = \'client_name\' THEN value END) AS `client_name`,\n    MAX(CASE WHEN field_name = \'client_last_name\' THEN value END) AS `client_last_name`,\n    MAX(CASE WHEN field_name = \'gender\' THEN value END) AS `gender`,\n    MAX(CASE WHEN field_name = \'date_of_birth\' THEN value END) AS `date_of_birth`,\n    MAX(CASE WHEN field_name = \'primary_language\' THEN value END) AS `primary_language`,\n    MAX(CASE WHEN field_name = \'country_birth\' THEN value END) AS `country_birth`,\n    MAX(CASE WHEN field_name = \'region_of_birth\' THEN value END) AS `region_of_birth`,\n    MAX(CASE WHEN field_name = \'hiv_status\' THEN value END) AS `hiv_status`,\n    MAX(CASE WHEN field_name = \'diabetes_mellitus_status\' THEN value END) AS `diabetes_mellitus_status`,\n    MAX(CASE WHEN field_name = \'ckd_requiring_dialysis\' THEN value END) AS `ckd_requiring_dialysis`,\n    MAX(CASE WHEN field_name = \'smokes_tobacco\' THEN value END) AS `smokes_tobacco`,\n    MAX(CASE WHEN field_name = \'sympts_with_active_tb\' THEN value END) AS `sympts_with_active_tb`,\n    MAX(CASE WHEN field_name = \'date1\' THEN value END) AS `date1`,\n    MAX(CASE WHEN field_name = \'igra1\' THEN value END) AS `igra1`,\n    MAX(CASE WHEN field_name = \'date2\' THEN value END) AS `date2`,\n    MAX(CASE WHEN field_name = \'igra2\' THEN value END) AS `igra2`,\n    MAX(CASE WHEN field_name = \'date3\' THEN value END) AS `date3`,\n    MAX(CASE WHEN field_name = \'igra3\' THEN value END) AS `igra3`,\n    MAX(CASE WHEN field_name = \'date4\' THEN value END) AS `date4`,\n    MAX(CASE WHEN field_name = \'igra4\' THEN value END) AS `igra4`,\n    MAX(CASE WHEN field_name = \'date5\' THEN value END) AS `date5`,\n    MAX(CASE WHEN field_name = \'igra5\' THEN value END) AS `igra5`,\n    MAX(CASE WHEN field_name = \'latest_cxr_date\' THEN value END) AS `latest_cxr_date`,\n    MAX(CASE WHEN field_name = \'latest_cxr_result\' THEN value END) AS `latest_cxr_result`,\n    MAX(CASE WHEN field_name = \'prior_chest_image\' THEN value END) AS `prior_chest_image`,\n    MAX(CASE WHEN field_name = \'first_date_inshelter\' THEN value END) AS `first_date_inshelter`,\n    MAX(CASE WHEN field_name = \'no_nights_exposureto_jlm\' THEN value END) AS `no_nights_exposureto_jlm`,\n    MAX(CASE WHEN field_name = \'no_nights_exposureto_ffv\' THEN value END) AS `no_nights_exposureto_ffv`,\n    MAX(CASE WHEN field_name = \'no_nights_exposureto_kr\' THEN value END) AS `no_nights_exposureto_kr`,\n    MAX(CASE WHEN field_name = \'no_nights_exposureto_apn\' THEN value END) AS `no_nights_exposureto_apn`,\n    MAX(CASE WHEN field_name = \'no_nights_exposureto_kft\' THEN value END) AS `no_nights_exposureto_kft`,\n    MAX(CASE WHEN field_name = \'no_nights_exposureto_fcc\' THEN value END) AS `no_nights_exposureto_fcc`,\n    MAX(CASE WHEN field_name = \'no_nights_exposureto_jc\' THEN value END) AS `no_nights_exposureto_jc`,\n    MAX(CASE WHEN field_name = \'comments\' THEN value END) AS `comments`,\n    MAX(CASE WHEN field_name = \'other_immunosuppression\' THEN value END) AS `other_immunosuppression`,\n    MAX(CASE WHEN field_name = \'primary_care_location\' THEN value END) AS `primary_care_location`,\n    MAX(CASE WHEN field_name = \'primary_care_provider\' THEN value END) AS `primary_care_provider`,\n    MAX(CASE WHEN field_name = \'record_no\' THEN value END) AS `record_no`,\n    MAX(CASE WHEN field_name = \'tb_clinic_record_complete\' THEN value END) AS `tb_clinic_record_complete`,\n    MAX(CASE WHEN field_name = \'weight\' THEN value END) AS `weight`\nFROM redcap.redcap_data3 \nGROUP BY project_id, event_id, record \nHAVING client_last_name IS NOT NULL\nORDER BY record'
          }
          sink: {
            type: 'DelimitedTextSink'
            storeSettings: {
              type: 'AzureBlobFSWriteSettings'
            }
            formatSettings: {
              type: 'DelimitedTextWriteSettings'
              quoteAllText: true
              fileExtension: '.txt'
            }
          }
          enableStaging: false
          translator: {
            type: 'TabularTranslator'
            mappings: [
              {
                source: {
                  name: 'project_id'
                  type: 'Int32'
                  physicalType: 'Int32'
                }
                sink: {
                  name: 'project_id'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'event_id'
                  type: 'Int32'
                  physicalType: 'Int32'
                }
                sink: {
                  name: 'event_id'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'record'
                  type: 'String'
                  physicalType: 'VarChar'
                }
                sink: {
                  name: 'record'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              // ... remaining mappings unchanged
            ]
            typeConversion: true
            typeConversionSettings: {
              allowDataTruncation: true
              treatBooleanAsNumber: false
            }
          }
        }
        inputs: [
          {
            referenceName: 'redcap_data'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
        outputs: [
          {
            referenceName: 'redcap_data_sink'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      }
      {
        name: 'SQLServerToADLS'
        type: 'Copy'
        dependsOn: []
        policy: {
          timeout: '0.12:00:00'
          retry: 0
          retryIntervalInSeconds: 30
          secureOutput: false
          secureInput: false
        }
        userProperties: []
        typeProperties: {
          source: {
            type: 'SqlServerSource'
            sqlReaderQuery: {
              value: '/*\nThere are 3 different forms used. Those forms have zero, one, or multiple records for each Client. \nSo the output date field here is just the DateCreated of the client.\nThe query is getting the most recent answered response from the forms. \n*/\nWITH cteHIV_AIDS_Ranked AS (\n    SELECT \n        f128.SubjectID AS CLID,\n        REPLACE(f128.DoestheclientcurrentlyhaveHIVAIDS_9696, \'\'\'\', \'\') AS HIV_Status,\n        ROW_NUMBER() OVER (\n            PARTITION BY f128.SubjectID \n            ORDER BY \n                CASE \n                    WHEN f128.DoestheclientcurrentlyhaveHIVAIDS_9696 IS NULL THEN 1\n                    WHEN f128.DoestheclientcurrentlyhaveHIVAIDS_9696 = \'Data not collected\' THEN 2 \n                    ELSE 3 \n                END DESC,\n                f128.ResponseCreatedDate DESC\n        ) AS RowNum\n    FROM ETO.form.f_128 AS f128\n), cteDiabetesRanked AS (\n    SELECT \n        f281.SubjectID AS CLID,\n        f281.Diabetes_20523 AS Diabetes_Mellitus_Status,\n        ROW_NUMBER() OVER (\n            PARTITION BY f281.SubjectID \n            ORDER BY \n                CASE \n                    WHEN f281.Diabetes_20523 IS NULL THEN 1\n                    ELSE 3 \n                END DESC,\n                f281.ResponseCreatedDate DESC\n        ) AS RowNum\n    FROM ETO.form.f_281 AS f281\n), cteTuberculosisRanked AS (\n    SELECT \n        f281.SubjectID AS CLID,\n        f281.Tuberculosis_20534 AS TB_Symptoms,\n        ROW_NUMBER() OVER (\n            PARTITION BY f281.SubjectID \n            ORDER BY \n                CASE \n                    WHEN f281.Tuberculosis_20534 IS NULL THEN 1\n                    ELSE 3 \n                END DESC,\n                f281.ResponseCreatedDate DESC\n        ) AS RowNum\n    FROM ETO.form.f_281 AS f281\n), cteKidneyDiseaseRanked AS (\n    SELECT \n        f326.SubjectID AS CLID,\n        f326.Chronickidneydisease_28407 AS Chronic_Kidney_Disease_Requiring_Dialysis,\n        ROW_NUMBER() OVER (\n            PARTITION BY f326.SubjectID \n            ORDER BY \n                CASE \n                    WHEN f326.Chronickidneydisease_28407 IS NULL THEN 1\n                    WHEN f326.Chronickidneydisease_28407 = \'Data not collected\' THEN 2 \n                    ELSE 3 \n                END DESC,\n                f326.ResponseCreatedDate DESC\n        ) AS RowNum\n    FROM ETO.form.f_326 AS f326\n)\nSELECT\n    c.CLID,\n    c.Fname,\n    c.Lname,\n    c.DOB,\n    darn_lang.ArbitraryTextOrNumericValue AS PrimaryLanguage, \n    c.DateCreated,\n    f128.HIV_Status,\n    f281_d.Diabetes_Mellitus_Status,\n    f326.Chronic_Kidney_Disease_Requiring_Dialysis,\n    f281_t.TB_Symptoms, \n    c.CSiteID AS Project_ID,\n    s.Site AS Project_Name\nFROM ETO.dbo.Clients AS c\nLEFT JOIN cteHIV_AIDS_Ranked AS f128 ON f128.CLID = c.CLID AND f128.RowNum = 1\nLEFT JOIN cteDiabetesRanked AS f281_d ON f281_d.CLID = c.CLID AND f281_d.RowNum = 1\nLEFT JOIN cteKidneyDiseaseRanked AS f326 ON f326.CLID = c.CLID AND f326.RowNum = 1\nLEFT JOIN cteTuberculosisRanked AS f281_t ON f281_t.CLID = c.CLID AND f281_t.RowNum = 1\nLEFT JOIN ETO.dbo.Sites AS s ON c.CSiteID = s.SiteID\nLEFT JOIN ETO.dbo.ClCxDemographicArbitraryTextOrNumericValues AS darn_lang ON c.CLID = darn_lang.CLID AND darn_lang.CDID = 558\nWHERE c.CSiteID = 5\n'
            }
            sink: {
              type: 'DelimitedTextSink'
              storeSettings: {
                type: 'AzureBlobFSWriteSettings'
              }
              formatSettings: {
                type: 'DelimitedTextWriteSettings'
                quoteAllText: true
                fileExtension: '.txt'
              }
            }
            enableStaging: false
            translator: {
              type: 'TabularTranslator'
              mappings: [
                {
                  source: {
                    name: 'CaseNumber'
                    type: 'String'
                    physicalType: 'String'
                  }
                  sink: {
                    name: 'CaseNumber'
                    type: 'String'
                    physicalType: 'String'
                  }
                }
                // ... remaining mappings as before
              ]
              typeConversion: true
              typeConversionSettings: {
                allowDataTruncation: true
                treatBooleanAsNumber: false
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
      }
      {
        name: 'execADLS_Raw_To_ADLS_Processed'
        type: 'ExecutePipeline'
        dependsOn: [
          {
            activity: 'LTS_Clients_To_ADLS'
            dependencyConditions: [
              'Completed'
            ]
          }
          {
            activity: 'LTS_Staff_To_ADLS'
            dependencyConditions: [
              'Completed'
            ]
          }
          {
            activity: 'ETO_MHL_and_HSB_clients_To_ADLS'
            dependencyConditions: [
              'Completed'
            ]
          }
        ]
        policy: {
          secureInput: true
        }
        userProperties: []
        typeProperties: {
          pipeline: {
            referenceName: 'ADLS_Raw_To_ADLS_Processed'
            type: 'PipelineReference'
          }
          waitOnCompletion: true
          parameters: {}
        }
      }
    ]
    policy: {
      elapsedTimeMetric: {}
    }
    annotations: []
  }
  dependsOn: [
    factoryName_SharePoint_LTS_Clients,
    factoryName_Mass_Cass_Guest_Tracker_raw_sink,
    factoryName_SharePoint_LTS_Staff_Names,
    factoryName_User_Information_List_raw_sink,
    factoryName_SQLServerETOQuery,
    factoryName_SQLServer_ETO_Clients_raw_sink,
    factoryName_ADLS_Raw_To_ADLS_Processed
  ]
}

resource factoryName_DelimitedText1_temporary 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'DelimitedText1_temporary'
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
        fileName: 'temp_test.csv'
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
  dependsOn: [
    factoryName_ADLSGen2_NotSelfHosted_Feb1
  ]
}

resource factoryName_ETOToADLS_sink 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'ETOToADLS_sink'
  properties: {
    linkedServiceName: {
      referenceName: 'SecureLinkedServiceADLS'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: 'REDCap_related_ETO_data.csv'
        folderPath: 'raw/SQL_Server_ETO'
        fileSystem: 'redcap-idb-hsb'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: []
  }
  dependsOn: [
    factoryName_SecureLinkedServiceADLS
  ]
}

resource factoryName_Mass_Cass_Guest_Tracker_raw_sink 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'Mass_Cass_Guest_Tracker_raw_sink'
  properties: {
    linkedServiceName: {
      referenceName: 'SecureLinkedServiceADLS'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: 'lts_clients_Mass_Cass_Guest_Tracker.csv'
          type: 'Expression'
        }
        folderPath: 'raw/sp_lts'
        fileSystem: 'cib-referral-system'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        name: 'FileSystemObjectType'
        type: 'String'
      }
      {
        name: 'Id'
        type: 'String'
      }
      {
        name: 'ServerRedirectedEmbedUri'
        type: 'String'
      }
      {
        name: 'ServerRedirectedEmbedUrl'
        type: 'String'
      }
      {
        name: 'ID'
        type: 'String'
      }
      {
        name: 'ContentTypeId'
        type: 'String'
      }
      {
        name: 'Title'
        type: 'String'
      }
      {
        name: 'Modified'
        type: 'String'
      }
      {
        name: 'Created'
        type: 'String'
      }
      {
        name: 'AuthorId'
        type: 'String'
      }
      {
        name: 'EditorId'
        type: 'String'
      }
      {
        name: 'OData__UIVersionString'
        type: 'String'
      }
      {
        name: 'Attachments'
        type: 'String'
      }
      {
        name: 'GUID'
        type: 'String'
      }
      {
        name: 'ComplianceAssetId'
        type: 'String'
      }
      {
        name: 'shelter_id'
        type: 'String'
      }
      {
        name: 'Address'
        type: 'String'
      }
      {
        name: 'capacity'
        type: 'String'
      }
      {
        name: 'OData__ColorTag'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    factoryName_SecureLinkedServiceADLS
  ]
}

resource factoryName_SQLServerETOQuery 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'SQLServerETOQuery'
  properties: {
    description: 'Currently this points to a table, I\'m hoping to get a chance to use this but with a query in the Copy data action in my pipeline.'
    linkedServiceName: {
      referenceName: 'SqlServerETO'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'SqlServerTable'
    schema: []
    typeProperties: {
      schema: 'dbo'
      table: 'Clients'
    }
  }
  dependsOn: [
    factoryName_SqlServerETO
  ]
}

resource factoryName_SQLServerToADLS 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'SQLServerToADLS'
  properties: {
    linkedServiceName: {
      referenceName: 'SqlServerETO'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'SqlServerTable'
    schema: []
    typeProperties: {
      schema: 'dbo'
      table: 'Clients'
    }
  }
  dependsOn: [
    factoryName_SqlServerETO
  ]
}

resource factoryName_SQLServer_ETO_Clients_raw_sink 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'SQLServer_ETO_Clients_raw_sink'
  properties: {
    linkedServiceName: {
      referenceName: 'SecureLinkedServiceADLS'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: 'eto_MHL_and_HSB_clients.csv'
          type: 'Expression'
        }
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
  dependsOn: [
    factoryName_SecureLinkedServiceADLS
  ]
}

resource factoryName_SqlServerDMBPHCETO 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'SqlServerDMBPHCETO'
  properties: {
    linkedServiceName: {
      referenceName: 'SqlServerDMBPHCETO'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'SqlServerTable'
    schema: []
    typeProperties: {
      schema: 'dbo'
      table: 'vwDMI_CAFH'
    }
  }
  dependsOn: [
    factoryName_integrationRuntime1
  ]
}

resource factoryName_SharePoint_LTS_Clients 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'SharePoint_LTS_Clients'
  properties: {
    linkedServiceName: {
      referenceName: 'SharePointOnlineList_Jan28'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'SharePointOnlineListResource'
    schema: []
    typeProperties: {
      listName: 'MassCassGuestTracker'
    }
  }
  dependsOn: [
    factoryName_SharePointOnlineList_Jan28
  ]
}

resource factoryName_SharePoint_LTS_Shelter_Names 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'SharePoint_LTS_Shelter_Names'
  properties: {
    linkedServiceName: {
      referenceName: 'SharePointOnlineList_Jan28'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'SharePointOnlineListResource'
    schema: []
    typeProperties: {
      listName: 'Shelters'
    }
  }
  dependsOn: [
    factoryName_SharePointOnlineList_Jan28
  ]
}

resource factoryName_SharePoint_LTS_Staff_Names 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'SharePoint_LTS_Staff_Names'
  properties: {
    linkedServiceName: {
      referenceName: 'SharePointOnlineList_Jan28'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'SharePointOnlineListResource'
    schema: []
    typeProperties: {
      listName: 'UserInformationList'
    }
  }
  dependsOn: [
    factoryName_SharePointOnlineList_Jan28
  ]
}

resource factoryName_Shelters_raw_sink 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'Shelters_raw_sink'
  properties: {
    linkedServiceName: {
      referenceName: 'SecureLinkedServiceADLS'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: '@concat(\'lts_shelters_\', formatDateTime(utcNow(), \'yyyyMMdd_HHmm\'), \'.csv\')'
          type: 'Expression'
        }
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
  dependsOn: [
    factoryName_SecureLinkedServiceADLS
  ]
}

resource factoryName_SQL_Server_vwDMI_CAFH 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'SQL_Server_vwDMI_CAFH'
  properties: {
    linkedServiceName: {
      referenceName: 'SqlServerDMBPHCETO'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'SqlServerTable'
    schema: []
    typeProperties: {
      schema: 'dbo'
      table: 'vwDMI_CAFH'
    }
  }
  dependsOn: [
    factoryName_SqlServerDMBPHCETO
  ]
}

resource factoryName_User_Information_List_raw_sink 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'User_Information_List_raw_sink'
  properties: {
    linkedServiceName: {
      referenceName: 'SecureLinkedServiceADLS'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'DelimitedText'
    typeProperties: {
      location: {
        type: 'AzureBlobFSLocation'
        fileName: {
          value: 'lts_staff_User_Information_List.csv'
          type: 'Expression'
        }
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
  dependsOn: [
    factoryName_SecureLinkedServiceADLS
  ]
}

resource factoryName_clean_SpLts_Clients 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'clean_SpLts_Clients'
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
        fileName: 'clean_lts_client_data.csv'
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
  dependsOn: [
    factoryName_ADLSGen2_NotSelfHosted_Feb1
  ]
}

resource factoryName_raw_SpLts_Clients 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
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
    schema: [
      {
        name: 'ViewEdit'
        type: 'String'
      }
      {
        name: 'FirstName'
        type: 'String'
      }
      {
        name: 'LastName'
        type: 'String'
      }
      {
        name: 'SSNLast4'
        type: 'String'
      }
      {
        name: 'GuestStatusValue'
        type: 'String'
      }
      {
        name: 'DOB'
        type: 'String'
      }
      {
        name: 'EthnicityValue'
        type: 'String'
      }
      {
        name: 'GenderValue'
        type: 'String'
      }
      {
        name: 'ReferralSourceValue'
        type: 'String'
      }
      {
        name: 'AssignedShelter'
        type: 'String'
      }
      {
        name: 'BedAssignment'
        type: 'String'
      }
      {
        name: 'AdditionalNotes'
        type: 'String'
      }
      {
        name: 'UID'
        type: 'String'
      }
      {
        name: 'MOReason'
        type: 'String'
      }
      {
        name: 'Shelter_id'
        type: 'String'
      }
      {
        name: 'StartDate'
        type: 'String'
      }
      {
        name: 'EndDate'
        type: 'String'
      }
      {
        name: 'Id'
        type: 'String'
      }
      {
        name: 'ContentTypeID'
        type: 'String'
      }
      {
        name: 'ContentType'
        type: 'String'
      }
      {
        name: 'Modified'
        type: 'String'
      }
      {
        name: 'Created'
        type: 'String'
      }
      {
        name: 'CreatedById'
        type: 'String'
      }
      {
        name: 'ModifiedById'
        type: 'String'
      }
      {
        name: 'Owshiddenversion'
        type: 'String'
      }
      {
        name: 'Version'
        type: 'String'
      }
      {
        name: 'Path'
        type: 'String'
      }
      {
        name: 'ComplianceAssetId'
        type: 'String'
      }
      {
        name: 'ColorTag'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    factoryName_ADLSGen2_NotSelfHosted_Feb1
  ]
}

resource factoryName_raw_SpLts_Shelters 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'raw_SpLts_Shelters'
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
        fileName: 'lts_shelters_20250131_1825.csv'
        folderPath: 'raw/sp_lts'
        fileSystem: 'cib-referral-system'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: [
      {
        name: 'Id'
        type: 'String'
      }
      {
        name: 'ContentTypeID'
        type: 'String'
      }
      {
        name: 'ContentType'
        type: 'String'
      }
      {
        name: 'ShelterName'
        type: 'String'
      }
      {
        name: 'Modified'
        type: 'String'
      }
      {
        name: 'Created'
        type: 'String'
      }
      {
        name: 'CreatedById'
        type: 'String'
      }
      {
        name: 'ModifiedById'
        type: 'String'
      }
      {
        name: 'Owshiddenversion'
        type: 'String'
      }
      {
        name: 'Version'
        type: 'String'
      }
      {
        name: 'Path'
        type: 'String'
      }
      {
        name: 'ComplianceAssetId'
        type: 'String'
      }
      {
        name: 'Shelter_id'
        type: 'String'
      }
      {
        name: 'Address'
        type: 'String'
      }
      {
        name: 'Capacity'
        type: 'String'
      }
      {
        name: 'ColorTag'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    factoryName_ADLSGen2_NotSelfHosted_Feb1
  ]
}

resource factoryName_raw_SpLts_Staff 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
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
    schema: [
      {
        name: 'Name'
        type: 'String'
      }
      {
        name: 'EMail'
        type: 'String'
      }
      {
        name: 'IsSiteAdmin'
        type: 'String'
      }
      {
        name: 'Deleted'
        type: 'String'
      }
      {
        name: 'Department'
        type: 'String'
      }
      {
        name: 'JobTitle'
        type: 'String'
      }
      {
        name: 'FirstName'
        type: 'String'
      }
      {
        name: 'LastName'
        type: 'String'
      }
      {
        name: 'WorkPhone'
        type: 'String'
      }
      {
        name: 'UserName'
        type: 'String'
      }
      {
        name: 'Office'
        type: 'String'
      }
      {
        name: 'Id'
        type: 'String'
      }
      {
        name: 'Modified'
        type: 'String'
      }
      {
        name: 'Created'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    factoryName_ADLSGen2_NotSelfHosted_Feb1
  ]
}

resource factoryName_raw_SqlEto_Clients 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
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
    schema: [
      {
        name: 'CaseNumber'
        type: 'String'
      }
      {
        name: 'FirstName'
        type: 'String'
      }
      {
        name: 'LastName'
        type: 'String'
      }
      {
        name: 'DOB'
        type: 'String'
      }
      {
        name: 'Gender'
        type: 'String'
      }
      {
        name: 'ServiceStartDate'
        type: 'String'
      }
      {
        name: 'MostRecentDate'
        type: 'String'
      }
      {
        name: 'Site'
        type: 'String'
      }
      {
        name: 'CaseManager'
        type: 'String'
      }
      {
        name: 'Language'
        type: 'String'
      }
      {
        name: 'DataSource'
        type: 'String'
      }
      {
        name: 'ProgramInfo'
        type: 'String'
      }
    ]
  }
  dependsOn: [
    factoryName_ADLSGen2_NotSelfHosted_Feb1
  ]
}

resource factoryName_redcap_data 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'redcap_data'
  properties: {
    linkedServiceName: {
      referenceName: 'MySQL_REDCap'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'MySqlTable'
    schema: []
    typeProperties: {
      tableName: '`redcap_data`'
    }
  }
  dependsOn: [
    factoryName_MySQL_REDCap
  ]
}

resource factoryName_redcap_data_sink 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'redcap_data_sink'
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
        fileName: 'redcap_mysql_data.csv'
        folderPath: 'raw/MySQL'
        fileSystem: 'redcap-idb-hsb'
      }
      columnDelimiter: ','
      escapeChar: '\\'
      firstRowAsHeader: true
      quoteChar: '"'
    }
    schema: []
  }
  dependsOn: [
    factoryName_ADLSGen2_NotSelfHosted_Feb1
  ]
}

resource factoryName_sink_CIB_LTS_MHL_and_HSB_clients 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
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
  dependsOn: [
    factoryName_ADLSGen2_NotSelfHosted_Feb1
  ]
}

resource factoryName_AzureKeyVault_LinkedService 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: factory
  name: 'AzureKeyVault_LinkedService'
  properties: {
    description: 'Linked service for accessing secrets from the dmi-dev-keyvault in Data Factory using the managed identity of the data-modernization instance.'
    annotations: []
    type: 'AzureKeyVault'
    typeProperties: {
      baseUrl: AzureKeyVault_LinkedService_properties_typeProperties_baseUrl
    }
  }
}

resource factoryName_MySQL_REDCap 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: factory
  name: 'MySQL_REDCap'
  properties: {
    annotations: []
    type: 'MySql'
    typeProperties: {
      server: MySQL_REDCap_properties_typeProperties_server
      port: 3306
      database: MySQL_REDCap_properties_typeProperties_database
      username: MySQL_REDCap_properties_typeProperties_username
      sslMode: 0
      password: {
        type: 'SecureString'
        value: MySQL_REDCap_password
      }
      driverVersion: 'v2'
    }
    connectVia: {
      referenceName: 'integrationRuntime1'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    factoryName_integrationRuntime1
  ]
}

resource factoryName_SecureLinkedServiceADLS 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: factory
  name: 'SecureLinkedServiceADLS'
  properties: {
    description: 'Need a dataset for Sink. Want it to be ADLS in the vNet.'
    annotations: []
    type: 'AzureBlobFS'
    typeProperties: {
      url: SecureLinkedServiceADLS_properties_typeProperties_url
      accountKey: {
        type: 'SecureString'
        value: SecureLinkedServiceADLS_accountKey
      }
    }
    connectVia: {
      referenceName: 'integrationRuntime1'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    factoryName_integrationRuntime1
  ]
}

resource factoryName_SharePointOnlineList_Jan28 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: factory
  name: 'SharePointOnlineList_Jan28'
  properties: {
    description: 'Use Service Principal for SharePoint Online to bring in data from Low Threshold Sites.'
    annotations: []
    type: 'SharePointOnlineList'
    typeProperties: {
      siteUrl: 'https://bphc.sharepoint.com/sites/Guest-Registry'
      tenantId: 'ff5b5bc8-925b-471f-942a-eb176c03ab36'
      servicePrincipalId: SharePointOnlineList_Jan28_properties_typeProperties_servicePrincipalId
      servicePrincipalKey: {
        type: 'SecureString'
        value: SharePointOnlineList_Jan28_servicePrincipalKey
      }
      servicePrincipalCredentialType: 'ServicePrincipalKey'
    }
  }
}

resource factoryName_SqlServerDMBPHCETO 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: factory
  name: 'SqlServerDMBPHCETO'
  properties: {
    description: 'For connecting to views where the views pull data from tables in ETO or ETOHSS databases.'
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
        type: 'SecureString'
        value: SqlServerDMBPHCETO_password
      }
      alwaysEncryptedSettings: {
        alwaysEncryptedAkvAuthType: 'ManagedIdentity'
      }
    }
    connectVia: {
      referenceName: 'integrationRuntime1'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    factoryName_integrationRuntime1
  ]
}

resource factoryName_SqlServerETO 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: factory
  name: 'SqlServerETO'
  properties: {
    description: 'For querying or connecting to tables in ETO database.'
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
        type: 'SecureString'
        value: SqlServerETO_password
      }
      alwaysEncryptedSettings: {
        alwaysEncryptedAkvAuthType: 'ManagedIdentity'
      }
    }
    connectVia: {
      referenceName: 'integrationRuntime1'
      type: 'IntegrationRuntimeReference'
    }
  }
  dependsOn: [
    factoryName_integrationRuntime1
  ]
}

resource factoryName_dailyTrigger_CIB_LTS_MHL_and_HSB 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
  parent: factory
  name: 'dailyTrigger_CIB_LTS_MHL_and_HSB'
  properties: {
    description: 'once a day update the data from SharePoint Online and on-prem SQL Server to ADLS Gen2'
    annotations: []
    runtimeState: 'Stopped'
    pipelines: [
      {
        pipelineReference: {
          referenceName: 'Raw_to_ADLS'
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
  dependsOn: [
    factoryName_Raw_to_ADLS
  ]
}

resource factoryName_dailyTrigger_REDCap 'Microsoft.DataFactory/factories/triggers@2018-06-01' = {
  parent: factory
  name: 'dailyTrigger_REDCap'
  properties: {
    description: 'once a day update the data from MySQL and on-prem SQL Server to ADLS Gen2'
    annotations: []
    runtimeState: 'Started'
    pipelines: [
      {
        pipelineReference: {
          referenceName: 'MySQL_REDCap_and_ETO'
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
        startTime: '2025-02-13T11:42:00'
        timeZone: 'Eastern Standard Time'
      }
    }
  }
  dependsOn: [
    factoryName_MySQL_REDCap_and_ETO
  ]
}

resource factoryName_integrationRuntime1 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  parent: factory
  name: 'integrationRuntime1'
  properties: {
    type: 'SelfHosted'
    description: 'want to change the name to "IR-SQLServer-OnPrem" or something like that, but the easiest way is to use the ARM template, and even that would include lots of manual work, since i don\'t have proper access to the Key Vault yet :('
    typeProperties: {}
  }
}

resource factoryName_ETL_Data_for_CIB 'Microsoft.DataFactory/factories/dataflows@2018-06-01' = {
  parent: factory
  name: 'ETL_Data_for_CIB'
  properties: {
    description: 'Take the raw datasets for CIB Automate Referrals project, transform them, and put processed data back into ADLS Gen2.'
    type: 'MappingDataFlow'
    typeProperties: {
      sources: [
        {
          dataset: {
            referenceName: 'raw_SpLts_Staff'
            type: 'DatasetReference'
          }
          name: 'SpLtsStaff'
        }
        {
          dataset: {
            referenceName: 'raw_SpLts_Clients'
            type: 'DatasetReference'
          }
          name: 'SpLtsClients'
        }
        {
          dataset: {
            referenceName: 'raw_SqlEto_Clients'
            type: 'DatasetReference'
          }
          name: 'SqlEtoClients'
        }
      ]
      sinks: [
        {
          dataset: {
            referenceName: 'sink_CIB_LTS_MHL_and_HSB_clients'
            type: 'DatasetReference'
          }
          name: 'sinkCombinedClients'
          rejectedDataLinkedService: {
            referenceName: 'ADLSGen2_NotSelfHosted_Feb1'
            type: 'LinkedServiceReference'
          }
        }
      ]
      transformations: [
        {
          name: 'ClientsWithStaffFLName'
        }
        {
          name: 'ClientsWithStaffFullName'
        }
        {
          name: 'unionClients'
        }
        {
          name: 'selectLtsColumns'
        }
      ]
      scriptLines: [
        'source(output(',
        '          Name as string,',
        '          EMail as string,',
        '          IsSiteAdmin as string,',
        '          Deleted as string,',
        '          Department as string,',
        '          JobTitle as string,',
        '          FirstName as string,',
        '          LastName as string,',
        '          WorkPhone as string,',
        '          UserName as string,',
        '          Office as string,',
        '          Id as string,',
        '          Modified as string,',
        '          Created as string',
        '     ),',
        '     allowSchemaDrift: true,',
        '     validateSchema: false,',
        '     ignoreNoFilesFound: false,',
        '     partitionBy(\'hash\', 1)) ~> SpLtsStaff',
        'source(output(',
        '          ViewEdit as string,',
        '          FirstName as string,',
        '          LastName as string,',
        '          SSNLast4 as string,',
        '          GuestStatusValue as string,',
        '          DOB as date,',
        '          EthnicityValue as string,',
        '          GenderValue as string,',
        '          ReferralSourceValue as string,',
        '          AssignedShelter as string,',
        '          BedAssignment as string,',
        '          AdditionalNotes as string,',
        '          UID as string,',
        '          MOReason as string,',
        '          Shelter_id as string,',
        '          StartDate as timestamp,',
        '          EndDate as timestamp,',
        '          Id as string,',
        '          ContentTypeID as string,',
        '          ContentType as string,',
        '          Modified as timestamp,',
        '          Created as timestamp,',
        '          CreatedById as string,',
        '          ModifiedById as string,',
        '          Owshiddenversion as string,',
        '          Version as string,',
        '          Path as string,',
        '          ComplianceAssetId as string,',
        '          ColorTag as string',
        '     ),',
        '     allowSchemaDrift: true,',
        '     validateSchema: false,',
        '     ignoreNoFilesFound: false,',
        '     partitionBy(\'hash\', 1)) ~> SpLtsClients',
        'SpLtsClients, SpLtsStaff join(CreatedById == SpLtsStaff@Id,',
        '     joinType:\'left\',',
        '     matchType:\'exact\',',
        '     ignoreSpaces: false,',
        '     partitionBy(\'hash\', 1),',
        '     broadcast: \'auto\')~> ClientsWithStaffFLName',
        'ClientsWithStaffFLName derive(CaseManager = SpLtsStaff@FirstName + \' \' + SpLtsStaff@LastName,',
        '          Language = \'Not captured\',',
        '          ProgramInfo = \'\',',
        '          DataSource = \'LTS\',',
        '     partitionBy(\'hash\', 1)) ~> ClientsWithStaffFullName',
        'selectLtsColumns, SqlEtoClients union(byName: true,',
        '     partitionBy(\'hash\', 1))~> unionClients',
        'ClientsWithStaffFullName select(mapColumn(',
        '          CaseNumber = UID,',
        '          FirstName = SpLtsClients@FirstName,',
        '          LastName = SpLtsClients@LastName,',
        '          DOB,',
        '          Gender = GenderValue,',
        '          ServiceStartDate = StartDate,',
        '          MostRecentDate = EndDate,',
        '          Site = AssignedShelter,',
        '          CaseManager,',
        '          Language,',
        '          DataSource,',
        '          ProgramInfo',
        '     ),',
        '     skipDuplicateMapInputs: true,',
        '     skipDuplicateMapOutputs: true) ~> selectLtsColumns',
        'unionClients sink(allowSchemaDrift: true,',
        '     validateSchema: false,',
        '     partitionFileNames:[\'CIB_LTS_MHL_and_HSB_clients.csv\'],',
        '     umask: 0777,',
        '     preCommands: [],',
        '     postCommands: [],',
        '     mapColumn(',
        '          CaseNumber,',
        '          FirstName,',
        '          LastName,',
        '          DOB,',
        '          Gender,',
        '          ServiceStartDate,',
        '          MostRecentDate,',
        '          Site,',
        '          CaseManager,',
        '          Language,',
        '          DataSource,',
        '          ProgramInfo',
        '     ),',
        '     partitionBy(\'hash\', 1)) ~> sinkCombinedClients'
      ]
    }
  }
  dependsOn: []
}

resource factoryName_NormalizeClientsFlowlet 'Microsoft.DataFactory/factories/dataflows@2018-06-01' = {
  parent: factory
  name: 'NormalizeClientsFlowlet'
  properties: {
    description: 'This flowlet is for adding the normalized columns to the common column set.'
    type: 'Flowlet'
    typeProperties: {
      sources: []
      sinks: []
      transformations: [
        {
          name: 'DeriveNormalizedColumns'
        }
        {
          name: 'CommonClientColumns'
        }
        {
          name: 'CommonAndNormalized'
        }
      ]
      scriptLines: [
        'input(output(',
        '          CaseNumber as string,',
        '          Site as string,',
        '          FirstName as string,',
        '          LastName as string,',
        '          DOB as date,',
        '          Gender as string,',
        '          Language as string,',
        '          ServiceStartDate as timestamp,',
        '          CaseManager as string',
        '     ),',
        '     order: 0,',
        '     allowSchemaDrift: false) ~> CommonClientColumns',
        'CommonClientColumns derive(NormFirstName = upper( regexReplace( trim(FirstName), \'[^A-Za-z]\', \'\' )),' ,
        '          NormLastName = upper( regexReplace( trim(LastName), \'[^A-Za-z]\', \'\' )),' ,
        '          NormLanguage = trim( regexReplace( iif( isNull(Language), \'\', upper( regexReplace( replace(replace(trim(Language), \'-\', \' \'), \'/\', \' \'), \'(^\\s+|\\s+$|[^A-Za-z\\s])\', \'\') ) ), \'\\s+\', \' \' ) ) ,' ,
        '          NormGender = trim(regexReplace( iif(isNull(Gender), \'\', upper( regexReplace( trim(Gender), \'(^\\s+|\\s+$|[^A-Za-z\\s])\', \'\') ) ), \'\\s+\', \' \' )) ~> DeriveNormalizedColumns',
        'DeriveNormalizedColumns output() ~> CommonAndNormalized'
      ]
    }
  }
  dependsOn: []
}

resource factoryName_default 'Microsoft.DataFactory/factories/managedVirtualNetworks@2018-06-01' = {
  parent: factory
  name: 'default'
  properties: {}
  dependsOn: []
}

resource factoryName_default_ADF_to_ADLSGen2_devtestbphc 'Microsoft.DataFactory/factories/managedVirtualNetworks/managedPrivateEndpoints@2018-06-01' = {
  parent: factoryName_default
  name: 'ADF-to-ADLSGen2-devtestbphc'
  properties: {
    privateLinkResourceId: ADF_to_ADLSGen2_devtestbphc_properties_privateLinkResourceId
    groupId: ADF_to_ADLSGen2_devtestbphc_properties_groupId
  }
  dependsOn: [
    factoryName_default
  ]
}
