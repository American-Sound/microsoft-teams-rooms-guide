# Zero-Touch Deployment

## Overview

Zero-touch deployment enables automated provisioning of Microsoft Teams Rooms devices with no IT intervention at the deployment site. This guide covers the complete process using Windows Autopilot and Pro Management Portal Autologin.

## What is Zero-Touch Deployment?

Zero-touch deployment means:
- Device arrives pre-configured for your organization
- IT doesn't need to manually set up each device
- Device configures itself when connected to network
- Ready for meetings with no user interaction

The key to making this truly zero-touch is combining **Autopilot** (handles Windows setup, Entra ID join, and Intune enrollment) with **Autologin** (handles Teams Rooms resource account sign-in).

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      ZERO-TOUCH FLOW                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────┐    ┌──────────┐    ┌──────────┐    ┌──────────┐  │
│  │  OEM     │───▶│ Autopilot│───▶│  Intune  │───▶│  MTR     │  │
│  │ Registers│    │ Enrolls  │    │ Configures│   │  Ready   │  │
│  └──────────┘    └──────────┘    └──────────┘    └──────────┘  │
│       │               │               │               │         │
│       ▼               ▼               ▼               ▼         │
│  Hardware ID     Entra ID Join   Policies &      PMP Autologin │
│  + MTR- tag      automatic       apps deploy     signs in room │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Prerequisites

### Tenant Configuration

- [ ] Teams Rooms Pro license (includes Intune, Entra ID P1, and is required for PMP Autologin)
- [ ] Automatic Intune enrollment enabled
- [ ] MDE-Intune connector configured (if using Defender for Endpoint)

### Autopilot Configuration

- [ ] Autopilot deployment profile created (Self-Deploying mode)
- [ ] Enrollment Status Page configured
- [ ] Device Group Tag defined with `MTR-` prefix
- [ ] Dynamic device group targeting `MTR-` Group Tag

### Account Preparation

- [ ] Resource accounts created in Entra ID
- [ ] Teams Rooms Pro licenses assigned
- [ ] Calendar processing configured (Exchange)
- [ ] Accounts excluded from MFA Conditional Access policies
- [ ] Passwords set to never expire

### Pro Management Portal

- [ ] Resource accounts assigned to Autopilot devices in PMP
- [ ] Provisioning status shows **Ready**

## Setup Procedure

### Step 1: Configure Autopilot Profile

Create self-deploying mode profile:

1. Navigate to **Intune Admin Center** > **Devices** > **Windows enrollment**
2. Select **Deployment Profiles** > **Create profile**
3. Configure:

```
Name: MTR-Autopilot-ZeroTouch
Deployment mode: Self-Deploying
Join to Entra ID as: Entra ID joined
Microsoft Software License Terms: Hide
Privacy settings: Hide
Hide change account options: Yes
User account type: Standard
Allow pre-provisioned deployment: No
Language: Operating system default
Automatically configure keyboard: Yes
Apply device name template: Yes
Name template: MTR-%SERIAL%
```

### Step 2: Create Dynamic Device Group

```
Group name: MTR-Autopilot-Devices
Membership type: Dynamic device
Rule: (device.devicePhysicalIds -any (_ -contains "[OrderID]:MTR-"))
```

### Step 3: Configure Enrollment Status Page

1. Navigate to **Devices** > **Windows enrollment** > **Enrollment Status Page**
2. Create profile:

```
Name: MTR-ESP
Show app and profile configuration progress: Yes
Show error when installation takes longer than: 90 minutes
Show custom message when time limit or error occur: Yes
Custom message: "Teams Rooms device is being configured..."
Allow users to collect logs: Yes
Only show page to OOBE devices: Yes
Block device use until all apps and profiles are installed: Yes
Allow users to reset device: No
Allow users to use device if installation error occurs: No
Block device use until required apps are installed: Yes
```

### Step 4: Configure Autologin via Pro Management Portal

This is the recommended method for new Windows 11 deployments. The PMP stores credentials in a Microsoft-managed backend: the password never touches the device as a plaintext file.

