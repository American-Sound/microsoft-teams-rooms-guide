# Direct Guest Join (DGJ)

## Overview

Direct Guest Join is a WebRTC-based capability built into Microsoft Teams Rooms that allows the room to join third-party meetings natively via the third-party platform's web client. No CVI partner or SIP infrastructure is required.

## Supported Platforms

| Platform | Teams Rooms on Windows | Teams Rooms on Android |
|----------|----------------------|----------------------|
| **Cisco Webex** | Supported | Supported |
| **Zoom** | Supported | Supported |
| **Google Meet** | Supported (app 5.5.129.0+) | Not supported |

Google Meet DGJ on Teams Rooms on Windows is two-way: ChromeOS-based Google Meet Rooms can also join Teams meetings. The feature is on by default.

## DGJ vs. CVI/SIP

DGJ is the zero-infrastructure option, but it comes with tradeoffs. Video caps at 720p, content sharing is receive-only, and platform support is limited to Webex, Zoom, and Google Meet. For organizations that need higher video quality (up to 1080p), content camera support, dual display, or connectivity to platforms like Amazon Chime, GoToMeeting, RingCentral, or arbitrary SIP endpoints, the SIP path through a CVI partner like Pexip is the better fit despite the additional infrastructure and Pro license requirement. See the [Interop Comparison](comparison.md) for the full feature matrix and [Pexip CVI](pexip-cvi.md) for deployment details.

## Enabling Direct Guest Join

### Teams Rooms on Windows: Three Methods

**Pro Management Portal:** Rooms > select room > Settings > Meetings > toggle desired platforms > Apply

**Local device settings:** More > Settings > enter admin credentials > Meetings tab > select providers

**SkypeSettings.xml configuration file:**

```xml
<WebexMeetingsEnabled>True</WebexMeetingsEnabled>
<ZoomMeetingsEnabled>True</ZoomMeetingsEnabled>
<GoogleMeetMeetingsEnabled>True</GoogleMeetMeetingsEnabled>
```

Optional custom identity for third-party meetings:

```xml
<UseCustomInfoForThirdPartyMeetings>true</UseCustomInfoForThirdPartyMeetings>
<CustomDisplayNameForThirdPartyMeetings>Conference Room A</CustomDisplayNameForThirdPartyMeetings>
<CustomDisplayEmailForThirdPartyMeetings>confrooma@contoso.com</CustomDisplayEmailForThirdPartyMeetings>
```

### Teams Rooms on Android

**Teams Admin Center:** Teams devices > Teams Rooms on Android > Configuration Profiles > Add/edit profile > Third party meetings section > toggle platforms > Save > assign to devices

**Local device settings:** More > Settings > Teams admin settings > Meetings > toggle providers

## Exchange Mailbox Prerequisite

The room's Exchange resource account must be configured to process external meeting invites and retain the meeting body (which contains the join URLs):

```powershell
Set-CalendarProcessing <RoomUPN> -ProcessExternalMeetingMessages $True -DeleteComments $False
```

Without this, externally forwarded meeting invites will be stripped of their join links.

## URL Rewrite Considerations

If your organization uses a third-party URL scanner (not Defender for Office 365 Safe Links, which works without changes), add these to your "don't rewrite" exception list:

- Cisco Webex: `*.webex.com/*`
- Zoom: `*.zoom.us/*`, `*.zoom.com/*`, `*.zoomgov.com/*`
- Google Meet: `*.meet.google.com/*`

## Limitations vs. Native Meetings

| Limitation | Detail |
|------------|--------|
| Max video quality | 720p send and receive |
| Content sharing | Receive only: cannot send via HDMI or content camera |
| Display support | Single display only (no dual-screen) |
| Reactions | Cannot send |
| Annotations | Cannot view |
| Transcription | Cannot view |
| Lobby control | Not available |
| Coordinated join | Not supported |
| Events/Webinars | Not available via DGJ |
| Internet access | Requires direct internet access to the third-party platform |

## Related Topics

- [Cloud Video Interop](cloud-video-interop.md): Higher-quality alternative requiring CVI partner
- [Interop Comparison](comparison.md): CVI vs DGJ vs SIP feature matrix
- [SkypeSettings.xml Reference](../reference/skypesettings-reference.md): Full XML configuration reference
- [Exchange Configuration](../02-prerequisites/exchange-configuration.md): Calendar processing prerequisites

## References

- [Third-party meetings on Teams Rooms: Microsoft Learn](https://learn.microsoft.com/en-us/microsoftteams/rooms/third-party-join)
