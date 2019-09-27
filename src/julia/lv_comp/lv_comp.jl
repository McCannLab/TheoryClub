# # Introduciton to Lotka-Volterra Competition

using Parameters
using DifferentialEquations
using ForwardDiff
using Plots
pyplot();

# # Introduction/Overview
# This notebook is simply looking at the two species L-V competiti9on model. Here, we are exploring
# the geometry and dynamics of this model.
#
# # Model and Equilibria
# The model we will use is the classical LV competition model:

include("lv_model.jl")

# # Evaluationg the model -- time series

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

# # Equilibria and Isoclines
# From the above equations we can generate the Jacobian:

# Make a numerical (not symbolic version using the ForwardDiff.jl library.
# This is what you will want to do most of the time)
jac(u, p) = ForwardDiff.jacobian(u -> lv_comp(u, p, NaN), u)

# Here we have the jacobian evaluated at the point `u = [0.5, 0.5]`, with the parameter set `par`
jac([0.5, 0.5], LVPar())

# First solve for $f_1$ and $f_2$ to determine when functions are equal to 0 (i.e., when $du_1/dt$
# and $du_2/dt = 0$). These are known as the isoclines, or nullclines, and describe the set of
# solutions when $u_1$ and $u_2$ do not change.

include("lv_symbolic.jl")

# We want to solve our equations for $u_1$ so that we can plot the isoclines as a function of  $u_1$
# ($u_1$ on the y-axis), but here I am keeping all possible solutions, with respect to both $u_1$
# and $u_2$. You should be able to see that the first two solutions ($u_1 = K_1 - \alpha_{12}u_2$
# and $u_2 = (K_1 - u_1)/\alpha_{12}$) are equivalent.
#
# The solutions $u_1 = K_1 - \alpha_{12}u_2$ and $u_1 = (K_2 - u_2)/\alpha_{21}$ are the equations
# for our isoclines for $du_1/dt = 0$ and $du_2/dt = 0$, respectively. We can find the interior
# equilibrium where these lines intersect (i.e., both $u_1$ and $u_2$ do not change). In this case
# we get one interior equilibrium, but note that in more complicated models we can get more interior
# equilibria.

# # Now plot the isoclines
# We will again use the manipulate function to see how our parameters change the isoclines. This can
# immediately tell us a lot about our equilibria and stability.

function iso1(u2, p)
    @unpack α12, K1 = p
    return K1 - α12 * u2 / K1
end
#-
function iso2(u2, p)
    @unpack α21, K2 = p
    return (K2 - u2) / α21
end
#-
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
