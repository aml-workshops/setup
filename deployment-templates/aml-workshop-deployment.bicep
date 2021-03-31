@description('A name to use as the base resource-name')
param resourceName string

@description('Tags to apply to the Azure Resources')
param tags object = {}

@description('The name for the Application Insights workspace associated with the AML Workspace')
param appInsightsName string = 'ai-${resourceName}'

@description('The name for the Storage Account associated with the AML Workspace')
param storageAccountName string = 'sa${replace(replace(resourceName, '-', ''),'_','')}'

@description('The name of the Key Vault associated with the AML Workspace')
param keyVaultName string = 'kv-${resourceName}'

@description('The name of the Container Registry associated with the AML Workspace')
param acrName string = 'acr${replace(replace(resourceName, '-', ''),'_','')}'

@description('The name of the AML Workspace')
param workspaceName string = 'ws-${resourceName}'

@description('Max number of nodes for the CPU-based cluster')
param maxNodeCount int = 10

@description('VM Size for the Cluster')
@allowed([
  'Standard_D1_v2'
  'Standard_D2_v2'
  'Standard_D3_v2'
  'Standard_D4_v2'
  'Standard_D11_v2'
  'Standard_D12_v2'
  'Standard_D13_v2'
  'Standard_D14_v2'
  'Standard_D15_v2'
  'Standard_DS1_v2'
  'Standard_DS2_v2'
  'Standard_DS3_v2'
  'Standard_DS4_v2'
  'Standard_DS5_v2'
  'Standard_DS11_v2'
  'Standard_DS12_v2'
  'Standard_DS13_v2'
  'Standard_DS14_v2'
  'Standard_DS15_v2'
  'Standard_D2_v3'
  'Standard_D4_v3'
  'Standard_D8_v3'
  'Standard_D16_v3'
  'Standard_D32_v3'
  'Standard_D64_v3'
  'Standard_D2s_v3'
  'Standard_D4s_v3'
  'Standard_D8s_v3'
  'Standard_D16s_v3'
  'Standard_D32s_v3'
  'Standard_D64s_v3'
  'Standard_E2_v3'
  'Standard_E4_v3'
  'Standard_E8_v3'
  'Standard_E16_v3'
  'Standard_D1'
  'Standard_D2'
  'Standard_D3'
  'Standard_D4'
  'Standard_D11'
  'Standard_D12'
  'Standard_D13'
  'Standard_D14'
  'Standard_NV6'
  'Standard_NV12'
  'Standard_NV24'
  'Standard_NC6s_v3'
  'Standard_NC12s_v3'
  'Standard_NC24rs_v3'
  'Standard_NC24s_v3'
  'Standard_HB60rs'
  'Standard_F2s_v2'
  'Standard_F4s_v2'
  'Standard_F8s_v2'
  'Standard_F16s_v2'
  'Standard_F32s_v2'
  'Standard_F64s_v2'
  'Standard_F72s_v2'
  'Standard_M8ms'
  'Standard_M16ms'
  'Standard_M32ls'
  'Standard_M32ms'
  'Standard_M32ts'
  'Standard_M64ls'
  'Standard_M64ms'
  'Standard_M64s'
  'Standard_M128ms'
  'Standard_M128s'
  'Standard_M64'
  'Standard_M64m'
  'Standard_M128'
  'Standard_M128m'
  'Standard_E2a_v4'
  'Standard_E4a_v4'
  'Standard_E8a_v4'
  'Standard_E16a_v4'
  'Standard_E32a_v4'
  'Standard_E48a_v4'
  'Standard_E64a_v4'
  'Standard_E96a_v4'
  'Standard_D2ds_v4'
  'Standard_D4ds_v4'
  'Standard_D8ds_v4'
  'Standard_D16ds_v4'
  'Standard_D32ds_v4'
  'Standard_D48ds_v4'
  'Standard_D64ds_v4'
  'Standard_NC6'
  'Standard_NC12'
  'Standard_NC24'
  'Standard_HC44rs'
  'Standard_HB120rs_v2'
  'Standard_NC24r'
  'Standard_NC6_Promo'
  'Standard_NC12_Promo'
  'Standard_NC24_Promo'
  'Standard_NC24r_Promo'
  'Standard_ND40rs_v2'
  'Standard_NV12s_v3'
  'Standard_NV24s_v3'
  'Standard_NV48s_v3'
  'Standard_H8'
  'Standard_H16'
  'Standard_H8m'
  'Standard_H16m'
  'Standard_H16r'
  'Standard_H16mr'
  'Standard_ND96asr_v4'
  'Standard_NC4as_T4_v3'
  'Standard_NC8as_T4_v3'
  'Standard_NC16as_T4_v3'
  'Standard_NC64as_T4_v3'
  'Standard_NC6s_v2'
  'Standard_NC12s_v2'
  'Standard_NC24rs_v2'
  'Standard_NC24s_v2'
])
param clusterVMSize string = 'Standard_DS14_v2'

var storageSKU = 'Standard_LRS'
var containerRegistrySku = 'Standard'
var keyVaultSKU = {
  name: 'standard'
  family: 'A'
}

resource appInsights 'Microsoft.Insights/components@2020-02-02-preview' = {
  name: appInsightsName
  location: resourceGroup().location
  kind: 'web'
  properties:{
    Application_Type: 'web'
  }
  tags: tags
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-01-01' = {
  kind: 'StorageV2'
  location: resourceGroup().location
  tags: tags
  name: storageAccountName
  sku: {
    name: storageSKU
  }
  properties: {
    allowBlobPublicAccess: false
  }
}


resource containerRegistry 'Microsoft.ContainerRegistry/registries@2020-11-01-preview' = {
  name: acrName
  location: resourceGroup().location
  sku: {
    name: containerRegistrySku
  }
  tags: tags
  properties: {
    adminUserEnabled: true
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: keyVaultName
  location: resourceGroup().location
  properties:{
    tenantId: subscription().tenantId
    sku: keyVaultSKU
    accessPolicies: []
  }
}

resource machineLearningWorkspace 'Microsoft.MachineLearningServices/workspaces@2021-01-01' = {
  name: workspaceName
  location: resourceGroup().location
  sku:{
    name: 'basic'
    tier: 'basic'
  }
  properties:{
    friendlyName: workspaceName
    storageAccount: storageAccount.id
    keyVault: keyVault.id
    containerRegistry: containerRegistry.id
    applicationInsights: appInsights.id
    hbiWorkspace: true
  }
  identity:{
    type: 'SystemAssigned'
  }
}

resource cpuCluster 'Microsoft.MachineLearningServices/workspaces/computes@2021-01-01' = {
  name: '${machineLearningWorkspace.name}/cpu-cluster'
  location: resourceGroup().location
  tags: tags
  properties: {
    computeType: 'AmlCompute'
    computeLocation: resourceGroup().location
    description: 'A compute cluster to be used for the workshop attendees'
    properties: {
      scaleSettings: {
        maxNodeCount: maxNodeCount
        minNodeCount: 0
        nodeIdleTimeBeforeScaleDown: 'PT30M'
      }
      vmPriority: 'LowPriority'
      vmSize: clusterVMSize
    }
  }
}
