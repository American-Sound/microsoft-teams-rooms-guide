<#
.SYNOPSIS
    Configures AI and Copilot policies for Teams Rooms.

.DESCRIPTION
    This script configures the CsTeamsAIPolicy (voice/face enrollment) and
    AI-relevant meeting policy settings for Teams Rooms resource accounts.

.PARAMETER RoomIdentity
    UPN of the Teams Rooms resource account to configure.

.PARAMETER MeetingPolicyName
    Name for the meeting policy. Default: "MTR-AIEnabled".

.PARAMETER EnableVoiceEnrollment
    Enable voice profile enrollment globally. Default: $true.

.PARAMETER EnableFaceEnrollment
    Enable face profile enrollment globally. Default: $true.

.PARAMETER CopilotMode
    Copilot policy setting. Default: "EnabledWithTranscriptDefaultOn".

.PARAMETER EnableTranscription
    Enable meeting transcription. Default: $true.

.PARAMETER EnableRecording
    Enable cloud recording for full Recap. Default: $true.

.PARAMETER EnableIntelligentSpeaker
    Enable Intelligent Speaker (people recognition) for the room. Default: $true.

.EXAMPLE
    .\Set-MTRAIPolicy.ps1 -RoomIdentity "mtr-hq-101@contoso.com"

    Configures all AI features with defaults for the specified room.

.EXAMPLE
    .\Set-MTRAIPolicy.ps1 -RoomIdentity "mtr-hq-101@contoso.com" `
        -CopilotMode Enabled -EnableRecording $false

    Configures with non-persisted transcript and no recording.

.NOTES
    Author: MTR Deployment Guide
    Requires: MicrosoftTeams module
    Permissions: Teams Administrator
#>

[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$RoomIdentity,

    [Parameter(Mandatory = $false)]
    [string]$MeetingPolicyName = "MTR-AIEnabled",

    [Parameter(Mandatory = $false)]
    [bool]$EnableVoiceEnrollment = $true,

    [Parameter(Mandatory = $false)]
    [bool]$EnableFaceEnrollment = $true,

    [Parameter(Mandatory = $false)]
    [ValidateSet("Enabled", "EnabledWithTranscript", "EnabledWithTranscriptDefaultOn", "Disabled")]
    [string]$CopilotMode = "EnabledWithTranscriptDefaultOn",

    [Parameter(Mandatory = $false)]
    [bool]$EnableTranscription = $true,

    [Parameter(Mandatory = $false)]
    [bool]$EnableRecording = $true,

    [Parameter(Mandatory = $false)]
    [bool]$EnableIntelligentSpeaker = $true
)

#Requires -Modules MicrosoftTeams

$ErrorActionPreference = 'Stop'

try {
    # Verify Teams connection
    $null = Get-CsTenant -ErrorAction Stop

    # Verify room exists
    $room = Get-CsOnlineUser -Identity $RoomIdentity -ErrorAction Stop
    Write-Information "Configuring AI policies for: $($room.DisplayName)" -InformationAction Continue

    # Step 1: Configure Global AI Policy
    if ($PSCmdlet.ShouldProcess("Global AI Policy", "Set voice/face enrollment")) {
        $voiceValue = if ($EnableVoiceEnrollment) { "Enabled" } else { "Disabled" }
        $faceValue = if ($EnableFaceEnrollment) { "Enabled" } else { "Disabled" }

        Set-CsTeamsAIPolicy -Identity Global `
            -EnrollVoice $voiceValue `
            -EnrollFace $faceValue `
            -SpeakerAttributionBYOD Enabled

        Write-Information "  Global AI Policy updated:" -InformationAction Continue
        Write-Information "    Voice enrollment: $voiceValue" -InformationAction Continue
        Write-Information "    Face enrollment: $faceValue" -InformationAction Continue
    }

    # Step 2: Create or update meeting policy
    if ($PSCmdlet.ShouldProcess($MeetingPolicyName, "Create/update meeting policy")) {
        $existingPolicy = Get-CsTeamsMeetingPolicy -Identity $MeetingPolicyName -ErrorAction SilentlyContinue

        if (-not $existingPolicy) {
            Write-Information "  Creating meeting policy: $MeetingPolicyName" -InformationAction Continue
            New-CsTeamsMeetingPolicy -Identity $MeetingPolicyName
        }

        $roomAttribute = if ($EnableIntelligentSpeaker) { "Attribute" } else { "Off" }

        Set-CsTeamsMeetingPolicy -Identity $MeetingPolicyName `
            -Copilot $CopilotMode `
            -AllowTranscription $EnableTranscription `
            -AllowCloudRecording $EnableRecording `
            -VoiceIsolation Enabled `
            -RoomAttributeUserOverride $roomAttribute `
            -SpeakerAttributionMode Enabled

        Write-Information "  Meeting policy '$MeetingPolicyName' configured:" -InformationAction Continue
        Write-Information "    Copilot: $CopilotMode" -InformationAction Continue
        Write-Information "    Transcription: $EnableTranscription" -InformationAction Continue
        Write-Information "    Recording: $EnableRecording" -InformationAction Continue
        Write-Information "    Intelligent Speaker: $roomAttribute" -InformationAction Continue
    }

    # Step 3: Assign meeting policy to room
    if ($PSCmdlet.ShouldProcess($RoomIdentity, "Assign meeting policy '$MeetingPolicyName'")) {
        Grant-CsTeamsMeetingPolicy -Identity $RoomIdentity -PolicyName $MeetingPolicyName
        Write-Information "  Meeting policy assigned to $RoomIdentity" -InformationAction Continue
    }

    Write-Information "`nAI configuration complete for $($room.DisplayName)." -InformationAction Continue
    Write-Information "  Users must enroll voice/face profiles at: Teams Settings > Recognition" -InformationAction Continue
}
catch {
    Write-Error "AI policy configuration failed: $_"
    throw
}
