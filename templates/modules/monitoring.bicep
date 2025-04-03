// ==========================================================
// Monitoring Module
// This module creates metric alerts and activity log alerts
// to mirror those in DevTest-Network.
// In this revision, we replace "Percentage CPU" with "CpuTime"
// so the metric alerts won't fail if you're targeting an App Service Plan.
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
// Define a dummy criteria object for metric alerts,
// including the required properties. We use "CpuTime"
// rather than "Percentage CPU", as "Percentage CPU" may
// not be valid on your target resource.
// ----------------------------------------------------------
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
// Metric Alert: EmailOnADFActionFailure (Example configuration)
// ----------------------------------------------------------
resource metricAlertADFActionFailure 'microsoft.insights/metricalerts@2018-03-01' = {
  name: metricAlertADFActionFailureName
  location: location
  properties: {
    severity: 3
    enabled: true
    scopes: [
      alertScope
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: dummyCriteria
  }
}

// ----------------------------------------------------------
// Metric Alert: EmailOnADFPipelineFailure (Example configuration)
// ----------------------------------------------------------
resource metricAlertADFPipelineFailure 'microsoft.insights/metricalerts@2018-03-01' = {
  name: metricAlertADFPipelineFailureName
  location: location
  properties: {
    severity: 3
    enabled: true
    scopes: [
      alertScope
    ]
    evaluationFrequency: 'PT5M'
    windowSize: 'PT15M'
    criteria: dummyCriteria
  }
}

// ----------------------------------------------------------
// Activity Log Alert: AdmAct_devdatabphc (Example configuration)
// ----------------------------------------------------------
resource activityLogAlertDevdatabphc 'microsoft.insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertDevdatabphcName
  location: location
  properties: {
    scopes: [
      alertScope
    ]
    condition: {
      allOf: []
    }
    actions: []  // Update with valid actions if needed.
  }
}

// ----------------------------------------------------------
// Activity Log Alert: sa_AdmAct (Example configuration)
// ----------------------------------------------------------
resource activityLogAlertSa 'microsoft.insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertSaName
  location: location
  properties: {
    scopes: [
      alertScope
    ]
    condition: {
      allOf: []
    }
    actions: []  // Update with valid actions if needed.
  }
}

// ----------------------------------------------------------
// Activity Log Alert: AdmAct_VNet (Example configuration)
// ----------------------------------------------------------
resource activityLogAlertVNet 'microsoft.insights/activityLogAlerts@2017-04-01' = {
  name: activityLogAlertVNetName
  location: location
  properties: {
    scopes: [
      alertScope
    ]
    condition: {
      allOf: []
    }
    actions: []  // Update with valid actions if needed.
  }
}

// ----------------------------------------------------------
// Outputs (optional)
// ----------------------------------------------------------
output metricAlertADFActionFailureId string = metricAlertADFActionFailure.id
output metricAlertADFPipelineFailureId string = metricAlertADFPipelineFailure.id
