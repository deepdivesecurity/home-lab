# Home Network, Home Lab, & Smart Home Setup
This repo contains detailed information about my technical projects, including configurations, scripts, and documentation for my home setup.

## Table of Contents
1. [Introduction](#introduction)
2. [Network Architecture](#network-architecture)
3. [Home Lab Architecture](#home-lab-architecture)
4. [Smart Home Automation](#smart-home-automation)
5. [Security Cameras](#security-cameras)


## Introduction


## Network Architecture
### Diagram
**Figure 1.**
*Baseline home network diagram*
![Baseline home network diagram](/assets/images/Baseline_H_Network.png)
Note. IP addresses omitted.

### Hardware
- Cyberpower UPS for power redundancy
- ISP provided modem
- Ubiquiti router/switch

### Segmentation
In my home network, I've opted for 5 virtual local area networks (VLANs) to support segmentation of devices as follows: 
- VLAN1: Personal devices (Trusted zone)
- VLAN20: Guest devices (Untrusted zone)
  - Guest network: enabled
  - Client device isolation: enabled
- VLAN30: IoT devices (Untrusted zone)
  - Isolate network: enabled
- VLAN40: Cameras (Trusted zone)
  - Isolate network: enabled
  - Allow internet access: disabled
- VLAN50: Home Lab (Semi-trusted zone)

At the time of this push, there are 2 SSIDs as follows: 
- Main network: Uses private pre-shared keys (PPSKs) to connect devices to their specific VLAN
- Guest network: Allows for guests to connect directly to the Guest VLAN

### Firewall Rules


## Home Lab Architecture
### Hardware
- Synology NAS/NVR
  - Multiple WD Red Plus HDDs in RAID1 configuration for data redundancy
- 1..n HP EliteDesk Mini PCs
  - 1 Running Proxmox VE

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
- Before morning routine
  - Turn AC on for 30min before morning routine
- Morning routine
  - Starter: In the morning at a specific time
  - Action(s):
    - Adjust smart hub media volume;
    - Tell me the weather;
    - Play my news sources
    - Turn on and gradually increase the brightness of my bedroom light
    - Turn bedroom light off in 30min
- Run robot vacuum
  - Run full robot vacuum cycle every 3rd day of the week

## Security Cameras
