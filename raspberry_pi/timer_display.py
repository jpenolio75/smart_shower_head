
import digitalio, board
from PIL import Image, ImageDraw, ImageFont
from adafruit_rgb_display import ili9341
import os, glob, time, sys, textwrap, datetime
from flask import Flask

app = Flask(__name__)

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

@app.route("/numbers/<m>/<s>")
def countdown(m=0,s=0):
        global text
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
        total_seconds  = int(m) * 60 + int(s)
        while total_seconds > 0 and True:

            timer = datetime.timedelta(seconds = total_seconds)
            text = str(timer)
            text_color = (200,200,200)
            text_start_height = 20
            draw_multiple_line_text(image, text, font, text_color, text_start_height)
            disp.image(image)
            time.sleep(1)
            total_seconds -= 1
            del text

        return "<p>The countdown is up</p>"
        
if __name__ == '__main__':
    app.run(debug=True,port=5003,host='0.0.0.0')



