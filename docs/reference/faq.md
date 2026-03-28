# Frequently Asked Questions

## General Questions

### What is Microsoft Teams Rooms?

Microsoft Teams Rooms (MTR) is a complete meeting solution that brings the Teams experience to conference rooms. It consists of certified hardware running dedicated software optimized for meeting room scenarios.

### What's the difference between Teams Rooms on Windows and Android?

**Windows MTR:**
- More advanced features (Front Row, content camera, intelligent speakers)
- Higher compute requirements and cost
- Managed via Intune with Autopilot support
- More peripheral options

**Android MTR:**
- Lower cost entry point
- All-in-one form factors available
- Simpler deployment
- Managed via vendor platforms or Intune AOSP

### Do I need Teams Rooms Pro or Basic?

**Teams Rooms Pro is recommended for all production deployments**, regardless of organization size. Pro provides the monitoring, management, security features, and Microsoft support that production meeting rooms require.

**Teams Rooms Basic** is a free license intended only for pilots and proof-of-concept evaluations. It lacks remote management, proactive alerting, advanced analytics, Teams Phone Standard, and professional support. It is limited to 25 devices per tenant and should not be used for production rooms.

## Licensing Questions

### What license does the room resource account need?

Each Teams Rooms device needs a **Microsoft Teams Rooms Pro** license for production use. Teams Rooms Basic (free, max 25 per tenant) exists for pilot and evaluation scenarios only. The license is assigned to the resource account, not the device.

### Does each room need its own license?

Yes, each resource account (room) requires its own Teams Rooms license. One license per room.

### Can I use a regular Microsoft 365 license for Teams Rooms?

No. Regular user licenses (E3, E5, Business) are not supported for Teams Rooms. You must use the dedicated Teams Rooms Pro or Basic license.

### Do Teams Panels need separate licenses?

Teams Panels can use a Shared Device license or share the license with a paired Teams Room. Check current licensing guidance as this may change.

## Account Questions

### Why do I need a resource account?

The resource account:
- Represents the room in Exchange (for calendar)
- Provides identity for Teams sign-in
- Shows the room's availability
- Enables meeting invitations

### Should the password expire on resource accounts?

No. Set passwords to never expire for resource accounts. Interactive password change is not possible on MTR devices.

### Can I use synced AD accounts for MTR?

Cloud-only accounts are recommended. Synced accounts can work but may have complications with password management and authentication.

### How do I change the resource account password?

1. Reset password in Entra ID or Microsoft 365 Admin Center
2. Update password on the device settings
3. Verify sign-in works

## Security Questions

### Why can't I require MFA for Teams Rooms?

MTR devices operate as unattended kiosks. They cannot:
- Display MFA prompts
- Accept push notifications
- Enter verification codes

Use device compliance and trusted locations instead.

### Is Teams Rooms secure without MFA?

Yes, when properly configured:
- Device compliance ensures managed device
- Trusted locations restrict where sign-in works
- Passwords are strong and non-expiring
- Conditional Access controls access

### Should I enable BitLocker on Windows MTR?

Yes. BitLocker protects data if the device is stolen. It's supported and recommended for compliance policies. Do not require a preboot PIN: the device must boot unattended.

### Can I install antivirus on MTR?

Windows MTR includes Microsoft Defender Antivirus by default. Keep it enabled. Third-party antivirus is not supported and may cause compatibility issues with the Teams Rooms app.

### Should I deploy Defender for Endpoint (MDE) on Teams Rooms?

Yes, for visibility and vulnerability management. MDE provides EDR telemetry, TVM (missing patches, vulnerable software), and security alerting. However, use protection features in Audit mode only: ASR Block mode and Network Protection enforcement can break meeting functionality. Microsoft's position: reporting supported, protection rules not recommended. See [Defender for Endpoint](../03-security/defender-endpoint.md).

### Should I configure LAPS for Teams Rooms?

Yes. LAPS automatically rotates the local admin password on each MTR device and stores it securely in Entra ID. Without LAPS, you likely have a shared admin password across all rooms: one compromised device exposes your entire fleet. LAPS password rotation does not affect the Skype user account running the MTR app, so there is no meeting disruption. See [LAPS Configuration](../03-security/laps-configuration.md).

## Deployment Questions

### How do I deploy Teams Rooms at scale?

For Windows MTR:
1. Use Windows Autopilot with self-deploying mode
2. Configure Autologin for automatic sign-in
3. Pre-register devices with vendors
4. Use dynamic groups for consistent policy application

### What's the best deployment method?

**Recommended:** Autopilot + Pro Management Portal Autologin (Windows 11)
- Zero-touch deployment: no IT presence needed at site
- Credentials delivered via cloud (no plaintext passwords on disk)
- Consistent configuration via Intune policies
- Scalable to hundreds of rooms
- Requires Teams Rooms Pro license and `MTR-` Group Tag prefix on Autopilot devices

For brownfield or Windows 10 devices, use SkypeSettings.xml to deliver resource account credentials. See [SkypeSettings.xml Reference](../reference/skypesettings-reference.md).

### How long does deployment take per device?

| Method | Time |
|--------|------|
| Autopilot + Autologin | 25-45 minutes |
| Manual deployment | 45-90 minutes |

### Do I need to be on-site to deploy?

With Autopilot: No. Device configures itself.
With manual: Yes, someone needs to complete setup.

## Network Questions

### What ports does Teams Rooms need?

