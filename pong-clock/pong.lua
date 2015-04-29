-------------------------------------------------------------------
-- (c) 2015 THILO & ANDREAS KREBS
-- 
-- pong clock main script
-- (tested with 0.9.5 build 20150318 integer)
-------------------------------------------------------------------

-- store timer value at startup
tmr_start=tmr.now()/1000000

-- hardware definitions
sda = 4
scl = 3
oled_addr = 0x3C


dofile("oledfunc.lc")
dofile("pongfunc.lc")
dofile("pongfont.lc")

oled_init()
oled_clear()



-- draw frame
for i=0,126 do
     plot(i, 0, 1)
     plot(126-i, 63, 1)
     tmr.wdclr()
end

for i=0,7 do
     command(0x00, 0x10, 0xb0 + i)
     data(0xff)
     command(0x0f, 0x17, 0xb0 +i)
     data(0xff)
     command(0x0f, 0x13, 0xb0 +i)
     data(0x99)
end



s_pos = {}     -- position of racket 0 and 1
s_dir = {}     -- direction of racket movement
s_tgt = {}     -- calculated arrival position of ball

s_pos[0] = 28   -- left racket
s_dir[0] = 1 
s_pos[1] = 28   -- right racket
s_dir[1] = 1
s_tgt[0] = 28
s_tgt[1] = 19
s_move(0,1)
s_move(1,1)

bx = 6         -- position of ball
by = 25
bdx = 1        -- direction of ball
bdy = 1

m_old = 59
t_us_alt = 0
t_rest = 0
t_alt = 0
counter = 0

tmr.alarm(0,40,1,function()   -- move ball and/or rackets every 40ms

     -- move rackets
     if (s_pos[0]+3 > s_tgt[0]) then     -- left racket is actually too low
          if (s_pos[0]>1) then s_move(0, -1) end
     else
          if (s_pos[0]+3 < s_tgt[0]) then     -- ...too high
               if (s_pos[0]<55) then s_move(0, 1) end
          else
               if (bdx == -1) then s_tgt[1]=28 end
               tmr.delay(7000)
          end
     end
     
     if (s_pos[1]+3 > s_tgt[1]) then     -- right racket is actually too low
          if (s_pos[1]>1) then s_move(1, -1) end
     else
          if (s_pos[1]+3 < s_tgt[1]) then     -- ...too high
               if (s_pos[1]<55) then s_move(1, 1) end
          else
               if (bdx == 1) then s_tgt[0]=28 end
               tmr.delay(7000)
          end
     end

     -- display time
     t = (tmr.now()/1000000) - tmr_start -- in microseconds
     if(t_alt>t) then
          counter = counter + 1
          if(counter % 2 == 0 and counter % 50 ~= 0 and counter ~= 0 ) then
               t_rest = t_rest + 1
          end
     end
     t_alt = t
     t = t + (counter*2147)
     t = t + tins + t_rest
     
     h=t % 86400 / 3600
     m=t % 3600 / 60
     s=t % 60
 
     if(m_old ~= m) then  -- only if a new minute began
          print(h/10 .. h%10 .. ":" .. m/10 .. m%10 .. ":" .. s/10 .. s%10)
          command(0x01, 0x13, 0xb1)
          data(unpack(font[h/10+1]))
          data(0x00)
          data(unpack(font[h%10+1]))
          data(0x00,0x00,0x00,0x99,0x00,0x00,0x00)
          data(unpack(font[m/10+1]))
          data(0x00)
          data(unpack(font[m%10+1]))
          m_old = m
     end

     -- move ball
     if(by/8==1 and bx>46 and bx<79) then 
          tmr.delay(7000)
     else
          plot(bx, by, 0)     -- delete ball
     end       
     bx = bx + bdx
     by = by + bdy
     if (by > 62) then        -- lower limit
          bdy = -1
          by = 61
     end
     if (by < 1) then         -- upper limit
          bdy = 1
          by = 2
     end
     if (bx > 121) then       -- right limit
          bdx = -1
          bx = 120
          -- calculate left target position
          s_tgt[0] = by - (7 * bdy)     --10
          if (s_tgt[0] < 1) then s_tgt[0] = -s_tgt[0]+2 end
          if (s_tgt[0] > 62) then s_tgt[0] = 122 - s_tgt[0] end
     end
     if (bx < 6) then         -- left limit
          bdx = 1
          bx = 7
          -- calculate right target position
          s_tgt[1] = by - (7 * bdy)          --10
          if (s_tgt[1] < 1) then s_tgt[1] = -s_tgt[1]+2 end
          if (s_tgt[1] > 62) then s_tgt[1] = 122 - s_tgt[1] end
     end

     if(by/8==1 and bx>46 and bx<79) then 
          tmr.delay(7000)
     else
          plot(bx, by, 1)     -- draw ball
     end     
     tmr.wdclr()    
end)

