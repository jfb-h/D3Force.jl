
abstract type Force end

@kwdef struct Center <: Force
    x::Float64 = 0
    y::Float64 = 0
    strength::Float64 = 1
end

function (f::Center)(nodes, links, alpha)
    n = length(nodes)
    sx = sum(n.x for n in nodes)
    sy = sum(n.y for n in nodes)
    sx = (sx / n - f.x) * f.strength
    sy = (sy / n - f.y) * f.strength
    for n in nodes
        n.x -= sx
        n.y -= sy
    end
    return nodes
end

struct Collide <: Force
end

struct Link <: Force
end

struct ManyBody <: Force
end

struct Position <: Force
end
