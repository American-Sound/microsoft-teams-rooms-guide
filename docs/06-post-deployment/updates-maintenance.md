# Updates and Maintenance

## Overview

Keeping Microsoft Teams Rooms devices updated ensures security, stability, and access to new features. This guide covers update management strategies for both Windows and Android platforms.

> **Critical: EWS Deprecation for Android MTR.** Android MTR devices must be updated to the February 2026 release (build 1449/1.0.96.2025421910 or later) to maintain calendar functionality after Microsoft deprecates Exchange Web Services. Devices running older firmware will lose calendar sync, which means no meeting information on the room display and no one-touch join. Prioritize this update for any Android MTR fleet.

## Update Types

### Teams Rooms Application

The MTR application receives regular updates:
- Feature updates
- Bug fixes
- Security patches
- Performance improvements

### Operating System

**Windows MTR:**
- Windows quality updates (monthly)
- Windows feature updates (annual)
- Security updates

**Android MTR:**
- Vendor-provided firmware updates
- Security patches (vendor-dependent)

### Peripheral Firmware

- Camera firmware
- Audio device firmware
- Touch console firmware

## Update Channels

### Windows MTR Update Channels

| Channel | Description | Recommendation |
|---------|-------------|----------------|
| **General Availability** | Stable releases | Production devices |
| **Preview** | Early access | Test devices only |

### Configuring Update Channel

