# Troubleshooting Guide

## Overview

This guide provides troubleshooting procedures for common Microsoft Teams Rooms issues. Use this as a reference when devices experience problems.

## Diagnostic Approach

### Troubleshooting Framework

1. **Identify** - What exactly is the problem?
2. **Scope** - One device or multiple?
3. **Reproduce** - Can the issue be recreated?
4. **Isolate** - What changed recently?
5. **Research** - Check logs and documentation
6. **Resolve** - Apply fix
7. **Verify** - Confirm issue resolved
8. **Document** - Record for future reference

### Information to Gather

Before troubleshooting:
- Device name and location
- Exact error message (screenshot if possible)
- When did the issue start?
- What actions trigger the issue?
- Any recent changes?

## Common Issues and Solutions

### Sign-In Issues

#### "Unable to sign in"

**Symptoms:**
- Device shows sign-in error
- Resource account won't authenticate

**Possible Causes:**
1. Incorrect password
2. Account disabled
3. Password expired
4. Conditional Access blocking
5. MFA required

**Solutions:**

| Cause | Solution |
|-------|----------|
| Password incorrect | Verify and re-enter |
| Account disabled | Enable in Entra ID |
| Password expired | Reset password, set non-expiring |
| CA blocking | Check/update exclusions |
| MFA required | Exclude account from MFA |

**Verification:**
```powershell
# Check account status
Connect-MgGraph -Scopes "User.Read.All"
Get-MgUser -Filter "userPrincipalName eq 'mtr-room@contoso.com'" | Select AccountEnabled, PasswordPolicies
```

#### "Can't connect to server"

**Possible Causes:**
1. Network connectivity
2. DNS resolution
3. Firewall blocking
4. Proxy misconfiguration

**Solutions:**
1. Verify network connection (ping test)
2. Check DNS (nslookup teams.microsoft.com)
3. Verify firewall rules allow Teams endpoints
4. Check/bypass proxy for Teams traffic

### Meeting Join Issues

#### "Unable to join meeting"

**Symptoms:**
- One-touch join fails
- Manual join doesn't work

**Possible Causes:**
1. Network issues
2. Calendar sync problems
3. Account authentication
4. Service outage

**Solutions:**

1. **Check network:**
   ```cmd
   ping teams.microsoft.com
   Test-NetConnection -ComputerName teams.microsoft.com -Port 443
   ```

2. **Verify calendar sync:**
   - Check calendar shows meetings
   - Verify Exchange connectivity

3. **Test authentication:**
   - Sign out and sign back in
   - Check account status

4. **Check service status:**
   - Visit status.microsoft.com
   - Check Microsoft 365 Service Health

#### Meeting audio/video not working

**Symptoms:**
- No audio in meeting
- Video not showing
- Remote participants can't hear/see room

**Solutions:**

| Issue | Solution |
|-------|----------|
| No audio | Check speaker/mic selection, volume |
| No video | Check camera selection, privacy shutter |
| One-way audio | Check network for UDP blocking |
| Poor quality | Check bandwidth, QoS settings |

### Peripheral Issues

#### Camera Not Detected

**Symptoms:**
- Camera not available in settings
- Video preview not working

**Solutions:**
1. Check USB connection (reseat cable)
2. Try different USB port
3. Verify camera power (if external power required)
4. Check for driver updates
5. Restart device

#### Audio Device Issues

**Symptoms:**
- Microphone not picking up sound
- Speaker no output
- Echo in calls

**Solutions:**

| Issue | Solution |
|-------|----------|
| No mic input | Check connection, verify selection |
| No speaker | Check connection, volume, verify selection |
| Echo | Enable echo cancellation, check room acoustics |
| Feedback | Lower volume, adjust mic placement |

#### Touch Console Not Responding

**Symptoms:**
- Touch input not working
- Console shows no display
- Console not connected

**Solutions:**
1. Check USB-C/Ethernet cable
2. Verify PoE power (if applicable)
3. Restart console
4. Check compute unit connectivity
5. Update firmware

### Display Issues

#### Front-of-Room Display Blank

**Symptoms:**
- No image on display
- Display shows "No Signal"

**Solutions:**
1. Check HDMI cable connection
2. Verify display is on correct input
3. Check MTR display settings
4. Try different HDMI port
5. Test with different cable

#### Content Sharing Not Working

**Symptoms:**
- Wireless content share fails
- HDMI ingest not showing

