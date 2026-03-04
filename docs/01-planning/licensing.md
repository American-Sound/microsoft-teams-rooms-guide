# Microsoft Teams Rooms Licensing

## Overview

Microsoft Teams Rooms requires specific licensing for meeting room devices. There are two main license types: Teams Rooms Pro and Teams Rooms Basic.

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
- Dual-screen support
- Intelligent speaker support
- Content camera support

**Recommended For:**
- Production meeting rooms
- Rooms requiring monitoring and management
- Enterprise deployments
- Rooms needing advanced features

### Teams Rooms Basic

Teams Rooms Basic is a limited free license for small deployments or evaluation.

**Included Features:**
- Full Teams meeting experience
- Basic device management in Teams Admin Center
- Limited to 25 devices per tenant
- No Pro Management Portal access
- No advanced analytics

**Limitations:**
- Maximum 25 rooms per tenant
- No remote management portal
- No proactive alerting
- No advanced analytics
- Limited support options

**Recommended For:**
- Small organizations (< 25 rooms)
- Evaluation/testing scenarios
- Non-critical meeting spaces

## License Comparison Matrix

| Feature | Teams Rooms Basic | Teams Rooms Pro |
|---------|-------------------|-----------------|
| **Price** | Free | Per device/month |
| **Device Limit** | 25 per tenant | Unlimited |
| **Teams Meetings** | Yes | Yes |
| **One-touch join** | Yes | Yes |
| **Whiteboard** | Yes | Yes |
| **Wireless content sharing** | Yes | Yes |
| **Teams Admin Center** | Basic | Full |
| **Pro Management Portal** | No | Yes |
| **Remote management** | No | Yes |
| **Real-time telemetry** | No | Yes |
| **Proactive alerts** | No | Yes |
| **Advanced analytics** | No | Yes |
| **Managed updates** | No | Yes |
| **Conditional Access** | Limited | Full |
| **Microsoft Support** | Community | Professional |

## Pricing

> **Note:** Pricing varies by agreement type and region. Contact your Microsoft partner or account team for current pricing.

Typical pricing models:
- **Teams Rooms Pro**: Monthly per-device subscription
- **Teams Rooms Basic**: Free (limited to 25 devices)

## License Assignment

Teams Rooms licenses are assigned to the resource account (room mailbox), not to devices or users.

### Assignment Methods

1. **Microsoft 365 Admin Center** - Manual assignment via portal
2. **PowerShell** - Script-based assignment for bulk operations
3. **Group-based Licensing** - Automatic assignment via security groups

### Best Practices

- Use group-based licensing for scalability
- Create dedicated security groups for license assignment
- Separate Pro and Basic licensed rooms if using both
- Document license assignments in your CMDB

See [Licensing Assignment](../02-prerequisites/licensing-assignment.md) for detailed steps.

## Common Licensing Scenarios

### Scenario 1: Small Organization

- 10 meeting rooms
- Limited IT resources
- **Recommendation:** Teams Rooms Basic (free, under 25-device limit)

### Scenario 2: Mid-size Enterprise

- 50 meeting rooms
- Need monitoring and management
- **Recommendation:** Teams Rooms Pro for all devices

### Scenario 3: Large Enterprise with Mixed Use

- 200+ meeting rooms
- Mix of critical and casual spaces
- **Recommendation:**
  - Teams Rooms Pro for executive/critical rooms
  - Teams Rooms Basic for remaining 25 lower-priority spaces
  - Teams Rooms Pro for the rest

### Scenario 4: Evaluation/Pilot

- Testing MTR deployment
- 5 pilot rooms
- **Recommendation:** Teams Rooms Basic initially, upgrade to Pro for production

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
