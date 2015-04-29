-------------------------------------------------------------
-- (c) 2015 Andreas Krebs
-- A tiny http server, that outputs one html page only.
-- The file index.html has to be uploaded to the ESP.
-- Placeholders starting and ending with $ in index.html are
-- replaced with values from table "html".
-- (tested with 0.9.5 build 20150311)
-------------------------------------------------------------

html = {}  -- table to store the values

srv=net.createServer(net.TCP,30) 
srv:listen(80,function(conn) 
     conn:on("receive",function(conn)
     
          -- example data
          html.myip = wifi.sta.getip()
          html.heap = node.heap()
          html.temp = 25,7
          
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
     conn:on("sent",function(conn) conn:close() end)
end)
