# Pexip CVI Integration

## Overview

Pexip's CVI integration connects legacy SIP and H.323 video conferencing endpoints to Microsoft Teams meetings. Pexip is also the only certified CVI partner that supports outbound SIP/H.323 calling from Teams Rooms devices.

## Architecture

Pexip's CVI consists of two main components:

**Pexip Infinity** — the on-premises or cloud-hosted MCU/gateway platform that handles SIP/H.323 call processing, transcoding, and routing.

**Pexip Teams Connector** — a dedicated application deployed in Microsoft Azure that handles all communication between Pexip Infinity and Microsoft Teams via Graph APIs.

The Teams Connector runs as a VM Scale Set (VMSS) behind an Azure Load Balancer, deployed using Pexip's PowerShell scripts. Pexip recommends a blue-green deployment strategy with separate production and test environments.

### Infrastructure Details

- Each Teams Connector instance handles approximately 15 concurrent VTC connections
- VM sizes: Standard_D4s_v5 (default), Standard_D4as_v5, Standard_F4s
- For GCC High: must deploy in Azure US Government, Arizona or Texas regions only (Virginia not supported)
- Dynamic resource group contains the VMSS (recreated on upgrades)
- Static resource group contains the load balancer, Key Vault, and persistent resources

## Dial-In Experience

Organizations configure a custom `*.onpexip.com` subdomain (or their own domain) as the calling domain.

**Two-stage dialing (IVR):** Dial `teams@customdomain.onpexip.com`. The Pexip Virtual Reception prompts for the Conference ID (9-13 digits, from the Teams meeting invite). After entering the ID, the user is connected.

**Direct dial:** Dial `<ConferenceID>@customdomain.onpexip.com` to bypass the IVR.

**One-touch dial:** Calendar-integrated rooms parse the meeting invite body and present a single "Join" button.

## Protocol Support

| Protocol | Maximum Video | Content Sharing |
|----------|--------------|-----------------|
| SIP | 1080p | VbSS, BFCP |
| H.323 | 720p | H.239 |

## Pexip Infinity Configuration

Key configuration steps on the Pexip Infinity side:

1. **Global Settings:** Enable "support for Pexip Infinity Connect clients and Client API" and "Enable PowerPoint Live" under Platform > Global settings

2. **Register Teams Tenant:** Under Call control > Microsoft Teams Tenants, add each Office 365 tenant ID (from Entra ID properties)

3. **Add Teams Connectors:** Under Call control > Microsoft Teams Connectors, point to the blue (production) and green (test) Teams Connector FQDNs in Azure

4. **Configure Call Routing Rules:** Set up rules matching Conference ID patterns (regex: `(\\d{9,13})(@example\\.com)?`) with priority ordering for enterprise/registered/guest callers

5. **Create Virtual Reception:** Under Services > Virtual Receptions, create a "Microsoft Teams" type reception with the alias matching the IVR parameter

6. **Assign Locations:** Under Platform > Locations, assign Teams Connectors as the default for outbound Teams calls

## Microsoft Tenant Configuration

After deploying the Teams Connector in Azure:

1. **Consent:** A Global Administrator clicks the consent link (provided by Pexip) to grant the CVI application permissions in the tenant

2. **PowerShell:** Run `New-CsVideoInteropServiceProvider` with the personalized parameters from Pexip, then `Grant-CsTeamsVideoInteropServicePolicy -PolicyName PexipServiceProviderEnabled -Global`

3. **DNS verification:** Verify at `https://dns.pexip.com/` that the custom domain resolves correctly

4. **Verify app ID:** Run `Get-CsVideoInteropServiceProvider` and confirm `AadApplicationIds` equals `923c9f0a-b883-4efe-af73-54810da59f83`

## SIP Guest Join (SGJ)

Pexip supports SIP Guest Join, allowing VTC endpoints to join external Teams meetings hosted by other organizations that don't have CVI deployed. The VTC connects through your Pexip infrastructure, which bridges into the remote tenant's meeting.

## Authentication

Pexip's Teams Connector has shifted to **certificate-based authentication (CBA)** as the default method for authenticating against Microsoft Graph, with password-based authentication planned for deprecation.

## References

## Related Topics

- [Cloud Video Interop](cloud-video-interop.md) — CVI overview and PowerShell setup
- [SIP/H.323 Dialing](sip-h323-dialing.md) — Outbound SIP calling from Teams Rooms (Pexip-exclusive)
- [Interop Comparison](comparison.md) — CVI vs DGJ vs SIP feature matrix

## References

- [About Pexip's Microsoft Teams CVI integration](https://help.pexip.com/service/teams-integration.htm)
- [Microsoft Teams setup for Pexip CVI](https://help.pexip.com/service/teams-setup.htm)
- [Installing the Teams Connector in Azure](https://docs.pexip.com/admin/teams_connector.htm)
- [Configuring Pexip Infinity as a Microsoft Teams gateway](https://docs.pexip.com/admin/teams_configuration.htm)
- [Pexip CVI product page](https://www.pexip.com/products/connect/teams)
