pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- to-dos

-- powerups
--   s speed up ❎
--   1 1up ❎
--   3 multiball
--   m megaball ❎
--   r reduce ❎
--   e expand ❎

-- main loop

function _init()
    mode = "start"
    levels = {
        -- level 1
        {
            "         ",
            " ixtbtxi ",
            " bb333bb ",
            "         ",
            "         "
        },
        -- level 2
        {
            "         ",
            "         ",
            "         ",
            "         ",
            "        t"
        },
        -- level 3
        {
            -- " b     b ",
            -- "  b   b  ",
            -- "  bbbbb  ",
            -- " bb b bb ",
            -- "bbbbbbbbb",
            -- "b bbbbb b",
            -- "b b   b b",
            -- "   b b   "
            "     x    "
        }
    }
end

function _update60()
    if not btn(5) then btn_released = true end
    if mode == "start" then update_start() end
    if mode == "clear" then update_clear() end
    if mode == "win" then update_win() end
    if mode == "over" then update_over() end
    if mode == "game" then update_game() end
end

function _draw()
    if mode == "start" then draw_start() end
    if mode == "clear" then draw_clear() end
    if mode == "win" then draw_win() end
    if mode == "over" then draw_over() end
    if mode == "game" then draw_game() end
end

-->8
-- update functions
function update_start()
    cls(1)
    if btn_released and btn(5) then
        level = 1
        score = 0
        lives = 4
        mode = "game"
        build(levels[level])
        btn_released = false
    end
end

function update_clear()
    if btn_released and btn(5) then
        mode = "game"
        build(levels[level])
        btn_released = false
    end
end

function update_win()
    if btn_released and btn(5) then
        mode = "start"
        btn_released = false
    end
end

function update_over()
    if btn_released and btn(5) then
        mode = "start"
        btn_released = false
    end
end

function update_game()
    -- loop timed powerups
    paddle.w = 24
    if speed_up_duration > 0 then speed_up_duration -= 1 end
    if megaball_duration > 0 then megaball_duration -= 1 end
    if expand_duration > 0 then
        paddle.w = 48
        expand_duration -= 1
    end
    if reduce_duration > 0 then
        paddle.w = 12
        reduce_duration -= 1
    end

    -- dampen paddle speed
    paddle.dx *= 0.6
    if abs(paddle.dx) < 0.5 then paddle.dx = 0 end

    -- get input and set paddle speed
    if btn(0) and btn(1) then
        if prev_dir == "l" then
            paddle.dx = 3
            if paddle.sticky then balls[1].dx = 1 end
        elseif prev_dir == "r" then
            paddle.dx = -3
            if paddle.sticky then balls[1].dx = -1 end
        end
    elseif btn(0) then
        prev_dir = "l"
        paddle.dx = -3
        if paddle.sticky then balls[1].dx = -1 end
    elseif btn(1) then
        prev_dir = "r"
        paddle.dx = 3
        if paddle.sticky then balls[1].dx = 1 end
    end

    -- move paddle
    paddle.x += paddle.dx

    -- reset paddle if out of bounds
    if paddle.x < 0 then
        paddle.x = 0
        paddle.dx = 0
    elseif paddle.x + paddle.w > 127 then
        paddle.x = 127 - paddle.w
        paddle.dx = 0
    end

    -- move ball
    if btn_released and btn(5) then
        btn_released = false
        paddle.sticky = false
    end

    if paddle.sticky then
        balls[1].x = paddle.x + paddle.w / 2
    else
        for ball in all(balls) do
            ball.x += ball.dx * (speed_up_duration > 0 and 1.5 or 1)
            ball.y += ball.dy * (speed_up_duration > 0 and 1.5 or 1)
        end
    end

    -- loop pills
    for pill in all(pills) do
        pill.y += 0.75
        if collide(pill, paddle) then
            if pill.type == "s" then
                speed_up_duration = 300
            elseif pill.type == "1" then
                lives += 1
            elseif pill.type == "3" then
                for i = 1, #balls do
                    local b1, b2
                    -- if balls[i].y < 0 then -- moving up
                        lower_angle(balls[i])
                        b1 = make_ball(balls[i].x, balls[i].y, balls[i].dx, balls[i].dy)
                        raise_angle(b1)
                        b2 = make_ball(b1.x, b1.y, b1.dx, b1.dy)
                        raise_angle(b2)
                    -- elseif balls[i] > 0 then -- moving down
                        -- lower an
                    -- end
                    add(balls, b1)
                    add(balls, b2)
                end
            elseif pill.type == "m" then
                megaball_duration = 300
            elseif pill.type == "r" then
                reduce_duration = 300
                expand_duration = 0
            elseif pill.type == "e" then
                expand_duration = 300
                reduce_duration = 0
            end
            del(pills, pill)
        end
        if pill.y + pill.r >= 127 then
            del(pills, pill)
        end
    end

    -- detect miss
    for ball in all(balls) do
        if ball.y + ball.r > 127 then
            sfx(2)
            del(balls, ball)
        end
    end

    -- if miss all
    if #balls == 0 then
        lives -= 1
        add(balls, make_ball(paddle.x + paddle.w / 2, paddle.y - 2 - 1, 1, -1))
        paddle.sticky = true
        multiplier = 0
    end

    -- collide ball with walls; reset position if out of bounds
    for ball in all(balls) do
        if ball.x + ball.r > 127 then
            ball.x = 127 - ball.r
            ball.dx = -ball.dx
            sfx(0)
        elseif ball.x - ball.r < 0 then
            ball.x = ball.r
            ball.dx = -ball.dx
            sfx(0)
        elseif ball.y - ball.r <= 11 then
            ball.y = ball.r + 11
            ball.dy = -ball.dy
            sfx(0)
        end

        -- collide ball with bricks
        ball.first_hit = true
        for i = 1, #bricks do
            for j = 1, #bricks[i] do
                local brick = bricks[i][j]
                if brick.timer ~= nil then
                    if brick.timer <= 0 then
                        react_to_hit(i, j)
                        update_score()
                        brick.timer = nil
                    else
                        brick.timer -= 1
                    end
                end

                if collide(ball, brick) and ball.first_hit and brick.type ~= " " then
                    if megaball_duration <= 0 or brick.type == "i" then
                        if deflect_x(ball, brick) then
                            ball.dx = -ball.dx
                        else
                            ball.dy = -ball.dy
                        end
                    end
                    ball.first_hit = false
                    sfx(3)
                    react_to_hit(i, j)
                    if brick.type ~= "i" then
                        update_multiplier()
                        update_score()
                    end
                end
            end
        end
    end

    if level_clear() then
        level += 1
        mode = level > #levels and "win" or "clear"
    end

    -- collide ball with paddle
    for ball in all(balls) do
        if collide(ball, paddle) and not paddle.sticky then
            if not ball.prev_collided then
                ball.dy = -ball.dy
                if ball.prev_defl_x then
                    ball.dy = -0.54
                    ball.dx = -1.31 * x_dir(ball)
                elseif ball.dx * paddle.dx > 0 then
                    lower_angle(ball)
                elseif ball.dx * paddle.dx < 0 then
                    raise_angle(ball)
                end
                multiplier = 0
                sfx(1)
            end
            ball.prev_collided = true
        else
            ball.prev_collided = false
        end
        -- calculate collision trajectory for next frame
        ball.prev_defl_x = deflect_x(ball, paddle)
    end
