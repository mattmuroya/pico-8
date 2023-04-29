pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	player={
		x=16,
		y=20,
		dx=0,
		dy=0,
		spr=1,
	}
end

function _update()
	player.dx=0
	player.dy=0

	if btn(0) then player.dx-=1 end
	if btn(1) then player.dx+=1 end

	player.x+=player.dx
	if cmap(player) then player.x-=player.dx end

	if btn(2) then player.dy-=1 end
	if btn(3) then player.dy+=1 end

	player.y+=player.dy
	if cmap(player) then player.y-=player.dy end
end

function cmap(p)
	local x1,y1,x2,y2=p.x/8,(p.y+1)/8
	local x2,y2=(p.x+7)/8,(p.y+7)/8
	return fget(mget(x1,y1),0)
		or fget(mget(x1,y2),0)
		or fget(mget(x2,y2),0)
		or fget(mget(x2,y1),0)
end

function _draw()
	cls(1)
	map(0,0)
	spr(player.spr,player.x,player.y)
	follow_cam()
end

function follow_cam()
	cam_x,cam_y=player.x-60,player.y-60
	if cam_x<=0 then cam_x=0 end
	if cam_x>=128 then cam_x=128 end
	if cam_y<=0 then cam_y=0 end
	if cam_y>=128 then cam_y=128 end
	camera(cam_x,cam_y)
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777776666666655555555
000000000eeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777776666666655555555
00700700eeeeeeee0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777776666666655555555
00077000eefffffe0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777776666666655555555
00077000eff2ff2f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777776666666655555555
00700700efffffff0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777776666666655555555
00000000eebbbb000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777776666666655555555
000000000ed00d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000777777776666666655555555
__gff__
0000000000000000000000000000010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
000000000000000000000000000000000e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000e0e0e0e0f0f0f0f0f0f0f0f0f0f0f0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000f0f0f0f0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000000d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e0e0d0d0d0d0d0d0d0d0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0d0d0d0d0d0d0d0d0f0f0f0f0f0f0d0d0d0d0d0d0d0d0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0f0f0f0f0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0f0f0f0f0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0d0d0d0d0d0d0d0d0d0d0d0e0e0e0e0e0e0e0e0d0d0d0d0d0d0d0d0d0d0d0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e0e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000