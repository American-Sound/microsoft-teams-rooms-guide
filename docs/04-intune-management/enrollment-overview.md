# Intune Enrollment Overview

## Overview

Microsoft Intune provides cloud-based device management for Microsoft Teams Rooms. Intune enrollment enables remote configuration, compliance monitoring, and policy enforcement across your MTR fleet.

## Enrollment Methods by Platform

| Platform | Enrollment Method | Automation Level |
|----------|-------------------|------------------|
| Windows MTR | Autopilot + Autologin | Full zero-touch |
| Windows MTR | Manual Entra ID Join | Semi-automated |
| Android MTR | AOSP Enrollment | Vendor-guided |
| Teams Panels | Android Enterprise | Device-specific |

## Windows MTR Enrollment

### Option 1: Windows Autopilot (Recommended)

**Best for:** New device deployments, zero-touch provisioning

**How it works:**
1. Hardware vendor registers device IDs with your tenant
2. Device powers on and connects to internet
3. Autopilot downloads configuration
4. MTR app installed, autologin configured
5. Device ready for use

**Requirements:**
- Autopilot hardware ID registration
- Autopilot deployment profile
- MTR Autologin profile
- Intune enrollment configured

See [Windows Autopilot](windows-autopilot.md) for detailed steps.

### Option 2: Manual Entra ID Join

**Best for:** Existing devices, small deployments

**How it works:**
1. Access device local admin settings
2. Join device to Entra ID
3. Intune enrollment automatic (via enrollment settings)
4. Configure MTR app manually

**Steps:**
1. On MTR device, sign out of MTR app
2. Access Windows Settings (Windows key + I)
3. Go to **Accounts** > **Access work or school**
4. Click **Connect** > **Join this device to Microsoft Entra ID**
5. Sign in with Entra ID credentials
6. Device joins and enrolls in Intune

## Android MTR Enrollment

### AOSP Enrollment

**Best for:** Android Teams Rooms devices going forward

**How it works:**
1. Factory reset device
2. Follow vendor setup wizard
3. Select AOSP/Device Owner enrollment
4. Scan QR code or enter enrollment details
5. Device enrolls in Intune

**Requirements:**
- Intune configured for AOSP enrollment
- Enrollment profile created
- Vendor-specific setup guidance

See [Android AOSP](android-aosp.md) for detailed steps.

### Legacy Android Enterprise

Older Android MTR devices may use:
- Dedicated device enrollment
- Corporate-owned, single-use (COSU)

> **Note:** Microsoft is transitioning Android MTR to AOSP enrollment. Check vendor documentation for current guidance.

## Intune Configuration

### Enrollment Settings

Configure enrollment restrictions:

1. Navigate to **Intune Admin Center** > **Devices** > **Enrollment**
2. Select **Enrollment device platform restrictions**
3. Configure:
   - Windows (MDM): **Allow**
   - Android Enterprise: **Allow** (for AOSP)
   - Platform-specific restrictions as needed

### Automatic Enrollment

Enable automatic MDM enrollment for Entra ID joined devices:

1. Navigate to **Intune Admin Center** > **Devices** > **Enrollment**
2. Select **Automatic Enrollment**
3. Configure MDM user scope:
   - **All** or **Some** (select groups)
4. Leave MAM user scope as needed

### Device Categories

Create categories for MTR devices:

```powershell
Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All"

# Create device category
$categoryParams = @{
    displayName = "Teams Rooms"
    description = "Microsoft Teams Rooms devices"
}

Invoke-MgGraphRequest -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCategories" `
    -Body ($categoryParams | ConvertTo-Json)
```

## Dynamic Device Groups

Create dynamic groups for enrolled devices:

### All MTR Devices

```
(device.deviceCategory -eq "Teams Rooms") or (device.displayName -startsWith "MTR-")
```

### Windows MTR Devices

```
(device.deviceOSType -eq "Windows") and (device.displayName -startsWith "MTR-")
```

### Android MTR Devices

```
(device.deviceOSType -contains "Android") and (device.displayName -startsWith "MTR-")
```

### Autopilot-Enrolled MTR

```
(device.devicePhysicalIds -any (_ -contains "[OrderID]:MTR"))
```

## Enrollment Verification

### Check Enrollment Status

**Via Intune Admin Center:**
1. Navigate to **Devices** > **All devices**
2. Search for device by name
3. Verify enrollment status and management state

**Via PowerShell:**
```powershell
Connect-MgGraph -Scopes "DeviceManagementManagedDevices.Read.All"

# Get all MTR devices
$mtrDevices = Get-MgDeviceManagementManagedDevice -Filter "startswith(deviceName, 'MTR-')"

$mtrDevices | Select deviceName, enrolledDateTime, managementAgent, complianceState |
    Format-Table
```

### Common Enrollment States

| State | Meaning |
|-------|---------|
| Enrolled | Successfully enrolled in Intune |
| Pending | Enrollment in progress |
| Enrollment failed | Check enrollment logs |
| Not enrolled | Not managed by Intune |

## Troubleshooting Enrollment

### Windows Enrollment Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| "User not authorized" | Enrollment restrictions | Check device limit/restrictions |
| Autopilot not starting | Hardware ID not registered | Verify Autopilot registration |
| Enrollment timeout | Network issues | Check connectivity to Intune |
| Already enrolled | Previous enrollment | Remove from Intune, retry |

### Android Enrollment Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| QR code invalid | Expired token | Generate new enrollment token |
| Enrollment blocked | Platform restriction | Enable Android AOSP |
| Setup wizard fails | Network connectivity | Verify internet access |

### Diagnostic Logs

**Windows:**
```powershell
# Collect Intune logs
%ProgramData%\Microsoft\IntuneManagementExtension\Logs
```

**Event Viewer:**
- Applications and Services Logs > Microsoft > Windows > DeviceManagement-Enterprise-Diagnostics-Provider

## Best Practices

1. **Use Autopilot for Windows** - Zero-touch deployment at scale
2. **Register devices before shipping** - Pre-configure Autopilot
3. **Use dynamic groups** - Automatic policy targeting
4. **Test enrollment process** - Verify before production rollout
5. **Document procedures** - For IT staff and vendors
6. **Monitor enrollment status** - Catch failures early
7. **Set up notifications** - Alert on enrollment failures

## Related Topics

- [Windows Autopilot](windows-autopilot.md)
- [Android AOSP](android-aosp.md)
- [Configuration Profiles](configuration-profiles.md)
- [Compliance Policies](compliance-policies.md)
