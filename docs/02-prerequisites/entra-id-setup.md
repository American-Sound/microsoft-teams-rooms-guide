# Entra ID Setup

## Overview

Microsoft Teams Rooms requires proper Entra ID (formerly Azure AD) configuration for authentication, management, and security. This guide covers tenant configuration and security group setup for MTR deployments.

## Tenant Requirements

### Minimum Requirements

- Microsoft 365 tenant (commercial, GCC, or GCC High)
- Entra ID P1 (included with Teams Rooms Pro; P2 recommended if you need PIM or risk-based Conditional Access)
- Exchange Online (for room mailboxes)
- Microsoft Teams service enabled

### Additional Services (Beyond What's Included in Pro)

- Entra ID P2 (for PIM, risk-based Conditional Access — P1 is included with Teams Rooms Pro)
- Note: Intune, Entra ID P1, and Defender for Endpoint Plan 2 are all included with the Teams Rooms Pro license and do not require separate licensing

## Security Groups

Create dedicated security groups to manage MTR devices and accounts:

### Recommended Group Structure

| Group Name | Type | Purpose |
|------------|------|---------|
| `MTR-Devices-All` | Dynamic Device | All enrolled MTR devices |
| `MTR-ResourceAccounts-All` | Assigned | All MTR resource accounts |
| `MTR-Devices-Windows` | Dynamic Device | Windows MTR devices |
| `MTR-Devices-Android` | Dynamic Device | Android MTR devices |
| `MTR-License-Pro` | Assigned | Accounts for Pro license assignment |
| `MTR-License-Basic` | Assigned | Accounts for Basic license assignment |
| `MTR-CA-Exclude` | Assigned | Accounts excluded from standard CA |

### Creating Security Groups

#### Via Entra Admin Center

1. Navigate to **Entra Admin Center** > **Groups** > **All groups**
2. Click **New group**
3. Configure:
   - Group type: **Security**
   - Group name: `MTR-ResourceAccounts-All`
   - Group description: `All Microsoft Teams Rooms resource accounts`
   - Membership type: **Assigned** or **Dynamic**
4. Click **Create**

#### Via PowerShell (Microsoft Graph)

```powershell
# Connect to Microsoft Graph
Connect-MgGraph -Scopes "Group.ReadWrite.All"

# Create assigned group for resource accounts
$groupParams = @{
    DisplayName = "MTR-ResourceAccounts-All"
    Description = "All Microsoft Teams Rooms resource accounts"
    MailEnabled = $false
    MailNickname = "MTR-ResourceAccounts-All"
    SecurityEnabled = $true
}
New-MgGroup @groupParams

# Create assigned group for CA exclusions
$caGroupParams = @{
    DisplayName = "MTR-CA-Exclude"
    Description = "MTR accounts excluded from standard Conditional Access policies"
    MailEnabled = $false
    MailNickname = "MTR-CA-Exclude"
    SecurityEnabled = $true
}
New-MgGroup @caGroupParams
```

### Dynamic Group Examples

Dynamic groups automatically add devices based on rules:

#### All Windows MTR Devices

**Rule syntax:**
```
(device.deviceModel -contains "Teams Room") or
(device.displayName -startsWith "MTR-")
```

#### All Autopilot MTR Devices

**Rule syntax:**
```
(device.devicePhysicalIds -any (_ -contains "[OrderID]:MTR"))
```

#### Creating Dynamic Device Group via PowerShell

```powershell
$dynamicGroupParams = @{
    DisplayName = "MTR-Devices-Windows"
    Description = "All Windows-based Microsoft Teams Rooms devices"
    MailEnabled = $false
    MailNickname = "MTR-Devices-Windows"
    SecurityEnabled = $true
    GroupTypes = @("DynamicMembership")
    MembershipRule = '(device.deviceModel -contains "Teams Room")'
    MembershipRuleProcessingState = "On"
}
New-MgGroup @dynamicGroupParams
```

## Device Registration

### Entra ID Join vs. Hybrid Join

| Method | Description | Recommended For |
|--------|-------------|-----------------|
| **Entra ID Join** | Cloud-only device identity | MTR on Windows (Autopilot) |
| **Hybrid Entra ID Join** | Both AD and Entra ID | Legacy scenarios only |

**Recommendation:** Use Entra ID Join with Autopilot for new MTR deployments.

### Device Settings Configuration

1. Navigate to **Entra Admin Center** > **Devices** > **Device settings**
2. Configure:
   - **Users may join devices to Entra ID**: Yes or selected groups
   - **Additional local administrators**: Add IT admin group
   - **Require MFA to register devices**: No (for MTR service accounts)

## Administrative Roles

### Recommended Roles for MTR Management

| Role | Purpose |
|------|---------|
| **Teams Administrator** | Manage Teams settings and devices |
| **Intune Administrator** | Manage device enrollment and policies |
| **Exchange Administrator** | Manage room mailboxes |
| **Cloud Device Administrator** | Manage Entra ID device objects |

### Role Assignment

Assign roles via:
- Entra Admin Center > Roles > Assign roles
- Privileged Identity Management (PIM) for time-limited access

## Service Accounts

MTR resource accounts should be:
- Cloud-only user accounts (not synced from AD)
- Assigned to MTR license group
- Excluded from standard user Conditional Access policies
- Not assigned interactive MFA

See [Resource Accounts](resource-accounts.md) for detailed account creation steps.

## Conditional Access Preparation

Before deploying MTR devices, plan your Conditional Access strategy:

1. **Identify existing CA policies** that may block MTR sign-in
2. **Create exclusion group** for MTR resource accounts
3. **Plan MTR-specific policies** for device compliance

See [Conditional Access](../03-security/conditional-access.md) for detailed policy configuration.

## Checklist

- [ ] Verify tenant has required licenses
- [ ] Create security group for resource accounts
- [ ] Create security group for CA exclusions
- [ ] Create dynamic device groups (optional)
- [ ] Configure device settings
- [ ] Plan Conditional Access exclusions
- [ ] Assign administrative roles

## Related Topics

- [Resource Accounts](resource-accounts.md)
- [Licensing Assignment](licensing-assignment.md)
- [Conditional Access](../03-security/conditional-access.md)
