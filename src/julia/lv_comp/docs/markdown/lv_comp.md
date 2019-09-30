```@meta
EditURL = "@__REPO_ROOT_URL__/"
```

# Introduciton to Lotka-Volterra Competition

```@example lv_comp
using Parameters
using DifferentialEquations
using ForwardDiff
using Plots
pyplot();
```

# Introduction/Overview
This notebook is simply looking at the two species L-V competiti9on model. Here, we are exploring
the geometry and dynamics of this model.

# Model and Equilibria
The model we will use is the classical LV competition model:

```@example lv_comp
# Inplace definition (the `du` array is passed to the function and changed), the default way to
# define this in Julia.
function lv_comp(du, u, p, t)
    @unpack r1, r2, α12, α21, K1, K2 = p
    du[1] = u[1] * r1 * (1 - (u[1] + α12 * u[2]) / K1)
    du[2] = u[2] * r2 * (1 - (u[2] + α21 * u[1]) / K2)
    return
end

# Make a version that allocates the output `du`, useful for symbolic calculations
function lv_comp(u, p, t)
    du = similar(u)
    lv_comp(du, u, p, t)
    return du
end
```

# Model Parameters

```@example lv_comp
@with_kw mutable struct LVPar
    α12 = 0.8
    α21 = 0.3
    r1 = 1.0
    r2 = 2.0
    K1 = 1.5
    K2 = 1.0
end
```

# Evaluating the model -- time series

```@example lv_comp
let
    u0 = [0.5, 0.5]
    t_span = (0.0, 100.0)
    p = LVPar()

    prob = ODEProblem(lv_comp, u0, t_span, p)
    sol = solve(prob, reltol = 1e-8)

    plot(sol)
    xlabel!("time")
    ylabel!("Density")
end
```

# Equilibria and Isoclines
From the above equations we can generate the Jacobian:

Make a numerical (not symbolic version using the ForwardDiff.jl library.
This is what you will want to do most of the time)

```@example lv_comp
jac(u, p) = ForwardDiff.jacobian(u -> lv_comp(u, p, NaN), u)
```

Here we have the jacobian evaluated at the point `u = [0.5, 0.5]`, with the parameter set `par`

```@example lv_comp
jac([0.5, 0.5], LVPar())
```

First solve for $f_1$ and $f_2$ to determine when functions are equal to 0 (i.e., when $du_1/dt$
and $du_2/dt = 0$). These are known as the isoclines, or nullclines, and describe the set of
solutions when $u_1$ and $u_2$ do not change.

```@example lv_comp
# We need to use a library for Symbolic calculations, a very common one is SymPy from the python
# language. Luckily Julia has excellent support for it.
using SymPy
```

We want to deal with all of these as symbolic variables, which are not the default type in Julia,
unlike Mathematica.

```@example lv_comp
@vars u1 u2
@vars r1 r2 a12 a21 K1 K2
```

We need to make a symbolic parameter list, as `LVPar` is numeric

```@example lv_comp
spar = Dict(
    :α12 => a12,
    :α21 => a21,
    :r1 => r1,
    :r2 => r2,
    :K1 => K1,
    :K2 => K2);
```

we need to make symbolic versions of the model equations. We do this by calling
the function with the symbolic parameters. the last parameter could be anything
as the time (`t`) argument is not used. I have set it to `NaN` which is a name
for not a number.

```@example lv_comp
f1, f2 = lv_comp([u1, u2], spar, NaN)
```

```@example lv_comp
sympy.solve(f1, u1)
```

```@example lv_comp
sympy.solve(f1, u2)
```

```@example lv_comp
sympy.solve(f2, u1)
```

```@example lv_comp
sympy.solve(f2, u2)
```

We want to solve our equations for $u_1$ so that we can plot the isoclines as a function of  $u_1$
($u_1$ on the y-axis), but here I am keeping all possible solutions, with respect to both $u_1$
and $u_2$. You should be able to see that the first two solutions ($u_1 = K_1 - \alpha_{12}u_2$
and $u_2 = (K_1 - u_1)/\alpha_{12}$) are equivalent.

The solutions $u_1 = K_1 - \alpha_{12}u_2$ and $u_1 = (K_2 - u_2)/\alpha_{21}$ are the equations
for our isoclines for $du_1/dt = 0$ and $du_2/dt = 0$, respectively. We can find the interior
equilibrium where these lines intersect (i.e., both $u_1$ and $u_2$ do not change). In this case
we get one interior equilibrium, but note that in more complicated models we can get more interior
equilibria.

# Now plot the isoclines
We will again use the manipulate function to see how our parameters change the isoclines. This can
immediately tell us a lot about our equilibria and stability.

```@example lv_comp
function iso1(u2, p)
    @unpack α12, K1 = p
    return K1 - α12 * u2 / K1
end
```

```@example lv_comp
function iso2(u2, p)
    @unpack α21, K2 = p
    return (K2 - u2) / α21
end
```

```@example lv_comp
let
    p = LVPar()
    u2s = range(0, 5, length = 100)

    fig = plot(u2s, [iso1(u2, p) for u2 in u2s], label = "u1 = 0")
    plot!(u2s, [iso2(u2, p) for u2 in u2s], label = "u2 = 0")
    xlims!(0, 3)
    ylims!(0, 5)
    xlabel!("u2")
    ylabel!("u1")
end
```

*This page was generated using [Literate.jl](https://github.com/fredrikekre/Literate.jl).*

