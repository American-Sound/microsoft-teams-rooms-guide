# Windows MTR Deployment

## Overview

This guide provides step-by-step instructions for deploying Microsoft Teams Rooms on Windows. It covers both Autopilot-based zero-touch deployment and manual deployment methods.

## Prerequisites Checklist

Before beginning deployment, ensure:

- [ ] Resource account created and licensed
- [ ] Calendar processing configured
- [ ] Conditional Access policies updated (MTR excluded)
- [ ] Intune enrollment configured
- [ ] Autopilot profile created (if using Autopilot)
- [ ] Network connectivity verified
- [ ] Hardware certified for Teams Rooms
- [ ] Resource account credentials documented

## Method 1: Autopilot Deployment (Recommended)

### Pre-Deployment Setup

1. **Register device with Autopilot**
   - OEM registration (preferred)
   - Manual hardware ID upload
   - Partner registration

2. **Verify Autopilot registration**
   ```powershell
   # Check device in Autopilot
   Get-MgDeviceManagementWindowsAutopilotDeviceIdentity -Filter "contains(serialNumber,'SERIAL123')"
   ```

3. **Assign to Autopilot group**
   - Verify device is in correct dynamic group
   - Confirm Autopilot profile assigned

### Deployment Steps

1. **Unbox and connect hardware**
   - Connect touch console
   - Connect camera and audio devices
   - Connect display(s)
   - Connect Ethernet cable (recommended)
   - Connect power

2. **Power on device**
   - Device boots to OOBE
   - Connects to internet automatically (if Ethernet)
   - Or select Wi-Fi network

3. **Autopilot process begins**
   - Device downloads Autopilot profile
   - Shows "Setting up for your organization"
   - No user interaction required

4. **Wait for enrollment**
   - Device joins Entra ID
   - Enrolls in Intune
   - Receives policies and apps
   - Progress shown on Enrollment Status Page

5. **Autologin completes**
   - Resource account signs in automatically
   - Teams Rooms app launches
   - Device ready for use

### Expected Timeline

| Phase | Duration |
|-------|----------|
| Initial boot to OOBE | 2-5 minutes |
| Autopilot profile download | 1-2 minutes |
| Entra ID join | 1-2 minutes |
| Intune enrollment | 2-5 minutes |
| Policy/app deployment | 10-20 minutes |
| Autologin and final setup | 2-5 minutes |
| **Total** | **20-40 minutes** |

## Method 2: Manual Deployment

### Initial Setup

1. **Connect hardware**
   - Same as Autopilot method

2. **Complete Windows OOBE**
   - Select region and keyboard
   - Connect to network
   - Skip Microsoft account sign-in
   - Create local admin account (temporary)

### Install Teams Rooms App

1. **Download MTR installer**
   - Get from Microsoft download center
   - Or use vendor-provided image

2. **Run installer**
   ```powershell
   # Run as administrator
   .\MicrosoftTeamsRoomSetup.msi /quiet
   ```

3. **Restart device**

### Configure Resource Account

1. **Access MTR settings**
   - On touch console: **More** > **Settings**
   - Enter admin password (default or configured)

2. **Configure account**
   - Enter resource account UPN
   - Enter password
   - Select Exchange Server: **Microsoft 365**
   - Enter SIP address (same as UPN typically)

3. **Apply and restart**

### Join to Entra ID

1. **Open Windows Settings**
   - Windows key + I

2. **Navigate to Accounts**
   - **Accounts** > **Access work or school**

3. **Join device**
   - Click **Connect**
   - Select **Join this device to Microsoft Entra ID**
   - Sign in with admin account
   - Confirm join

4. **Verify enrollment**
   - Device should auto-enroll in Intune
   - Check in Intune portal

### Verify Configuration

1. **Check device status**
   - Green checkmark on home screen
   - Calendar loads properly
   - Test meeting join

2. **Verify in admin portals**
   - Pro Management Portal: Device shows online and healthy
   - Intune: Device enrolled and compliant
   - Entra ID: Device joined

## Post-Deployment Configuration

### Pro Management Portal Settings

Configure device settings in the Pro Management Portal:

1. Navigate to **[Pro Management Portal](https://portal.rooms.microsoft.com)** > **Rooms**
2. Select the device
3. Navigate to **Settings** and configure:
   - Meeting defaults
   - Peripheral settings
   - Theme and background
   - Digital signage (if applicable)

### Room Settings (On Device)

Access via **More** > **Settings** on touch console:

| Setting | Recommendation |
|---------|----------------|
| Theme | Per branding requirements |
| Default camera | Auto or specific device |
| Default speaker | Auto or specific device |
| Default microphone | Auto or specific device |
| Bluetooth beaconing | Enable for proximity join |
| Room calendar | Verify account |

### Peripheral Configuration

1. **Camera settings**
   - Frame/zoom defaults
   - AI features (if available)

2. **Audio settings**
   - Default volume
   - Noise suppression
   - Speaker settings

3. **Display settings**
   - Front of room layout
   - Content display preferences

## Troubleshooting

### Autopilot Issues

| Issue | Solution |
|-------|----------|
| Autopilot not starting | Verify device registered, check network |
| Stuck at "Identifying" | Check internet, try Ethernet |
| Profile not downloading | Verify profile assignment |
| ESP timeout | Check required apps, extend timeout |

### Sign-In Issues

| Issue | Solution |
|-------|----------|
| "Unable to sign in" | Verify account enabled, check password |
| "Can't connect to server" | Check network, verify endpoints |
| MFA prompt | Exclude account from MFA policies |
| Repeated sign-in prompts | Check Conditional Access, token issues |

### Peripheral Issues

| Issue | Solution |
|-------|----------|
| Camera not detected | Check USB connection, try different port |
| Audio not working | Verify device selected in settings |
| Console not responding | Check network/USB connection |

### Diagnostic Tools

**On device:**
```powershell
# Collect diagnostic logs
C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\Diagnostics

# Check Teams Rooms app logs
Get-Content "$env:LocalAppData\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\Logs\*.log" -Tail 100
```

**Remote:**
- Pro Management Portal device health and incidents
- Intune device status and compliance

## Validation Checklist

After deployment, verify:

- [ ] Device shows online in Pro Management Portal
- [ ] Device enrolled in Intune
- [ ] Device compliant with policies
- [ ] Calendar showing correctly
- [ ] Can join ad-hoc Teams meeting
- [ ] Can join scheduled meeting (one-touch join)
- [ ] Audio working (microphone and speaker)
- [ ] Video working (camera)
- [ ] Content sharing working
- [ ] Room remote controls working
- [ ] Bluetooth beaconing working (if enabled)

## Best Practices

1. **Use Autopilot** for consistent, scalable deployment
2. **Test with pilot rooms** before broad rollout
3. **Use Ethernet** for deployment reliability
4. **Document credentials** securely
5. **Verify network** before deployment
6. **Schedule deployment** outside meeting hours
7. **Have rollback plan** for issues
8. **Train local staff** on basic troubleshooting

## Related Topics

- [Zero-Touch Deployment](zero-touch-deployment.md)
- [Windows Autopilot](../04-intune-management/windows-autopilot.md)
- [Resource Accounts](../02-prerequisites/resource-accounts.md)
- [Troubleshooting](../06-post-deployment/troubleshooting.md)
