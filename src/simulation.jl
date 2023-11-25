@kwdef struct Node
    idx::Int
    x::Float64
    y::Float64
    vx::Float64 = 0.0
    vy::Float64 = 0.0
end

@kwdef mutable struct Simulation
    nodes::Vector{Node}
    links::Vector{Tuple{Int, Int}}
    forces::Vector{DataType}
    alpha::Float64 = 1.0
    alpha_min::Float64 = 0.001
    alpha_decay::Float64 = 0.0228
    alpha_target::Float64 = 0.0
    velocity_decay::Float64 = 0.6
end

function init_node(idx, init_radius, init_angle)
    radius = init_radius * sqrt(0.5 + idx)
    angle = init_angle * idx
    x = radius * cos(angle)
    y = radius * sin(angle)
    return Node(;idx, x, y)
end

function init_simulation(N::Int)
    r, a = 10.0, pi * (3 - sqrt(5.0))
    nodes = [init_node(i, r, a) for i in 1:N]
    forces = DataType[]
    return Simulation(;nodes, forces)
end

function stop() end
function restart() end

function update_alpha!(s::Simulation)
    s.alpha = (s.alpha_target - s.alpha) * s.alpha_decay
    return s
end

function update_nodes!(s::Simulation)
    for f! in s.forces
        f!(s.nodes, s.alpha)
    end
    return s
end

function update_velocities!(s::Simulation)
    for node in s.nodes
        @set node.vx = node.vx * s.velocity_decay
        @set node.vy = node.vy * s.velocity_decay
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
