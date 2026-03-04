# PowerShell Scripts for Microsoft Teams Rooms

## Overview

This directory contains PowerShell scripts for managing Microsoft Teams Rooms deployments. All scripts use modern Microsoft Graph PowerShell SDK and follow PowerShell best practices.

## Prerequisites

### Required PowerShell Modules

```powershell
# Install required modules
Install-Module Microsoft.Graph -Scope CurrentUser
Install-Module ExchangeOnlineManagement -Scope CurrentUser
Install-Module MicrosoftTeams -Scope CurrentUser
```

### Required Permissions

Scripts require appropriate admin permissions:
- **User Administrator** - For creating/managing resource accounts
- **Exchange Administrator** - For mailbox and calendar configuration
- **Teams Administrator** - For Teams-specific settings
- **Intune Administrator** - For device management scripts
- **Security Administrator** - For Conditional Access scripts

### Connecting to Services

Before running scripts, connect to required services:

```powershell
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"

# Connect to Exchange Online
Connect-ExchangeOnline

# Connect to Microsoft Teams
Connect-MicrosoftTeams
```

## Script Categories

### accounts/

Scripts for creating and managing resource accounts:
- `New-MTRResourceAccount.ps1` - Create single resource account
- `New-MTRResourceAccountsBulk.ps1` - Bulk create from CSV
- `Set-MTRCalendarProcessing.ps1` - Configure calendar settings
- `Get-MTRAccountStatus.ps1` - Audit account configuration

### licensing/

Scripts for license management:
- `Get-MTRLicenseStatus.ps1` - Report license assignments
- `Set-MTRLicense.ps1` - Assign licenses
- `Get-AvailableMTRLicenses.ps1` - Check license inventory

### entra-conditional-access/

Scripts for Conditional Access management:
- `New-MTRConditionalAccessPolicy.ps1` - Create CA policy
- `Get-MTRConditionalAccessStatus.ps1` - Audit CA coverage
- `Export-ConditionalAccessPolicies.ps1` - Backup policies

### intune/

Scripts for Intune management:
- `New-MTRAutopilotProfile.ps1` - Create Autopilot profile
- `Import-AutopilotDevices.ps1` - Import hardware IDs
- `New-MTRCompliancePolicy.ps1` - Create compliance policy
- `Get-MTRDeviceEnrollmentStatus.ps1` - Check enrollment
- `Set-MTRAutoLogin.ps1` - Configure resource account sign-in via SkypeSettings.xml (supports Azure Key Vault)

### interop/

Scripts for video interoperability:
- `Set-MTRCviPolicy.ps1` - Register CVI providers and assign policies

### copilot-ai/

Scripts for AI and Copilot configuration:
- `Set-MTRAIPolicy.ps1` - Configure AI policies and Copilot for rooms

### teams-phone/

Scripts for PSTN calling configuration:
- `Set-MTRPhoneNumber.ps1` - Assign phone numbers and calling policies

### teams-policies/

Scripts for Teams policy configuration:
- `Set-MTRTeamsPolicy.ps1` - Configure meeting policies

### validation/

Scripts for validation and reporting:
- `Test-MTRPrerequisites.ps1` - Pre-deployment checks
- `Test-MTRAccountConfiguration.ps1` - Validate account setup
- `Get-MTRDeploymentReport.ps1` - Generate status report

## Usage

### Getting Help

Each script includes comment-based help:

```powershell
Get-Help .\New-MTRResourceAccount.ps1 -Full
```

### Common Parameters

Most scripts support:
- `-WhatIf` - Preview changes without applying
- `-Confirm` - Prompt before changes
- `-Verbose` - Detailed output

### Examples

```powershell
# Create single resource account
.\New-MTRResourceAccount.ps1 -DisplayName "HQ-Conf-101" -UserPrincipalName "mtr-hq-101@contoso.com"

# Bulk create from CSV
.\New-MTRResourceAccountsBulk.ps1 -CsvPath ".\rooms.csv" -WhatIf

# Check account configuration
.\Get-MTRAccountStatus.ps1 -UserPrincipalName "mtr-hq-101@contoso.com"

# Generate deployment report
.\Get-MTRDeploymentReport.ps1 -OutputPath ".\report.html"
```

## Best Practices

1. **Always test with -WhatIf** before running for real
2. **Run in non-production** environment first
3. **Review output** before confirming changes
4. **Keep scripts updated** with latest module versions
5. **Store credentials securely** - Never hardcode passwords

## Troubleshooting

### Common Issues

| Error | Cause | Solution |
|-------|-------|----------|
| "Unauthorized" | Missing permissions | Verify admin roles |
| "Module not found" | Module not installed | Run Install-Module |
| "Not connected" | Missing connection | Run Connect-MgGraph |
| "User not found" | Sync delay | Wait for Entra ID sync |

### Logging

Most scripts support `-Verbose` for detailed output:

```powershell
.\New-MTRResourceAccount.ps1 -DisplayName "Test" -UPN "test@contoso.com" -Verbose
```

## Contributing

See [CONTRIBUTING.md](../CONTRIBUTING.md) for contribution guidelines.
