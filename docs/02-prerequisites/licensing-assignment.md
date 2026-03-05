# Licensing Assignment

## Overview

Each Microsoft Teams Rooms resource account requires a Teams Rooms license to function. **Teams Rooms Pro is recommended for all production deployments.** Teams Rooms Basic should only be used for pilots and evaluations. This guide covers methods for assigning licenses to MTR accounts.

## License SKU Identifiers

| License | SKU Part Number | Product ID |
|---------|----------------|------------|
| Teams Rooms Pro | `MTR_PREM` | `4cde982a-ede4-4409-9ae6-b003453c8ea6` |
| Teams Rooms Basic | `Microsoft_Teams_Rooms_Basic` | `6af4b3d6-14bb-4a2a-960c-6c902aad34f3` |

## Assignment Methods

### Method 1: Microsoft 365 Admin Center

**For single accounts:**

1. Navigate to **Microsoft 365 Admin Center** > **Users** > **Active users**
2. Search for the resource account (e.g., `mtr-hq-101`)
3. Click on the user > **Licenses and apps**
4. Check **Microsoft Teams Rooms Pro** or **Microsoft Teams Rooms Basic**
5. Click **Save changes**

### Method 2: PowerShell (Single Assignment)

```powershell
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "User.ReadWrite.All", "Directory.ReadWrite.All"

# Set variables
$userUPN = "mtr-hq-101@contoso.com"
$skuId = "4cde982a-ede4-4409-9ae6-b003453c8ea6"  # Teams Rooms Pro

# Get user
$user = Get-MgUser -Filter "userPrincipalName eq '$userUPN'"

# Assign license
$licenseParams = @{
    AddLicenses = @(
        @{
            SkuId = $skuId
        }
    )
    RemoveLicenses = @()
}

Set-MgUserLicense -UserId $user.Id -BodyParameter $licenseParams

# Verify assignment
Get-MgUserLicenseDetail -UserId $user.Id | Select SkuPartNumber
```

### Method 3: Group-Based Licensing (Recommended)

Group-based licensing automatically assigns licenses when users are added to a group.

#### Setup via Entra Admin Center

1. Navigate to **Entra Admin Center** > **Groups** > **All groups**
2. Select or create `MTR-License-Pro` group
3. Click **Licenses** in left menu
4. Click **+ Assignments**
5. Select **Microsoft Teams Rooms Pro**
6. Click **Save**

#### Setup via PowerShell

```powershell
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All", "Directory.ReadWrite.All"

# Get group and SKU
$group = Get-MgGroup -Filter "displayName eq 'MTR-License-Pro'"
$sku = Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -eq "MTR_PREM" }

# Assign license to group
$licenseParams = @{
    AddLicenses = @(
        @{
            DisabledPlans = @()
            SkuId = $sku.SkuId
        }
    )
    RemoveLicenses = @()
}

Set-MgGroupLicense -GroupId $group.Id -BodyParameter $licenseParams
```

#### Add Users to Licensed Group

```powershell
# Add resource account to license group
$user = Get-MgUser -Filter "userPrincipalName eq 'mtr-hq-101@contoso.com'"
$group = Get-MgGroup -Filter "displayName eq 'MTR-License-Pro'"

New-MgGroupMember -GroupId $group.Id -DirectoryObjectId $user.Id
```

### Method 4: Bulk Assignment

For bulk license assignment, use the licensing scripts:

```powershell
# Using the Set-MTRLicense.ps1 script
.\Set-MTRLicense.ps1 -UserPrincipalName "mtr-hq-101@contoso.com" -LicenseType "Pro"

# For bulk assignment from CSV
Import-Csv "resource-accounts.csv" | ForEach-Object {
    .\Set-MTRLicense.ps1 -UserPrincipalName $_.UserPrincipalName -LicenseType "Pro"
}
```

See [Set-MTRLicense.ps1](../../scripts/licensing/Set-MTRLicense.ps1) for the full script.

## Verification

### Check License Assignment

**Via Admin Center:**
1. Go to **Microsoft 365 Admin Center** > **Billing** > **Licenses**
2. Click on **Microsoft Teams Rooms Pro**
3. Search for the resource account

**Via PowerShell:**
```powershell
# Check specific user
$user = Get-MgUser -Filter "userPrincipalName eq 'mtr-hq-101@contoso.com'"
Get-MgUserLicenseDetail -UserId $user.Id | Select SkuPartNumber, SkuId

# Check all MTR accounts
$mtrUsers = Get-MgUser -Filter "startswith(userPrincipalName, 'mtr-')" -All
foreach ($user in $mtrUsers) {
    $licenses = Get-MgUserLicenseDetail -UserId $user.Id
    [PSCustomObject]@{
        UserPrincipalName = $user.UserPrincipalName
        Licenses = ($licenses.SkuPartNumber -join ", ")
    }
}
```

### Check Available Licenses

```powershell
# Get available Teams Rooms licenses
Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -like "*MTR*" -or $_.SkuPartNumber -like "*Teams_Rooms*" } |
    Select SkuPartNumber, ConsumedUnits, @{N='Available';E={$_.PrepaidUnits.Enabled - $_.ConsumedUnits}}
```

## License Requirements

### Teams Rooms Pro Enables

- Teams meeting join
- Calendar integration
- Pro Management Portal
- Remote management
- Advanced analytics
- Intelligent audio/video

### Teams Rooms Basic Enables

- Teams meeting join
- Calendar integration
- Basic device management in Pro Management Portal (no incidents or analytics)

### Additional Considerations

| Requirement | Notes |
|-------------|-------|
| **Usage Location** | Must be set on user account |
| **Exchange Online** | Not required separately (MTR license includes) |
| **Teams Phone Standard** | Included with Teams Rooms Pro; a PSTN connectivity option (Calling Plan, Direct Routing, or Operator Connect) and phone number are still required separately |
| **Common Area Phone** | Different license for phone devices |

## Setting Usage Location

License assignment requires a usage location:

```powershell
# Set usage location
$user = Get-MgUser -Filter "userPrincipalName eq 'mtr-hq-101@contoso.com'"
Update-MgUser -UserId $user.Id -UsageLocation "US"
```

## Troubleshooting

### Common Issues

| Issue | Cause | Solution |
|-------|-------|----------|
| "No available licenses" | License exhausted | Purchase more licenses |
| "Usage location not set" | Missing location | Set UsageLocation property |
| License not applying | Group processing | Wait 15-30 mins for group sync |
| Conflicting licenses | Multiple assignments | Remove direct assignment if using group |

### License Processing Delays

- Direct assignment: Immediate to 15 minutes
- Group-based: Up to 30 minutes
- Bulk operations: May take longer

## Best Practices

1. **Use group-based licensing** for scalability and consistency
2. **Create separate groups** for Pro and Basic licenses (if using Basic for pilots)
3. **Document license assignments** in your CMDB/inventory
4. **Monitor license consumption** to avoid running out
5. **Set usage location** before assigning licenses
6. **Avoid mixing** direct and group-based assignment

## Related Topics

- [Licensing Overview](../01-planning/licensing.md)
- [License Scripts](../../scripts/licensing/)
- [Resource Accounts](resource-accounts.md)