1. Sign in to [portal.rooms.microsoft.com](https://portal.rooms.microsoft.com)
2. Navigate to **Planning** > **Autopilot devices**
3. Click **Sync** to pull registered devices from Intune
4. For each device:
   - Click **Assign account**
   - Select the resource account
   - Either enter the existing password or select **Auto Generate password**
5. Verify provisioning status shows **Ready**

> **Auto Generate password** requires Exchange Admin privileges and only works with cloud-only resource accounts (not hybrid). It generates a strong random password and updates the account automatically.

### Step 4 (Alternative): SkypeSettings.xml for Brownfield Devices

For devices that cannot use PMP Autologin (Windows 10, Hybrid Entra ID joined, Basic license), deploy a SkypeSettings.xml file containing the resource account credentials. See [Windows Autopilot: Method 2](../04-intune-management/windows-autopilot.md#method-2-skypesettingsxml-legacy--brownfield) and the [Set-MTRAutoLogin.ps1](../../scripts/intune/Set-MTRAutoLogin.ps1) script.

### Step 5: Assign Intune Profiles

Assign all profiles to the dynamic device group:

| Profile | Target Group |
|---------|--------------|
| Autopilot deployment | MTR-Autopilot-Devices |
| ESP | MTR-Autopilot-Devices |
| Compliance policy | MTR-Autopilot-Devices |
| Configuration profiles | MTR-Autopilot-Devices |
| LAPS policy | MTR-Autopilot-Devices |
| EDR policy (if using MDE) | MTR-Autopilot-Devices |

> **Do not assign:** Security Baselines or policies that modify `AutoAdminLogon`. These will break the Windows-level autologon to the local Skype account and the device will boot to a Windows login screen instead of the Teams app.

### Step 6: Register Devices

**OEM Registration (Recommended):**
1. Provide tenant ID to hardware vendor
2. Request devices be registered with Group Tag `MTR-` (or `MTR-{location-code}` for tracking)
3. Devices ship pre-registered

**Manual Registration:**
```powershell
# On device, extract hardware ID
Install-Script -Name Get-WindowsAutopilotInfo -Force
Get-WindowsAutopilotInfo -OutputFile C:\AutopilotHWID.csv -GroupTag "MTR-"

# Upload CSV to Intune > Devices > Windows enrollment > Devices > Import
```

## Deployment Process

### What Happens When Device Powers On

1. **Device boots** and connects to internet (Ethernet preferred)
2. **Autopilot profile downloads**: device recognized by hardware ID
3. **OOBE skipped**: Self-Deploying mode bypasses all user prompts
4. **Entra ID join**: device joins your tenant automatically
5. **Intune enrollment**: device enrolls for management
6. **Policies applied**: compliance, configuration, LAPS, EDR
7. **ESP waits**: required apps and profiles install
8. **Windows autologon**: boots into the local Skype account (OEM-configured)
9. **Teams Rooms app launches**: Shell Launcher V2 kiosk mode
10. **PMP Autologin**: app retrieves credentials from PMP service and signs in
11. **Device ready for meetings**

### Timeline

| Phase | Typical Duration |
|-------|------------------|
| Boot and OOBE | 3-5 minutes |
| Autopilot detection | 1-2 minutes |
| Entra ID join | 1-2 minutes |
| Intune enrollment | 2-3 minutes |
| Policy deployment | 5-10 minutes |
| App installation | 10-20 minutes |
| Autologin and finalization | 1-3 minutes |
| **Total** | **25-45 minutes** |

## Vendor Coordination

### Information for Hardware Vendors

Provide vendors with:
- Tenant ID: `xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`
- Group Tag: `MTR-` (or `MTR-{location}`)
- Deployment requirements: Self-Deploying mode, Windows 11
- Note: Windows 10 devices are no longer supported (EOL October 2025)

### Pre-Ship Testing

Request vendor perform:
- Network connectivity test
- Hardware ID extraction and registration confirmation
- TPM 2.0 attestation verification

## Scaling Zero-Touch

### For Large Deployments

1. **Batch device orders** by location/building
2. **Pre-create resource accounts** in bulk using [New-MTRResourceAccountsBulk.ps1](../../scripts/accounts/New-MTRResourceAccountsBulk.ps1)
3. **Standardize naming**: device names: `MTR-%SERIAL%`, accounts: `mtr-{building}-{room}@contoso.com`
4. **Assign accounts in PMP** before devices ship: the linkage is valid for 90 days
5. **Coordinate shipping** with site readiness (network drops, power, displays)
6. **Track deployment status**: PMP shows Provisioning Status per device (Ready → Consumed)

### MSP Multi-Tenant Pattern

For managed service providers deploying across client tenants:

1. Use the [Multi-Tenant Management Portal](https://partner.rooms.microsoft.com) for cross-tenant visibility
2. Standardize Group Tags: `MTR-{client-code}` (e.g., `MTR-ACME`, `MTR-CONTOSO`)
3. Each client tenant requires its own Autopilot registrations, PMP Autologin assignments, and Intune profiles
4. Document per-client deployment runbooks with tenant-specific IDs and naming conventions

## Troubleshooting

### Autopilot Not Detecting Device

- Verify device registered in Intune portal
- Check Group Tag matches dynamic group rule (must start with `MTR-`)
- Confirm network connectivity to Microsoft Autopilot service
- Check for firewall blocking Autopilot endpoints

### ESP Timeout

- Review required apps list: reduce if too many
- Check app deployment status in Intune
- Extend timeout if needed (90 minutes recommended for MTR)
- Verify network bandwidth is sufficient

### PMP Autologin Not Working

- Confirm provisioning status is **Ready** in PMP > Planning > Autopilot devices
- Verify the Group Tag has the `MTR-` prefix
- Check that the resource account has a Teams Rooms Pro license
- Confirm the resource account is not blocked by Conditional Access
- If status shows **Expired**, re-assign the account (90-day limit)

### Device Stuck in OOBE

- Verify self-deploying mode configured (not user-driven)
- Check TPM 2.0 available and attestation working
- Try Ethernet instead of Wi-Fi
- Check for OOBE connectivity issues (corporate proxy blocking)

## Validation

### Per-Device Checklist

- [ ] Device shows in Intune as enrolled
- [ ] Compliance state: Compliant
- [ ] All profiles: Succeeded
- [ ] LAPS password available in Entra ID
- [ ] Teams Rooms app running
- [ ] Resource account signed in
- [ ] Calendar displaying correctly
- [ ] Meeting join working (test with ad-hoc meeting)
- [ ] Audio and video functional
- [ ] Shows online in Pro Management Portal

### Dashboard Monitoring

Monitor deployment progress via:
- Intune device list: enrollment status
- Autopilot deployment status: per-device progress
- ESP completion reports
- Pro Management Portal: room health and provisioning status

## Best Practices

1. **Start with pilot**: test with 5-10 devices first
2. **Use Ethernet**: more reliable during Autopilot provisioning
3. **Use PMP Autologin**: most secure credential delivery method
4. **Coordinate with facilities**: network drops and power must be ready
5. **Document each deployment**: track serial numbers, room assignments, provisioning status
6. **Monitor actively**: watch PMP and Intune for failures during rollout
7. **Have backup procedure**: manual sign-in as fallback
8. **Pre-stage network**: ensure drops are active before device arrival
9. **Test end-to-end**: verify meeting join after deployment completes
10. **Exclude from Security Baselines**: they break MTR Windows autologon

## Related Topics

- [Windows Autopilot](../04-intune-management/windows-autopilot.md)
- [Windows Deployment](windows-deployment.md)
- [SkypeSettings.xml Reference](../reference/skypesettings-reference.md)
- [Resource Accounts](../02-prerequisites/resource-accounts.md)
- [Enrollment Overview](../04-intune-management/enrollment-overview.md)
- [Pro Management Portal](../10-pro-management/portal-overview.md)
