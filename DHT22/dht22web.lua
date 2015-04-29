-------------------------------------------------------------
-- (c) 2015 Andreas Krebs
-- reads temperature and humidity values from the DHT22
-- and displays them on a web page
-- (tested with 0.9.5 build 20150311)
-------------------------------------------------------------


PIN = 4 --  data pin, GPIO2

dht22 = require("dht22")
dht22.read(PIN)
t = dht22.getTemperature()
h = dht22.getHumidity()

html = {}  -- table to store the values


srv = net.createServer(net.TCP,30) 
srv:listen(80,function(conn) 
     conn:on("receive",function(conn)
     
          -- read data
          dht22.read(PIN)
          t = dht22.getTemperature()
          h = dht22.getHumidity()
          if (h == nil) then
               html.temp = "---"
               html.hum = "---"
          else
               html.temp = ((t-(t % 10)) / 10)..","..(t % 10)
               html.hum  = ((h - (h % 10)) / 10)..","..(h % 10)
          end
          
          file.open("index.html", "r")
          repeat
               line = file.readline()
               -- replace html placeholders with table values
               if (line ~= nil) then
                    line = string.gsub(line, "%$(.-)%$", html)
                    conn:send(line) 
               end
          until line==nil
     end) 
     conn:on("sent",function(conn) conn:close() collectgarbage("collect") end)
end)
