# Calling Policies for Teams Rooms

## Overview

Create a dedicated calling policy for Teams Rooms resource accounts. Rooms should not forward calls, use voicemail, or record calls: they should ring, be answered by whoever is in the room, and provide a basic calling experience.

## Recommended Policy

```powershell
New-CsTeamsCallingPolicy -Identity "TeamsRoomCallingPolicy" `
    -AllowPrivateCalling $true `
    -AllowCallForwardingToUser $false `
    -AllowCallForwardingToPhone $false `
    -AllowCallGroups $false `
    -AllowDelegation $false `
    -AllowVoicemail "AlwaysDisabled" `
    -BusyOnBusyEnabledType "Enabled" `
    -AllowCloudRecordingForCalls $false `
    -AllowTranscriptionForCalling $false `
    -MusicOnHoldEnabledType "Enabled" `
    -SpamFilteringEnabledType "Enabled" `
    -InboundPstnCallRoutingTreatment "RegularIncoming" `
    -InboundFederatedCallRoutingTreatment "RegularIncoming" `
    -AllowWebPSTNCalling $false `
    -AutoAnswerEnabledType "Disabled" `
    -PreventTollBypass $false
```

## Parameter Reference

| Parameter | Recommended | Description |
|-----------|-------------|-------------|
| `AllowPrivateCalling` | `$true` | Master switch for all calling: must be true |
| `AllowCallForwardingToUser` | `$false` | Don't forward to other users |
| `AllowCallForwardingToPhone` | `$false` | Don't forward to external numbers |
| `AllowCallGroups` | `$false` | No call group routing |
| `AllowDelegation` | `$false` | No delegation |
| `AllowVoicemail` | `AlwaysDisabled` | Rooms shouldn't have voicemail |
| `BusyOnBusyEnabledType` | `Enabled` | Busy signal when already in a call |
| `AllowCloudRecordingForCalls` | `$false` | Don't record 1:1/PSTN calls |
| `AllowTranscriptionForCalling` | `$false` | No post-call transcription |
| `MusicOnHoldEnabledType` | `Enabled` | Music on hold active |
| `SpamFilteringEnabledType` | `Enabled` | Filter spam calls |
| `InboundPstnCallRoutingTreatment` | `RegularIncoming` | Ring normally |
| `AutoAnswerEnabledType` | `Disabled` | Don't auto-answer (unless desired) |
| `PreventTollBypass` | `$false` | Unless Location-Based Routing is required |

## Assign to Room

```powershell
Grant-CsTeamsCallingPolicy -Identity "confroom01@contoso.com" `
    -PolicyName "TeamsRoomCallingPolicy"
```

## Related Topics

- [PSTN Overview](pstn-overview.md): Connectivity options and licensing
- [Emergency Calling](emergency-calling.md): Emergency calling and routing policies
- [End-to-End Setup](end-to-end-setup.md): Complete configuration walkthrough

## References

- [Configure calling policies](https://learn.microsoft.com/en-us/microsoftteams/teams-calling-policy)
- [Set-CsTeamsCallingPolicy](https://learn.microsoft.com/en-us/powershell/module/microsoftteams/set-csteamscallingpolicy)
