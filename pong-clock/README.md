#ESP8266 pong clock

A tiny little pong clock. Instead of describing it, look here: http://youtu.be/Su3f5w3nEbg

Upon startp it connects to an ntp server and fetches the exact time. 

###Required hardware:
- ESP8266
- OLED 128 x 64 with SSD1306 controller

###Software setup:
Copy all files to your ESP module. Compile all files except ntp.lua. Edit ntp.lua and insert your wifi SSID and password. Start ntp.lua and see if it works. If so, rename it to init.lua so that it automatically starts after reboot or power-up.

###todo:
I think a regular reboot at night might help to overcome the unprecise crystal oscillator.
