# End-to-End Teams Phone Setup for a Room

## Complete Configuration Example (Direct Routing)

```powershell
# 1. Connect to required PowerShell modules
Connect-ExchangeOnline
Connect-MicrosoftTeams
Connect-MgGraph -Scopes "User.ReadWrite.All"

# 2. Create the room mailbox (if not already created)
New-Mailbox -MicrosoftOnlineServicesID confroom301@contoso.com `
    -Name "Conference Room 301" `
    -Alias confroom301 `
    -Room `
    -EnableRoomMailboxAccount $true `
    -RoomMailboxPassword (ConvertTo-SecureString -String 'P@ssw0rd!' -AsPlainText -Force)

# 3. Configure calendar processing
Set-CalendarProcessing -Identity "confroom301" `
    -AutomateProcessing AutoAccept `
    -AddOrganizerToSubject $false `
    -DeleteAttachments $true `
    -DeleteComments $false `
    -DeleteSubject $false `
    -ProcessExternalMeetingMessages $true `
    -RemovePrivateProperty $false `
    -AddAdditionalResponse $true `
    -AdditionalResponse "This is a Microsoft Teams Meeting room."

# 4. Set password to never expire
Update-MgUser -UserId confroom301@contoso.com `
    -PasswordPolicies DisablePasswordExpiration -PassThru

# 5. Assign Teams Rooms Pro license
# (Use M365 Admin Center > Users > Active users > Licenses and apps)

# 6. Assign Direct Routing phone number
Set-CsPhoneNumberAssignment -Identity "confroom301@contoso.com" `
    -PhoneNumber "+12065551301" `
    -PhoneNumberType DirectRouting

# 7. Assign voice routing policy
Grant-CsOnlineVoiceRoutingPolicy -Identity "confroom301@contoso.com" `
    -PolicyName "US-VoiceRoutingPolicy"

# 8. Assign dial plan
Grant-CsTenantDialPlan -Identity "confroom301@contoso.com" `
    -PolicyName "US-SeattleDialPlan"

# 9. Assign calling policy (custom for rooms)
Grant-CsTeamsCallingPolicy -Identity "confroom301@contoso.com" `
    -PolicyName "TeamsRoomCallingPolicy"

# 10. Assign caller ID policy
Grant-CsCallingLineIdentity -Identity "confroom301@contoso.com" `
    -PolicyName "RoomCallerIdPolicy"

# 11. Assign emergency calling policy
Grant-CsTeamsEmergencyCallingPolicy -Identity "confroom301@contoso.com" `
    -PolicyName "SeattleEmergencyPolicy"

# 12. Assign emergency call routing policy (Direct Routing)
Grant-CsTeamsEmergencyCallRoutingPolicy -Identity "confroom301@contoso.com" `
    -PolicyName "USEmergencyRouting"

# 13. Verify configuration
Get-CsOnlineUser -Identity "confroom301@contoso.com" | fl `
    DisplayName, LineUri, EnterpriseVoiceEnabled, `
    OnlineVoiceRoutingPolicy, TeamsCallingPolicy, `
    TenantDialPlan, CallingLineIdentity
```

## Complete Configuration Example (Calling Plan)

```powershell
# After creating room and assigning Teams Rooms Pro license...

# Assign Calling Plan license
# (M365 Admin Center > Users > Active users > Licenses and apps)

# Assign phone number with emergency location
$loc = Get-CsOnlineLisLocation -City "Seattle"
Set-CsPhoneNumberAssignment -Identity "confroom301@contoso.com" `
    -PhoneNumber "+12065551301" `
    -PhoneNumberType CallingPlan `
    -LocationId $loc.LocationId

# Assign calling policy
Grant-CsTeamsCallingPolicy -Identity "confroom301@contoso.com" `
    -PolicyName "TeamsRoomCallingPolicy"

# Assign emergency calling policy
Grant-CsTeamsEmergencyCallingPolicy -Identity "confroom301@contoso.com" `
    -PolicyName "SeattleEmergencyPolicy"

# Verify
Get-CsOnlineUser -Identity "confroom301@contoso.com" | fl `
    DisplayName, LineUri, EnterpriseVoiceEnabled
```

## Related Topics

- [PSTN Overview](pstn-overview.md) — Connectivity options, licensing, SIP Gateway
- [Calling Policies](calling-policies.md) — Detailed policy parameter reference
- [Emergency Calling](emergency-calling.md) — LIS and emergency policy details
- [Resource Accounts](../02-prerequisites/resource-accounts.md) — Account creation prerequisites

## References

- [Create and configure resource accounts for Teams Rooms](https://learn.microsoft.com/en-us/microsoftteams/rooms/create-resource-account)
- [Teams Rooms home screen and admin controls](https://learn.microsoft.com/en-us/microsoftteams/rooms/mtr-home-refresh)
