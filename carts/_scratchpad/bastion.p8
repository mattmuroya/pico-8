pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- utils

function log(input)
	printh("> "..tostr(input))
end
-->8
-- init

function _init()
	cls(0)
	poke(0x5f2d,1)
	mouse_x=0
	mouse_y=0
	platform_map={
		{ 0, 0, 0,-1,-1,-1, 0, 0},
		{-1,-1, 0,-1, 0, 0, 0,-1},
		{-1,-1, 0,-1, 0,-1,-1,-1},
		{ 0, 0, 0,-1, 0, 0, 0, 0},
		{ 0,-1, 0, 0, 0,-1,-1, 0},
		{ 0,-1,-1,-1, 0,-1, 0, 0},
		{ 0, 0, 0, 0, 0,-1,-1, 0},
		{ 0,-1,-1,-1, 0,-1,-1, 0},
	}
	wait={30,45,60,75,90,105,120,135}
end
-->8
-- update

function _update()
	mouse_x=stat(32)
	mouse_y=stat(33)
	local min_x,max_x=mouse_x-32,mouse_x+32
	local min_y,max_y=mouse_y-32,mouse_y+32
	for i=1,8 do
		for j=1,8 do
			local x,y=j*16-8,i*16-8
			local current,target=platform_map[i][j],nil
			if min_x<=x and x<=max_x and
				min_y<=y and y<=max_y then
					target=1 else target=0
			end
			if current>=0 then
					if current>target then current-=0.1 end
					if current<target then current+=0.1 end
					if current>1 then current=1 end
					if current<0 then current=0 end
			end
			platform_map[i][j]=current
		end
	end
end
-->8
-- draw

function _draw()
	cls(0)
	print_platforms()
	display_cursor()
end

function print_platforms()
	for i=1,8 do
		for j=1,8 do
			local scale=platform_map[i][j]
			if scale>=0 then
				sspr(8,0,16,22,
					-- platform's center x coordinate minus half its dimensions
					-- platform's min y coord plus up to 1.5x height as scale decreases
					(j*16-8) - 16*scale/2,
					(i-1)*16 + (1-scale)*33,
					16*scale,
					22*scale
				)
			end
		end
	end
end

function display_cursor()
	print("("..mouse_x..", "..mouse_y..")",2,2,7)
	spr(0,mouse_x-4,mouse_y-4)
end
__gfx__
00000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003eee33333333eee300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007003e333333333333e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000770003e333333333333e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003e333333333333e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003e333333333333e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000003eee33333333eee300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000333333333333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000bbbbbbbbbbbbbbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000b5b5b5b5b5b5b5b500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000555555555555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000545454545454545400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000444444444444444400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000404040404040404000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
