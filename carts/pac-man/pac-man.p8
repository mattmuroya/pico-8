pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- main loop

function _init()
    mode = "game"

    p = {
        x = 64,
        y = 64,
        dx = 0,
        dy = 0,
    }

    -- map = {'
    --     █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █
    --     █                                   █
    --     █   █ █   █ █ █   █   █ █ █   █ █   █
    --     █                                   █
    --     █   █ █   █   █ █ █ █ █   █   █ █   █
    --     █         █       █       █         █
    --     █ █ █ █   █ █ █   █   █ █ █   █ █ █ █
    --           █   █               █   █
    --     █ █ █ █   █   █ █ █ █ █   █   █ █ █ █
    --                   █       █    
    --     █ █ █ █   █   █ █ █ █ █   █   █ █ █ █
    --           █   █               █
    --     █ █ █ █   █   █ █ █ █ █   █   █ █ █ █
    --     █                 █                 █
    --     █   █ █   █ █ █   █   █ █ █   █ █   █
    --     █     █                       █     █
    --     █ █   █   █   █ █ █ █ █   █   █   █ █
    --     █         █       █       █         █
    --     █   █ █ █ █ █ █   █   █ █ █ █ █ █   █
    --     █                                   █
    --     █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █

    --     █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █
    --     █               █               █
    --     █   █ █   █ █   █   █ █   █ █   █
    --     █                               █
    --     █   █ █   █   █ █ █   █   █ █   █
    --     █         █     █     █         █
    --     █ █ █ █   █ █   █   █ █   █ █ █ █
    --           █   █           █   █
    --     █ █ █ █   █   █ █ █   █   █ █ █ █
    --                   █   █    
    --     █ █ █ █   █   █ █ █   █   █ █ █ █
    --           █   █           █   █
    --     █ █ █ █   █   █ █ █   █   █ █ █ █
    --     █               █               █
    --     █   █ █   █ █   █   █ █   █ █   █
    --     █     █                   █     █
    --     █ █   █   █   █ █ █   █   █   █ █
    --     █         █     █     █         █
    --     █   █ █ █ █ █   █   █ █ █ █ █   █
    --     █                               █
    --     █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █ █

    -- '}
end

function _update60()
    if mode == "game" then update_game() end
end

function _draw()
    if mode == "game" then draw_game() end
end

-->8
-- update functions

function update_game()

    if btn(0) then p.dy = 0 p.dx = -0.5 end
    if btn(1) then p.dy = 0 p.dx = 0.5 end
    if btn(2) then p.dx = 0 p.dy = -0.5 end
    if btn(3) then p.dx = 0 p.dy = 0.5 end

    p.x += p.dx
    p.y += p.dy
end

-->8
-- draw functions

function draw_game()
    cls()
    circfill(p.x, p.y, 3, 10)
end

-->8
-- utils

function log(input)
    printh("> " .. tostr(input))
end

__gfx__
