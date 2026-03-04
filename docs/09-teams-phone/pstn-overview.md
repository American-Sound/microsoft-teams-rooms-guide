# Teams Phone and PSTN Calling for Teams Rooms

## Overview

Teams Rooms devices on both Windows and Android can make and receive PSTN calls. The Teams Rooms Pro license includes the **Teams Phone Standard** service plan, which provides PBX-level calling capabilities. Teams Rooms Basic does not include Teams Phone Standard — it only supports peer-to-peer and group Teams calls.

When PSTN calling is configured, a dial pad is available on the touch console, allowing room occupants to dial PSTN numbers directly. Incoming PSTN calls ring on the device and can be answered from the console.

## Licensing

### Teams Rooms License Comparison

| Feature | Teams Rooms Basic | Teams Rooms Pro |
|---------|-------------------|-----------------|
| Teams Phone Standard | Not included | **Included** |
| Audio Conferencing | Included | Included |
| Intune | Not included | Included |
| Entra ID P1 | Not included | Included |
| Defender for Endpoint P2 | Not included | Included |

### What's Needed for PSTN Calling

1. **Teams Rooms Pro license** on the resource account (provides Teams Phone Standard)
2. **A PSTN connectivity option** — one of:
   - Microsoft Calling Plan license (Domestic or International)
   - Operator Connect number
   - Direct Routing phone number
   - Shared Calling (uses a shared number via auto attendant)
3. **A phone number assigned** to the resource account (except Shared Calling, where the room uses the shared number)

> **Important:** Do not use Teams Phone Resource Account licenses for rooms. Those are for auto attendant and call queue resource accounts only.

> **Important (November 2025):** Calling Plan licenses on resource accounts no longer support On-Behalf-Of PSTN outbound calls. A funded Pay-As-You-Go license or Communications Credits is required for resource accounts making outbound PSTN calls via Calling Plans.

## PSTN Connectivity Options

### Microsoft Calling Plans

Microsoft acts as the PSTN carrier. Simplest option — no infrastructure to manage.

- Requires a Calling Plan license (Domestic, International, or Pay-As-You-Go) assigned to the resource account
- Phone numbers acquired through Microsoft via Teams Admin Center
- Emergency address management handled by Microsoft

### Operator Connect

Third-party certified operator provides PSTN connectivity.

- Requires a contract with a participating Operator Connect partner
- Numbers provisioned by the operator, appear in Teams Admin Center for assignment
- No infrastructure to manage (operator handles SBC/trunks)

### Direct Routing

Any PSTN operator, connected via a certified Session Border Controller (SBC).

- Most flexible option — works in any country/region, supports interop with third-party PBXs, overhead pagers, analog devices
- Requires SBC with valid TLS certificate, DNS/FQDN configuration, and PSTN trunk
- Requires voice routing policy configuration
- Supports Survivable Branch Appliance (SBA) for local PSTN survivability during cloud outages

### Shared Calling

Cost-effective approach where the room makes/receives calls through a shared phone number owned by an auto attendant resource account.

- Room resource account needs only Teams Rooms Pro (no individual Calling Plan license)
- Outbound caller ID shows the shared number
- Configured via a Shared Calling policy

## Configuration — PowerShell

### Assign a Phone Number

```powershell
# Calling Plan
Set-CsPhoneNumberAssignment -Identity "confroom01@contoso.com" `
    -PhoneNumber "+12065551234" `
    -PhoneNumberType CallingPlan

# Direct Routing
Set-CsPhoneNumberAssignment -Identity "confroom01@contoso.com" `
    -PhoneNumber "+12065551234" `
    -PhoneNumberType DirectRouting

# Direct Routing with extension
Set-CsPhoneNumberAssignment -Identity "confroom01@contoso.com" `
    -PhoneNumber "+12065551000;ext=1234" `
    -PhoneNumberType DirectRouting

# Operator Connect
Set-CsPhoneNumberAssignment -Identity "confroom01@contoso.com" `
    -PhoneNumber "+12065551234" `
    -PhoneNumberType OperatorConnect

# With emergency location
$loc = Get-CsOnlineLisLocation -City "Seattle"
Set-CsPhoneNumberAssignment -Identity "confroom01@contoso.com" `
    -PhoneNumber "+12065551234" `
    -PhoneNumberType CallingPlan `
    -LocationId $loc.LocationId
```

When you assign a phone number, `EnterpriseVoiceEnabled` is automatically set to `$true`.

### Assign Policies

```powershell
# Voice routing policy (Direct Routing only)
Grant-CsOnlineVoiceRoutingPolicy -Identity "confroom01@contoso.com" `
    -PolicyName "US-Seattle-VoiceRoutingPolicy"

# Dial plan
Grant-CsTenantDialPlan -Identity "confroom01@contoso.com" `
    -PolicyName "US-DialPlan"

# Calling policy (custom for rooms)
Grant-CsTeamsCallingPolicy -Identity "confroom01@contoso.com" `
    -PolicyName "TeamsRoomCallingPolicy"

# Caller ID policy
Grant-CsCallingLineIdentity -Identity "confroom01@contoso.com" `
    -PolicyName "RoomCallerIdPolicy"
```

### Verify Configuration

```powershell
Get-CsOnlineUser -Identity "confroom01@contoso.com" | fl `
    DisplayName, LineUri, EnterpriseVoiceEnabled, `
    OnlineVoiceRoutingPolicy, TeamsCallingPolicy, `
    TenantDialPlan, CallingLineIdentity
```

## SIP Gateway

SIP Gateway is a separate feature for **legacy SIP desk phones** (Cisco, Poly, Yealink, AudioCodes). It is not used for Teams Rooms devices, which connect natively to Teams. SIP Gateway exists to preserve investments in legacy SIP desk phones by enabling basic Teams calling on those devices.

If a conference room has an analog phone or traditional SIP desk phone alongside the Teams Room (e.g., a wall-mounted courtesy phone for emergency calling), that device could use SIP Gateway via an ATA.

## Related Topics

- [Calling Policies](calling-policies.md) — Recommended calling policy settings for rooms
- [Emergency Calling](emergency-calling.md) — E911, LIS configuration, compliance
- [Audio Conferencing](audio-conferencing.md) — Dial-in conferencing setup
- [End-to-End Setup](end-to-end-setup.md) — Complete PowerShell walkthrough
- [Phone Number Script](../../scripts/teams-phone/Set-MTRPhoneNumber.ps1) — Automated phone assignment
- [Resource Accounts](../02-prerequisites/resource-accounts.md) — Account creation and licensing

## References

- [Microsoft Teams Rooms licenses](https://learn.microsoft.com/en-us/microsoftteams/rooms/rooms-licensing)
- [PSTN connectivity options](https://learn.microsoft.com/en-us/microsoftteams/pstn-connectivity)
- [Set-CsPhoneNumberAssignment](https://learn.microsoft.com/en-us/powershell/module/microsoftteams/set-csphonenumberassignment)
- [Enable users for Direct Routing](https://learn.microsoft.com/en-us/microsoftteams/direct-routing-enable-users)
- [Plan for Shared Calling](https://learn.microsoft.com/en-us/microsoftteams/shared-calling-plan)
