-------------------------------------------------------------------
-- (c) 2015 THILO & ANDREAS KREBS
-- 
-- functions for pong-clock
-- (tested with 0.9.5 build 20150318 integer)
-------------------------------------------------------------------

function plot(x, y, z)
     ln = x % 16
     hn = x/16
     pg = y/8
     bt = 2 ^ (y % 8)
     command(0x00 + ln, 0x10 + hn, 0xb0 + pg)
     if (z==0) then 
          if(x~=63) then bt=0 else bt=0x99 end
     end
     if(pg == 0) then bt = bit.bor(bt,1) end
     if(pg == 7) then bt = bit.bor(bt,128) end
     data(bt)
end

function s_move(sl , delta)  -- sl: 0 or 1, delta: +1 or -1
     if (sl == 0) then
          lnx = 5        -- X-position left racket
          hnx = 16       -- 16 = 0x10
     else
          lnx = 10       -- X-position right racket
          hnx = 23       -- 23 = 0x10 + 7
     end
     if (delta == 1) then     -- down
          pg = s_pos[sl] / 8
          sb = 2 ^(s_pos[sl] % 8)  -- bit value of upper pixel
          bt = 255 - (2 * sb -1)   -- new byte value, pixel removed
          command(lnx, hnx, 0xB0+pg)
          if(pg == 0) then bt = bit.bor(bt,1) end
          data(bt)
          command(lnx, hnx, 0xB0+pg+1)
          bt = 2 * sb - 1
          if(pg == 6) then bt = bit.bor(bt,128) end
          data(bt)
          s_pos[sl] = s_pos[sl] + 1
     end
     if (delta == -1) then    -- up
          pg = (s_pos[sl] + 7) / 8           -- page of lowest pixel
          sb = 2 ^((s_pos[sl] - 1) % 8)      -- bit value of lowest pixel
          bt = sb -1                         -- new byte value, pixel removed
          command(lnx, hnx, 0xB0+pg)
          if(pg == 7) then 
               data(bit.bor(bt,128))
          else
               data(bt)
          end
          command(lnx, hnx, 0xB0+pg-1)
          bt = 255 - bt
          if(pg == 1) then bt = bit.bor(bt,1) end
          data(bt)
          s_pos[sl] = s_pos[sl] - 1
     end
end

