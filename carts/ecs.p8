pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- a breakdown/study of selfsame's ECS framework on lexaloffle
-- https://www.lexalofflentity.com/bbs/?tid=30039

-- main loop

function _init()
    world = {}
    add(world, mk_circle(32, 64, 10, 12))
    add(world, mk_sprite(64, 64, 0))
    add(world, mk_circle(96, 64, 10, 8))
end

function _update()
    pulse_circles(world)
end

function _draw()
    cls()
    draw_circles(world)
    draw_sprites(world)
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

function mk_circle(x, y, r, color)
    return {
        pos = { x = x, y = y},
        r = r,
        color = color,
        shrink = true
    }
end

function  mk_sprite(x, y, sprite)
    return {
        pos = { x = x, y = y },
        sprite = 0
    }
end

-->8
-- systems

-- ===== update systems =====

pulse_circles = system({ "pos", "color" },
    function(entity)
        entity.r += entity.shrink and -1 or 1
        if entity.r == 10 or entity.r == 0 then
            entity.shrink = not entity.shrink
        end
    end
)

-- ===== draw systems =====

draw_circles = system({ "pos", "color" }, 
    function(entity)
        circfill(entity.pos.x, entity.pos.y, entity.r, entity.color)
    end
)

draw_sprites = system({ "pos", "sprite" },
    function(entity)
        spr(entity.sprite, entity.pos.x-4, entity.pos.y-4)
    end
)

__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
