using ComplexSystems
using Plots

the_walkers = walker_set(5000,-5,5)
unshift!(the_walkers,walker(0.,0.,0))

the_walkers = dla(the_walkers,0.1,-5,5)

## Plotting
the_x = [w.x for w in the_walkers]
the_y = [w.y for w in the_walkers]
p = scatter(the_x,the_y,markersize=3.,
            leg=false,ticks=nothing,
            markerstrokewidth=0.,border=false)
title!("Diffusion Limit Aggregation")
png(p,"/figs/dla")


## Minkowski dimension
min_x=-5.
max_x=5.
min_y=-5.
max_y=5.


walkers_p = map(x -> Point(x.x,x.y),the_walkers);
Δs = []
Dimension = []
for Δ ∈ 0.01:0.05:0.96
    the_grid = make_square_grid(min_x,max_x,min_y,max_y,Δ,true);
    for punto ∈ walkers_p
        map(x -> inside_box(punto,x),the_grid);
    end
    non_empty_ones = sum([!x.empty for x ∈ the_grid]);
    println(non_empty_ones)
    dimension = log(non_empty_ones)/log(1/Δ)
    push!(Δs,Δ)
    push!(Dimension,dimension)
end

mini = round(Dimension[1];digits=3)
p = scatter(Δs,Dimension,legend=false)
title!("Dimension vs box size")
yaxis!("Dimension",:log10)
xaxis!("Length of square side",:log10)

png(p,"/figs/dimension")
