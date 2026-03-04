# Monitoring and Alerting

## Overview

Effective monitoring ensures Teams Rooms devices remain operational and issues are addressed before impacting meetings. This guide covers monitoring strategies, alerting configuration, and best practices.

## Monitoring Options

### Microsoft Native Solutions

| Solution | Best For | License Required |
|----------|----------|------------------|
| Teams Admin Center | Basic monitoring | Teams Rooms Basic/Pro |
| Pro Management Portal | Advanced monitoring | Teams Rooms Pro |
| Microsoft 365 Admin Center | Service health | Any M365 |
| Azure Monitor | Custom monitoring | Azure subscription |

### Third-Party Solutions

- PRTG Network Monitor
- Nagios/Zabbix
- ServiceNow
- Vendor-specific platforms (Poly Lens, Logitech Sync, etc.)

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

### Configuring Alerts

1. Navigate to **Teams Admin Center** > **Notifications & alerts**
2. Click **Rules** > **Add rule**
3. Configure:

**Device Offline Alert:**
```
Rule name: MTR Offline Alert
Condition: Device is offline
Duration: 15 minutes
Scope: All Teams Rooms devices
Notification: Email to helpdesk@contoso.com
```

**Health Change Alert:**
```
Rule name: MTR Health Degraded
Condition: Device health state changed to Warning or Critical
Scope: All Teams Rooms devices
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
