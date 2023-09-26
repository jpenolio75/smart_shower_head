
import digitalio, board
from PIL import Image, ImageDraw, ImageFont
from adafruit_rgb_display import ili9341
from firebase import firebase
import os, glob, time, sys, textwrap
import RPi.GPIO as GPIO
import time

firebase = firebase.FirebaseApplication('https://smart-shower-head-bfcc9-default-rtdb.firebaseio.com',None)

os.system('modprobe w1-gpio')
os.system('modprobe w1-therm')

base_dir = '/sys/bus/w1/devices/28-0303979429ae'
device_file = base_dir  + '/w1_slave'

GPIO.setmode(GPIO.BCM)
inpt = 13
GPIO.setup(inpt,GPIO.IN,pull_up_down=GPIO.PUD_UP)
minutes = 0
constant = 0.006
time_new = 0.0
rpt_int = 10

global rate_cnt, tot_cnt
rate_cnt = 0
tot_cnt = 0

def Pulse_cnt(inpt_pin):
    global rate_cnt, tot_cnt
    rate_cnt += 1
    tot_cnt += 1
    
GPIO.add_event_detect(inpt,GPIO.FALLING,callback=Pulse_cnt,bouncetime=10)

# First define some constants to allow easy resizing of shapes.
BORDER = 20
FONTSIZE = 24

# Configuration for CS and DC pins (these are PiTFT defaults):
cs_pin = digitalio.DigitalInOut(board.CE0)
dc_pin = digitalio.DigitalInOut(board.D25)
reset_pin = digitalio.DigitalInOut(board.D24)

# Config for display baudrate (default max is 24mhz):
BAUDRATE = 24000000

# Setup SPI bus using hardware SPI:
spi = board.SPI()

disp = ili9341.ILI9341(
    spi,
    rotation=90,  # 2.2", 2.4", 2.8", 3.2" ILI9341
    cs=cs_pin,
    dc=dc_pin,
    rst=reset_pin,
    baudrate=BAUDRATE,
)
# pylint: enable=line-too-long

# Create blank image for drawing.
# Make sure to create image with mode 'RGB' for full color.
if disp.rotation % 180 == 90:
    height = disp.width  # we swap height/width to rotate it to landscape!
    width = disp.height
else:
    width = disp.width  # we swap height/width to rotate it to landscape!
    height = disp.height

image = Image.new("RGB", (width, height))

def read_temp_raw():
	f = open(device_file,'r')
	lines = f.readlines()
	f.close()
	return lines

def read_temp():
	lines = read_temp_raw()
	while lines[0].strip()[-3:] != 'YES':
		time.sleep(0.2)
		lines = read_temp_raw()
	equals_pos = lines[1].find('t=')
	if equals_pos != -1:
		temp_string = lines[1][equals_pos+2:]
		temp_c = float(temp_string) / 1000.0
		temp_f = temp_c * 9.0 / 5.0 + 32.0
		return temp_f

def draw_multiple_line_text(image, text, font, text_color, text_start_height):
    '''
    From unutbu on [python PIL draw multiline text on image](https://stackoverflow.com/a/7698300/395857)
    '''
    draw = ImageDraw.Draw(image)
    image_width, image_height = image.size
    y_text = text_start_height
    lines = textwrap.wrap(text, width=22)
    for line in lines:
        line_width, line_height = font.getsize(line)
        draw.text(((image_width - line_width) / 2, y_text), 
                  line, font=font, fill=text_color)
        y_text += line_height

while True:
    time_new = time.time() + rpt_int
    rate_cnt = 0
    while time.time() <= time_new:
        try:
            None
        except KeyboardInterrupt:
            print('\nCTRL c - Exiting nicely')
            GPIO.cleanup()
            print('Done')
            sys.exit()
            
    minutes += 1
    
    #LperM = round(((rate_cnt*constant)/(rpt_int/60)),2)
    LperM = round((((rate_cnt*constant)*0.625)/(rpt_int/60)),2)
    #TotLit = round(tot_cnt * constant, 2)
    TotLit = round((tot_cnt * constant)*0.625, 2)
    GperM = round(LperM / 3.785,2)
    TotGal = round(TotLit / 3.785,2)
    temp_conv = round(read_temp(),2)
    
    currentTime = time.strftime("%I:%M %p")
        
    # Get drawing object to draw on image.
    draw = ImageDraw.Draw(image)

    # Draw a green filled box as the background
    draw.rectangle((0, 0, width, height), fill=(0, 255, 0))
    #disp.image(image)

    # Draw a smaller inner purple rectangle
    draw.rectangle(
        (BORDER, BORDER, width - BORDER - 1, height - BORDER - 1), fill=(170, 0, 136)
    )
    # Load a TTF Font
    font = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", FONTSIZE)
    # Draw Some Text
    text = "Temperature: " + str(temp_conv) + "°F \n" + "Flow Rate: " + str(GperM) + " gal/min \n" + "Water Usage: " + str(TotGal) + " gal \n" + currentTime + " \n"
    text_color = (200,200,200)
    text_start_height = 20
    
    firebase.put('/Raspberry_Pi/Temperature','VoiceSensor',"The current water temperature is " + str(temp_conv) + " degrees fahrenheit")
    firebase.put('/Raspberry_Pi/FlowRate','VoiceSensor',"The current water flow rate is " + str(GperM) + " gal/min")
    firebase.put('/Raspberry_Pi/WaterUsage','VoiceSensor',"The current water usage is " + str(TotGal) + " gal")
    
    firebase.put('/Raspberry_Pi/Temperature','AppData',temp_conv)
    firebase.put('/Raspberry_Pi/FlowRate','AppData',GperM)
    firebase.put('/Raspberry_Pi/WaterUsage','AppData',TotGal)
    draw_multiple_line_text(image, text, font, text_color, text_start_height)
    disp.image(image)
        
GPIO.cleanup()
print('Done')



