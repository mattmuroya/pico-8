pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function log(input)
	printh("> "..tostr(input))
end

function _init()
  t=0
  s=3
  f=0
  mx=0
  cx=128
  frames={2,2,4,4}
  x=16
  y=88
  dy=0
  state="grounded"
  headroom=5 -- init headroom (max boost time)

end

function _update()
  animate_cactus()
  animate_dino()
end

function _draw()
  cls()
  map(0,0,mx,0,16,16)
  map(0,0,mx+128,0,16,16)
  spr(6,cx,88,2,2)
  spr(f,x,y,2,2)
end

function animate_cactus()
  cx-=s
end

function animate_dino()
  f=frames[t%5]
  mx-=s
  if mx<=-128 then mx=mx+128 end
  log(mx)
  if state=="grounded" and btn(4) then
    state="boosting"
    headroom-=1
    dy=-8
    sfx(0)
  elseif state=="boosting" then
    f=0
    if btn(4) and headroom>0 then
      headroom-=1
    else
      state="falling"
      headroom=5
      dy/=2
    end
  elseif state=="falling" then
    f=0
    if fget(mget((x+8)/8,(y+8)/8),0) then
      state="grounded"
      dy=0
    else
      dy+=1
    end
  end
  y=y+dy<88 and y+dy or 88
  t+=1
end

__gfx__
00000000077777700000000007777770000000000777777000000000000000000000000000000000000000000000000000000000000000005555555555555555
00000000775577770000000077557777000000007755777700000007700000000000000000000000000000000000000000000000000000005555555555555555
00000000775577770000000077557777000000007755777700000077770077000000000000000000000000000000000000000000000000005555555555555555
70000000777777777000000077777777700000007777777700000077770777000000000000000000000000000000000000000000000000005555555555555555
70000000777777777000000077777777700000007777777700770077770777000000000000000000000000000000000000000000000000007777777755555555
77000007777777707700000777777770770000077777777000777077770777000000000000000000000000000000000000000000000000005555555555555555
77700077777700007770007777770000777000777777000000777077777770000000000000000000000000000000000000000000000000005755555555555555
07777777777700000777777777770000077777777777000000777077777700000000000000000000000000000000000000000000000000005555557555555555
07777777777777000777777777777700077777777777770000077777777000000000000000000000000000000000000000000000000000000000000000000000
00777777777707000077777777770700007777777777070000007777770000000000000000000000000000000000000000000000000000000000000000000000
00777777777700000077777777770000007777777777000000000077770000000000000000000000000000000000000000000000000000000000000000000000
00077777777700000007777777770000000777777777000000000077770000000000000000000000000000000000000000000000000000000000000000000000
00007777777000000000777777000000000007007770000077777777777777770000000000000000000000000000000000000000000000000000000000000000
00000770070000000000077007700000000007700700000000000077770000000000000000000000000000000000000000000000000000000000000000000000
00000700070000000000070000000000000000000700000000000077770000000000000000000000000000000000000000000000000000000000000000000000
00000770077000000000077000000000000000000770000000000077770000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
0004000000300003002432024300033001c3001e3001e3001f3002030020300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300
0004000000000000002405024000030001c0001e0001e0001f0002000020000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
