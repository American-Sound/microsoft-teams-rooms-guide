# Microsoft Defender for Endpoint on Teams Rooms

## Overview

Microsoft Defender for Endpoint (MDE) provides endpoint detection and response (EDR), threat and vulnerability management (TVM), and antivirus capabilities for Windows-based Teams Rooms devices. Configuring MDE on MTR requires a fundamentally different approach than standard workstations: these are purpose-built kiosk devices running in Assigned Access mode, and aggressive protection policies can break meeting functionality.

Microsoft's official position: **reporting capabilities are fully supported on Teams Rooms; protection rules (ASR in Block mode, Network Protection enforcement, aggressive remediation) are not recommended.** The value proposition for MDE on MTR is visibility and vulnerability awareness, not active threat blocking.

## Teams Rooms Default Security Posture

Before configuring MDE, it's important to understand what protections already exist on Teams Rooms on Windows devices out of the box:

**Assigned Access (Shell Launcher):** The MTR app runs as a kiosk application under the local `Skype` user account. This user cannot access the desktop, file explorer, browser, or run arbitrary applications. The attack surface is fundamentally narrower than a standard workstation.

**Local Account Isolation:** The `Skype` account is a standard (non-admin) user. Administrative actions require the separate local admin account, which should be managed via LAPS (see [LAPS Configuration](laps-configuration.md)).

**Hardware Protections:** Certified Teams Rooms devices include TPM 2.0, Secure Boot, and UEFI firmware: all providing hardware-rooted security before the OS even loads.

**Microsoft Defender Antivirus:** Enabled by default on all Windows MTR devices. Real-time protection, cloud-delivered protection, and automatic signature updates are active out of the box.

**Automatic Updates:** The MTR app and Windows OS update automatically (controllable via Pro Management Portal update rings), keeping the device patched without admin intervention.

## Platform Support

| Platform | MDE Support | Notes |
|----------|-------------|-------|
| Windows MTR | Supported | EDR + TVM reporting recommended; protection rules in Audit only |
| Android MTR | Not supported | Managed via vendor platforms or Intune AOSP |
| Teams Panels | Not supported |: |

## Prerequisites

### Licensing

The **Teams Rooms Pro** license includes **Microsoft Defender for Endpoint Plan 2**. No additional security license is required for MDE on Teams Rooms Pro-licensed devices.

If you are using Teams Rooms Basic (for pilots/evaluations), MDE is not included and would require a separate license such as:
- Microsoft 365 E5
- Microsoft 365 E5 Security
- Microsoft Defender for Endpoint Plan 2 (standalone)

### Requirements

- Windows 11 IoT Enterprise (Windows 10 reached EOL October 14, 2025)
- Network connectivity to Microsoft Defender endpoints
- Device enrolled in Intune (recommended for EDR policy deployment)
- Intune connector configured for MDE integration

## Onboarding Methods

### Method 1: Intune EDR Policy (Recommended)

The cleanest approach for MTR devices already enrolled in Intune:

1. **Configure the Intune-MDE connector** (one-time setup):
   - In the **Microsoft Defender portal** (security.microsoft.com), go to **Settings** > **Endpoints** > **Advanced Features**
   - Enable **Microsoft Intune connection**
   - In **Intune Admin Center**, go to **Endpoint Security** > **Microsoft Defender for Endpoint**
   - Enable **Allow Microsoft Defender for Endpoint to enforce Endpoint Security Configurations**

2. **Create EDR policy:**
   - Navigate to **Intune Admin Center** > **Endpoint Security** > **Endpoint detection and response**
   - Click **Create policy**
   - Platform: **Windows 10, Windows 11, and Windows Server**
   - Profile: **Endpoint detection and response**
   - Configure:
     - Microsoft Defender for Endpoint client configuration package type: **Auto from connector**
     - Sample sharing for all files: **Yes**
     - Expedite telemetry reporting frequency: **Yes**
   - Assign to your **MTR-Devices-Windows** dynamic group

### Method 2: Local Onboarding Script

For devices not managed by Intune or for one-off deployments:

1. In the **Microsoft Defender portal**, go to **Settings** > **Endpoints** > **Onboarding**
2. Select deployment method: **Local Script**
3. Download the onboarding package
4. On the MTR device, sign in with the local admin account
5. Run:

```powershell
# Run from an elevated PowerShell prompt
.\WindowsDefenderATPLocalOnboardingScript.cmd
```

6. Verify onboarding:

