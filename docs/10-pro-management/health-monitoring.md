# Health Monitoring and Signals

## Overview

The monitoring agent (Teams Rooms Pro Monitoring Software) deployed on each device sends telemetry to PMP cloud services. The service monitors applications health, operating system health, peripheral health, firmware health, network status, and Teams Rooms app heartbeat.

## Health Signal Types

### Critical/Important Signals (Affect Health Status)

| Signal | Description |
|--------|-------------|
| Display | Connected display not healthy |
| Conference microphone | Audio recording device misconfigured |
| Conference speaker | Audio output device misconfigured |
| Camera | Connected camera not healthy |
| HDMI Ingest | HDMI ingest not healthy |
| Sign-In (Exchange) | Calendar access/Exchange sign-in failure |
| Sign-In (Teams) | Teams sign-in failure |
| Proximity Sensor | Proximity join feature failures |

### Warning Signals (Do Not Affect Health Status)

| Signal | Description |
|--------|-------------|
| App version | Teams Rooms app version not current |
| OS version | Windows OS version no longer recommended |

## Health Determination

A room is considered **unhealthy** if Critical/Important tickets impacted it for more than 20 total minutes during non-maintenance hours (5 AM: 12 AM local time). Health is aggregated daily at 12:00 AM UTC.

The meeting impact view shows scheduled meetings during which Critical/Important tickets were open.

## Signal Management

- **Show All Signals** toggle expands each category to show underlying signals
- Individual signals can be **suppressed** (silencing notifications) when a device is in known maintenance
- **Unsuppress** when monitoring should resume

## Android Device Signals

For Android devices transitioning to PMP, health signals include sign-on, heartbeat, network status, and poor call quality signals.

## Related Topics

- [Portal Overview](portal-overview.md): Dashboard, rooms, incidents, configuration
- [Analytics & Reporting](analytics-reporting.md): Health and usage reports
- [ServiceNow Integration](servicenow-integration.md): Incident ticket export

## References

- [Health signals](https://learn.microsoft.com/en-us/microsoftteams/rooms/signals)
- [Health reports](https://learn.microsoft.com/en-us/microsoftteams/rooms/health-and-usage-reports)
- [Device health monitoring](https://learn.microsoft.com/en-us/microsoftteams/alerts/device-health-status)
