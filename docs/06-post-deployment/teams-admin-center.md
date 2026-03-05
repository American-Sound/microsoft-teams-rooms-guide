# Teams Admin Center and Teams Rooms

## Overview

The Microsoft Teams Admin Center (TAC) at **admin.teams.microsoft.com** is the central portal for managing Teams-wide policies, users, phone numbers, and meeting settings. However, as of June 2025, **Teams Rooms on Windows device management has moved entirely to the Pro Management Portal** (portal.rooms.microsoft.com). TAC no longer provides device health, remote actions, configuration profiles, or update management for Windows MTR devices.

TAC remains relevant for Teams Rooms in two areas:

1. **Teams policies** — Calling policies, meeting policies, messaging policies, and other tenant-wide settings that apply to resource accounts are still configured in TAC (or PowerShell).
2. **Call Quality Dashboard (CQD)** — The primary tool for analyzing call and meeting quality data across your Teams Rooms fleet. CQD is accessed from TAC and is the most valuable TAC feature for ongoing MTR operations.

### Device Management by Platform

| Platform | Management Portal | Notes |
|----------|------------------|-------|
| Teams Rooms on Windows | **Pro Management Portal** | Moved from TAC in June 2025 |
| Teams Rooms on Android | Teams Admin Center | Transitioning to PMP through 2026 |
| Teams Panels | Teams Admin Center | Transitioning to PMP in 2026 |
| Teams Phones | Teams Admin Center | — |
| Teams Displays | Teams Admin Center | — |

## Accessing Teams Admin Center

**URL:** https://admin.teams.microsoft.com

**Required Permissions:**
- Teams Administrator
- Teams Device Administrator (for Android/Panels/Phones device management)
- Global Administrator

## Call Quality Dashboard (CQD)

CQD is the primary reason to use TAC for Teams Rooms troubleshooting. It provides detailed call quality analytics, historical trend data, and the ability to drill into specific call failures across your entire MTR fleet.

### Accessing CQD

1. Navigate to **Teams Admin Center** > **Analytics & reports** > **Call quality dashboard**
2. Or go directly to: **https://cqd.teams.microsoft.com**

### What CQD Provides

- **Call quality metrics** — Audio and video stream quality ratings (Good/Poor) for every call and meeting involving MTR devices
- **Failure analysis** — Call setup failures, drops, and media establishment errors
- **Network diagnostics** — Jitter, packet loss, latency, and round-trip time per stream
- **Historical trending** — Quality trends over days, weeks, or months to identify degradation patterns
- **Building/location mapping** — When subnets are mapped to buildings, CQD can report quality by physical location
- **Comparative analysis** — Compare quality across device types, locations, network segments, or time periods

### Building Data Upload

To get location-aware reporting, upload your building and subnet data:

1. In CQD, navigate to **Tenant Data Upload**
2. Upload a CSV mapping subnets to building names, cities, and countries
3. Format:

```csv
Network,NetworkName,NetworkRange,BuildingName,OwnershipType,BuildingType,BuildingOfficeType,City,ZipCode,Country,State,Region,InsideCorp,ExpressRoute
10.10.1.0,HQ-Floor1,24,Headquarters,Contoso,Office,Main,Seattle,98101,US,WA,West,1,0
10.10.2.0,HQ-Floor2,24,Headquarters,Contoso,Office,Main,Seattle,98101,US,WA,West,1,0
10.20.1.0,Branch-Main,24,Branch Office,Contoso,Office,Branch,Portland,97201,US,OR,West,1,0
```

4. Allow 24-48 hours for data to process and appear in reports

### Power BI Template for CQD

Microsoft provides a Power BI template that connects directly to CQD data and produces a comprehensive visual dashboard for MTR call quality analysis. This is the recommended approach for ongoing monitoring and executive reporting.

**Setup:**

