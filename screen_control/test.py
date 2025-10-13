#!/usr/bin/env python3
import RPi.GPIO as GPIO
import time
import datetime
import os
import sys
import logging
from logging.handlers import RotatingFileHandler
from dotenv import load_dotenv

# === CONFIG ===
CONFIG_PATH = "screen_toggle.conf"
LOG_FILE = "screen_toggle.log"
SCREEN_PIN = 17  # BCM number
BOUNCE_TIME = 500  # milliseconds

# === Load environment (.env) ===
load_dotenv()
ON_TIME = int(os.getenv("ON_TIME", 7))    # Default 07:00
OFF_TIME = int(os.getenv("OFF_TIME", 21)) # Default 21:00

# === Setup GPIO ===
GPIO.setmode(GPIO.BCM)
GPIO.setup(SCREEN_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
GPIO.add_event_detect(SCREEN_PIN, GPIO.FALLING, callback=on_button_press, bouncetime=BOUNCE_TIME)

# === Logging Setup ===
log_formatter = logging.Formatter('%(asctime)s %(levelname)s %(funcName)s(%(lineno)d) %(message)s')
handler = RotatingFileHandler(LOG_FILE, maxBytes=5*1024*1024, backupCount=2)
handler.setFormatter(log_formatter)
handler.setLevel(logging.INFO)
app_log = logging.getLogger('pi')
app_log.setLevel(logging.INFO)
app_log.addHandler(handler)

app_log.info("*************** Starting ***************")

# === Status Config Handling ===
def read_status():
    try:
        with open(CONFIG_PATH, "r") as f:
            for line in f:
                if line.startswith("SCREEN_STATE="):
                    return int(line.strip().split("=")[1])
    except Exception as e:
        app_log.warning(f"Could not read status: {e}")
    return 0  # Default to OFF

def write_status(state):
    try:
        with open(CONFIG_PATH, "w") as f:
            f.write(f"SCREEN_STATE={state}\n")
        app_log.info("Updated SCREEN_STATE to %d", state)
    except Exception as e:
        app_log.error(f"Failed to write config: {e}")

def toggle_screen():
    app_log.info("Toggling screen...")
    GPIO.remove_event_detect(SCREEN_PIN)
    GPIO.setup(SCREEN_PIN, GPIO.OUT)
    GPIO.output(SCREEN_PIN, GPIO.HIGH)
    time.sleep(1)
    GPIO.output(SCREEN_PIN, GPIO.LOW)
    write_status(0 if read_status() == 1 else 1)
    GPIO.setup(SCREEN_PIN, GPIO.IN, pull_up_down=GPIO.PUD_UP)
    GPIO.add_event_detect(SCREEN_PIN, GPIO.FALLING, callback=on_button_press, bouncetime=BOUNCE_TIME)

def on_button_press(channel):
    app_log.info("Button pressed - toggling screen manually")
    toggle_screen()

def check_time(now):
    if now.hour == ON_TIME and now.minute == 30:
        app_log.info("Scheduled ON")
        toggle_screen()
    elif now.hour == OFF_TIME and now.minute == 30:
        app_log.info("Scheduled OFF")
        toggle_screen()
    else:
        app_log.debug("Time check passed, no toggle")

def screen_state_check(now):
    status = read_status()
    if status == 0 and ON_TIME < now.hour < OFF_TIME:
        app_log.info("Auto ON: Correcting state")
        toggle_screen()
    elif status == 1 and (now.hour < ON_TIME or now.hour > OFF_TIME):
        app_log.info("Auto OFF: Correcting state")
        toggle_screen()
    else:
        app_log.debug("Screen already in correct state")

def main():
    try:
        while True:
            now = datetime.datetime.now()
            screen_state_check(now)
            check_time(now)
            time.sleep(60)

    except KeyboardInterrupt:
        app_log.info("Interrupted by user")

    except Exception as e:
        app_log.error(f"Unhandled error: {e}")

    finally:
        GPIO.cleanup()
        app_log.info("*************** Exiting ***************")

if __name__ == "__main__":
    main()
