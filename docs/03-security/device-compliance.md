# Device Compliance for Microsoft Teams Rooms

## Overview

Device compliance policies in Microsoft Intune ensure that Teams Rooms devices meet security requirements before accessing corporate resources. Compliance status integrates with Conditional Access to provide secure, MFA-free authentication.

## Compliance Policy Basics

### How It Works

1. **Device enrolls** in Intune
2. **Compliance policy** evaluates device settings
3. **Device marked compliant** or non-compliant
4. **Conditional Access** uses compliance status for access decisions

### Benefits for MTR

- Replaces interactive MFA requirement
- Ensures devices meet security baseline
- Automated, no user interaction
- Integrates with Conditional Access

## Platform-Specific Considerations

### Windows MTR Compliance

Windows-based Teams Rooms devices support most compliance settings, with some caveats.

**Supported Settings:**
- Minimum OS version
- BitLocker encryption
- Secure Boot
- Code integrity
- Antivirus status (Defender)
- Firewall enabled
- Windows Update compliance

**Not Supported/Recommended:**
- Password complexity (resource account)
- Require user PIN
- Device lock settings (kiosk mode)

### Android MTR Compliance

Android Teams Rooms devices (AOSP enrollment) have limited compliance capabilities.

**Supported Settings:**
- Minimum OS version
- Device encryption
- Rooted device detection

**Not Supported:**
- Many Android Enterprise settings
- Work profile settings
- App-based compliance

## Creating Compliance Policies

### Windows MTR Compliance Policy

**Via Intune Admin Center:**

1. Navigate to **Intune Admin Center** > **Devices** > **Compliance policies**
2. Click **Create policy**
3. Select **Platform: Windows 10 and later**
4. Configure settings:

**Device Health:**
- Require BitLocker: **Yes**
- Require Secure Boot: **Yes**
- Require code integrity: **Yes**

**Device Properties:**
- Minimum OS version: **10.0.22000** (Windows 11 21H2 or later)

**System Security:**
- Require encryption: **Yes**
- Firewall: **Require**
- Antivirus: **Require**
- Antispyware: **Require**
- Microsoft Defender Antimalware: **Require**
- Real-time protection: **Require**

**Microsoft Defender for Endpoint:**
- Require device to be at or under machine risk score: **Medium** (if using Defender)

5. Assign to **MTR-Devices-Windows** group
6. Set actions for noncompliance (e.g., mark noncompliant immediately)

**Via PowerShell:**

```powershell
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "DeviceManagementConfiguration.ReadWrite.All"

# Create compliance policy
$policyParams = @{
    "@odata.type" = "#microsoft.graph.windows10CompliancePolicy"
    displayName = "MTR-Windows-Compliance"
    description = "Compliance policy for Windows Teams Rooms devices"
    bitLockerEnabled = $true
    secureBootEnabled = $true
    codeIntegrityEnabled = $true
    osMinimumVersion = "10.0.19044"
    storageRequireEncryption = $true
    firewallEnabled = $true
    defenderEnabled = $true
    defenderPotentiallyUnwantedAppAction = "block"
    scheduledActionsForRule = @(
        @{
            ruleName = "DeviceNonComplianceRule"
            scheduledActionConfigurations = @(
                @{
                    actionType = "block"
                    gracePeriodHours = 0
                    notificationTemplateId = ""
                }
            )
        }
    )
}

$policy = Invoke-MgGraphRequest -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies" `
    -Body ($policyParams | ConvertTo-Json -Depth 10)
```

### Android MTR Compliance Policy

**Via Intune Admin Center:**

1. Navigate to **Intune Admin Center** > **Devices** > **Compliance policies**
2. Click **Create policy**
3. Select **Platform: Android (AOSP)**
4. Configure settings:

**Device Health:**
- Rooted devices: **Block**

**Device Properties:**
- Minimum OS version: **10.0** (or vendor-recommended)

**System Security:**
- Require encryption: **Yes**

5. Assign to **MTR-Devices-Android** group

## Compliance Settings Reference

### Windows Settings Matrix

| Setting | Recommended | Impact on MTR |
|---------|-------------|---------------|
| BitLocker | Yes | Encrypts device storage |
| Secure Boot | Yes | Prevents boot-level attacks |
| Code Integrity | Yes | Validates signed drivers |
| OS Minimum Version | 10.0.19044 | Ensures supported OS |
| Firewall | Yes | Network protection |
| Defender Enabled | Yes | Malware protection |
| Real-time Protection | Yes | Active threat detection |
| Password Required | No | Breaks kiosk operation |

### Android Settings Matrix

| Setting | Recommended | Impact on MTR |
|---------|-------------|---------------|
| Rooted Device | Block | Prevents compromised devices |
| Encryption | Yes | Protects stored data |
| OS Minimum | Vendor-specific | Ensures supported firmware |

## Noncompliance Actions

Configure actions when devices fail compliance:

| Action | Grace Period | Purpose |
|--------|--------------|---------|
| Mark noncompliant | Immediately | Blocks Conditional Access |
| Send notification | 1 day | Alert admins |
| Retire device | 30 days | Remove corporate data |

**Recommendation:** Use short grace periods for MTR devices since they should always be compliant if properly configured.

## Assignment

### Group-Based Assignment

Assign compliance policies to device groups:

```powershell
# Get policy and group IDs
$policyId = (Get-MgDeviceManagementDeviceCompliancePolicy -Filter "displayName eq 'MTR-Windows-Compliance'").Id
$groupId = (Get-MgGroup -Filter "displayName eq 'MTR-Devices-Windows'").Id

