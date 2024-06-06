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
3. Security Cameras & NVR: A security system integrated with multiple IP cameras feeding a centralized NVR over RTSP for comprehensive monitoring and secure access without internet exposure
4. Smart Home Automation: Enhanced convenience through integrated smart devices and platforms for automating tasks and allowing for seamless control.

## Network Architecture
### Diagram
**Figure 1.**

*Baseline home network diagram*
![Baseline home network diagram](/assets/images/Baseline_H_Network.png)
Note. IP addresses omitted.

### Hardware
- Cyberpower uninterruptable power supply (UPS) for power redundancy
- Internet service provider (ISP) provided modem
- Ubiquiti router/switch

### Network Settings and Segmentation
In my home network, I've opted for 5 virtual local area networks (VLANs) to support segmentation of devices [(M1030)](https://attack.mitre.org/mitigations/M1030/) as follows: 
- VLAN1: Personal devices (Trusted zone)
- VLAN20: Guest devices (Untrusted zone)
  - Guest network: enabled
  - Client device isolation: enabled
- VLAN30: IoT devices (Untrusted zone)
  - Isolate network: enabled
- VLAN40: Cameras (Semi-trusted zone)
  - Isolate network: enabled
  - Allow internet access: disabled [(M1035)](https://attack.mitre.org/mitigations/M1035/)
- VLAN50: Home Lab (Semi-trusted zone)

At the time of this push, there are 2 WiFi SSIDs as follows: 
- Main network
  - Secured w/ WPA-2 to allow for the use of private pre-shared keys (PPSKs) [(M1041)](https://attack.mitre.org/mitigations/M1041/)
  - Uses PPSKs to connect devices to their applicable VLAN (not including VLAN20: Guest devices)
- Guest network
  - Allows for guests to connect directly to the Guest VLAN
  - Secured w/ WPA-2/WPA-3 [(M1041)](https://attack.mitre.org/mitigations/M1041/)
  - For quality-of-life improvements, I've generated a QR code and placed it by my router which allows guests to connect to the guest network without having to know the password

The password policy for the PPSKs/networks is as follows [(M1027)](https://attack.mitre.org/mitigations/M1027/)
- Password length minimum: 20
- At least 1 capital letter
- At least 1 lower case letter
- At least 1 number
- At least 1 special character

The UniFi management user account must have multi-factor authentication (MFA) enabled [(M1032)](https://attack.mitre.org/mitigations/M1032/)

### Firewall Rules


## Home Lab Architecture
### Hardware
- Synology Network attached storage (NAS)/Network video recorder (NVR)
  - Multiple WD Red Plus HDDs in RAID1 configuration for data redundancy
- 1..n HP EliteDesk Mini PCs
  - 1 Running Proxmox VE
 
## Security Cameras and NVR

## Smart Home Automation
### Hardware
- 1..2 Smart hubs
- 1 Smart doorbell
- 1 Smart robot vacuum
- 1..n Smart lights
- 1..n Matter-enabled smart plugs
- 1..2 Smart TVs

### Setup

### Automations
- Turn AC On Morning routine
  - Starter: In the morning at a specific time
  - Action(s):
    - Turn AC on for 30min
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