```powershell
$status = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status"
if ($status.OnboardingState -eq 1) { Write-Host "MDE onboarded successfully" }
```

### Method 3: Group Policy

For Hybrid Entra ID joined devices managed via on-prem AD:

1. Download the Group Policy onboarding package from the Defender portal
2. Extract to your central policy store
3. Configure via GPO:
   - Computer Configuration > Administrative Templates > Windows Components > Microsoft Defender ATP
   - Enable **Onboard to Microsoft Defender ATP**
   - Set onboarding blob from the downloaded package

## Antivirus Configuration

Microsoft Defender Antivirus runs by default on all Windows MTR devices. The primary configuration considerations are scan scheduling (to avoid impacting meetings) and appropriate exclusions for the Teams Rooms app.

### Recommended Antivirus Settings

```powershell
# Schedule scans during off-hours: avoid scanning during meeting times
Set-MpPreference -ScanScheduleDay 0              # Every day
Set-MpPreference -ScanScheduleTime "02:00:00"    # 2 AM local time
Set-MpPreference -ScanParameters 1               # Quick scan (not full)
Set-MpPreference -RemediationScheduleDay 0       # Remediate daily

# Signature updates: frequent but not aggressive
Set-MpPreference -SignatureUpdateInterval 4       # Every 4 hours

# Cloud protection: leave enabled (default)
Set-MpPreference -MAPSReporting Advanced
Set-MpPreference -SubmitSamplesConsent SendAllSamples

# Real-time protection: leave enabled (default)
Set-MpPreference -DisableRealtimeMonitoring $false
```

### Process and Path Exclusions

Add exclusions only if you observe performance issues (high CPU, audio glitches, delayed meeting joins). The new Teams app on MTR uses `ms-teams.exe`, not the legacy `Microsoft.SkypeRoomSystem.exe`:

```powershell
# Teams Rooms app process (new Teams client)
Add-MpPreference -ExclusionProcess "ms-teams.exe"

# Teams Rooms app data
Add-MpPreference -ExclusionPath "C:\Users\Skype\AppData\Local\Packages\MSTeamsRoomSystem*"

# Legacy Teams Rooms process (if still running older app version)
# Add-MpPreference -ExclusionProcess "Microsoft.SkypeRoomSystem.exe"
# Add-MpPreference -ExclusionPath "C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem*"
```

> **Caution:** Only add exclusions when you have documented performance issues. Every exclusion reduces your protection surface. Start without exclusions and add selectively if needed.

### Intune Antivirus Policy

To manage antivirus settings centrally via Intune:

1. **Intune Admin Center** > **Endpoint Security** > **Antivirus**
2. Create policy for Windows 10/11
3. Configure:
   - Real-time protection: **Enable**
   - Cloud-delivered protection: **Enable**
   - Cloud-delivered protection level: **High**
   - Scan type: **Quick scan**
   - Scheduled scan time: **2:00 AM**
   - Signature update interval: **4 hours**
4. Assign to **MTR-Devices-Windows** group

## Attack Surface Reduction (ASR) Rules

**Critical: Use Audit mode only on Teams Rooms devices.** Microsoft explicitly recommends against enabling ASR rules in Block mode on MTR because they can interfere with the Teams Rooms application, peripheral drivers, and firmware update processes. ASR in Audit mode gives you visibility into what would be blocked without actually disrupting meetings.

### Recommended ASR Configuration

```powershell
# AUDIT MODE ONLY: Do NOT use "Enabled" (Block) on MTR devices
# Action value: 0 = Disabled, 1 = Block, 2 = Audit, 6 = Warn

# Block executable content from email and webmail
Set-MpPreference -AttackSurfaceReductionRules_Ids BE9BA2D9-53EA-4CDC-84E5-9B1EEEE46550 `
    -AttackSurfaceReductionRules_Actions AuditMode

# Block Office apps from creating child processes
Set-MpPreference -AttackSurfaceReductionRules_Ids D4F940AB-401B-4EFC-AADC-AD5F3C50688A `
    -AttackSurfaceReductionRules_Actions AuditMode

# Block credential stealing from LSASS
Set-MpPreference -AttackSurfaceReductionRules_Ids 9E6C4E1F-7D60-472F-BA1A-A39EF669E4B2 `
    -AttackSurfaceReductionRules_Actions AuditMode

