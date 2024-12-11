## 1. Add the user to the system (if not already added)

First, make sure the user exists on the system. You can add a user with the useradd command.


```
sudo useradd -m username
```

The -m flag ensures the user gets a home directory.


## 2. Set a password for the user on the system

Use the passwd command to set the password for the user.

```
sudo passwd username
```

This will prompt you to enter a password for the user.

## 3. Add the user to Samba

Now, to add the user to Samba, you need to create a Samba user by running the smbpasswd command. This is a separate password from the system password, and Samba uses it for sharing files.

```
sudo smbpasswd -a username
```

This will prompt you to set a password for the Samba user.

`-a`: This option adds the user to Samba's user database.

## 4. Enable the user for Samba

Once you’ve added the user, enable the user for Samba access with:

```
sudo smbpasswd -e username
```

This will enable the user’s Samba account.

## 5. Verify the Samba user

To verify that the user has been added successfully, you can list Samba users with the following command:

```
sudo pdbedit -L
```

This will display a list of Samba users.

## 6. Configure Samba Share (Optional)

Make sure to configure the Samba share in your smb.conf file. Typically, the file is located at /etc/samba/smb.conf.

For example:

```
[shared]
   path = /path/to/share
   valid users = username
   read only = no
   browsable = yes
```

Valid users for multiple users can be done like the following example:

```
valid users = user1, user2, user3
```

Additionally, if you'd prefer to add a group over individual users, you can do the following:

```
sudo groupadd <samba_write_group>
sudo usermod -aG <samba_write_group> <user>
```

Then add the group to the `valid users` with an `@` like so:

```
valid users = @samba_write_group
```

## 7. Restart the Samba service

Finally, restart the Samba service to apply the changes:

```
sudo systemctl restart smbd
```

This will restart the Samba server and apply any changes made to the configuration or users.

# Summary

Add the user to the system using `useradd`.

Set a password for the user with `passwd`.

Add the user to Samba with smbpasswd `-a`.

Enable the user with smbpasswd `-e`.

Optionally configure Samba shares in `/etc/samba/smb.conf`.

Restart the Samba service with `systemctl restart smbd`.
