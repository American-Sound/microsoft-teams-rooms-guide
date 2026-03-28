# Monitoring and Alerting

## Overview

Effective monitoring ensures Teams Rooms devices remain operational and issues are addressed before impacting meetings. This guide covers monitoring strategies, alerting configuration, and best practices.

## Monitoring Options

### Microsoft Native Solutions

| Solution | Best For | License Required |
|----------|----------|------------------|
| Teams Admin Center | CQD call quality analytics; device management for Android/Panels/Phones only | Teams Rooms Basic/Pro |
| Pro Management Portal | Advanced monitoring | Teams Rooms Pro |
| Microsoft 365 Admin Center | Service health | Any M365 |
| Azure Monitor | Custom monitoring | Azure subscription |

### Third-Party Solutions

- **Utelogy**: Cloud-native AV monitoring and management platform hosted in Microsoft Azure. Built on Microsoft Graph API, integrates with ServiceNow, and supports multi-vendor AV device monitoring (Cisco, Crestron, Q-SYS, Poly, Logitech, and more) alongside Teams Rooms. Strong fit for organizations invested in the Microsoft ecosystem due to Azure residency and Graph compatibility.
- **PRTG Network Monitor**: Agentless network monitoring with SNMP/WMI support
- **Nagios/Zabbix**: Open-source monitoring platforms with broad device support
- **ServiceNow**: ITSM platform with device monitoring and incident management
- **Cisco Control Hub**: Cloud management portal for Cisco collaboration devices. Monitors device status, diagnostics, and call quality across the Cisco Room Series fleet. Manages firmware, configurations, and provides workspace-level analytics for devices running RoomOS with Teams mode.
- **Crestron XiO Cloud**: Cloud-based provisioning, monitoring, and management platform for Crestron devices. Supports fleet-wide firmware deployment, remote configuration, and real-time device status across Crestron room systems, touch panels, and peripherals.
- **Q-SYS Reflect**: Cloud monitoring and management for Q-SYS ecosystem devices. Provides real-time status, alerting, remote configuration, and firmware management for Q-SYS Cores, peripherals, and networked audio/video endpoints.
- **Poly Lens**: Cloud management for Poly video and audio devices. Provides remote monitoring, firmware updates, configuration management, and device analytics.
- **Logitech Sync**: Cloud portal for Logitech collaboration devices. Offers device health monitoring, room insights, software updates, and remote management capabilities.
- **Yealink Management Cloud**: Centralized cloud platform for Yealink devices. Supports monitoring, diagnostics, firmware management, and usage analytics.
- **Neat Pulse**: Cloud management for Neat devices. Provides device health monitoring, remote configuration, software updates, and room usage analytics.
- **ShureCloud**: Cloud platform for Shure networked audio devices (MXA microphone arrays, IntelliMix DSPs). Monitors device status, manages firmware updates, and provides remote configuration for Shure audio endpoints commonly deployed alongside Teams Rooms.

## Key Metrics to Monitor

### Device Health

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Online status | Device communicating | Offline > 15 min |
| App status | Teams app running | Unhealthy |
| Sign-in status | Account authenticated | Failed |
| Compliance | Intune compliance | Non-compliant |

### Peripheral Health

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Camera | Video device status | Disconnected/Failed |
| Microphone | Audio input status | Disconnected/Failed |
| Speaker | Audio output status | Disconnected/Failed |
| Display | HDMI connection | Disconnected |

### Network Health

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Connectivity | Network reachable | Disconnected |
| Latency | Network delay | > 150ms |
| Packet loss | Data loss rate | > 2% |
| Bandwidth | Available throughput | < 5 Mbps |

### Meeting Quality

| Metric | Description | Alert Threshold |
|--------|-------------|-----------------|
| Call quality | Audio/video quality | Poor |
| Join success | Meeting join rate | < 95% |
| Drop rate | Call disconnections | > 5% |

## Teams Admin Center Alerts

