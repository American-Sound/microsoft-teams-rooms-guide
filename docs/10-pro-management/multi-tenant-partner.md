# Multi-Tenant Management Portal (Partner Portal)

## Overview

The Multi-Tenant Management (MTM) portal enables managed service providers and Microsoft Teams Rooms partners to manage multiple customer tenants from a single interface.

**URL:** [https://partner.rooms.microsoft.com](https://partner.rooms.microsoft.com/)

**Availability:** Public/commercial cloud only. Not available in GCC, GCC-H, or DoD.

> **Note:** Partner organizations cannot manage their own rooms through MTM. Those must be managed at `portal.rooms.microsoft.com`.

## How It Differs from Single-Tenant PMP

- Cross-tenant visibility and management from a single partner login
- Two navigation models: **Aggregate view** (data from all customers in a single filterable list, currently only Incidents page with "Enable all tickets view" toggle) and **Tenant switching** (select a specific customer from dropdown)
- Partner users only see customer rooms they are assigned to manage

## Partner Onboarding

1. **Partner prerequisites:** Must meet eligibility criteria demonstrating capability to deploy, configure, and manage Teams Rooms (including Surface Hub). Apply at [aka.ms/MicrosoftTeamsRoomsPartnerInquiry](https://aka.ms/MicrosoftTeamsRoomsPartnerInquiry)

2. **Customer initiates:** Customer sends invitation from their PMP portal: **Settings > Partners > Add partner**, entering partner domain, setting expiration (1-30 days), and configuring change control approval (currently only auto-approval available)

3. **Customer assigns room scope:** The invitation specifies which rooms the partner can manage

4. **Partner accepts:** Users with Global Admin, Teams Rooms Pro Manager, or Tenant Manager roles see pending invitations in the MTM portal and accept

## Security Model

The MTM portal uses its **own invitation-based delegation model** rather than standard GDAP through Partner Center:

- A partner gains **no privileges outside the Teams Rooms Pro Management portal** — no access to Entra ID, Teams Admin Center, or any other Microsoft product
- Partners cannot view or modify rooms outside the invitation scope
- Data resides in the customer's tenant and is not copied to the partner's tenant
- Customers retain full control and can remove a partner at any time
- Audit logs available for partner activity within PMP (Entra ID/O365 auditing does not capture PMP logs)

## Partner Roles

| Role | Description |
|------|-------------|
| Tenant Managers | MTM-only role for accepting invitations and sub-delegating |
| Primary Admins | Built-in role per customer with almost all permissions within assigned room scope |
| Custom partner roles | Created per customer for operational needs (e.g., help desk with only incident management) |

Customers can delete partner roles at any time.

## Current Limitations

These features are **not available** in the MTM partner portal:

- ServiceNow API integration
- Standards / Room Planner
- One Time Password
- Remote Control
- Bring Your Own Device (BYOD)
- Windows Autopilot

## Licensing

The customer must have Teams Rooms Pro or Teams Shared Device licenses on their rooms. The partner does not need separate PMP licenses — access is granted through the invitation/delegation model.

## API and Programmatic Access

The beta TeamworkDevice Graph API was retired December 8, 2025. There is currently no supported programmatic API for PMP data. Available data extraction methods:

- Ticket export (JSON) from Reporting > Overview
- ServiceNow Table API integration
- Email notifications per role assignment
- AI Assistant for interactive queries

## Related Topics

- [Portal Overview](portal-overview.md) — Single-tenant PMP features and architecture
- [RBAC](rbac.md) — Role-based access control in PMP
- [Health Monitoring](health-monitoring.md) — Cross-tenant health visibility

## References

- [Multitenant customer management for partners](https://learn.microsoft.com/en-us/microsoftteams/rooms/multi-tenant-management-partner)
- [Partner management for customers](https://learn.microsoft.com/en-us/microsoftteams/rooms/multi-tenant-management-customer)
