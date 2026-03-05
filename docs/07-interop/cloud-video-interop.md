# Cloud Video Interop (CVI)

## Overview

Cloud Video Interop (CVI) enables legacy SIP and H.323 video teleconferencing devices (VTCs) to join Microsoft Teams meetings. A certified CVI partner deploys cloud-based infrastructure that translates between standard video conferencing protocols and the Teams meeting platform via Microsoft Graph APIs.

CVI is about **inbound** interoperability — non-Teams VTC devices joining **into** Teams meetings. For Teams Rooms joining third-party meetings, see [Direct Guest Join](direct-guest-join.md). For point-to-point SIP/H.323 calling from Teams Rooms, see [SIP and H.323 Dialing](sip-h323-dialing.md).

## Architecture

The CVI architecture consists of three layers:

1. **VTC endpoint** (Cisco codec, Poly system, etc.) places a SIP or H.323 call to the CVI partner's infrastructure
2. **CVI partner service** (e.g., Pexip CVI cloud service) receives the call, authenticates against the Microsoft tenant, and joins the meeting on behalf of the VTC
3. **Microsoft Teams** sees the CVI service as a bot participant that has been granted the required Graph API permissions

## Certified CVI Partners

Only these partners are Microsoft-certified for CVI. Microsoft does not support granting other third parties the Graph API permissions that provide similar capabilities.

| Partner | Solution | Status |
|---------|----------|--------|
| **Pexip** | Pexip CVI (cloud-hosted in Pexip Service) | Active, fully featured |
| **Cisco** | Webex Video Integration for Microsoft Teams | Active |

> **Note:** HP Poly CloudConnect and Poly RealConnect were Pexip-powered CVI solutions sold through Poly. These have been consolidated under Pexip directly. If you have an existing CloudConnect or RealConnect deployment, contact Pexip for migration to the current Pexip CVI service.

## Dialing Methods

VTC users can join Teams meetings three ways:

**IVR (Interactive Voice Response):** Dial `tenantkey@partnerdomain`, get prompted for the VTC Conference ID (included in the Teams meeting invite), then get connected.

**Direct dial:** Dial `tenantkey.ConferenceID@partnerdomain` to skip the IVR entirely.

**One-touch dial:** If the VTC room has calendar integration (via Exchange), the meeting coordinates are parsed automatically and dialing is a single button press.

## Licensing

**Microsoft side:**
- CVI coordinates are injected into Teams meeting invites when a user has been assigned a `TeamsVideoInteropServicePolicy`. The meeting organizer must have this policy applied.
- Teams Rooms devices receiving CVI-joined participants do not need a specific CVI license.

**CVI partner side:**
- Each CVI partner has its own licensing model. You purchase a subscription from the partner (e.g., Pexip Connect Standard includes domain hosting; additional licenses scale with concurrent VTC connections).

## PowerShell Configuration

All CVI configuration uses the **MicrosoftTeams** PowerShell module:

```powershell
# Register the CVI provider (values provided by your CVI partner)
New-CsVideoInteropServiceProvider -Name "PexipCVI" `
    -TenantKey "teams@yourdomain.onpexip.com" `
    -AadApplicationIds "923c9f0a-b883-4efe-af73-54810da59f83" `
    -InstructionUri "https://join.pexip.com/teams/?conf={conf}&ivr={ivr}&d={domain}&ip={ip}&test={test}&prefix={prefix}&joinParam={joinParam}"

# View configured providers
Get-CsVideoInteropServiceProvider

# View available pre-built policies
Get-CsTeamsVideoInteropServicePolicy

# Assign CVI policy globally (all users get VTC coordinates in meeting invites)
Grant-CsTeamsVideoInteropServicePolicy -PolicyName PexipServiceProviderEnabled -Global

# Assign to a specific user
Grant-CsTeamsVideoInteropServicePolicy -PolicyName PexipServiceProviderEnabled `
    -Identity "user@contoso.com"

# Assign to an Entra ID group
Grant-CsTeamsVideoInteropServicePolicy -PolicyName PexipServiceProviderEnabled `
    -Group "<Entra-ID-Group-Object-ID>"

# Update a provider
Set-CsVideoInteropServiceProvider -Identity "PexipCVI" `
    -TenantKey "newkey@domain.onpexip.com"

# Remove a provider
Remove-CsVideoInteropServiceProvider -Identity "PexipCVI"
```

## CVI Feature Updates

| Feature | Details |
|---------|---------|
| CVI Support for Teams Town Halls | Presenters can join and present in town halls using VTC devices |
| CVI Support for PowerPoint Live | VTCs see still content snapshots of PowerPoint Live presentations |
| Video RTX (retransmission) | Improved packet loss resilience for CVI call legs |

## Key Capabilities

- HD video/audio and bidirectional content sharing
- SIP connections support up to 1080p video; H.323 limited to 720p
- Content sharing via VbSS, BFCP, or H.239 depending on protocol
- Mute/unmute controls, raised hand indicators
- Recording and transcription notifications
- Layout options (Teams-like, 1+7, Equal 2x2, Equal 3x3)
- DTMF controls (*8 to cycle layouts, *2 for Large Gallery)
- Display name passthrough from VTC endpoints
- Trusted devices can bypass the Teams lobby; untrusted VTCs land in lobby

## Related Topics

- [Pexip CVI Configuration](pexip-cvi.md) — Pexip-specific architecture and setup
- [SIP/H.323 Dialing](sip-h323-dialing.md) — Outbound calling from Teams Rooms via CVI partner
- [Direct Guest Join](direct-guest-join.md) — WebRTC-based alternative for joining third-party meetings
- [Interop Comparison](comparison.md) — Feature matrix across all three methods
- [CVI Policy Script](../../scripts/interop/Set-MTRCviPolicy.ps1) — PowerShell automation

## References

- [Cloud Video Interop — Microsoft Learn](https://learn.microsoft.com/en-us/microsoftteams/cloud-video-interop)
- [Grant-CsTeamsVideoInteropServicePolicy](https://learn.microsoft.com/en-us/powershell/module/teams/grant-csteamsvideointeropservicepolicy)
- [Teams Rooms Licensing](https://learn.microsoft.com/en-us/microsoftteams/rooms/rooms-licensing)
