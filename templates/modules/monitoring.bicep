// ==========================================================
// Revised Monitoring Module
// This module creates metric alerts and activity log alerts.
// Updated to use valid metrics for Azure Data Factory.
// ==========================================================

@description('Name for the metric alert EmailOnADFActionFailure')
param metricAlertADFActionFailureName string

@description('Name for the metric alert EmailOnADFPipelineFailure')
param metricAlertADFPipelineFailureName string

@description('Name for the activity log alert AdmAct_devdatabphc')
param activityLogAlertDevdatabphcName string

@description('Name for the activity log alert sa_AdmAct')
param activityLogAlertSaName string

@description('Name for the activity log alert AdmAct_VNet')
param activityLogAlertVNetName string

@description('Location for alerts (typically global)')
param location string = 'global'

@description('Resource ID to use as the scope for alerts')
param alertScope string

// ----------------------------------------------------------
// Define valid ADF metric alert criteria (Pipeline Failed Runs)
// ----------------------------------------------------------
var adfFailureCriteria = {
  'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
  allOf: [
    {
      name: 'PipelineFailedRuns'
      metricName: 'PipelineFailedRuns'
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
resource metricAlertADFActionFailure 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertADFActionFailureName
  location: location
  properties: {
    severity: 3
    enabled: true
    scopes: [alertScope]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: adfFailureCriteria
  }
}

resource metricAlertADFPipelineFailure 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: metricAlertADFPipelineFailureName
  location: location
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
resource activityLogAlertDevdatabphc 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertDevdatabphcName
  location: location
  properties: {
    scopes: [alertScope]
    condition: {
      allOf: [] // Define actual conditions if needed
    }
    actions: [] // Define actual actions if needed
  }
}

resource activityLogAlertSa 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertSaName
  location: location
  properties: {
    scopes: [alertScope]
    condition: {
      allOf: []
    }
    actions: []
  }
}

resource activityLogAlertVNet 'Microsoft.Insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertVNetName
  location: location
  properties: {
    scopes: [alertScope]
    condition: {
      allOf: []
    }
    actions: []
  }
}

// ----------------------------------------------------------
// Outputs
// ----------------------------------------------------------
output metricAlertADFActionFailureId string = metricAlertADFActionFailure.id
output metricAlertADFPipelineFailureId string = metricAlertADFPipelineFailure.id
output activityLogAlertDevdatabphcId string = activityLogAlertDevdatabphc.id
output activityLogAlertSaId string = activityLogAlertSa.id
output activityLogAlertVNetId string = activityLogAlertVNet.id
