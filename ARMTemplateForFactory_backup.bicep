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
    '${factoryId}/dataflows/ETL_Data_for_CIB'
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
              {
                source: {
                  name: 'shelter_id'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'shelter_id'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'date_of_screening'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'date_of_screening'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'client_name'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'client_name'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'client_last_name'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'client_last_name'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'gender'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'gender'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'date_of_birth'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'date_of_birth'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'primary_language'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'primary_language'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'country_birth'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'country_birth'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'region_of_birth'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'region_of_birth'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'hiv_status'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'hiv_status'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'diabetes_mellitus_status'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'diabetes_mellitus_status'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'ckd_requiring_dialysis'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'ckd_requiring_dialysis'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'smokes_tobacco'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'smokes_tobacco'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'sympts_with_active_tb'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'sympts_with_active_tb'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'date1'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'date1'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'igra1'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'igra1'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'date2'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'date2'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'igra2'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'igra2'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'date3'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'date3'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'igra3'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'igra3'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'date4'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'date4'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'igra4'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'igra4'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'date5'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'date5'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'igra5'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'igra5'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'latest_cxr_date'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'latest_cxr_date'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'latest_cxr_result'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'latest_cxr_result'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'prior_chest_image'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'prior_chest_image'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'first_date_inshelter'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'first_date_inshelter'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'no_nights_exposureto_jlm'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'no_nights_exposureto_jlm'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'no_nights_exposureto_ffv'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'no_nights_exposureto_ffv'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'no_nights_exposureto_kr'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'no_nights_exposureto_kr'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'no_nights_exposureto_apn'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'no_nights_exposureto_apn'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'no_nights_exposureto_kft'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'no_nights_exposureto_kft'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'no_nights_exposureto_fcc'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'no_nights_exposureto_fcc'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'no_nights_exposureto_jc'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'no_nights_exposureto_jc'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'comments'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'comments'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'other_immunosuppression'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'other_immunosuppression'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'primary_care_location'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'primary_care_location'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'primary_care_provider'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'primary_care_provider'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'record_no'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'record_no'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'tb_clinic_record_complete'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'tb_clinic_record_complete'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'weight'
                  type: 'String'
                  physicalType: 'Text'
                }
                sink: {
                  name: 'weight'
                  type: 'String'
                  physicalType: 'String'
                }
              }
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
            sqlReaderQuery: '/*\nThere are 3 different forms used. Those forms have zero, one, or multiple records for each Client. \nSo the output date field here is just the DateCreated of the client.\nThe query is getting the most recent answered response from the forms. \n*/\nWITH cteHIV_AIDS_Ranked AS (\n    SELECT \n        f128.SubjectID AS CLID,\n        --f128.ResponseCreatedDate, \n        REPLACE(f128.DoestheclientcurrentlyhaveHIVAIDS_9696, \'\'\'\', \'\') AS HIV_Status, -- remove single quotes\n        --f128.ProgramID,\n        --f128.FormIdentifier,\n        ROW_NUMBER() OVER (\n            PARTITION BY f128.SubjectID \n            ORDER BY \n                CASE \n                    WHEN f128.DoestheclientcurrentlyhaveHIVAIDS_9696 IS NULL THEN 1\n                    WHEN f128.DoestheclientcurrentlyhaveHIVAIDS_9696 = \'Data not collected\' THEN 2 \n                    ELSE 3 \n                END DESC,  -- Highest priority first\n                f128.ResponseCreatedDate DESC  -- Most recent first\n        ) AS RowNum\n    FROM ETO.form.f_128 AS f128 -- non-null values include: "Client Doesn\'t Know" NOTE THE SINGLE QUOTE, \'Client refused\', \n                                --                          \'Client prefers not to answer\', \'Data not collected\', \'No\', and \'Yes\'\n), cteDiabetesRanked AS (\n    SELECT \n        f281.SubjectID AS CLID,\n        --f281.ResponseCreatedDate, \n        f281.Diabetes_20523 AS Diabetes_Mellitus_Status,\n        --f281.ProgramID,\n        --f281.FormIdentifier,\n        ROW_NUMBER() OVER (\n            PARTITION BY f281.SubjectID \n            ORDER BY \n                CASE \n                    WHEN f281.Diabetes_20523 IS NULL THEN 1\n                    --WHEN f281.Diabetes_20523 = \'Data not collected\' THEN 2 \n                    ELSE 3 \n                END DESC,  -- Highest priority first\n                f281.ResponseCreatedDate DESC  -- Most recent first\n        ) AS RowNum\n    FROM ETO.form.f_281 AS f281  -- non null values are \'Yes\', \'No\', \'Guest refused\', and \'Guest does not know\'\n), cteTuberculosisRanked AS (\n    SELECT \n        f281.SubjectID AS CLID,\n        --f281.ResponseCreatedDate, \n        f281.Tuberculosis_20534 AS TB_Symptoms,\n        --f281.ProgramID,\n        --f281.FormIdentifier,\n        ROW_NUMBER() OVER (\n            PARTITION BY f281.SubjectID \n            ORDER BY \n                CASE \n                    WHEN f281.Tuberculosis_20534 IS NULL THEN 1\n                    --WHEN f281.Tuberculosis_20534 = \'Data not collected\' THEN 2 \n                    ELSE 3 \n                END DESC,  -- Highest priority first\n                f281.ResponseCreatedDate DESC  -- Most recent first\n        ) AS RowNum\n    FROM ETO.form.f_281 AS f281 -- non null values are \'Yes\', \'No\', and \'Guest does not know\'\n), cteKidneyDiseaseRanked AS (\n    SELECT \n        f326.SubjectID AS CLID,\n        --f326.ResponseCreatedDate, \n        f326.Chronickidneydisease_28407 AS Chronic_Kidney_Disease_Requiring_Dialysis,\n        --f326.ProgramID,\n        --f326.FormIdentifier,\n        ROW_NUMBER() OVER (\n            PARTITION BY f326.SubjectID \n            ORDER BY \n                CASE \n                    WHEN f326.Chronickidneydisease_28407 IS NULL THEN 1\n                    WHEN f326.Chronickidneydisease_28407 = \'Data not collected\' THEN 2 \n                    ELSE 3 \n                END DESC,  -- Highest priority first\n                f326.ResponseCreatedDate DESC  -- Most recent first\n        ) AS RowNum\n    FROM ETO.form.f_326 AS f326 -- THIS TABLE HAS A TOTAL OF ONLY 15 RECORDS\n)\nSELECT\n    c.CLID,\n    c.Fname,\n    c.Lname,\n    c.DOB,\n    darn_lang.ArbitraryTextOrNumericValue AS PrimaryLanguage, \n    c.DateCreated,\n    f128.HIV_Status,\n    f281_d.Diabetes_Mellitus_Status,\n    f326.Chronic_Kidney_Disease_Requiring_Dialysis,\n    f281_t.TB_Symptoms, \n    c.CSiteID AS Project_ID,\n    s.Site AS Project_Name\nFROM ETO.dbo.Clients                AS c\nLEFT JOIN cteHIV_AIDS_Ranked        AS f128   ON f128.CLID = c.CLID   AND f128.RowNum = 1\nLEFT JOIN cteDiabetesRanked         AS f281_d ON f281_d.CLID = c.CLID AND f281_d.RowNum = 1\nLEFT JOIN cteKidneyDiseaseRanked    AS f326   ON f326.CLID = c.CLID   AND f326.RowNum = 1\nLEFT JOIN cteTuberculosisRanked     AS f281_t ON f281_t.CLID = c.CLID AND f281_t.RowNum = 1\nLEFT JOIN ETO.dbo.Sites             AS s      ON c.CSiteID = s.SiteID\nLEFT JOIN ETO.dbo.ClCxDemographicArbitraryTextOrNumericValues AS darn_lang ON  c.CLID = darn_lang.CLID\n                                                                           AND darn_lang.CDID = 558\nWHERE c.CSiteID = 5 --<--- Homeless Services\n;\n'
            queryTimeout: '02:00:00'
            partitionOption: 'None'
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
                  name: 'CLID'
                  type: 'Int32'
                  physicalType: 'int'
                }
                sink: {
                  name: 'CLID'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Fname'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'Fname'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Lname'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'Lname'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'DOB'
                  type: 'DateTime'
                  physicalType: 'smalldatetime'
                }
                sink: {
                  name: 'DOB'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'PrimaryLanguage'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'PrimaryLanguage'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'DateCreated'
                  type: 'DateTime'
                  physicalType: 'smalldatetime'
                }
                sink: {
                  name: 'DateCreated'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'HIV_Status'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'HIV_Status'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Diabetes_Mellitus_Status'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'Diabetes_Mellitus_Status'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Chronic_Kidney_Disease_Requiring_Dialysis'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'Chronic_Kidney_Disease_Requiring_Dialysis'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'TB_Symptoms'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'TB_Symptoms'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Project_ID'
                  type: 'Int16'
                  physicalType: 'smallint'
                }
                sink: {
                  name: 'Project_ID'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Project_Name'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'Project_Name'
                  type: 'String'
                  physicalType: 'String'
                }
              }
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
            referenceName: 'SQLServerToADLS'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
        outputs: [
          {
            referenceName: 'ETOToADLS_sink'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      }
    ]
    policy: {
      elapsedTimeMetric: {}
    }
    annotations: []
  }
  dependsOn: [
    '${factoryId}/datasets/redcap_data'
    '${factoryId}/datasets/redcap_data_sink'
    '${factoryId}/datasets/SQLServerToADLS'
    '${factoryId}/datasets/ETOToADLS_sink'
  ]
}

