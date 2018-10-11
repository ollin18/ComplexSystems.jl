#!/usr/bin/env julia

## =========================== ## ## =========================== ##
## 	                  Minkowski Dimension                      	 ##
##	                Ollin Demian Langle Chimal					 ##
##	                         						             ##
##                         10 / 08 / 2018	    		         ##
## =========================== ## ## =========================== ##

using LibGEOS

# An AbstractType with an empty property
#  mutable struct box_2d
#      squares::Polygon
#      empty::Bool
#  end

"""
    gen_box(start,Δx,Δy,empty)

Generates a rectangle with the given start and the Δ in every axis.
Can be either empty or not.
"""
function gen_box(start::Array{Float64,1},Δx::Float64,Δy::Float64,empty::Bool)
    x = start[1]
    y = start[2]
    nx = x + Δx
    ny = y + Δy
    polyg = readgeom("POLYGON(($x $y,$nx $y,$nx $ny,$x $ny,$x $y))")
    box = box_2d(polyg,empty)
end

"""
    make_grid(min_x,max_y,min_y,max_y,Nx,Ny,empty)

Generates a grid of boxes given by the number of divisions in every axis.
Needs a start and end point. Currently you can only make them all empty,
not empty or randomize them.
"""
function make_grid(min_x,max_x,min_y,max_y,Nx,Ny,empty)
    Δx = (max_x-min_x)/Nx
    Δy = (max_y-min_y)/Ny
    tN = Nx*Ny
    boxes = Array{box_2d}(undef,tN)
    x = min_x
    y = min_y
    box = 1
    for j ∈ 1:Ny
        for i ∈ 1:Nx
            boxes[box] = gen_box([x,y],Δx,0.,empty)
            x = x + Δx
            box += 1
        end
        y = y + Δy
        x = min_x
    end
    return boxes,Δx,Δy
end

"""
    make_square_grid(min_x,max_x,min_y,max_y,Δ,empty)

Generates a grid of square boxes given by the Δ which is the box size length.
Needs a start and end point. Currently you can only make them all empty,
not empty or randomize them.
"""
function make_square_grid(min_x,max_x,min_y,max_y,Δ,empty)
    Nx = ceil((max_x-min_x)/Δ)
    Ny = ceil((max_y-min_y)/Δ)
    tN = Int(Nx*Ny)
    boxes = Array{box_2d}(undef,tN)
    x = min_x
    y = min_y
    box = 1
    for j ∈ 1:Ny
        for i ∈ 1:Nx
            boxes[box] = gen_box([x,y],Δ,Δ,empty)
            x = x + Δ
            box += 1
        end
        y = y + Δ
        x = min_x
    end
    return boxes
end

"""
    inside_box(point,box)

Checks if there's a point inside a box and if there is change the state of the box
to not empty.
"""
function inside_box(point,box)
    if within(point,box.squares)
        box.empty = false
    end
    return box.empty
end
