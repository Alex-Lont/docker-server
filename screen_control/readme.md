# LCD controller

Controller to script for LCD screen to turn off at night and in the morning.  
controls screen via a NPN BJT wired accross the switch with the base going to a pin via a series 10k resistor.
BJT's collector wired to one side of the button and the emitter to the other.  

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
@chromium-browser https://organiser.virtual.lontiotlabs.au/#Homepage --kiosk --force-device-scale-factor=0.75
@xset s noblank
@xset s off
@xset s -dpmsr
```

## Pi Wiring

![Pinout](./header_pinout.jpg)

## Remote GPIO
https://github.com/joan2937/pigpio/issues/632#issuecomment-3379034242

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
sudo pigpiod -n 192.168.10.7
sudo pigpiod -n localhost -n 192.168.10.7 # allow localhost and 192.168.10.7
```

# LCD controller 
*designed to run on a raspberry pi*   

Controller to script for LCD screen to turn off at night and in the morning.  
controls screen via a NPN BJT wired accross the switch with the base going to a pin via a series 10k resistor.  
BJT's collector wired to one side of the button and the  emitter to the other.  
define the pin and times in the .env file.  

## Requiremnts
dotenv library is need else service will error out

```bash
pip install python-dotenv
```

## Environment File

 - SCREEN_PIN pin which base is connected to. set up for bcm mode of the GPIOs
 - ON_TIME time which screen turns on
 - OFF_TIME time which screen turns off

## Service File

default setting for service, change if in a different location.  
- User=root 
- WorkingDirectory=/home/pi/docker-server/screen_control/main.py
- ExecStart=/usr/bin/python /home/pi/docker-server/screen_control/main.py
- Restart=always

User must run as root as using the GPIO pin on the raspberry pi.  
WorkingDirectory so script know where the the log and status file are.  
ExecStart so the service knows where the script is.  
Restart policy, script is a infinite loop, but just incase.

## Setting up the service

copy service to pi

```bash
sudo cp screencontrol.service /lib/systemd/system/screencontrol.service
```

set file permissions

```bash
sudo chmod 644 /lib/systemd/system/screencontrol.service
```

load service

```bash

sudo systemctl daemon-reload

sudo systemctl enable screencontrol.service
```

start service

```bash
sudo systemctl start screencontrol.service

sudo systemctl status screencontrol.service
```

### Logs

will create a log file screen.log in script folder, log is limited to 5mB.

### txt file

screen.txt is used to hold the current state of the screen for reboots. also allows you to manual interact with screen if you need to change its state. 