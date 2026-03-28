# AI and Copilot PowerShell Reference

## Complete Configuration Script

```powershell
# Connect to Teams PowerShell
Connect-MicrosoftTeams

# --- Step 1: Configure Global AI Policy ---
Set-CsTeamsAIPolicy -Identity Global `
    -EnrollVoice Enabled `
    -EnrollFace Enabled `
    -SpeakerAttributionBYOD Enabled

# --- Step 2: Create a meeting policy for Teams Rooms ---
New-CsTeamsMeetingPolicy -Identity "MTR-AIEnabled"

Set-CsTeamsMeetingPolicy -Identity "MTR-AIEnabled" `
    -Copilot EnabledWithTranscriptDefaultOn `
    -AllowTranscription $true `
    -AllowCloudRecording $true `
    -VoiceIsolation Enabled `
    -RoomAttributeUserOverride Attribute `
    -SpeakerAttributionMode Enabled

# --- Step 3: Assign meeting policy to room resource accounts ---
Grant-CsTeamsMeetingPolicy -Identity "roomaccount@contoso.com" `
    -PolicyName "MTR-AIEnabled"

# --- Step 4: Create a policy for users who should NOT have biometric enrollment ---
New-CsTeamsAIPolicy -Identity "NoBiometrics" `
    -EnrollVoice Disabled `
    -EnrollFace Disabled
Grant-CsTeamsAIPolicy -PolicyName "NoBiometrics" `
    -Identity "restricteduser@contoso.com"

# --- Step 5: Verify policies ---
Get-CsTeamsAIPolicy -Identity Global
Get-CsTeamsMeetingPolicy -Identity "MTR-AIEnabled"
```

## CsTeamsAIPolicy Cmdlets

| Cmdlet | Purpose |
|--------|---------|
| `Set-CsTeamsAIPolicy` | Modify an existing Teams AI policy |
| `New-CsTeamsAIPolicy` | Create a new custom Teams AI policy |
| `Get-CsTeamsAIPolicy` | Retrieve current policy settings |
| `Grant-CsTeamsAIPolicy` | Assign a policy to a specific user |
| `Remove-CsTeamsAIPolicy` | Delete a custom Teams AI policy |

### Set-CsTeamsAIPolicy Parameters

```
-Identity <String>              # Policy name (Global or custom)
-EnrollVoice <String>           # Enabled | Disabled (default: Enabled)
-EnrollFace <String>            # Enabled | Disabled (default: Enabled)
-SpeakerAttributionBYOD <String> # Enabled | Disabled (default: Enabled)
-Description <String>           # Optional description
```

## CsTeamsMeetingPolicy: AI-Relevant Parameters

```powershell
Set-CsTeamsMeetingPolicy -Identity <PolicyName> `
    -Copilot <String>                    # Enabled | EnabledWithTranscript |
                                          # EnabledWithTranscriptDefaultOn | Disabled
    -AllowTranscription <Boolean>        # $true | $false
    -AllowCloudRecording <Boolean>       # $true | $false
    -VoiceIsolation <String>             # Enabled | Disabled
    -RoomAttributeUserOverride <String>  # Attribute | Off
    -RoomPeopleNameUserOverride <String> # On | Off
    -SpeakerAttributionMode <String>     # Enabled | EnabledUserOverride |
                                          # DisabledUserOverride | Disabled
    -LiveCaptionsEnabledType <String>    # DisabledUserOverride | Disabled
```

## Related Topics

- [Copilot Overview](copilot-overview.md): License tiers and meeting policy configuration
- [Intelligent Speaker](intelligent-speaker.md): Voice/face enrollment details
- [AI Policy Script](../../scripts/copilot-ai/Set-MTRAIPolicy.ps1): Automated AI configuration script

## References

- [Set-CsTeamsAIPolicy](https://learn.microsoft.com/en-us/powershell/module/microsoftteams/set-csteamsaipolicy)
- [Set-CsTeamsMeetingPolicy](https://learn.microsoft.com/en-us/powershell/module/microsoftteams/set-csteamsmeetingpolicy)
- [New-CsTeamsAIPolicy](https://learn.microsoft.com/en-us/powershell/module/microsoftteams/new-csteamsaipolicy)
- [Grant-CsTeamsAIPolicy](https://learn.microsoft.com/en-us/powershell/module/microsoftteams/grant-csteamsaipolicy)