end

function make_ball(x, y, dx, dy)

    return {
        r = 2,
        dx = dx,
        dy = dy,
        x = x,
        y = y,
        first_hit = true,
    }
end

function build(level)
    paddle = {}
    paddle.w = 24
    paddle.h = 3
    paddle.x = 40
    paddle.y = 120
    paddle.dx = 0
    paddle.sticky = true

    balls = {}

    add(balls, make_ball(paddle.x + paddle.w / 2, paddle.y - 2 - 1, 1, -1))

    multiplier = 0

    speed_up_duration = 0
    expand_duration = 0
    reduce_duration = 0
    megaball_duration = 0

    pills = {}
    bricks = {}

    for i = 1, #level do
        add(bricks, {})
        for j = 1, #level[i] do
            add(
                bricks[i], make_brick(
                    1 + (j - 1) % 9 * 14,
                    18 + (i - 1) * 6,
                    13,
                    4,
                    level[i][j]
                )
            )
        end
    end
end

function make_brick(x, y, w, h, type)
    local brick = {
        x = x,
        y = y,
        w = w,
        h = h,
        type = type
    }
    return brick
end

function collide(ball, rect)
    return
        not (rect.y - ball.y > ball.r + 1
                or ball.y - (rect.y + rect.h) > ball.r + 1
                or rect.x - ball.x > ball.r + 2
                or ball.x - (rect.x + rect.w) > ball.r + 1
            ) -- to-do: reject collision if ball at corner outside radius

end

function react_to_hit(i, j)
    local brick = bricks[i][j]
    if brick.type == "b" then
        brick.type = " "
    elseif brick.type == "t" then
        brick.type = "b"
    elseif brick.type == "x" then
        set_timers_on_adj(i, j)
        brick.type = " " -- to-do: replace with explosion animation
    elseif is_powerup(brick) then
        drop_pill(i, j, brick.type)
        brick.type = " "
    end
end

function drop_pill(i, j, type)
    local brick = bricks[i][j]
    local pill = {
        x = flr(brick.x + brick.w / 2),
        y = brick.y + brick.h / 2,
        r = 2,
        type = type
    }
    add(pills, pill)
end

function set_timers_on_adj(i, j)
    if i > 1 and is_reactive(bricks[i - 1][j].type) then bricks[i - 1][j].timer = 6 end
    if i < #bricks and is_reactive(bricks[i + 1][j].type) then bricks[i + 1][j].timer = 6 end
    if j > 1 and is_reactive(bricks[i][j - 1].type) then bricks[i][j - 1].timer = 6 end
    if j < #bricks[i] and is_reactive(bricks[i][j + 1].type) then bricks[i][j + 1].timer = 6 end
