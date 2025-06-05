# LCD controller

Controller to script for LCD screen to turn off at night and in the morning.  
controls screen via a NPN BJT wired accross the switch with the base going to a pin via a series 10k resistor.
BJT's collector wired to one side of the button and the  emitter to the other.  

## Browser

Opens up a browser on boot to organizr screen.  
Add the following to file.  

```bash
sudo nano /etc/xdg/lxsession/LXDE-pi/autostart 
```

```text
@lxpanel --profile LXDE-pi
@pcmanfm --desktop --profile LXDE-pi
#@xscreensaver -no-splash
@chromium-browser http://127.0.0.1/#Homepage --kiosk --force-device-scale-factor=0.75
@xset s noblank
@xset s off
@xset s -dpmsr
```

## Pi Wiring

![Pinout](./header_pinout.jpg)

## Remote GPIO

```bash
sudo apt install pigpio
```

Enter sudo raspi-config on the command line, and enable Remote GPIO. This is functionally equivalent to the desktop method.

This will allow remote connections (until disabled) when the pigpio daemon is launched using systemctl (see below). It will also launch the pigpio daemon for the current session. Therefore, nothing further is required for the current session, but after a reboot, a systemctl command will be required.

Command-line: systemctl
To automate running the daemon at boot time, run:

```bash
sudo systemctl enable pigpiod
```

Command-line: pigpiod

This is for single-session-use and will not persist after a reboot. However, this method can be used to allow connections from a specific IP address, using the -n flag. For example:

```bash
sudo pigpiod -n localhost # allow localhost only
sudo pigpiod -n 192.168.10.12 # allow 192.168.1.65 only
sudo pigpiod -n localhost -n 192.168.10.12 # allow localhost and 192.168.1.65 only
```