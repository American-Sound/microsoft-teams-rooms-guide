# Supported Policies Reference

## Overview

This reference documents which Conditional Access and compliance policy settings are supported for Microsoft Teams Rooms devices. Use this to avoid configuration issues that may block MTR functionality.

## Conditional Access Policies

### Supported Grant Controls

| Grant Control | Supported | Notes |
|---------------|-----------|-------|
| Require compliant device | Yes | Recommended for MTR |
| Require approved client app | Yes | Teams is approved |
| Require app protection policy | No | Not applicable to MTR |
| Require MFA | **No** | Blocks MTR sign-in |
| Require password change | **No** | No interactive capability |
| Require terms of use | **No** | No interactive capability |
| Require device to be Hybrid Entra ID joined | Yes | If using hybrid join |
| Require device to be Entra ID joined | Yes | Recommended approach |

### Supported Conditions

| Condition | Supported | Notes |
|-----------|-----------|-------|
| Users and groups | Yes | Use group exclusions for MTR accounts |
| Cloud apps | Yes | Target Teams, Exchange, SharePoint |
| Device platforms | Yes | Windows, Android |
| Locations | Yes | Named locations work well |
| Client apps | Yes | Target "Mobile apps and desktop clients" |
| Device state | Yes | Use device filters |
| Sign-in risk | Partial | May cause issues with elevated risk |
| User risk | Partial | May cause issues with elevated risk |

### Supported Session Controls

| Session Control | Supported | Notes |
|-----------------|-----------|-------|
| Sign-in frequency | Yes | Extend to 90 days for MTR |
| Persistent browser session | N/A | Not applicable |
| Conditional Access App Control | No | Not supported on MTR |
| Continuous access evaluation | Yes | Works with MTR |

### Device Filters

Supported filter attributes for targeting MTR:

| Attribute | Example |
|-----------|---------|
| device.displayName | `device.displayName -startsWith "MTR-"` |
| device.manufacturer | `device.manufacturer -eq "Lenovo"` |
| device.model | `device.model -contains "ThinkSmart"` |
| device.deviceOwnership | `device.deviceOwnership -eq "Company"` |
| device.enrollmentProfileName | `device.enrollmentProfileName -eq "MTR-Autopilot"` |
| device.operatingSystem | `device.operatingSystem -eq "Windows"` |

## Intune Compliance Policies - Windows

### Device Health

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Require BitLocker | Yes | Yes |
| Require Secure Boot | Yes | Yes |
| Require code integrity | Yes | Yes |
| Require early-launch antimalware | Yes | Optional |

### Device Properties

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Minimum OS version | Yes | 10.0.22000 |
| Maximum OS version | Yes | Optional |
| Minimum OS build | Yes | Optional |
| Valid operating system builds | Yes | Optional |

### System Security - Password

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Require password | **No** | **No** - Breaks kiosk mode |
| Simple passwords | **No** | **No** |
| Password type | **No** | **No** |
| Minimum password length | **No** | **No** |
| Password expiration | **No** | **No** |
| Previous passwords | **No** | **No** |

### System Security - Encryption

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Require encryption | Yes | Yes |

### System Security - Device Security

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Firewall | Yes | Yes |
| Trusted Platform Module | Yes | Yes |
| Antivirus | Yes | Yes |
| Antispyware | Yes | Yes |

### Microsoft Defender

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Microsoft Defender Antimalware | Yes | Yes |
| Minimum version | Yes | Optional |
| Security intelligence up-to-date | Yes | Yes |
| Real-time protection | Yes | Yes |

### Microsoft Defender for Endpoint

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Require device risk score | Yes | If using MDE |

## Intune Compliance Policies - Android (AOSP)

### Device Health

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Rooted devices | Yes | Block |

### Device Properties

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Minimum OS version | Yes | Per vendor |
| Maximum OS version | Yes | Optional |

### System Security

| Setting | Supported | Recommended |
|---------|-----------|-------------|
| Encryption | Yes | Yes |
| Password required | **No** | **No** - Dedicated device |

## Intune Configuration Profiles - Windows

### Device Restrictions

| Category | Setting | Support |
|----------|---------|---------|
| General | Screen capture | Yes |
| App Store | Block access | Yes |
| Browser | Block InPrivate | Yes |
| Cloud | Microsoft Account | Block recommended |
| Password | Require password | **No** - Don't configure |
| Reporting | Diagnostic data | Yes |

### Windows Update

| Setting | Support | Recommendation |
|---------|---------|----------------|
| Quality update deferral | Yes | 7 days |
| Feature update deferral | Yes | 30-60 days |
| Automatic update behavior | Yes | Auto download |
| Active hours | Yes | Configure for business hours |

### Endpoint Protection

| Setting | Support | Recommendation |
|---------|---------|----------------|
| BitLocker encryption | Yes | Require |
| Firewall | Yes | Enable |
| Microsoft Defender | Yes | Enable all |

## Intune Configuration Profiles - Android (AOSP)

### Device Restrictions

| Setting | Support | Recommendation |
|---------|---------|----------------|
| Camera | Yes | Allow |
| Microphone | Yes | Allow |
| Screen capture | Yes | Per policy |
| Factory reset | Yes | Block |
| USB file transfer | Yes | Block |

## Teams Policies

### Meeting Policies

| Setting | Applies to MTR | Notes |
|---------|---------------|-------|
| Allow transcription | Yes | If licensed |
| Allow recording | Yes | If licensed |
| Allow chat in meetings | Yes | Appears on room |
| Allow whiteboard | Yes | Feature dependent |

### Messaging Policies

Most messaging policies don't apply to room accounts.

### App Setup Policies

Can be used to customize Teams app experience if needed.

## Summary: What NOT to Configure

### Do Not Apply to MTR Accounts/Devices

1. **Interactive MFA** - Cannot complete prompts
2. **Password policies** - Breaks kiosk operation
3. **Terms of use** - No interactive acceptance
4. **Password change requirements** - No interactive capability
5. **Sign-in risk blocking** (strict) - May cause issues
6. **Session timeouts < 30 days** - Causes frequent re-auth
7. **App protection policies** - Not supported

### Always Exclude MTR From

- User-targeted MFA policies
- Standard device compliance (use MTR-specific)
- User password policies
- Self-service password reset requirements
- Interactive Conditional Access challenges

## Best Practices

1. **Create dedicated MTR policies** rather than modifying user policies
2. **Use security groups** for consistent exclusions
3. **Test in report-only** before enabling policies
4. **Document all policy decisions** for compliance
5. **Review regularly** as Microsoft adds features

## Related Topics

- [Conditional Access](../03-security/conditional-access.md)
- [Device Compliance](../03-security/device-compliance.md)
- [MFA Considerations](../03-security/mfa-considerations.md)