resource factoryName_Raw_to_ADLS 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  parent: factory
  name: 'Raw_to_ADLS'
  properties: {
    description: 'See if we can load data to ADLS from SharePoint Dataset. Some of the columns are not correct yet. Using "ColorTag" when I just need an empty column. '
    activities: [
      {
        name: 'LTS_Clients_To_ADLS'
        description: 'Move raw LTS Client Data from SharePoint Online to ADLS Gen2. Specifically the "Mass Cass Guest Tracker" list. Note that the CaseManager is non-trivial to identify if at all possible, and so is left out. '
        type: 'Copy'
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
          source: {
            type: 'SharePointOnlineListSource'
            query: '$select=UID,AssignedShelter,FirstName,LastName,DOB,Gender,Created,StartDate,EndDate'
            httpRequestTimeout: '00:05:00'
          }
          sink: {
            type: 'DelimitedTextSink'
            storeSettings: {
              type: 'AzureBlobFSWriteSettings'
              copyBehavior: 'FlattenHierarchy'
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
                  name: 'FirstName'
                  type: 'String'
                }
                sink: {
                  name: 'FirstName'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'LastName'
                  type: 'String'
                }
                sink: {
                  name: 'LastName'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'DOB'
                  type: 'DateTime'
                }
                sink: {
                  name: 'DOB'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'AssignedShelter'
                  type: 'String'
                }
                sink: {
                  name: 'AssignedShelter'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'UID'
                  type: 'Double'
                }
                sink: {
                  name: 'UID'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'StartDate'
                  type: 'DateTime'
                }
                sink: {
                  name: 'StartDate'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'EndDate'
                  type: 'DateTime'
                }
                sink: {
                  name: 'EndDate'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Created'
                  type: 'DateTime'
                }
                sink: {
                  name: 'Created'
                  type: 'String'
                  physicalType: 'String'
                }
              }
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
            referenceName: 'SharePoint_LTS_Clients'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
        outputs: [
          {
            referenceName: 'Mass_Cass_Guest_Tracker_raw_sink'
            type: 'DatasetReference'
            parameters: {}
          }
        ]
      }
      {
        name: 'LTS_Staff_To_ADLS'
        description: 'Move raw LTS Staff Names Data from SharePoint Online to ADLS Gen2. Specifically the "User Information List" list.'
        type: 'Copy'
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
          source: {
            type: 'SharePointOnlineListSource'
            query: '$select=Id,Name,Modified,Created,EMail,IsSiteAdmin,Deleted,Department,JobTitle,FirstName,LastName,WorkPhone,UserName,Office'
            httpRequestTimeout: '00:05:00'
          }
          sink: {
            type: 'DelimitedTextSink'
            storeSettings: {
              type: 'AzureBlobFSWriteSettings'
              copyBehavior: 'FlattenHierarchy'
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
                  name: 'Name'
                  type: 'String'
                }
                sink: {
                  name: 'Name'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'EMail'
                  type: 'String'
                }
                sink: {
                  name: 'EMail'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'IsSiteAdmin'
                  type: 'String'
                }
                sink: {
                  name: 'IsSiteAdmin'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Deleted'
                  type: 'Boolean'
                }
                sink: {
                  name: 'Deleted'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Department'
                  type: 'String'
                }
                sink: {
                  name: 'Department'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'JobTitle'
                  type: 'String'
                }
                sink: {
                  name: 'JobTitle'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'FirstName'
                  type: 'String'
                }
                sink: {
                  name: 'FirstName'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'LastName'
                  type: 'String'
                }
                sink: {
                  name: 'LastName'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'WorkPhone'
                  type: 'String'
                }
                sink: {
                  name: 'WorkPhone'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'UserName'
                  type: 'String'
                }
                sink: {
                  name: 'UserName'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Office'
                  type: 'String'
                }
                sink: {
                  name: 'Office'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Id'
                  type: 'Int32'
                }
                sink: {
                  name: 'Id'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Modified'
                  type: 'DateTime'
                }
                sink: {
                  name: 'Modified'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Created'
                  type: 'DateTime'
                }
                sink: {
                  name: 'Created'
                  type: 'String'
                  physicalType: 'String'
                }
              }
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
      }
      {
        name: 'ETO_MHL_and_HSB_clients_To_ADLS'
        description: 'Move raw queried ETO client data from SQL Server on-prem to ADLS Gen2. Specifically the MHL and HSB client data.'
        type: 'Copy'
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
          source: {
            type: 'SqlServerSource'
            sqlReaderQuery: {
              value: 'WITH LanguageCorrection AS (\n    SELECT \'polish\' AS IncorrectLanguage, \'Polish\' AS CorrectedLanguage\n    UNION ALL SELECT \'32514\', \'\'  -- do not judge, you were not there\n    UNION ALL SELECT \'44505\', \'\'\n    UNION ALL SELECT \'52803\', \'\'\n    UNION ALL SELECT \'85339\', \'\'\n    UNION ALL SELECT \'91301\', \'\'\n    UNION ALL SELECT \'3477382597\', \'\'\n    UNION ALL SELECT \'7744192012\', \'\'\n    UNION ALL SELECT \'7819210395\', \'\'\n    UNION ALL SELECT \'8573957115\', \'\'\n    UNION ALL SELECT \'9787027387\', \'\'\n    UNION ALL SELECT \' Haitian Creole\', \'Haitian Creole\'\n    UNION ALL SELECT \'\\English\', \'English\'\n    UNION ALL SELECT \'0000\', \'\'\n    UNION ALL SELECT \'00000\', \'\'\n    UNION ALL SELECT \'01760\', \'\'\n    UNION ALL SELECT \'02032\', \'\'\n    UNION ALL SELECT \'02118\', \'\'\n    UNION ALL SELECT \'02119\', \'\'\n    UNION ALL SELECT \'02121\', \'\'\n    UNION ALL SELECT \'02122\', \'\'\n    UNION ALL SELECT \'02124\', \'\'\n    UNION ALL SELECT \'02125\', \'\'\n    UNION ALL SELECT \'02127\', \'\'\n    UNION ALL SELECT \'02128\', \'\'\n    UNION ALL SELECT \'02132\', \'\'\n    UNION ALL SELECT \'02139\', \'\'\n    UNION ALL SELECT \'02150\', \'\'\n    UNION ALL SELECT \'02169\', \'\'\n    UNION ALL SELECT \'02184\', \'\'\n    UNION ALL SELECT \'02446\', \'\'\n    UNION ALL SELECT \'03038\', \'\'\n    UNION ALL SELECT \'34607-3913\', \'\'\n    UNION ALL SELECT \'617-416-9094 Johana in case of Emergency\', \'\'\n    UNION ALL SELECT \'978-881-8983 CELLULAR\', \'\'\n    UNION ALL SELECT \'Americain Sign Language\', \'American Sign Language\'\n    UNION ALL SELECT \'Arabic and English, French\', \'Arabic, English, French\'\n    UNION ALL SELECT \'Arabic, french,English\', \'Arabic, French, English\'\n    UNION ALL SELECT \'Arabic/French/English\', \'Arabic, French, English\'\n    UNION ALL SELECT \'ASL\', \'American Sign Language\'\n    UNION ALL SELECT \'ATTENTION: Alert in 5/1/2023, client needs to meet with Pedro ASAP.  Thank you.\', \'\'\n    UNION ALL SELECT \'boths english / spanish\', \'English, Spanish\'\n    UNION ALL SELECT \'Brazil\', \'Brazilian\'\n    UNION ALL SELECT \'Brazilian / Port\', \'Brazilian, Port\'\n    UNION ALL SELECT \'Call   Niece 781-808-8892\', \'\'\n    UNION ALL SELECT \'can\'\'t return until 12/21-22\', \'\'\n    UNION ALL SELECT \'Cape verde creol\', \'Cape Verde Creole\'\n    UNION ALL SELECT \'Cape Verdean\', \'Cape Verde Creole\'\n    UNION ALL SELECT \'Cape Verdean Creole and Portuguese\', \'Cape Verdean Creole, Portuguese\'\n    UNION ALL SELECT \'Client must see Leida Triage Ext:43045 prior to get a bed. 6/7/2022\', \'\'\n    UNION ALL SELECT \'Creol\', \'Creole\'\n    UNION ALL SELECT \'Creol french\', \'Creole, French\'\n    UNION ALL SELECT \'Creol french\', \'Creole, French\'\n    UNION ALL SELECT \'Creole \', \'Creole\'\n    UNION ALL SELECT \'CREOLE (FRENCH)\', \'Creole, French\'\n    UNION ALL SELECT \'Creole french\', \'Creole, French\'\n    UNION ALL SELECT \'Creole/ English\', \'Creole, English\'\n    UNION ALL SELECT \'Creole/English\', \'Creole, English\'\n    UNION ALL SELECT \'creole/french\', \'Creole, French\'\n    UNION ALL SELECT \'Creole/Spanish\', \'Creole, Spanish\'\n    UNION ALL SELECT \'Ebglish\', \'English\'\n    UNION ALL SELECT \'Eglish\', \'English\'\n    UNION ALL SELECT \'Egnlidh\', \'English\'\n    UNION ALL SELECT \'Einglish\', \'English\'\n    UNION ALL SELECT \'Emglish\', \'English\'\n    UNION ALL SELECT \'ENG\', \'English\'\n    UNION ALL SELECT \'Enghish\', \'English\'\n    UNION ALL SELECT \'Engilsh\', \'English\'\n    UNION ALL SELECT \'Engisg\', \'English\'\n    UNION ALL SELECT \'Engish\', \'English\'\n    UNION ALL SELECT \'engishl\', \'English\'\n    UNION ALL SELECT \'engliash\', \'English\'\n    UNION ALL SELECT \'Englidh\', \'English\'\n    UNION ALL SELECT \'Engliish\', \'English\'\n    UNION ALL SELECT \'Englis\', \'English\'\n    UNION ALL SELECT \'Englisg\', \'English\'\n    UNION ALL SELECT \'English & Spanish\', \'English, Spanish\'\n    UNION ALL SELECT \'english / asian\', \'English, Asian\'\n    UNION ALL SELECT \'English / Haitian Creole\', \'English, Haitian Creole\'\n    UNION ALL SELECT \'English / Spanish\', \'English, Spanish\'\n    UNION ALL SELECT \'english /african\', \'English, African\'\n    UNION ALL SELECT \'English /Portugese\', \'English, Portuguese\'\n    UNION ALL SELECT \'English and Arabic\', \'English, Arabic\'\n    UNION ALL SELECT \'English and Haitian Creole\', \'English, Haitian Creole\'\n    UNION ALL SELECT \'English and Korean\', \'English, Korean\'\n    UNION ALL SELECT \'English and Russian\', \'English, Russian\'\n    UNION ALL SELECT \'English and Spanish\', \'English, Spanish\'\n    UNION ALL SELECT \'English and Spanish \', \'English, Spanish\'\n    UNION ALL SELECT \'english, Hatian Creyole\', \'English, Haitian Creole\'\n    UNION ALL SELECT \'English/ Hatian Creole\', \'English, Haitian Creole\'\n    UNION ALL SELECT \'english/ philipino\', \'English, Filipino\'\n    UNION ALL SELECT \'English/ Spanish\', \'English, Spanish\'\n    UNION ALL SELECT \'ENGLISH/ SPANISH/MALAY\', \'English, Spanish, Malay\'\n    UNION ALL SELECT \'English/ spanish/portgues/creole\', \'English, Spanish, Portuguese, Creole\'\n    UNION ALL SELECT \'English/Cape Verdan Creole/Spanish\', \'English, Cape Verdean Creole, Spanish\'\n    UNION ALL SELECT \'english/french/ creole\', \'English, French, Creole\'\n    UNION ALL SELECT \'English/Haitian Creole\', \'English, Haitian Creole\'\n    UNION ALL SELECT \'English/Hatian Creole\', \'English, Haitian Creole\'\n    UNION ALL SELECT \'english/portuguese\', \'English, Portuguese\'\n    UNION ALL SELECT \'English/Sicilian\', \'English, Sicilian\'\n    UNION ALL SELECT \'English/Spanish\', \'English, Spanish\'\n    UNION ALL SELECT \'Englsih\', \'English\'\n    UNION ALL SELECT \'Enjglish\', \'English\'\n    UNION ALL SELECT \'Enlgish\', \'English\'\n    UNION ALL SELECT \'English\', \'English\'\n    UNION ALL SELECT \'ENLISH\', \'English\'\n    UNION ALL SELECT \'Evening\', \'\'\n    UNION ALL SELECT \'Farshid\', \'Farsi\'\n    UNION ALL SELECT \'French / Spanish\', \'French, Spanish\'\n    UNION ALL SELECT \'French /English\', \'French, English\'\n    UNION ALL SELECT \'french creol\', \'French Creole\'\n    UNION ALL SELECT \'French/ Creole\', \'French, Creole\'\n    UNION ALL SELECT \'French/ Hatian creole\', \'French, Haitian Creole\'\n    UNION ALL SELECT \'french/english\', \'French, English\'\n    UNION ALL SELECT \'French-Creole\', \'French Creole\'\n    UNION ALL SELECT \'Frensh\', \'French\'\n    UNION ALL SELECT \'Friends Floor 344\', \'\'\n    UNION ALL SELECT \'Gujaiati/Engilsh\', \'Gujarati, English\'\n    UNION ALL SELECT \'Haitain creloe\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haitain Creole\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haitain Creole & English\', \'Haitian Creole, English\'\n    UNION ALL SELECT \'Haitain Creole/Spanish\', \'Haitian Creole, Spanish\'\n    UNION ALL SELECT \'Haitan Creole\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haiti\', \'Haitian\'\n    UNION ALL SELECT \'Haiti creol\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haiti creole/ English\', \'Haitian Creole, English\'\n    UNION ALL SELECT \'Haiti Creolo\', \'Haitian Creole\'\n    UNION ALL SELECT \'HAITI CRIOLO\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haitian ceorle\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haitian creloe\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haitian Creol\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haitian Creole & Spanish\', \'Haitian Creole, Spanish\'\n    UNION ALL SELECT \'Haitian Creole / Spanish\', \'Haitian Creole, Spanish\'\n    UNION ALL SELECT \'Haitian Creole and English\', \'Haitian Creole, English\'\n    UNION ALL SELECT \'Haitian Creole and Spanish\', \'Haitian Creole, Spanish\'\n    UNION ALL SELECT \'Haitian Creole, Spanish, Portuguese and French\', \'Haitian Creole, Spanish, Portuguese, French\'\n    UNION ALL SELECT \'Haitian Creole/Spanish\', \'Haitian Creole, Spanish\'\n    UNION ALL SELECT \'Haitian Creole/Spanish \', \'Haitian Creole, Spanish\'\n    UNION ALL SELECT \'Haitian creole740649960\', \'Haitian Creole \'\n    UNION ALL SELECT \'Haitian creyole/english\', \'Haitian Creole, English\'\n    UNION ALL SELECT \'Haitian/ Spanish\', \'Haitian, Spanish\'\n    UNION ALL SELECT \'Haitian/Creole\', \'Haitian, Creole\'\n    UNION ALL SELECT \'Haitian/English\', \'Haitian, English\'\n    UNION ALL SELECT \'Haitian/Spanish\', \'Haitian, Spanish\'\n    UNION ALL SELECT \'Haitian-Creole\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haitian-Creole and English\', \'Haitian Creole, English\'\n    UNION ALL SELECT \'Haitiean Creole\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haitien Creole\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haitine creole\', \'Haitian Creole\'\n    UNION ALL SELECT \'Haiutian Creole\', \'Haitian Creole\'\n    UNION ALL SELECT \'Hatian Creole\', \'Haitian Creole\'\n    UNION ALL SELECT \'Hatien\', \'Haitian\'\n    UNION ALL SELECT \'Hearing imparied\', \'Hearing impaired\'\n    UNION ALL SELECT \'IMPORTANT!!!!!!  PLEASE HAVE CLIENT SEE TORRY BEFORE GETTING A BED 12/23/2023!!!!!!!!!\', \'\'\n    UNION ALL SELECT \'Mahric\', \'Amharic\'\n    UNION ALL SELECT \'marklachapelle00@gtmaiol.com\', \'\'\n    UNION ALL SELECT \'Nebali\', \'Nepali\'\n    UNION ALL SELECT \'Not Allowed In The Shelter till 11:00 PM 1/12/2021!\', \'\'\n    UNION ALL SELECT \'Pashto/ English\', \'Pashto, English\'\n    UNION ALL SELECT \'PLEASE SEE THE PEER SUPPORT ILDO SANTOS AT THE OFFICES N: 129\', \'\'\n    UNION ALL SELECT \'Portguese\', \'Portuguese\'\n    UNION ALL SELECT \'Portugese\', \'Portuguese\'\n    UNION ALL SELECT \'Portugues\', \'Portuguese\'\n    UNION ALL SELECT \'PORTUGUES and SPANISH \', \'Portuguese, Spanish\'\n    UNION ALL SELECT \'Portuguese \', \'Portuguese\'\n    UNION ALL SELECT \'Portuguese Ceole\', \'Portuguese, Creole\'\n    UNION ALL SELECT \'Portuguese/engish\', \'Portuguese, English\'\n    UNION ALL SELECT \'Portuguese/Spanish\', \'Portuguese, Spanish\'\n    UNION ALL SELECT \'Portuguess\', \'Portuguese\'\n    UNION ALL SELECT \'portugwese\', \'Portuguese\'\n    UNION ALL SELECT \'Poruguese\', \'Portuguese\'\n    UNION ALL SELECT \'Russian/English\', \'Russian, English\'\n    UNION ALL SELECT \'SIGN LANGUAGE...English,\', \'Sign Language, English\'\n    UNION ALL SELECT \'Sign launge\', \'Sign Language\'\n    UNION ALL SELECT \'Somalai\', \'Somalian\'\n    UNION ALL SELECT \'somali\', \'Somalian\'\n    UNION ALL SELECT \'span /eng\', \'Spanish, English\'\n    UNION ALL SELECT \'spanish  do not understand English\', \'Spanish, do not understand English\'\n    UNION ALL SELECT \'Spanish ,english\', \'Spanish, English\'\n    UNION ALL SELECT \'Spanish / French\', \'Spanish, French\'\n    UNION ALL SELECT \'Spanish / MUTE\', \'Spanish, MUTE\'\n    UNION ALL SELECT \'Spanish and English\', \'Spanish, English\'\n    UNION ALL SELECT \'Spanish or Creole\', \'Spanish, Creole\'\n    UNION ALL SELECT \'Spanish portugese\', \'Spanish, Portuguese\'\n    UNION ALL SELECT \'Spanish.\', \'Spanish\'\n    UNION ALL SELECT \'Spanish\', \'Spanish\'\n    UNION ALL SELECT \'Spanish.  \', \'Spanish\'\n    UNION ALL SELECT \'Spanish/ Creole\', \'Spanish, Creole\'\n    UNION ALL SELECT \'Spanish/ english\', \'Spanish, English\'\n    UNION ALL SELECT \'Spanish/ Haiti creol\', \'Spanish, Haitian Creole\'\n    UNION ALL SELECT \'Spanish/ Haitian creole\', \'Spanish, Haitian Creole\'\n    UNION ALL SELECT \'spanish/creole\', \'Spanish, Creole\'\n    UNION ALL SELECT \'SPANISH/ENGLISH\', \'Spanish, English\'\n    UNION ALL SELECT \'Spanish-English-Chinese\', \'Spanish, English, Chinese\'\n    UNION ALL SELECT \'Spansih\', \'Spanish\'\n    UNION ALL SELECT \'Spnish\', \'Spanish\'\n    UNION ALL SELECT \'Tahmoush61@gmail.com\', \'\'\n    UNION ALL SELECT \'Vietnamese & Cambodian\', \'Vietnamese, Cambodian\'\n    UNION ALL SELECT \'Woloff\', \'Wolof\'\n    UNION ALL SELECT \'Arabic but speaks english\', \'Arabic but speaks English\'\n    UNION ALL SELECT \'bangoli\', \'Bangoli\'\n    UNION ALL SELECT \'bosnian\', \'Bosnian\'\n    UNION ALL SELECT \'BRAZILIAN\', \'Brazilian\'\n    UNION ALL SELECT \'creole\', \'Creole\'\n    UNION ALL SELECT \'english\', \'English\'\n    UNION ALL SELECT \'haitian\', \'Haitian\'\n    UNION ALL SELECT \'other\', \'Other\'\n    UNION ALL SELECT \'polish\', \'Polish\'\n    UNION ALL SELECT \'punjabi\', \'Punjabi\'\n    UNION ALL SELECT \'somalian\', \'Somalian\'\n    UNION ALL SELECT \'urdu\', \'Urdu\'\n), cteGender AS \n(\n    SELECT\n        c.CLID,\n        CASE \n            WHEN ddtv.TextValue = \'Man (Boy, if child)\'          THEN \'MALE\'\n            WHEN ddtv.TextValue = \'Woman (Girl, if child)\'       THEN \'FEMALE\'\n            WHEN ddtv.TextValue = \'Client prefers not to answer\' THEN \'Prefers not to answer\'\n            WHEN ddtv.TextValue = \'Client Doesn\'\'t Know\'         THEN \'Client does not know\'\n            WHEN ddtv.TextValue = \'Culturally Specific Identity (e.g., Two-Spirit)\' THEN \'Culturally specific identity\'\n            ELSE ddtv.TextValue -- Retain other values\n        END AS Gender\n    FROM ETO.dbo.Clients                                  AS c\n    INNER JOIN ETO.dbo.ClCxDemographicNoneExclusiveValues AS dnev ON c.CLID = dnev.CLID\n    INNER JOIN ETO.dbo.CxDemographicsDefinedTextValues    AS ddtv ON dnev.CDDTVID = ddtv.CDDTVID\n    INNER JOIN ETO.dbo.CxDemographics                     AS d    ON ddtv.CDID = d.CDID\n    WHERE ddtv.cdid = 1 --Gender (HUD)\n      AND ddtv.Disabled = 0\n)\nSELECT -- client granularity\n    c.CLID AS CaseNumber,  -- Samples for testing: 104080, 104678, 106999\n    c.FName AS FirstName,\n    c.LName AS LastName, \n    CAST(c.DOB AS DATE) AS DOB,\n    g.Gender, -- Clients table has a Gender column, but completely null, so use this\n    c.DateCreated AS ServiceStartDate,\n    c.AuditDate AS MostRecentDate, -- needs to be corrected\n    s.Site,\n    \'\' AS CaseManager, \n    COALESCE(lc.CorrectedLanguage, darn_lang.ArbitraryTextOrNumericValue, \'\') AS Language,  -- Primary Language Spoken\n    \'ETO\' AS DataSource,\n    (\n        SELECT\n            p.ProgramName,\n            CAST(cxp.ProgramStartDate AS date) AS StartDate,\n            CAST(cxp.EndDate AS date) AS EndDate\n        FROM ETO.dbo.ClientsXPrograms   AS cxp\n        INNER JOIN ETO.dbo.Programs     AS p   ON cxp.ProgramID = p.ProgramID\n        WHERE cxp.CLID = c.CLID\n        FOR JSON PATH\n    ) AS ProgramInfo\nFROM ETO.dbo.Clients            AS c\nLEFT JOIN ETO.dbo.Sites         AS s   ON c.CSiteID = s.SiteID\nLEFT JOIN cteGender             AS g   ON c.CLID = g.CLID\nLEFT JOIN ETO.dbo.ClCxDemographicArbitraryTextOrNumericValues AS darn_lang ON  c.CLID = darn_lang.CLID\n                                                                           AND darn_lang.CDID = 558\nLEFT JOIN LanguageCorrection AS lc  ON lc.IncorrectLanguage = ISNULL(darn_lang.ArbitraryTextOrNumericValue, \'\')\nWHERE c.CSiteID IN (5, 15) -- Homeless Services and MHL   \n;'
              type: 'Expression'
            }
            queryTimeout: '02:00:00'
            partitionOption: 'None'
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
                  type: 'Int32'
                  physicalType: 'int'
                }
                sink: {
                  name: 'CaseNumber'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'FirstName'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'FirstName'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'LastName'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'LastName'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'DOB'
                  type: 'DateTime'
                  physicalType: 'date'
                }
                sink: {
                  name: 'DOB'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Gender'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'Gender'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'ServiceStartDate'
                  type: 'DateTime'
                  physicalType: 'smalldatetime'
                }
                sink: {
                  name: 'ServiceStartDate'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'MostRecentDate'
                  type: 'DateTime'
                  physicalType: 'datetime'
                }
                sink: {
                  name: 'MostRecentDate'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Site'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'Site'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'CaseManager'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'CaseManager'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'Language'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'Language'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'DataSource'
                  type: 'String'
                  physicalType: 'varchar'
                }
                sink: {
                  name: 'DataSource'
                  type: 'String'
                  physicalType: 'String'
                }
              }
              {
                source: {
                  name: 'ProgramInfo'
                  type: 'String'
                  physicalType: 'nvarchar'
                }
                sink: {
                  name: 'ProgramInfo'
                  type: 'String'
                  physicalType: 'String'
                }
              }
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
    '${factoryId}/datasets/SharePoint_LTS_Clients'
    '${factoryId}/datasets/Mass_Cass_Guest_Tracker_raw_sink'
    '${factoryId}/datasets/SharePoint_LTS_Staff_Names'
    '${factoryId}/datasets/User_Information_List_raw_sink'
    '${factoryId}/datasets/SQLServerETOQuery'
    '${factoryId}/datasets/SQLServer_ETO_Clients_raw_sink'
    '${factoryId}/pipelines/ADLS_Raw_To_ADLS_Processed'
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
    '${factoryId}/linkedServices/ADLSGen2_NotSelfHosted_Feb1'
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
    '${factoryId}/linkedServices/SecureLinkedServiceADLS'
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
    '${factoryId}/linkedServices/SecureLinkedServiceADLS'
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
    '${factoryId}/linkedServices/SqlServerETO'
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
    '${factoryId}/linkedServices/SqlServerETO'
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
    '${factoryId}/linkedServices/SecureLinkedServiceADLS'
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
    '${factoryId}/linkedServices/SqlServerDMBPHCETO'
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
    '${factoryId}/linkedServices/SharePointOnlineList_Jan28'
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
    '${factoryId}/linkedServices/SharePointOnlineList_Jan28'
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
    '${factoryId}/linkedServices/SharePointOnlineList_Jan28'
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
    '${factoryId}/linkedServices/SecureLinkedServiceADLS'
  ]
}

