using ComplexSystems
using Plots
gr()

fl65 = Dict{String,String}("F" => "F[-F]F[+F]F")
HW = mult_evol_lsystem("F",fl65,3)
splitted = split(HW,"");
plot();
let
    global x = 0.
    global y = 0.
    global a = 0.
    global p
    global variables=[(x,y,a)]
    Δ = 25
    global da = Δ/180*π
    for s in splitted
        if s == "F" || s == "G"
            p,x,y=turtle_step(x,y,s,a)
        elseif s == "+" || s == "-"
            a = update_angle(a,da,1,s)
        elseif s == "["
            push!(variables,(x,y,a))
            x,y,a = variables[end]
        elseif s == "]"
            x,y,a = variables[end]
            pop!(variables)
        end
        p
    end
end

mf = Dict{String,String}("F" => "FF[+F][-F]","+" =>
"+F[+2F][-2F]","-"=>"-F[-3F][+3F]")
HW2 = mult_evol_lsystem("F",mf,4);
splitted = split(HW2,"");

plot();
let
    global x = 0.
    global y = 0.
    global a = 0.
    global p
    global variables=[(x,y,a)]
    Δ = 45
    global da = Δ/180*π
    for s in splitted
        if s == "F" || s == "G"
            p,x,y=turtle_step(x,y,s,a)
        elseif s == "+" || s == "-"
            a = update_angle(a,da,1,s)
        elseif s == "["
            push!(variables,(x,y,a))
            x,y,a = variables[end]
        elseif s == "]"
            x,y,a = variables[end]
            pop!(variables)
        end
        p
    end
end
