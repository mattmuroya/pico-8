pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function log(input)
	printh("> " .. tostr(input))
end

function opposite_dir(a, b)
	return a.dx ~= 0 and b.dx ~=0 and a.dx ~ b.dx < 0
end

function _init()
	cls()

	initial_speed = 1

	prev_collided = false
	prev_defl_x = false

	paddle = {}
	paddle.w = 24
	paddle.h = 3
	paddle.x = 40
	paddle.y = 120
	paddle.dx = 0

	ball = {}
	ball.r = 2
	ball.x = 0
	ball.y = 60
	ball.dx = initial_speed
	ball.dy = initial_speed
	ball.c = 11
end

function _update60()
	-- dampen paddle speed
	paddle.dx *= 0.6
	if abs(paddle.dx) < 0.5 then paddle.dx = 0 end

	-- get input and set paddle speed
	if btn(0) then paddle.dx = -3 end
	if btn(1) then paddle.dx = 3 end

	-- move paddle
	paddle.x += paddle.dx

	-- reset paddle if out of bounds
	if paddle.x < 0 then paddle.x = 0 end
	if paddle.x + paddle.w > 127 then paddle.x = 127 - paddle.w end

	-- move ball
	ball.x += ball.dx
	ball.y += ball.dy

	-- collide ball with wall; reset position if out of bounds
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
	if ball.y - ball.r < 0 then
		ball.y = ball.r
		ball.dy = -ball.dy
		sfx(0)
	end
	if ball.y + ball.r > 127 then
		ball.x = 40
		ball.y = 60
		ball.dy = initial_speed
		ball.dx = initial_speed
		sfx(0)
	end

	-- collide ball with paddle
	if collide(ball, paddle) then
		if not prev_collided then
			if prev_defl_x then ball.dx = -ball.dx end
			ball.dy = -ball.dy
		end
		prev_collided = true
	else
		prev_collided = false
	end

	prev_defl_x = deflect_x(ball, paddle)
end

function _draw()
	cls(3)
	rectfill(paddle.x, paddle.y, paddle.x + paddle.w, paddle.y + paddle.h, 7)
	circfill(ball.x, ball.y, ball.r, ball.c)
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
		return corner_dx >= 0 and slope >= corner_dy / corner_dx
	elseif slope > 0 and ball.dx < 0 then
	--ball moving NW
		corner_dx = rect.x + rect.w - ball.x
		corner_dy = rect.y + rect.h - ball.y
		return corner_dx <= 0 and slope >= corner_dy / corner_dx
	elseif slope < 0 and ball.dx > 0 then
	-- ball moving NE
		corner_dx = rect.x - ball.x
		corner_dy = rect.y + rect.h - ball.y
		return corner_dx >= 0 and slope <= corner_dy / corner_dx
	elseif slope < 0 and ball.dx < 0 then
	-- ball moving SW
		corner_dx = rect.x + rect.w - ball.x
		corner_dy = rect.y - ball.y
		return corner_dx <= 0 and slope <= corner_dy / corner_dx
	end
end

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100000b5500b550175000b50017500175001750017500175002350023500235002350023500235002350021500235002350023500235002350021500235002250020500225002250022500005000050000500
010100001755017550175000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
