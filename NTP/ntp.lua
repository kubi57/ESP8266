-----------------------------------------------------------------
--  (c) 2015 Andreas Krebs 
--  get the timestamp from an ntp server and convert it to
--  year, month, day, hour, minute and second
--  copyright 2015 Andreas Krebs
--  initially tested with NodeMCU 0.9.5 build 20150213
--  works also with 20150318int
-----------------------------------------------------------------

request=string.char( 227, 0, 6, 236, 0,0,0,0,0,0,0,0, 49, 78, 49, 52,
          0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
timezone = 1
dayspermonth = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31}

sk=net.createConnection(net.UDP, 0)
sk:on("receive", function(sck, payload) 
     -- the timestamp is in bytes 41 to 44 of the response as a 64 bit integer
     -- and represents the number of seconds since 1.1.1900
     -- it's a bit tricky, because Lua can only handle uint31
     ntpstamp = payload:byte(41) * 128 * 256 * 256 
              + payload:byte(42) * 128 * 256
              + payload:byte(43) * 128 
              + payload:byte(44) /2
              + timezone * 1800
     hour = ntpstamp % 43200 / 1800
     minute = ntpstamp % 1800 / 30
     second = ntpstamp % 30 + payload:byte(44)%2
     year = ntpstamp / 15778800 + 1900
     -- todo: check if leapyear calculation is correct !
     day = ((ntpstamp % 15778800) + (year % 4 * 10800)) / 43200 +1
     month=1
     while (day>dayspermonth[month]) do
          day = day - dayspermonth[month]
          if ((year % 4 < 1) and (month == 2)) then day=day-1 end    -- february in leapyears
          month=month+1
     end
     print(string.format("%02u.%02u.%04u",day,month,year))
     print(string.format("%02u:%02u:%02u",hour,minute,second))
     sck:close()
end )
sk:connect(123,"130.149.17.21")    -- TU-Berlin
sk:send(request)