resource factoryName_SqlServerTableClients 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: factory
  name: 'SqlServerTableClients'
  properties: {
    linkedServiceName: {
      referenceName: 'SqlServerETO'
      type: 'LinkedServiceReference'
    }
    annotations: []
    type: 'SqlServerTable'
    schema: [
      {
        name: 'CLID'
        type: 'int'
        precision: 10
      }
      {
        name: 'SSN'
        type: 'char'
      }
      {
        name: 'CaseNumber'
        type: 'varchar'
      }
      {
        name: 'FName'
        type: 'varchar'
      }
      {
        name: 'MiddleInitial'
        type: 'varchar'
      }
      {
        name: 'LName'
        type: 'varchar'
      }
      {
        name: 'Disabled'
        type: 'bit'
      }
      {
        name: 'PrefixID'
        type: 'smallint'
        precision: 5
      }
      {
        name: 'SuffixID'
        type: 'smallint'
        precision: 5
      }
      {
        name: 'EthnicityID'
        type: 'smallint'
        precision: 5
      }
      {
        name: 'DOB'
        type: 'smalldatetime'
        precision: 16
        scale: 0
      }
      {
        name: 'Address1'
        type: 'varchar'
      }
      {
        name: 'Address2'
        type: 'varchar'
      }
      {
        name: 'ZipCode'
        type: 'varchar'
      }
      {
        name: 'HomePhone'
        type: 'varchar'
      }
      {
        name: 'CellPhone'
        type: 'varchar'
      }
      {
        name: 'WorkPhone'
        type: 'varchar'
      }
      {
        name: 'WorkPhoneExtension'
        type: 'varchar'
      }
      {
        name: 'Pager'
        type: 'varchar'
      }
      {
        name: 'Email'
        type: 'varchar'
      }
      {
        name: 'Gender'
        type: 'bit'
      }
      {
        name: 'MaritalStatusID'
        type: 'smallint'
        precision: 5
      }
      {
        name: 'FundingEntityID'
        type: 'int'
        precision: 10
      }
      {
        name: 'ReferralEntityID'
        type: 'int'
        precision: 10
      }
      {
        name: 'AuditStaffID'
        type: 'int'
        precision: 10
      }
      {
        name: 'AuditDate'
        type: 'datetime'
        precision: 23
        scale: 3
      }
      {
        name: 'AssignedStaffID'
        type: 'int'
        precision: 10
      }
      {
        name: 'DateCreated'
        type: 'smalldatetime'
        precision: 16
        scale: 0
      }
      {
        name: 'Alert'
        type: 'varchar'
      }
      {
        name: 'ClientGUID'
        type: 'uniqueidentifier'
      }
      {
        name: 'TigerID'
        type: 'bigint'
        precision: 19
      }
      {
        name: 'CensusTract'
        type: 'char'
      }
      {
        name: 'CensusBlock'
        type: 'char'
      }
      {
        name: 'CLID_Source'
        type: 'int'
        precision: 10
      }
      {
        name: 'ZipExtension'
        type: 'char'
      }
      {
        name: 'HoR_ID'
        type: 'int'
        precision: 10
      }
      {
        name: 'HoR_ChildID'
        type: 'int'
        precision: 10
      }
      {
        name: 'HoR_BID'
        type: 'int'
        precision: 10
      }
      {
        name: 'HoR_IDAbuser'
        type: 'int'
        precision: 10
      }
      {
        name: 'HoR_VID'
        type: 'int'
        precision: 10
      }
      {
        name: 'OptOut'
        type: 'bit'
      }
      {
        name: 'ReferralNotification'
        type: 'bit'
      }
      {
        name: 'CSiteID'
        type: 'smallint'
        precision: 5
      }
    ]
    typeProperties: {
      schema: 'dbo'
      table: 'Clients'
    }
  }
  dependsOn: [
    '${factoryId}/linkedServices/SqlServerETO'
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
    '${factoryId}/linkedServices/SecureLinkedServiceADLS'
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
    '${factoryId}/linkedServices/ADLSGen2_NotSelfHosted_Feb1'
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
    '${factoryId}/linkedServices/ADLSGen2_NotSelfHosted_Feb1'
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
    '${factoryId}/linkedServices/ADLSGen2_NotSelfHosted_Feb1'
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
    '${factoryId}/linkedServices/ADLSGen2_NotSelfHosted_Feb1'
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
    '${factoryId}/linkedServices/ADLSGen2_NotSelfHosted_Feb1'
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
    '${factoryId}/linkedServices/MySQL_REDCap'
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
    '${factoryId}/linkedServices/ADLSGen2_NotSelfHosted_Feb1'
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
    '${factoryId}/linkedServices/ADLSGen2_NotSelfHosted_Feb1'
  ]
}

