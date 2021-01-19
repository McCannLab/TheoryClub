using Parameters
using DifferentialEquations
using ForwardDiff
using LinearAlgebra

include("cr_model.jl")

# Function to calculate the jacobian at any point (with any model)
function jac(u, model, p)
    ForwardDiff.jacobian(u -> model(u, p, NaN), u)
end

# Function to calculate maximum eigenvalue (real part)
λ_stability(M) = maximum(real.(eigvals(M)))




## CR exp resource, type II consumer

# Calculate the interior equilibrium
function expII_inteq(p)
    @unpack r, a, h, m, e = p
    R = m / (a * (e - h * m))
    C = R * h * r + r / a
    return [R , C]
end

expII_inteq(CRPar(r = 0.5, a = 1.0))

expII_inteq_jac = jac(expII_inteq(CRPar(r = 0.5, a = 1.0)), cr_expII_model, CRPar(r = 0.5, a = 1.0))

λ_stability(expII_inteq_jac)

expII_00_jac = jac([0.0,0.0], cr_expII_model, CRPar(r = 0.5, a = 1.0))

λ_stability(expII_00_jac)

eigvals(expII_00_jac)