end

function update_multiplier()
    if multiplier == 0 then
        multiplier = 1 * (reduce_duration > 0 and 2 or 1)
    elseif multiplier < 8 then
        multiplier *= 2 * (reduce_duration > 0 and 2 or 1)
    end
end

function update_score()
    score += 10 * (multiplier > 0 and multiplier or 1)
end

function level_clear()
    for i = 1, #bricks do
        for j = 1, #bricks[i] do
            if is_reactive(bricks[i][j].type) then return false end
        end
    end
    return true
end

function is_reactive(type)
    return type ~= " " and type ~= "i"
end

function is_powerup(brick)
    return brick.type == "s"
        or brick.type == "1"
        or brick.type == "3"
        or brick.type == "m"
        or brick.type == "r"
        or brick.type == "e"
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

function raise_angle(ball)
    local x_dir = x_dir(ball)
    local y_dir = y_dir(ball)
    if -abs(ball.dy) == -0.54 then
        ball.dy = 1 * y_dir
        ball.dx = 1 * x_dir
    elseif -abs(ball.dy) == -1 then
        ball.dy = 1.31 * y_dir
        ball.dx = 0.54 * x_dir
    elseif ball.dy == -1.31 then
        ball.dx = -ball.dx
    end
end

function lower_angle(ball)
    local x_dir = x_dir(ball)
    local y_dir = y_dir(ball)
    if -abs(ball.dy) == -1.31 then
        ball.dy = 1 * y_dir
        ball.dx = 1 * x_dir
    elseif -abs(ball.dy) == -1 then
        ball.dy = 0.54 * y_dir
        ball.dx = 1.31 * x_dir
    end
end

function x_dir(ball)
    return ball.dx / abs(ball.dx)
end

function y_dir(ball)
    return ball.dy / abs(ball.dy)
end

-->8
-- draw functions

function draw_start()
    local str = "press ❎ to start"
    print(str, 63 - (#str / 2) * 4, 60, 7)
end

function draw_clear()
    draw_game()
    local str = "clear! press ❎ to continue"
    print(str, 63 - (#str / 2) * 4, 60, 7)
end

function draw_win()
    draw_game()
    local str = "you win! play again? ❎"
    print(str, 63 - (#str / 2) * 4, 60, 7)
end

function draw_over()
    draw_game()
    local str = "game over! try again? ❎"
    print(str, 63 - (#str / 2) * 4, 60, 7)
end

function draw_game()
    cls(1)
    rectfill(0, 0, 127, 10, 0)

    print("lives:" .. lives, 2, 3, 7)

    local multiplier_str = "combo:" .. (multiplier > 1 and multiplier .. "x" or "--")
    print(multiplier_str, 63 - #multiplier_str * 4 / 2, 3, 7)

    local score_str = "score:" .. score
    print(score_str, 126 - #score_str * 4, 3, 7)

    for i = 1, #bricks do
        for j = 1, #bricks[i] do
            if bricks[i][j].type ~= " " then
                local brick = bricks[i][j]
                rectfill(brick.x + 1, brick.y + 1, brick.x + brick.w, brick.y + brick.h, 0)
                rectfill(
                    brick.x, brick.y, brick.x + brick.w - 1, brick.y + brick.h - 1,
                    brick.type == "b" and 11
                        or brick.type == "t" and 3
                        or brick.type == "i" and 6
                        or brick.type == "x" and 10
                        or 12
                )
            end
        end
    end

    for pill in all(pills) do
        circfill(pill.x, pill.y, 2, 12)
    end

    for ball in all(balls) do
        circfill(ball.x + 1, ball.y + 1, ball.r, 3)
        circfill(ball.x, ball.y, ball.r, 11)
    end
    
    if paddle.sticky then
        line(
            balls[1].x + balls[1].dx * 5,
            balls[1].y + balls[1].dy * 5,
            balls[1].x + balls[1].dx * 10,
            balls[1].y + balls[1].dy * 10,
            11
        )
    end

    rectfill(paddle.x + 1, paddle.y + 1, paddle.x + paddle.w + 1, paddle.y + paddle.h + 1, 2)
    rectfill(paddle.x, paddle.y, paddle.x + paddle.w, paddle.y + paddle.h, 6)
end

-->8
-- utils

function log(input)
    printh("> " .. tostr(input))
end

__gfx__
00000000088008800880088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000877888888008800800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700878888888000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000888888888000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000088888800800008000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700008888000080080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000880000008800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100000b5500b550175000b50017500175001750017500175002350023500235002350023500235002350021500235002350023500235002350021500235002250020500225002250022500005000050000500
000100001755017550175000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500005000050000500
000100000443004430034000b40007400044400444004400014000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
00030000006002664019630106200a620076100361000610016000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600006000060000600
