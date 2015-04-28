-------------------------------------------------------------------
-- (c) 2015 THILO & ANDREAS KREBS
-- 
-- functions for OLED display with SSD1306 controller
-- (tested with 0.9.5 build 20150318 integer)
-------------------------------------------------------------------

function data(...)
     i2c.start(0)
     i2c.address(0, oled_addr, i2c.TRANSMITTER)
     i2c.write(0, 0x40, arg)
     i2c.stop(0)
end

function command(...)
     i2c.start(0)
     i2c.address(0, oled_addr, i2c.TRANSMITTER)
     i2c.write(0, 0, arg)
     i2c.stop(0)
end

function oled_clear()
     command(0x20, 0x01)           
     command(0xB0, 0x00, 0x10)     -- home
     for i=0,63 do
          data(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
     end
     command(0x20, 0x02)           -- page addressing mode
end

function oled_init()
     i2c.setup(0, sda, scl, i2c.SLOW)
     command(0x8d, 0x14) -- enable charge pump   
     command(0xaf)       -- display on, resume to RAM
     command(0xd3, 0x00) -- set vertical shift to 0
     command(0x40)       -- set display start line to 0
     command(0xa1)       -- column 127 is mapped to SEG0
     command(0xc8)       -- remapped mode
     command(0xda, 0x12) -- alternative COM pin configuration, disable left/right remap
     command(0x81, 0xff) -- set contrast to 255
     command(0x20, 0x02) -- page addressing mode
end
