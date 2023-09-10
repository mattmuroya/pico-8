pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- utils

function log(input)
	printh("> " .. tostr(input))
end

-->8
-- main loop

function _init()
	cls()
	mode = "start"
end

function _update60()
	if mode == "start" then update_start() end
	if mode == "over" then update_over() end
	if mode == "game" then update_game() end
end

function _draw()
	if mode == "start" then draw_start() end
	if mode == "over" then draw_over() end
	if mode == "game" then draw_game() end
end

-->8
-- update functions

function update_start()
	if btn(4) then init_game() end
end

function update_over()
	if btn(4) then init_game() end
end

function update_game()
	-- dampen paddle speed
	paddle.dx *= 0.6
	if abs(paddle.dx) < 0.5 then paddle.dx = 0 end

	-- get input and set paddle speed
	if btn(0) and btn(1) then
		if prev_dir == "l" then paddle.dx=3
		elseif prev_dir == "r" then paddle.dx=-3
		end
	elseif btn(0) then
		prev_dir = "l"
		paddle.dx=-3
	elseif btn(1) then
		prev_dir = "r"
		paddle.dx=3
	end

	-- move paddle
	paddle.x += paddle.dx

	-- reset paddle if out of bounds
	if paddle.x < 0 then paddle.x = 0 end
	if paddle.x + paddle.w > 127 then paddle.x = 127 - paddle.w end

	-- move ball
	ball.x += ball.dx
	ball.y += ball.dy

	-- detect miss
	if ball.y + ball.r > 127 then
		lives -= 1
		sfx(2)
		if lives == 0 then
			mode = "over"
		else
			ball.x = 2
			ball.y = 40
			ball.dx = 1
			ball.dy = 1
		end
	end

	-- collide ball with paddle
	if collide(ball, paddle) then
		if not prev_collided then
			if prev_defl_x then ball.dx = -ball.dx end
			ball.dy = -ball.dy
			score += 1
			sfx(1)
		end
		prev_collided = true
	else
		prev_collided = false
	end

	-- collide ball with walls; reset position if out of bounds
	if ball.x + ball.r > 127 then
		ball.x = 127 - ball.r
		ball.dx = -ball.dx
		sfx(0)
	end
	if ball.x - ball.r < 0 then
		ball.x = ball.r
		ball.dx = -ball.dx
		sfx(0)
	end
	if ball.y - ball.r <= 11  then
		ball.y = ball.r + 11
		ball.dy = -ball.dy
		sfx(0)
	end

	-- calculate collision trajectory for next frame
	prev_defl_x = deflect_x(ball, paddle)
end

function init_game()
	prev_collided = false
	prev_defl_x = false

	max_lives = 4
	lives = 4

	score = 0

	paddle = {}
	paddle.w = 24
	paddle.h = 3
	paddle.x = 40
	paddle.y = 120
	paddle.dx = 0

	ball = {}
	ball.r = 2
	ball.x = 2
	ball.y = 40
	ball.dx = 1
	ball.dy = 1
	ball.c = 11

	mode = "game"
end

function collide(ball, rect)
	return not (
		rect.y - ball.y > ball.r + 1
			or ball.y - (rect.y + rect.h) > ball.r + 1 
			or rect.x - ball.x > ball.r + 2
			or ball.x - (rect.x + rect.w) > ball.r + 1
	)
end

function deflect_x(ball, rect)
	if ball.dx == 0 then return false end
	if ball.dy == 0 then return true end

	local slope = ball.dy / ball.dx
	local corner_dx, corner_dy

	if slope > 0 and ball.dx > 0 then
	-- ball moving SE
		corner_dx = rect.x - ball.x
		corner_dy = rect.y - ball.y
		return corner_dx > 0 and slope >= corner_dy / corner_dx
	elseif slope > 0 and ball.dx < 0 then
	--ball moving NW
		corner_dx = rect.x + rect.w - ball.x
		corner_dy = rect.y + rect.h - ball.y
		return corner_dx < 0 and slope >= corner_dy / corner_dx
	elseif slope < 0 and ball.dx > 0 then
	-- ball moving NE
		corner_dx = rect.x - ball.x
		corner_dy = rect.y + rect.h - ball.y
		return corner_dx > 0 and slope <= corner_dy / corner_dx
	elseif slope < 0 and ball.dx < 0 then
	-- ball moving SW
		corner_dx = rect.x + rect.w - ball.x
		corner_dy = rect.y - ball.y
		return corner_dx < 0 and slope <= corner_dy / corner_dx
	end
end

-->8
-- draw functions

function draw_start()
	cls(3)
	local str = "press ❎ to start"
	print(str, 63 - (#str / 2) * 4, 60, 7)
end

function draw_over()
	-- cls(3)
	local str = "game over! press ❎ to retry"
	print(str, 63 - (#str / 2) * 4, 60, 7)
end

function draw_game()
	cls(3)
	rectfill(0, 0, 127, 10, 0)

	for i = 1, max_lives do
		spr(lives >= i and 1 or 2, 2 + (i - 1) * 9, 2)
	end

	local str = "score:"..score
	print(str, 126 - #str * 4, 3, 7)

	rectfill(paddle.x, paddle.y, paddle.x + paddle.w, paddle.y + paddle.h, 7)
	circfill(ball.x, ball.y, ball.r, ball.c)
end

__gfx__
00000000088008800880088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000877888888008800800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700878888888000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000888888888000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000088888800800008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000080080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000880000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000b5500b550175000b50017500175001750017500175002350023500235002350023500235002350021500235002350023500235002350021500235002250020500225002250022500005000050000500
000100001755017550175000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000100000444004440034000b40007400044500445004400014000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
