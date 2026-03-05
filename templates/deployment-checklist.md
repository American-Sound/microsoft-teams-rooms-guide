# Microsoft Teams Rooms Deployment Checklist

## Room Information

| Field | Value |
|-------|-------|
| Room Name | |
| Building | |
| Floor | |
| Capacity | |
| Resource Account UPN | |
| Device Serial Number | |
| Deployment Date | |
| Deployed By | |

---

## Pre-Deployment

### Account Preparation
- [ ] Resource account created
- [ ] Display name configured correctly
- [ ] Password documented securely
- [ ] Password set to never expire
- [ ] Usage location set
- [ ] Teams Rooms license assigned (Pro/Basic)
- [ ] Calendar processing configured
- [ ] Added to MTR security group
- [ ] Excluded from MFA Conditional Access policies

### Network Preparation
- [ ] Network drop installed and tested
- [ ] Switch port configured (VLAN, PoE)
- [ ] Firewall rules allow Teams traffic
- [ ] QoS policies configured
- [ ] DNS resolves Microsoft endpoints

### Intune/Autopilot (if applicable)
- [ ] Device registered in Autopilot
- [ ] Group tag assigned (MTR)
- [ ] Autopilot profile assigned
- [ ] Compliance policy assigned
- [ ] Configuration profiles assigned

---

## Physical Deployment

### Hardware Installation
- [ ] Mount position verified
- [ ] Display mounted/positioned
- [ ] Camera mounted (correct height/angle)
- [ ] Touch console positioned
- [ ] Cables routed cleanly
- [ ] Labels applied

### Connections
- [ ] Ethernet connected
- [ ] Display HDMI connected
- [ ] Camera USB connected
- [ ] Audio USB connected
- [ ] Touch console connected
- [ ] Power connected

---

## Initial Configuration

### Power On
- [ ] Device powers on
- [ ] Autopilot/OOBE completes (if applicable)
- [ ] Joins Entra ID
- [ ] Enrolls in Intune

### Account Sign-In
- [ ] Resource account signed in successfully
- [ ] No MFA prompts encountered
- [ ] Calendar loads correctly
- [ ] Room name displays correctly

### Settings Configuration
- [ ] Theme/branding set
- [ ] Camera settings configured
- [ ] Audio settings configured
- [ ] Display settings configured
- [ ] Bluetooth beaconing enabled (if desired)

---

## Testing

### Audio/Video
- [ ] Microphone test passed
- [ ] Speaker test passed
- [ ] Camera preview working
- [ ] Correct devices selected as default

### Meeting Functionality
- [ ] Can join ad-hoc Teams meeting
- [ ] One-touch join works for scheduled meetings
- [ ] Content sharing works
- [ ] Remote participants can see/hear room
- [ ] Room can see/hear remote participants

### Peripheral Testing
- [ ] Touch console responsive
- [ ] Front-of-room display working
- [ ] Content input working (if applicable)

---

## Post-Deployment Verification

### Admin Portal Verification
- [ ] Device appears in Pro Management Portal (Windows MTR) or Teams Admin Center (Android)
- [ ] Device shows as Online/Healthy in PMP
- [ ] Device appears in Intune (if enrolled)
- [ ] Compliance state is Compliant
- [ ] Pro Management Portal shows device (if Pro licensed)

### Documentation
- [ ] Serial number recorded
- [ ] IP address documented
- [ ] Configuration documented
- [ ] Credentials stored securely
- [ ] User training completed (if applicable)

---

## Sign-Off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| IT Deployer | | | |
| Facilities | | | |
| End User/Owner | | | |

---

## Notes

_Add any deployment notes, issues encountered, or special configurations here._

```




```
