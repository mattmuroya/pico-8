pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- main loop

function _init()
	cls(0)
	start_screen()
	t=1
end

function _update()
	t+=1
	if t>1000 then t=1 end
	if mode=="game" then update_game()
	elseif mode=="wave_text" then update_wave_text()
	elseif mode=="start" then update_start()
	elseif mode=="over" then update_over()
	elseif mode=="win" then update_win()
	end
end

function _draw()
	if mode=="game" then draw_game()
	elseif mode=="wave_text" then draw_wave_text()
	elseif mode=="start" then draw_start()
	elseif mode=="over" then draw_over()
	elseif mode=="win" then draw_win()
	end
end

function start_screen()
	mode="start"
	music(1)
end

function start_game()
	wave=0
	next_wave()
	t=0
	-- init stars
	stars={}
	for i=1,70 do
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
		sx=0,
		xy=0,
		flash=0
	}
	-- init flame
	flame=5
	-- init lasers
	lasers={}
	muzzle=0
	cooldown=0

	-- init shockwaves
	shwaves={}
	-- init enemies
	enemies={}
	-- init particle system
	particles={}
	-- init player stats
	score=0
	lives=4
	invulnerable=0
end
-->8
-- utils

function log(input)
	printh("> "..input)
end

function blink()
	local frames = {5,5,5,5,5,5,5,5,5,6,6,7,7,6,6}
	if t>#frames then t=1 end
	return frames[t]
end

function draw_sprite(sprite)
	spr(sprite.spr,sprite.x,sprite.y)
end

function collide(a,b)
	if a.y>b.y+7 or
			a.y+7<b.y or
			a.x>b.x+7 or
			a.x+7<b.x then
		return false
		else return true
	end
end

function spawn_wave()
	spawn_enemy()
end

function next_wave()
	wave+=1

	if wave>2 then
		mode="win"
	else
		mode="wave_text"
		wave_text_timer=90
	end

end

function spawn_enemy()
	add(enemies,{
		spr=37,
		blue=rnd()<.5 and true or false,
		x=rnd(120),
		y=-8,
		hp=5,
		flash=0
	})
end

function explode(x,y,is_blue)
	add(particles,{
		x=x,
		y=y,
		sx=0,
		sy=0,
		age=0,
		max=0,
		r=10,
		is_blue=is_blue
	})
	for i=1,20 do
		add(particles,{
			x=x,
			y=y,
			sx=(rnd()-.5)*5,
			sy=(rnd()-.5)*5,
			age=flr(rnd(2)),
			max=10+rnd(10),
			r=rnd(3)+1,
			is_blue=is_blue
		})
	end
	for i=1,20 do
		add(particles,{
			x=x,
			y=y,
			sx=(rnd()-.5)*10,
			sy=(rnd()-.5)*10,
			age=flr(rnd(2)),
			max=10+rnd(10),
			r=rnd(3)+1, -- not really a radius but that's ok
			spark=true
		})
	end
end

function shwave(x,y,r,target_r,spd,color)
	add(shwaves,{
		x=x,
		y=y,
		r=r,
		target_r=target_r,
		spd=spd,
		color=color
	})
end

function smol_sparks(x,y)
	for i=1,2 do
		add(particles,{
			x=x,
			y=y,
			sx=(rnd()-.5)*5,
			sy=(rnd()-.8)*5,
			age=flr(rnd(2)),
			max=2+rnd(2),
			r=rnd(3)+1, -- not really a radius but that's ok
			spark=true
		})
	end
end

function step_color(age, is_blue)
	local steps=is_blue and {6,12,13,1} or {10,9,8,2}
	if age>16 then return 5
	elseif age>12 then return steps[4]
	elseif age>8 then return steps[3]
	elseif age>5 then return steps[2]
	elseif age>3 then return steps[1]
	else return 7
	end
end
-->8
-- update functions