1. Download the **CQD Power BI Connector** from Microsoft:
   - In CQD, click the **Power BI** icon in the top navigation
   - Or download from the [Microsoft Download Center](https://www.microsoft.com/download/details.aspx?id=102291)
2. Install the connector (MQD.mez file) into your Power BI custom connectors directory:
   ```
   %USERPROFILE%\Documents\Power BI Desktop\Custom Connectors\
   ```
3. Download the **CQD Teams Rooms report templates** (.pbit files) from the same source
4. Open the template in Power BI Desktop
5. When prompted, authenticate with your Teams Admin credentials
6. The template connects to CQD data and populates the dashboards

**Available Report Templates:**

| Template | Purpose |
|----------|---------|
| CQD Teams Auto Attendant & Call Queue Historical Report | AA/CQ performance (not MTR-specific) |
| CQD Teams Utilization Report | Overall Teams usage metrics |
| CQD PSTN Direct Routing Report | Direct Routing call quality |
| **CQD Teams Rooms Report** | **MTR-specific call quality — use this one** |

**CQD Teams Rooms Report includes:**

- Room-level call quality summary (good vs. poor streams per room)
- Audio quality detail (jitter, packet loss, NMOS scores) per MTR device
- Video quality detail (frame rate, resolution, freeze events)
- Call failure analysis by room, by time period, by failure type
- Network quality by subnet/building (requires building data upload)
- Trend analysis — quality degradation over time to catch issues before users report them
- Peripheral health correlation — quality metrics correlated with specific camera/microphone/speaker models

**Publishing and Sharing:**

1. After the template loads, publish the report to your Power BI workspace
2. Configure a scheduled refresh (daily recommended) so the data stays current
3. Share the workspace with your support team and stakeholders
4. Pin key visuals to a Power BI dashboard for at-a-glance monitoring

### CQD Filters for Teams Rooms

When querying CQD directly (without the Power BI template), use these filters to isolate MTR data:

| Filter | Value | Purpose |
|--------|-------|---------|
| **User Agent Category** | Teams Rooms | Filter to MTR devices only |
| **Second User Agent Category** | (varies) | Filter the remote participant type |
| **Building Name** | (your building) | Filter by location |
| **Is Server Pair** | Client : Client | Peer-to-peer calls |
| **Is Server Pair** | Client : Server | Conference calls |

### Common CQD Investigations for MTR

**"Users report poor audio in Room X"**
1. Filter CQD to the specific room's resource account UPN
2. Check audio stream quality — look for high jitter (>30ms), packet loss (>2%), or poor NMOS scores (<3.5)
3. Compare against other rooms in the same building to isolate room-specific vs. network-wide issues
4. Check if the issue correlates with specific times (congestion) or specific remote participant types

**"Call drops in a specific building"**
1. Filter by Building Name
2. Look at call setup failure rates and mid-call drop rates
3. Check network metrics (packet loss, jitter) by subnet
4. Compare against other buildings to confirm the issue is location-specific

**"Quality degraded after a network change"**
1. Use date range filters to compare before/after the change
2. Look for changes in packet loss, jitter, or round-trip time
3. Check if the issue affects all device types or only MTR

## Policies Managed in TAC

The following Teams policies apply to MTR resource accounts and are configured in TAC (or via PowerShell):

| Policy Type | TAC Location | Relevance to MTR |
|-------------|-------------|-------------------|
| Meeting policy | Meetings > Meeting policies | Controls transcription, recording, lobby, content sharing |
| Calling policy | Voice > Calling policies | Controls call forwarding, voicemail, delegation |
| Caller ID policy | Voice > Caller ID policies | Controls outbound caller ID for PSTN calls |
| Voice routing policy | Voice > Direct Routing | Routes calls through specific SBCs |
| Dial plan | Voice > Dial plan | Normalizes dialed numbers |
| Update policy | Teams devices > Configuration profiles | Android MTR update management (transitioning to PMP) |
| IP phone policy | Teams devices > IP Phone policies | Phones and shared devices |

> **Note:** Meeting policies, calling policies, and voice routing policies are assigned to the resource account UPN via PowerShell (`Grant-CsTeamsMeetingPolicy`, `Grant-CsTeamsCallingPolicy`, etc.) or via TAC user management. These are tenant-level Teams settings, not device management — they remain in TAC regardless of whether the device itself is managed in PMP.

## Android Device Management (Transitioning)

TAC still provides device management for Teams Rooms on Android through the transition to PMP (expected completion H2 2026):

1. Navigate to **Teams Admin Center** > **Teams devices** > **Teams Rooms on Android**
2. Available actions: Restart, Download logs, Update software, Sign out
3. Configuration profiles for Android MTR can still be created and assigned in TAC
4. Device health and peripheral status are visible in the device detail view

This functionality will move to PMP. Plan accordingly and begin familiarizing your team with PMP for Android device management.

## What TAC No Longer Does for Windows MTR

For clarity, the following capabilities have moved to the **Pro Management Portal** and are no longer available in TAC for Windows MTR devices:

- Device inventory and health status
- Remote actions (restart, sign out, ring device, download logs)
- Configuration profiles and per-device settings
- Software update management and update rings
- Peripheral health monitoring
- Incident management and alerting
- Analytics and usage reporting (device-level; CQD call quality remains in TAC)

See [Pro Management Portal](../10-pro-management/portal-overview.md) for full documentation on these capabilities.

## Related Topics

- [Pro Management Portal](../10-pro-management/portal-overview.md) — Windows MTR device management
- [Monitoring and Alerting](monitoring-alerting.md) — Alerting configuration
- [Troubleshooting](troubleshooting.md) — Diagnostic procedures
- [Updates and Maintenance](updates-maintenance.md) — Update management strategies

## References

- [CQD for Teams Rooms — Microsoft Learn](https://learn.microsoft.com/en-us/microsoftteams/rooms/with-office-365#call-quality)
- [Use Power BI to analyze CQD data — Microsoft Learn](https://learn.microsoft.com/en-us/microsoftteams/cqd-power-bi-query-templates)
- [Upload building data to CQD — Microsoft Learn](https://learn.microsoft.com/en-us/microsoftteams/cqd-upload-tenant-building-data)
