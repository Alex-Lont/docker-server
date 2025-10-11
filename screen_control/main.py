#! /usr/bin/python 
import RPi.GPIO as GPIO
import time 
import datetime
import sys
import os
from dotenv import load_dotenv
import logging
from logging.handlers import RotatingFileHandler

load_dotenv()
log_formatter = logging.Formatter('%(asctime)s %(levelname)s %(funcName)s(%(lineno)d) %(message)s')
logFile = 'screen.log'

my_handler = RotatingFileHandler(logFile, mode='a', maxBytes=5*1024*1024, 
                                 backupCount=2, encoding=None, delay=0)
my_handler.setFormatter(log_formatter)
my_handler.setLevel(logging.DEBUG)
app_log = logging.getLogger('pi')
app_log .setLevel(logging.DEBUG)
app_log .addHandler(my_handler)
app_log .info("***************Starting***************")

#24hour time
ON_TIME = int(os.getenv("ON_TIME"))
OFF_TIME = int(os.getenv("OFF_TIME"))
SCREEN = int(os.getenv("SCREEN_PIN"))

GPIO.setmode(GPIO.BCM)# number scheme
GPIO.setwarnings(False)
GPIO.setup(SCREEN, GPIO.OUT, initial=GPIO.LOW)

def function_will_exit():
    sys.exit('some error log')

def togglescreen():
    GPIO.output(SCREEN,GPIO.HIGH)
    time.sleep(1)
    GPIO.output(SCREEN,GPIO.LOW)
    writestatus()
    
def checktime():
    if (now.hour == ON_TIME and now.minute == 30):
        app_log.info("Turning on screen")
        togglescreen()
        app_log.info("Status pin %d is %d", SCREEN, GPIO.input(SCREEN))
    elif (now.hour == OFF_TIME and now.minute == 30):
        app_log.info("Turning off screen")
        togglescreen()
        app_log.info("Status pin %d is %d", SCREEN ,GPIO.input(SCREEN))
    else:
        app_log.info("sleeping")
        app_log.info("Status pin %d is %d", SCREEN, GPIO.input(SCREEN))

def screenstatus():
    f = open("screen.txt","r")
    status = f.read()
    f.close
    app_log .info("current status: %s", status)
    if (status == "0" and now.hour > ON_TIME and now.hour < OFF_TIME):
        app_log.info("on state")
        togglescreen()  
    elif (status == "1" and now.hour < ON_TIME and now.hour > OFF_TIME):
        togglescreen()
        app_log.info("off state")
    else:
        app_log.info("correct state")

def writestatus():
    f = open("screen.txt","r")
    status = f.read()
    f.close()
    f = open("screen.txt","w")
    app_log.info("toggling screen")
    if (status == "0"):
        f.write("1")
        f.close()
    elif (status == "1"):
        f.write("0")
        f.close()
    else:
        app_log.info("resetting status")
        f.write("0")
        f.close()
try:
    while True:
        global now
        now = datetime.datetime.now()
        screenstatus()
        checktime()
        time.sleep(60)

except Exception as err:
    app_log.info("***************Exiting***************")
    app_log.error("Function exited with %s", err)
    sys.exit(err)