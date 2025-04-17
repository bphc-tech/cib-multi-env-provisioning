// ==========================================================
// Monitoring Module
// This module creates alerts for Azure Data Factory and related resources.
// It defines a metric alert for ADF action failures and activity log alerts
// for ADF pipeline failures as well as for other resource failures.
// ==========================================================

@description('Name for the metric alert to monitor ADF action failures.')
param metricAlertADFActionFailureName string

@description('Name for the activity log alert to monitor ADF pipeline failures.')
param activityLogAlertADFPipelineFailureName string

@description('Name for the activity log alert for the Devdatabphc resource.')
param activityLogAlertDevdatabphcName string

@description('Name for the activity log alert for the Storage Account.')
param activityLogAlertSaName string

@description('Name for the activity log alert for the Virtual Network.')
param activityLogAlertVNetName string

@description('Location for the alerts (typically global).')
param location string = 'global'

@description('Resource ID to use as the scope for the alerts.')
param alertScope string

// ----------------------------------------------------------
// Define valid alert criteria for ADF action failures using metrics
// ----------------------------------------------------------
var adfActionCriteria = {
  'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
  allOf: [
    {
      name: 'FailedRunsCriteria'
      metricName: 'FailedRuns' // Use valid metric "FailedRuns"
      operator: 'GreaterThan'
      threshold: 0
      timeAggregation: 'Total'
      criterionType: 'StaticThresholdCriterion'
    }
  ]
}

// ----------------------------------------------------------
// Metric Alert for ADF Action Failures
// ----------------------------------------------------------
resource metricAlertADFActionFailure 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertADFActionFailureName
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [
      alertScope
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: adfActionCriteria
  }
}

// ----------------------------------------------------------
// Activity Log Alert for ADF Pipeline Failures
// ----------------------------------------------------------
resource activityLogAlertADFPipelineFailure 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertADFPipelineFailureName
  location: 'global'
  properties: {
    scopes: [
      alertScope
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'Administrative'
        }
        {
          field: 'operationName'
          equals: 'Microsoft.DataFactory/factories/pipelines/run/action'
        }
        {
          field: 'status'
          equals: 'Failed'
        }
      ]
    }
    actions: []
    enabled: true
    description: 'Alert when an ADF pipeline run fails.'
  }
}

// ----------------------------------------------------------
// Activity Log Alert for the Devdatabphc Resource
// ----------------------------------------------------------
resource activityLogAlertDevdatabphc 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertDevdatabphcName
  location: 'global'
  properties: {
    scopes: [
      alertScope
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'Administrative'
        }
        {
          field: 'status'
          equals: 'Failed'
        }
      ]
    }
    actions: []
  }
}

// ----------------------------------------------------------
// Activity Log Alert for the Storage Account
// ----------------------------------------------------------
resource activityLogAlertSa 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertSaName
  location: 'global'
  properties: {
    scopes: [
      alertScope
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'Administrative'
        }
        {
          field: 'status'
          equals: 'Failed'
        }
      ]
    }
    actions: []
  }
}

// ----------------------------------------------------------
// Activity Log Alert for the Virtual Network
// ----------------------------------------------------------
resource activityLogAlertVNet 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertVNetName
  location: 'global'
  properties: {
    scopes: [
      alertScope
    ]
    condition: {
      allOf: [
        {
          field: 'category'
          equals: 'Administrative'
        }
        {
          field: 'status'
          equals: 'Failed'
        }
      ]
    }
    actions: []
  }
}

// ----------------------------------------------------------
// Outputs
// ----------------------------------------------------------
@description('Resource ID of the metric alert for ADF action failures.')
output metricAlertADFActionFailureId string = metricAlertADFActionFailure.id

@description('Resource ID of the activity log alert for ADF pipeline failures.')
output activityLogAlertADFPipelineFailureId string = activityLogAlertADFPipelineFailure.id

@description('Resource ID of the activity log alert for the Devdatabphc resource.')
output activityLogAlertDevdatabphcId string = activityLogAlertDevdatabphc.id

@description('Resource ID of the activity log alert for the Storage Account.')
output activityLogAlertSaId string = activityLogAlertSa.id

@description('Resource ID of the activity log alert for the Virtual Network.')
output activityLogAlertVNetId string = activityLogAlertVNet.id
