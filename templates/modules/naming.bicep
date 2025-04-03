// =====================================
// Module to generate standardized names for CIB-DL-UAT
// =====================================

@description('Environment name (e.g. dev, uat, prod)')
param env string = 'uat'

@description('Azure region short name (e.g. eus for East US)')
param region string = 'eastus'

@description('Service or app name (e.g. sharepoint, datalake)')
param service string

@description('Resource type abbreviation (e.g. func, vnet, sa, ag)')
param resourceType string

@description('Optional suffix for uniqueness (e.g. 01, backup)')
param suffix string = ''

// Compose the name
var name = empty(suffix) ? '${env}-${service}-${resourceType}-${region}' : '${env}-${service}-${resourceType}-${region}-${suffix}'

@description('Generated standardized name')
output resourceName string = name
