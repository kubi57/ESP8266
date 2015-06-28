-----------------------------------------------------------------
--  demo using an MCP3421 high precision ADC, 18 bit, 0.05%
--  reads the input voltage, print to console and to an 
--  SSD1306 OLED display
--  copyright 2015 Andreas Krebs
--  initially tested with NodeMCU 0.9.6 build 20150627 float
-----------------------------------------------------------------

sda = 4
scl = 3
dev_addr = 0x68
id = 0
disp_addr = 0x3c

i2c.setup(id, sda, scl, i2c.SLOW)

-- set ADC to one shot, gain=1 and 18 bit resolution 
i2c.start(id)
i2c.address(id, dev_addr, i2c.TRANSMITTER)
i2c.write(id, 0x8c)   -- 1000 1100
i2c.stop(id)

-- read until /RDY bit is cleared
repeat
i2c.start(id)
i2c.address(id, dev_addr, i2c.RECEIVER)
x = i2c.read(id,4)
i2c.stop(id)
until string.byte(x,4) < 128

v = string.byte(x,1)*65536 + string.byte(x,2)*256 + string.byte(x,3)
if v>262144 then
    v = v - 16777216    -- for negative values
end
v = math.floor(v * 15.625 / 10) / 100000    -- 6 digits
    
print(v .. " V")

disp = u8g.ssd1306_128x64_i2c(disp_addr)
disp:setFont(u8g.font_6x10)
disp:setFontRefHeightExtendedText()
disp:setDefaultForegroundColor()
disp:setFontPosTop()

disp:firstPage()
repeat
    disp:drawStr(0,0, v .. " V")    
until disp:nextPage() == false