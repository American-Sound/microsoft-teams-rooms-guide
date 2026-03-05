# Microsoft Teams Rooms Licensing

## Overview

Microsoft Teams Rooms requires specific licensing for meeting room devices. There are two main license types: Teams Rooms Pro and Teams Rooms Basic. **Teams Rooms Pro is the recommended license for all production deployments.** Teams Rooms Basic is a limited free license intended only for evaluation, pilots, and proof-of-concept scenarios — it is not designed or recommended for production use.

## License Types

### Teams Rooms Pro

Teams Rooms Pro is the full-featured license for enterprise deployments.

**Included Features:**
- Full Teams meeting experience
- Teams Rooms Pro Management Portal access
- Intelligent audio and video capabilities
- AI-powered noise suppression
- Remote device management and monitoring
- Advanced analytics and reporting
- Real-time telemetry and alerts
- Automatic app and firmware updates (managed)
- Microsoft support for Teams Rooms
- Conditional access and compliance integration
- Microsoft Defender for Endpoint Plan 2
- Intune and Entra ID P1 entitlements
- Teams Phone Standard (PBX capabilities)
- Dual-screen support
- Intelligent speaker support
- Content camera support

**Recommended For:**
- Production meeting rooms
- Rooms requiring monitoring and management
- Enterprise deployments
- Rooms needing advanced features

### Teams Rooms Basic

Teams Rooms Basic is a limited free license intended for evaluation and proof-of-concept scenarios only. It is not designed for production use and lacks the management, monitoring, and security features that production environments require.

**Included Features:**
- Full Teams meeting experience
- Audio Conferencing (dial-in)
- Basic device management in Pro Management Portal (device inventory only — no incidents or analytics)
- Limited to 25 devices per tenant

**Limitations:**
- Maximum 25 rooms per tenant
- No incident detection or analytics in PMP
- No proactive alerting
- No Teams Phone Standard (no PSTN calling)
- No Intune or Entra ID P1 entitlements
- Limited support options

**Appropriate For:**
- Pilot and proof-of-concept deployments
- Short-term evaluation before purchasing Pro

> **Note:** Even organizations with fewer than 25 rooms should use Teams Rooms Pro for production deployments. The monitoring, management, and security capabilities included in Pro are essential for maintaining a reliable meeting room experience.

## License Comparison Matrix

| Feature | Teams Rooms Basic | Teams Rooms Pro |
|---------|-------------------|-----------------|
| **Price** | Free | Per device/month |
| **Device Limit** | 25 per tenant | Unlimited |
| **Teams Meetings** | Yes | Yes |
| **One-touch join** | Yes | Yes |
| **Whiteboard** | Yes | Yes |
| **Wireless content sharing** | Yes | Yes |
| **Pro Management Portal** | Device inventory only (no incidents/analytics) | Full (incidents, analytics, update rings) |
| **Audio Conferencing** | Yes | Yes |
| **Remote management** | No | Yes |
| **Real-time telemetry** | No | Yes |
| **Proactive alerts** | No | Yes |
| **Advanced analytics** | No | Yes |
| **Managed updates** | No | Yes |
| **Conditional Access** | Limited | Full |
| **Intune + Entra ID P1** | No | Yes |
| **Teams Phone Standard** | No | Yes |
| **Defender for Endpoint P2** | No | Yes |
| **Microsoft Support** | Community | Professional |

## Pricing

> **Note:** Pricing varies by agreement type and region. Contact your Microsoft partner or account team for current pricing.

Typical pricing models:
- **Teams Rooms Pro**: Monthly per-device subscription
- **Teams Rooms Basic**: Free (limited to 25 devices, evaluation/pilot use only)

## License Assignment

Teams Rooms licenses are assigned to the resource account (room mailbox), not to devices or users.

### Assignment Methods

1. **Microsoft 365 Admin Center** - Manual assignment via portal
2. **PowerShell** - Script-based assignment for bulk operations
3. **Group-based Licensing** - Automatic assignment via security groups

### Best Practices

- Use group-based licensing for scalability
- Create dedicated security groups for license assignment
- Separate Pro and Basic licensed rooms if using Basic for pilots
- Document license assignments in your CMDB

See [Licensing Assignment](../02-prerequisites/licensing-assignment.md) for detailed steps.

## Common Licensing Scenarios

### Scenario 1: Small Organization

- 10 meeting rooms
- Limited IT resources
- **Recommendation:** Teams Rooms Pro for all devices. The management and monitoring capabilities justify the cost at any scale, and you avoid accumulating technical debt from running unmanaged rooms.

### Scenario 2: Mid-size Enterprise

- 50 meeting rooms
- Need monitoring and management
- **Recommendation:** Teams Rooms Pro for all devices

### Scenario 3: Large Enterprise

- 200+ meeting rooms
- Mix of critical and casual spaces
- **Recommendation:** Teams Rooms Pro for all devices. Even "casual" meeting spaces create support tickets and user frustration when they go unmanaged. The cost of Pro across the fleet is typically far less than the labor cost of reactively troubleshooting unmonitored rooms.

### Scenario 4: Evaluation/Pilot

- Testing MTR deployment
- 5 pilot rooms
- **Recommendation:** Teams Rooms Basic for the pilot period, then upgrade to Teams Rooms Pro before moving to production

## License Requirements for Features

Certain features require Teams Rooms Pro:

| Feature | Basic | Pro Required |
|---------|-------|--------------|
| Intelligent Speaker | No | Yes |
| Content Camera | Limited | Yes |
| Remote Restart | No | Yes |
| Configuration Updates | Manual | Automatic |
| Peripheral Health Monitoring | No | Yes |
| Meeting Analytics | No | Yes |

## Related Topics

- [Licensing Assignment Steps](../02-prerequisites/licensing-assignment.md)
- [Resource Account Creation](../02-prerequisites/resource-accounts.md)
- [Teams Rooms Pro Management Portal](../10-pro-management/portal-overview.md)
