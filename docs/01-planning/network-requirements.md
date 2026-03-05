# Network Requirements

## Overview

Microsoft Teams Rooms requires reliable network connectivity for optimal meeting experiences. This guide covers bandwidth, ports, firewall rules, and network configuration requirements.

## Bandwidth Requirements

### Minimum Bandwidth

| Scenario | Download | Upload |
|----------|----------|--------|
| Audio only | 60 Kbps | 60 Kbps |
| Audio + screen sharing | 250 Kbps | 250 Kbps |
| Audio + 360p video | 500 Kbps | 500 Kbps |
| Audio + 720p HD video | 1.5 Mbps | 1.5 Mbps |
| Audio + 1080p HD video | 3 Mbps | 3 Mbps |
| Gallery view (multiple participants) | 4 Mbps | 4 Mbps |

### Recommended Bandwidth per Room

- **Minimum:** 10 Mbps dedicated
- **Recommended:** 20-50 Mbps dedicated
- **Large rooms with content sharing:** 50+ Mbps

### Total Capacity Planning

Calculate total bandwidth needs:
```
Total = (Number of Rooms) × (Bandwidth per Room) × (Concurrency Factor)
```

Example: 20 rooms × 20 Mbps × 0.5 concurrency = 200 Mbps dedicated capacity

## Required Ports and Protocols

### Microsoft 365 and Teams

| Protocol | Port | Purpose |
|----------|------|---------|
| TCP | 80 | HTTP communication |
| TCP | 443 | HTTPS/TLS communication |
| UDP | 3478-3481 | STUN/TURN for media |
| UDP | 49152-65535 | Media ports (preferred) |
| TCP | 443 | Media fallback (if UDP blocked) |

### Media Traffic (Critical)

Teams media flows should use UDP for optimal quality:

| Traffic Type | Protocol | Ports | DSCP Marking |
|--------------|----------|-------|--------------|
| Audio | UDP | 50000-50019 | 46 (EF) |
| Video | UDP | 50020-50039 | 34 (AF41) |
| Screen Share | UDP | 50040-50059 | 18 (AF21) |

> **Important:** If UDP is blocked, Teams will fall back to TCP/443, resulting in degraded quality and higher latency.

### Additional Services

| Service | Ports | Purpose |
|---------|-------|---------|
| Intune | TCP 443 | Device management |
| Windows Update | TCP 80, 443 | OS updates |
| Microsoft Store | TCP 443 | App updates |
| Entra ID | TCP 443 | Authentication |

## Firewall Requirements

### Required Endpoints

Teams Rooms must be able to reach these Microsoft endpoints:

**Teams Service:**
```
*.teams.microsoft.com
*.skype.com
*.skypeforbusiness.com
teams.microsoft.com
```

**Authentication:**
```
login.microsoftonline.com
login.windows.net
*.login.microsoftonline.com
aadcdn.msftauth.net
```

**Microsoft 365 Common:**
```
*.office.com
*.office365.com
*.microsoft.com
*.msftidentity.com
```

**Media Relay:**
```
*.lync.com
*.tr.teams.microsoft.com
*.relay.teams.microsoft.com
```

**Updates:**
```
*.windowsupdate.com
*.update.microsoft.com
*.delivery.mp.microsoft.com
```

### IP Ranges

Microsoft publishes IP ranges for Microsoft 365 services:

- [Office 365 URLs and IP Ranges](https://learn.microsoft.com/microsoft-365/enterprise/urls-and-ip-address-ranges)
- Service Area: "Microsoft Teams"
- Update frequency: Monthly

> **Recommendation:** Use FQDNs rather than IP addresses where possible, as IPs may change.

## Network Configuration

### VLAN Design

**Recommended:** Place MTR devices on a dedicated Voice/Video VLAN

**Benefits:**
- QoS policy application
- Security isolation
- Traffic monitoring
- Troubleshooting simplicity

**Example VLAN Design:**
```
VLAN 10  - Corporate Data
VLAN 20  - Voice/Video (MTR devices)
VLAN 30  - Guest
```

### QoS Configuration

Quality of Service ensures media traffic priority:

**DSCP Markings:**
| Traffic | DSCP Value | Per-Hop Behavior |
|---------|------------|------------------|
| Audio | 46 | EF (Expedited Forwarding) |
| Video | 34 | AF41 |
| Signaling | 24 | CS3 |
| Screen Share | 18 | AF21 |

**Switch Configuration Example (Cisco):**
```
mls qos
interface GigabitEthernet1/0/1
  description MTR-ConferenceRoom
  mls qos trust dscp
  switchport access vlan 20
```

### DNS Requirements

- Internal DNS must resolve Microsoft 365 endpoints
- Split-brain DNS considerations for hybrid environments
- DNS response time < 100ms recommended

### Proxy Considerations

**Best Practice:** Bypass proxy for Teams media traffic

**If proxy required:**
- Ensure proxy supports WebSocket
- Configure PAC file exceptions for Teams
- Test thoroughly before deployment
- Monitor for latency issues

**Proxy Bypass URLs:**
```
*.teams.microsoft.com
*.skype.com
13.107.64.0/18
52.112.0.0/14
```

## Wired vs. Wireless

### Wired (Recommended)

**Advantages:**
- Consistent bandwidth
- Lower latency
- No interference
- More reliable

**Requirements:**
- Gigabit Ethernet
- PoE for touch consoles (802.3at)
- Quality cabling (Cat6 minimum)

### Wireless (Not Recommended for Primary)

**Limitations:**
- Variable bandwidth
- Potential interference
- Higher latency
- Shared medium

**If Wireless Required:**
- Use 5 GHz only
- Wi-Fi 6 (802.11ax) preferred
- Ensure strong signal (-65 dBm or better)
- Dedicated SSID optional

## Network Testing

### Pre-Deployment Testing

1. **Bandwidth Test**
   - Verify available bandwidth
   - Test during peak hours
   - Use Microsoft Network Assessment Tool

2. **Port Connectivity**
   - Test UDP 3478-3481
   - Verify no port blocking
   - Test from actual MTR location

3. **Endpoint Reachability**
   - Test connectivity to Teams endpoints
   - Verify DNS resolution
   - Check certificate validation

### Microsoft Network Assessment Tool

Download and run from MTR device:
```powershell
# Download
Invoke-WebRequest -Uri "https://www.microsoft.com/download/details.aspx?id=53885" -OutFile NetworkAssessmentTool.msi

# Run assessment
.\NetworkAssessmentmentTool.exe
```

### Ongoing Monitoring

- Monitor network utilization
- Track call quality metrics
- Review Teams Admin Center call analytics
- Set up alerts for degradation

## Troubleshooting Network Issues

### Common Issues

| Symptom | Possible Cause | Solution |
|---------|---------------|----------|
| Poor audio quality | UDP blocked | Open UDP ports 3478-3481 |
| Video freezing | Insufficient bandwidth | Increase bandwidth allocation |
| Call drops | Network instability | Check switch/cabling |
| Sign-in failures | Firewall blocking | Verify endpoint access |
| Delayed join | Proxy latency | Bypass proxy for Teams |

### Diagnostic Tools

- **Teams Admin Center** - Call quality dashboard
- **Windows Network Diagnostics** - Built-in troubleshooting
- **Wireshark** - Packet capture analysis
- **MTR/Traceroute** - Path analysis

## Related Topics

- [Hardware Requirements](hardware-requirements.md)
- [Troubleshooting](../06-post-deployment/troubleshooting.md)
- [Monitoring and Alerting](../06-post-deployment/monitoring-alerting.md)