function update_game()
	--reset speed and sprite
	ship.sx=0
	ship.sy=0
	ship.spr=2
	--animate starfield
	for star in all(stars) do
		star.y+=star.spd
		if star.y>=128 then star.y=0
		end
	end
	--set x speed
	if btn(0) and btn(1) then
		if btn_0_was_last then ship.sx+=2
		else ship.sx-=2
		end
	elseif btn(0) then 
		btn_0_was_last=true
		ship.sx-=2
		ship.spr=1
	elseif btn(1) then
		btn_0_was_last=false
		ship.sx+=2
		ship.spr=3
	end
	--set y speed
	if btn(2) and btn(3) then
		if btn_2_was_last then ship.sy+=2
		else ship.sy-=2
		end
	elseif btn(2) then 
		btn_2_was_last=true
		ship.sy-=2
	elseif btn(3) then
		btn_2_was_last=false
		ship.sy+=2
	end
	--calculate ship position
	ship.x+=ship.sx
	ship.y+=ship.sy
	-- reset position if hit bound
	if ship.x>=120 then	ship.x=120
	elseif ship.x<=0 then	ship.x=0
	end
	if ship.y>=120 then	ship.y=120
	elseif ship.y<=0 then	ship.y=0
	end
	--animate flame
	if flame>9 then flame=5
	else flame+=1
	end
	--fire laser
	if btn(5) then
		if cooldown==0 then
			sfx(0,0)
			add(lasers,{
				x=ship.x,
				y=ship.y-4,
				spr=21
			})
			muzzle=5
			cooldown=4
		end
	end
	if cooldown>0 then cooldown-=1
	end
	--animate lasers and muzzle
	for laser in all(lasers) do
		laser.y-=3
		if laser.y<-8 then del(lasers,laser)
		elseif laser.spr<24.5 then laser.spr+=.5
		else laser.spr=21
		end
	end
	if muzzle>0 then muzzle-=1
	end
	-- animate enemies
	for enemy in all(enemies) do
		enemy.y+=1
		if enemy.y>=128 then
			del(enemies,enemy)
			spawn_enemy()
		elseif enemy.spr<40.9 then enemy.spr+=.1
		else enemy.spr=37
		end
	end
	-- collide lasers x enemies
	for enemy in all(enemies) do
		for laser in all(lasers) do
			if enemy.y>=-4 and collide(enemy,laser) then
				sfx(3)
				enemy.flash=2
				del(lasers, laser)
				enemy.hp-=1
				shwave(laser.x+4,laser.y+4,3,6,1,12)
				smol_sparks(laser.x+4,laser.y+4)
				if enemy.hp<=0 then
					sfx(2)
					del(enemies, enemy)
					explode(enemy.x+4,enemy.y+4,true)
					shwave(enemy.x+4,enemy.y+4,3,28,3,6)
					score+=1
					if #enemies==0 then
						next_wave()
					end
				end
			end
		end
	end
	-- collide ship x enemies
	if invulnerable==0 then
		for enemy in all(enemies) do
			if collide(enemy,ship) then
				sfx(1)
				explode(ship.x+4,ship.y+4,false)
				shwave(ship.x+4,ship.y+4,3,28,3,6)
				ship.flash=2
				lives-=1
				invulnerable=60
				-- del(enemies,enemy)
				-- spawn_enemy()
			end
		end
	else invulnerable-=1
	end
	-- check for game over
	if lives<=0 then
		mode="over"
		music(6)
	end
end

function update_wave_text()
	update_game()
	log(wave_text_timer)
	wave_text_timer-=1
	if wave_text_timer<=0 then
		mode="game"
		spawn_wave()
	end
end

function update_start()
	if btn(4)==false and btn(5)==false then
		btn_released=true
	end
	if btn_released then
		if btnp(4) or btnp(5) then
			start_game()
			music(-1,1000)
			btn_released=false
		end
	end
end

function update_over()
	if btn(4)==false and btn(5)==false then
		btn_released=true
	end
	if btn_released then
		if btnp(4) or btnp(5) then
			start_screen()
			btn_released=false
		end
	end
end

function update_win()
	if btn(4)==false and btn(5)==false then
		btn_released=true
	end
	if btn_released then
		if btnp(4) or btnp(5) then
			start_screen()
			btn_released=false
		end
	end
end
-->8
-- draw functions

