# Surface Hub Deployment

## Overview

Microsoft Surface Hub is a premium all-in-one meeting device that combines whiteboarding, video conferencing, and Teams meetings. Surface Hub has unique deployment requirements compared to standard Teams Rooms devices.

## Surface Hub Models

| Model | Screen Size | Platform |
|-------|-------------|----------|
| Surface Hub 2S | 50" or 85" | Windows 10 Team (EOL October 14, 2025) |
| Surface Hub 3 | 50" or 85" | Windows 11 with Teams Rooms |

> **Critical:** Surface Hub 2S on Windows 10 Team Edition lost Teams access on October 14, 2025. Hub 2S devices must be upgraded via the **Surface Hub 3 Compute Cartridge** (hardware swap) or **software migration to Windows 11** to continue functioning with Teams. Surface Hub 3 runs the full Teams Rooms on Windows experience.

## Prerequisites

### Licensing

Surface Hub requires:
- Microsoft Teams Rooms Pro or Basic license (for Teams functionality)
- Surface Hub resource account

### Network

- Ethernet recommended (Gigabit)
- Wi-Fi 6 supported
- Same port requirements as standard MTR

### Physical

- Appropriate wall mount or mobile stand
- Adequate wall reinforcement (for wall mount)
- Power outlet nearby
- Network drop or strong Wi-Fi coverage

## Deployment Methods

### Method 1: Windows Autopilot (Surface Hub 3)

Surface Hub 3 supports Autopilot deployment:

1. **Register device** with Autopilot
2. **Create Autopilot profile** for Surface Hub
3. **Power on** and connect to network
4. **Autopilot enrolls** device automatically

### Method 2: Provisioning Package (Surface Hub 2S/3)

1. **Create provisioning package** using Windows Configuration Designer
2. **Apply during OOBE** or via Settings
3. **Configure** resource account and settings

### Method 3: Manual Configuration

1. **Complete OOBE** manually
2. **Configure** account and settings through device

## Surface Hub 2S Deployment

### Initial Setup

1. **Mount device**
   - Wall mount or mobile stand
   - Connect power

2. **Power on and complete OOBE**
   - Select region and language
   - Connect to network
   - Create device admin account

3. **Configure device account**
   - Settings > Surface Hub > Accounts
   - Add device account (resource account)
   - Enter credentials

4. **Configure additional settings**
   - Settings > Surface Hub
   - Meeting settings
   - Maintenance window
   - Security settings

### Device Account Setup

```
Account: mtr-surfacehub@contoso.com
Exchange server: outlook.office365.com
SIP address: mtr-surfacehub@contoso.com
```

### MDM Enrollment

For Intune management:

1. **Settings** > **Accounts** > **Access work or school**
2. **Connect** to Entra ID
3. Device enrolls in Intune automatically

## Surface Hub 3 Deployment

Surface Hub 3 runs Teams Rooms on Windows with a Surface Hub-optimized experience.

### Initial Setup

1. **Mount and power on**

2. **Autopilot or OOBE**
   - If Autopilot configured, automatic enrollment
   - If manual, complete Windows OOBE

3. **Teams Rooms setup**
   - Configure resource account
   - Same process as standard Windows MTR

### Key Differences from Hub 2S

| Feature | Hub 2S | Hub 3 |
|---------|--------|-------|
| OS | Windows 10 Team | Windows 11 + Teams Rooms |
| Whiteboard | Windows Whiteboard | Teams Whiteboard |
| Management | Hub-specific policies | Standard MTR + Hub policies |
| Autopilot | Limited | Full support |

## Configuration

### Meeting Settings

Configure via Settings or Intune:

| Setting | Recommendation |
|---------|----------------|
| Friendly name | Room name |
| Meeting timeout | 5 minutes (or per policy) |
| Resume session | Per preference |
| Sleep timeout | 30-60 minutes |

### Security Settings

| Setting | Recommendation |
|---------|----------------|
| Password required to resume | No (for meeting continuity) |
| Bluetooth | Enable for proximity |
| USB ports | Enable (for content sharing) |

### Maintenance Window

Configure automatic updates:

```
Maintenance window start: 2:00 AM
Maintenance window duration: 4 hours
```

## Intune Management

### Device Categories

Create separate category for Surface Hub:

```powershell
$categoryParams = @{
    displayName = "Surface Hub"
    description = "Microsoft Surface Hub devices"
}
```

### Configuration Profiles

Create Surface Hub-specific profiles:

1. **Device restrictions** - Surface Hub settings
2. **Update policies** - Windows Update configuration
3. **Security baselines** - Hub-appropriate security

### CSP Settings for Surface Hub

Common OMA-URI settings:

**Meeting timeout:**
```
OMA-URI: ./Vendor/MSFT/SurfaceHub/InBoxApps/SkypeForBusiness/MeetingInfoOption
Value: 1
```

**Maintenance window:**
```
OMA-URI: ./Vendor/MSFT/SurfaceHub/MaintenanceHoursSimple/Hours/StartTime
Value: 02:00
```

## Whiteboard Integration

### Surface Hub 2S

Uses Windows Whiteboard app:
- Boards saved to OneDrive
- Share to meeting participants
- Sign in with organizational account

### Surface Hub 3

Uses Microsoft Whiteboard in Teams:
- Integrated with Teams meetings
- Collaborative during meetings
- Saved to user's OneDrive

## Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| Device account not syncing | Verify account, check password expiration |
| Touch not responsive | Calibrate touch, check connections |
| Camera/microphone issues | Update firmware, check peripherals |
| Whiteboard not saving | Verify sign-in, check OneDrive connectivity |
| Display issues | Check HDMI connections, restart |

### Diagnostic Logs

**Surface Hub 2S:**
```
Settings > Update & Security > Recovery > Get Help
```

**Surface Hub 3:**
```
Same as Windows MTR logs + Hub-specific logs
```

### Factory Reset

If needed:

1. **Settings** > **Update & Security** > **Recovery**
2. **Get started** under Reset this device
3. Choose reset type
4. Confirm and wait

## Best Practices

1. **Plan mounting carefully** - Hub devices are heavy
2. **Use Ethernet** when possible
3. **Configure maintenance window** outside business hours
4. **Enable Bitlocker** for security
5. **Document admin credentials** securely
6. **Test all features** before room handoff
7. **Train users** on Hub-specific features
8. **Configure backup admin account** for recovery

## Related Topics

- [Windows Deployment](windows-deployment.md)
- [Configuration Profiles](../04-intune-management/configuration-profiles.md)
- [Troubleshooting](../06-post-deployment/troubleshooting.md)
