# Audio Conferencing for Teams Rooms

## Overview

Both Teams Rooms Pro and Teams Rooms Basic include **Audio Conferencing** as a service plan. This means meetings scheduled in a room resource account's calendar can have dial-in phone numbers automatically included in the meeting invitation.

## How It Works

When Audio Conferencing is enabled on the resource account:

- Meetings organized by (or on behalf of) the resource account include a dial-in phone number and conference ID in the invitation
- External participants can call in to the meeting using the toll or toll-free number
- The room itself joins via its native Teams client, not via dial-in

Audio Conferencing is typically auto-configured when the Teams Rooms license is assigned.

## Configuration

```powershell
# Check audio conferencing settings
Get-CsOnlineDialInConferencingUser -Identity "confroom01@contoso.com"

# Set the default toll number
Set-CsOnlineDialInConferencingUser -Identity "confroom01@contoso.com" `
    -ServiceNumber "+12065551000"

# Set a toll-free number (requires Communications Credits)
Set-CsOnlineDialInConferencingUser -Identity "confroom01@contoso.com" `
    -TollFreeServiceNumber "+18005551000"
```

## Toll-Free Numbers

Toll-free dial-in numbers require **Communications Credits** to be funded on the tenant. Toll-free minutes are consumed from the Communications Credits balance.

## Related Topics

- [PSTN Overview](pstn-overview.md) — Full PSTN connectivity and licensing guide
- [Licensing](../01-planning/licensing.md) — Teams Rooms Pro vs Basic comparison

## References

- [Microsoft Teams Rooms licenses](https://learn.microsoft.com/en-us/microsoftteams/rooms/rooms-licensing)
- [Audio Conferencing in Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/audio-conferencing-in-office-365)
