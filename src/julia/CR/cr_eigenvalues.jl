using Parameters
using DifferentialEquations
using ForwardDiff
using LinearAlgebra

include("cr_model.jl")

## CR exp resource, type I consumer
function expI_inteq(p)
    @unpack r, a, m, e = p
    C = r / a
    R = m / ( a * e ) 
    return [R , C]
end

expI_inteq_jac = jac(expI_inteq(CRPar()), cr_expI_model, CRPar())

eigvals(expI_inteq_jac)

λ_stability(expI_inteq_jac)

expI_00_jac = jac([0.0,0.0], cr_expI_model, CRPar())

λ_stability(expI_00_jac)

eigvals(expI_00_jac)

expI_k_jac = jac([3.0,0.0], cr_expI_model, CRPar())

λ_stability(expI_k_jac)

eigvals(expI_k_jac)


## CR log resource, type I consumer
function logI_inteq(p)
    @unpack r, a, k, m, e = p
    R =  m / (a * e)
    C = r * (- R + k) / (a * k)
    return [R , C]
end

logI_inteq_jac = jac(logI_inteq(CRPar()), cr_logI_model, CRPar())

eigvals(logI_inteq_jac)

λ_stability(logI_inteq_jac)

logI_00_jac = jac([0.0,0.0], cr_logI_model, CRPar())

λ_stability(logI_00_jac)

eigvals(logI_00_jac)

logI_k_jac = jac([3.0,0.0], cr_logI_model, CRPar())

λ_stability(logI_k_jac)

eigvals(logI_k_jac)

## CR log resource, type II consumer

logII_inteq_jac = jac(logII_eq(CRPar()), cr_logII_model, CRPar())

eigvals(logII_inteq_jac)

λ_stability(logII_inteq_jac)

logII_00_jac = jac([0.0,0.0], cr_logII_model, CRPar())

λ_stability(logII_00_jac)

eigvals(logII_00_jac)

logII_k_jac = jac([3.0,0.0], cr_logII_model, CRPar())

λ_stability(logII_k_jac)

eigvals(logII_k_jac)

## CR exp resource, type II consumer

# Calculate the interior equilibrium
function expII_inteq(p)
    @unpack r, a, h, m, e = p
    R = m / (a * (e - h * m))
    C = R * h * r + r / a
    return [R , C]
end

expII_inteq_jac = jac(expII_inteq(CRPar(r = 0.5, a = 1.0)), cr_expII_model, CRPar(r = 0.5, a = 1.0))

eigvals(expII_inteq_jac)

λ_stability(expII_inteq_jac)

expII_00_jac = jac([0.0,0.0], cr_expII_model, CRPar(r = 0.5, a = 1.0))

λ_stability(expII_00_jac)

eigvals(expII_00_jac)