#!/usr/bin/env julia

## =========================== ## ## =========================== ##
## 	                         2D  L-system                      	 ##
##	                Ollin Demian Langle Chimal					 ##
##	                         						             ##
##                         09 / 23 / 2018	    		         ##
## =========================== ## ## =========================== ##


"""
    evolve(s,d)

Changes a string s to the value of a dictionary counterpart if it is on it
"""
function evolve(s::String,d::Dict)
    if s ∈ keys(d) |> collect
        s = d[s]
    end
    s
end

"""
    paste_string(a)

Makes a single string from an array of strings
"""
function paste_string(a::Array)
    whole = a[1]
    if length(a) > 1
        for i ∈ 2:length(a)
            whole = whole * a[i]
        end
    end
    whole
end

"""
    lsystem(axiom,rules)

Evolves a L-system from the axiom to the rules given as a dictionary
"""
function lsystem(axiom::String,rules::Dict)
    splitted = split(axiom,"")
    to_string = map(String,splitted)
    evolved_seed = map(x -> evolve(x,rules),to_string) |> paste_string
end

"""
    mult_evol_lsystem(axiom,rules,times)

Evolves a L-system from the axiom to the rules given as a dictionary
and does the same the times given
"""
function mult_evol_lsystem(axiom::String,rules::Dict,times::Int)
    ls = lsystem(axiom,rules)
    if times > 1
        for i ∈ 1:times-1
            ls = lsystem(ls,rules)
        end
    end
    ls
end

"""
    turtle_step(x,y,typ,angle,size)

Makes a L-system turtle step given the current position, an angle, the step size
and an typ which is the axiom which can currently only be F or G and for coloring
"""
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

"""
    update_angle(angle,amount,times,direction)

Updates the angle of the turtle step by the times of an amount with a positive or negative
change.
"""
function update_angle(angle,amount,times,direction)
    ex = Expr(:call, Meta.parse(direction), angle, times*amount)
    eval(ex)
end
