pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- a breakdown/study of selfsame's ECS framework on lexaloffle
-- https://www.lexalofflentity.com/bbs/?tid=30039

-- main loop

function _init()
    ships = {}
    add(ships, mk_ship(64,64))
end

function _update()
    reset_ship(ships)
    get_player_input(ships)
    move_entities(ships)
end

function _draw()
    cls()
    draw_ship(ships)
end

-->8
-- ecs framework/utils

-- creates a function that takes a list of entities and performs the provided
-- action on each one that contains the specified components.
function system(components, action)
    return function(entities)
        for entity in all(entities) do
            if _has(entity, components) then
                action(entity)
            end
        end
    end
end

function _has(entity, components)
    for component in all(components) do
        if not entity[component] then
            return false
        end
    end
    return true
end

function log(input)
    printh("> " .. tostr(input))
end

-->8
-- entity factories

function mk_ship(x, y)
    return {
        type = "ship",
        position = {
            x = x,
            y = y
        },
        direction = {
            dx = 0,
            dy = 0
        },
        speed = 2,
        sprite = 2
    }
end

-->8
-- systems

-- ===== update systems =====

reset_ship = system({},
    function(e)
        e.direction.dx = 0
        e.direction.dy = 0
        e.sprite = 2
    end
)

get_player_input = system({},
    function(e)
        if btn(0) and btn(1) then
            if btn_0_was_last then e.direction.dx += 2
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

        if btn(2) and btn(3) then
            if btn_2_was_last then e.direction.dy += 2
            else e.direction.dy -= e.speeed
            end
        elseif btn(2) then 
            btn_2_was_last = true
            e.direction.dy -= e.speed
        elseif btn(3) then
            btn_2_was_last = false
            e.direction.dy += e.speed
        end
    end
)

-- moves all entities that have position and speed components
move_entities = system({"direction"},
    function(e)
        e.position.x += e.direction.dx
        e.position.y += e.direction.dy
        if e.type == "ship" then
            if e.position.x >= 124 then e.position.x = 124 end
            if e.position.x <= 4 then e.position.x = 4 end
            if e.position.y >= 124 then e.position.y = 124 end
            if e.position.y <= 4 then e.position.y = 4 end
        end
    end
)

-- ===== draw systems =====

draw_ship = system({},
    function(e)
        spr(e.sprite, e.position.x - 4, e.position.y - 4)
    end
)

__gfx__
00000000000880000008800000088000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009998000089980000899900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0070070000bb3800083bb3800083bb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000009938000839938000839900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000099999808999999808999990000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
007007000a99a98089a99a98089a99a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000a99a88088a99a88088a99a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000008888000088880000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
