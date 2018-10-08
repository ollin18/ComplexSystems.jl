#!/usr/bin/env julia

## =========================== ## ## =========================== ##
## 	                         2D  L-system                      	 ##
##	                Ollin Demian Langle Chimal					 ##
##	                         						             ##
##                         09 / 23 / 2018	    		         ##
## =========================== ## ## =========================== ##

#  I believe this can be better done with dictionaries but I already begun so I'm
#  going to leave here unused functions that could also work if I were to
#  replicate the Matlab code.

function evolve(s::String,d::Dict)
    if s ∈ keys(d) |> collect
        s = d[s]
    end
    s
end

function paste_string(a::Array)
    whole = a[1]
    if length(a) > 1
        for i ∈ 2:length(a)
            whole = whole * a[i]
        end
    end
    whole
end

function lsystem(axiom::String,rules::Dict)
    splitted = split(axiom,"")
    to_string = map(String,splitted)
    evolved_seed = map(x -> evolve(x,rules),to_string) |> paste_string
end

function mult_evol_lsystem(axiom::String,rules::Dict,times::Int)
    ls = lsystem(axiom,rules)
    if times > 1
        for i ∈ 1:times-1
            ls = lsystem(ls,rules)
        end
    end
    ls
end

function turtle_step(x,y,typ,angle,size=1)
    if typ=="F"
        col = :brown
    elseif typ=="G"
        col = :green
    end
    nx = x + size*cos(angle)
    ny = y + size*sin(angle)
    line = ([y,ny],[x,nx])
    plot!(line,color=col,w=2,leg=false,aspect_ratio=:equal,ticks=nothing,border=false),nx,ny
end

function update_angle(angle,amount,times,direction)
    ex = Expr(:call, Meta.parse(direction), angle, times*amount)
    eval(ex)
end