# Block untrusted/unsigned processes from USB
Set-MpPreference -AttackSurfaceReductionRules_Ids B2B3F03D-6A65-4F7B-A9C7-1C7EF74A9BA4 `
    -AttackSurfaceReductionRules_Actions AuditMode

# Block process creations originating from PSExec and WMI
Set-MpPreference -AttackSurfaceReductionRules_Ids D1E49AAC-8F56-4280-B9BA-993A6D77406C `
    -AttackSurfaceReductionRules_Actions AuditMode
```

### Why Not Block Mode?

Teams Rooms devices have unique runtime behaviors that conflict with ASR Block mode:
- The MTR app launches child processes for peripheral management (cameras, microphones, speakers)
- USB devices are plugged/unplugged frequently (content cameras, HDMI ingest)
- Firmware updates from vendors may execute unsigned processes temporarily
- The Shell Launcher kiosk configuration relies on specific process chains that ASR rules can interrupt

Review ASR audit logs in the Defender portal to understand your environment's behavior before considering any exceptions.

## Network Protection

Like ASR, Network Protection should be configured in **Audit mode only** on MTR devices. Block mode can interfere with meeting connectivity, especially for Direct Guest Join (WebRTC to third-party platforms) and CVI connections.

```powershell
# Audit mode: logs connections to risky destinations without blocking
Set-MpPreference -EnableNetworkProtection AuditMode
```

Do **not** use:
```powershell
# Do NOT enable Block mode on MTR: can disrupt meeting connectivity
# Set-MpPreference -EnableNetworkProtection Enabled
```

## Firewall Configuration

Windows Firewall is enabled by default on MTR. The Teams Rooms app creates its own firewall rules during installation. If deploying additional firewall policies via Intune, ensure these ports remain open:

| Protocol | Ports | Purpose |
|----------|-------|---------|
| TCP | 80, 443 | HTTP/HTTPS (Teams service, updates, auth) |
| UDP | 3478-3481 | STUN/TURN (media relay) |
| UDP | 50000-59999 | Media (audio, video, screen sharing) |
| TCP | 443 | WebSocket (real-time signaling) |

### MDE-Specific URLs

Ensure these endpoints are reachable for MDE telemetry and updates:

```
*.securitycenter.windows.com
*.security.microsoft.com
*.wdcp.microsoft.com
*.wd.microsoft.com
winatp-gw-*.microsoft.com
```

### Intune Firewall Policy

If managing firewall centrally:

1. **Intune Admin Center** > **Endpoint Security** > **Firewall**
2. Create policy for Windows
3. Configure:
   - Domain profile: **Enable**
   - Private profile: **Enable**
   - Public profile: **Enable**
4. Do **not** configure rules that would block the ports listed above
5. Assign to **MTR-Devices-Windows** group

## Monitoring in the Defender Portal

### Device Inventory

Access MTR device security status at **security.microsoft.com**:

1. Go to **Assets** > **Devices**
2. Filter by device name prefix (e.g., `MTR-`) or use device tags
3. For each device, review:
   - **Exposure score**: overall vulnerability level
   - **Active alerts**: security incidents
   - **Security recommendations**: configuration improvements
   - **Software inventory**: installed applications and versions
   - **Discovered vulnerabilities**: known CVEs affecting the device

### Device Tagging

Tag MTR devices for easier filtering and reporting:

1. In the Defender portal, open a device page
2. Click **Manage tags**
3. Add tag: `TeamsRooms` or `MTR`

Or via the API for bulk tagging:
```powershell
# Tag devices via Microsoft Graph Security API
# Requires SecurityEvents.ReadWrite.All permission
```

### Threat & Vulnerability Management (TVM)

TVM is one of the highest-value capabilities of MDE on Teams Rooms. It provides:
- **Missing security updates**: OS patches that haven't been applied
- **Vulnerable software versions**: known CVEs in installed applications
- **Configuration weaknesses**: settings that could be hardened
- **Exposure score trending**: track your security posture over time

Review TVM recommendations regularly and prioritize OS updates, which can be managed through Pro Management Portal update rings.

### Alert Notifications

Configure email alerts for MTR security events:

1. **Settings** > **Endpoints** > **Email notifications**
2. Create notification rule:
   - Name: `MTR Security Alerts`
   - Device group: Filter to MTR devices
   - Alert severity: **High** and **Critical**
   - Recipients: Security team distribution list

## Incident Response Considerations

### Device Isolation: Use with Extreme Caution

Device isolation is a nuclear option for MTR devices. Isolating a Teams Room device **immediately kills all meeting functionality** for that room. The device cannot join meetings, display the calendar, or receive calls until isolation is released.

**Before isolating an MTR device:**
1. Confirm the alert represents a genuine security incident, not a false positive
2. Consider whether the device is currently in an active meeting
3. Evaluate whether the threat can be contained by less disruptive means (antivirus scan, app restriction)
4. Notify facilities/AV teams that the room will be out of service

**Available response actions (in order of impact):**

| Action | Meeting Impact | When to Use |
|--------|---------------|-------------|
| Run antivirus scan | None | First response to most alerts |
| Collect investigation package | None | Gathering forensic data |
| Restrict app execution | Possible disruption | Confirmed malware, non-meeting-critical app |
| Isolate device | **Complete meeting outage** | Confirmed active breach only |

### Live Response

MDE Live Response allows remote shell access to MTR devices for investigation. This is useful for:
- Examining running processes
- Checking registry keys
- Reviewing event logs
- Collecting specific files for analysis

Access via the device page in the Defender portal > **Initiate live response session**.

## Troubleshooting

### Verify Onboarding Status

```powershell
# Check MDE onboarding state
$status = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows Advanced Threat Protection\Status"
Write-Host "Onboarding State: $($status.OnboardingState)"  # 1 = onboarded
Write-Host "Org ID: $($status.OrgId)"

