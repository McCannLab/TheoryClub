using Parameters
using DifferentialEquations
using PyPlot

include("cr_model.jl")

## CR exp resource, type I consumer
let
    u0 = [0.5, 0.5]
    t_span = (0.0, 50.0)
    p = CRPar()

    prob = ODEProblem(cr_expI_model, u0, t_span, p)
    sol = DifferentialEquations.solve(prob, reltol = 1e-8)

    cr_expI_ts = figure()
    plot(sol.t, sol.u)
    xlabel("time")
    ylabel("Density")
    return cr_expI_ts
end
## CR log resource, type I consumer
let
    u0 = [0.5, 0.5]
    t_span = (0.0, 50.0)
    p = CRPar()

    prob = ODEProblem(cr_logI_model, u0, t_span, p)
    sol = DifferentialEquations.solve(prob, reltol = 1e-8)

    cr_logI_ts = figure()
    plot(sol.t, sol.u)
    xlabel("time")
    ylabel("Density")
    return cr_logI_ts
end


## CR log resource, type II consumer
let
    u0 = [0.5, 0.5]
    t_span = (0.0, 75.0)
    p = CRPar(e=0.5)

    prob = ODEProblem(cr_logII_model, u0, t_span, p)
    sol = DifferentialEquations.solve(prob, reltol = 1e-8)
    cr_logII_ts = figure()
    plot(sol.t, sol.u)
    xlabel("time")
    ylabel("Density")
    return cr_logII_ts
end

## CR exp resource, type II consumer

let
    u0 = [0.5,0.5]
    t_span = (0.0, 50.0)
    p = CRPar(r=0.5)

    prob = ODEProblem(cr_expII_model, u0, t_span, p)
    sol = DifferentialEquations.solve(prob, reltol = 1e-8)

    cr_expII_ts = figure()
    plot(sol.t, sol.u)
    xlabel("time")
    ylabel("Density")
    return cr_expII_ts
end

let
    Rrange = 0.0:0.1:30.0
    u0 = [0.5,0.5]
    t_span = (0.0, 50.0)
    p = CRPar(r=0.549)

    prob = ODEProblem(cr_expII_model, u0, t_span, p)
    sol = DifferentialEquations.solve(prob, reltol = 1e-8)

    cr_expII_phasets = figure()
    plot(collect(Rrange), [expII_resiso(R, p) for R in Rrange], color="blue")
    vlines(expII_coniso(p), 0.0, 30.0, colors="orange")
    plot(sol[1,:], sol[2,:])
    xlim(0.0,30.0)
    ylim(0.0,30.0)
    xlabel("Resource")
    ylabel("Consumer")
    return cr_expII_phasets
end
