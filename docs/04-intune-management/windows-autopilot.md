# Windows Autopilot for Teams Rooms

## Overview

Windows Autopilot enables zero-touch deployment of Teams Rooms on Windows devices. Combined with Autologin via the Pro Management Portal, you can deploy meeting rooms that are ready to use out of the box with no manual configuration.

## Prerequisites

### Licensing
- Teams Rooms Pro license (includes Intune, Entra ID P1, and is required for Autologin via Pro Management Portal)
- Windows 11 IoT Enterprise license (OEM)

### Configuration Requirements
- Intune configured and operational
- Entra ID automatic enrollment enabled
- Resource accounts created with licenses
- Network connectivity to Microsoft services

### Hardware Requirements
- Windows Autopilot-capable device with TPM 2.0
- Certified for Teams Rooms
- Hardware ID registered with Microsoft
- Windows 11 (Windows 10 reached EOL October 14, 2025)

## Architecture

### Two Layers of Sign-In

Understanding the difference between these two layers is critical for troubleshooting and configuration:

**Layer 1 — Windows Autologon (handled by OEM image):**
The MTR Windows image ships with a local user account called `Skype`. Windows autologon is pre-configured in the OEM image to boot directly into this account via Shell Launcher V2 (kiosk mode). The registry keys at `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon` control this — `AutoAdminLogon=1`, `DefaultUserName=Skype`. You should never need to configure this manually; the OEM image handles it.

> **Warning:** If you apply Intune Security Baselines or certain Group Policy settings to MTR devices, they can reset `AutoAdminLogon` to `0`, which breaks the device — it boots to a Windows login screen instead of the Teams app. Always **exclude MTR devices** from Security Baseline assignments.

**Layer 2 — Teams App Resource Account Sign-In:**
Once Windows boots into the Skype local account and launches the Teams Rooms app, the app must sign in to a Microsoft 365 resource account (e.g., `confroom1@contoso.com`). This uses the ROPC (Resource Owner Password Credentials) OAuth flow — a non-interactive authentication that does not support MFA. This is what "Autologin" configures.

```
[Device Powers On]
        ↓
[Windows Autologon → Skype account]     ← Layer 1 (OEM image)
        ↓
[Shell Launcher → Teams Rooms app]
        ↓
[Autopilot: Entra ID Join + Intune]
        ↓
[Autologin: Resource account sign-in]   ← Layer 2 (PMP or SkypeSettings.xml)
        ↓
[Ready for Meetings]
```

## Device Registration

### Method 1: OEM Registration (Recommended)

Request your hardware vendor to register devices before shipping:

1. Provide vendor with your tenant ID
2. Vendor extracts hardware IDs during manufacturing
3. Vendor uploads IDs to your Autopilot service with Group Tag `MTR-`
4. Devices arrive pre-registered

> **Important:** Use the `MTR-` prefix on Group Tags. The Pro Management Portal requires this prefix to identify Autopilot devices for Autologin assignment.

### Method 2: Partner Registration

Microsoft partners can register on your behalf:

1. Authorize partner in Partner Center
2. Partner extracts and uploads hardware IDs
3. Verify registration in Intune

### Method 3: Manual Registration

For existing devices or small quantities:

**Extract Hardware ID:**
```powershell
# Run on the device
Install-Script -Name Get-WindowsAutopilotInfo -Force
Get-WindowsAutopilotInfo -OutputFile "C:\Autopilot\AutopilotHWID.csv" -GroupTag "MTR-"
```

**Upload to Intune:**
1. Navigate to **Intune Admin Center** > **Devices** > **Enrollment**
2. Select **Windows enrollment** > **Devices**
3. Click **Import**
4. Upload the CSV file
5. Wait for processing (can take 15+ minutes)

### Hardware ID CSV Format

```csv
Device Serial Number,Windows Product ID,Hardware Hash,Group Tag,Assigned User
SERIALNUMBER001,,BASE64HASH==,MTR-,
SERIALNUMBER002,,BASE64HASH==,MTR-,
```

## Autopilot Deployment Profile

### Create Deployment Profile

1. Navigate to **Intune Admin Center** > **Devices** > **Enrollment**
2. Select **Windows enrollment** > **Deployment Profiles**
3. Click **Create profile** > **Windows PC**
4. Configure:

**Basics:**
- Name: `MTR-Autopilot-Profile`
- Description: `Autopilot profile for Microsoft Teams Rooms`