# Verify Defender services are running
Get-Service -Name "Sense", "WinDefend", "WdNisSvc" | Format-Table Name, Status, StartType

# Test connectivity to MDE cloud
$connectivity = Test-NetConnection -ComputerName "winatp-gw-eus.microsoft.com" -Port 443
Write-Host "MDE Gateway Reachable: $($connectivity.TcpTestSucceeded)"

# Check real-time protection status
Get-MpComputerStatus | Select-Object RealTimeProtectionEnabled, AntivirusSignatureLastUpdated, QuickScanEndTime
```

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Device not onboarding | Firewall blocking MDE URLs | Allow `*.wdcp.microsoft.com` and `winatp-gw-*.microsoft.com` |
| High CPU during meetings | Full scan running during business hours | Set `ScanScheduleTime` to off-hours (2-4 AM) |
| Audio/video glitches | Real-time scanning of media processes | Add `ms-teams.exe` process exclusion |
| ASR blocking peripherals | ASR rules in Block mode | Switch all ASR rules to Audit mode |
| Device shows "inactive" in portal | Device offline or not sending telemetry | Verify network, restart Sense service |
| Onboarding succeeds but no data | Intune connector not configured | Enable MDE-Intune connector in both portals |

### Diagnostic Commands

```powershell
# Run MDE Client Analyzer (downloadable from Microsoft)
# Downloads and runs connectivity and health checks
.\MDEClientAnalyzer.cmd

# Check ASR rule audit events
Get-WinEvent -LogName "Microsoft-Windows-Windows Defender/Operational" |
    Where-Object { $_.Id -eq 1121 -or $_.Id -eq 1122 } |
    Select-Object TimeCreated, Message -First 20

# Verify signature update status
Get-MpComputerStatus | Select-Object AntivirusSignatureVersion, AntivirusSignatureLastUpdated

# Force a signature update
Update-MpSignature
```

## Best Practices Summary

1. **Deploy EDR via Intune** for consistent configuration across all MTR devices
2. **Schedule scans at 2 AM** or other off-hours to avoid meeting impact
3. **ASR rules in Audit mode only**: never Block mode on Teams Rooms
4. **Network Protection in Audit mode only**: Block mode can break meeting connectivity
5. **Monitor TVM recommendations**: highest-value capability for MTR security posture
6. **Use device tags** in the Defender portal for MTR-specific filtering and reporting
7. **Isolate devices only for confirmed breaches**: isolation kills all meeting functionality
8. **Add process exclusions selectively**: only when performance issues are documented
9. **Configure LAPS** for local admin password management (see [LAPS Configuration](laps-configuration.md))
10. **Review audit logs regularly**: ASR and Network Protection audit events reveal your threat landscape without disrupting operations

## Related Topics

- [LAPS Configuration](laps-configuration.md): Local admin password management
- [Device Compliance](device-compliance.md): Intune compliance policies
- [Conditional Access](conditional-access.md): Identity-based access controls
- [Windows Deployment](../05-deployment/windows-deployment.md): Initial device setup
- [Pro Management Portal](../10-pro-management/portal-overview.md): Update ring management
