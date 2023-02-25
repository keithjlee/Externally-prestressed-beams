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
    FuAxial = 400 * 4.454 #N
    FuMoment = 1200 * 4.454 #N
end

## Failure mode: yielding of external tensioning anchors
begin
    fySteel = 350. #MPa
    momentArm = 9.4 #mm, center of anchor to perpendicular edge of pixel
    b = 27.8 #width of support edge, mm
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
### failure mode 1: slip critical
tensioning = collect(range(0., 2Frod, length = 300))
Fvert = tensioning .* sin(θ)
Fhor = tensioning .* cos(θ)

prop = collect(0:0.05:0.2)
μs = collect(0.4:0.05:0.7)

using GLMakie, kjlMakie

