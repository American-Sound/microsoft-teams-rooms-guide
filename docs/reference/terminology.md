# Terminology and Glossary

## A

**AOSP (Android Open Source Project)**
: The open-source version of Android used for corporate device management without Google Mobile Services. Used for Android Teams Rooms enrollment in Intune.

**Autopilot (Windows Autopilot)**
: Microsoft's zero-touch deployment technology that configures Windows devices automatically when first powered on and connected to the internet.

**Autologin**
: The process of automatically signing in a Teams Rooms resource account (the Microsoft 365 account, not the Windows local account). The recommended method is via the Pro Management Portal's Autopilot integration, which delivers credentials through the cloud with no local plaintext files. The legacy method uses SkypeSettings.xml with `<UserAccount>` credentials. Not to be confused with Windows autologon, which is the separate OEM-configured mechanism that boots the device into the local `Skype` kiosk account.

## B

**BitLocker**
: Windows disk encryption technology. Recommended for Teams Rooms compliance policies.

## C

**CVI (Cloud Video Interop)**
: Microsoft-qualified third-party solution enabling legacy SIP/H.323 video conferencing devices to join Teams meetings.

**CA (Conditional Access)**
: Microsoft Entra ID feature that controls access to cloud resources based on conditions like user, device, location, and risk level.

**Calendar Processing**
: Exchange settings that control how room mailboxes handle meeting requests, including automatic acceptance and booking rules.

**Compliance Policy**
: Intune policy defining security requirements that devices must meet to be considered compliant.

**Configuration Profile**
: Intune policy that configures device settings, features, and behaviors.

**Content Camera**
: Specialized camera that captures and digitally enhances physical whiteboards for sharing in Teams meetings.

**Coordinated Meetings**
: Feature allowing Teams Rooms and Panels to work together, sharing status and control.

## D

**DGJ (Direct Guest Join)**
: WebRTC-based capability allowing Teams Rooms to join third-party meetings (Webex, Zoom, Google Meet) natively.

**Device Code Flow**
: Authentication method where users enter a code on another device to sign in. Used for some Teams Rooms scenarios.

**DSCP (Differentiated Services Code Point)**
: Network packet marking used for QoS to prioritize voice and video traffic.

**Dynamic Group**
: Entra ID group where membership is determined automatically by rules based on user or device attributes.

## E

**Entra ID (Microsoft Entra ID)**
: Microsoft's cloud identity and access management service (formerly Azure Active Directory).

**ESP (Enrollment Status Page)**
: Windows Autopilot feature showing deployment progress and blocking use until configuration completes.

**Exchange Online**
: Microsoft's cloud-based email and calendar service. Hosts Teams Rooms resource accounts.

## F

**Facilitator**
: AI-powered meeting agent that provides shared AI-generated notes, agenda tracking, and Q&A visible to all meeting participants on the front-of-room display. Requires M365 Copilot license.

**Front Row**
: Teams Rooms display layout that positions video participants at eye level with content above, optimizing hybrid meeting experience.

## G

**GCC (Government Community Cloud)**
: Microsoft 365 environment for US government customers.

**Graph API (Microsoft Graph)**
: Unified API for accessing Microsoft 365 services, including user and device management.

## H

**Hardware ID (HWID)**
: Unique identifier for Windows devices used for Autopilot registration.

**Hybrid Entra ID Join**
: Device joined to both on-premises Active Directory and Entra ID.

## I

**Intelligent Speaker**
: Capability that identifies individual in-room speakers in meeting transcription using voice and face profiles. Supported by all certified Teams Rooms microphones.

**Intune**
: Microsoft's cloud-based device management service for PCs, mobile devices, and Teams Rooms.

## L

**LAPS (Local Administrator Password Solution)**
: Microsoft solution that automatically manages and rotates local administrator passwords on Entra ID-joined or Hybrid Entra ID-joined devices. Passwords are stored in Entra ID and retrievable by authorized administrators. Supported and recommended on Teams Rooms on Windows. See [LAPS Configuration](../03-security/laps-configuration.md).

**Live Response**
: MDE capability allowing remote shell access to managed devices for investigation and forensic data collection.

## M

**MDM (Mobile Device Management)**
: Technology for managing and securing mobile devices and PCs. Intune is Microsoft's MDM solution.

**MDE (Microsoft Defender for Endpoint)**
: Enterprise endpoint security platform providing EDR, TVM, and antivirus capabilities. On Teams Rooms, reporting is fully supported but protection rules (ASR Block mode, Network Protection enforcement) are not recommended. See [Defender for Endpoint](../03-security/defender-endpoint.md).

