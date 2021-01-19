using Parameters
using PyPlot

include("cr_model.jl")

## CR exp resource, type I consumer
function expI_resiso(p)
    @unpack r, a = p
    return r / a
end

function expI_coniso(p)
    @unpack m, a, e = p
    return m / a * e
end

let
    par = CRPar()
    expI_plot = figure()
    hlines(expI_iso1(par), 0.0, 3.0, colors="blue")
    vlines(expI_iso2(par), 0.0, 3.0, colors="orange")
    xlabel("Resource")
    ylabel("Consumer")
    xlim(0,3)
    ylim(0,3)
    return expI_plot
end

## CR log resource, type I consumer
function logI_resiso(R, p)
    @unpack r, k, a = p
    return r * (- R + k) / (a * k)
end

function logI_coniso(p)
    @unpack m, a, e = p
    return m / (a * e)
end

let
    par = CRPar()
    Rrange = 0.0:0.1:3.0
    logI_plot = figure()
    plot(collect(Rrange), [logI_resiso(R, par) for R in Rrange], color="blue")
    vlines(logI_coniso(par), 0.0, 3.0, colors="orange")
    xlabel("Resource")
    ylabel("Consumer")
    xlim(0,3)
    ylim(0,3)
    return logI_plot
end

## CR log resource, type II consumer

function logII_resiso(R, p)
    @unpack r, k, a, h = p
    return r * (-R^2 * a * h + R * a * h * k - R + k) / (a * k)
end

function logII_coniso(p)
    @unpack m, a, e, h = p
    return m / (a * (e - h * m))
end

let
    par = CRPar()
    Rrange = 0.0:0.1:3.0
    logII_plot = figure()
    plot(collect(Rrange), [logII_resiso(R, par) for R in Rrange], color="blue")
    vlines(logII_coniso(par), 0.0, 3.0, colors="orange")
    xlabel("Resource")
    ylabel("Consumer")
    xlim(0,3)
    ylim(0,3)
    return logII_plot
end

## CR exp resource, type II consumer
function expII_resiso(R, p)
    @unpack r, a, h = p
    return R * h * r + r / a
end

function expII_coniso(p)
    @unpack m, a, e, h = p
    return m / (a * (e - h * m))
end

let
    par = CRPar(r=0.5, a=1.0)
    Rrange = 0.0:0.1:3.0
    expII_plot = figure()
    plot(collect(Rrange), [expII_resiso(R, par) for R in Rrange], color="blue")
    vlines(expII_coniso(par), 0.0, 3.0, colors="orange")
    xlabel("Resource")
    ylabel("Consumer")
    xlim(0,3)
    ylim(0,3)
    return expII_plot
end

