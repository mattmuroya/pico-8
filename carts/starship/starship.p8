pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- main loop

function _init()
    starfield = {}
    for i = 1, 80 do add(starfield, mk_star()) end

    ships = {}
    add(ships, mk_ship(64,64))

    lasers = {}
end

function _update()
    reset_ship(ships)
    get_player_input(ships)

    move_entities(starfield)
    move_entities(ships)
    move_entities(lasers)
end

function _draw()
    cls()
    draw_starfield(starfield)
    draw_sprites(ships)
    draw_sprites(lasers)
end

-->8
-- ecs framework/utils

-- creates a function that takes a list of entities and performs the provided
-- action on each.
function system(action)
    return function(entities)
        -- if type(entities) == "table" then
            for entity in all(entities) do
                action(entity)
            end
        -- end
    end
end

function log(input)
    printh("> " .. tostr(input))
end

-->8
-- entity factories

function mk_star()
    return {
        type = "star",
        pos = {
            x = flr(rnd(128)),
            y = flr(rnd(128))
        },
        direction = {
            dx = 0,
            dy = rnd(1.5) + 0.5 -- random y speed
        }
    }
end

function mk_ship(x, y)
    return {
        type = "ship",
        pos = {
            x = x,
            y = y
        },
        direction = {
            dx = 0,
            dy = 0
        },
        speed = 2,
        sprite = 2,
        
        cooldown = 0
    }
end

function mk_laser(x, y)
    return {
        type = "laser",
        pos = {
            x = x,
            y = y
        },
        direction = {
            dx = 0,
            dy = -4
        },
        sprite = 4
    }
end

-->8
-- systems

-- ===== update systems =====

reset_ship = system(
    function(e)
        e.direction.dx = 0
        e.direction.dy = 0
        e.sprite = 2
    end
)

get_player_input = system(
    function(e)
        -- get x direction
        if btn(0) and btn(1) then
            if btn_0_was_last then e.direction.dx += e.speed
            else e.direction.dx -= e.speed
            end
        elseif btn(0) then 
            btn_0_was_last = true
            e.direction.dx -= e.speed
            e.sprite = 1
        elseif btn(1) then
            btn_0_was_last = false
            e.direction.dx += e.speed
            e.sprite = 3
        end

        -- get y direction
        if btn(2) and btn(3) then
            if btn_2_was_last then e.direction.dy += e.speed
            else e.direction.dy -= e.speed
            end
        elseif btn(2) then 
            btn_2_was_last = true
            e.direction.dy -= e.speed
        elseif btn(3) then
            btn_2_was_last = false
            e.direction.dy += e.speed
        end

        -- shoot laser
        if btn(5) then
            if e.cooldown == 0 then
                log('asdf')
                add(lasers, mk_laser(e.pos.x, e.pos.y - 4))
                e.cooldown = 4
            end
        end
    end
)

-- moves all entities that have pos and speed components
move_entities = system(
    function(e)
        e.pos.x += e.direction.dx
        e.pos.y += e.direction.dy

        if e.type == "star" then
            if e.pos.y >= 128 then
                e.pos.y = 0
                e.pos.x = flr(rnd(128))
            end
        end

        if e.type == "ship" then
            if e.pos.x >= 124 then e.pos.x = 124 end
            if e.pos.x <= 4 then e.pos.x = 4 end
            if e.pos.y >= 124 then e.pos.y = 124 end
            if e.pos.y <= 4 then e.pos.y = 4 end

            if e.cooldown > 0 then e.cooldown -=1 end
        end

        if e.type == "laser" then
            if e.pos.y <= -4 then del(lasers, e)
            else e.sprite = e.sprite >= 7 and 4 or e.sprite + 1 end
        end
    end
)

-- ===== draw systems =====

draw_starfield = system(
    function(e)
        local color = 6
        if e.direction.dy < 1 then
            color = 1
        elseif e.direction.dy < 1.5 then
            color = 13
        end
        pset(e.pos.x, e.pos.y, color)
    end
)

draw_sprites = system(
    function(e)
        spr(e.sprite, e.pos.x - 4, e.pos.y - 4)
    end
)

__gfx__
00000000000880000008800000088000001111000011110000111100001111000000000000000000000000000000000000000000000000000000000000000000
0000000000999800008998000089990001cccc1001cccc1001cccc1001cccc100000000000000000000000000000000000000000000000000000000000000000
0070070000bb3800083bb3800083bb001cc77cc11cc77cc11cc77cc11cc77cc10000000000000000000000000000000000000000000000000000000000000000
000770000099380008399380008399001c7777c11c7777c11c7777c11c7777c10000000000000000000000000000000000000000000000000000000000000000
000770000999998089999998089999901ccc77c11cc77cc11c77ccc11cc77cc10000000000000000000000000000000000000000000000000000000000000000
007007000a99a98089a99a98089a99a0001cccc001cccc100cccc10001cccc100000000000000000000000000000000000000000000000000000000000000000
000000000a99a88088a99a88088a99a000c1cc10001cc10001cc1c00001cc1000000000000000000000000000000000000000000000000000000000000000000
00000000008888000088880000888800000011000001100000110000000110000000000000000000000000000000000000000000000000000000000000000000
