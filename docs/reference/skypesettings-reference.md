# SkypeSettings.xml Reference

## Overview

SkypeSettings.xml is the local configuration file for Microsoft Teams Rooms on Windows. Despite the legacy name, it is the active configuration mechanism for the current Teams Rooms app (including the new Teams client, `ms-teams.exe`). The name has not changed.

When placed in the correct directory, the Teams Rooms app reads the file at startup, applies all settings, and **deletes the file**. This is a one-shot configuration mechanism — the file is consumed, not persistently read.

The Pro Management Portal uses SkypeSettings.xml under the hood. When you push settings from the portal, the management agent writes a SkypeSettings.xml to the device, restarts the app, and the app processes it identically to a manually placed file.

## File Location

The file path is the same for both the legacy and new Teams app:

```
C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\SkypeSettings.xml
```

This path is under the local `Skype` user profile — the kiosk account that runs the MTR app. The UWP package identity (`Microsoft.SkypeRoomSystem_8wekyb3d8bbwe`) has not changed with the new Teams client.

## File Format

```xml
<SkypeSettings>
  <!-- Settings go here as child elements -->
</SkypeSettings>
```

All settings are child elements of the root `<SkypeSettings>` element. You can include any combination of settings — you do not need to include every setting, only the ones you want to change.

## Settings Reference

### Account Sign-In

Used for initial resource account provisioning or re-authentication. The file is deleted after processing.

```xml
<SkypeSettings>
  <UserAccount>
    <SkypeSignInAddress>confroom1@contoso.com</SkypeSignInAddress>
    <Password>ResourceAccountPassword!</Password>
  </UserAccount>
</SkypeSettings>
```

| Element | Type | Description |
|---------|------|-------------|
| `<UserAccount>` | Container | Wrapper for credential elements |
| `<SkypeSignInAddress>` | String | UPN of the resource account |
| `<Password>` | String | Plaintext password for the resource account |

