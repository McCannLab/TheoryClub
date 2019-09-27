using Parameters
using DifferentialEquations
using Blink
using Interact
using Plots
gr()

# Bring in the model
include("lv_model.jl")

# Build a Graphical User Interface (GUI) to explore the parameters
let
    u0 = [0.5, 0.5]
    t_span = (0.0, 100.0)

    ui = @manipulate for α12 in slider(0.1:0.01:2.0; label = "α12", value = 0.8),
                         α21 in slider(0.1:0.01:2.0; label = "α21", value = 0.3),
                         K1 in slider(0.1:0.01:3.0; label = "K1", value = 1.5),
                         K2 in slider(0.1:0.01:3.0; label = "K2", value = 1.0),
                         r1 in slider(0.1:0.01:10.0; label = "r1", value = 1.0),
                         r2 in slider(0.1:0.01:10.0; label = "r2", value = 2.0)
        p = LVPar(α12 = α12, α21 = α21, K1 = K1, K2 = K2, r1 = r1, r2 = r2)
        prob = ODEProblem(lv_comp, u0, t_span, p)
        sol = solve(prob, reltol = 1e-8)
        plot(sol)
        xlabel!("time")
        ylabel!("Density")
    end

    w = Blink.AtomShell.Window()
    body!(w, ui)
end
