__precompile__()
module ComplexSystems
    using DataFrames
    using Distributions
    using GLM
    using Statistics
    using LibGEOS

    export distance,freeze,look_around,random_walk,walker_set,dla
    export neighboors,initialize_population,friends_opinion,avg_friends_opinion
    export convince,convince_2_sites,convince_3_sites,sznajd_one_site,sznajd_two_site,sznajd_three_site
    export stupid_bots, smart_bots, cambridge_analytica, gen_box, make_grid
    export inside_box, euler, heun, lv, lot3, my_integrator
    export evolve, paste_string, lsystem,mult_evol_lsystem,turtle_step,update_angle

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
    include("CA.jl")
end # module
