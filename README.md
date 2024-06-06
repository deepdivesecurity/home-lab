# Home Network, Home Lab, & Smart Home Setup
This repo contains detailed information about my technical projects, including configurations, scripts, and documentation for my home setup.

## Table of Contents
1. [Introduction](#introduction)
2. [Network Architecture](#network-architecture


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
- Ubiquiti Router/Switch

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
Synology NAS/NVR
WD Red Plus HDDs (Data redundancy)
HP EliteDesk Mini PC

## Smart Home Automation
Smart Hubs
Smart Doorbell
Smart Robot Vacuum
Smart Lights
Smart Plugs
Smart TVs

## Security Cameras w/ NVR
