# Home Network, Home Lab, & Smart Home Setup
This repo contains detailed information about my technical projects, including configurations, scripts, and documentation for my home setup.

## Table of Contents
1. [Introduction](#introduction)
2. [Network Architecture](#network-architecture)
3. [Home Lab Architecture](#home-lab-architecture)
4. [Security Cameras & NVR](#security-cameras-and-nvr)
5. [Smart Home Automation](#smart-home-automation)

## Introduction
This repo showcases my integrated home network, lab, security, and automation setup. This is meant to document my network for personal use, highlight my technical expertise across various domains, and represent my dedication to continued learning. The various domains covered are: 
1. Network Architecture: Designed for high performance and security with segmented VLANs, custom firewall rules, and automated VLAN device assignment
2. Home Lab Architecture: A versatile lab environment featuring a server with Proxmox VE virtualization, extensive NAS storage, and diverse network configurations for technical projects and experimentation
3. Security Cameras & Network Video Recorder (NVR): A security system integrated with multiple IP cameras feeding a centralized NVR over RTSP for comprehensive monitoring and secure access without internet exposure
4. Smart Home Automation: Enhanced convenience through integrated smart devices and platforms for automating tasks and allowing for seamless control.

## Network Architecture
### Diagram
**Figure 1.** <br />
*Baseline home network diagram*
![Baseline home network diagram](/assets/images/Baseline_H_Network.png)
Note. IP addresses omitted.

### Hardware
- Cyberpower uninterruptable power supply (UPS) for power redundancy
- Internet service provider (ISP) provided modem
- Ubiquiti router/switch

### Network Zoning and Segmentation
#### Network Zones
- Trusted Zone: Contains critical and personal devices with the highest security requirements
- Semi-trusted Zone: Contains devices with moderate security requirements. These devices are important, but may have some vulnerabilities or limited security controls.
- Untrusted Zone: Contains devices with the lowest level of trust, primarily guest devices and IoT devices which may contain many vulnerabilities and no security controls.

#### VLANs & Segmentation
In my home network, I've opted for 5 virtual local area networks (VLANs) to support segmentation of devices [(M1030)](https://attack.mitre.org/mitigations/M1030/) as follows: <br />
Table 1. <br />
*VLANs*
| VLAN  | Network Zone | Devices | Configurations |
| ------------- | ------------- | ------------- | ------------- |
| VLAN1: Personal Devices  | Trusted zone  | Personal computers & smartphones | --- |
| VLAN20: Guest Devices  | Untrusted zone  | Guests' laptops, smartphones, & other devices | Guest network: enabled <br />Client device isolation: enabled |
| VLAN30: IoT Devices  | Untrusted zone  | Smart TVs; smart hubs; smart plugs; smart lights; etc. | Isolate network: enabled |
| VLAN40: Cameras  | Semi-trusted zone  | IP cameras; NVR | Isolate network: enabled <br />Allow internet access: disabled [(M1035)](https://attack.mitre.org/mitigations/M1035/) |
| VLAN50: Home Lab  | Semi-trusted zone  | Mini-PC servers; network attached storage (NAS); etc. | --- |

### WiFi
At the time of this push, there are 2 WiFi SSIDs as follows: 
- Main network
  - Secured w/ WPA-2 to allow for the use of private pre-shared keys (PPSKs) [(M1041)](https://attack.mitre.org/mitigations/M1041/)
  - Uses PPSKs to connect devices to their applicable VLAN (not including VLAN20: Guest devices)
- Guest network
  - Allows for guests to connect directly to the Guest VLAN
  - Secured w/ WPA-2/WPA-3 [(M1041)](https://attack.mitre.org/mitigations/M1041/)
  - For quality-of-life improvements, I've generated a QR code and placed it by my router which allows guests to connect to the guest network without having to know the password

### Password Policy
The password policy for the PPSKs/networks is as follows [(M1027)](https://attack.mitre.org/mitigations/M1027/)
- Password length minimum: 20
- At least 1 capital letter
- At least 1 lower case letter
- At least 1 number
- At least 1 special character

### Identity & Access Management (IAM)
The UniFi management user account must have multi-factor authentication (MFA) enabled [(M1032)](https://attack.mitre.org/mitigations/M1032/)

### Firewall Rules
<details>
  <summary>Rule 1</summary>
Rule Name: Allow Established and Related Connections <br />
Type: LAN In <br />
Action: Accept <br />
Source: Any <br />
Port: Any <br />
Destination: Any <br />
Port: Any <br />
States: Match State Established; Match State Related <br />
</details>

<details>
  <summary>Rule 2</summary>
Rule Name: Drop Invalid State <br />
Type: LAN In <br />
Action: Drop <br />
Source: Any <br />
Port: Any <br />
Destination: Any <br />
Port: Any <br />
States: Match State Invalid <br />
</details>

<details>
  <summary>Rule 3</summary>
Rule Name: Allow LAN to Anywhere <br />
Type: LAN In <br />
Action: Accept <br />
Source: VLAN1 <br />
Port: Any <br />
Destination: RFC1918 Port/IP Group <br />
Port: Any <br />
</details>

<details>
  <summary>Rule 4</summary>
Rule Name: Block inter-VLAN Traffic <br />
Type: LAN In <br />
Action: Drop <br />
Source: RFC1918 Port/IP Group <br />
Port: Any <br />
Destination: RFC1918 Port/IP Group <br />
Port: Any <br />
</details>

### Backup & Recovery
#### Automated Backups
For my network, I'm using the UniFi Controller automated system config backup solution on a weekly basis.

## Home Lab Architecture
### Value Proposition
The value of my home lab is that it creates an environment for me to conduct practical, hands-on learning engagements to experiment and conduct proof of concepts/value (PoC/PoV). This also facilitates home automation and quality of life improvement projects.

### Hardware
- Synology NAS/NVR
  - Multiple WD Red Plus HDDs in RAID1 configuration for data redundancy
- 1..n HP EliteDesk Mini PCs
  - 1 Running Proxmox VE
 
## Security Cameras and NVR
### Value Proposition
Enabling my IP cameras to feed into my NVR offers various personal value benefits including but not limited to: 
- Improved security: By sending my IP camera feeds to my NVR over my LAN, I'm able to disable internet connectivity for my IP cameras
- Continuous recording: Without an NVR, my IP cameras lose their recordings in the event of an internet outage
- Reduced network load: IP camera feeds would be processed locally, reducing bandwidth load on the network

### Hardware
- 1..3 IP cameras
- Synology NAS/NVR

## Smart Home Automation
### Value Proposition
The main value of my smart home automation and overall IoT setup is an improved quality of life. By automating mundane tasks, my schedule is freed up to engage in more important priorities. This setup also facilitates managing my home while away, monitoring utility usage, and provides a learning opportunity for setting up integrations & automations.

### Hardware
- 1..2 Smart hubs
- 1 Smart doorbell
- 1 Smart robot vacuum
- 1..n Smart lights
- 1..n Matter-enabled smart plugs
- 1..2 Smart TVs

### Setup
At the time of this push, all devices are integrated with Google Home for centralized management. Research/Testing is ongoing to see if a self-hosted instance of Home Assistant meets my requirements.
- The 1..2 smart hubs are matter-enabled hubs for controlling matter-enabled IoT devices

#### Issues
- The smart hubs can't talk with the smart TVs. This is likely due to incompatibility for 1 TV (not running Android) and using a different Google account for the Android TV. More research/testing is required.

### Automations
- <details><summary>Turn AC On Morning Routine</summary>
- Starter: In the morning at a specific time<br />
- Action(s): <br />
  - Turn AC on for 30min</details>
- Morning routine
  - Starter: In the morning at a specific time
  - Action(s):
    - Adjust smart hub media volume;
    - Tell me the weather;
    - Play my news sources;
    - Turn on and gradually increase the brightness of my bedroom light;
    - Turn bedroom light off in 30min
- Run robot vacuum routine
  - Starter: Every 3rd day of the week at a specific time
  - Action(s):
    - Run full robot vacuum cycle
- Where are the Utensils
  - Starter: When someone asks where are the utensils
  - Action(s):
    - Announce to household where the utensils are located
- Where is the Garbage and/or Recyclables
  - Starter: When someone asks where the garbage, where the recyclables, or a combination of the two
  - Action(s):
    - Announce to the household where the garbage and recyclables are
