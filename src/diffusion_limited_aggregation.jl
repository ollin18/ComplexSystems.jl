using Distributions

# walker type, with a position and if it is a wanderer
mutable struct walker
    x::Float64
    y::Float64
    loner::Bool
end

"""
    distance(walker1,walker2)

Computes de distance between two walkers.
"""
function distance(w1::walker,w2::walker)
    on_x = (w1.x - w2.x)^2
    on_y = (w1.y - w2.y)^2
    sqrt(on_x+on_y)
end

"""
    freeze(walker1,walker2,tol)

Changes the loner state of a walker if it's distance
to another one is < tol
"""
function freeze(w1::walker,w2::walker,tol::Float64)
    if w1.loner == false || w2.loner == false
        if distance(w1,w2) <= tol
            return w1.loner=w2.loner=0
        end
    end
end

"""
    look_around(element,W,tol)

Computes the distance of a walker to all the other walkers
in an array of them and freezes them if their distance to
the nearest one is < tol
"""
function look_around(element::Int64,W::Array,tol::Float64)
    not_me = W[1:end .!= element]
    map(x -> freeze(the_walkers[element],x,tol),not_me)
end

"""
    random_walk(w,min,max)

Makes a walker do a random walk inside a restriction box with
length Δ
"""
function random_walk(w::walker,min::Number,max::Number,Δ=0.1)
    Δx = rand([-Δ,0,Δ])
    Δy = rand([-Δ,0,Δ])
    if w.x + Δx > min && w.x + Δx < max
        w.x = w.x + Δx;
    end
    if w.y + Δy > min && w.y + Δy < max
        w.y = w.y + Δy;
    end
end

## Main program
#  the_walkers = [walker(round(rand(Uniform(-5,5));digits=1),
#                        round(rand(Uniform(-5,5));digits=1),
#                        1) for i in 1:5000]
#  unshift!(the_walkers,walker(0.,0.,0))
#
#  while sum([x.loner for x ∈ the_walkers]) > 0
#      global the_movers = findall(x -> x.loner == true, the_walkers);;
#      for i ∈ the_movers
#          look_around(i,the_walkers,0.1)
#      end
#      the_movers = findall(x -> x.loner == true, the_walkers);
#      map(x -> random_walk(the_walkers[x],-5,5),the_movers);
#  end
#
#  ## Plotting
#  the_x = [w.x for w in the_walkers]
#  the_y = [w.y for w in the_walkers]
#  p = scatter(the_x,the_y,markersize=3.,
#              leg=false,ticks=nothing,
#              markerstrokewidth=0.,border=false)
#  png(p,"/figs/initial")