function draw_game()
	cls(0)
	-- draw starfield
	for star in all(stars) do
		local color=6
		if star.spd<1 then color=1
		elseif star.spd<1.5 then color=13
		end
		pset(star.x,star.y,color)
	end
	-- draw enemies
	for enemy in all(enemies) do
		if enemy.flash>0 then
			enemy.flash-=1
			for i=1,15 do
				pal(i,7)
			end
		elseif enemy.blue then
			pal(11,12)
			pal(3,1)
		end
		draw_sprite(enemy)
		pal()
	end
	-- draw particle explosion
	for p in all(particles) do
		if p.spark then pset(p.x,p.y,6)
		else circfill(p.x,p.y,p.r,step_color(p.age,p.is_blue))
		end
		p.x+=p.sx
		p.y+=p.sy
		p.age+=1
		p.sx*=.9
		p.sy*=.9
		if p.age>p.max then
			p.r-=0.5
			if p.r<=0 then del(particles,p)
			end
		end
	end
	-- draw ship
	if invulnerable==0 or sin(t/5)>0 then
		if ship.flash>0 then
			ship.flash-=1
			for i=1,15 do
				pal(i,7)
			end
		end
		draw_sprite(ship)
		pal()
		if flame <=9 then spr(flame,ship.x,ship.y+8)
		end
	end
	-- draw lasers and muzzle
	for laser in all(lasers) do
		draw_sprite(laser)
	end
	if muzzle>0 then
		circfill(ship.x+3,ship.y-2,muzzle,muzzle>2 and 12 or 7)
		circfill(ship.x+4,ship.y-2,muzzle,muzzle>2 and 12 or 7)
	end
	-- draw shwaves
	for s in all(shwaves) do
		circ(s.x,s.y,s.r,s.color)
		if s.r<s.target_r then s.r+=s.spd
		else del(shwaves,s)
		end
	end
	-- draw player stats
	print("score:"..score,40,3,12)
	for i=1,4 do
		spr(lives>=i and 12 or 13, 2 + (i-1) * 9, 2)
	end
end

function draw_wave_text()
	draw_game()
	print("wave "..wave,53,40,blink())
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

function draw_win()
	cls(11)
	print("congratulations!",46,40,2)
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
0000000000000000000000000000000000000000001cc10000c1cc10001cc10001cc1c0000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000001100000001100000110000011000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000bbbb0000bbbb0000bbbb0000bbbb0000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000b3223b00b3333b00b3223b00b3333b000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000b322823bb332233bb328223bb332233b00000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000b328823bb328823bb328823bb328823b00000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000bbbbbb00bbbbbb00bbbbbb00bbbbbb000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000f000000f0f0000f0f000000f0f0000f000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000f0000f000f00f000f0000f000f00f0000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000005000050000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000090000000002222005050000505022000500000000000055090000000000000000000000000000000000000000000000000000
00000000000000000000000099900000005228882252250000500955552550050000000005000000000000000000000000000000000000000000000000000000
00000909990000000009099999990000050888095998250005005505555555000005550050000000000000000000000000000000000000000000000000000000
0000a0a777900000000099aaaaa9900000880999a999025000055959a95555550005555000550000000000000000000000000000000000000000000000000000
000a0a7777a9000000999aa77aaa90000089599aaaa9585000055522559955500905555005555000000000000000000000000000000000000000000000000000
00009a77777900000099aa7777aa990002859aaa77a998000509599aa99258000555550055555000000000000000000000000000000000000000000000000000
0000a777777900000009aa77777aa9000525aa7777a9880000555a2a2a9558500055000050500000000000000000000000000000000000000000000000000000
0000a7777aa900000009aa77777aa9000029aaa77aa998000059552a882550500005050000005550000000000000000000000000000000000000000000000000
00009a777a90000000099aa77aaaa90000299aaaaa99985000655552aa5595500000000500000550000000000000000000000000000000000000000000000000
000009aaa0a0000000009aaaaaaa990000889999a995885000550952295055000055550005000000000000000000000000000000000000000000000000000000
000000990a0000000009099a99999000059588959990855050558555555555500055555505505550000000000000000000000000000000000000000000000000
00000000000000000000009990090000005228899988200000500555995500500055509055005500000000000000000000000000000000000000000000000000
00000000000000000000000000000000000002588222000000000255550000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000502200505500000005000000090000000005500000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000055000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00088008800088008800088008800088008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00877888880877888880800880080800880080000cc00cc00cc0ccc0ccc00000cc00ccc0ccc0ccc0ccc000000000600000000000000000000000000000000000
0087888888087888888080000008080000008000c000c000c0c0c0c0c0000c000c00c0c0c0c0c0c0c0c000000000000000000000000000000000000000000000
0088888888088888888080000008080000008000ccc0c000c0c0cc00cc0000000c00c0c0c0c0c6c0c0c000000000000000000000000000000000000000000000
000888888000888888000800008000800008000000c0c000c0c0c0c0c0000c000c00c0c0c0c0c6c0c0c000000000000000000000000000000000000000000000
0000888800000888800000800800000800800000cc000cc0cc00c0c0ccc00000ccc0ccc0ccc0ccc0ccc000000000000000000000000000000000000000000000
00000880000000880000000880000000880000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000600000000600000000000000000000000000000000000000000000000000
0000000000000000000000100000d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00010000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d00
00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00600000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000
00600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006001000000000000000000d000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000bbbb00000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000060b3333b0000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000006b332233b000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000d00000000000d0000000000000000006b328823b000000000000000000000000000000000000000000000000000000000000
0000000000000000d00000000000000000000000000000000000000000060bbbbbb0000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000060f0000f0000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000f00f00000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000d00000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000d0000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000d000060000000000000000000000000100000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000006000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000100000000000000001000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000088000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000d000000000000000000000100000000000899800000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000d000000000000000000000000000083bb380000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000008399380000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000089999998000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000089a99a98000000000000000000000010000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000088a99a88000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000888800000000000000000000000006000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000600100000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000d00000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000d000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000000000000000000000000d0000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d00000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000600000000000600000060000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000d600000000d0000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000
00000000001000000000000006000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000d000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000600000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000100000000000000000000000d00000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000010000000000000600000000000000000000000000000000000000000010000000000000000000000000000000000000000
00000000000000000000000000000000000000000000600000000000000000000000000006000000000000000000000000000000000000000000000000000000

