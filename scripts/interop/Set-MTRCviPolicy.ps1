<#
.SYNOPSIS
    Configures Cloud Video Interop (CVI) policy for Teams users or rooms.

.DESCRIPTION
    This script registers a CVI provider and assigns the CVI policy to users
    so that Teams meeting invites include VTC dial-in coordinates.

.PARAMETER Action
    Action to perform: RegisterProvider, AssignPolicy, or ViewStatus.

.PARAMETER ProviderName
    Name for the CVI provider registration (e.g., "PexipCVI").

.PARAMETER TenantKey
    Tenant key provided by the CVI partner (e.g., "teams@yourdomain.onpexip.com").

.PARAMETER AadApplicationId
    Azure AD application ID for the CVI service.

.PARAMETER InstructionUri
    Instruction URI template provided by the CVI partner.

.PARAMETER PolicyName
    Name of the CVI policy to assign (e.g., "PexipServiceProviderEnabled").

.PARAMETER Identity
    User or group to assign the policy to. Use "Global" for all users.

.EXAMPLE
    .\Set-MTRCviPolicy.ps1 -Action ViewStatus

    Shows current CVI providers and policies.

.EXAMPLE
    .\Set-MTRCviPolicy.ps1 -Action RegisterProvider -ProviderName "PexipCVI" `
        -TenantKey "teams@contoso.onpexip.com" `
        -AadApplicationId "923c9f0a-b883-4efe-af73-54810da59f83" `
        -InstructionUri "https://join.pexip.com/teams/?conf={conf}&ivr={ivr}"

    Registers a Pexip CVI provider.

.EXAMPLE
    .\Set-MTRCviPolicy.ps1 -Action AssignPolicy -PolicyName PexipServiceProviderEnabled -Identity Global

    Assigns CVI policy globally so all meeting invites include VTC coordinates.

.NOTES
    Author: MTR Deployment Guide
    Requires: MicrosoftTeams module
    Permissions: Teams Administrator
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("RegisterProvider", "AssignPolicy", "ViewStatus")]
    [string]$Action,

    [Parameter(Mandatory = $false)]
    [string]$ProviderName,

    [Parameter(Mandatory = $false)]
    [string]$TenantKey,

    [Parameter(Mandatory = $false)]
    [string]$AadApplicationId,

    [Parameter(Mandatory = $false)]
    [string]$InstructionUri,

    [Parameter(Mandatory = $false)]
    [string]$PolicyName,

    [Parameter(Mandatory = $false)]
    [string]$Identity
)

#Requires -Modules MicrosoftTeams

$ErrorActionPreference = 'Stop'

try {
    # Verify Teams connection
    $null = Get-CsTenant -ErrorAction Stop

    switch ($Action) {
        "ViewStatus" {
            Write-Information "=== CVI Providers ===" -InformationAction Continue
            $providers = Get-CsVideoInteropServiceProvider
            if ($providers) {
                $providers | Format-Table Name, TenantKey, AadApplicationIds -AutoSize
            }
            else {
                Write-Information "  No CVI providers registered." -InformationAction Continue
            }

            Write-Information "`n=== Available CVI Policies ===" -InformationAction Continue
            Get-CsTeamsVideoInteropServicePolicy | Format-Table Identity, Description -AutoSize

            Write-Information "`n=== Global Policy Assignment ===" -InformationAction Continue
            $global = Get-CsTeamsVideoInteropServicePolicy -Identity Global -ErrorAction SilentlyContinue
            if ($global) {
                Write-Information "  Global policy: $($global.Identity)" -InformationAction Continue
            }
        }

        "RegisterProvider" {
            if (-not $ProviderName -or -not $TenantKey -or -not $AadApplicationId -or -not $InstructionUri) {
                throw "RegisterProvider requires -ProviderName, -TenantKey, -AadApplicationId, and -InstructionUri parameters."
            }

            if ($PSCmdlet.ShouldProcess($ProviderName, "Register CVI provider")) {
                New-CsVideoInteropServiceProvider -Name $ProviderName `
                    -TenantKey $TenantKey `
                    -AadApplicationIds $AadApplicationId `
                    -InstructionUri $InstructionUri

                Write-Information "CVI provider '$ProviderName' registered successfully." -InformationAction Continue
                Write-Information "  Tenant Key: $TenantKey" -InformationAction Continue
                Write-Information "  App ID: $AadApplicationId" -InformationAction Continue
            }
        }

        "AssignPolicy" {
            if (-not $PolicyName) {
                throw "AssignPolicy requires -PolicyName parameter."
            }

            $target = if ($Identity -and $Identity -ne "Global") { $Identity } else { "Global (all users)" }

            if ($PSCmdlet.ShouldProcess($target, "Assign CVI policy '$PolicyName'")) {
                if ($Identity -and $Identity -ne "Global") {
                    Grant-CsTeamsVideoInteropServicePolicy -PolicyName $PolicyName -Identity $Identity
                }
                else {
                    Grant-CsTeamsVideoInteropServicePolicy -PolicyName $PolicyName -Global
                }

                Write-Information "CVI policy '$PolicyName' assigned to $target." -InformationAction Continue
            }
        }
    }
}
catch {
    Write-Error "CVI configuration failed: $_"
    throw
}