# Create assignment
$assignmentParams = @{
    assignments = @(
        @{
            target = @{
                "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                groupId = $groupId
            }
        }
    )
}

Invoke-MgGraphRequest -Method POST `
    -Uri "https://graph.microsoft.com/beta/deviceManagement/deviceCompliancePolicies/$policyId/assign" `
    -Body ($assignmentParams | ConvertTo-Json -Depth 5)
```

### Exclusions

Exclude specific devices if needed (e.g., test devices):

```powershell
$exclusionGroupId = (Get-MgGroup -Filter "displayName eq 'MTR-Compliance-Exclude'").Id

$assignmentParams = @{
    assignments = @(
        @{
            target = @{
                "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
                groupId = $groupId
            }
        }
        @{
            target = @{
                "@odata.type" = "#microsoft.graph.exclusionGroupAssignmentTarget"
                groupId = $exclusionGroupId
            }
        }
    )
}
```

## Monitoring Compliance

### Intune Admin Center

1. Navigate to **Devices** > **Compliance policies** > select policy
2. View **Device status** for compliance breakdown
3. Click **View report** for detailed device list

### PowerShell Reporting

```powershell
# Get compliance status for MTR devices
$mtrDevices = Get-MgDeviceManagementManagedDevice -Filter "startswith(deviceName, 'MTR-')"

foreach ($device in $mtrDevices) {
    $status = Get-MgDeviceManagementManagedDeviceComplianceState -ManagedDeviceId $device.Id
    [PSCustomObject]@{
        DeviceName = $device.DeviceName
        ComplianceState = $device.ComplianceState
        LastSyncDateTime = $device.LastSyncDateTime
    }
}
```

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Device noncompliant | BitLocker not enabled | Enable BitLocker via policy |
| Device noncompliant | OS version too old | Update Windows |
| Compliance not evaluating | Device not synced | Force Intune sync |
| Multiple policies | Conflicting settings | Consolidate policies |

### Force Compliance Check

On the device:
1. Open **Settings** > **Accounts** > **Access work or school**
2. Select the account > **Info**
3. Click **Sync**

Via Intune:
1. Select device in Intune portal
2. Click **Sync** action

### View Compliance Details

```powershell
# Get detailed compliance status
$deviceId = (Get-MgDeviceManagementManagedDevice -Filter "deviceName eq 'MTR-HQ-101'").Id

Get-MgDeviceManagementManagedDevice -ManagedDeviceId $deviceId `
    -Property "deviceCompliancePolicyStates" |
    Select -ExpandProperty deviceCompliancePolicyStates |
    Format-Table displayName, state, settingStates
```

## Integration with Conditional Access

### Require Compliant Device

In Conditional Access policy:

```powershell
$grantControls = @{
    Operator = "AND"
    BuiltInControls = @("compliantDevice")
}
```

### Combined with Trusted Location

For higher security:

```powershell
# Require BOTH compliant device AND trusted location
$policyParams = @{
    Conditions = @{
        Locations = @{
            IncludeLocations = @($trustedLocationId)
        }
    }
    GrantControls = @{
        Operator = "AND"
        BuiltInControls = @("compliantDevice")
    }
}
```

## Best Practices

1. **Start with essential settings** - BitLocker, Secure Boot, Defender
2. **Avoid password requirements** - Breaks MTR kiosk operation
3. **Test policies thoroughly** - Use test devices/report-only
4. **Monitor compliance trends** - Catch issues early
5. **Set appropriate grace periods** - Balance security with operations
6. **Use device groups** - Separate Windows and Android policies
7. **Document policy settings** - For troubleshooting and audits

## Related Topics

- [Conditional Access](conditional-access.md)
- [MFA Considerations](mfa-considerations.md)
- [Intune Enrollment](../04-intune-management/enrollment-overview.md)
- [Compliance Policy Script](../../scripts/intune/New-MTRCompliancePolicy.ps1)
