# LAPS for Teams Rooms

## Overview

Local Administrator Password Solution (LAPS) automatically manages and rotates the local administrator password on Windows Teams Rooms devices. On MTR, the local admin account is used for device settings, troubleshooting, and firmware updates: LAPS ensures these passwords are unique per device, regularly rotated, and securely stored in Entra ID.

Without LAPS, organizations typically use a shared local admin password across all MTR devices, which means a single compromised password exposes every room in the fleet.

## How LAPS Works on Teams Rooms

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│  MTR Device  │────▶│  Entra ID    │────▶│  IT Admin    │
│              │     │              │     │  Portal      │
│ Auto-rotates │     │ Stores       │     │ Retrieves    │
│ local admin  │     │ password +   │     │ password     │
│ password     │     │ expiration   │     │ when needed  │
└──────────────┘     └──────────────┘     └──────────────┘
```

The MTR device generates a new random password on the configured schedule, stores it in Entra ID as a device attribute, and only authorized administrators can retrieve it.

## Prerequisites

- Windows 11 with April 2023 update or later (built-in LAPS client)
- Device must be Entra ID joined (or Hybrid Entra ID joined)
- Entra ID P1 or P2 (P1 is included with Teams Rooms Pro)
- Intune enrollment (for policy deployment)
- Administrator role: **Cloud Device Administrator** or **Intune Administrator** (to read passwords)

## Configuration via Intune

### Step 1: Enable LAPS in Entra ID

1. Navigate to **Entra admin center** > **Devices** > **Device settings**
2. Under **Local administrator settings**, set **Enable Microsoft Entra Local Administrator Password Solution (LAPS)** to **Yes**
3. Save

### Step 2: Create LAPS Policy in Intune

1. Navigate to **Intune Admin Center** > **Endpoint Security** > **Account Protection**
2. Click **Create policy**
3. Platform: **Windows 10 and later**
4. Profile: **Local admin password solution (Windows LAPS)**
5. Configure:

| Setting | Recommended Value | Notes |
|---------|-------------------|-------|
| Backup directory | **Azure AD only** | Cloud-native for Entra ID joined devices |
| Password age (days) | **30** | Monthly rotation; adjust based on security requirements |
| Administrator account name | **Admin** | Or whatever your MTR local admin account is named |
| Password complexity | **Large letters + small letters + numbers + special characters** | Maximum complexity |
| Password length | **14** | Minimum recommended; 20+ for high-security environments |
| Post-authentication actions | **Reset password and logoff the managed account** | Ensures password rotates after use |
| Post-authentication reset delay (hours) | **8** | Gives admin time to complete work before password resets |

6. Assign to **MTR-Devices-Windows** group

### Step 3: Verify Deployment

After policy deploys (allow up to 8 hours for initial sync):

```powershell
# On the MTR device (run as local admin)
# Check if LAPS policy is applied
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Policies\LAPS" | Select-Object *

# Verify the managed account
Get-LocalUser | Where-Object { $_.Enabled -eq $true }
```

## Retrieving LAPS Passwords

### From Entra Admin Center

1. Navigate to **Entra admin center** > **Devices** > **All devices**
2. Search for the MTR device name
3. Click the device > **Local administrator password recovery**
4. Click **Show local administrator password**
5. Note the password and expiration date

### From Intune Admin Center

1. Navigate to **Intune Admin Center** > **Devices** > **All devices**
2. Search for the MTR device
3. Select the device > **Local admin password**
4. View the current password

### Via PowerShell (Microsoft Graph)

```powershell
# Requires Device.Read.All and DeviceLocalCredential.Read.All permissions
Connect-MgGraph -Scopes "DeviceLocalCredential.Read.All"

# Get LAPS password for a specific device
$deviceName = "MTR-HQ-101"
$device = Get-MgDevice -Filter "displayName eq '$deviceName'"
$lapsPassword = Get-MgDeviceLocalCredential -DeviceId $device.DeviceId

# Display (handle securely: don't log in production)
$lapsPassword | Select-Object DeviceName, AccountName, PasswordExpirationDateTime
```

## MTR-Specific Considerations

### The Local Admin Account on Teams Rooms

Teams Rooms on Windows has two local accounts:
- **Skype**: the standard user account that runs the MTR app in kiosk mode. This is NOT the account LAPS manages.
- **Admin** (or custom name): the local administrator account used for device settings access (tap the gear icon 5 times), troubleshooting, and firmware updates. **This is the account LAPS should manage.**

### When You Need the Local Admin Password

- Accessing device settings on the touch console (Settings gear > Admin mode)
- Connecting to the device via remote desktop for troubleshooting
- Running firmware updates that require admin elevation
- Modifying local device configuration outside of Intune

### Password Rotation and Meeting Disruption

LAPS password rotation does **not** disrupt meetings or the Teams Rooms app. The `Skype` user account (which runs the MTR app) is unaffected by local admin password changes. Rotation happens silently in the background.

### Post-Authentication Reset

When an admin retrieves and uses the LAPS password, the post-authentication action resets the password after the configured delay. Plan your maintenance window within this delay period (default 8 hours recommended for MTR so a technician can complete all work in a single visit).

## Auditing LAPS Usage

### Entra ID Audit Logs

LAPS password retrievals are logged in Entra ID audit logs:

1. **Entra admin center** > **Audit logs**
2. Filter by Activity: **Recover device local administrator password**
3. Review who retrieved which device's password and when

### Monitoring Recommendations

- Set up alerts for LAPS password retrievals outside of scheduled maintenance windows
- Review audit logs weekly for unexpected access patterns
- Ensure only authorized roles can retrieve passwords (Cloud Device Administrator, Intune Administrator)

## Troubleshooting

| Issue | Cause | Solution |
|-------|-------|----------|
| No password in portal | Policy not yet applied | Wait for Intune sync; check policy assignment |
| "Not configured" status | LAPS not enabled in Entra ID | Enable in Entra admin center > Device settings |
| Wrong account managed | Account name mismatch | Verify the admin account name in LAPS policy matches the actual local admin account |
| Password not rotating | Device offline or sync issues | Verify device checks in with Intune regularly |
| Can't retrieve password | Insufficient permissions | Requires Cloud Device Administrator or Intune Administrator role |

## Related Topics

- [Defender for Endpoint](defender-endpoint.md): Endpoint security configuration
- [Device Compliance](device-compliance.md): Compliance policy settings
- [MFA Considerations](mfa-considerations.md): Authentication for resource accounts
