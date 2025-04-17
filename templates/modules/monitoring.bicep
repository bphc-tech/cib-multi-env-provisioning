// ==========================================================
// Monitoring Module
// This module creates metric alerts and activity log alerts for monitoring Azure resources.
// It includes alerts for Azure Data Factory pipeline failures and activity logs.
// ==========================================================

@description('Name for the metric alert to monitor ADF action failures.')
param metricAlertADFActionFailureName string

@description('Name for the metric alert to monitor ADF pipeline failures.')
param metricAlertADFPipelineFailureName string

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
// Define valid ADF metric alert criteria (Pipeline Failed Runs)
// ----------------------------------------------------------
var adfFailureCriteria = {
  'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
  allOf: [
    {
      name: 'PipelineFailedRunsCriteria'
      metricName: 'PipelineFailedRuns' // Updated metric name for ADF
      operator: 'GreaterThan'
      threshold: 0
      timeAggregation: 'Total'
      criterionType: 'StaticThresholdCriterion'
    }
  ]
}

// ----------------------------------------------------------
// Metric Alerts
// ----------------------------------------------------------

// Metric alert for ADF action failures
resource metricAlertADFActionFailure 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertADFActionFailureName
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [alertScope]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: adfFailureCriteria
  }
}

// Metric alert for ADF pipeline failures
resource metricAlertADFPipelineFailure 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertADFPipelineFailureName
  location: 'global'
  properties: {
    severity: 3
    enabled: true
    scopes: [alertScope]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: adfFailureCriteria
  }
}

// ----------------------------------------------------------
// Activity Log Alerts
// ----------------------------------------------------------

// Activity log alert for the Devdatabphc resource
resource activityLogAlertDevdatabphc 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertDevdatabphcName
  location: 'global'
  properties: {
    scopes: [alertScope]
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

// Activity log alert for the Storage Account
resource activityLogAlertSa 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertSaName
  location: 'global'
  properties: {
    scopes: [alertScope]
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

// Activity log alert for the Virtual Network
resource activityLogAlertVNet 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertVNetName
  location: 'global'
  properties: {
    scopes: [alertScope]
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
@description('The resource ID of the metric alert for ADF action failures.')
output metricAlertADFActionFailureId string = metricAlertADFActionFailure.id

@description('The resource ID of the metric alert for ADF pipeline failures.')
output metricAlertADFPipelineFailureId string = metricAlertADFPipelineFailure.id

@description('The resource ID of the activity log alert for the Devdatabphc resource.')
output activityLogAlertDevdatabphcId string = activityLogAlertDevdatabphc.id

@description('The resource ID of the activity log alert for the Storage Account.')
output activityLogAlertSaId string = activityLogAlertSa.id

@description('The resource ID of the activity log alert for the Virtual Network.')
output activityLogAlertVNetId string = activityLogAlertVNet.id
