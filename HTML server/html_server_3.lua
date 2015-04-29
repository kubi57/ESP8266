-------------------------------------------------------------------
-- (c) 2015 Andreas Krebs
-- A small http server, that outputs html pages according to url,
-- but only one level, as nodemcu can't deal with subdirectories.
-- Placeholders starting and ending with $ in index.html are
-- replaced with values from table "html". Parameters in the url
-- are also stored in table html.
-- (tested with 0.9.5 build 20150311)
-------------------------------------------------------------------

html = {}  -- table to store data for and from html pages

-- example data
html.temp = 25,7
html.heap = node.heap()
html.ssid = ""
html.pwd = ""
html.ssid_error = ""
html.pwd_error = ""
html.ap_checked = ""
html.sta_checked = ""
html.message = "This is a message for you from LUA."


srv=net.createServer(net.TCP,30) 
srv:listen(80,function(conn) 
     conn:on("receive",function(conn, payload)
          
          -- example data
          html.myip = wifi.sta.getip()
          
          url = string.match(payload, "/(.-)%s")  -- get url
 
          -- extract filename and parameter from url
          if (string.find(url, "?")) then
               filename = string.match(url, "(.+)?")
               pbeg, pend = string.find(url,"?")
               if (pend) then
                    url = string.sub(url,pend+1)
                    url = url .. "&"
                    for k, v in string.gfind(url, "(%w+)=(.-)&") do
                         html[k] = v    -- store parameter from url in table html
                    end
               end
          else
               filename = url
               parameter = ""
          end

          parameter = string.match(url, "%?(.-)")
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
