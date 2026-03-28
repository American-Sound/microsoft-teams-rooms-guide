# ServiceNow Integration

## Overview

PMP pushes incidents to ServiceNow's Table API via a REST API integration configured within the portal.

## Prerequisites

- Teams Rooms Pro management license
- Service Administrator role in PMP
- ServiceNow instance with Table API support
- Role of `incident_manager` or higher in ServiceNow
- **Not available for GCC or GCCH customers** (use email notifications and ITSM email ingest instead)

## Authentication Methods

- Basic Authorization
- OAuth (using ServiceNow's OAuth application framework)

## Configuration

1. In PMP, navigate to **Settings > ServiceNow**
2. Select authentication method, enter ServiceNow Instance Host and API URI
3. Complete the Field Mapping section:
   - `short_description` → Incident description (auto-filled)
   - `description` → First Message (auto-filled)
   - `assignment_group` → Room group (copy from ServiceNow)
   - `severity` → Rings (custom values)
   - `comments` (optional, custom field mapping)
   - `state (resolved)` → Resolution state value
   - `close_code` → Resolution close code
4. **Test** the configuration (required before submission)
5. **Submit**, then toggle "Do you want to enable ServiceNow?" to On

The ticket export includes a `SnowIncident` field (e.g., "INC11684776") for correlation.

> **Note:** O365 connector webhooks were deprecated in 2024. The ServiceNow REST API integration is the current and supported method.

## Related Topics

- [Portal Overview](portal-overview.md): PMP dashboard and incident management
- [Health Monitoring](health-monitoring.md): Signals that generate incidents for ServiceNow

## References

- [Configure ServiceNow for Teams Rooms](https://learn.microsoft.com/en-us/microsoftteams/rooms/microsoft-teams-rooms-configure-servicenow)
