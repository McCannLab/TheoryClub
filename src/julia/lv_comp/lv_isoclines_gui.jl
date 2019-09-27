using Parameters
using Blink
using Interact
using Plots
gr()

include("lv_model.jl")

function iso1(u2, p)
    @unpack α12, K1 = p
    return K1 - α12 * u2 / K1
end

function iso2(u2, p)
    @unpack α21, K2 = p
    return (K2 - u2) / α21
end

let
    u2s = range(0, 5, length = 100)
    ui = @manipulate for α12 in slider(0.1:0.01:1.0; label = "α12", value = 0.8),
                         α21 in slider(0.1:0.01:1.0; label = "α21", value = 0.3),
                         K1 in slider(0.1:0.01:2.0; label = "K1", value = 1.5),
                         K2 in slider(0.1:0.01:2.0; label = "K2", value = 1.0)
        p = LVPar(α12 = α12, α21 = α21, K1 = K1, K2 = K2)

        plot(u2s, [iso1(u2, p) for u2 in u2s], label = "u1 = 0")
        plot!(u2s, [iso2(u2, p) for u2 in u2s], label = "u2 = 0")
        xlims!(0, 3)
        ylims!(0, 5)
        xlabel!("u2")
        ylabel!("u1")
    end

    w = Blink.AtomShell.Window()
    body!(w, ui)
end
