#!/usr/bin/env julia

## =========================== ## ## =========================== ##
## 	   Euler's and Heun's methods for numerical integration 	 ##
##	   Ollin Demian Langle Chimal					             ##
##	                         						             ##
##     09 / 23 / 2018									         ##
## =========================== ## ## =========================== ##

"""
    euler(x,h;fun,kwargs...)

Uses Euler method to integrate function fun at x with step h
"""
function euler(x,h;fun=lv,kwargs...)
    try
        f = fun(x;kwargs...)
        y = x + f * h
        return y
    catch
        return @. x + fun(x;kwargs...) * h
    end
end

"""
    heun(x,h;fun,kwargs...)

Uses Heun method to integrate function fun at x with step h
"""
function heun(x,h;fun=lv,kwargs...)
    try
        y1 = euler(x,h;fun=fun,kwargs...)
        y2 = fun(x;kwargs...) .+ fun(y1;kwargs...)
        yf = x .+ h * 0.5 * y2
        return yf
    catch
        y1 = euler(x,h;fun=fun,kwargs...)
        y2 = @. fun(x;kwargs...) + fun(y1;kwargs...)
        yf = @. x + h * 0.5 * y2
        return yf
    end
end

"""
    lv(x;a,b,c,d)

Classical 2D Lotka-Volterra model
"""
function lv(x;a,b,c,d)
    y = [a*x[1]-b*x[1]*x[2],c*x[1]*x[2]-d*x[2]]
    y
end

"""
    lot3(x;α)

Generalized Lotka-Volterra model for 3 species as in
Flake's The Computational Beauty of Nature book.
"""
function lot3(x;α=0.75)
    A = [0.5 0.5 0.1; -0.5 -0.1 0.1; α 0.1 0.1]
    y = zeros(length(x))
    for i in 1:length(x)
        y[i] = x[i] * (A[i,:]' * (1 .- x))
    end
    y
end

"""
    my_integrator(ti,tf,h,y0;fun,algo,kwargs...)

Integrates a function fun from ti to tf with step h and initial condition
y0 with algorithm algo.
"""
function my_integrator(ti,tf,h,y0;fun=lv,algo=euler,kwargs...)
    t = ti:h:tf |> collect
    y = zeros(length(t),length(y0))
    y[1,:] .= y0
    for i ∈ 2:size(y)[1]
        value = algo(y[i-1,:],h;fun=fun,kwargs...)
        if any(@. !isless(value,1e4))
            y = y[1:i-1,:]
            t = t[1:size(y)[1]]
            break
        end
        y[i,:] .= value
    end
    t,y
end

# Test the integration in a Lotka-Volterra 2 species system and for a regular
# function like cosine.

#  @time t,y = my_integrator(0,500,1/2^4,[2/3,0.9];fun=lv,algo=heun,a=0.5,b=1.2,c=1,d=0.8)
#  @time t,y = my_integrator(0,500,0.125,[2/3,0.9];fun=cos,algo=heun)
