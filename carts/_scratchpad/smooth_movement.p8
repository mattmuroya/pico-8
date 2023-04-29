pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	player={
		p={x=64,y=64}, -- position
		v={x=0,y=0}, -- velocity
	}
end

function _update()
	if btn(0) then player.v.x-=0.8 end
	if btn(1) then player.v.x+=0.8 end
	if btn(2) then player.v.y-=0.8 end
	if btn(3) then player.v.y+=0.8 end
	-- dampen total player velocity by 20%
	-- eases velocity toward 0 if no input
	player.v.x*=0.8
	player.v.y*=0.8
	-- if velocity in any direction is less than 0.1, set to 0
	if abs(player.v.x)<0.1 then player.v.x=0 end
	if abs(player.v.y)<0.1 then player.v.y=0 end
	-- calculate linear speed by finding hypotenuse of player's velocity
	-- if speed > 3, reduce both the speed (to 3) and velocity proportionally
	speed=sqrt(player.v.x^2+player.v.y^2)
	if speed>3 then
		player.v.x*=3/speed
		player.v.y*=3/speed
		speed=3 -- for demo print
	end
	-- set player position
	player.p.x+=player.v.x
	player.p.y+=player.v.y
end

function _draw()
	cls(0)
	circfill(player.p.x,player.p.y,3,11)
	print("velocity: "..player.v.x..", "..player.v.y,2,2)
	print("linear speed: "..speed)
end
	
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
