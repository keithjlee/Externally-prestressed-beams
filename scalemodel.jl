include("utilities/utilityFunctions.jl")
include("utilities/resistanceCalculations.jl")

#initial data
begin
    Asingle = 6179. #mm²
    Atotal = 3Asingle
    height = 229. #mm
    e = height #eccentricity of external strands from centroid 
    Lseg = 500. #mm
    Ldev = 89. #mm 

    fc = 30. #MPa, N/mm²

    #breaking capacity of steel cables
    FuAxial = 2900 * 4.454 #N
    FuMoment = 1200 * 4.454 #N
end

## Failure mode: yielding of external tensioning anchors
begin
    fySteel = 250. #MPa very mild steel
    momentArm = 12.7 #mm, center of anchor to perpendicular edge of pixel
    b = 44.3 #width of support edge, mm
    tPlate = 3/16 * 25.4 #mm 
end

# What force will cause this plate to yield?
begin
    Splate = b * tPlate^2 / 6 #section modulus, mm³
    Mrplate = Splate * fySteel #yielding moment, Nmm
    FrodHorizontal = Mrplate / momentArm #Force at anchor, N
end

## Global demand
#Angle of strand + force in horizontal strand region [rad, N]
θ = atan(e/Lseg)
Frod = FrodHorizontal / cos(θ)

#Required external load [N]
Preq = 2Frod * sin(θ)

#Axial force on deviator [N]
PdeviatorVert = Preq

#Axial force on concrete [N]
Fconcrete = 2Frod * cos(θ)

#Pure compression resistance
Rconcrete = 0.85 * fc * Atotal

#Prestress factor
axialFactor = 0.5
RsteelAxial = axialFactor * FuAxial * 3 #total post tension force on concrete [N]
Rtotal = 0.65 * 0.8 * (Rconcrete - RsteelAxial) #total factored resistance [N]

##Deviator design
<<<<<<< refs/remotes/Upstream/main
hdev = 87.2
wdev = 50.8

Moverturn = 2Frod * cos(θ) * hdev / 2
Poverturn = Moverturn * 6 / wdev

=======
>>>>>>> .
### failure mode 1: slip critical
tensioning = collect(range(0., 2Frod, length = 300))
Fvert = tensioning .* sin(θ)
Fhor = tensioning .* cos(θ)

prop = collect(0:0.05:0.2)
μs = collect(0.4:0.05:0.7)

<<<<<<< refs/remotes/Upstream/main
Ffriction = [f * μ for f in Fvert, μ in μs]

using GLMakie, kjlMakie

set_theme!(kjl_light)
begin
    fig = Figure(backgroundcolor = :white)

    ax = Axis3(fig[1,1],
        xlabel = "Induced normal force [N]",
        ylabel = "Friction coefficient, μ",
        zlabel = "Horizontal friction resistance [N]",
        zlabeloffset = 75,
        aspect = (1,1,1))

    labelize!(ax)
    surface!(Fvert, μs, Ffriction,
        colormap = :tempo)

    fig
end


### Aluminum loading plate
hplate = 7 * 25.4 
bplate = 4.5 * 25.4 
tflange = 3/8 * 25.4
tweb = 25.4 / 4

Iflange = bplate * tflange^3 / 12
Aflange = bplate * tflange
rflange = hplate / 2 - tflange / 2

Iweb = tweb * (hplate - 2tflange)^3 / 12

Itot = 2 * (Iflange + Aflange * rflange^2) + Iweb #mm^4
Eal = 70e3 #N/mm²
σal = 95e3 #N/mm²

Stot = Itot / hplate * 2

Pcenter = 6e3 #N
Lplate = 1000. #mm

Δmax = Pcenter * Lplate^3 / 48 / Eal / Itot
=======
using GLMakie, kjlMakie

>>>>>>> .
