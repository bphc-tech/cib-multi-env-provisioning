// ==========================================================
// Data Factory Module
// This module creates a Data Factory to mirror one from DevTest-Network,
// using a globally unique name (e.g., data-modernization-uat).
// ==========================================================

@description('Name of the Data Factory (default is data-modernization-uat for a unique global name).')
param dataFactoryName string = 'data-modernization-uat'

@description('Location for the Data Factory (defaults to the resource group location)')
param location string = resourceGroup().location

// ----------------------------------------------------------
// Create the Data Factory
// ----------------------------------------------------------
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  properties: {}
}

// ----------------------------------------------------------
// Output the ID of the created Data Factory
// ----------------------------------------------------------
output dataFactoryId string = dataFactory.id
