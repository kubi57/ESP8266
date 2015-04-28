-------------------------------------------------------------------
-- (c) 2015 THILO & ANDREAS KREBS
-- 
-- Connects to NTP-server and gets actual time, then starts the 
-- pong-clock script. Rename this script to 'init.lua' once
-- everything works fine.
-- (tested with 0.9.5 build 20150318 integer)
-------------------------------------------------------------------

-- initialize wifi
wifi.setmode(wifi.STATION)
wifi.sta.config("SSID","password")   -- set SSID and password of your access point
wifi.sta.connect()


timezone = 1

tmr.alarm(1,1000,1,function() -- try every second to connect to NTP-server
     if(tins==nil and wifi.sta.status()==5) then
          sk=net.createConnection(net.UDP, 0)
          sk:on("receive", function(sck, payload) 
               ntpstamp = payload:byte(41) * 128 * 256 * 256 
                    + payload:byte(42) * 128 * 256
                    + payload:byte(43) * 128 
                    + payload:byte(44) /2
                    + timezone * 3600
               tins = (ntpstamp % 43200) * 2 + payload:byte(44) % 2  -- time in seconds
               sck:close()
               sck=nil
               tmr.stop(1)
               dofile("pong.lc")  -- start pong
          end )
          sk:connect(123,"130.149.17.21")    -- IP address of NTP-server at TU-Berlin
          sk:send(string.char( 227, 0, 6, 236, 0,0,0,0,0,0,0,0, 49, 78, 49, 52,
                              0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0))
     end
end)
