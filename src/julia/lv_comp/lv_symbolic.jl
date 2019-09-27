## We need to use a library for Symbolic calculations, a very common one is SymPy from the python
## language. Luckily Julia has excellent support for it.
using SymPy

#jl Remove the follow `#jl` to use this file standalone
#jl include("lv_model.jl")

# We want to deal with all of these as symbolic variables, which are not the default type in Julia,
# unlike Mathematica.
@vars u1 u2
@vars r1 r2 a12 a21 K1 K2
# We need to make a symbolic parameter list, as `LVPar` is numeric
spar = Dict(
    :α12 => a12,
    :α21 => a21,
    :r1 => r1,
    :r2 => r2,
    :K1 => K1,
    :K2 => K2);

# we need to make symbolic versions of the model equations. We do this by calling the function with
# the symbolic parameters. the last parameter could be anythign as the time (`t`) argument is not
# used. I have set it to `NaN` which is a name for not a number.
f1, f2 = lv_comp([u1, u2], spar, NaN)
#-
sympy.solve(f1, u1)
#-
sympy.solve(f1, u2)
#-
sympy.solve(f2, u1)
#-
sympy.solve(f2, u2)
#-
