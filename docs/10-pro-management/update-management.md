# Update Management

## Overview

The PMP update management system uses ring-based validation for controlled rollout of updates. Updates cover: Teams Rooms app, Windows OS quality updates, Windows OS feature updates, firmware/drivers (delivered through Windows Update by OEMs), and Microsoft Store applications.

## Update Rings

Three preconfigured rings:

| Ring | Purpose | Recommendation |
|------|---------|----------------|
| **Staging** | Testbed ring, all new updates roll out here first | Include diversity of device types |
| **General** | Default ring for most enterprise devices | Primary production ring |
| **Executive** | High-profile rooms where disruption must be minimized | Last to receive updates |

Custom rings can be created (up to 9 in order). Each ring has configurable parameters:

- **Deferment period** — delay in days before the update starts on this ring
- **Rollout duration** — time in days to deploy within the ring
- **Test period** — days to validate after rollout completes before moving to next ring
- Updates cannot exceed **60 days** across all rings total

## Update States

| State | Description |
|-------|-------------|
| Scheduled | Update queued for this ring |
| In progress | Currently deploying |
| Completed with failures | Done but some devices failed |
| Completed | Successfully deployed |
| Deprecated | Update superseded |
| Paused | Permanently halted |
| Not Required | Ring devices already at target version |

## Maintenance Window

Updates install during the **nightly maintenance window (12:00 AM — 5:00 AM room local time)**. Windows updates use a preset local policy (beginning between 2:00-3:00 AM).

## Admin Controls

- **Pause** — permanently halt an update
- **Retry all failed** — retry on devices that failed
- **Force updates** — immediate or next available (not recommended as general strategy)

## Licensing

Teams Rooms Pro licenses get ring-based orchestration. Basic/Standard licenses get updates through the device's nightly maintenance window automatically (no ring control).

> **Important:** Do not use SCCM, Intune, WSUS, or other tools to push Windows feature updates to MTR-W during the validation period. The app uses WUfB group policies to intentionally defer updates until certified.

## Related Topics

- [Portal Overview](portal-overview.md) — PMP dashboard and room management
- [Health Monitoring](health-monitoring.md) — Monitoring signals affected by updates

## References

- [Update management in PMP](https://learn.microsoft.com/en-us/microsoftteams/rooms/update-management)
- [Manual update procedures](https://learn.microsoft.com/en-us/microsoftteams/rooms/manual-update)
- [Windows updates for MTR](https://learn.microsoft.com/en-us/microsoftteams/rooms/updates)
