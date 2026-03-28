# Hardware Requirements

## Overview

Microsoft Teams Rooms requires certified hardware to ensure a consistent, reliable meeting experience. Only devices that have passed Microsoft's certification program are officially supported.

## Certification Program

Microsoft certifies Teams Rooms hardware through a rigorous testing process:

- Devices must meet performance requirements
- Audio and video quality standards
- Integration testing with Teams services
- Firmware and software compatibility verification

> **Important:** Using non-certified hardware may result in unsupported configurations, degraded experience, and compatibility issues.

## Certified Device Categories

### Teams Rooms on Windows

#### Compute Modules
Dedicated compute devices that run the MTR on Windows application:

**Vendors:**
- Lenovo ThinkSmart Core
- HP Elite Slice G2
- Dell OptiPlex
- Logitech Rally Bar (with compute)
- Poly G Series
- Yealink MVC Series

**Minimum Specifications:**
- Processor: Intel Core i5 (8th gen+) or equivalent
- RAM: 8 GB minimum (16 GB recommended)
- Storage: 128 GB SSD
- USB ports: Multiple USB 3.0
- Display outputs: 1-2 HDMI/DisplayPort
- Network: Gigabit Ethernet (required), Wi-Fi optional
- TPM 2.0, Secure Boot, UEFI required
- Windows 11 IoT Enterprise or Enterprise (General Availability Channel)

> **Important:** Windows 10 support ended October 14, 2025. Devices that cannot run Windows 11 must be replaced. Known incompatible devices include Lenovo Hub 500 (i5-7500T), HP Slice G2 (i5-7500T), Yealink NUC (i5-7300U), Surface Pro 5 (i5-7300U), and Crestron Skull Canyon (i7-6770HQ). LTSB/LTSC, IoT LTSB/LTSC, Pro, and Home editions are not supported.

#### Peripherals

**Cameras:**
- Must support UVC (USB Video Class)
- 1080p minimum resolution
- Wide field of view recommended (90°+)
- Examples: Poly Studio, Jabra PanaCast, Logitech Rally Camera

**Audio Devices:**
- Speakerphones and soundbars
- USB or certified room audio systems
- Examples: Poly Sync, Jabra Speak, Lenovo ThinkSmart Bar

**Displays:**
- Any display with HDMI input
- 4K recommended for front-of-room
- Touch display optional for interactive content

**Touch Console:**
- Required for room control
- Certified consoles from Lenovo, HP, Poly, Logitech, Yealink
- Typically 10" touchscreen

### Teams Rooms on Android

Android-based systems are typically all-in-one or modular certified bundles:

**Vendors:**
- Poly Studio X Series
- Yealink MeetingBoard
- Logitech Rally Bar / Rally Bar Mini
- Cisco Room Series (with Teams)
- Neat Bar / Neat Board
- Jabra PanaCast 50

**Form Factors:**

**All-in-One Bars:**
- Integrated camera, speaker, microphone, compute
- Single device deployment
- Best for small/medium rooms

**Modular Systems:**
- Separate components connected to central compute
- Scalable for larger rooms
- More flexibility in room design

**Video Bars:**
- Camera and speaker bar only
- Requires separate touch controller

## Room Size Guidelines

### Huddle/Focus Room (2-4 people)

