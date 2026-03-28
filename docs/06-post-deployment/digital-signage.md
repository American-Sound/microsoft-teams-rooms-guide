# Digital Signage on Teams Rooms

## Overview

Teams Rooms on Windows devices can display digital signage content on the front-of-room display when the room is not in a meeting. This transforms idle meeting room displays into communication surfaces for company announcements, wayfinding, event schedules, dashboards, or branded content: without deploying separate signage hardware.

The built-in signage feature in Teams Rooms displays a web URL as a full-screen iframe on the front-of-room display. It activates after a configurable idle period and dismisses automatically when a meeting begins or someone interacts with the touch console.

## Requirements

- Teams Rooms on Windows (not supported on Android)
- Teams Rooms Pro license
- Signage content hosted at an HTTPS URL accessible from the device's network
- Content must be designed for passive, non-interactive display (no touch input on the front-of-room display)

## Built-In Signage Configuration

### Via Pro Management Portal (Recommended)

1. Sign in to the [Pro Management Portal](https://portal.rooms.microsoft.com)
2. Select the room(s) to configure
3. Navigate to **Settings** > **Digital Signage**
4. Configure:
   - **Enable Digital Signage**: On
   - **Signage URL**: The HTTPS URL of your signage content
   - **Activation timeout**: Minutes of idle time before signage appears (default: 5 minutes)
   - **Enable banner**: Optionally overlay a banner with room name, next meeting, or clock
5. Apply now or schedule for the maintenance window

Bulk configuration is supported via Device Settings Jobs: select multiple rooms and push the same signage URL to all of them.

### Via SkypeSettings.xml

For devices not managed through the portal or for scripted deployments:

```xml
<SkypeSettings>
  <DigitalSignage>
    <Enabled>true</Enabled>
    <Url>https://signage.contoso.com/lobby-display</Url>
    <ActivationTimeout>5</ActivationTimeout>
  </DigitalSignage>
</SkypeSettings>
```

Place at:
```
C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\SkypeSettings.xml
```

See [SkypeSettings.xml Reference](../reference/skypesettings-reference.md) for the full configuration reference.

## Third-Party Signage Platforms

The built-in signage feature accepts any HTTPS URL, which means you can point it at a third-party signage CMS that renders content for display. Two platforms that work well with Teams Rooms are Appspace and Navori.

### Appspace

Appspace is a cloud-based workplace experience platform with a dedicated Teams Rooms signage integration.

**Integration approach:** Appspace provides a purpose-built card for Teams Rooms that renders signage content optimized for the front-of-room display resolution and aspect ratio. Content is managed in the Appspace console and delivered via a URL that you configure in the Teams Rooms signage settings.

**Key capabilities:**
- Drag-and-drop content designer with templates optimized for meeting room displays
- Channel-based content scheduling: different content at different times of day or days of the week
- Room-aware content using calendar data: display the day's meeting schedule, room availability, or wayfinding
- Integration with Microsoft 365 for pulling SharePoint news, Power BI dashboards, and Teams announcements into signage playlists
- Centralized management across hundreds of rooms from a single console
- Analytics on content impressions and display uptime

**Configuration:**
1. In the Appspace console, create a channel for Teams Rooms signage
2. Design and schedule content cards for the channel
3. Publish the channel and copy the display URL
4. In the Pro Management Portal, set the signage URL to the Appspace channel URL
5. Content updates in Appspace are reflected automatically on the display: no device-side changes needed

**Licensing:** Appspace requires its own subscription (per-screen or enterprise licensing). This is separate from the Teams Rooms Pro license.

### Navori

Navori QL is a digital signage and content management platform with enterprise-grade content scheduling, real-time data integration, and support for high-resolution display output.

**Integration approach:** Navori renders signage content through a web player that can be pointed at from the Teams Rooms signage URL. Content is authored and scheduled in Navori's management console and served to the display via a per-screen URL.

**Key capabilities:**
- Advanced content scheduling with dayparting, conditional triggers, and playlist management
- Real-time data overlays: pull live data from APIs, databases, or spreadsheets into signage layouts
- Support for 4K and multi-zone layouts optimized for large-format displays
- Proof-of-play reporting for compliance and content audit trails
- On-premises or cloud-hosted management server options
- AI-driven content optimization and audience analytics (Navori QL with Aquaji)

**Configuration:**
1. In the Navori management console, create a player instance for the Teams Room display
2. Assign content playlists and schedules to the player
3. Copy the web player URL for that screen
4. In the Pro Management Portal, set the signage URL to the Navori player URL
5. Navori manages all content rotation and scheduling server-side

**Licensing:** Navori requires its own subscription (per-player licensing). This is separate from the Teams Rooms Pro license.

### Choosing Between Platforms

| Consideration | Appspace | Navori |
|---------------|----------|--------|
| **Best for** | Organizations deep in the Microsoft ecosystem wanting seamless M365 content integration | Organizations needing advanced scheduling, real-time data overlays, or proof-of-play compliance |
| **Microsoft integration** | Native M365 connectors (SharePoint, Power BI, Teams) | Generic API/data connectors |
| **Content authoring** | Template-based, drag-and-drop | Template-based with advanced layout designer |
| **Real-time data** | Via M365 connectors and Power BI | Native API/database/spreadsheet integration |
| **Proof-of-play** | Basic analytics | Full proof-of-play audit trail |
| **Deployment model** | Cloud only | Cloud or on-premises |
| **Room-aware content** | Yes (calendar integration) | Via API integration |

For most deployments where the tenant is Microsoft-centric, Appspace is the simpler integration path. Navori is the stronger choice when clients need granular scheduling control, real-time data feeds from non-Microsoft sources, or proof-of-play reporting for regulatory or contractual requirements.

## Content Design Best Practices

Signage content on Teams Rooms displays has specific constraints:

- **No touch interaction**: the front-of-room display is view-only. All content must be passive.
- **Design for distance**: meeting room displays are typically viewed from 6-15 feet. Use large fonts (minimum 24pt), high-contrast colors, and minimal text per screen.
- **Landscape orientation**: front-of-room displays are always landscape. Design at 1920x1080 or 3840x2160 for 4K displays.
- **Auto-rotation**: if displaying multiple pieces of content, rotate automatically with 10-15 second dwell time per slide.
- **Avoid video with audio**: the room's audio system will play signage audio, which is disruptive if someone walks in. Use silent video or static content.
- **Respect the banner**: if the Teams Rooms banner overlay is enabled, keep critical content out of the bottom 10% of the screen where the banner renders.
- **Network bandwidth**: signage content loads over the same network connection as Teams meetings. Avoid heavy video loops that could saturate bandwidth before a meeting starts.

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| Signage not appearing | Signage not enabled or URL not set | Verify configuration in PMP or SkypeSettings.xml |
| Blank screen after idle | URL unreachable from device network | Test URL in a browser on the device; check firewall/proxy rules |
| Content not updating | Browser cache or CMS publish delay | Most CMS platforms handle cache-busting; check platform-specific settings |
| Signage doesn't dismiss for meetings | Activation timeout misconfigured | Verify the Teams Rooms app is signed in and calendar is syncing |
| Low resolution or scaled content | Content not designed for display resolution | Design at native resolution (1080p or 4K) |
| Audio playing from signage | Video content with audio track | Mute audio in the signage content or use silent video |

## Related Topics

- [Pro Management Portal](../10-pro-management/portal-overview.md): Signage configuration via portal
- [SkypeSettings.xml Reference](../reference/skypesettings-reference.md): XML-based signage configuration
- [Monitoring and Alerting](monitoring-alerting.md): Monitor signage display health
