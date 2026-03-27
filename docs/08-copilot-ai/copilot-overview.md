# Copilot in Teams Rooms

## Overview

Microsoft 365 Copilot integrates with Teams Rooms to provide AI-powered meeting assistance. Licensed remote participants can interact with Copilot privately during meetings: their prompts and responses are visible only to the individual user, not projected on the front-of-room display. Copilot uses either a persisted transcript or a non-persisted speech-to-text stream (depending on the organizer's meeting option) to understand what has been said.

## What Users Can Do

- Ask real-time questions during the meeting: "How did the team react to the proposal?", "Does this plan's timeline have any conflicts?"
- Get catch-up summaries mid-meeting if they joined late
- Request follow-up tasks and action items
- Create tables summarizing pros/cons or other structured data from discussion
- Access Intelligent Recap after the meeting (AI notes, recommended tasks, speaker/chapter markers, audio recap)

## Front-of-Room Display Behavior

The Copilot interaction itself is **private to each licensed user's device** (desktop, mobile). It does not appear on the front-of-room display. However, the [Facilitator agent](facilitator.md) (separate from Copilot) does project AI-generated notes and agenda tracking onto the front-of-room display.

The front-of-room display shows live captions, transcription indicators, and Facilitator notes when active.

## Interpreter Agent

The Interpreter agent (introduced in Teams Rooms app v5.5.129.0, January 2026) provides real-time interpretation in up to 9 languages during meetings. Meeting participants select their preferred language, and the agent translates speech in real time, allowing multilingual meetings without dedicated human interpreters. The Interpreter agent requires a Teams Rooms Pro license and is configured through Teams meeting policies.

## Voice and Face Recognition Management

As of Teams Rooms app v5.4.210.0 (September 2025), voice and face recognition settings can be managed through the Pro Management Portal UI in addition to the existing PowerShell method (`Set-CsTeamsAIPolicy`). The PMP UI is the simpler path for per-room configuration, while PowerShell remains available for bulk policy assignment across fleets.

## Licensing Requirements

AI features for Teams Rooms span four license tiers:

| Feature | Teams (base) | Teams Premium | M365 Copilot |
|---------|-------------|---------------|--------------|
| AI-based noise suppression | Yes |: |: |
| AI-based video optimization | Yes |: |: |
| Suggested replies | Yes |: |: |
| Live meeting captions and transcript | Yes |: |: |
| Cameo video overlay | Yes |: |: |
| Real-time caption/transcript translation |: | Yes |: |
| Intelligent Recap (AI notes and tasks) |: | Yes | Yes |
| Intelligent Recap (video, speaker, chapter markers) |: | Yes | Yes |
| In-meeting Copilot queries |: |: | Yes |
| Microsoft Copilot UX |: |: | Yes |
| M365 Graph grounding |: |: | Yes |
| Audio Recap |: |: | Yes |
| Facilitator Agent |: |: | Yes |
| Customizable Recap templates |: |: | Yes |

**Teams Rooms Pro** license must be assigned to the resource account of each Teams Rooms console. This is required for Intelligent Speaker, Facilitator in unscheduled meetings, enhanced captions with translation, and full AI feature support.

**Microsoft 365 Copilot** license is assigned to individual users, not the room resource account. Required for in-meeting Copilot Q&A.

**Teams Premium** is assigned to meeting organizers. Enables real-time translation and Intelligent Recap for attendees.

### Key SKUs

| SKU | ID | Assigned To |
|-----|------|-------------|
| Teams Rooms Pro | CFQ7TTC0QW7C | Room resource account |
| Microsoft 365 Copilot | 639dec6b-bb19-468b-871c-c5c441c4b0cb | Individual users |

## Admin Configuration

### Step 1: Assign Licenses

Assign **Teams Rooms Pro** to the room resource account. Assign **M365 Copilot** to individual users who need in-meeting Copilot access.

### Step 2: Configure the Copilot Meeting Policy

The `-Copilot` parameter in `Set-CsTeamsMeetingPolicy` controls Copilot behavior:

| Teams Admin Center Value | PowerShell Value | Behavior |
|--------------------------|-----------------|----------|
| On | `Enabled` | Default = "Only during the meeting" (non-persisted). Organizer can change. |
| On with saved transcript required | `EnabledWithTranscript` | Forces "During and after": organizer cannot change. Transcript always persisted. |
| On with transcript saved by default | `EnabledWithTranscriptDefaultOn` | Default = "During and after" but organizer can change. |
| Off | `Disabled` | Default = Off. Organizer can still enable per-meeting. |

```powershell
# Enable Copilot with persisted transcript as default, organizer can change
Set-CsTeamsMeetingPolicy -Identity <PolicyName> -Copilot EnabledWithTranscriptDefaultOn

# Force Copilot with persisted transcript (organizer cannot override)
Set-CsTeamsMeetingPolicy -Identity <PolicyName> -Copilot EnabledWithTranscript
```

> **Note:** Microsoft changed the default Copilot policy from `EnabledWithTranscript` to `Enabled` in March 2026, shifting the default to non-persisted transcripts. Review your policies to confirm they match your organization's transcript retention requirements.

### Step 3: Enable Transcription

```powershell
Set-CsTeamsMeetingPolicy -Identity <PolicyName> -AllowTranscription $true
```

### Step 4: Enable Recording (recommended for full Recap)

```powershell
Set-CsTeamsMeetingPolicy -Identity <PolicyName> -AllowCloudRecording $true
```

Without recording, users get Recap without recording playback, speakers, topics, and chapters.

### Step 5: Configure in Teams Admin Center (GUI alternative)

1. Sign in to [Teams Admin Center](https://admin.teams.microsoft.com/)
2. Navigate to **Meetings** > **Meeting Policies**
3. Under **Recording & transcription**, configure: Copilot, Meeting recording, Transcription, Live captions

## Meeting Recap

### Features

Available in the Recap tab in Teams calendar and chat after a meeting ends:

- AI meeting notes: automated summary of discussion
- AI recommended tasks: action items extracted from conversation
- Personalized timeline markers: shows when your name was mentioned, screens shared, join/leave times
- Speaker timeline markers: who spoke and when, with jump-to-moment
- Meeting chapters: topic-based divisions
- Audio Recap (M365 Copilot only, public preview): podcast-like AI-generated audio summary

### Customizable Templates (February 2026 GA)

- **Speaker Summary**: organizes insights by participant
- **Executive Summary**: highlights key takeaways and decisions
- **Custom templates**: free-text prompt describing desired structure; can save for reuse

## Related Topics

- [Facilitator](facilitator.md): AI-generated shared notes on front-of-room display
- [Intelligent Speaker](intelligent-speaker.md): Voice/face enrollment and speaker attribution
- [Voice Isolation](voice-isolation.md): Noise suppression policies
- [Foundry Agents](foundry-agents.md): Custom AI agents for conference rooms
- [AI PowerShell Reference](powershell-reference.md): All AI/Copilot PowerShell commands
- [Licensing](../01-planning/licensing.md): Teams Rooms Pro vs Basic feature comparison

## References

- [Admin guide to Copilot in Teams Rooms](https://learn.microsoft.com/en-us/microsoftteams/rooms/copilot-admin-mtr)
- [Manage M365 Copilot in Teams meetings](https://learn.microsoft.com/en-us/microsoftteams/copilot-teams-transcription)
- [Intelligent Recap](https://learn.microsoft.com/en-us/microsoftteams/intelligent-recap-calls-meetings)
- [License options for M365 Copilot](https://learn.microsoft.com/en-us/copilot/microsoft-365/microsoft-365-copilot-licensing)
