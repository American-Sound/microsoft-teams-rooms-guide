# Microsoft Teams Rooms Deployment Guide

Comprehensive deployment guide, scripts, and best practices for Microsoft Teams Rooms on Windows and Android. From zero to fully managed meeting rooms.

## Overview

This repository consolidates documentation and automation tools for deploying and managing Microsoft Teams Rooms (MTR). Whether you're deploying a single room or hundreds across multiple locations, this guide provides the knowledge and scripts you need.

## Quick Navigation

### Documentation

| Section | Description |
|---------|-------------|
| [Planning](docs/01-planning/) | Platform comparison, licensing, hardware, and network requirements |
| [Prerequisites](docs/02-prerequisites/) | Entra ID setup, resource accounts, licensing, Exchange configuration |
| [Security](docs/03-security/) | Conditional Access, MFA, compliance, Defender for Endpoint, LAPS |
| [Intune Management](docs/04-intune-management/) | Enrollment, Autopilot, AOSP, configuration profiles |
| [Deployment](docs/05-deployment/) | Step-by-step deployment guides for all platforms |
| [Post-Deployment](docs/06-post-deployment/) | Monitoring, updates, troubleshooting |
| [Interoperability](docs/07-interop/) | CVI, Pexip, SIP/H.323 dialing, Direct Guest Join |
| [Copilot & AI](docs/08-copilot-ai/) | Copilot, Facilitator, Intelligent Speaker, transcription, Foundry agents |
| [Teams Phone](docs/09-teams-phone/) | PSTN calling, audio conferencing, emergency calling |
| [Pro Management Portal](docs/10-pro-management/) | Health monitoring, updates, analytics, partner portal |
| [Reference](docs/reference/) | Terminology, SkypeSettings.xml reference, supported policies, official links, FAQ |

### Scripts

| Category | Description |
|----------|-------------|
| [Account Scripts](scripts/accounts/) | Create and manage resource accounts |
| [Licensing Scripts](scripts/licensing/) | License assignment and reporting |
| [Conditional Access](scripts/entra-conditional-access/) | CA policy management |
| [Intune Scripts](scripts/intune/) | Autopilot, compliance, enrollment |
| [Interop Scripts](scripts/interop/) | CVI provider and policy configuration |
| [Copilot & AI Scripts](scripts/copilot-ai/) | AI policy and Copilot configuration |
| [Teams Phone Scripts](scripts/teams-phone/) | Phone number and calling policy assignment |
| [Teams Policies Scripts](scripts/teams-policies/) | Meeting policy configuration |
| [Validation Scripts](scripts/validation/) | Pre/post deployment validation |

### Templates & Examples

- [Resource Accounts CSV](templates/resource-accounts.csv) - Bulk account creation template
- [Autopilot Devices CSV](templates/autopilot-devices.csv) - Hardware ID import template
- [Deployment Checklist](templates/deployment-checklist.md) - Printable deployment checklist
- [Policy Examples](examples/) - CA and compliance policy JSON exports

## Getting Started

### Reading Order for New Deployments

If you're deploying Teams Rooms for the first time, follow these sections in order — each one builds on the previous:

1. **Plan** — Start with [Overview](docs/01-planning/overview.md) to understand the platform, then [Licensing](docs/01-planning/licensing.md) to determine Pro vs Basic. Review [Hardware](docs/01-planning/hardware-requirements.md) and [Network](docs/01-planning/network-requirements.md) requirements for your environment.
2. **Prepare** — Set up [Entra ID](docs/02-prerequisites/entra-id-setup.md), create [Resource Accounts](docs/02-prerequisites/resource-accounts.md), assign [Licenses](docs/02-prerequisites/licensing-assignment.md), and configure [Exchange](docs/02-prerequisites/exchange-configuration.md).
3. **Secure** — Configure [Conditional Access](docs/03-security/conditional-access.md) (exclude rooms from MFA), set up [Compliance Policies](docs/03-security/device-compliance.md), and optionally deploy [Defender for Endpoint](docs/03-security/defender-endpoint.md) and [LAPS](docs/03-security/laps-configuration.md).
4. **Set Up Intune** — Configure [Enrollment](docs/04-intune-management/enrollment-overview.md), create [Autopilot Profiles](docs/04-intune-management/windows-autopilot.md), and build [Configuration Profiles](docs/04-intune-management/configuration-profiles.md).
5. **Deploy** — Follow [Zero-Touch Deployment](docs/05-deployment/zero-touch-deployment.md) for Autopilot or [Windows Deployment](docs/05-deployment/windows-deployment.md) for manual setup.
6. **Manage** — Set up [Monitoring](docs/06-post-deployment/monitoring-alerting.md) and learn the [Pro Management Portal](docs/10-pro-management/portal-overview.md) for ongoing operations.

### If You Need a Specific Feature

Sections 07-10 are standalone topics — read them when you need them, not necessarily in order:

| Need | Start Here |
|------|------------|
| Rooms joining Webex/Zoom/Google Meet | [Direct Guest Join](docs/07-interop/direct-guest-join.md) |
| Legacy VTCs joining Teams meetings | [Cloud Video Interop](docs/07-interop/cloud-video-interop.md) |
| Choosing between interop methods | [Interop Comparison](docs/07-interop/comparison.md) |
| Copilot or AI features in rooms | [Copilot Overview](docs/08-copilot-ai/copilot-overview.md) |
| PSTN calling from a room | [PSTN Overview](docs/09-teams-phone/pstn-overview.md) |
| Managing rooms at scale | [Pro Management Portal](docs/10-pro-management/portal-overview.md) |
| Managing rooms across client tenants | [Multi-Tenant Partner Portal](docs/10-pro-management/multi-tenant-partner.md) |
| SkypeSettings.xml configuration | [SkypeSettings.xml Reference](docs/reference/skypesettings-reference.md) |
| Quick answers | [FAQ](docs/reference/faq.md) |
| Terminology you don't recognize | [Glossary](docs/reference/terminology.md) |

