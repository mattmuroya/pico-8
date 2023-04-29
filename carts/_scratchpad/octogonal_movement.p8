pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	cls(0)
	player={
		x=16,
		y=20,
		dx=0,
		dy=0,
	}
end

function _update()
	player.dx=0
	player.dy=0
  if btn(0) and btn(1) then
		if last_xdir=="left" then
			player.dx=2
			player.rev=false
		elseif last_xdir=="right" then
			player.dx=-2
			player.rev=true
		end
	elseif btn(0) then
		last_xdir="left"
		player.dx=-2
		player.rev=true
	elseif btn(1) then
		last_xdir="right"
		player.dx=2
		player.rev=false
	end
	player.x+=player.dx
	-- get y input
	if btn(2) and btn(3) then
		if last_ydir=="up" then
			player.dy=2
		elseif last_ydir=="down" then
			player.dy=-2
		end
	elseif btn(2) then
		last_ydir="up"
		player.dy=-2
	elseif btn(3) then
		last_ydir="down"
		player.dy=2
	end
	player.y+=player.dy
end

function _draw()
	cls(1)
	circfill(player.x,player.y,3,7)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