> **Note:** TAC alerting applies to **Android MTR, Panels, and Phones** only. Windows MTR alerting has moved to the Pro Management Portal, which provides automatic incident detection and AI-assisted remediation. See [Pro Management Portal](../10-pro-management/portal-overview.md).

### Configuring Alerts (Android/Panels/Phones)

1. Navigate to **Teams Admin Center** > **Notifications & alerts**
2. Click **Rules** > **Add rule**
3. Configure:

**Device Offline Alert:**
```
Rule name: MTR Offline Alert
Condition: Device is offline
Duration: 15 minutes
Scope: Android Teams Rooms devices, Panels, Phones
Notification: Email to helpdesk@contoso.com
```

**Health Change Alert:**
```
Rule name: MTR Health Degraded
Condition: Device health state changed to Warning or Critical
Scope: Android Teams Rooms devices, Panels, Phones
Notification: Email to teams-support@contoso.com
```

### Alert Notification Options

- Email notification
- Teams channel message (via webhook)
- Action group integration

## Pro Management Portal Alerts

### Built-in Alert Types

The Pro Management Portal provides automatic alerting for:

- Device offline
- Hardware failures
- Software issues
- Sign-in problems
- Meeting quality degradation
- Update failures

### Configuring Alert Recipients

1. Navigate to **Settings** > **Alerts**
2. Configure notification recipients
3. Set alert severity thresholds

### Incident Escalation

Configure escalation paths:
1. **Level 1**: Automatic ticket creation
2. **Level 2**: Email to support team
3. **Level 3**: Escalate to management

## Azure Monitor Integration

### Setting Up Azure Monitor

For advanced monitoring, use Azure Monitor:

1. **Create Log Analytics Workspace**
   ```powershell
   New-AzOperationalInsightsWorkspace -ResourceGroupName "MTR-Monitoring" `
       -Name "MTR-LogAnalytics" `
       -Location "EastUS"
   ```

2. **Configure Diagnostic Settings**
   - Enable audit logs from Entra ID
   - Stream sign-in logs
   - Configure Intune diagnostics

3. **Create Alert Rules**
   ```
   Alert name: MTR Sign-in Failures
   Scope: Log Analytics workspace
   Condition: SigninLogs | where UserPrincipalName startswith "mtr-" and ResultType != "0"
   Action: Send email to support team
   ```

### Sample KQL Queries

**MTR Sign-in Failures:**
```kusto
SigninLogs
| where UserPrincipalName startswith "mtr-"
| where ResultType != "0"
| project TimeGenerated, UserPrincipalName, ResultType, ResultDescription, IPAddress
| order by TimeGenerated desc
```

**MTR Device Activity:**
```kusto
AuditLogs
| where TargetResources[0].displayName startswith "MTR-"
| where ActivityDisplayName contains "Device"
| project TimeGenerated, ActivityDisplayName, Result
| order by TimeGenerated desc
```

## Vendor Monitoring Platforms

### Poly Lens

For Poly devices:
- Remote device monitoring
- Firmware updates
- Configuration management
- Analytics and insights

### Logitech Sync

For Logitech devices:
- Device health monitoring
- Room insights
- Software updates
- Remote management

### Yealink Management Cloud

For Yealink devices:
- Centralized management
- Monitoring and diagnostics
- Firmware management
- Usage analytics

### Cisco Control Hub

For Cisco Room Series devices (Room Bar, Room Kit EQ, Room Kit Pro, Board Pro, etc.):
- Real-time device status, diagnostics, and xAPI access
- Firmware channel management (stable, preview) with staged rollout
- Workspace configuration and room capacity analytics
- Call quality dashboards with per-call media statistics
- Integration with Webex cloud for hybrid deployments

> **Note:** Cisco devices running Teams mode are managed at the RoomOS/device layer through Control Hub and at the Teams app layer through Teams Admin Center and Intune. Both portals are needed for complete device management.

