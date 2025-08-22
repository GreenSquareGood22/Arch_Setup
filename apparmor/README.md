# Description

Installation and configuration of app armor security package.


## Steps

- Install apparmor using pacman
- Configure it to launch on boot by appending the command line arguments in the grub config with:
"apparmor=1 security=apparmor"
- Enable the apparmor service so that it runs on machine start

```bash
sudo systemctl enable apparmor.service
```

- Configure the app armor profiles for the applications installed (Maybe include those profiles here and some steps to apply them)

## Example - Firefox

Check for a profile

```bash
sudo aa-status | grep firefox
ls /etc/apparmor.d/ | grep firefox
```

If profile exists, but is disabled, enable it.

```bash
sudo aa-enforce /etc/apparmor.d/usr.bin.firefox
```

Close any open instances of firefox, then reopen and check confinement

```bash
killall firefox | firefox &
sudo aa-status | grep firefox
```
If the application crashes or cannot open, set mode to complain and check the journal for issues.
Troubleshoot issues until the application performs satisfactorily.

```bash
sudo aa-complain /etc/apparmor.d/usr.bin.firefox
sudo journalctl -b | grep DENIED
```



