# Emergency Calling for Teams Rooms

## Overview

Teams Rooms devices on both Windows and Android support dynamic emergency calling. When an emergency call (911/933) is placed, the emergency location is conveyed to the PSAP based on the device's detected network location.

## How Dynamic Location Detection Works

1. The tenant admin defines network topology: trusted IP addresses, network sites, and the Location Information Service (LIS) with subnets, WAPs, switches, and ports mapped to emergency addresses
2. The Teams Rooms client sends network connectivity information to the LIS during startup, periodically, and on network change
3. If a match is found, the LIS returns an emergency location to the client
4. When an emergency call is placed, the location is conveyed in the call to the PSAP

## Location Detection Methods

| Method | Windows | Android |
|--------|---------|---------|
| Subnet | Yes | Yes |
| WiFi (BSSID) | Yes | Yes |
| Ethernet/Switch (LLDP) | Yes | Yes (OEM-specific config may be required) |

## Configuration

### Define Network Topology

```powershell
# Trusted IP addresses
New-CsTenantTrustedIPAddress -IPAddress "203.0.113.0" -MaskBits 24 `
    -Description "Seattle Office"

# Network regions
New-CsTenantNetworkRegion -Identity "USWest" -Description "US West Region"

# Network sites
New-CsTenantNetworkSite -Identity "SeattleOffice" `
    -NetworkRegionID "USWest" -Description "Seattle HQ"

# Network subnets
New-CsTenantNetworkSubnet -SubnetID "10.10.10.0" `
    -MaskBits 24 -NetworkSiteID "SeattleOffice"
```

### Populate LIS with Emergency Locations

```powershell
# Map a subnet
Set-CsOnlineLisSubnet -Subnet "10.10.10.0" `
    -LocationId "<LocationGUID>" -Description "Seattle Office Floor 3"

# Map a WAP
Set-CsOnlineLisWirelessAccessPoint -BSSID "AA:BB:CC:DD:EE:FF" `
    -LocationId "<LocationGUID>" -Description "Seattle Floor 3 WAP"

# Map a switch
Set-CsOnlineLisSwitch -ChassisID "AB:CD:EF:01:23:45" `
    -LocationId "<LocationGUID>" -Description "Seattle Floor 3 Switch"

# Map a switch port (most granular — per room)
Set-CsOnlineLisPort -ChassisID "AB:CD:EF:01:23:45" -PortID "Gi1/0/1" `
    -LocationId "<LocationGUID>" -Description "Conf Room 301"
```

### Configure Emergency Calling Policy (Security Desk Notification)

```powershell
New-CsTeamsEmergencyCallingPolicy -Identity "SeattleEmergencyPolicy" `
    -NotificationMode "ConferenceUnMuted" `
    -NotificationGroup "security-desk@contoso.com"

Grant-CsTeamsEmergencyCallingPolicy -Identity "confroom01@contoso.com" `
    -PolicyName "SeattleEmergencyPolicy"
```

### Configure Emergency Call Routing (Direct Routing Only)

```powershell
New-CsTeamsEmergencyCallRoutingPolicy -Identity "USEmergencyRouting" `
    -EmergencyNumbers @{
        add = New-CsTeamsEmergencyNumber -EmergencyDialString "911" `
            -EmergencyDialMask "911" `
            -OnlinePstnUsage "EmergencyUsage"
    }

Grant-CsTeamsEmergencyCallRoutingPolicy -Identity "confroom01@contoso.com" `
    -PolicyName "USEmergencyRouting"

# Enable PIDF/LO on SBC (Direct Routing)
Set-CsOnlinePSTNGateway -Identity "sbc1.contoso.com" -PidfLoSupported $true
```

## Testing

Use the test emergency number **933** (for Calling Plan, Operator Connect, and Teams Phone Mobile users in US/Canada). This routes to a bot that echoes back the caller's phone number, emergency address/location, and whether the call would route to PSAP or be screened.

Direct Routing customers should coordinate with their Emergency Routing Service (ERS) provider for testing.

## Related Topics

- [PSTN Overview](pstn-overview.md) — Connectivity options and phone number assignment
- [Calling Policies](calling-policies.md) — Calling policy configuration
- [End-to-End Setup](end-to-end-setup.md) — Emergency policy assignment in full workflow

## References

- [Configure dynamic emergency calling](https://learn.microsoft.com/en-us/microsoftteams/configure-dynamic-emergency-calling)
- [Plan and manage emergency calling](https://learn.microsoft.com/en-us/microsoftteams/what-are-emergency-locations-addresses-and-call-routing)