resource factoryName_ADLSGen2_NotSelfHosted_Feb1 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: factory
  name: 'ADLSGen2_NotSelfHosted_Feb1'
  properties: {
    description: 'Because I get this message in Azure Data Factory, "Linked service with self-hosted integration runtime is not supported in data flow." I\'m trying to create a linked service that uses "NotSelfHostedIrForADLS (Managed Virtual Network)".'
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
  dependsOn: [
    '${factoryId}/integrationRuntimes/NotSelfHostedIrForADLS'
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
  dependsOn: []
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
    '${factoryId}/integrationRuntimes/integrationRuntime1'
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
    '${factoryId}/integrationRuntimes/integrationRuntime1'
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
  dependsOn: []
}

resource factoryName_SqlServerDMBPHCETO 'Microsoft.DataFactory/factories/linkedServices@2018-06-01' = {
  parent: factory
  name: 'SqlServerDMBPHCETO'
  properties: {
    description: 'For connecting to views where the views pull data from tables in ETO or ETOHSS databases. '
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
    '${factoryId}/integrationRuntimes/integrationRuntime1'
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
    '${factoryId}/integrationRuntimes/integrationRuntime1'
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
    '${factoryId}/pipelines/Raw_to_ADLS'
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
    '${factoryId}/pipelines/MySQL_REDCap_and_ETO'
  ]
}

resource factoryName_NotSelfHostedIrForADLS 'Microsoft.DataFactory/factories/integrationRuntimes@2018-06-01' = {
  parent: factory
  name: 'NotSelfHostedIrForADLS'
  properties: {
    type: 'Managed'
    description: 'Need an appropriate IR for connecting to ADLS Gen2 in a Data flow since, "Linked service with self-hosted integration runtime is not supported in data flow."'
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
  dependsOn: [
    '${factoryId}/managedVirtualNetworks/default'
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
        'source(output('
        '          Name as string,'
        '          EMail as string,'
        '          IsSiteAdmin as string,'
        '          Deleted as string,'
        '          Department as string,'
        '          JobTitle as string,'
        '          FirstName as string,'
        '          LastName as string,'
        '          WorkPhone as string,'
        '          UserName as string,'
        '          Office as string,'
        '          Id as string,'
        '          Modified as string,'
        '          Created as string'
        '     ),'
        '     allowSchemaDrift: true,'
        '     validateSchema: false,'
        '     ignoreNoFilesFound: false,'
        '     partitionBy(\'hash\', 1)) ~> SpLtsStaff'
        'source(output('
        '          ViewEdit as string,'
        '          FirstName as string,'
        '          LastName as string,'
        '          SSNLast4 as string,'
        '          GuestStatusValue as string,'
        '          DOB as date,'
        '          EthnicityValue as string,'
        '          GenderValue as string,'
        '          ReferralSourceValue as string,'
        '          AssignedShelter as string,'
        '          BedAssignment as string,'
        '          AdditionalNotes as string,'
        '          UID as string,'
        '          MOReason as string,'
        '          Shelter_id as string,'
        '          StartDate as timestamp,'
        '          EndDate as timestamp,'
        '          Id as string,'
        '          ContentTypeID as string,'
        '          ContentType as string,'
        '          Modified as timestamp,'
        '          Created as timestamp,'
        '          CreatedById as string,'
        '          ModifiedById as string,'
        '          Owshiddenversion as string,'
        '          Version as string,'
        '          Path as string,'
        '          ComplianceAssetId as string,'
        '          ColorTag as string'
        '     ),'
        '     allowSchemaDrift: true,'
        '     validateSchema: false,'
        '     ignoreNoFilesFound: false,'
        '     partitionBy(\'hash\', 1)) ~> SpLtsClients'
        'source(output('
        '          CaseNumber as string,'
        '          FirstName as string,'
        '          LastName as string,'
        '          DOB as date,'
        '          Gender as string,'
        '          ServiceStartDate as timestamp,'
        '          MostRecentDate as timestamp,'
        '          Site as string,'
        '          CaseManager as string,'
        '          Language as string,'
        '          DataSource as string,'
        '          ProgramInfo as string'
        '     ),'
        '     allowSchemaDrift: true,'
        '     validateSchema: false,'
        '     ignoreNoFilesFound: false,'
        '     partitionBy(\'hash\', 1)) ~> SqlEtoClients'
        'SpLtsClients, SpLtsStaff join(CreatedById == SpLtsStaff@Id,'
        '     joinType:\'left\','
        '     matchType:\'exact\','
        '     ignoreSpaces: false,'
        '     partitionBy(\'hash\', 1),'
        '     broadcast: \'auto\')~> ClientsWithStaffFLName'
        'ClientsWithStaffFLName derive(CaseManager = SpLtsStaff@FirstName + \' \' + SpLtsStaff@LastName,'
        '          Language = \'Not captured\','
        '          ProgramInfo = \'\','
        '          DataSource = \'LTS\','
        '     partitionBy(\'hash\', 1)) ~> ClientsWithStaffFullName'
        'selectLtsColumns, SqlEtoClients union(byName: true,'
        '     partitionBy(\'hash\', 1))~> unionClients'
        'ClientsWithStaffFullName select(mapColumn('
        '          CaseNumber = UID,'
        '          FirstName = SpLtsClients@FirstName,'
        '          LastName = SpLtsClients@LastName,'
        '          DOB,'
        '          Gender = GenderValue,'
        '          ServiceStartDate = StartDate,'
        '          MostRecentDate = EndDate,'
        '          Site = AssignedShelter,'
        '          CaseManager,'
        '          Language,'
        '          DataSource,'
        '          ProgramInfo'
        '     ),'
        '     skipDuplicateMapInputs: true,'
        '     skipDuplicateMapOutputs: true) ~> selectLtsColumns'
        'unionClients sink(allowSchemaDrift: true,'
        '     validateSchema: false,'
        '     partitionFileNames:[\'CIB_LTS_MHL_and_HSB_clients.csv\'],'
        '     umask: 0777,'
        '     preCommands: [],'
        '     postCommands: [],'
        '     mapColumn('
        '          CaseNumber,'
        '          FirstName,'
        '          LastName,'
        '          DOB,'
        '          Gender,'
        '          ServiceStartDate,'
        '          MostRecentDate,'
        '          Site,'
        '          CaseManager,'
        '          Language,'
        '          DataSource,'
        '          ProgramInfo'
        '     ),'
        '     partitionBy(\'hash\', 1)) ~> sinkCombinedClients'
      ]
    }
  }
  dependsOn: [
    '${factoryId}/datasets/raw_SpLts_Staff'
    '${factoryId}/datasets/raw_SpLts_Clients'
    '${factoryId}/datasets/raw_SqlEto_Clients'
    '${factoryId}/datasets/sink_CIB_LTS_MHL_and_HSB_clients'
    '${factoryId}/linkedServices/ADLSGen2_NotSelfHosted_Feb1'
  ]
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
        'input(output('
        '          CaseNumber as string,'
        '          Site as string,'
        '          FirstName as string,'
        '          LastName as string,'
        '          DOB as date,'
        '          Gender as string,'
        '          Language as string,'
        '          ServiceStartDate as timestamp,'
        '          CaseManager as string'
        '     ),'
        '     order: 0,'
        '     allowSchemaDrift: false) ~> CommonClientColumns'
        'CommonClientColumns derive(NormFirstName = upper( regexReplace( trim(FirstName), \'[^A-Za-z]\', \'\' )),'
        '          NormLastName = upper( regexReplace( trim(LastName), \'[^A-Za-z]\', \'\' )),'
        '          NormLanguage = trim(\r'
        '    regexReplace(\r'
        '        iif(\r'
        '            isNull(Language),\r'
        '            \'\',\r'
        '            upper(\r'
        '                regexReplace(\r'
        '                    replace(replace(trim(Language), \'-\', \' \'), \'/\', \' \'),\r'
        '                    \'(^\\\\s+|\\\\s+$|[^A-Za-z\\\\s])\',\r'
        '                    \'\'\r'
        '                )\r'
        '            )\r'
        '        ),\r'
        '        \'\\\\s+\',\r'
        '        \' \'\r'
        '    )\r'
        '),'
        '          NormGender = trim(regexReplace(iif(isNull(Gender), \'\', upper( regexReplace( trim(Gender), \'(^\\\\s+|\\\\s+$|[^A-Za-z\\\\s])\', \'\' ))), \'\\\\s+\', \' \'))) ~> DeriveNormalizedColumns'
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
    '${factoryId}/managedVirtualNetworks/default'
  ]
}


