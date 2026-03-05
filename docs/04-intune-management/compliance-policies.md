# Compliance Policies for Teams Rooms

## Overview

Compliance policies in Intune define the security requirements that Teams Rooms devices must meet. Compliance status integrates with Conditional Access to control resource access.

## Windows Compliance Settings

### Supported Settings

These compliance settings are supported for Windows MTR devices:

#### Device Health

| Setting | Supported | Notes |
|---------|-----------|-------|
| BitLocker | Yes | Recommended |
| Secure Boot | Yes | Recommended |
| Code integrity | Yes | Recommended |
| Early-launch antimalware | Yes | Optional |

#### Device Properties

| Setting | Supported | Notes |
|---------|-----------|-------|
| Minimum OS version | Yes | Set to 10.0.22000 (Windows 11 21H2) or later |
| Maximum OS version | Yes | Optional |
| Minimum OS build | Yes | For specific build requirements |
| Valid OS build ranges | Yes | For controlling update compliance |

#### System Security

| Setting | Supported | Notes |
|---------|-----------|-------|
| Require encryption | Yes | Recommended |
| Firewall | Yes | Recommended |
| Trusted Platform Module | Yes | Required for Autopilot self-deploy |
| Antivirus | Yes | Recommended |
| Antispyware | Yes | Recommended |
| Microsoft Defender Antimalware | Yes | Recommended |
| Real-time protection | Yes | Recommended |

#### Microsoft Defender for Endpoint

| Setting | Supported | Notes |
|---------|-----------|-------|
| Require device risk score | Yes | If using MDE |

### Not Supported/Not Recommended

| Setting | Why Not |
|---------|---------|
| Password required | MTR uses service account, no interactive password |
| Password complexity | Same as above |
| Max minutes of inactivity | Interferes with kiosk mode |
| Device lock | Interferes with meeting display |

## Android Compliance Settings

### Supported Settings (AOSP)

| Setting | Supported | Notes |
|---------|-----------|-------|
| Rooted devices | Yes | Block rooted devices |
| Minimum OS version | Yes | Per vendor recommendation |
| Device encryption | Yes | Recommended |

### Not Supported for AOSP

Many Android Enterprise compliance settings don't apply to AOSP:
- Work profile settings
- Google Play Protect
- App-based compliance

## Creating Compliance Policies

### Windows MTR Compliance Policy

**Via Intune Admin Center:**

1. Navigate to **Intune Admin Center** > **Devices** > **Compliance policies**
2. Click **Create policy**
3. Platform: **Windows 10 and later**
4. Click **Create**

**Configuration:**

**Basics:**
- Name: `MTR-Windows-Compliance`
- Description: `Compliance policy for Windows Teams Rooms`

**Compliance settings:**

**Device Health:**
```
BitLocker: Require
Secure Boot: Require
Code Integrity: Require
```

**Device Properties:**
```
Minimum OS version: 10.0.22000
```

**System Security:**
```
Encryption of data storage: Require
Firewall: Require
Antivirus: Require
Antispyware: Require
Microsoft Defender Antimalware: Require
Microsoft Defender Antimalware minimum version: (leave default)
Real-time protection: Require
```

**Microsoft Defender for Endpoint (if using):**
```
Require device to be at or under machine risk score: Medium
```

**Actions for noncompliance:**
```
Mark device noncompliant: Immediately (0 days)
Send push notification to end user: No
Send email to end user: No (optional for admins)
```

**Assignments:**
- Include: `MTR-Devices-Windows` group
- Exclude: `MTR-Compliance-Exclude` (if needed for testing)

### Android MTR Compliance Policy

1. **Create policy**
2. Platform: **Android (AOSP)**
3. Click **Create**

**Compliance settings:**

**Device Health:**
```
Rooted devices: Block
```

**Device Properties:**
```
Minimum OS version: (per vendor recommendation)
```

**System Security:**
```
Require encryption of data storage on device: Require
```

**Assignments:**
- Include: `MTR-Devices-Android` group

## Policy Assignment

### Using Device Groups

Create dynamic groups for precise targeting:

**Windows MTR with Autopilot:**
```
(device.deviceOSType -eq "Windows") and
(device.enrollmentProfileName -eq "MTR-Autopilot-Profile")
```

