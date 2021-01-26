## We need to use a library for Symbolic calculations, a very common one is SymPy from the python
## language. Luckily Julia has excellent support for it.
using Parameters
using DifferentialEquations
using ForwardDiff
using SymPy

#jl Remove the follow `#jl` to use this file standalone
include("cr_model.jl")

# We want to deal with all of these as symbolic variables, which are not the default type in Julia,
# unlike Mathematica.
@vars R C
@vars r k e a h m
# We need to make a symbolic parameter list, as `CRPar` is numeric
spar = Dict(
    :r => r,
    :k => k,
    :a => a,
    :h => h,
    :e => e,
    :m => m)

# we need to make symbolic versions of the model equations. We do this by calling the function with
# the symbolic parameters. the last parameter could be anythign as the time (`t`) argument is not
# used. I have set it to `NaN` which is a name for not a number.

## CR exp resource, type I consumer
f1, f2 = cr_expI_model([R, C], spar, NaN)
#-
SymPy.solve(f1, R)
#-
SymPy.solve(f1, C)
#-
SymPy.solve(f2, R)
#-
SymPy.solve(f2, C)
#-

## CR log resource, type I consumer
g1, g2 = cr_logI_model([R, C], spar, NaN)
#-
SymPy.solve(g1, R)
#-
SymPy.solve(g1, C)
#-
SymPy.solve(g2, R)
#-
SymPy.solve(g2, C)

## CR log resource, type II consumer
l1, l2 = cr_logII_model([R, C], spar, NaN)
#-
SymPy.solve(l1, R)
#-
SymPy.solve(l1, C)
#-
SymPy.solve(l2, R)
#-
SymPy.solve(l2, C)

## CR exp resource, type II consumer
n1, n2 = cr_expII_model([R, C], spar, NaN)
#-
SymPy.solve(n1, R)
#-
SymPy.solve(n1, C)
#-
SymPy.solve(n2, R)
#-
SymPy.solve(n2, C)