**MTR (Microsoft Teams Rooms)**
: Meeting room solution running Teams on dedicated hardware.

**MFA (Multi-Factor Authentication)**
: Authentication requiring multiple verification methods. Not supported interactively on MTR devices.

## N

**Named Location**
: Conditional Access feature defining trusted IP ranges or countries/regions.

## O

**OMA-URI**
: Open Mobile Alliance Uniform Resource Identifier. Used for custom Intune device configuration settings.

**One-Touch Join**
: Feature allowing meeting join with single tap on room device when meeting appears on calendar.

## M (continued)

**MTMP (Multi-Tenant Management Portal)**
: Partner version of the Pro Management Portal enabling MSPs to manage Teams Rooms across multiple customer tenants from a single interface.

## P

**PMP (Pro Management Portal)**
: The Teams Rooms Pro Management portal at portal.rooms.microsoft.com. Primary management surface for Teams Rooms on Windows (and transitioning for Android).

**PoE (Power over Ethernet)**
: Technology providing electrical power over Ethernet cables. Used for touch consoles and panels.

**Pro Management Portal**
: Advanced management portal for Teams Rooms Pro licensed devices at portal.rooms.microsoft.com.

**Proximity Join**
: Feature using Bluetooth to detect nearby meetings and enable easy join from room device.

## Q

**QoS (Quality of Service)**
: Network features prioritizing specific traffic types for better call quality.

## R

**Resource Account**
: Exchange room mailbox and associated Entra ID account representing a meeting room.

**Room List**
: Exchange distribution group organizing room mailboxes by location for easier discovery.

**Room Mailbox**
: Exchange mailbox type specifically for meeting rooms, supporting calendar booking features.

## S

**ROPC (Resource Owner Password Credentials)**
: OAuth 2.0 grant type used by Teams Rooms for non-interactive authentication. The app sends the resource account username and password directly to Entra ID without user interaction. Does not support MFA.

**Self-Deploying Mode**
: Autopilot deployment mode requiring no user interaction, ideal for shared devices like Teams Rooms.

**Shell Launcher V2**
: Windows kiosk configuration that replaces the Windows shell (Start menu, taskbar, Settings) with the Teams Rooms app for the local `Skype` user account. Part of the OEM image on certified MTR-W devices.

**SkypeSettings.xml**
: Local configuration file for Teams Rooms on Windows. Despite the legacy name, it is the active configuration mechanism for the current Teams app. Placed in the MTR app's LocalState directory, processed at app startup, and deleted after consumption. The Pro Management Portal writes SkypeSettings.xml under the hood. See [SkypeSettings.xml Reference](skypesettings-reference.md).

**Service Account**
: Account used by services rather than interactive users. Resource accounts are a type of service account.

**SBC (Session Border Controller)**
: Network device that mediates SIP signaling and media between an enterprise network and a PSTN provider. Required for Direct Routing.

**SIP Address**
: Session Initiation Protocol address used for Teams communications, typically matching the UPN.

**Surface Hub**
: Microsoft's all-in-one collaborative meeting device with whiteboarding capabilities.

## T

**TAC (Teams Admin Center)**
: Web portal for managing Teams policies, users, phone numbers, and Call Quality Dashboard (CQD) at admin.teams.microsoft.com. Device management for Android MTR, Panels, and Phones (transitioning to PMP through 2026). Windows MTR device management moved to the Pro Management Portal in June 2025.

**Teams Panels**
: Wall-mounted touchscreen devices showing room availability outside meeting rooms.

**Teams Rooms Basic**
: Free license tier for up to 25 Teams Rooms devices with basic features. Intended for pilot and proof-of-concept use only — not recommended for production deployments.

**Teams Rooms Pro**
: Premium license providing full Teams Rooms features including Pro Management Portal.

**Touch Console**
: Tabletop touchscreen device used to control Teams Rooms meetings.

**TPM (Trusted Platform Module)**
: Security chip providing hardware-based security functions. Required for Autopilot self-deploying mode.

## U

**UPN (User Principal Name)**
: User identifier in email format (user@domain.com) used for sign-in.

**UVC (USB Video Class)**
: Standard for USB video devices ensuring compatibility without special drivers.

## V

**VLAN (Virtual Local Area Network)**
: Network segmentation technology. Recommended for isolating Teams Rooms devices.

## W

**Windows IoT Enterprise**
: Windows edition designed for specialized devices including Teams Rooms.

**WPA2/WPA3-Enterprise**
: Wi-Fi security protocols using RADIUS authentication for corporate networks.

## Z

**Zero-Touch Deployment**
: Device deployment requiring no manual IT intervention, achieved through Autopilot and Autologin.
