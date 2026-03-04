<#
.SYNOPSIS
    Creates an Intune compliance policy for Teams Rooms devices.

.DESCRIPTION
    This script creates a Windows compliance policy with settings
    appropriate for Microsoft Teams Rooms devices.

.PARAMETER PolicyName
    Name for the compliance policy.

.PARAMETER RequireBitLocker
    Require BitLocker encryption. Default: $true

.PARAMETER RequireSecureBoot
    Require Secure Boot. Default: $true

.PARAMETER MinimumOSVersion
    Minimum Windows OS version. Default: "10.0.22631" (Windows 11 23H2)

.EXAMPLE
    .\New-MTRCompliancePolicy.ps1 -PolicyName "MTR-Windows-Compliance"

    Creates compliance policy with default settings.

.NOTES
    Author: MTR Deployment Guide
    Requires: Microsoft.Graph module
    Permissions: Intune Administrator
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $false)]
    [string]$PolicyName = "MTR-Windows-Compliance",

    [Parameter(Mandatory = $false)]
    [string]$Description = "Compliance policy for Microsoft Teams Rooms on Windows",

    [Parameter(Mandatory = $false)]
    [bool]$RequireBitLocker = $true,

    [Parameter(Mandatory = $false)]
    [bool]$RequireSecureBoot = $true,

    [Parameter(Mandatory = $false)]
    [bool]$RequireCodeIntegrity = $true,

    [Parameter(Mandatory = $false)]
    [string]$MinimumOSVersion = "10.0.22631"
)

#Requires -Modules Microsoft.Graph.DeviceManagement

$ErrorActionPreference = 'Stop'

try {
    $context = Get-MgContext
    if (-not $context) {
        throw "Not connected to Microsoft Graph."
    }

    Write-Information "Creating compliance policy: $PolicyName"

    $policyParams = @{
        "@odata.type" = "#microsoft.graph.windows10CompliancePolicy"
        displayName = $PolicyName
        description = $Description
        bitLockerEnabled = $RequireBitLocker
        secureBootEnabled = $RequireSecureBoot
        codeIntegrityEnabled = $RequireCodeIntegrity
        osMinimumVersion = $MinimumOSVersion
        storageRequireEncryption = $true
        firewallEnabled = $true
        defenderEnabled = $true
        scheduledActionsForRule = @(
            @{
                ruleName = "DeviceNonComplianceRule"
                scheduledActionConfigurations = @(
                    @{
                        actionType = "block"
                        gracePeriodHours = 0
                        notificationTemplateId = ""
                    }
                )
            }
        )
    }

    if ($PSCmdlet.ShouldProcess($PolicyName, "Create compliance policy")) {
        $policy = Invoke-MgGraphRequest -Method POST `
            -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies" `
            -Body ($policyParams | ConvertTo-Json -Depth 5) `
            -ContentType "application/json"

        Write-Information "Policy created successfully!"
        Write-Information "  Policy ID: $($policy.id)"
        Write-Information ""
        Write-Information "Settings:"
        Write-Information "  BitLocker: $RequireBitLocker"
        Write-Information "  Secure Boot: $RequireSecureBoot"
        Write-Information "  Code Integrity: $RequireCodeIntegrity"
        Write-Information "  Min OS Version: $MinimumOSVersion"
        Write-Information "  Firewall: Required"
        Write-Information "  Defender: Required"
        Write-Information ""
        Write-Information "Next step: Assign this policy to your MTR device group"

        return $policy
    }
}
catch {
    Write-Error "Failed to create compliance policy: $_"
    throw
}