### Quick Start with Scripts

```powershell
# Install required modules
Install-Module Microsoft.Graph -Scope CurrentUser
Install-Module ExchangeOnlineManagement -Scope CurrentUser
Install-Module MicrosoftTeams -Scope CurrentUser

# Connect to services
Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "Directory.ReadWrite.All"
Connect-ExchangeOnline

# Check prerequisites
.\scripts\validation\Test-MTRPrerequisites.ps1

# Create a single resource account
.\scripts\accounts\New-MTRResourceAccount.ps1 -DisplayName "HQ-Conf-101" -UserPrincipalName "mtr-hq-101@contoso.com"

# Or bulk create from CSV
.\scripts\accounts\New-MTRResourceAccountsBulk.ps1 -CsvPath ".\templates\resource-accounts.csv"
```

## Platform Support

| Platform | Documentation | Scripts |
|----------|---------------|---------|
| Teams Rooms on Windows | Full | Full |
| Teams Rooms on Android | Full | Partial |
| Teams Panels | Included | N/A |
| Surface Hub | Included | N/A |

## Documentation Structure

```
docs/
├── 01-planning/           # What to consider before deployment
│   ├── overview.md        # MTR platform overview
│   ├── licensing.md       # Pro vs Basic, costs
│   ├── hardware-requirements.md
│   └── network-requirements.md
│
├── 02-prerequisites/      # What to set up before deployment
│   ├── entra-id-setup.md
│   ├── resource-accounts.md
│   ├── licensing-assignment.md
│   └── exchange-configuration.md
│
├── 03-security/           # Security configuration
│   ├── conditional-access.md
│   ├── mfa-considerations.md
│   ├── device-compliance.md
│   ├── defender-endpoint.md
│   └── laps-configuration.md
│
├── 04-intune-management/  # Device management
│   ├── enrollment-overview.md
│   ├── windows-autopilot.md
│   ├── android-aosp.md
│   ├── configuration-profiles.md
│   └── compliance-policies.md
│
├── 05-deployment/         # Step-by-step deployment
│   ├── windows-deployment.md
│   ├── android-deployment.md
│   ├── surface-hub.md
│   ├── teams-panels.md
│   └── zero-touch-deployment.md
│
├── 06-post-deployment/    # Ongoing management
│   ├── teams-admin-center.md
│   ├── monitoring-alerting.md
│   ├── updates-maintenance.md
│   └── troubleshooting.md
│
├── 07-interop/            # Video interoperability
│   ├── cloud-video-interop.md
│   ├── pexip-cvi.md
│   ├── sip-h323-dialing.md
│   ├── direct-guest-join.md
│   └── comparison.md
│
├── 08-copilot-ai/         # Copilot and AI features
│   ├── copilot-overview.md
│   ├── facilitator.md
│   ├── intelligent-speaker.md
│   ├── voice-isolation.md
│   ├── foundry-agents.md
│   └── powershell-reference.md
│
├── 09-teams-phone/        # PSTN calling
│   ├── pstn-overview.md
│   ├── calling-policies.md
│   ├── emergency-calling.md
│   ├── audio-conferencing.md
│   └── end-to-end-setup.md
│
├── 10-pro-management/     # Pro Management Portal
│   ├── portal-overview.md
│   ├── health-monitoring.md
│   ├── update-management.md
│   ├── analytics-reporting.md
│   ├── rbac.md
│   ├── servicenow-integration.md
│   ├── ai-assistant.md
│   └── multi-tenant-partner.md
│
└── reference/             # Reference materials
    ├── terminology.md
    ├── skypesettings-reference.md
    ├── supported-policies.md
    ├── microsoft-learn-links.md
    └── faq.md
```

## Prerequisites

### Required Licenses

- Microsoft 365 tenant
- Teams Rooms Pro or Basic license (per room)
- Intune license (for device management)
- Entra ID P1 or P2 (for Conditional Access)

### Required PowerShell Modules

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Install-Module ExchangeOnlineManagement -Scope CurrentUser
Install-Module MicrosoftTeams -Scope CurrentUser
```

### Required Permissions

- User Administrator (resource account creation)
- Exchange Administrator (mailbox configuration)
- Teams Administrator (Teams settings)
- Intune Administrator (device management)
- Conditional Access Administrator (CA policies)

## Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

### Ways to Contribute

- Report issues or suggest improvements
- Submit pull requests for documentation updates
- Share scripts or automation tools
- Provide feedback on existing content

## License

This project is licensed under the MIT License - see [LICENSE](LICENSE) for details.

## Disclaimer

This is a community resource and is not officially affiliated with or endorsed by Microsoft. Always refer to [official Microsoft documentation](https://learn.microsoft.com/microsoftteams/rooms/) for the most current information.

## Resources

- [Microsoft Teams Rooms Documentation](https://learn.microsoft.com/microsoftteams/rooms/)
- [Teams Rooms Certified Devices](https://learn.microsoft.com/microsoftteams/rooms/certified-hardware)
- [Microsoft Tech Community - Teams](https://techcommunity.microsoft.com/t5/microsoft-teams/ct-p/MicrosoftTeams)

---

**Topics:** microsoft-teams, teams-rooms, intune, autopilot, conditional-access, powershell, entra-id, meeting-rooms, deployment
