# Interop Comparison: CVI vs. DGJ vs. SIP Dialing

## Direction of Interoperability

This is the most fundamental distinction:

- **CVI** = Non-Teams VTC devices joining **into** Teams meetings. Direction: inbound to Teams.
- **DGJ** = Teams Rooms devices joining **out to** third-party meetings (Webex, Zoom, Google Meet). Direction: outbound from Teams via WebRTC.
- **SIP/H.323 Calling** (via CVI partner) = Teams Rooms placing outbound calls to VTC endpoints or third-party meetings via SIP. Direction: outbound from Teams via SIP.

## When to Use Each

| Scenario | Use |
|----------|-----|
| VTCs need to join your Teams meetings | **CVI** |
| Teams Rooms need to join a client's Webex or Zoom meetings | **DGJ** (simplest) or **SIP/H.323** (higher quality) |
| Point-to-point call to a standalone VTC endpoint | **SIP/H.323 Calling** (Pexip) |
| 50+ legacy VTCs migrating to Teams over time | **CVI** as a bridge |
| Google Meet rooms and Teams Rooms need mutual join | **DGJ** (two-way, ISE 2026) |
| Presenters joining a Teams Town Hall from a VTC | **CVI** |
| 1080p video quality required for cross-platform meetings | **CVI / SIP** |
| Budget-constrained, no CVI partner desired | **DGJ** (no additional cost) |

## Feature Comparison

| Capability | CVI (SIP/H.323) | DGJ (WebRTC) |
|------------|-----------------|--------------|
| **Video quality** | Up to 1080p/30fps | Up to 720p/30fps |
| **Content send via HDMI** | Yes | No |
| **Content camera** | Yes | No |
| **Dual displays** | Yes | Single only |
| **Lobby control** | Yes (partner-dependent) | No |
| **Events/Webinars** | Yes | No |
| **Supported join-button platforms** | Webex, Google Meet, GoToMeeting, RingCentral, Zoom, Amazon Chime, other SIP | Webex, Zoom, Google Meet |
| **Teams Rooms license required** | Pro (for SIP/H.323 calling from rooms) | Basic or Pro |
| **Teams Rooms on Android** | Not supported for SIP/H.323 calling | Supported for Webex and Zoom |
| **Additional partner cost** | Yes (CVI subscription) | No |
| **Direct internet access** | Not required | Required |

## Licensing Summary

| Component | CVI (VTCs into Teams) | DGJ | SIP/H.323 Calling |
|-----------|----------------------|-----|-------------------|
| Teams Rooms license | N/A (CVI is for VTCs, not the room) | Basic or Pro | **Pro only** |
| CVI partner subscription | Required | Not needed | Required (Pexip only) |
| Per-user CVI policy | Required for meeting organizers | Not needed | Not needed |
| Exchange calendar config | N/A | `Set-CalendarProcessing` required | N/A |

## ASEI Considerations

Given multi-vendor client environments (Cisco, Pexip, Q-SYS) and the MSP model:

- **CVI via Pexip** provides the most comprehensive interop — existing Pexip Infinity infrastructure can serve as the CVI gateway for all managed clients, supporting both inbound VTC-to-Teams and outbound Teams-Rooms-to-VTC scenarios
- **DGJ** is the zero-cost option for rooms that occasionally join a client's Webex or Zoom meeting, with the tradeoff of lower video quality and no HDMI content sharing
- For the **Salesforce/Google Meet** engagement, the new two-way DGJ between Teams Rooms on Windows and Google Meet hardware requires no CVI infrastructure
- The **SIP/H.323 calling** feature (Pexip-exclusive) is the right tool when a Teams Room needs to make a direct call to a Cisco codec in a client's conference room

## Related Topics

- [Cloud Video Interop](cloud-video-interop.md) — CVI architecture, certified partners, PowerShell
- [Pexip CVI Configuration](pexip-cvi.md) — Pexip-specific setup and dial-in experience
- [SIP/H.323 Dialing](sip-h323-dialing.md) — Outbound calling from Teams Rooms
- [Direct Guest Join](direct-guest-join.md) — WebRTC join for Webex, Zoom, Google Meet
- [CVI Policy Script](../../scripts/interop/Set-MTRCviPolicy.ps1) — PowerShell automation
