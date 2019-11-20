#!/usr/bin/env julia

using ComplexSystems
using Plots
using StatsBase

avg_p_1 = Array{Tuple{Float64,Float64}}(undef,11)
for p in 0:0.1:1
    avg = Array{Float64}(undef,30)
    for j=1:30
        space = initialize_population(200,200,p)
        for i=1:100
            sznajd_one_site(space,p)
        end
        avg[j]=sum(space)/length(space)
    end
    avg_p_1[Int(p*10+1)]=mean_and_std(avg)
end

avg_p_1_stupid = Array{Tuple{Float64,Float64}}(undef,11)
for p in 0:0.1:1
    avg = Array{Float64}(undef,30)
    for j=1:30
        space = initialize_population(200,200,p)
        for i=1:100
            if i in [50,60,70,80,90]
                stupid_bots(space,0.1)
            end
            sznajd_one_site(space,p)
        end
        avg[j]=sum(space)/length(space)
    end
    avg_p_1_stupid[Int(p*10+1)]=mean_and_std(avg)
end

avg_p_1_smart = Array{Tuple{Float64,Float64}}(undef,11)
for p in 0:0.1:1
    avg = Array{Float64}(undef,30)
    for j=1:30
        space = initialize_population(200,200,p)
        for i=1:100
            if i in [50,60,70,80,90]
                smart_bots(space,0.1)
            end
            sznajd_one_site(space,p)
        end
        avg[j]=sum(space)/length(space)
    end
    avg_p_1_smart[Int(p*10+1)]=mean_and_std(avg)
end

avg_p_1_cambridge = Array{Tuple{Float64,Float64}}(undef,11)
for p in 0:0.1:1
    avg = Array{Float64}(undef,30)
    for j=1:30
        space = initialize_population(200,200,p)
        for i=1:100
            if i == 75
                cambridge_analytica(space,0.1)
            end
            sznajd_one_site(space,p)
        end
        avg[j]=sum(space)/length(space)
    end
    avg_p_1_cambridge[Int(p*10+1)]=mean_and_std(avg)
end


theavg=map(x -> x[1],avg_p_1) |> collect
thetime=0:0.1:1|>collect
σ=map(x->x[2],avg_p_1)|> collect

theavg2=map(x -> x[1],avg_p_2) |> collect
σ2=map(x->x[2],avg_p_2)|> collect

theavg3=map(x -> x[1],avg_p_3) |> collect
σ3=map(x->x[2],avg_p_3)|> collect

plot(thetime,theavg,ribbon=σ,fillalpha=.5,lab="1 site")
plot!(thetime,theavg2,ribbon=σ2,fillalpha=.5,lab="2 site")
plot!(thetime,theavg3,ribbon=σ3,fillalpha=.5,lab="3 site")
