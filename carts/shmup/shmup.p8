pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- main loop

function _init()
	cls(0)
	mode="start"
	blink_t=1
end

function _update()
	blink_t+=1
	if mode=="game" then update_game()
	elseif mode=="start" then update_start()
	elseif mode=="over" then update_over()
	end
end

function _draw()
	if mode=="game" then draw_game()
	elseif mode=="start" then draw_start()
	elseif mode=="over" then draw_over()
	end
	-- debug
	-- print("debug",1,122,7)
end

function start_game()
	mode="game"
	-- init stars
	stars={}
	for i=1,80 do
		add(stars,{
			x=flr(rnd(128)),
			y=flr(rnd(128)),
			spd=rnd(1.5)+0.5
		})
	end
	-- init ship
	ship={
		spr=2,
		x=60,
		y=60,
		spd={
			x=0,
			y=0
		}
	}
	--init flame
	flame=5
	-- init lasers
	lasers={}
	muzzle=0
	-- init player stats
	score=10000
	lives=2
end
-->8
-- utils

function blink()
	local frames = {5,5,5,5,5,5,5,5,5,6,6,7,7,6,6}
	if blink_t>#frames then blink_t=1 end
	return frames[blink_t]
end
-->8
-- update functions

function update_game()
	--reset speed and sprite
	ship.spd.x=0
	ship.spd.y=0
	ship.spr=2
	--animate starfield
	for i=1,#stars do
		local star=stars[i]
		star.y+=star.spd
		if star.y>=128 then star.y=0
		end
	end
	--set x speed
	if btn(0) and btn(1) then
		if btn_0_was_last then ship.spd.x+=2
		else ship.spd.x-=2
		end
	elseif btn(0) then 
		btn_0_was_last=true
		ship.spd.x-=2
		ship.spr=1
	elseif btn(1) then
		btn_0_was_last=false
		ship.spd.x+=2
		ship.spr=3
	end
	--set y speed
	if btn(2) and btn(3) then
		if btn_2_was_last then ship.spd.y+=2
		else ship.spd.y-=2
		end
	elseif btn(2) then 
		btn_2_was_last=true
		ship.spd.y-=2
	elseif btn(3) then
		btn_2_was_last=false
		ship.spd.y+=2
	end
	--calculate ship position
	ship.x+=ship.spd.x
	ship.y+=ship.spd.y
	--animate flame
	if flame>9 then flame=5
	else flame+=1
	end
	--fire laser
	if btnp(5) then
		add(lasers,{
			x=ship.x,
			y=ship.y-4,
			spr=21
		})
		muzzle=5
		sfx(0)
	end
	--animate lasers
	for i=#lasers,1,-1 do
		lasers[i].y-=3
		if lasers[i].y<-8 then del(lasers,lasers[i])
		elseif lasers[i].spr<24 then lasers[i].spr+=1
		else lasers[i].spr=21
		end
	end
	--animate muzzle
	if muzzle>0 then muzzle-=1
	end
	--reset position if hit bound
	if ship.x>=120 then	ship.x=120
	elseif ship.x<=0 then	ship.x=0
	end
	if ship.y>=120 then	ship.y=120
	elseif ship.y<=0 then	ship.y=0
	end
end

function update_start()
	if btnp(5) or btnp(4) then start_game()
	end
end

function update_over()
	if btnp(5) or btnp(4) then mode="start"
	end
end
-->8
-- draw functions

function draw_game()
	cls(0)
	-- draw starfield
	for i=1,#stars do
		local star,color = stars[i],6
		if star.spd<1 then color=1
		elseif star.spd<1.5 then color=13
		end
		if star.spd>1.9 then line(star.x,star.y,star.x,star.y+4,color)
		else pset(star.x,star.y,color)
		end
	end
	-- draw ship and flame
	spr(ship.spr,ship.x,ship.y)
	if flame <=9 then spr(flame,ship.x,ship.y+8)
	end
	for i=1,#lasers do
		local laser=lasers[i]
		spr(laser.spr,laser.x,laser.y)
	end
	if muzzle>0 then
		circfill(ship.x+3,ship.y-2,muzzle,muzzle>2 and 12 or 7)
		circfill(ship.x+4,ship.y-2,muzzle,muzzle>2 and 12 or 7)
	end
	-- draw player stats
	print("score:"..score,40,3,12)
	for i=1,4 do
		spr(lives>=i and 12 or 13, 2 + (i-1) * 9, 2)
	end
end

function draw_start()
	cls(1)
	print("my awesome shmup",32,40,12)
	print("press any key to start",20,80,blink())
end

function draw_over()
	cls(8)
	print("game over",46,40,2)
	print("press any key to continue",15,80,blink())
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
