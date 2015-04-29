-------------------------------------------------------------------
-- (c) 2015 Andreas Krebs
-- A small http server, that outputs html pages according to url,
-- but only one level, as nodemcu can't deal with subdirectories.
-- Placeholders starting and ending with $ in index.html are
-- replaced with values from table "html".
-- (tested with 0.9.5 build 20150311)
--
-- requires:  files index.html and 404.html on ESP
-------------------------------------------------------------------

html = {}  -- table to store data for html pages

srv=net.createServer(net.TCP,30) 
srv:listen(80,function(conn) 
     conn:on("receive",function(conn, payload)
     
          -- example data
          html.myip = wifi.sta.getip()
          html.heap = node.heap()
          html.temp = 25,7

          filename = string.match(payload, "/(.-)%s")  -- get filename from url
          if (filename == "") then filename = "index.html" end
          if (string.sub(filename, -5) ~= ".html") then filename = filename .. ".html" end
          if (file.open(filename, "r") == nil) then file.open("404.html", "r") end
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
