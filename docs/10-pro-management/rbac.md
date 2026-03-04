# Role-Based Access Control

## Entra ID Built-in Roles

| Role | Portal Access |
|------|--------------|
| Global Administrator | Full access to all PMP features |
| Teams Administrator | Most PMP features including ServiceNow, Signals, role management |
| Teams Devices Administrator | Device management, rooms, updates, tickets, inventory; cannot manage roles, ServiceNow, or Signals |
| Global Reader | Read-only access |

> **Note:** Teams Administrator or Teams Devices Administrator assigned to an Administrative Unit (AU) cannot access PMP — AUs are not yet supported.

## PMP Built-in Roles

| Role | Description |
|------|-------------|
| Teams Rooms Pro Manager | Full access to all PMP features, equivalent to admin |
| Site Lead | View/modify rooms, view groups, view reports, view/modify tickets. Cannot manage room groups, updates, roles, inventory, or service config |
| Site Technician | View/modify rooms and view/modify tickets only |

## Custom Roles

Created by Global Administrator, Teams Administrator, or Teams Rooms Pro Manager. Each custom role is configured with:

- **Permissions** — granular checkbox selection of feature access
- **Assignments** — named assignments with:
  - **Members** — users or security groups
  - **Scope** — specific rooms or room groups
  - **Email notifications** — optional service notifications for rooms in scope

Multiple assignments per role are supported, and users can be in multiple assignments.

## Related Topics

- [Portal Overview](portal-overview.md) — PMP features and access
- [Multi-Tenant Partner Portal](multi-tenant-partner.md) — Partner roles and delegation

## References

- [Role-based access control in PMP](https://learn.microsoft.com/en-us/microsoftteams/rooms/rooms-pro-rbac)
