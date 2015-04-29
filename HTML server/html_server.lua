----------------------------------------------------------
-- (c) 2015 Andreas Krebs
-- A tiny http serve, that outputs one html page only.
-- The html file must be uploaded to the ESP as well.
-- Placeholders starting with $$ in the html are replaced
-- with lua variable values.
----------------------------------------------------------


temp = 25,4

srv=net.createServer(net.TCP,30) 
srv:listen(80,function(conn) 
     conn:on("receive",function(conn,payload) 
          myip=wifi.sta.getip()
          file.open("test.html", "r")
          repeat
               line = file.readline()
               -- example to replace html placeholders with variable values
               if (line ~= nil) then 
                    line = string.gsub(line, "$$myip", myip)
                    line = string.gsub(line, "$$temp", temp)
                    conn:send(line) 
               end
          until line==nil
     end) 
     conn:on("sent",function(conn) conn:close() end)
end)
