pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--initialize (called at start)
function _init()
	cls(0)

	ship_spr=2
	flame_spr=5
	laser_spr=21

	ship_x=60
	ship_y=60

	-- laser_x=-8
	-- laser_y=-8

	fired_lasers={}

	muzzle=0

	ship_spd_x=0
	ship_spd_y=0
	
	score=10000
	
	lives=2

	stars_x={}
	stars_y={}
	stars_spd={}

	for i=1,80 do
		add(stars_x, flr(rnd(128)))
		add(stars_y, flr(rnd(128)))
		add(stars_spd,rnd(1.5)+.5)
	end
end

--update game data (=30fps)
function _update()
	--reset speed and sprite
	ship_spd_x=0
	ship_spd_y=0
	ship_spr=2

	--animate stars
	animate_starfield()

	--set x speed
	if btn(0) and btn(1) then
		if btn_0_was_last then ship_spd_x+=2
		else ship_spd_x-=2
		end
	elseif btn(0) then 
		btn_0_was_last=true
		ship_spd_x-=2
		ship_spr=1
	elseif btn(1) then
		btn_0_was_last=false
		ship_spd_x+=2
		ship_spr=3
	end

	--set y speed
	if btn(2) and btn(3) then
		if btn_2_was_last then ship_spd_y+=2
		else ship_spd_y-=2
		end
	elseif btn(2) then 
		btn_2_was_last=true
		ship_spd_y-=2
	elseif btn(3) then
		btn_2_was_last=false
		ship_spd_y+=2
	end

	--calculate ship position
	ship_x+=ship_spd_x
	ship_y+=ship_spd_y

	--animate flame
	--intentionally not render when > 9
	if flame_spr>9 then flame_spr=5
	else flame_spr+=1
	end

	--fire laser
	if btnp(5) then
		-- laser_x=ship_x
		-- laser_y=ship_y-4
		sfx(0)
		muzzle=5

		add(fired_lasers,{ship_x,ship_y-4})
	end

	--cut lasers
	if #fired_lasers > 10 then deli(fired_lasers,1) end


	--animate laser
	animate_lasers()

	--animate muzzle
	if muzzle>0 then muzzle-=1
	end
	
	--reset position if hit bound
	if ship_x>=120 then	ship_x=120
	elseif ship_x<=0 then	ship_x=0
	end

	if ship_y>=120 then	ship_y=120
	elseif ship_y<=0 then	ship_y=0
	end
end

-- draw new frame (~30fps)
function _draw()
	cls(0)
	print(#fired_lasers)
	starfield()
	lasers()
	spr(ship_spr,ship_x,ship_y)
	-- blank frame when > 9 looks cool
	if flame_spr <=9 then spr(flame_spr,ship_x,ship_y+8)
	end

	
	if muzzle>0 then
		circfill(ship_x+3,ship_y-2,muzzle,muzzle>2 and 12 or 7)
		circfill(ship_x+4,ship_y-2,muzzle,muzzle>2 and 12 or 7)
	end

	for i=1,4 do
		spr(lives>=i and 12 or 13, 2 + (i-1) * 9, 2)
	end

	print("score:"..score,40,3,12)
end
-->8

function lasers()
	for i=1,#fired_lasers do
		spr(laser_spr,fired_lasers[i][1],fired_lasers[i][2])
	end
end

function animate_lasers()
	for i=1,#fired_lasers do
		fired_lasers[i][2]-=3
	end
	if laser_spr==24 then laser_spr=21
	else laser_spr+=1
	end
end

function starfield()
	for i=1,#stars_x do
		local x,y,s,col=stars_x[i],stars_y[i],stars_spd[i],6
		if s<1 then col=1
		elseif s<1.5 then col=13
		end

		if s>1.9 then line(x,y,x,y+4,col)
		else pset(x,y,col)
		end
	end
end

function animate_starfield()
	for i=1,#stars_y do
		local y=stars_y[i]
		stars_y[i]+=stars_spd[i]
		if stars_y[i]>=128 then stars_y[i]=0 end
	end
end
__gfx__
00000000000880000008800000088000000000000000000000000000000000000000000000000000000000000000000008800880088008800000000000000000
000000000099980000899800008999000000000000a77a0000077000000770000007700000a77a00000000000000000087788888800880080000000000000000
0070070000bb3800083bb3800083bb0000000000000aa000000aa00000077000000aa000000aa000000000000000000087888888800000080000000000000000
00077000009938000839938000839900000000000000000000099000000aa0000009900000000000000000000000000088888888800000080000000000000000
00077000099999808999999808999990000000000000000000000000000990000000000000000000000000000000000008888880080000800000000000000000
007007000a99a98089a99a98089a99a0000000000000000000000000000220000000000000000000000000000000000000888800008008000000000000000000
000000000a99a88088a99a88088a99a0000000000000000000000000000000000000000000000000000000000000000000088000000880000000000000000000
00000000008888000088880000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000011110000111100001111000011110000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000001cccc1001cccc1001cccc1001cccc1000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001cc77cc11cc77cc11cc77cc11cc77cc100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001c7777c11c7777c11c7777c11c7777c100000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000001cc77cc11ccc77c11cc77cc11c77ccc100000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000001cccc10001cccc001cccc100cccc10000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000001cc1000c01cc10001cc10001cc10c000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000001100000001100000110000011000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00899800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
083bb380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08399380000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
89999998000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
89a99a98000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88a99a88000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
000100002f3502e350363502c35031350293502d350273502635024350243502335022350203501e3501c3501a350183501535013350113500e3500b350073500435003350003000030002000005000050000500
