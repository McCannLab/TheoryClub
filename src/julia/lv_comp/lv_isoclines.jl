using Parameters
using PyPlot

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
    par = LVPar(K1 = 1.5)
    u2range = 0.0:0.1:3.0
    lv_plot = figure()
    plot(u2range, [iso1(u2, par) for u2 in u2range])
    plot(u2range, [iso2(u2, par) for u2 in u2range])
    xlim(0,3)
    ylim(0,3)
    return lv_plot
end
