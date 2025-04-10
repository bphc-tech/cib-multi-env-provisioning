// ==========================================================
// Data Factory Module
// This module creates an Azure Data Factory instance.
// It mirrors the configuration of a Data Factory from DevTest-Network
// and uses a globally unique name (e.g., data-modernization-uat).
// ==========================================================

@description('Name of the Data Factory (e.g., data-modernization-uat).')
param dataFactoryName string = 'data-modernization-uat'

@description('Location for the Data Factory (defaults to the resource group location).')
param location string = resourceGroup().location

// ----------------------------------------------------------
// Create the Data Factory
// ----------------------------------------------------------
resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  properties: {
    // Additional properties can be added here if needed
  }
}

// ----------------------------------------------------------
// Output the ID of the created Data Factory
// ----------------------------------------------------------
@description('The resource ID of the created Data Factory.')
output dataFactoryId string = dataFactory.id