Essential ports:
- TCP 80, 443 (HTTP/HTTPS)
- UDP 3478-3481 (STUN/TURN)
- UDP 50000-59999 (media - preferred)

### Should MTR devices use wired or wireless?

**Wired (recommended):**
- More reliable
- Consistent bandwidth
- Required for PoE devices

**Wireless:**
- Use only if wired not possible
- 5 GHz / Wi-Fi 6 preferred
- Ensure strong signal

### Do I need a separate VLAN for MTR?

Recommended but not required. Benefits:
- QoS policy application
- Security isolation
- Easier troubleshooting
- Traffic monitoring

## Management Questions

### How do I manage Teams Rooms devices?

| Tool | Purpose |
|------|---------|
| Pro Management Portal | Device management, health monitoring, incidents, analytics, update rings (Windows MTR) |
| Teams Admin Center | Teams policies, CQD call quality; device management for Android/Panels/Phones (transitioning to PMP) |
| Intune | Compliance, configuration profiles, enrollment |
| Vendor portals | Firmware, vendor-specific features |

### How do I update Teams Rooms software?

Updates are automatic by default. You can:
- Let devices auto-update
- Control via PMP update rings (Windows MTR) or Intune update rings (OS-level)
- Manually push via PMP (Windows MTR) or TAC (Android/Panels/Phones)
- Configure maintenance windows

### How often do devices need maintenance?

| Task | Frequency |
|------|-----------|
| Health check | Daily |
| Review updates | Weekly |
| Physical cleaning | Monthly |
| Restart | Monthly (or as needed) |

### Can I remotely restart a device?

Yes, via:
- Pro Management Portal (Windows MTR)
- Teams Admin Center (Android/Panels/Phones)
- Intune (device actions)

## Troubleshooting Questions

### The room shows as offline - what do I do?

1. Check physical network connection
2. Verify device is powered on
3. Check if signed in (look at room display)
4. Verify network/firewall allows traffic
5. Restart device

### Calendar isn't showing meetings - why?

Check:
1. Resource account is signed in
2. Exchange connectivity working
3. Calendar processing settings correct
4. Meetings are on the room calendar
5. Time zone configured correctly

### Audio/video isn't working in meetings

1. Check peripheral connections
2. Verify correct device selected in settings
3. Test peripherals (audio test in settings)
4. Update firmware
5. Try different USB ports

### Device won't sign in

Check:
1. Correct credentials
2. Account enabled in Entra ID
3. Password not expired
4. Conditional Access not blocking
5. MFA not required

## Feature Questions

### Can Teams Rooms join non-Teams meetings?

Yes, via two methods:

**Direct Guest Join (WebRTC):** Join Zoom, Cisco Webex, and Google Meet (Windows only, Feb 2026) meetings directly from the room. No additional licensing beyond Teams Rooms Basic or Pro. Limited to 720p, receive-only content sharing.

**SIP/H.323 Dialing (via CVI partner):** Join third-party meetings or make point-to-point calls to VTCs via SIP. Requires Teams Rooms Pro and a CVI partner (currently Pexip only). Supports up to 1080p and bidirectional content sharing.

See [Interoperability](../07-interop/comparison.md) for a detailed comparison.

### Can legacy VTCs join our Teams meetings?

Yes, via Cloud Video Interop (CVI). You need a certified CVI partner (Pexip or Cisco) and must assign a CVI policy to meeting organizers. VTC users dial using the coordinates included in the Teams meeting invite. See [Cloud Video Interop](../07-interop/cloud-video-interop.md).

### Does Teams Rooms support PSTN calling?

Yes. Teams Rooms Pro includes Teams Phone Standard. You additionally need a PSTN connectivity option (Calling Plan, Direct Routing, Operator Connect, or Shared Calling) and a phone number assigned to the resource account. See [Teams Phone](../09-teams-phone/pstn-overview.md).

### Does Teams Rooms support Copilot?

Yes. Individual users need a Microsoft 365 Copilot license for in-meeting Copilot queries. The room resource account needs Teams Rooms Pro. Transcription must be enabled via meeting policy. See [Copilot in Teams Rooms](../08-copilot-ai/copilot-overview.md).

### What is Facilitator?

Facilitator is an AI agent that provides shared AI-generated notes, agenda tracking, and Q&A visible to all participants on the front-of-room display. It requires M365 Copilot licenses and Teams Rooms Pro. See [Facilitator](../08-copilot-ai/facilitator.md).

### Where do I manage Teams Rooms devices?

As of June 2025, Teams Rooms on Windows devices are managed in the **Pro Management Portal** (portal.rooms.microsoft.com), not the Teams Admin Center. Android devices are transitioning to PMP through 2026. TAC continues to handle Teams policies, users, and meeting settings. See [Pro Management Portal](../10-pro-management/portal-overview.md).

### Can I customize the room display?

Yes:
- Custom backgrounds
- Themes
- Company branding
- Display layouts

### Does Teams Rooms support whiteboarding?

Yes:
- Microsoft Whiteboard integrated
- Interactive on touch displays
- Share to meeting participants

## Getting Help

### Where do I get support?

| Issue Type | Contact |
|------------|---------|
| Microsoft service | Microsoft 365 support ticket |
| Hardware | Device vendor support |
| Licensing | Microsoft partner or account team |
| Community help | Microsoft Tech Community |

### Where can I report issues?

- Microsoft 365 Admin Center support
- Microsoft Tech Community forums
- Feedback Hub (on Windows devices)
- Vendor support channels
