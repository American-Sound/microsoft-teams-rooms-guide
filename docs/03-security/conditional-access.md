# Conditional Access for Microsoft Teams Rooms

## Overview

Conditional Access (CA) policies control how and when users and devices can access Microsoft 365 resources. Teams Rooms devices require special consideration because they sign in as service accounts without interactive user authentication.

## The Challenge

Standard CA policies designed for users often block MTR sign-in because:

1. **No interactive MFA** - MTR devices cannot complete interactive MFA prompts
2. **Device compliance** - MTR devices may not meet standard user device compliance
3. **Sign-in frequency** - Frequent re-authentication disrupts meeting rooms
4. **Location-based policies** - Room devices have fixed locations

## Recommended Strategy

### Strategy Overview

1. **Exclude MTR accounts** from standard user CA policies
2. **Create MTR-specific policies** tailored for room devices
3. **Use device compliance** instead of MFA where possible
4. **Use named locations** for trusted networks

### Exclusion Group

Create a security group to exclude MTR accounts from user-targeted policies:

```powershell
# Create exclusion group
Connect-MgGraph -Scopes "Group.ReadWrite.All"

$groupParams = @{
    DisplayName = "MTR-CA-Exclude"
    Description = "Teams Rooms accounts excluded from standard CA policies"
    MailEnabled = $false
    MailNickname = "mtr-ca-exclude"
    SecurityEnabled = $true
}
$exclusionGroup = New-MgGroup @groupParams

# Add MTR accounts to exclusion group
$mtrAccounts = Get-MgUser -Filter "startswith(userPrincipalName, 'mtr-')"
foreach ($account in $mtrAccounts) {
    New-MgGroupMember -GroupId $exclusionGroup.Id -DirectoryObjectId $account.Id
}
```

## Updating Existing Policies

### Step 1: Audit Current Policies

Identify policies that may block MTR sign-in:

```powershell
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Policy.Read.All"

# Get all CA policies
$policies = Get-MgIdentityConditionalAccessPolicy

# Check for policies targeting all users
$policies | Where-Object {
    $_.Conditions.Users.IncludeUsers -contains "All"
} | Select DisplayName, State
```

### Step 2: Add Exclusions

For each policy targeting "All Users", add the MTR exclusion group:

**Via Entra Admin Center:**
1. Navigate to **Entra Admin Center** > **Protection** > **Conditional Access**
2. Select the policy to modify
3. Under **Users** > **Exclude**, add `MTR-CA-Exclude` group
4. Save the policy

**Via PowerShell:**
```powershell
$policyId = "policy-id-here"
$exclusionGroupId = (Get-MgGroup -Filter "displayName eq 'MTR-CA-Exclude'").Id

# Get current policy
$policy = Get-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $policyId

# Update exclusions (preserve existing)
$currentExclusions = $policy.Conditions.Users.ExcludeGroups
$newExclusions = $currentExclusions + $exclusionGroupId

$params = @{
    Conditions = @{
        Users = @{
            ExcludeGroups = $newExclusions
        }
    }
}

Update-MgIdentityConditionalAccessPolicy -ConditionalAccessPolicyId $policyId -BodyParameter $params
```

## MTR-Specific Conditional Access Policy

Create a dedicated CA policy for Teams Rooms devices:

### Recommended Policy Configuration

| Setting | Configuration |
|---------|---------------|
| **Name** | MTR-Access-Policy |
| **Users** | Include: MTR-ResourceAccounts-All group |
| **Cloud Apps** | Microsoft Teams, Exchange Online, SharePoint |
| **Conditions** | Optionally: Named locations (corporate network) |
| **Grant** | Require compliant device (approved client app is NOT supported on MTR) |
| **Session** | Do not configure sign-in frequency (not supported, causes periodic sign-outs) |

### Creating the Policy

**Via Entra Admin Center:**

1. Navigate to **Entra Admin Center** > **Protection** > **Conditional Access**
2. Click **+ Create new policy**
3. Configure:
   - **Name:** `MTR-Access-Policy`
   - **Users:**
     - Include: Select `MTR-ResourceAccounts-All` group
   - **Target resources:**
     - Cloud apps: Microsoft Teams, Exchange Online
   - **Conditions:**
     - Locations: Optionally require trusted/named locations
   - **Grant:**
     - Require device to be marked as compliant (if using Intune)
     - Do NOT select "Require approved client app" (not supported on MTR)
   - **Session:**
     - Do NOT configure sign-in frequency (not supported, causes periodic sign-outs)
4. Enable policy: **On**
5. Click **Create**

**Via PowerShell:**