**All MTR by naming convention:**
```
(device.displayName -startsWith "MTR-")
```

### Using Assignment Filters

Filters provide additional targeting flexibility:

```
(device.manufacturer -eq "Lenovo") and (device.model -contains "ThinkSmart")
```

## Compliance Grace Period

Configure grace period for temporary noncompliance:

| Scenario | Recommended Grace Period |
|----------|-------------------------|
| New device enrollment | 24 hours |
| OS update required | 7 days |
| Security setting | 0 days (immediate) |

**Best Practice:** Use 0 days for security settings, allow grace for updates.

## Integration with Conditional Access

### Require Compliant Device

In Conditional Access policy:

```
Grant controls:
  - Require device to be marked as compliant: Yes
```

This creates the connection:
1. Device evaluated against compliance policy
2. If compliant, Conditional Access grants access
3. If noncompliant, access blocked

### Benefits

- No interactive MFA needed
- Automated compliance checking
- Consistent security posture
- Clear audit trail

## Monitoring Compliance

### Dashboard View

1. Navigate to **Devices** > **Monitor** > **Device compliance**
2. View compliance by:
   - Platform
   - Policy
   - Setting
   - Trend over time

### Per-Policy View

1. Select policy in **Compliance policies**
2. View **Device status**
3. Check counts:
   - Compliant
   - Noncompliant
   - In grace period
   - Not evaluated

### Per-Device View

1. **Devices** > **All devices** > Select device
2. **Device compliance**
3. View:
   - Overall status
   - Per-policy status
   - Per-setting status

### Compliance Reports

1. **Reports** > **Device compliance**
2. Available reports:
   - Noncompliant devices
   - Policy compliance
   - Setting compliance
   - Device compliance trends

## Troubleshooting

### Device Shows Noncompliant

1. **Check specific settings:**
   - Navigate to device > Device compliance
   - Review which settings fail

2. **Common causes:**

| Failed Setting | Common Cause | Solution |
|----------------|--------------|----------|
| BitLocker | Not enabled | Enable via policy |
| Secure Boot | Disabled in BIOS | Enable in firmware |
| OS Version | Outdated | Install updates |
| Defender | Disabled/outdated | Check Defender settings |
| Encryption | Not encrypted | Enable encryption |

3. **Force re-evaluation:**
   - Sync device
   - Wait for check-in
   - Compliance re-evaluates

### Compliance Not Evaluating

| Symptom | Cause | Solution |
|---------|-------|----------|
| "Not evaluated" | Policy not assigned | Check group membership |
| "Not evaluated" | Platform mismatch | Verify policy platform |
| "Pending" | Sync in progress | Wait or force sync |

### Force Compliance Check

**Via Intune portal:**
1. Select device
2. Click **Sync**
3. Wait for status update

**On Windows device:**
```powershell
# Force Intune sync
$Shell = New-Object -ComObject Shell.Application
$Shell.open("ms-settings:sync")
# Then click Sync in Settings
```

## Best Practices

1. **Start with essential settings** only
2. **Test policies** before broad deployment
3. **Use appropriate grace periods** for updates
4. **Monitor compliance trends** proactively
5. **Document policy rationale** for audits
6. **Align with Conditional Access** requirements
7. **Avoid settings that break MTR** functionality
8. **Review regularly** for needed updates

## Compliance Matrix

Quick reference for MTR compliance settings:

| Setting | Windows | Android | Risk if Disabled |
|---------|---------|---------|------------------|
| BitLocker | Required | N/A | Data exposure |
| Secure Boot | Required | N/A | Boot attacks |
| Code Integrity | Required | N/A | Driver compromise |
| Encryption | Required | Required | Data exposure |
| Firewall | Required | N/A | Network attacks |
| Defender | Required | N/A | Malware |
| Rooted Device | N/A | Block | Device compromise |

## Related Topics

- [Device Compliance (Security)](../03-security/device-compliance.md)
- [Conditional Access](../03-security/conditional-access.md)
- [Configuration Profiles](configuration-profiles.md)
- [Compliance Policy Script](../../scripts/intune/New-MTRCompliancePolicy.ps1)
