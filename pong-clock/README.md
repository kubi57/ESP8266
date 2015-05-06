#ESP8266 pong clock

A tiny little pong clock. Instead of describing it, look here: http://youtu.be/Su3f5w3nEbg

Upon start it connects to an ntp server and fetches the exact time. 

###Required hardware:
- ESP8266
- OLED 128 x 64 with SSD1306 controller, conenct SCL with GPIO0 and SDA with GPIO2

###Required Firmware:
last tested nodeMCU version: 0.9.5 build 20150318 integer

###Software setup:
Copy all files to your ESP module. Compile all files except ntp.lua. 

Edit ntp.lua and
- insert your wifi SSID and password
- adjust the value for timezone
- enter the IP address of a different ntp server, if you want

Start ntp.lua and see if it works. If so, rename it to init.lua so that the pong clock automatically starts after reboot or power-up.

###todo:
I think a regular reboot at night might help to overcome the unprecise crystal oscillator.