### Crestron XiO Cloud

For Crestron room systems and peripherals:
- Fleet-wide device discovery and provisioning
- Real-time monitoring and alerting for all Crestron endpoints
- Centralized firmware deployment and scheduling
- Remote configuration push across device groups
- Integration with Crestron room scheduling and control systems

### Q-SYS Reflect

For Q-SYS ecosystem devices:
- Real-time status monitoring for Q-SYS Cores, peripherals, and I/O endpoints
- Remote firmware management with staged deployment
- Alerting and notification for device health events
- Configuration backup and restore
- Multi-site management with location-based device grouping

### Neat Pulse

For Neat devices:
- Device health monitoring and diagnostics
- Remote configuration and settings management
- Software update scheduling and deployment
- Room usage analytics and environmental sensors (air quality, humidity)
- Multi-site fleet management with bulk operations

### ShureCloud

For Shure networked audio devices:
- Real-time status monitoring for MXA microphone arrays and IntelliMix DSPs
- Firmware update management across Shure audio endpoints
- Remote configuration of audio processing parameters (beam steering, AEC, noise reduction)
- Device inventory and network discovery
- Integration with Shure Designer for audio system configuration

## Dashboard Creation

### Teams Rooms Dashboard Components

Create a comprehensive dashboard showing:

1. **Health Overview**
   - Total devices
   - Healthy/Warning/Critical/Offline counts
   - Health trend over time

2. **Incident Summary**
   - Active incidents
   - Resolved today
   - Average resolution time

3. **Device Map**
   - Geographic distribution
   - Status by location

4. **Update Status**
   - Devices pending updates
   - Update compliance rate

### Power BI Dashboard

Create Power BI dashboard:
1. Connect to Microsoft 365 data
2. Import Pro Management Portal data (if available)
3. Create visualizations
4. Share with stakeholders

## Alert Response Procedures

### Incident Response Workflow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Alert     │────▶│   Triage    │────▶│  Diagnose   │
│  Triggered  │     │   Impact    │     │   Issue     │
└─────────────┘     └─────────────┘     └─────────────┘
                                               │
                                               ▼
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Close     │◀────│  Verify     │◀────│   Apply     │
│  Incident   │     │   Fix       │     │   Fix       │
└─────────────┘     └─────────────┘     └─────────────┘
```

### Response Time Targets

| Severity | Description | Response Target |
|----------|-------------|-----------------|
| Critical | Room unusable | 15 minutes |
| High | Major feature impacted | 1 hour |
| Medium | Minor issue | 4 hours |
| Low | Cosmetic/informational | Next business day |

### Escalation Matrix

| Level | Time | Action |
|-------|------|--------|
| L1 | 0-15 min | Help desk initial response |
| L2 | 15-60 min | Teams/AV support |
| L3 | 60+ min | Engineering escalation |
| L4 | 4+ hours | Vendor/Microsoft support |

## Proactive Monitoring

### Daily Checks

- Review overnight alerts
- Check device health dashboard
- Verify upcoming meeting rooms are online
- Review any pending updates

### Weekly Reviews

- Analyze incident trends
- Review meeting quality metrics
- Check compliance status
- Plan maintenance activities

### Monthly Reports

- Device health summary
- Incident statistics
- Usage analytics
- Capacity planning

## Best Practices

1. **Define clear thresholds** - Avoid alert fatigue
2. **Prioritize alerts** - Not everything is critical
3. **Document procedures** - Consistent response
4. **Test alerting** - Verify notifications work
5. **Review and tune** - Adjust based on experience
6. **Track metrics** - Measure improvement
7. **Automate remediation** - Where possible
8. **Train support staff** - Know the tools

## Related Topics

- [Pro Management Portal](../10-pro-management/portal-overview.md)
- [Teams Admin Center](teams-admin-center.md)
- [Troubleshooting](troubleshooting.md)
- [Updates and Maintenance](updates-maintenance.md)
