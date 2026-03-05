# Resource Account Creation

## Overview

Microsoft Teams Rooms requires a resource account (room mailbox) for each device. This account represents the meeting room in Exchange and Teams, allowing users to book the room and enabling the MTR device to join meetings.

## Resource Account Components

Each MTR resource account consists of:

1. **Exchange Room Mailbox** - Stores calendar and meeting information
2. **Entra ID User Account** - Provides identity for Teams sign-in
3. **Teams Rooms License** - Enables Teams functionality
4. **Password** - Device uses to sign in (not user-interactive)

## Naming Conventions

### Recommended Naming Standards

| Component | Format | Example |
|-----------|--------|---------|
| Display Name | `Building-Room Description` | `HQ-Conf-Room-101` |
| UPN | `mtr-location-room@domain.com` | `mtr-hq-101@contoso.com` |
| Email/Alias | Same as UPN prefix | `mtr-hq-101` |

### Best Practices

- Use consistent prefix (e.g., `mtr-`) for easy identification
- Include location and room identifiers
- Avoid spaces and special characters
- Keep names under 64 characters

## Creating Resource Accounts

### Prerequisites

Required PowerShell modules:
```powershell
# Install required modules
Install-Module Microsoft.Graph -Scope CurrentUser
Install-Module ExchangeOnlineManagement -Scope CurrentUser
Install-Module MicrosoftTeams -Scope CurrentUser
```

Required permissions:
- Exchange Administrator or higher
- Teams Administrator
- User Administrator (for password management)

### Method 1: Exchange Admin Center (Single Room)

1. Navigate to **Exchange Admin Center** > **Recipients** > **Resources**
2. Click **+ Add a room mailbox**
3. Fill in:
   - Display name: `HQ-Conference-Room-101`
   - Email address: `mtr-hq-101`
   - Domain: Select from dropdown
4. Click **Save**
5. Enable the room mailbox account in Entra ID and assign license separately

> **Note:** Resource accounts are Exchange room mailboxes. They are created and managed in the Exchange Admin Center. Teams policies are configured in the Teams Admin Center, and Windows MTR device management is in the Pro Management Portal (portal.rooms.microsoft.com).

### Method 2: PowerShell (Single Room)

```powershell
# Connect to services
Connect-ExchangeOnline
Connect-MgGraph -Scopes "User.ReadWrite.All"

# Set variables
$roomName = "HQ-Conference-Room-101"
$roomUPN = "mtr-hq-101@contoso.com"
$roomPassword = ConvertTo-SecureString -String "ComplexPassword123!" -AsPlainText -Force

# Create the room mailbox
New-Mailbox -Name $roomName `
            -Room `
            -Alias ($roomUPN -split '@')[0] `
            -EnableRoomMailboxAccount $true `
            -RoomMailboxPassword $roomPassword

# Wait for Entra ID sync (may take several minutes)
Start-Sleep -Seconds 60

# Set password to not expire
$userId = (Get-MgUser -Filter "userPrincipalName eq '$roomUPN'").Id
Update-MgUser -UserId $userId -PasswordPolicies "DisablePasswordExpiration"

# Add to security group
$groupId = (Get-MgGroup -Filter "displayName eq 'MTR-ResourceAccounts-All'").Id
New-MgGroupMember -GroupId $groupId -DirectoryObjectId $userId
```

### Method 3: Bulk Creation (CSV)

For multiple rooms, use a CSV file with the bulk creation script.

**CSV Format:**
```csv
DisplayName,UserPrincipalName,Password,Location,Building
HQ-Conf-101,mtr-hq-101@contoso.com,TempPass123!,Headquarters,Building A
HQ-Conf-102,mtr-hq-102@contoso.com,TempPass123!,Headquarters,Building A
Branch-Conf-201,mtr-branch-201@contoso.com,TempPass123!,Branch Office,Main
```

See [New-MTRResourceAccountsBulk.ps1](../../scripts/accounts/New-MTRResourceAccountsBulk.ps1) for the bulk creation script.

## Calendar Processing Settings

After creating the room mailbox, configure calendar processing:

```powershell
# Configure calendar processing
Set-CalendarProcessing -Identity "mtr-hq-101@contoso.com" `
    -AutomateProcessing AutoAccept `
    -AddOrganizerToSubject $false `
    -AllowConflicts $false `
    -DeleteAttachments $true `
    -DeleteComments $false `
    -DeleteNonCalendarItems $true `
    -DeleteSubject $false `
    -ProcessExternalMeetingMessages $true `
    -RemovePrivateProperty $false `
    -AddAdditionalResponse $true `
    -AdditionalResponse "This is a Microsoft Teams Meeting Room. Please use the room's Teams device for your meeting."
```

### Key Settings Explained

| Setting | Value | Purpose |
|---------|-------|---------|
| `AutomateProcessing` | AutoAccept | Automatically accept meeting requests |
| `AddOrganizerToSubject` | $false | Preserve original meeting subject |
| `DeleteAttachments` | $true | Remove attachments for cleanliness |
| `DeleteSubject` | $false | Keep meeting subject visible |
| `ProcessExternalMeetingMessages` | $true | Accept external meeting invites |

## Password Management

### Password Requirements

- Complex password (meets Entra ID policy)
- Set to never expire (PasswordPolicies: DisablePasswordExpiration)
- Store securely (Azure Key Vault, password manager)
- Document for device setup

### Setting Password to Not Expire

```powershell
# Using Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All"
$user = Get-MgUser -Filter "userPrincipalName eq 'mtr-hq-101@contoso.com'"
Update-MgUser -UserId $user.Id -PasswordPolicies "DisablePasswordExpiration"
```

## Verification

After creating resource accounts, verify configuration:

```powershell
# Verify mailbox exists
Get-Mailbox -Identity "mtr-hq-101@contoso.com" | Select Name, RecipientTypeDetails

# Verify calendar processing
Get-CalendarProcessing -Identity "mtr-hq-101@contoso.com" | Select AutomateProcessing, ProcessExternalMeetingMessages

# Verify account enabled
Get-MgUser -Filter "userPrincipalName eq 'mtr-hq-101@contoso.com'" | Select UserPrincipalName, AccountEnabled

# Verify password policy
Get-MgUser -Filter "userPrincipalName eq 'mtr-hq-101@contoso.com'" -Property PasswordPolicies | Select PasswordPolicies
```

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Mailbox not showing in Teams | Sync delay | Wait 15-30 minutes |
| Cannot sign in on device | Account disabled | Enable account in Entra ID |
| Password expired | Policy not set | Set DisablePasswordExpiration |
| Double-booking | Calendar processing | Set AllowConflicts to $false |

### Sync Delays

Resource accounts may take 15-60 minutes to fully propagate across:
- Exchange Online
- Entra ID
- Microsoft Teams
- Intune

## Related Topics

- [Bulk Account Creation Script](../../scripts/accounts/New-MTRResourceAccountsBulk.ps1)
- [Licensing Assignment](licensing-assignment.md)
- [Exchange Configuration](exchange-configuration.md)
- [Calendar Processing Script](../../scripts/accounts/Set-MTRCalendarProcessing.ps1)
