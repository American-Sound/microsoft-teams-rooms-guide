<#
.SYNOPSIS
    Assigns a phone number and calling policies to a Teams Rooms resource account.

.DESCRIPTION
    This script assigns a PSTN phone number to a Teams Rooms resource account
    and configures the appropriate calling, dial plan, caller ID, and emergency
    calling policies.

.PARAMETER Identity
    UPN of the Teams Rooms resource account.

.PARAMETER PhoneNumber
    Phone number to assign in E.164 format (e.g., "+12065551234").

.PARAMETER PhoneNumberType
    Type of phone number: CallingPlan, DirectRouting, or OperatorConnect.

.PARAMETER LocationId
    Emergency location ID (for Calling Plans).

.PARAMETER VoiceRoutingPolicy
    Voice routing policy name (required for Direct Routing).

.PARAMETER DialPlan
    Tenant dial plan name.

.PARAMETER CallingPolicy
    Teams calling policy name. Default: "TeamsRoomCallingPolicy".

.PARAMETER CallerIdPolicy
    Caller ID policy name.

.PARAMETER EmergencyCallingPolicy
    Emergency calling policy name.

.PARAMETER EmergencyCallRoutingPolicy
    Emergency call routing policy name (Direct Routing only).

.EXAMPLE
    .\Set-MTRPhoneNumber.ps1 -Identity "mtr-hq-301@contoso.com" `
        -PhoneNumber "+12065551301" `
        -PhoneNumberType DirectRouting `
        -VoiceRoutingPolicy "US-VoiceRoutingPolicy" `
        -DialPlan "US-SeattleDialPlan"

    Assigns a Direct Routing phone number with policies.

