# Teams Admin Center Device Management

## Overview

The Microsoft Teams Admin Center (TAC) provides device management capabilities for Teams devices. As of June 2025, Teams Rooms on Windows management has moved to the [Pro Management Portal](../10-pro-management/portal-overview.md). TAC remains the primary management surface for Teams Rooms on Android, Panels, and Phones, though Android device management is transitioning to PMP in phases through 2026. TAC continues to handle Teams-wide administration including policies, users, and meeting settings.

## Accessing Teams Admin Center

### URL

Navigate to: **https://admin.teams.microsoft.com**

### Required Permissions

Access requires one of:
- Teams Administrator
- Teams Device Administrator
- Global Administrator

## Device Inventory

### Viewing Devices

1. Navigate to **Teams devices** in left menu
2. Select device category:
   - **Teams Rooms on Windows**
   - **Teams Rooms on Android**
   - **Panels**
   - **Phones**
   - **Displays**

### Device Information

Each device listing shows:
- Device name
- Health status
- Signed-in user (resource account)
- IP address
- Last activity

### Filtering and Sorting

Filter devices by:
- Health status
- Tag
- Software version
- Manufacturer

Sort by:
- Name
- Health
- Last activity
- Software version

## Device Details

### Accessing Device Details

1. Click on device in list
2. View detailed information

### Information Tabs

**Overview:**
- Health status
- Basic device info
- Signed-in account
- Software version

**Health:**
- Current health state
- Peripheral status
- Last health check

**Activity:**
- Recent meetings
- Usage statistics

**History:**
- Configuration changes
- Incident history

**Diagnostics:**
- Diagnostic logs
- Connectivity info

## Remote Actions

### Available Actions

| Action | Description | Platform |
|--------|-------------|----------|
| Restart | Reboot device | All |
| Download logs | Collect diagnostic logs | All |
| Update software | Push software update | All |
| Sign out | Sign out resource account | All |
| Ring device | Play sound on device | Windows |

### Performing Actions

1. Select device
2. Click **Actions** dropdown
3. Select action
4. Confirm if prompted

### Bulk Actions

For multiple devices:
1. Select checkboxes for devices
2. Click **Actions** at top
3. Select bulk action
4. Confirm

## Configuration

### Device Settings

Configure per-device settings:

1. Select device
2. Navigate to **Configuration** tab
3. Edit settings:
   - Display name
   - Theme
   - Meeting defaults
   - Peripheral settings

### Configuration Profiles

Apply settings to groups:

1. Navigate to **Teams devices** > **Configuration profiles**
2. Create new profile
3. Configure settings
4. Assign to devices

**Profile Settings:**
- Teams application settings
- Meeting behaviors
- Peripheral preferences
- Display options

## Software Updates

### View Current Versions

1. Navigate to device category
2. View **Software version** column
3. Or select device > **Overview** > Software version

### Update Process

**Automatic Updates:**
- Devices check for updates regularly
- Install during maintenance window

**Manual Updates:**
1. Select device(s)
2. Actions > **Update software**
3. Select update to apply
4. Confirm

### Update Status

Check update status:
1. Select device
2. View **History** tab
3. Review update events

## Health Monitoring

### Health States

| State | Meaning | Action |
|-------|---------|--------|
| Healthy | All components working | None required |
| Warning | Non-critical issue | Monitor/investigate |
| Critical | Major issue detected | Immediate attention |
| Offline | Device not communicating | Investigate connectivity |

### Peripheral Health

View status of:
- Camera
- Microphone
- Speaker
- Display
- Touch console

### Troubleshooting from TAC

1. Select unhealthy device
2. View **Health** tab
3. Review issues listed
4. Follow recommended actions
5. Download logs if needed

## Teams Rooms Specific

### Teams Rooms on Windows

Additional features:
- Autopilot status
- Intune compliance
- Windows version
- Defender status

### Teams Rooms on Android

Features:
- Android version
- Firmware version
- Vendor information
- AOSP enrollment status

### Coordinated Devices

View devices paired together:
- Teams Room + Panel
- Room system + Touch controller

## Reporting

### Built-in Reports

Access via **Analytics & reports**:
- Device usage
- Device health
- Call quality
- Feature usage

### Usage Reports

View:
- Meetings per device
- Meeting duration
- Participation trends
- Feature adoption

### Export Data

1. Navigate to report
2. Click **Export**
3. Download CSV

## Alerts and Notifications

### Configuring Alerts

1. Navigate to **Notifications & alerts**
2. Create alert rule
3. Configure:
   - Condition (e.g., device offline)
   - Recipients
   - Notification method

### Alert Types

- Device offline
- Health state change
- Update failure
- Sign-in failure

## Comparison: TAC vs Pro Management Portal

| Feature | Teams Admin Center | Pro Management Portal |
|---------|-------------------|----------------------|
| Windows MTR management | No (moved to PMP June 2025) | Yes |
| Android MTR management | Yes (transitioning to PMP H2 2026) | Yes (June 2026+) |
| Panels/Phones management | Yes | Coming 2026 |
| Teams policies & settings | Yes | No |
| Advanced analytics | Limited | Yes (Pro license) |
| Incident management | Basic | Advanced with auto-remediation |
| Update rings | No | Yes (staging, general, executive) |
| Remote settings push | Yes (Android) | Yes (Windows) |
| ServiceNow integration | No | Yes |
| RBAC/custom roles | No | Yes |
| Multi-tenant partner portal | No | Yes |

## Best Practices

1. **Check device health regularly** - At least weekly
2. **Use configuration profiles** - Consistent settings
3. **Monitor update status** - Ensure devices stay current
4. **Set up alerts** - Proactive notification
5. **Download logs early** - When issues occur
6. **Document configurations** - Track changes
7. **Use tags** - Organize devices logically

## Troubleshooting

### Device Not Appearing

- Verify device is signed in
- Check resource account is valid
- Confirm network connectivity
- Wait for sync (up to 24 hours for new devices)

### Actions Not Working

- Verify device is online
- Check your admin permissions
- Confirm device supports action
- Review action history for errors

### Health Not Updating

- Device may be offline
- Check last activity timestamp
- Restart device
- Verify network allows telemetry

## Related Topics

- [Pro Management Portal](../10-pro-management/portal-overview.md)
- [Monitoring and Alerting](monitoring-alerting.md)
- [Troubleshooting](troubleshooting.md)
