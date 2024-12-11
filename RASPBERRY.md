# Raspberry Pi

## Flash ISO

https://www.raspberrypi.com/software/

https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi#1-overview

## Networking

The network configuration file is located at `/etc/netplan/50-cloud-init.yaml`. To add ethernet or wireless connections, we will perform the following:

```
sudo nano /etc/netplan/50-cloud-init.yaml
```

Here is an example of the yaml text file when configured:

```
network:
  version: 2
  ethernets:
    eth0:
      dhcp4: true
      optional: true
  wifis:
    wlan0:
      dhcp4: true
      optional: true
      access-points:
        "home network":
          password: "123456789"
```

**It is important to maintain this consistent indentation for it to successfully apply the settings.**

```
sudo netplan apply

sudo reboot
```
