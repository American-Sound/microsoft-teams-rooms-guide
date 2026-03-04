# Voice Isolation

## Overview

Voice isolation is advanced noise suppression that uses a personalized deep voice quality enhancement AI model to separate the enrolled user's voice from all other sounds and voices. It goes beyond standard noise suppression (which filters non-human noise) by filtering out other human voices — such as background chatter in a shared space.

## How It Works

The feature relies on the user's voice profile stored locally on their device. During a call or meeting, it removes any audio that does not match the enrolled profile. The local voice signature is encrypted, expires after 14 days, and is replaced with a new download.

## Configuration

Voice isolation requires two policies to be enabled:

```powershell
# 1. Enable voice enrollment (so users can create profiles)
Set-CsTeamsAIPolicy -Identity <PolicyName> -EnrollVoice Enabled

# 2. Enable voice isolation in meeting policy
Set-CsTeamsMeetingPolicy -Identity <PolicyName> -VoiceIsolation Enabled
```

Both are enabled by default at the Global (Org-wide default) level.

To disable:

```powershell
Set-CsTeamsMeetingPolicy -Identity <PolicyName> -VoiceIsolation Disabled
```

## Teams Rooms Considerations

- Voice isolation is **automatically turned off for BYOD meeting rooms and rooms audio** to avoid filtering out legitimate in-room speakers
- For dedicated Teams Rooms with Intelligent Speaker, voice isolation works per-user on their personal device (desktop/mobile), not on the room audio system itself
- The room microphone captures all in-room audio for transcription and speaker attribution; voice isolation applies only to the audio stream from a user's personal device

Users can toggle voice isolation on/off in the Teams app before or during a meeting via their audio settings.

## Related Topics

- [Copilot Overview](copilot-overview.md) — Copilot configuration and meeting policies
- [Intelligent Speaker](intelligent-speaker.md) — Speaker attribution and AI policies

## References

- [Manage voice isolation](https://learn.microsoft.com/en-us/microsoftteams/voice-isolation)
