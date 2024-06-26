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
![Baseline home network diagram](/assets/images/baseline_home_network.png)
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
| VLAN40: Cameras  | Semi-trusted zone  | IP cameras; NVR | Isolate network: enabled <br />Allow internet access: disabled (I also have a traffic rule blocking internet access) [(M1035)](https://attack.mitre.org/mitigations/M1035/) |
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

### Firewall & Traffic Rules
<details>
  <summary>Firewall Rule 1</summary>
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
  <summary>Firewall Rule 2</summary>
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
  <summary>Firewall Rule 3</summary>
Rule Name: Allow VPN to NVR <br />
Type: LAN In <br />
Action: Accept <br />
Source: VPN subnet <br />
Port: NVR port <br />
Destination: VLAN40 <br />
</details>

<details>
  <summary>Firewall Rule 4</summary>
Rule Name: Allow LAN to Anywhere <br />
Type: LAN In <br />
Action: Accept <br />
Source: VLAN1 <br />
Port: Any <br />
Destination: RFC1918 Port/IP Group <br />
Port: Any <br />
</details>

<details>
  <summary>Firewall Rule 5</summary>
Rule Name: Block inter-VLAN Traffic <br />
Type: LAN In <br />
Action: Drop <br />
Source: RFC1918 Port/IP Group <br />
Port: Any <br />
Destination: RFC1918 Port/IP Group <br />
Port: Any <br />
</details>

<details>
  <summary>Traffic Rule 1</summary>
Rule Name: Block Camera VLAN Internet <br />
Action: Block <br />
Source: VLAN40 <br />
Destination: Internet <br />
</details>

### Backup & Recovery
#### Automated Backups
For my network, I'm using the UniFi Controller automated system config backup solution on a weekly basis. [(M1053)](https://attack.mitre.org/mitigations/M1053/)

## Home Lab Architecture
### Value Proposition
The value of my home lab is that it creates an environment for me to conduct practical, hands-on learning engagements to experiment and conduct proof of concepts/value (PoC/PoV). This also facilitates home automation and quality of life improvement projects.

### Hardware
- Synology NAS/NVR
  - Multiple WD Red Plus HDDs in RAID1 configuration for data redundancy
  - Upgraded RAM
- 1..n HP EliteDesk Mini PCs
  - 1 Running Proxmox VE
 
### Synology NAS Configuration
#### IAM
- Default admin account disabled
- Default guest account disabled
- New admin account created with MFA [(M1032)](https://attack.mitre.org/mitigations/M1032/)
- New regular user account, user1, w/ access to shared folder created
- Password policy: [(M1027)](https://attack.mitre.org/mitigations/M1027/)
  - Exclude name and description of user from password
  - Include mixed case
  - Include numeric characters
  - Include special characters
  - Minimal password length: 12

#### Storage Pool/Volume
- RAID1 w/ 2 WD RED Plus HDDs in the pool
- Data scrubbing every 6 months

#### Backup & Disaster Recovery
- Currently following the 3-2-1 backup strategy [(M1053)](https://attack.mitre.org/mitigations/M1053/)
  - 3 copies of data on 2 different media with 1 copy off-site for disaster recovery

#### Shared Folder
- Location: Volume 1, btrfs, encrypted [(M1041)](https://attack.mitre.org/mitigations/M1041/)
- Hidden from users without permissions
- user1 provided access <br />

**Figure 2.** <br />
*Shared files folder configuration*
![Shared files folder configuration](/assets/images/shared_files_folder.png)

#### Snapshots
- Downloaded and installed Snapshot Replication
- Setup daily snapshots on the shared folder mentioned above with a retention of 7 days <br />

**Figure 3.** <br />
*Snapshot configuration*
![Snapshot configuration](/assets/images/snapshot_configuration.png)

#### UPS
- Connected my UPS to the NAS for power redundancy and safe shutdown to prevent data loss <br />

**Figure 4.** <br />
*UPS configuration* <br />
![UPS configuration](/assets/images/ups_settings.png)

#### Security
- Enabled DoS protection
- Configured auto block [(M1036)](https://attack.mitre.org/mitigations/M1036/)
- Enabled account protection
- Enabled redirect HTTP to HTTPS [(M1041)](https://attack.mitre.org/mitigations/M1041/)
- Changed default HTTP/HTTPS ports
- etc.

**Figure 5.** <br />
*Security advisor*
![Security advisor results](/assets/images/security_advisor.png)

##### Firewall Rules
<details>
  <summary>Rule 1</summary>
Ports: DSM (HTTPS) <br />
Protocol: TCP <br />
Source IP: VLAN1 <br />
Action: Allow <br />
</details>

<details>
  <summary>Rule 2</summary>
Ports: DSM (HTTPS) <br />
Protocol: TCP <br />
Source IP: VPN Client IP <br />
Action: Allow <br />
</details>

<details>
  <summary>Rule 3</summary>
Ports: 445 <br />
Protocol: TCP <br />
Source IP: VLAN1 <br />
Action: Allow <br />
</details>

<details>
  <summary>Rule 4</summary>
Ports: 445 <br />
Protocol: TCP <br />
Source IP: VLAN50 <br />
Action: Allow <br />
</details>

<details>
  <summary>Rule 5</summary>
Ports: All <br />
Protocol: All <br />
Source IP: All <br />
Action: Deny <br />
</details>
 
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
<details>
  <summary>Turn AC On Morning Routine</summary>
  
  - Starter: In the morning at a specific time
  - Action(s):
    - Turn AC on for 30min
</details>

<details>
  <summary>Morning Routine</summary>
  
  - Starter: In the morning at a specific time
  - Action(s):
    - Adjust smart hub media volume;
    - Tell me the weather;
    - Play my news sources;
    - Turn on and gradually increase the brightness of my bedroom light;
    - Turn bedroom light off in 30min
</details>

<details>
  <summary>Run Robot Vacuum Routine</summary>

  - Starter: Every 3rd day of the week at a specific time
  - Action(s):
    - Run full robot vacuum cycle 
</details>

<details>
  <summary>Where are the Utensils? Routine</summary>
  
  - Starter: When someone asks where are the utensils
  - Action(s):
    - Announce to household where the utensils are located
</details>

<details>
  <summary>Where is the Garbage and/or Recyclables Routine</summary>
  
  - Starter: When someone asks where the garbage, where the recyclables, or a combination of the two
  - Action(s):
    - Announce to the household where the garbage and recyclables are
</details>