**Via Pro Management Portal:**
1. Navigate to **[Pro Management Portal](https://portal.rooms.microsoft.com)** > **Rooms**
2. Select device or use update rings to manage channels across device groups
3. Configure update ring assignment (Staging, General, or Executive)

**Via Intune:**
Configure in device configuration profile (for Windows Update rings and deferrals).

## Update Management Strategies

### Strategy 1: Automatic Updates (Default)

Let devices update automatically:

**Pros:**
- No manual intervention
- Always current
- Simplest approach

**Cons:**
- Less control over timing
- Potential for unexpected issues
- Updates during business hours possible

### Strategy 2: Controlled Rollout

Manage updates in waves:

**Update Rings:**
```
Ring 1 (Pilot): 5% of devices - Test first
Ring 2 (Early): 25% of devices - Validate
Ring 3 (Production): 70% of devices - Full rollout
```

**Implementation:**
1. Create device groups per ring
2. Configure update deferrals
3. Monitor pilot before expanding

### Strategy 3: Manual Approval

Approve each update manually:

**Pros:**
- Maximum control
- Test before deployment

**Cons:**
- Requires active management
- Risk of falling behind

## Windows Update Configuration

### Update Rings (Intune)

Create update ring for MTR:

1. **Intune Admin Center** > **Devices** > **Windows** > **Update rings**
2. Create ring:

```
Name: MTR-Update-Ring
Quality update deferral: 7 days
Feature update deferral: 60 days
Automatic update behavior: Download and install at maintenance time
Maintenance start time: 2:00 AM
Maintenance duration: 3 hours
Restart grace period: 2 days
```

### Maintenance Window

Configure when updates install:

**Active Hours:**
```
Start: 7:00 AM
End: 8:00 PM
```

Updates install outside active hours.

**Maintenance Window:**
```
Start: 2:00 AM
Duration: 4 hours
```

## Teams Rooms App Updates

### Automatic Updates

By default, MTR app updates automatically:
- Checks for updates daily
- Installs during non-meeting times
- Restarts if required

### Manual Updates

Force update via:

**Pro Management Portal (Windows MTR):**
1. Select device in PMP
2. Use update rings or push updates through the portal
3. PMP manages app and OS update orchestration for Windows MTR

**Teams Admin Center (Android MTR only, transitioning to PMP):**
1. Select device under **Teams devices** > **Teams Rooms on Android**
2. **Actions** > **Update software**
3. Select update and apply

**On Device:**
1. Access admin settings
2. Check for updates
3. Install available updates

### Update Deferral

Defer app updates via Intune policy:

```
OMA-URI: ./Vendor/MSFT/Policy/Config/Update/DeferUpdatePeriod
Value: 7 (days)
```

## Android MTR Updates

### Vendor-Managed Updates

Android MTR firmware updates are typically:
- Provided by device vendor
- Delivered via vendor cloud platform
- Scheduled through vendor management console

### Update Sources

| Vendor | Management Platform |
|--------|-------------------|
| Poly | Poly Lens |
| Logitech | Logitech Sync |
| Yealink | Yealink Management Cloud |
| Neat | Neat Pulse |

### Best Practices for Android Updates

1. **Enable automatic updates** in vendor platform
2. **Schedule maintenance windows** for off-hours
3. **Monitor update status** per device
4. **Test updates** on pilot devices first

## Peripheral Firmware

### Updating Peripheral Firmware

Peripherals may require separate updates:

**Camera/Audio Firmware:**
- Check vendor websites for updates
- Use vendor update tools
- Some update via MTR app automatically

**Touch Controller:**
- Usually updates with main system
- May have separate firmware updates

### Managing Peripheral Updates

1. **Inventory peripherals** by model and firmware
2. **Track firmware versions** in documentation
3. **Schedule updates** during maintenance
4. **Test after updates** to verify functionality

## Maintenance Tasks

### Regular Maintenance

| Task | Frequency | Description |
|------|-----------|-------------|
| Check health status | Daily | Review dashboard |
| Review updates | Weekly | Check pending updates |
| Apply updates | Weekly/Monthly | Install approved updates |
| Restart devices | Monthly | Clear memory, apply pending |
| Verify peripherals | Monthly | Check all connected |
| Clean devices | Monthly | Physical cleaning |
| Review logs | As needed | Troubleshoot issues |

### Maintenance Checklist

```
□ Review device health in Pro Management Portal (Windows MTR) or TAC (Android/Panels/Phones)
□ Check for pending software updates
□ Review and resolve active incidents
□ Verify all peripherals connected and working
□ Check compliance status in Intune
□ Review meeting quality metrics
□ Schedule maintenance window if updates pending
□ Document any issues or changes
```

## Change Management

### Pre-Update Preparation

1. **Review release notes** - Understand changes
2. **Test on pilot devices** - Validate compatibility
3. **Notify stakeholders** - Communicate maintenance window
4. **Have rollback plan** - Know how to revert

### Post-Update Validation

1. **Verify device boots** correctly
2. **Test meeting join** functionality
3. **Check peripheral operation**
4. **Confirm compliance** status
5. **Monitor for issues** for 24-48 hours

### Rollback Procedures

**Windows MTR:**
- Windows recovery options
- System restore (if enabled)
- Re-image device (last resort)

**Android MTR:**
- Factory reset
- Contact vendor support
- May require manual firmware downgrade

## Automation

### Automated Update Notifications

```powershell
# Example: Check for devices needing updates
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

$devices = Get-MgDeviceManagementManagedDevice -Filter "startswith(deviceName, 'MTR-')"

foreach ($device in $devices) {
    # Check for pending updates
    # Send notification if updates pending
}
```

### Automated Health Checks

Schedule daily health check scripts:
- Query device status
- Check for offline devices
- Alert on issues
- Generate daily report

## Troubleshooting Updates

### Update Failures

| Issue | Cause | Solution |
|-------|-------|----------|
| Update stuck | Network issue | Restart, check connectivity |
| Update failed | Insufficient space | Clear temp files, check disk |
| Rollback occurred | Compatibility issue | Check logs, contact support |
| Device won't boot | Corrupted update | Recovery mode, re-image |

### Checking Update Status

**Via Intune:**
1. Select device
2. View **Device configuration** status
3. Check **Update rings** compliance

**On Windows Device:**
```powershell
Get-WindowsUpdateLog
# Or check Settings > Update & Security > Update History
```

## Best Practices

1. **Don't skip updates** - Security risk
2. **Test before production** - Use pilot devices
3. **Schedule maintenance** - Outside business hours
4. **Communicate downtime** - Notify users
5. **Monitor after updates** - Catch issues early
6. **Keep firmware current** - All components
7. **Document everything** - Track versions and changes
8. **Have rollback plan** - Always be prepared

## Related Topics

- [Pro Management Portal](../10-pro-management/portal-overview.md)
- [Teams Admin Center](teams-admin-center.md)
- [Monitoring and Alerting](monitoring-alerting.md)
- [Troubleshooting](troubleshooting.md)
