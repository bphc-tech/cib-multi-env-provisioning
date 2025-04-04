// ==========================================================
// Monitoring Module
// Creates metric alerts and activity log alerts.
// Replaces "Percentage CPU" with "CpuTime" for compatibility.
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

// Dummy metric alert criteria
var dummyCriteria = {
  'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
  allOf: [
    {
      name: 'DefaultCriterion'
      metricName: 'CpuTime'
      operator: 'GreaterThan'
      threshold: 1000
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
    criteria: dummyCriteria
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
    criteria: dummyCriteria
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
      allOf: []
    }
    actions: []
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