**Recommended:**
- All-in-one video bar
- Small display (40-55")
- Simple deployment

**Example Setups:**
- Poly Studio X30 + TC8 Touch
- Logitech Rally Bar Mini + Tap
- Yealink MeetingBar A20

### Small Conference (4-8 people)

**Recommended:**
- Mid-size video bar or modular system
- 55-65" display
- Touch console

**Example Setups:**
- Poly Studio X50 + TC8
- Logitech Rally Bar + Tap
- Lenovo ThinkSmart Core + Bar

### Medium Conference (8-14 people)

**Recommended:**
- Modular system with separate camera
- Dual displays optional
- Table microphones may be needed

**Example Setups:**
- MTR on Windows with PTZ camera
- Poly Studio X70 + expansion mics
- Logitech Rally Plus system

### Large/Boardroom (14-20 people)

**Recommended:**
- MTR on Windows with professional AV integration, or Cisco Room Kit EQ (Android)
- Multiple cameras or PTZ
- Ceiling or table microphone arrays
- Dual displays
- DSP for audio processing

**Example Setups:**
- Windows MTR compute + Biamp, Q-SYS, or Crestron DSP integration
- Cisco Room Kit EQ + Cisco Quad Camera + Cisco Table Microphone Pro arrays + dual displays (Android MTR)
- Professional installation recommended for both platforms

> **Note:** Cisco Room Kit EQ is the only Android MTR platform certified for large rooms. All other Android MTR vendors (Poly, Logitech, Yealink, Neat) are limited to medium rooms and below.

### Extra Large (20+ people)

For auditoriums, training rooms, all-hands spaces, and executive boardrooms with 20+ seats, the device options are limited to Windows MTR with custom AV integration or Cisco Room Series on Android.

**Recommended:**
- Multiple displays (up to three screens)
- PTZ cameras or multi-camera systems
- Ceiling microphone arrays or distributed table microphones
- External DSP for audio processing and room coverage
- Professional AV integration required

**Example Setups:**
- Windows MTR compute + Q-SYS Core DSP + ceiling mic arrays + PTZ cameras
- Cisco Codec Pro + Cisco PTZ 4K cameras + Cisco Ceiling Microphone Pro arrays (Android MTR)
- Cisco Room 70 Panorama: dual 70" integrated displays with panoramic video (Android MTR)

### Divisible Rooms

Divisible rooms use a physical partition to split a large space into two or more independent meeting rooms, each requiring its own Teams Rooms session when divided and a combined session when open.

**Options:**
- **Cisco Room Kit EQ with Room Divider** (Android MTR): native room divider support in RoomOS automatically reconfigures cameras, microphones, and displays when the partition moves. No third-party control system required for the divider logic.
- **Windows MTR with third-party control system**: Crestron, Q-SYS, or Extron control system manages room combining logic, switching between two independent MTR computes (divided) and a single MTR compute (combined). Requires professional AV integration and programming.

> **Note:** Divisible rooms are among the most complex meeting space deployments. Both approaches require careful planning around microphone zones, camera coverage per room half, display assignment, and network connectivity for multiple potential MTR sessions.

## Network Hardware Requirements

**Wired Network:**
- Gigabit Ethernet port required
- PoE switch port for touch consoles (802.3at/af)
- Separate VLAN recommended

**Switch Requirements:**
- Support for QoS/DSCP marking
- LLDP-MED for voice VLAN
- Sufficient port capacity

**Optional Wi-Fi:**
- Not recommended for primary connection
- 5 GHz / Wi-Fi 6 if used
- Enterprise WPA2/WPA3

## Power Requirements

- UPS recommended for compute devices
- Power strip with surge protection
- Consider PoE for peripherals where supported
- Account for display power requirements

## Display Requirements

**Front of Room Display(s):**
- HDMI input (CEC optional but helpful)
- 4K resolution recommended
- Brightness: 350+ nits
- Size: Appropriate for room dimensions and viewing distance

**Touch Console:**
- PoE powered (most models)
- USB-C or Ethernet connection to compute
- Table mount or wall mount options

## Certified Device Finder

Microsoft maintains an up-to-date list of certified devices:

**Official Certification List:**
[Microsoft Teams Rooms Certified Devices](https://learn.microsoft.com/microsoftteams/rooms/certified-hardware)

> **Tip:** Filter by room type, vendor, and platform to find suitable devices.

## Procurement Considerations

1. **Lead Times** - Plan for hardware availability
2. **Warranty** - Consider extended warranty options
3. **Support** - Vendor support agreements
4. **Spare Equipment** - Budget for replacement units
5. **Accessories** - Cables, mounts, power supplies
6. **Installation** - Professional AV integration for complex rooms

## Related Topics

- [Network Requirements](network-requirements.md)
- [Windows Deployment](../05-deployment/windows-deployment.md)
- [Android Deployment](../05-deployment/android-deployment.md)
