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

### Cisco Room Series

Cisco Room Series devices (Room Bar, Room Bar Pro, Room Kit EQ, Room Kit Pro, Board Pro, Codec Pro) run RoomOS with Teams mode enabled: a fundamentally different architecture than other Android MTR vendors.

1. **Initial hardware setup**
   - Connect display(s) via HDMI, Ethernet for network, and power
   - Connect Cisco peripherals (Cisco Navigator touch panel, cameras, microphones)
   - Device boots into RoomOS setup wizard

2. **Register device to Cisco Control Hub**
   - Claim device in Control Hub using activation code or serial number
   - Device downloads its RoomOS configuration and firmware from Cisco cloud
   - Configure workspace assignment and device name in Control Hub

3. **Enable Microsoft Teams mode**
   - In Control Hub, navigate to the device and set the calling platform to Microsoft Teams
   - Device downloads the Teams Rooms application and restarts
   - RoomOS continues to manage the device layer (display, cameras, peripherals, network) while Teams handles the meeting experience

4. **Sign in with Teams resource account**
   - Enter resource account UPN and password on the touch panel or front-of-room display
   - Calendar syncs and room name appears
   - Device registers in Teams Admin Center as an Android MTR device

5. **Post-registration management**
   - **Control Hub** manages: RoomOS firmware, device configuration, peripheral settings, xAPI access, diagnostics
   - **Teams Admin Center / Intune** manages: Teams app updates, compliance policies, meeting settings
   - Both portals are required for complete lifecycle management

## Cisco Room Series Considerations

Cisco Room Series occupies a unique position in the Android MTR ecosystem. While most Android MTR devices (Poly, Logitech, Yealink, Neat) target small-to-medium rooms, Cisco is the only Android MTR vendor with devices certified for large and extra-large meeting spaces.

### Large and Extra-Large Room Support

Cisco is the only Android MTR platform certified for rooms beyond the typical small/medium form factor:

- **Room Kit EQ**: Supports large boardrooms (14-20 people) with multiple Cisco Quad Camera or PTZ 4K cameras, Cisco Table Microphone Pro arrays, and dual displays
- **Room Kit Pro / Codec Pro**: Supports extra-large spaces (20+ people) including training rooms and all-hands spaces, with up to three screens and extensive peripheral connectivity
- **Room 70 Panorama**: Purpose-built for extra-large executive boardrooms with dual 70" integrated displays and panoramic video

All other Android MTR vendors max out at medium conference rooms (8-14 people at most).

### Divisible Room Support

Cisco Room Kit EQ supports Room Divider functionality: a feature unique among Android MTR platforms. When a physical divider splits a large room into two smaller rooms, the system automatically reconfigures cameras, microphones, and displays to operate as two independent meeting rooms or recombines them into a single space. This typically requires third-party control system integration (Crestron, Q-SYS) on Windows MTR, but Cisco handles it natively in RoomOS.

### Third-Party Control System Integration

Cisco devices expose the xAPI interface on RoomOS, enabling integration with third-party control systems (Crestron, Q-SYS, Extron). This allows:

- Room automation triggered by meeting state (lights, blinds, displays)
- Custom touch panel interfaces overlaying Teams functionality
- Integration with building management systems
- Macro-based room behavior customization

No other Android MTR platform offers this level of third-party programmability.

### Dual Management Model

Cisco devices require management through two planes:

| Management Layer | Tool | Scope |
|-----------------|------|-------|
| Device / RoomOS | Cisco Control Hub | Firmware, device config, peripherals, xAPI, diagnostics, workspace analytics |
| Teams Application | Teams Admin Center / Intune | Teams app updates, compliance, meeting policies, resource account |

This dual-management model means IT teams need familiarity with both Cisco Control Hub and Microsoft management tools. For organizations already running Cisco collaboration infrastructure (CUCM, Webex, Expressway), Control Hub is likely already in use.

### Peripheral Ecosystem

Cisco devices use purpose-built peripherals designed for large spaces: these are not available on other Android MTR platforms:

- **Cisco Quad Camera**: Speaker-tracking camera system with four lenses and integrated speaker detection
- **Cisco PTZ 4K**: Pan-tilt-zoom camera for large rooms and auditoriums
- **Cisco Table Microphone Pro**: Directional microphone arrays for boardroom tables
- **Cisco Ceiling Microphone Pro**: Ceiling-mounted microphone arrays for rooms where table mics aren't practical
- **Cisco Navigator**: 10" touch panel controller (replaces generic touch controllers)

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