**Solutions:**
1. Verify content sharing enabled
2. Check network (wireless share)
3. Verify HDMI input device connected
4. Restart MTR app

### Calendar Issues

#### Calendar Not Showing Meetings

**Symptoms:**
- No meetings displayed
- Outdated information

**Possible Causes:**
1. Exchange sync issue
2. Account configuration
3. Calendar processing settings
4. Network connectivity

**Solutions:**
```powershell
# Verify calendar processing
Get-CalendarProcessing -Identity "mtr-room@contoso.com" |
    Select AutomateProcessing, ProcessExternalMeetingMessages
```

1. Verify account signed in
2. Check Exchange connectivity
3. Verify calendar processing settings
4. Force calendar sync (restart app)

### Device Offline

#### Device Shows Offline in Admin Portal

**Symptoms:**
- Device not showing in TAC
- Offline status despite being powered on

**Possible Causes:**
1. Network disconnection
2. Account sign-out
3. Device crash
4. Firewall blocking telemetry

**Solutions:**
1. Verify physical network connection
2. Check device is at home screen (signed in)
3. Restart device
4. Verify telemetry endpoints accessible

### Compliance Issues

#### Device Shows Non-Compliant

**Symptoms:**
- Intune compliance failure
- Conditional Access blocking

**Solutions:**
1. Check specific compliance failure in Intune
2. Common fixes:

| Failed Setting | Solution |
|----------------|----------|
| BitLocker | Enable via policy |
| OS version | Update Windows |
| Defender | Verify Defender running |
| Firewall | Enable firewall |

3. Force compliance check:
   - Sync device from Intune
   - Restart device

## Log Collection

### Windows MTR Logs

**Application Logs:**
```
C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\
```

**Event Viewer:**
- Applications and Services Logs > Microsoft > Windows > DeviceManagement

**Collect via PowerShell:**
```powershell
# Copy logs to accessible location
$logPath = "$env:LOCALAPPDATA\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\Logs"
Copy-Item -Path "$logPath\*" -Destination "C:\Temp\MTRLogs" -Recurse
```

### Android MTR Logs

**Via Device:**
1. Access admin settings
2. Navigate to diagnostics
3. Export logs

**Via Vendor Platform:**
- Use Poly Lens, Logitech Sync, etc.
- Request diagnostic bundle

### Remote Log Collection

**Via Teams Admin Center:**
1. Select device
2. **Actions** > **Download device logs**
3. Wait for collection
4. Download when ready

**Via Pro Management Portal:**
1. Select device
2. Navigate to **Diagnostics**
3. Initiate log collection

## Network Diagnostics

### Connectivity Tests

**Basic Connectivity:**
```cmd
ping teams.microsoft.com
ping outlook.office365.com
```

**Port Tests:**
```powershell
Test-NetConnection -ComputerName teams.microsoft.com -Port 443
Test-NetConnection -ComputerName 13.107.64.2 -Port 3478
```

**DNS Resolution:**
```cmd
nslookup teams.microsoft.com
nslookup outlook.office365.com
```

### Network Assessment Tool

Run Microsoft Network Assessment Tool:
```powershell
# Download from Microsoft
# Provides Teams media quality assessment
```

## Escalation

### When to Escalate

- Issue persists after standard troubleshooting
- Multiple devices affected
- Critical room impacted
- Hardware failure suspected
- Service outage suspected

### Escalation Information

Prepare:
- Device serial number
- Issue description
- Steps already taken
- Log files
- Screenshots/recordings

### Support Channels

| Issue Type | Contact |
|------------|---------|
| Microsoft service | Microsoft 365 support |
| Device hardware | Vendor support |
| Intune/Entra | Microsoft support |
| Network | Internal network team |

## Quick Reference

### Common Fixes

| Symptom | Quick Fix |
|---------|-----------|
| General issues | Restart device |
| Sign-in problems | Re-enter credentials |
| Peripheral issues | Reseat cables |
| Network issues | Check cables, restart switch port |
| Display issues | Check HDMI, display input |
| Audio issues | Check device selection, volume |

### Emergency Procedures

**Room needed urgently:**
1. Check if device boots to home screen
2. If yes, try manual meeting join
3. If no, use laptop with Teams
4. Document and escalate after meeting

## Related Topics

- [Monitoring and Alerting](monitoring-alerting.md)
- [Pro Management Portal](../10-pro-management/portal-overview.md)
- [Network Requirements](../01-planning/network-requirements.md)
- [Conditional Access](../03-security/conditional-access.md)
