# SIP and H.323 Dialing from Teams Rooms

## Overview

Teams Rooms on Windows devices can make outbound SIP and H.323 calls to non-Teams endpoints (Cisco codecs, Poly systems, standalone VTCs). Calls route from the Teams Room through the Microsoft 365 cloud to the CVI partner's infrastructure, then out to the destination VTC. Currently, only **Pexip** offers this capability among the certified CVI partners.

This is distinct from Direct Guest Join (WebRTC-based, lower quality) and from CVI (which is about VTCs joining into Teams meetings). SIP/H.323 dialing enables Teams Rooms to make point-to-point calls or join third-party meetings via SIP.

## Requirements

- **Teams Rooms Pro** license (mandatory; Teams Rooms Basic does not support SIP/H.323 calling)
- **Teams Rooms on Windows** only (not supported on Android)
- Teams Rooms on Windows app version **5.2.115.0 or later**
- Active CVI partner agreement with SIP/H.323 dialing capability (currently Pexip only)
- From the Pexip side: Domain Hosting (included in Connect Standard) plus Connect for Teams Rooms licenses

## PowerShell Configuration

```powershell
# Create a policy enabling SIP/H.323 calling on Teams Rooms
New-CsTeamsRoomVideoTeleConferencingPolicy -Identity "MtrSipCallingPolicy" `
    -Enabled $true `
    -AreaCode "923c9f0a-b883-4efe-af73-54810da59f83" `
    -ReceiveExternalCalls Enabled `
    -ReceiveInternalCalls Enabled

# Assign to a specific room
Grant-CsTeamsRoomVideoTeleConferencingPolicy -Identity "meetingroom01@contoso.com" `
    -PolicyName "MtrSipCallingPolicy"

# Or assign globally to all rooms
Grant-CsTeamsRoomVideoTeleConferencingPolicy -PolicyName "MtrSipCallingPolicy" -Global

# View existing policies
Get-CsTeamsRoomVideoTeleConferencingPolicy

# Modify a policy (e.g., disable external inbound calls)
Set-CsTeamsRoomVideoTeleConferencingPolicy -Identity "MtrSipCallingPolicy" `
    -ReceiveExternalCalls Disabled
```

The `AreaCode` parameter is the CVI application GUID provided by the partner (for Pexip: `923c9f0a-b883-4efe-af73-54810da59f83`). `ReceiveExternalCalls` and `ReceiveInternalCalls` control whether the room can receive inbound calls from VTCs (both default to Disabled).

## Dialing Experience

Once enabled, the touch console exposes several interop options:

- **One-touch join** from the calendar for scheduled third-party meetings that include SIP dial strings
- **Join by meeting ID** by selecting a provider (Zoom, Webex, Google Meet) and entering the meeting ID/passcode
- **Direct SIP/H.323 address dial** by selecting "Call," choosing SIP or H.323, and entering the destination address (e.g., `sip:room123@cisco.example.com`)

## Limitations

- Standard Teams meeting features (recording, transcription, breakout rooms) are not available in point-to-point SIP/H.323 calls
- Bidirectional screen sharing is supported via BFCP/H.239
- Not available on Teams Rooms on Android
- Requires a CVI partner as the intermediary: not native SIP dialing

## Fallback Behavior

If a room has both SIP dialing and Direct Guest Join enabled, and a meeting invite contains both a SIP dial string and a WebRTC join URL, the device uses SIP first. If no SIP dial string is present, it falls back to DGJ WebRTC.

## Related Topics

- [Cloud Video Interop](cloud-video-interop.md): CVI overview (required infrastructure for SIP dialing)
- [Pexip CVI Configuration](pexip-cvi.md): Pexip-specific setup
- [Direct Guest Join](direct-guest-join.md): WebRTC alternative (no CVI partner required)
- [Interop Comparison](comparison.md): Feature matrix across all three methods

## References

- [SIP and H.323 dialing with Teams Rooms: Microsoft Learn](https://learn.microsoft.com/en-us/microsoftteams/rooms/meetings-with-sip-h323-devices)
- [Pexip Teams Rooms SIP/H.323 calling](https://help.pexip.com/service/teams-join-mtr.htm)
