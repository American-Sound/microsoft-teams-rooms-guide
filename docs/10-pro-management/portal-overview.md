# Teams Rooms Pro Management Portal

## Overview

The Teams Rooms Pro Management portal is a cloud-based management solution that proactively monitors and updates Microsoft Teams Rooms devices and their peripherals. It provides real-time health monitoring, automated incident detection and remediation, update orchestration, configuration management, and analytics/reporting.

**URL:** [https://portal.rooms.microsoft.com](https://portal.rooms.microsoft.com/)

GCC-High: `https://devices.gov.teams.microsoft.us/` | DoD: `https://devices.dod.teams.microsoft.us/`

## Licensing

No additional license is required to access the portal itself. After May 1, 2025, all Teams Rooms on Windows devices (including Basic-licensed devices) appear in PMP.

| License | Portal Access | Incident Generation | Analytics | Update Rings |
|---------|--------------|--------------------|-----------|----|
| Teams Rooms Pro | Full | Yes | Yes | Yes |
| Teams Rooms Basic | Device inventory only | No | No | No (automatic updates only) |
| Teams Shared Device | Device management | Yes | Yes | — |

As of June 2025, Teams Rooms on Windows are managed exclusively through PMP (no longer available in TAC). Android device management is transitioning to PMP through 2026.

## Portal Sections

### Dashboard / Overview

The Reporting > Overview tab surfaces tenant-wide health trends:

- Tickets by category (Audio, Display, Peripherals, Connectivity, Versioning, Recorded issues)
- Health history graph (your tenant average vs. all Microsoft Pro customers, up to 90 days)
- Most reliable / least reliable rooms
- Rooms history (enrolled, healthy, unmonitored over time)
- Export tickets button (JSON, importable to Power BI)

### Rooms and Devices

Top-panel snapshot of device states:

| State | Description |
|-------|-------------|
| **Healthy** (green) | No Critical or Important severity incidents |
| **Unhealthy** (red) | At least one Critical or Important incident (does not necessarily mean complete outage) |
| **Unmonitored** | Monitoring agent disconnected from cloud, no telemetry (typically network/firewall issues) |
| **Suppressed** | Device in known maintenance state, alerts silenced |

Each room has a Status tab (consolidated issues), Incidents tab (signal category breakdown), and Show All Signals toggle.

### Incident Management

Incidents have two states:

- **Need Action** — requires admin corrective action; includes description, typical causes, resolutions, and Notes tab
- **System Investigating** — under automatic investigation by the AI monitoring platform; next steps provided if auto-remediation fails

**Severity levels:**

| Severity | Impact | Affects Health Status |
|----------|--------|---------------------|
| Critical | Likely causing meeting problems, prioritize immediately | Yes |
| Important | Likely causing meeting problems, prioritize | Yes |
| Warning | Plan maintenance; may escalate if unresolved | No |
| Recommendation | Best practices guidance | No |

Each signal gets one ticket that persists over time, maintaining full history. Tickets include Overview, Notes, Attachments, and History tabs.

### Settings / Configuration

Remotely configure Teams Rooms on Windows via SkypeSettings.xml sync (up to 15 minutes):

**Apply Now** — queues job and restarts device immediately (unavailable if in use)
**Schedule Later** — applies during nightly maintenance window

Configurable settings categories:
- **Account** — Exchange sign-in, public preview enrollment
- **Meetings** — content layout, chat, Front Row, HDMI ingest, captions, people count, third-party meeting join (Webex/Zoom/GoTo/RingCentral/Amazon Chime), Facilitator QR code
- **Device** — dual monitor, resolution/scaling, Bluetooth beaconing, proximity join, QR code join
- **Peripherals** — mic, speaker, camera selection/volume, Cloud IntelliFrame, multi-camera, content camera, noise suppression
- **Coordinated meetings** — mic/camera/whiteboard coordination, trusted device accounts
- **Theming** — background selection
- **Digital Signage** — activation timing, signage source, banner display

Bulk changes are supported via Device Settings Jobs.

## Related Topics

- [Health Monitoring](health-monitoring.md) — Signals, health states, incident management
- [Update Management](update-management.md) — Rings, maintenance windows, controls
- [Analytics & Reporting](analytics-reporting.md) — Usage, health, standards, room planner
- [RBAC](rbac.md) — Roles, permissions, custom roles
- [ServiceNow Integration](servicenow-integration.md) — Incident ticket sync
- [AI Assistant](ai-assistant.md) — Built-in AI for admin queries
- [Multi-Tenant Partner Portal](multi-tenant-partner.md) — MSP management across tenants
- [SkypeSettings.xml Reference](../reference/skypesettings-reference.md) — Configuration settings pushed via PMP
- [Licensing](../01-planning/licensing.md) — Pro vs Basic feature comparison

## References

- [Pro Management overview](https://learn.microsoft.com/en-us/microsoftteams/rooms/rooms-pro-management)
- [Pro Management Portal](https://learn.microsoft.com/en-us/microsoftteams/rooms/managed-meeting-rooms-portal)
- [Enrolling in Pro Management](https://learn.microsoft.com/en-us/microsoftteams/rooms/enrolling-mtrp-managed-service)