.EXAMPLE
    .\Set-MTRPhoneNumber.ps1 -Identity "mtr-hq-301@contoso.com" `
        -PhoneNumber "+12065551301" `
        -PhoneNumberType CallingPlan `
        -LocationId "a1b2c3d4-e5f6-7890-abcd-ef1234567890"

    Assigns a Calling Plan phone number with emergency location.

.NOTES
    Author: MTR Deployment Guide
    Requires: MicrosoftTeams module
    Permissions: Teams Administrator
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$Identity,

    [Parameter(Mandatory = $true)]
    [ValidatePattern('^\+\d{7,15}')]
    [string]$PhoneNumber,

    [Parameter(Mandatory = $true)]
    [ValidateSet("CallingPlan", "DirectRouting", "OperatorConnect")]
    [string]$PhoneNumberType,

    [Parameter(Mandatory = $false)]
    [string]$LocationId,

    [Parameter(Mandatory = $false)]
    [string]$VoiceRoutingPolicy,

    [Parameter(Mandatory = $false)]
    [string]$DialPlan,

    [Parameter(Mandatory = $false)]
    [string]$CallingPolicy = "TeamsRoomCallingPolicy",

    [Parameter(Mandatory = $false)]
    [string]$CallerIdPolicy,

    [Parameter(Mandatory = $false)]
    [string]$EmergencyCallingPolicy,

    [Parameter(Mandatory = $false)]
    [string]$EmergencyCallRoutingPolicy
)

#Requires -Modules MicrosoftTeams

$ErrorActionPreference = 'Stop'

try {
    # Verify Teams connection
    $null = Get-CsTenant -ErrorAction Stop

    # Verify user exists
    $user = Get-CsOnlineUser -Identity $Identity -ErrorAction Stop
    Write-Information "Configuring phone for: $($user.DisplayName)" -InformationAction Continue

    if ($user.LineUri) {
        Write-Warning "  User already has phone number assigned: $($user.LineUri)"
    }

    # Validate Direct Routing has voice routing policy
    if ($PhoneNumberType -eq "DirectRouting" -and -not $VoiceRoutingPolicy) {
        throw "Direct Routing requires -VoiceRoutingPolicy parameter."
    }

    # Step 1: Assign phone number
    if ($PSCmdlet.ShouldProcess($Identity, "Assign phone number $PhoneNumber ($PhoneNumberType)")) {
        $params = @{
            Identity        = $Identity
            PhoneNumber     = $PhoneNumber
            PhoneNumberType = $PhoneNumberType
        }
        if ($LocationId) {
            $params['LocationId'] = $LocationId
        }

        Set-CsPhoneNumberAssignment @params
        Write-Information "  Phone number assigned: $PhoneNumber ($PhoneNumberType)" -InformationAction Continue
    }

    # Step 2: Assign voice routing policy (Direct Routing)
    if ($VoiceRoutingPolicy) {
        if ($PSCmdlet.ShouldProcess($Identity, "Assign voice routing policy '$VoiceRoutingPolicy'")) {
            Grant-CsOnlineVoiceRoutingPolicy -Identity $Identity -PolicyName $VoiceRoutingPolicy
            Write-Information "  Voice routing policy: $VoiceRoutingPolicy" -InformationAction Continue
        }
    }

    # Step 3: Assign dial plan
    if ($DialPlan) {
        if ($PSCmdlet.ShouldProcess($Identity, "Assign dial plan '$DialPlan'")) {
            Grant-CsTenantDialPlan -Identity $Identity -PolicyName $DialPlan
            Write-Information "  Dial plan: $DialPlan" -InformationAction Continue
        }
    }

    # Step 4: Assign calling policy
    if ($PSCmdlet.ShouldProcess($Identity, "Assign calling policy '$CallingPolicy'")) {
        Grant-CsTeamsCallingPolicy -Identity $Identity -PolicyName $CallingPolicy
        Write-Information "  Calling policy: $CallingPolicy" -InformationAction Continue
    }

    # Step 5: Assign caller ID policy
    if ($CallerIdPolicy) {
        if ($PSCmdlet.ShouldProcess($Identity, "Assign caller ID policy '$CallerIdPolicy'")) {
            Grant-CsCallingLineIdentity -Identity $Identity -PolicyName $CallerIdPolicy
            Write-Information "  Caller ID policy: $CallerIdPolicy" -InformationAction Continue
        }
    }

    # Step 6: Assign emergency calling policy
    if ($EmergencyCallingPolicy) {
        if ($PSCmdlet.ShouldProcess($Identity, "Assign emergency calling policy '$EmergencyCallingPolicy'")) {
            Grant-CsTeamsEmergencyCallingPolicy -Identity $Identity -PolicyName $EmergencyCallingPolicy
            Write-Information "  Emergency calling policy: $EmergencyCallingPolicy" -InformationAction Continue
        }
    }

    # Step 7: Assign emergency call routing policy (Direct Routing)
    if ($EmergencyCallRoutingPolicy) {
        if ($PSCmdlet.ShouldProcess($Identity, "Assign emergency call routing policy '$EmergencyCallRoutingPolicy'")) {
            Grant-CsTeamsEmergencyCallRoutingPolicy -Identity $Identity -PolicyName $EmergencyCallRoutingPolicy
            Write-Information "  Emergency call routing policy: $EmergencyCallRoutingPolicy" -InformationAction Continue
        }
    }

    # Verify
    Write-Information "`nVerifying configuration..." -InformationAction Continue
    $updated = Get-CsOnlineUser -Identity $Identity
    Write-Information "  Display Name: $($updated.DisplayName)" -InformationAction Continue
    Write-Information "  Line URI: $($updated.LineUri)" -InformationAction Continue
    Write-Information "  Enterprise Voice: $($updated.EnterpriseVoiceEnabled)" -InformationAction Continue
    Write-Information "  Voice Routing Policy: $($updated.OnlineVoiceRoutingPolicy)" -InformationAction Continue
    Write-Information "  Calling Policy: $($updated.TeamsCallingPolicy)" -InformationAction Continue
    Write-Information "  Dial Plan: $($updated.TenantDialPlan)" -InformationAction Continue

    Write-Information "`nPhone configuration complete." -InformationAction Continue
}
catch {
    Write-Error "Phone configuration failed: $_"
    throw
}
