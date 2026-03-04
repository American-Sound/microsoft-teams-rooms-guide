# Facilitator Agent

## Overview

Facilitator is an AI-powered agent that acts as a shared meeting assistant visible to all participants. Unlike Copilot (where prompts and responses are private to each user), Facilitator's responses appear in the meeting chat for everyone. It functions like an AI participant sitting in the meeting.

## GA Features

- Collaborative, real-time AI-generated notes editable by all participants via the Notes tab
- AI-powered Q&A from meeting and web content (mention `@Facilitator` in chat)
- Visual timeline markers tracking topics and time, with reminders at midway and wrap-up
- Enhanced Teams Rooms experience with chat, notes, and timers on front-of-room display
- Mobile capture of ad-hoc discussions and action items

## Public Preview Features

- Task tracking integration with Planner
- Document drafting with Word or Loop

## How It Works in Teams Rooms

### Scheduled Meetings

When a Teams Room is invited to a scheduled meeting, in-room participants can view Facilitator interactions in chat and navigate to the Notes button on the console to view AI-generated notes. Notes are also visible on the front-of-room display.

### Unscheduled / Ad-Hoc Meetings

When a room is unoccupied and the presence detector wakes the device, a banner appears on the front-of-room display inviting users to start Facilitator. One participant scans a QR code on the display using their mobile Teams app, which starts an ad-hoc meeting with transcription enabled. The front-of-room display shows "Facilitator is listening" and begins displaying AI-generated notes that auto-update throughout the conversation.

> **Current limitation:** Only the person who scans the QR code is identified and attributed in transcription and notes. Other in-room participants appear as "Speaker 1", "Speaker 2", etc. Microsoft has stated this will be addressed in a future update.

## Licensing

- An eligible **Microsoft 365 base license** (E3, E5, Business Basic/Standard/Premium, etc.)
- A **Microsoft Teams** license (often included in M365 subscription)
- A **Microsoft 365 Copilot** license — Facilitator is included with M365 Copilot
- For unscheduled meetings in Teams Rooms: **Teams Rooms Pro** license on the resource account

## Admin Setup

### For Scheduled Meetings

1. Assign M365 Copilot licenses to users
2. Enable Loop experiences in Teams (see [Loop components configuration](https://learn.microsoft.com/en-us/microsoft-365/loop/loop-components-configuration))
3. In Teams Admin Center > **Teams apps** > **Manage apps** > search for "Facilitator" > select **Allow**

### For Unscheduled Meetings in Teams Rooms

1. Assign **Teams Rooms Pro** license to the room resource account
2. In the **Teams Rooms Pro Management Portal**: Room > Settings > Meeting > **Facilitator QR Code** > toggle On
3. In PMP: Room > Settings > Account > **Enable public preview** > toggle On (still required for some Facilitator-in-Rooms features)

## Data Storage

AI-generated notes are stored as `.loop` files in the OneDrive **Meetings** folder of the user who initiated Facilitator. This data is treated as meeting transcript data and follows the same retention and compliance policies.

## Platform Availability

Currently available on Teams Rooms on Windows. Teams Rooms on Android support is planned for a later date.

## Related Topics

- [Copilot Overview](copilot-overview.md) — Copilot license tiers and meeting policy configuration
- [Intelligent Speaker](intelligent-speaker.md) — Voice/face enrollment for speaker attribution
- [Pro Management Portal](../10-pro-management/portal-overview.md) — Enable Facilitator via portal settings

## References

- [Facilitator in Teams Rooms](https://learn.microsoft.com/en-us/microsoftteams/rooms/facilitator-teams-rooms)
- [Set up Facilitator in Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/facilitator-teams)