__sfx__
000100003455032550305502e5502b550285502555022550205501b55018550165501355011550010000f5500c5500a5500855006550055500455003550015500055000000000000000000000000000100000000
000100002b650366402d65025650206301d6201762015620116200f6100d6100a6100761005610046100361002610026000160000600006000060000600006000000000000000000000000000000000000000000
00010000377500865032550206300d620085200862007620056100465004610026000260001600006200070000700006300060001600016200160001600016200070000700007000070000700007000070000700
000100000961025620006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
01050000010501605019050160501905001050160501905016050190601b0611b0611b061290001d0001700026000350002d000250001f0002900030000000000000000000000000000000000000000000000000
01050000205401d540205401d540205401d540205401d540225402255022550225502255000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010500001972020720227201b730207301973020740227401b7402074022740227402274000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000001f5501f5501b5501d5501d550205501f5501f5501b5501a5501b5501d5501f5501f5501b5501d5501d550205501f5501b5501a5501b5501d5501f5502755027550255502355023550225502055020550
011000000f5500f5500a5500f5501b530165501b5501b550165500f5500f5500a5500f5500f5500a550055500a5500e5500f5500f550165501b5501b550165501755017550125500f5500f550125501055010550
011000001e5501c5501c550175501e5501b550205501d550225501e55023550205501c55026550265500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110000017550145501455010550175500b550195500d5501b5500f5501c550105500455016550165500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
090d00001b0301b0001b0201d0201e0302003020040200401b7001d700227001a7001b7001b700227001b7001b7001d7001b7001b7001b7001d700227001a7001b7001b700167001b7001b7001b7001c7001c700
050d00001f5301f0001f52021520225302453024530245301e7001e70020700237002070022700227001670000000000000000000000000000000000000000000000000000000000000000000000000000000000
010d000022030220002203024030250302703027030270301b0001b0001b0001d0001e00020000200002000000000000000000000000000000000000000000000000000000000000000000000000000000000000
4d1000002b0202b0202b0202b0202b0202b0202b0202b0202b020290202b0202c0202b0202b0202b0202602026020260202702027020270202b0202b0202b0202a0302a0302a0302703027030270302003020030
4d1000002003028030280302c0302a0302a0302a0302703027030270302c0302a030290302e0302e0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010f00001e050000001e0501d0501b0501a0601a0621a062000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
050f00001b540070001b5401a54018540175501755217562075000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000070000700007000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000001b50018500185001b5001f5002250022500225001f5001d5001b5001b5001b5001d50024500295001b50018500185001b5002b50029500245001f5001b50018500185001b50000500005000050000500
001000000a5030000000000000000a5030a50000000000000a5030000009500000000a5030000000000075000a5030000000000000000a5030000000000000000a5030000000000000000a503000000000000000
__music__
04 04050644
00 07084749
04 090a484a
04 0b0c0d44
00 0e084344
04 0f0a4344
04 10114e44
