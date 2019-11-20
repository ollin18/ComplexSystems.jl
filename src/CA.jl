#!/usr/bin/env julia

using StatsBase

"""
This function gives the neighbors of a cell. Takes into
account the diagonal ones.
"""
function neighbors(population,i,j)
    above = [(i-1,k) for k in j-1:j+1 if (k>0 && i-1>0 && k<=size(population)[2])]
    below = [(i+1,k) for k in j-1:j+1 if (k>0 && i<size(population)[1] && k<=size(population)[2])]
    right = [(i,j+1) for i in i if (j<size(population)[2])]
    left  = [(i,j-1) for i in i if (j-1 > 0)]
    neigh = union(above,below,right,left)
    neigh
end

"""
This function initializes the opinion population given
a p probability of 1 and p-1 of -1
"""
function initialize_population(x,y,p)
    sizes = Int(ceil(x*y*(1-p)))
    init = ones(Int64,x,y)
    coord = [tuple(i,j) for i in 1:x for j in 1:y]
    selected = sample(coord,sizes;replace=false)
    map(x -> init[x[1],x[2]]=-init[x[1],x[2]],selected)
    init
end

function friends_opinion(population,i,j)
    n = neighbors(population,i,j)
    op = [population[n[k][1],n[k][2]] for k in 1:length(n)]
    op
end

function avg_friends_opinion(population,i,j)
    op = friends_opinion(population,i,j)
    sum(op)/length(op)
end

function convince(population,i,j)
    my_opinion = population[i,j]
    neighborhood = neighbors(population,i,j)
    map(x-> population[x[1],x[2]]=my_opinion,neighborhood)
    population
end

function convince_2_sites(population,i,j)
    my_opinion = population[i,j]
    neighborhood = neighbors(population,i,j)
    rf = sample(neighborhood,1)
    if population[rf[1][1],rf[1][2]] == my_opinion
        map(x-> population[x[1],x[2]]=my_opinion,neighborhood)
    end
    population
end

function convince_3_sites(population,i,j)
    my_opinion = population[i,j]
    neighborhood = neighbors(population,i,j)
    rf = sample(neighborhood,2)
    if population[rf[1][1],rf[1][2]] === population[rf[2][1],rf[2][2]] == my_opinion
        map(x-> population[x[1],x[2]]=my_opinion,neighborhood)
    end
    population
end

function sznajd_one_site(population,p)
    sizes = Int(ceil(length(population)*p))
    coord = [tuple(i,j) for i in 1:size(population)[1] for j in 1:size(population)[2]]
    selected = sample(coord,sizes;replace=false)
    map(x -> convince(population,x[1],x[2]),selected)
    population
end

function sznajd_two_site(population,p)
    sizes = Int(ceil(length(population)*p))
    coord = [tuple(i,j) for i in 1:size(population)[1] for j in 1:size(population)[2]]
    selected = sample(coord,sizes;replace=false)
    map(x -> convince_2_sites(population,x[1],x[2]),selected)
    population
end

function sznajd_three_site(population,p)
    sizes = Int(ceil(length(population)*p))
    coord = [tuple(i,j) for i in 1:size(population)[1] for j in 1:size(population)[2]]
    selected = sample(coord,sizes;replace=false)
    map(x -> convince_3_sites(population,x[1],x[2]),selected)
    population
end

function stupid_bots(population,p)
    coord = [tuple(i,j) for i in 1:size(population)[1] for j in 1:size(population)[2]]
    hm = Int(ceil(length(population)*p))
    selected = sample(coord,hm;replace=false)
    map(x -> population[x[1],x[2]]=1,selected)
    population
end

function smart_bots(population,p)
    coord = [tuple(i,j) for i in 1:size(population)[1] for j in 1:size(population)[2]
            if population[i,j]!=1]
    hm = Int(ceil(length(coord)*p))
    selected = sample(coord,hm;replace=false)
    map(x -> population[x[1],x[2]]=1,selected)
    population
end

function cambridge_analytica(population,p)
    coord = [tuple(i,j) for i in 1:size(population)[1] for j in 1:size(population)[2] if (population[i,j]!=1 && abs(avg_friends_opinion(population,i,j))!=1)]
    hm = Int(ceil(length(coord)*p))
    selected = sample(coord,hm;replace=true)
    map(x -> convince_2_site(population,x[1],x[2]),selected)                                                                                                                                       
    population
end
