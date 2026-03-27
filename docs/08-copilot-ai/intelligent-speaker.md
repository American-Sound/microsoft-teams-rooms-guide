# Intelligent Speaker and People Recognition

## Overview

Intelligent Speaker (also called speaker recognition or speaker attribution) identifies in-room participants in live transcription and meeting transcripts. Combined with Copilot, it enables accurate meeting summaries and Intelligent Recap that attribute statements to specific in-room speakers rather than lumping them all under "Room Audio."

## Voice and Face Enrollment

Users create biometric profiles in the Teams desktop app under **Settings** > **Recognition**:

1. **Voice profile** must be enrolled first. User reads a provided text passage into their microphone.
2. **Face profile** can be enrolled after voice profile. Uses the device camera.
3. Users can disenroll at any time, even if the admin policy subsequently disables enrollment.
4. Removing voice profile automatically removes face profile. Removing face profile leaves voice profile intact.

### Supported Languages for Voice Enrollment

en-us, en-gb, en-ca, en-in, en-au, en-nz, ar-sa, da-dk, de-de, es-es, es-mx, fi-fi, fr-ca, fr-fr, it-it, ja-jp, ko-kr, nb-no, nl-nl, pl-pl, pt-br, ru-ru, sv-se, zh-cn, zh-tw. No language requirement for face enrollment.

## Admin Configuration: CsTeamsAIPolicy

The `CsTeamsAIPolicy` provides granular control over biometric enrollment. This policy can only be managed via PowerShell: there is no Teams Admin Center UI for it.

### Parameters

| Parameter | Values | Default | Description |
|-----------|--------|---------|-------------|
| `-EnrollVoice` | `Enabled`, `Disabled` | `Enabled` | Controls voice profile enrollment |
| `-EnrollFace` | `Enabled`, `Disabled` | `Enabled` | Controls face profile enrollment |
| `-SpeakerAttributionBYOD` | `Enabled`, `Disabled` | `Enabled` | Speaker attribution in BYOD rooms |

### PowerShell Examples

```powershell
# Enable voice and face enrollment globally (default)
Set-CsTeamsAIPolicy -Identity Global -EnrollVoice Enabled -EnrollFace Enabled

# Disable all biometric enrollment globally
Set-CsTeamsAIPolicy -Identity Global -EnrollVoice Disabled -EnrollFace Disabled

# Create a custom policy for specific users
New-CsTeamsAIPolicy -Identity DisableBiometrics -EnrollVoice Disabled -EnrollFace Disabled
Grant-CsTeamsAIPolicy -PolicyName DisableBiometrics -Identity user@contoso.com

# Enable speaker attribution in BYOD scenarios
Set-CsTeamsAIPolicy -Identity Global -SpeakerAttributionBYOD Enabled

# View current policy settings
Get-CsTeamsAIPolicy -Identity Global
```

## Room-Level Configuration: RoomAttributeUserOverride

To enable Intelligent Speaker (people recognition) in Teams Rooms, set `RoomAttributeUserOverride` on the meeting policy assigned to the room resource account:

```powershell
Set-CsTeamsMeetingPolicy -Identity <RoomPolicyName> -RoomAttributeUserOverride Attribute
```

### SpeakerAttributionMode

Controls user-level speaker identification in transcription:

| Value | Behavior |
|-------|----------|
| `Enabled` | Speakers identified in transcription |
| `EnabledUserOverride` | Speakers identified, users can opt out |
| `DisabledUserOverride` | Speakers not identified by default, users can opt in |
| `Disabled` | Speaker names never shown |

```powershell
Set-CsTeamsMeetingPolicy -Identity Global -SpeakerAttributionMode Enabled
```

## Hardware Requirements

**No special microphones are needed.** All microphones included in certified Teams Rooms for Windows devices support Intelligent Speaker. Additional certified hardware devices can provide higher quality speaker identification.

For BYOD rooms, the room host must have either a Microsoft Teams Premium or Microsoft 365 Copilot license.

## Data Handling

- Voice and face data stored in the same region as the user's Teams data (data sovereignty compliant)
- Encrypted at rest and in transit
- Microsoft does not use profiles to train models
- Profiles auto-deleted after 1 year of non-use
- Voice isolation stores a local encrypted signature that expires after 14 days
- Not available in GCCH or DOD environments (available up to GCC)

## Related Topics

- [Copilot Overview](copilot-overview.md): How speaker attribution feeds into Copilot features
- [Facilitator](facilitator.md): Shared AI notes that use speaker identification
- [Voice Isolation](voice-isolation.md): Complementary audio processing policy
- [AI PowerShell Reference](powershell-reference.md): Complete CsTeamsAIPolicy cmdlet reference

## References

- [Voice and face enrollment overview](https://learn.microsoft.com/en-us/microsoftteams/rooms/voice-and-face-recognition)
- [Set-CsTeamsAIPolicy](https://learn.microsoft.com/en-us/powershell/module/microsoftteams/set-csteamsaipolicy)
- [Enable People Recognition on Teams Rooms](https://learn.microsoft.com/en-us/microsoftteams/rooms/teams-rooms-people-recognition)
