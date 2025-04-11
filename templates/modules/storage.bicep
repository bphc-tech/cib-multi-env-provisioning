// ==========================================================
// Storage Module
// This module creates two Storage Accounts.
// Update parameter values in your parameters file accordingly.
// ==========================================================

@description('Name for storage account 1')
param storageAccount1Name string = 'dmiprojectsstorage-uat'

@description('Name for storage account 2')
param storageAccount2Name string = 'dmiprojectsstorage-secondary-uat'

@description('Location for storage accounts (defaults to the resource group location)')
param location string = resourceGroup().location

// ----------------------------------------------------------
// Create the first Storage Account
// ----------------------------------------------------------
resource storage1 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccount1Name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    // Enable soft delete for blob containers (optional)
    deleteRetentionPolicy: {
      days: 7 // Soft delete for 7 days
    }
  }
}

// ----------------------------------------------------------
// Create the second Storage Account
// ----------------------------------------------------------
resource storage2 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageAccount2Name
  location: location
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
  properties: {
    // Enable soft delete for blob containers (optional)
    deleteRetentionPolicy: {
      days: 7 // Soft delete for 7 days
    }
  }
}

// ----------------------------------------------------------
// Output the IDs of the created Storage Accounts
// ----------------------------------------------------------
output storage1Id string = storage1.id
output storage2Id string = storage2.id
