module D3Force

include("src/forces.jl")

export Node
export Simulation
export tick!

mutable struct Node{T<:Integer, S<:Real, R<:Real}
    idx::T
    x::S
    y::S
    vx::R
    vy::R
end

@kwdef mutable struct Simulation{T, F}
    nodes::Vector{Node}
    forces::Vector{F}
    alpha::T = 1.0
    alpha_min::T = 0.001
    alpha_decay::T = 0.0228
    alpha_target::T = 0.0
    velocity_decay::T = 0.4
end

function stop() end
function restart() end

function update_alpha!(s::Simulation)
    s.alpha = (s.alpha_target - s.alpha) * s.alpha_decay
    return s
end

function update_nodes!(s::Simulation)
    for f in s.forces
        force!(f, s.nodes, s.alpha)
    end
    return s
end

function update_velocities!(s::Simulation)
    for node in s.nodes
        node.vx = node.vx * s.velocity_decay
        node.vy = node.vy * s.velocity_decay
    end
    return s
end

function tick!(s::Simulation; iter::Integer = 300)
    for _ in iter
        update_alpha!(s)
        update_nodes!(s)
        update_velocities!(s)
    end
    return s
end

end
