pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function log(input)
  printh("> " .. tostr(input))
end

function _init()
  cls()

  paddle = {}
  paddle.w = 24
  paddle.h = 3
  paddle.x = 30
  paddle.y = 120
  paddle.dx = 0

  ball = {}
  ball.r = 2
  ball.x = 40
  ball.y = 60
  ball.dx = 1
  ball.dy = 1
  ball.c = 11
end

function _update()
  -- dampen paddle speed
  paddle.dx *= .5

  -- get input and set paddle speed
  if btn(0) then paddle.dx = -5 end
  if btn(1) then paddle.dx = 5 end

  -- move paddle
  paddle.x += paddle.dx

  -- reset paddle if out of bounds
  if paddle.x < 0 then paddle.x = 0 end
  if paddle.x + paddle.w > 127 then paddle.x = 127 - paddle.w end

  -- move ball
  ball.x += ball.dx
  ball.y += ball.dy

  -- collide ball with paddle
  if collide(ball, paddle) then
    -- to-do: reset position if overlapping paddle
    if deflect_x(ball,paddle) then ball.dx = -ball.dx
    else ball.dy = -ball.dy end
    sfx(1)
  end

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
  if ball.y + ball.r > 127 then
    ball.y = 127 - ball.r
    ball.dy = -ball.dy
    sfx(0)
  end
  if ball.y -ball.r < 0 then
    ball.y = ball.r
    ball.dy = -ball.dy
    sfx(0)
  end

  -- to-do: revisit alternate wall collision logic; necessary to reset position?
  -- if ball.x >= 127 - ball.r or ball.x <= ball.r then ball.dx = -ball.dx sfx(0) end
  -- if ball.y >= 127 - ball.r or ball.y <= ball.r then ball.dy = -ball.dy sfx(0) end

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
      or rect.x - ball.x > ball.r + 1
      or ball.x - (rect.x + rect.w) > ball.r + 1
    )
end

function deflect_x(ball, rect)
  if ball.dx == 0 then return false end
  if ball.dy == 0 then return true end

  local slope = ball.dy / ball.dx
  local dist_to_corner_x, dist_to_corner_y

  if slope > 0 then
    if ball.dx > 0 then
      if ball.x >= rect.x then return false end
      dist_to_corner_x = rect.x - ball.x
      dist_to_corner_y = rect.y - ball.y
    else
      if ball.x <= rect.x + rect.w then return false end
      dist_to_corner_x = (rect.x + rect.w) - ball.x
      dist_to_corner_y = (rect.y + rect.h) - ball.y
    end
    slope_to_corner = dist_to_corner_y / dist_to_corner_x
    return slope > slope_to_corner
  else
    if ball.dx > 0 then
      if ball.x >= rect.x then return false end
      dist_to_corner_x = rect.x - ball.x
      dist_to_corner_y = (rect.y + rect.h) - ball.y
    else
      if ball.x <= rect.x + rect.w then return false end
      dist_to_corner_x = (rect.x + rect.w) - ball.x
      dist_to_corner_y = rect.y - ball.y
    end
    slope_to_corner = dist_to_corner_y / dist_to_corner_x
    return slope < slope_to_corner
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
