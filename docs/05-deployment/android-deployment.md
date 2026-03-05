# Android MTR Deployment

## Overview

This guide provides step-by-step instructions for deploying Microsoft Teams Rooms on Android devices. Android MTR devices are typically all-in-one video bars or modular systems from certified vendors.

## Prerequisites Checklist

Before beginning deployment, ensure:

- [ ] Resource account created and licensed
- [ ] Calendar processing configured
- [ ] Conditional Access policies updated
- [ ] Intune AOSP enrollment configured (if managing with Intune)
- [ ] Network connectivity verified
- [ ] Device certified for Teams Rooms
- [ ] Resource account credentials documented
- [ ] Vendor documentation reviewed

## Vendor-Specific Considerations

Each Android MTR vendor has unique setup processes. Consult vendor documentation for:

| Vendor | Documentation |
|--------|---------------|
| Poly | poly.com/support |
| Logitech | logitech.com/support |
| Yealink | yealink.com/support |
| Neat | neat.no/support |
| Jabra | jabra.com/support |
| Cisco | cisco.com/support |

## Deployment Steps

### Step 1: Unbox and Connect Hardware

1. **Unbox device components**
   - Main video bar/compute unit
   - Touch controller (if separate)
   - Cables and power supplies
   - Mounting hardware

2. **Mount devices**
   - Mount video bar below/above display
   - Position touch controller on table
   - Route cables cleanly

3. **Connect cables**
   - Display: HDMI from video bar to display
   - Network: Ethernet (recommended) or Wi-Fi
   - Touch controller: PoE or USB-C (vendor-dependent)
   - Power: Connect last

### Step 2: Initial Device Setup

1. **Power on device**
   - Main unit and touch controller
   - Wait for boot sequence

2. **Select language and region**
   - Follow on-screen prompts
   - Select appropriate region settings

3. **Connect to network**
   - **Ethernet**: Usually auto-detected
   - **Wi-Fi**: Select network and enter credentials

4. **Accept license agreements**
   - Microsoft and vendor EULAs

### Step 3: Firmware Update (If Required)

Many devices check for firmware updates during setup:

1. **Allow update check**
2. **Install updates if available**
   - May take 10-30 minutes
   - Device will restart

> **Tip:** Ensure network connectivity is stable during firmware updates.

### Step 4: Intune Enrollment (Optional)

If managing with Intune:

1. **Choose enrollment during setup**
   - Some devices prompt for MDM enrollment
   - Or configure in device settings later

2. **Scan enrollment QR code**
   - Generate from Intune (AOSP enrollment profile)
   - Scan with device camera

3. **Complete enrollment**
   - Device downloads management profile
   - Applies configuration policies

See [Android AOSP](../04-intune-management/android-aosp.md) for detailed Intune enrollment.

### Step 5: Sign In with Resource Account

1. **Enter resource account**
   - UPN: `mtr-room@contoso.com`
   - Password: Resource account password

2. **Select account type**
   - Microsoft 365 / Office 365

3. **Complete sign-in**
   - May require accepting permissions
   - Calendar syncs

4. **Verify sign-in**
   - Calendar appears on display
   - Room name shows correctly

### Step 6: Configure Device Settings

Access settings via touch controller:

1. **Tap More (...)**
2. **Select Settings**
3. **Enter admin password**
   - Default varies by vendor
   - Change default password

**Configure:**

| Setting | Configuration |
|---------|---------------|
| Room name | Verify matches resource account |
| Theme | Per branding requirements |
| Default camera settings | Auto-frame, zoom, etc. |
| Audio settings | Volume, noise suppression |
| Display settings | Brightness, timeout |
| Bluetooth | Enable for proximity join |

### Step 7: Configure Peripherals (If Applicable)

For modular systems with additional peripherals:

1. **Extension microphones**
   - Position in room
   - Verify recognition in settings

2. **Additional cameras**
   - Connect and position
   - Configure as needed

3. **External speakers**
   - Connect and configure
   - Test audio levels

## Vendor-Specific Setup

### Poly Studio X Series

1. Complete initial setup wizard
2. Sign in at poly.com/setup (optional for cloud management)
3. Enter Teams resource account
4. Configure via touch controller or Poly Lens

### Logitech Rally Bar

1. Complete Logitech setup wizard
2. Sign in with resource account
3. Configure via touch controller
4. Optional: Connect to Logitech Sync for management

### Yealink MeetingBar

1. Follow Yealink setup wizard
2. Sign in with resource account
3. Configure via touch controller or web interface
4. Optional: Connect to Yealink Management Cloud

### Neat Bar

1. Complete Neat setup process
2. Sign in with resource account
3. Configure via Neat Pad or web portal
4. Optional: Connect to Neat Pulse for management

## Post-Deployment Configuration

### Teams Admin Center (Transitioning to PMP Through 2026)

1. Navigate to **Teams Admin Center** > **Teams devices** > **Teams Rooms on Android**
2. Locate device by room name
3. Configure:
   - Display name
   - Meeting settings
   - Device configuration

### Remote Configuration

Many vendors offer cloud management portals:

- **Poly**: Poly Lens
- **Logitech**: Sync Portal
- **Yealink**: Yealink Management Cloud
- **Neat**: Neat Pulse

These provide:
- Remote monitoring
- Firmware updates
- Configuration management
- Health alerts

## Troubleshooting

### Sign-In Issues

| Issue | Solution |
|-------|----------|
| "Unable to sign in" | Verify account enabled, password correct |
| "Network error" | Check connectivity, DNS resolution |
| MFA prompt | Update Conditional Access exclusions |
| Certificate error | Check date/time settings, update firmware |

### Peripheral Issues

| Issue | Solution |
|-------|----------|
| No video | Check HDMI connection, display input |
| No audio | Verify audio output settings |
| Touch controller not connecting | Check network/USB connection |
| Microphone not working | Check permissions, restart device |

### Network Issues

| Issue | Solution |
|-------|----------|
| "Offline" in TAC | Check network, firewall rules |
| Calendar not syncing | Verify account, check Exchange connectivity |
| Can't join meetings | Check Teams service endpoints |

### Factory Reset

If needed to start over:

1. **Access system settings**
   - Varies by vendor
   - Usually in advanced/admin settings

2. **Select Factory Reset**
   - Confirm action
   - Device resets to initial state

3. **Re-run setup**
   - Follow deployment steps again

## Validation Checklist

After deployment, verify:

- [ ] Device shows online in Teams Admin Center
- [ ] Calendar displaying correctly
- [ ] Can join Teams meeting (one-touch)
- [ ] Audio working (microphone and speaker test)
- [ ] Video working (camera preview)
- [ ] Content sharing from room working
- [ ] Proximity join working (if enabled)
- [ ] Room remote controls working

## Best Practices

1. **Use Ethernet** for reliable connectivity
2. **Update firmware** before deployment
3. **Change default passwords** immediately
4. **Test all features** before room handoff
5. **Document configuration** for each room
6. **Configure vendor cloud management** for monitoring
7. **Train local staff** on basic operations
8. **Have spare devices** for quick replacement

## Related Topics

- [Android AOSP Enrollment](../04-intune-management/android-aosp.md)
- [Resource Accounts](../02-prerequisites/resource-accounts.md)
- [Network Requirements](../01-planning/network-requirements.md)
- [Troubleshooting](../06-post-deployment/troubleshooting.md)