**Out-of-box experience (OOBE):**
- Deployment mode: **Self-Deploying** (required for MTR)
- Join to Entra ID as: **Entra ID joined**
- Microsoft Software License Terms: **Hide**
- Privacy settings: **Hide**
- Hide change account options: **Yes**
- User account type: **Standard**
- Allow pre-provisioned deployment: **No**
- Apply device name template: **Yes**
- Name template: `MTR-%SERIAL%`

**Assignments:**
- Assign to group: **MTR-Autopilot-Devices** (dynamic group based on Group Tag)

### Self-Deploying Mode

Self-deploying mode is required for MTR because:
- No user credentials required during setup
- Device enrolls automatically
- No user interaction needed
- Fully automated process

**Requirements for self-deploying:**
- TPM 2.0 with device attestation capability
- Ethernet connection recommended (Wi-Fi requires manual SSID selection)

### Dynamic Group for Autopilot Devices

Create a dynamic device group:

```
(device.devicePhysicalIds -any (_ -contains "[OrderID]:MTR-"))
```

This captures all devices with Group Tags prefixed with `MTR-`.

## Resource Account Autologin

### Method 1: Pro Management Portal Autologin (Recommended)

This is the Microsoft-recommended approach for new Windows 11 deployments with Teams Rooms Pro licenses. Credentials are stored in the Microsoft-managed PMP service and delivered to the device through the Autopilot provisioning flow — the password never exists as plaintext on local disk.

**Prerequisites:**
- Teams Rooms Pro license assigned to resource account
- Device registered in Autopilot with `MTR-` Group Tag prefix
- Windows 11 only

**Configuration Steps:**

