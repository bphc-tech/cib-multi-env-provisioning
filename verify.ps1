# -------------------------------------------
# PowerShell script to verify the Bicep file modifications
# -------------------------------------------

# Set the path to your Bicep file (adjust if needed)
$filePath = ".\ARMTemplateForFactory.bicep"

# Function to check if a pattern exists in the file
function Check-Pattern {
    param (
        [string]$filePath,
        [string]$pattern
    )
    $content = Get-Content -Path $filePath -Raw
    if ($content -match $pattern) {
        return $true
    }
    return $false
}

# Function to check if a resource reference exists in the file
function Check-ResourceReference {
    param (
        [string]$filePath,
        [string]$resourceReference
    )
    $content = Get-Content -Path $filePath -Raw
    if ($content -match $resourceReference) {
        return $true
    }
    return $false
}

# Patterns to check for the old dependency strings
$oldPatterns = @(
    "\[concat\('Microsoft\.DataFactory/factories/', parameters\('factoryName'\)\)\]",
    "\[concat\('Microsoft\.DataFactory/factories/', parameters\('factoryName'\), '/integrationRuntimes/', parameters\('integrationRuntimeName'\)\)\]"
)

# New resource references to check for (unquoted)
$resourceReferences = @(
    "dataFactory",
    "managedIR"
)

Write-Output "Verifying removal of old dependency strings..."
foreach ($pattern in $oldPatterns) {
    if (Check-Pattern -filePath $filePath -pattern $pattern) {
        Write-Output "Old pattern found: $pattern"
    } else {
        Write-Output "Old pattern not found: $pattern"
    }
}

Write-Output "`nVerifying presence of new resource references..."
foreach ($ref in $resourceReferences) {
    if (Check-ResourceReference -filePath $filePath -resourceReference $ref) {
        Write-Output "Resource reference found: $ref"
    } else {
        Write-Output "Resource reference not found: $ref"
    }
}

Write-Output "`nVerifying inline comments in dependsOn blocks..."
# Get all dependsOn lines with context
$dependsOnBlocks = Select-String -Path $filePath -Pattern "dependsOn:\s*\[.*\]" -Context 0,3

foreach ($block in $dependsOnBlocks) {
    $lineNumber = $block.LineNumber
    $context = $block.Context.PreContext
    $commentFound = $false

    foreach ($line in $context) {
        if ($line -match "// Dependency reference: see mapping.md") {
            $commentFound = $true
            break
        }
    }

    if ($commentFound) {
        Write-Output "Inline comment found for dependsOn block at line $lineNumber"
    } else {
        Write-Output "Inline comment NOT found for dependsOn block at line $lineNumber"
    }
}

Write-Output "`nVerification complete."