```powershell
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"

$mtrGroup = Get-MgGroup -Filter "displayName eq 'MTR-ResourceAccounts-All'"

# Get app IDs
$teamsAppId = "cc15fd57-2c6c-4117-a88c-83b1d56b4bbe"  # Microsoft Teams
$exchangeAppId = "00000002-0000-0ff1-ce00-000000000000"  # Exchange Online

$policyParams = @{
    DisplayName = "MTR-Access-Policy"
    State = "enabled"
    Conditions = @{
        Users = @{
            IncludeGroups = @($mtrGroup.Id)
        }
        Applications = @{
            IncludeApplications = @($teamsAppId, $exchangeAppId)
        }
        ClientAppTypes = @("all")
    }
    GrantControls = @{
        Operator = "OR"
        BuiltInControls = @("compliantDevice")
    }
    # Do NOT configure SignInFrequency - it is not supported on MTR
    # and will cause periodic device sign-outs
}

New-MgIdentityConditionalAccessPolicy -BodyParameter $policyParams
```

## Device Filters

Use device filters to target MTR devices specifically:

### Filter by Device Model

```
device.model -contains "Teams Room"
```

### Filter by Display Name

```
device.displayName -startsWith "MTR-"
```

### Filter by Enrollment Profile (Autopilot)

```
device.enrollmentProfileName -eq "MTR-Autopilot-Profile"
```

### Example: Policy with Device Filter

```powershell
$policyParams = @{
    DisplayName = "MTR-Compliant-Device-Required"
    State = "enabled"
    Conditions = @{
        Users = @{
            IncludeUsers = @("All")
        }
        Applications = @{
            IncludeApplications = @("All")
        }
        Devices = @{
            DeviceFilter = @{
                Mode = "include"
                Rule = 'device.displayName -startsWith "MTR-"'
            }
        }
    }
    GrantControls = @{
        Operator = "AND"
        BuiltInControls = @("compliantDevice")
    }
}
```

## Named Locations

Create named locations for your office networks where MTR devices are deployed:

### Create Named Location

```powershell
Connect-MgGraph -Scopes "Policy.ReadWrite.ConditionalAccess"

$locationParams = @{
    "@odata.type" = "#microsoft.graph.ipNamedLocation"
    DisplayName = "Corporate-Network-All-Offices"
    IsTrusted = $true
    IpRanges = @(
        @{
            "@odata.type" = "#microsoft.graph.iPv4CidrRange"
            CidrAddress = "203.0.113.0/24"
        }
        @{
            "@odata.type" = "#microsoft.graph.iPv4CidrRange"
            CidrAddress = "198.51.100.0/24"
        }
    )
}

New-MgIdentityConditionalAccessNamedLocation -BodyParameter $locationParams
```

### Use in CA Policy

Include the trusted location as a condition:

```powershell
$locationId = (Get-MgIdentityConditionalAccessNamedLocation -Filter "displayName eq 'Corporate-Network-All-Offices'").Id

# In policy conditions
Conditions = @{
    Locations = @{
        IncludeLocations = @($locationId)
    }
}
```

## Common CA Scenarios

### Scenario 1: Basic MTR Access

**Goal:** Allow MTR devices on corporate network without MFA

**Configuration:**
- Include: MTR accounts group
- Condition: Named location (corporate network)
- Grant: Require compliant device
- Session: Do not configure sign-in frequency

### Scenario 2: Zero Trust for MTR

**Goal:** Require both compliant device AND trusted network

**Configuration:**
- Include: MTR accounts group
- Condition: Any location
- Grant: Require compliant device AND trusted location
- Session: Do not configure sign-in frequency (not supported)

### Scenario 3: Monitoring Only

**Goal:** Monitor MTR sign-ins without blocking

**Configuration:**
- Policy state: Report-only
- Include: MTR accounts group
- Condition: All locations
- Grant: Require MFA (report-only mode shows what would be blocked)

## Troubleshooting

### Check Sign-in Logs

```powershell
# Get recent MTR sign-ins
Connect-MgGraph -Scopes "AuditLog.Read.All"

Get-MgAuditLogSignIn -Filter "startswith(userPrincipalName, 'mtr-')" -Top 50 |
    Select UserPrincipalName, Status, ConditionalAccessStatus, AppliedConditionalAccessPolicies
```

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| Sign-in blocked | Policy requiring MFA | Add to exclusion group |
| Frequent re-auth | Sign-in frequency configured | Remove sign-in frequency setting entirely (not supported on MTR) |
| Compliant device failed | Device not enrolled | Enroll in Intune |
| Location blocked | IP not in named location | Update named location |

## Best Practices

1. **Always test in Report-Only** before enabling policies
2. **Use exclusion groups** for maintainability
3. **Document all policies** and their purposes
4. **Monitor sign-in logs** after changes
5. **Use device compliance** instead of MFA where possible
6. **Do not configure sign-in frequency** (not supported on MTR, causes sign-out loops)
7. **Do not enable Continuous Access Evaluation** (must be disabled or causes instability)
8. **Use named locations** for trusted networks
9. **Do not block Device Code Flow** in Authentication flows conditions (breaks Android remote sign-in)

## Related Topics

- [MFA Considerations](mfa-considerations.md)
- [Device Compliance](device-compliance.md)
- [CA Policy Script](../../scripts/entra-conditional-access/New-MTRConditionalAccessPolicy.ps1)
- [Supported Policies Reference](../reference/supported-policies.md)
