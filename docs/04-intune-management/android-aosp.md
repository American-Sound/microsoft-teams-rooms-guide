# Android AOSP Enrollment for Teams Rooms

## Overview

Android-based Microsoft Teams Rooms devices use Android Open Source Project (AOSP) enrollment in Microsoft Intune. This provides a standardized management experience for Android MTR devices.

## Understanding AOSP Enrollment

### What is AOSP?

AOSP enrollment is a device management mode for corporate-owned Android devices that don't require Google Mobile Services (GMS). It's designed for dedicated-use devices like kiosks and meeting room systems.

### Why AOSP for MTR?

- **Consistent management** across vendors
- **No Google dependency** for device management
- **Dedicated device mode** optimized for single-purpose use
- **Corporate-owned** device management model
- **Intune integration** for policies and compliance

## Prerequisites

### Requirements

- Microsoft Intune license
- Android device certified for Teams Rooms
- Device running compatible Android version
- Network connectivity during enrollment
- Enrollment token/QR code generated

### Supported Devices

Check with your vendor for AOSP support:
- Poly Studio X Series
- Logitech Rally Bar devices
- Yealink MeetingBar series
- Neat devices
- Cisco Room Series (Room Bar, Room Bar Pro, Room Kit EQ, Board Pro, Codec Pro, Room Kit Pro)
- Other certified Android MTR devices

> **Note:** Not all Android MTR devices support AOSP enrollment. Verify with your vendor before purchase.

> **Cisco-specific note:** Cisco Room Series devices run RoomOS with the Teams Rooms application on top, rather than a stock Android build with the Teams app. This means device-layer management (firmware, peripherals, device configuration) is handled through Cisco Control Hub, while Intune AOSP enrollment manages the Teams application layer. Enrollment behavior may differ from other Android MTR vendors: consult Cisco documentation for the current enrollment workflow and any RoomOS version requirements for Intune AOSP support.

## Intune Configuration

### Enable AOSP Enrollment

1. Navigate to **Intune Admin Center** > **Devices** > **Enrollment**
2. Select **Android enrollment**
3. Select **Corporate-owned, userless devices**
4. Click **Create** to add an enrollment profile

### Create Enrollment Profile

1. **Basics:**
   - Name: `MTR-Android-AOSP-Profile`
   - Description: `AOSP enrollment for Android Teams Rooms`
   - Token type: **Corporate-owned dedicated device (default)**

2. **Settings:**
   - Enrollment token expiration: **90 days** (adjust as needed)

3. **Scope tags:** Add if using scope tags

4. **Review + Create**

### Generate Enrollment Token

After creating the profile:

1. Select the profile
2. Click **Token**
3. View or copy the enrollment token
4. Download QR code for easy enrollment

### Token Management

| Field | Description |
|-------|-------------|
| Token value | Alphanumeric string for manual entry |
| QR code | Scannable code containing token |
| Expiration | Date token becomes invalid |
| Devices enrolled | Count of devices using this token |

## Device Enrollment Process

### Step 1: Factory Reset

If device was previously configured:
1. Access device settings
2. Navigate to **System** > **Reset**
3. Select **Factory data reset**
4. Confirm and wait for reset to complete

### Step 2: Initial Setup

1. Power on device
2. Connect to Wi-Fi network
3. Begin setup wizard

### Step 3: Enrollment Method

Depending on vendor, choose one:

**QR Code Method:**
1. When prompted, tap screen 6 times rapidly
2. This opens QR code scanner
3. Scan the enrollment QR code from Intune
4. Device enrolls automatically

**Token Entry Method:**
1. Enter enrollment token manually
2. Follow on-screen prompts

**Vendor-Specific Method:**
- Some vendors have custom enrollment flows
- Follow vendor documentation
- May require specific setup steps

### Step 4: Post-Enrollment

1. Device downloads Intune management profile
2. Policies and configurations apply
3. Teams Rooms app configures
4. Device ready for use

## Configuration Profiles

### Device Restrictions

Create device restrictions for Android AOSP:

1. Navigate to **Intune Admin Center** > **Devices** > **Configuration profiles**
2. **Create profile**
3. Platform: **Android (AOSP)**
4. Profile type: **Device restrictions**

**Recommended settings:**
- Camera: **Allow** (required for video meetings)
- Microphone: **Allow** (required for audio)
- Screen capture: **Allow** or **Block** per policy
- USB file transfer: **Block** (security)
- Factory reset: **Block** (prevent unauthorized reset)

### Wi-Fi Configuration

Create Wi-Fi profile for enterprise networks:

1. **Create profile**
2. Platform: **Android (AOSP)**
3. Profile type: **Wi-Fi**
4. Configure:
   - SSID: Your corporate SSID
   - Security: WPA2-Enterprise
   - EAP type: As required
   - Certificates: Deploy separately

## Compliance Policies

### Create Android AOSP Compliance

1. Navigate to **Intune Admin Center** > **Devices** > **Compliance policies**
2. **Create policy**
3. Platform: **Android (AOSP)**

**Recommended settings:**

**Device Health:**
- Rooted devices: **Block**

**Device Properties:**
- Minimum OS version: Per vendor recommendation

**System Security:**
- Require encryption: **Yes**

**Actions for noncompliance:**
- Mark noncompliant: **Immediately**

## Troubleshooting

### Enrollment Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| QR code won't scan | Camera issue or invalid code | Regenerate token/QR code |
| Token expired | Past expiration date | Create new enrollment profile |
| Network error | No connectivity | Verify Wi-Fi connection |
| Enrollment blocked | Platform restriction | Enable AOSP in Intune |

### Post-Enrollment Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Policies not applying | Sync delay | Force sync from device |
| Apps not installing | Deployment not assigned | Verify app assignments |
| Device noncompliant | Configuration drift | Review compliance details |

### Diagnostic Steps

1. **Check device enrollment:**
   - Navigate to Intune > Devices > Android
   - Search for device by serial number

2. **View device details:**
   - Check last sync time
   - Review compliance state
   - Verify assigned profiles

3. **Force sync:**
   - In Intune portal: Device > Sync
   - On device: Settings > Accounts > Work account > Sync

## Best Practices

1. **Create dedicated profiles** for MTR devices
2. **Test enrollment process** with pilot devices
3. **Document vendor-specific steps** for each device type
4. **Use QR codes** for faster enrollment
5. **Set appropriate token expiration** (not too short)
6. **Monitor enrollment status** in Intune dashboard
7. **Keep spare tokens** available for new devices
8. **Coordinate with vendors** for firmware requirements

## Migration from Legacy Enrollment

If migrating from older enrollment methods:

1. **Document current configuration**
2. **Create AOSP profiles** that match existing
3. **Test with pilot devices**
4. **Factory reset** and re-enroll devices
5. **Verify functionality** before production

> **Warning:** Factory reset is typically required when changing enrollment types. Plan for downtime.

## Related Topics

- [Enrollment Overview](enrollment-overview.md)
- [Android Deployment](../05-deployment/android-deployment.md)
- [Compliance Policies](compliance-policies.md)
- [Configuration Profiles](configuration-profiles.md)
