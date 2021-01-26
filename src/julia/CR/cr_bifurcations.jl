# We will use the logistic resource type II consumer model - obviously the most interesting bifurcation diagrams

using Distributed
using PyPlot

#parallel set up
addprocs(length(Sys.cpu_info())-1)

@everywhere using Parameters
@everywhere using DifferentialEquations
@everywhere using ForwardDiff
@everywhere using LinearAlgebra

@everywhere include("/home/chrisgg/julia/TheoryClub/src/julia/CR/cr_model.jl")


#non parallel set up
include("cr_model.jl")

# Min max version
## Parallel version
@everywhere function calc_minmax(eval, tend)
    u0 = [0.5, 0.5]
    t_span = (0.0, tend)
    remove_transient = 300.0:1.0:tend
    p = CRPar(e = eval)
    prob = ODEProblem(cr_logII_model, u0, t_span, p)
    sol = DifferentialEquations.solve(prob, reltol = 1e-8)
    solend = sol(remove_transient)
    minC = minimum(solend[2, 1:end])
    maxC = maximum(solend[2, 1:end])

    return [minC, maxC]
end

function parallel_minmax(tend)
    effrange = 0.43:0.01:0.9
    data = pmap(eval -> calc_minmax(eval, tend), effrange)
    minmaxC = zeros(length(effrange),2)
    for i in 1:length(effrange)
        minmaxC[i,1] = data[i][1]
        minmaxC[i,2] = data[i][2]
    end
    return hcat(collect(effrange), minmaxC)
end

let
    data = parallel_minmax(400.0)
    minmaxplot = figure()
    plot(data[:,1], data[:,2])
    plot(data[:,1], data[:,3])
    xlabel("Efficiency")
    ylabel("Consumer Max/Min")
    return minmaxplot
end


## non-parallel version
function minmaxbifurc(tend)
    effrange = 0.43:0.01:0.9
    minC = zeros(length(effrange))
    maxC = zeros(length(effrange))

    u0 = [0.5, 0.5]
    t_span = (0.0, tend)
    remove_transient = 300.0:1.0:tend

    for (ei, evals) in enumerate(effrange)
        p = CRPar(e = evals)
        prob = ODEProblem(cr_logII_model, u0, t_span, p)
        sol = DifferentialEquations.solve(prob, reltol = 1e-8)
        solend = sol(remove_transient)
        solend[2, 1:end]

        minC[ei] = minimum(solend[2, 1:end])
        maxC[ei] = maximum(solend[2, 1:end])
    end

    return hcat(effrange, minC, maxC)
end

let
    data = minmaxbifurc(400.0)
    minmaxplot = figure()
    plot(data[:,1], data[:,2])
    plot(data[:,1], data[:,3])
    xlabel("Efficiency")
    ylabel("Consumer Max/Min")
    return minmaxplot
end


# Check mark diagram
function eff_maxeigen_data()
    evals = 0.4:0.0001:0.9
    max_eig = zeros(length(evals))

    for (ei, eval) in enumerate(evals)
        p = CRPar(e = eval)
        equ = logII_eq(p)
        max_eig[ei] = λ_stability(jac(equ, cr_logII_model, p))
    end
    return hcat(collect(evals), max_eig)
end

let
    data = eff_maxeigen_data()
    maxeigen_plot = figure()
    plot(data[:,1], data[:,2], color = "black")
    ylabel("Re(λₘₐₓ)", fontsize = 15)
    xlim(0.4, 0.8)
    ylim(-0.35, 0.1)
    xlabel("Efficiency", fontsize = 15)
    hlines(0.0, 0.4,0.8, linestyles = "dashed", linewidth = 0.5)
    vlines([0.441, 0.710], ymin = -0.35, ymax = 0.1, linestyles = "dashed")
    return maxeigen_plot
end
