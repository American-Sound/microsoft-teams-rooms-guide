# Microsoft Teams Rooms Overview

## What is Microsoft Teams Rooms?

Microsoft Teams Rooms (MTR) is a complete meeting solution that brings the Teams experience to conference rooms and meeting spaces of all sizes. MTR transforms meeting rooms into rich, collaborative spaces that enable hybrid meetings, allowing in-room and remote participants to interact naturally.

## Platform Options

Microsoft Teams Rooms is available on two platforms:

### Teams Rooms on Windows

MTR on Windows provides a full-featured meeting room experience running on certified compute devices.

**Key Characteristics:**
- Runs Windows 11 IoT Enterprise (Windows 10 support ended October 14, 2025)
- Supports advanced features like content cameras, intelligent speakers
- Full management via Intune and Autopilot
- Wider peripheral and hardware ecosystem
- Higher compute requirements

**Best For:**
- Large conference rooms
- Rooms requiring advanced AV setups
- Organizations with existing Windows management infrastructure
- Scenarios requiring front row layout and content cameras

### Teams Rooms on Android

MTR on Android provides a streamlined meeting experience on certified Android-based devices.

**Key Characteristics:**
- Runs Android (vendor-specific implementations)
- Generally lower cost entry point
- All-in-one form factors available (touch console + compute + camera/speaker)
- Management via Intune AOSP enrollment (2025+)
- Vendor-managed firmware updates

**Best For:**
- Small to medium meeting rooms
- Huddle spaces
- Budget-conscious deployments
- Simpler peripheral requirements

## Platform Comparison

| Feature | Windows | Android |
|---------|---------|---------|
| **Operating System** | Windows 11 IoT Enterprise | Android (vendor-specific) |
| **Form Factors** | Compute module + peripherals | All-in-one or modular |
| **Front Row Layout** | Yes | Limited |
| **Content Camera** | Yes | No |
| **Intelligent Speakers** | Yes | Limited |
| **Dual Screen Support** | Yes | Yes |
| **Coordinated Meetings** | Yes | Yes |
| **Direct Guest Join** | Yes | Yes |
| **Proximity Join** | Yes | Yes |
| **Management** | Intune, Autopilot | Intune AOSP |
| **Autopilot Support** | Yes (with Autologin) | No |
| **Typical Cost** | Higher | Lower |

> **Note on Android MTR room size coverage:** While most Android MTR devices (Poly, Logitech, Yealink, Neat, Jabra) are designed for small-to-medium rooms, **Cisco Room Series on Android** breaks this pattern. Cisco Room Kit EQ, Room Kit Pro, Codec Pro, and Room 70 Panorama are certified for large and extra-large rooms with features typically associated with Windows MTR: multiple cameras, multiple displays, content cameras, third-party control system integration (via xAPI), and divisible room support. Organizations evaluating Android MTR should not assume it is limited to small rooms if Cisco devices are in scope.

## Related Devices

### Microsoft Teams Panels

Teams Panels are wall-mounted scheduling displays that show room availability and meeting details outside conference rooms.

- Android-based touchscreen devices
- Integrate with room mailbox calendars
- Show real-time availability
- Enable ad-hoc booking
- Pair with Teams Rooms for complete solution

### Surface Hub

Surface Hub is Microsoft's all-in-one collaborative device combining whiteboarding, video conferencing, and Teams meetings.

- Surface Hub 3 (50" and 85"): runs Windows 11 with Teams Rooms experience
- Surface Hub 2S: can be upgraded to Hub 3 via Compute Cartridge or software migration (Windows 10 Team lost Teams access October 14, 2025)
- Specialized management requirements
- Premium collaboration experience

## Deployment Considerations

When planning your MTR deployment, consider:

1. **Room Size and Purpose** - Match hardware to room requirements
2. **Platform Standardization** - Consider managing one platform vs. mixed
3. **Existing Infrastructure** - use current management tools
4. **Budget Constraints** - Balance features against cost
5. **Support Capabilities** - Factor in internal IT capabilities
6. **Network Readiness** - Ensure network meets requirements
7. **Licensing Strategy** - Pro vs. Basic license requirements

## Next Steps

- [Licensing Requirements](licensing.md) - Understand Pro vs. Basic licensing
- [Hardware Requirements](hardware-requirements.md) - Certified devices and specifications
- [Network Requirements](network-requirements.md) - Bandwidth and connectivity needs
- [Interoperability](../07-interop/) - CVI, SIP dialing, and Direct Guest Join
- [Copilot and AI](../08-copilot-ai/) - Copilot, Facilitator, Intelligent Speaker, transcription
- [Teams Phone](../09-teams-phone/) - PSTN calling, Audio Conferencing, emergency calling
- [Pro Management Portal](../10-pro-management/) - Health monitoring, update management, partner portal
