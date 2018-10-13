__precompile__()
module ComplexSystems
    using DataFrames
    using Distributions
    using GLM
    using Statistics
    using LibGeos

    # An AbstractType with an empty property
    mutable struct box_2d
        squares::Polygon
        empty::Bool
    end

    # walker type, with a position and if it is a wanderer
    mutable struct walker
        x::Float64
        y::Float64
        loner::Bool
    end

    include("diffusion_limited_aggregation.jl")
    include("dynamical_system.jl")
    include("l_system.jl")
    include("box_counting.jl")
end # module
