
abstract type Force end

struct Center <: Force
end

struct Collide <: Force
end

struct Link <: Force
end

struct ManyBody <: Force
end

struct Position <: Force
end
