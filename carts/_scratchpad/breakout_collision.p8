pico-8 cartridge // http://www.pico-8.com
version 41
__lua__

function _init()
  cls()

  box = {}
  box.x = 32
  box.y = 58
  box.w = 64
  box.h = 12

  ball = {}
  ball.x = 0
  ball.y = 0
  ball.dx = -3
  ball.dy = 2
end

function _update()
  if btn(0) then ball.x -= 1 end
  if btn(1) then ball.x += 1 end
  if btn(2) then ball.y -= 1 end
  if btn(3) then ball.y += 1 end
end

function _draw()
  cls(3)
  rect(box.x, box.y, box.x + box.w, box.y + box.h)

  local px, py = ball.x, ball.y
  for i=1,64 do
    pset(px, py)
    px += ball.dx
    py += ball.dy
  end

  print(deflect_x(ball, box) and "horizontal" or "vertical")
  print(debug1)
end

function deflect_x(ball, box)
  if ball.dx == 0 then return false end
  if ball.dy == 0 then return true end

  local slope = ball.dy / ball.dx
  local dist_to_corner_x, dist_to_corner_y

  if slope > 0 then
    if ball.dx > 0 then
      debug1 = "down right"
      if ball.x >= box.x then return false end
      dist_to_corner_x = box.x - ball.x
      dist_to_corner_y = box.y - ball.y
    else
    debug1= "up left"
      if ball.x <= box.x + box.w then return false end
      dist_to_corner_x = (box.x + box.w) - ball.x
      dist_to_corner_y = (box.y + box.h) - ball.y
    end
    slope_to_corner = dist_to_corner_y / dist_to_corner_x
    return slope > slope_to_corner
  else
    if ball.dx > 0 then
      debug1 = "up right"
      if ball.x >= box.x then return false end
      dist_to_corner_x = box.x - ball.x
      dist_to_corner_y = (box.y + box.h) - ball.y
    else
      debug1="down left"
      if ball.x <= box.x + box.w then return false end
      dist_to_corner_x = (box.x + box.w) - ball.x
      dist_to_corner_y = box.y - ball.y
    end
    slope_to_corner = dist_to_corner_y / dist_to_corner_x
    return slope < slope_to_corner
  end
end