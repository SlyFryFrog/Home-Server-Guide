# Home Server Guide

## Introduction

## UFW

### Step 1: Install UFW

```
sudo apt install ufw
```

### Step 2: Configure Firewall

Set ufw to deny any connections by default.

```
sudo ufw default deny
```

To add a specific ip to a specific port, follow the following template.

```
sudo ufw allow from <ip_address> to any port <port> proto <tcp>
```

The following example allows any local ip to access the port 22 (used for SSH). The subnet `/24` specifies that any address of `192.168.1.#` is allowed.

```
sudo ufw allow from 192.168.1.0/24 to any port 22 proto tcp
```

If you want to see your current firewall configuration, run `sudo ufw numbered`. This shows a list, starting from 1; you can remove a rule using `sudo ufw delete #`.

Additionally, if you change any configuration and want to apply the changes, make sure do reload UFW with `sudo ufw reload`.

### Step 3: Enable UFW

To enable UFW, run `sudo ufw enable` and view the status of UFW by running `sudo ufw status`.

## SSH

```
sudo apt install ssh
```

# Creating Config and SSH key-pair

## Client

## Server

To securely access the server, we will be using key-authentication. We can make the ssh key-pair using the `ssh-keygen` command. An example of creating this key-pair is shown below, where we are using the `ed25519` encryption algorithm.

### Step 1: Generate a Key Pair

```
ssh-keygen -t ed25519 -C "your_email@example.com"
> Enter file in which to save the key (/home/<user>/.ssh/<id_algorithm>):
> Enter passphrase (empty for no passphrase):
> Enter same passphrase again:
```

Follow the prompts:

- Save the key in the suggested location or specify a custom one.

- Optionally, add a passphrase for extra security.

#### Step 2: Add the Private Key

To access the server using our generated key-pair, we must add the private-key (`<id_algorithm>`) using `ssh-add`.


```
ssh-add ~/.ssh/<id_algorithm>
```

#### Step 3: Copy the Public Key from the Server

Afterwards, we simply need to copy the contents of our `<id_algorithm>.pub` to our host machine to use authenticate.

To finish the setup of ssh, we must also modify the config file. Ensure that password authentication is disabled and ssh-key authentication is enabled. This can be completed by doing the following:

#### Step 4: Update SSH Configuration

```
sudo nano /etc/ssh/sshd_config
```

Example sshd_config:

```
Include /etc/ssh/sshd_config.d/*.conf

Port 22
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::

#HostKey /etc/ssh/ssh_host_rsa_key
#HostKey /etc/ssh/ssh_host_ecdsa_key
#HostKey /etc/ssh/ssh_host_ed25519_key

# Ciphers and keying
#RekeyLimit default none

# Logging
#SyslogFacility AUTH
#LogLevel INFO

# Authentication:

#LoginGraceTime 2m
#PermitRootLogin prohibit-password
PermitRootLogin no
StrictModes yes
MaxAuthTries 6
MaxSessions 5

PubkeyAuthentication yes

# Expect .ssh/authorized_keys2 to be disregarded by default in future.
AuthorizedKeysFile .ssh/authorized_keys .ssh/authorized_keys2

# For this to work you will also need host keys in /etc/ssh/ssh_known_hosts
#HostbasedAuthentication no
# Change to yes if you don't trust ~/.ssh/known_hosts for
# HostbasedAuthentication
#IgnoreUserKnownHosts no
# Don't read the user's ~/.rhosts and ~/.shosts files
#IgnoreRhosts yes

# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no
PermitEmptyPasswords no

# Change to yes to enable challenge-response passwords (beware issues with
# some PAM modules and threads)
KbdInteractiveAuthentication no

# Set this to 'yes' to enable PAM authentication, account processing,
# and session processing. If this is enabled, PAM authentication will
# be allowed through the KbdInteractiveAuthentication and
# PasswordAuthentication.  Depending on your PAM configuration,
# PAM authentication via KbdInteractiveAuthentication may bypass
# the setting of "PermitRootLogin prohibit-password".
# If you just want the PAM account and session checks to run without
# PAM authentication, then enable this but set PasswordAuthentication
# and KbdInteractiveAuthentication to 'no'.
UsePAM yes

#AllowAgentForwarding yes
#AllowTcpForwarding yes
#GatewayPorts no
X11Forwarding yes
#X11DisplayOffset 10
#X11UseLocalhost yes
#PermitTTY yes
PrintMotd no
#PrintLastLog yes
#TCPKeepAlive yes
#PermitUserEnvironment no
#Compression delayed
#ClientAliveInterval 0
#ClientAliveCountMax 3
#UseDNS no
PidFile /run/sshd.pid

# Allow client to pass locale environment variables
AcceptEnv LANG LC_*

# override default of no subsystems
Subsystem	sftp	/usr/lib/openssh/sftp-server
```

Finally, restart the service by running `sudo systemctl restart sshd` to apply all changes.

### Samba

Samba is a network-share tool that enables us to access the filesystem of our server from other devices on our network. We can install it by running `sudo apt install samba`.

## Utilities

### Services

Services allow us to perform a task periodically without user-interaction. This is ideal for tasks such as keeping the system update-to-date.