1. Sign in to the [Pro Management Portal](https://portal.rooms.microsoft.com)
2. Navigate to **Planning** > **Autopilot devices**
3. Click **Sync** to pull the device list from Intune
4. Select a device, click **Assign account**
5. Choose the resource account
6. On the configuration page, either:
   - **Enter the existing password** manually, or
   - Select **Auto Generate password** (requires Exchange Admin privileges; does not work with hybrid resource accounts)
7. The provisioning status changes to **Ready**

**What happens during deployment:**
1. Device completes Autopilot (Entra ID join, Intune enrollment, policies)
2. Teams Rooms app detects the Autopilot Autologin profile
3. App retrieves credentials from the PMP service
4. Resource account signs in automatically — zero touch
5. Provisioning status in PMP changes to **Consumed**

**After a factory reset:** If you reset a device that previously consumed its Autologin credentials, you must re-assign the resource account in the Pro Management Portal to get the status back to **Ready** before the device will Autologin again.

**Credential validity:** The Autologin credential linkage is valid for up to 90 days. If the device is not provisioned within that window, re-assign the account.

### Method 2: SkypeSettings.xml (Legacy / Brownfield)

For devices that cannot use the PMP Autologin flow — Windows 10 (EOL), Hybrid Entra ID joined, or Teams Rooms Basic licensed rooms — deploy resource account credentials via SkypeSettings.xml.

```xml
<SkypeSettings>
  <UserAccount>
    <SkypeSignInAddress>confroom1@contoso.com</SkypeSignInAddress>
    <Password>ResourceAccountPassword123!</Password>
  </UserAccount>
</SkypeSettings>
```

Place this file at:
```
C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\SkypeSettings.xml
```

The Teams Rooms app reads the file at startup, signs in with the provided credentials, and **deletes the XML file**. The password is consumed and removed from disk.

**Deploy via Intune PowerShell script:**

See [Set-MTRAutoLogin.ps1](../../scripts/intune/Set-MTRAutoLogin.ps1) for a production script that retrieves credentials from Azure Key Vault and writes the SkypeSettings.xml securely.

> **Security Warning:** Never deploy SkypeSettings.xml with hardcoded passwords in your Intune script source. The script is visible to Intune administrators and stored in the Intune service. Use Azure Key Vault or another secrets management solution to retrieve the password at runtime on the device.

For a complete SkypeSettings.xml reference, see [SkypeSettings.xml Reference](../reference/skypesettings-reference.md).

### Method 3: Manual Sign-In

For one-off deployments or troubleshooting:

1. On the touch console: **More** > **Settings**
2. Enter the admin password
3. Navigate to **Account**
4. Enter resource account UPN and password
5. Select **Microsoft 365** as the server
6. Apply and restart

## Enrollment Status Page

Configure the Enrollment Status Page (ESP) for MTR:

1. Navigate to **Intune Admin Center** > **Devices** > **Enrollment**
2. Select **Enrollment Status Page**
3. Click **Create**
4. Configure:
   - Show app and profile configuration progress: **Yes**
   - Show error when installation takes longer than: **90 minutes**
   - Allow users to reset device: **No**
   - Allow users to use device: **No** (wait for completion)
   - Block device use until required apps installed: **Yes**
5. Assign to MTR device group

## Complete Deployment Flow

### Zero-Touch Process (Autopilot + PMP Autologin)

1. **Register device** in Autopilot with `MTR-` Group Tag
2. **Assign resource account** in Pro Management Portal > Planning > Autopilot devices
3. **Ship device** to location
4. **Connect to network** (Ethernet preferred)
5. **Power on device**
6. Device self-deploys via Autopilot
7. Teams Rooms app signs in via PMP Autologin
8. **MTR ready for meetings**

### Timeline

| Phase | Duration |
|-------|----------|
| OOBE and Autopilot | 5-10 minutes |
| Intune enrollment | 2-5 minutes |
| Policy application | 5-15 minutes |
| App installation | 10-20 minutes |
| Autologin | 1-2 minutes |
| **Total** | **25-50 minutes** |

## Troubleshooting

### Autopilot Not Starting

- Verify device is registered in Intune portal
- Check network connectivity (try Ethernet if on Wi-Fi)
- Confirm hardware ID upload completed
- Verify Autopilot profile assigned to the correct group
- Confirm TPM 2.0 is functional (`tpmtool getdeviceinformation`)

### Enrollment Failures

- Check ESP for error messages
- Review Intune enrollment logs
- Verify automatic enrollment configured in Entra ID
- Check device restrictions (enrollment limits)

### Autologin Not Working (PMP Method)

- Verify the device has `MTR-` prefix on its Group Tag
- Check that the provisioning status in PMP is **Ready** (not Consumed or Expired)
- Confirm the resource account has a Teams Rooms Pro license
- Verify the resource account is not blocked by Conditional Access
- Check that the resource account password has not been changed since assignment

### Autologin Not Working (SkypeSettings.xml Method)

- Verify the XML file was written to the correct path
- Check that the file is well-formed XML (encoding, special characters)
- Confirm the resource account UPN and password are correct
- Verify the resource account is enabled in Entra ID
- Check that the password has not expired (set to never expire)

### Windows Autologon Broken (Device Shows Windows Login)

This means Layer 1 (Windows autologon to the Skype local account) is broken:
- Check `HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon` — `AutoAdminLogon` must be `1`
- Look for Security Baseline policies that may have reset this value
- Ensure the `Skype` local account exists and is enabled
- Verify `net accounts /maxpwage:unlimited` is set (local account passwords must not expire)

### Diagnostic Commands

```powershell
# Check Autopilot registration
dsregcmd /status

# Check Intune enrollment
Get-WmiObject -Class MDM_DevDetail_Ext01 -Namespace root\cimv2\mdm\dmmap

# Verify Windows autologon registry
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" |
    Select-Object AutoAdminLogon, DefaultUserName, DefaultDomainName

# Check Teams Rooms app is running (new Teams client)
Get-Process -Name "ms-teams" -ErrorAction SilentlyContinue

# Check for pending reboot
Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -ErrorAction SilentlyContinue
```

## Best Practices

1. **Use OEM registration** — Devices arrive ready to deploy
2. **Use PMP Autologin** — Most secure; no plaintext passwords on disk
3. **Use `MTR-` Group Tag prefix** — Required for PMP Autopilot integration
4. **Test with pilot devices** — Validate the full flow before production rollout
5. **Use Ethernet** — More reliable than Wi-Fi during enrollment
6. **Configure ESP** — Ensure all apps install before the device is usable
7. **Exclude from Security Baselines** — Baselines can break Windows autologon
8. **Set resource account passwords to never expire** — Expiring passwords break unattended sign-in
9. **Monitor deployment** — Track enrollment status in Intune and PMP
10. **Plan for failures** — Have the manual sign-in method as a backup

## Related Topics

- [Enrollment Overview](enrollment-overview.md)
- [Zero-Touch Deployment](../05-deployment/zero-touch-deployment.md)
- [Configuration Profiles](configuration-profiles.md)
- [SkypeSettings.xml Reference](../reference/skypesettings-reference.md)
- [Autopilot Profile Script](../../scripts/intune/New-MTRAutopilotProfile.ps1)
- [Autologin Script](../../scripts/intune/Set-MTRAutoLogin.ps1)