> **Security:** The password is stored in plaintext in the XML. The file is deleted after the app processes it, but it exists on disk briefly. For production deployments at scale, use the [Pro Management Portal Autologin](../04-intune-management/windows-autopilot.md#method-1-pro-management-portal-autologin-recommended) method or the [Set-MTRAutoLogin.ps1](../../scripts/intune/Set-MTRAutoLogin.ps1) script which retrieves passwords from Azure Key Vault at runtime.

### Meeting Platform

| Element | Type | Default | Description |
|---------|------|---------|-------------|
| `<TeamsMeetingsEnabled>` | Boolean | Disabled | Enable Teams meetings. Must be enabled. |
| `<SfbMeetingEnabled>` | Boolean | Disabled | **Deprecated.** SfB support removed in app 5.0.111.0 (April 2024). No functional effect. |
| `<IsTeamsDefaultClient>` | Boolean | Enabled | Teams is the default client. |

### Direct Guest Join (Third-Party Meetings)

```xml
<SkypeSettings>
  <WebExMeetingsEnabled>True</WebExMeetingsEnabled>
  <ZoomMeetingsEnabled>True</ZoomMeetingsEnabled>
  <GoogleMeetMeetingsEnabled>True</GoogleMeetMeetingsEnabled>
</SkypeSettings>
```

| Element | Type | Default | Description |
|---------|------|---------|-------------|
| `<WebExMeetingsEnabled>` | Boolean | Disabled | Cisco Webex Direct Guest Join |
| `<ZoomMeetingsEnabled>` | Boolean | Disabled | Zoom Direct Guest Join |
| `<GoogleMeetMeetingsEnabled>` | Boolean | Disabled | Google Meet DGJ. Added in app 5.5.129.0 (Feb 2026). |
| `<UseCustomInfoForThirdPartyMeetings>` | Boolean | Disabled | Use custom display name/email instead of room account |
| `<CustomDisplayNameForThirdPartyMeetings>` | String | — | Guest name shown in third-party meeting |
| `<CustomDisplayEmailForThirdPartyMeetings>` | String | — | Guest email shown in third-party meeting |

See [Direct Guest Join](../07-interop/direct-guest-join.md) for detailed configuration and Exchange prerequisites.

### Meeting Behavior

| Element | Type | Default | Description |
|---------|------|---------|-------------|
| `<AutoScreenShare>` | Boolean | — | HDMI ingest auto-shares to remote participants. If false, shows locally but requires manual share. |
| `<HideMeetingName>` | Boolean | — | Hides meeting names on console and front-of-room displays |
| `<AutoExitMeetingEnabled>` | Boolean | Disabled | Auto-leaves meeting if room is last participant |
| `<RequirePasscodeForAllTeamsMeetings>` | Boolean | Disabled | Requires meeting ID + passcode for all meetings. **Pro license required.** |
| `<RequirePasscodeForAllPrivateTeamsMeetings>` | Boolean | Disabled | Same but only for private meetings. **Pro license required.** |
| `<DisableTeamsAudioSharing>` | Boolean | false | Disables HDMI audio sharing to meeting |
| `<NoiseSuppressionDefault>` | String | — | `0` = Off (OEM mode only), `1` = High (suppresses all non-speech) |
| `<EnableDeviceEndToEndEncryption>` | Boolean | false | E2EE for 1:1 calls. Both parties must enable. |

### Proximity & Bluetooth

| Element | Type | Default | Description |
|---------|------|---------|-------------|
| `<BluetoothAdvertisementEnabled>` | Boolean | Enabled | Bluetooth beaconing for proximity join |
| `<AutoAcceptProximateMeetingInvitations>` | Boolean | Enabled | Auto-accept proximity-based meeting invitations |
| `<AllowRoomRemoteEnabled>` | Boolean | Enabled | Allow room remote control from personal devices |
| `<RoomQRcodeEnabled>` | Boolean | Enabled | Show QR code on home screen for quick join |
| `<QRCodeAutoAcceptProximateMeetingInvitations>` | Boolean | Enabled | Auto-accept QR code proximity invitations |

### Front Row & Display Layout

| Element | Type | Default | Description |
|---------|------|---------|-------------|
| `<FrontRowEnabled>` | Boolean | Enabled | Enable/disable Front Row layout |
| `<FrontRowVideoSize>` | String | `medium` | `small`, `medium`, or `large` |
| `<FrontRowPanelDefaults>` | String | — | Comma-separated pair (e.g., `3,2`). `1`=Hide, `2`=Chat, `3`=Raised hand |
| `<DefaultFoRExperience>` | Boolean | 0 | `0` = Gallery (default), `1` = Front Row |
| `<SingleFoRDefaultContentLayout>` | String | 1 | `0` = Content only, `1` = Content + people |
| `<DualScreenMode>` | Boolean | false | Enable dual screen mode |
| `<DuplicateIngestDefault>` | Boolean | — | Content on both screens in dual mode when out of meeting |
| `<SplitVideoLayoutsDisabled>` | Boolean | false | Dual-display only. Disables split gallery and Front Row. |
| `<RemoveFoRCalendar>` | Boolean | false | Remove calendar from front-of-room display |
| `<ShowMeetingChat>` | Boolean | Enabled | Meeting chat and chat bubbles |
| `<OpenMeetingChatByDefault>` | Boolean | Enabled | Auto-open chat panel in Gallery view |
| `<PrioritizeVideoParticipantsGallery>` | Boolean | Enabled | Video participants on main stage, audio on side rail |
| `<HideMeForAllLayouts>` | Boolean | false | Hide self-preview in all layouts |

### Display Resolution & Scaling

Resolution and scaling settings require `<EnableResolutionAndScalingSetting>` to be `true` before they take effect.

```xml
<SkypeSettings>
  <EnableResolutionAndScalingSetting>true</EnableResolutionAndScalingSetting>
  <MainFoRDisplay>
    <MainFoRDisplayResolution>3840,2160</MainFoRDisplayResolution>
    <MainFoRDisplayScaling>150</MainFoRDisplayScaling>
  </MainFoRDisplay>
</SkypeSettings>
```

| Element | Type | Default | Description |
|---------|------|---------|-------------|
| `<EnableResolutionAndScalingSetting>` | Boolean | Disabled | Must be true for resolution/scaling to apply |
| `<MainFoRDisplay>` | Container | — | Main (or right in dual mode) display settings |
| `<MainFoRDisplayResolution>` | String | — | `Width,Height` (e.g., `1920,1080` or `3840,2160`) |
| `<MainFoRDisplayScaling>` | Number | — | 100, 125, 150, 175, 200, 225, 250, 300 |
| `<ExtendedFoRDisplay>` | Container | — | Extended (left in dual mode) display settings |
| `<ExtendedFoRDisplayResolution>` | String | — | Same format as main display |
| `<ExtendedFoRDisplayScaling>` | Number | — | Same values as main display |

### Camera & IntelliFrame

| Element | Type | Default | Description |
|---------|------|---------|-------------|
| `<EnableCloudIntelliFrame>` | Boolean | Enabled | Cloud IntelliFrame feature toggle |
| `<EnableCIFOnByDefault>` | Boolean | Enabled | IntelliFrame enabled by default for remote participants |
| `<EnableCIFOnSupportedCamerasOnly>` | Boolean | Enabled | Restrict IntelliFrame to certified cameras |
| `<OemCameraControlsEnabled>` | Boolean | Enabled | OEM camera PTZ controls within meetings |
| `<EnableRoomPeopleCount>` | Boolean | Enabled | People counting via camera |
| `<EnableRoomCapacityNotification>` | Boolean | Enabled | Capacity warnings (requires Exchange room capacity + capable camera) |

### Peripherals

Peripheral settings must be wrapped in a `<Devices>` container. Device names must match exactly as shown in Windows Device Manager.

```xml
<SkypeSettings>
  <Devices>
    <MicrophoneForCommunication>Yealink UVC86 Microphone</MicrophoneForCommunication>
    <SpeakerForCommunication>Yealink UVC86 Speaker</SpeakerForCommunication>
    <DefaultSpeaker>Realtek Digital Output</DefaultSpeaker>
  </Devices>
</SkypeSettings>
```

| Element | Type | Description |
|---------|------|-------------|
| `<MicrophoneForCommunication>` | String | Device name for conference microphone |
| `<SpeakerForCommunication>` | String | Device name for conference speaker |
| `<DefaultSpeaker>` | String | Speaker for HDMI ingest audio playback |
| `<ContentCameraId>` | String | USB device instance path for content camera. Ampersands must be escaped as `&amp;` |
| `<ContentCameraInverted>` | Boolean | Camera is physically upside-down |
| `<ContentCameraEnhancement>` | Boolean | Digital whiteboard enhancement (edge detection, ink enhancement, transparent presenter). Default: true |

### Theming & Custom Backgrounds

```xml
<SkypeSettings>
  <Theming>
    <ThemeName>Custom</ThemeName>
    <CustomBackgroundMainFoRDisplay>lobby-background.png</CustomBackgroundMainFoRDisplay>
    <CustomBackgroundConsole>console-background.png</CustomBackgroundConsole>
  </Theming>
</SkypeSettings>
```

| Element | Type | Description |
|---------|------|-------------|
| `<ThemeName>` | String | Preset name or `Custom`. Use `No Theme` to clear. |
| `<CustomBackgroundMainFoRDisplay>` | String | PNG filename for main display. **Pro license, app 4.17+** |
| `<CustomBackgroundExtendedFoRDisplay>` | String | PNG filename for extended display (required if Custom + dual mode). **Pro license, app 4.17+** |
| `<CustomBackgroundConsole>` | String | PNG filename for touch console. Optional. **Pro license, app 4.17+** |
| `<CustomThemeImageUrl>` | String | Legacy (app 4.16 and earlier or Basic license). Filename only. |

**Available preset themes:** Default, Vivid Flag Default, Summer Summit, Seaside Bliss, Into The Fold, Creative Conservatory, Blue Wave, Digital Forest, Dreamcatcher, Limeade, Purple Paradise, Pixel Perfect, Roadmap, Sunset

Custom background PNG files must be placed in the same LocalState folder alongside the XML file. The Pro Management Portal cannot push custom background image files — you must deploy them via Intune PowerShell script or file copy.

### Coordinated Meetings

For rooms with multiple Teams Rooms devices or a Surface Hub working together:

```xml
<SkypeSettings>
  <CoordinatedMeetings enabled="true">
    <Settings>
      <Audio default="true" enabled="true" />
      <Video default="true" enabled="true" />
      <Whiteboard default="false" enabled="false" />
    </Settings>
    <TrustedAccounts>hub@contoso.com,secondroom@contoso.com</TrustedAccounts>
  </CoordinatedMeetings>
</SkypeSettings>
```

| Element | Type | Description |
|---------|------|-------------|
| `<CoordinatedMeetings enabled="">` | Container + attribute | Enable coordinated meetings |
| `<Audio default="" enabled="">` | Boolean attributes | Microphone control for this device in coordinated setup |
| `<Video default="" enabled="">` | Boolean attributes | Camera control |
| `<Whiteboard default="" enabled="">` | Boolean attributes | Whiteboard control |
| `<TrustedAccounts>` | String | Comma-separated UPNs of coordinated devices |

### Logging & Feedback

| Element | Type | Default | Description |
|---------|------|---------|-------------|
| `<EmailAddressForLogsAndFeedback>` | String | — | Email for "Report a problem" logs (in `<SendLogs>` container) |
| `<SendLogsAndFeedback>` | Boolean | — | Allow logs with feedback submissions (in `<SendLogs>` container) |
| `<SendFeedbackToPMP>` | Boolean | Enabled | Send feedback to Pro Management Portal |

### Other Feature Toggles

| Element | Type | Default | Description |
|---------|------|---------|-------------|
| `<EnablePublicPreview>` | Boolean | Disabled | Enroll device in Ring 3.6 Public Preview |
| `<RoomLanguageSwitchEnabled>` | Boolean | true | Allow end users to change console language |

## Pro Management Portal vs. SkypeSettings.xml

The Pro Management Portal and SkypeSettings.xml are not mutually exclusive — the portal writes SkypeSettings.xml to the device under the hood.

### Settings available in both

Most settings — meeting defaults, Front Row, Bluetooth/proximity, QR code, Direct Guest Join toggles, IntelliFrame, noise suppression, theming (presets only), resolution/scaling.

### Portal-only capabilities

- Digital Signage configuration (activation timers, signage source, banners)
- Bulk settings jobs across multiple rooms
- Settings job history and audit trail
- Captions and profanity filter toggles
- Autologin credential assignment (Planning > Autopilot devices)

### XML-only capabilities

- Account credentials (`<UserAccount>` block)
- Exact peripheral device names by string
- Custom background image file deployment (PNG files must be placed in LocalState)
- Coordinated meetings configuration

### Sync behavior

When settings are changed locally on the device (via touch console or manual XML placement), the PMP management agent syncs those changes back up to the portal within approximately 15 minutes. Changes pushed from the portal trigger an app restart and are applied within minutes.

## Deployment at Scale

### Method 1: Pro Management Portal (Recommended for Pro-licensed rooms)

For any setting that has a portal equivalent, the portal is the preferred method. It supports individual device settings, bulk settings jobs, scheduled maintenance windows, and full audit trails.

### Method 2: Intune PowerShell Scripts

The most common approach for settings that require XML delivery:

```powershell
# Example: Deploy via Intune PowerShell script
$xmlContent = @"
<SkypeSettings>
  <WebExMeetingsEnabled>True</WebExMeetingsEnabled>
  <ZoomMeetingsEnabled>True</ZoomMeetingsEnabled>
  <AutoScreenShare>True</AutoScreenShare>
  <BluetoothAdvertisementEnabled>True</BluetoothAdvertisementEnabled>
</SkypeSettings>
"@

$xmlPath = "C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\SkypeSettings.xml"
$xmlContent | Out-File -FilePath $xmlPath -Encoding UTF8 -Force

# Restart the MTR app to process the XML
Get-Process -Name "Microsoft.SkypeRoomSystem" -ErrorAction SilentlyContinue | Stop-Process -Force
```

Deploy this as an Intune PowerShell script (**Devices** > **Windows** > **Scripts**) targeting your MTR device group.

### Method 3: PowerShell Remoting

For individual devices or small batches:

```powershell
$session = New-PSSession -ComputerName "MTR-HQ-101" -Credential (Get-Credential)
Copy-Item -Path ".\SkypeSettings.xml" -Destination "C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\" -ToSession $session
Invoke-Command -Session $session -ScriptBlock {
    Get-Process -Name "Microsoft.SkypeRoomSystem" -ErrorAction SilentlyContinue | Stop-Process -Force
}
Remove-PSSession $session
```

## Troubleshooting

### Settings Not Applying

1. Verify the file is at the exact correct path (check for typos in the package name)
2. Confirm the file is valid XML (use `[xml](Get-Content $path)` to test parsing)
3. Check that the MTR app restarted after file placement
4. Look in the app logs for XML parsing errors:
   ```
   C:\Users\Skype\AppData\Local\Packages\Microsoft.SkypeRoomSystem_8wekyb3d8bbwe\LocalState\Logs\
   ```

### File Not Being Deleted

If the XML file persists after app restart, the app likely encountered a parsing error. Common causes:
- Unescaped ampersands in device paths (use `&amp;`)
- Invalid element names or values
- Malformed XML structure

### Special Characters

Escape XML special characters in values:
- `&` → `&amp;`
- `<` → `&lt;`
- `>` → `&gt;`
- `"` → `&quot;`
- `'` → `&apos;`

This is most commonly needed in `<ContentCameraId>` values which contain USB device paths with ampersands.

## Related Topics

- [Windows Autopilot](../04-intune-management/windows-autopilot.md) — Autologin configuration
- [Direct Guest Join](../07-interop/direct-guest-join.md) — Third-party meeting configuration
- [Pro Management Portal](../10-pro-management/portal-overview.md) — Cloud-based settings management
- [Autologin Script](../../scripts/intune/Set-MTRAutoLogin.ps1) — Production credential deployment
