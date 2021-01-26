using Parameters
using PyPlot

include("cr_model.jl")

function retrieve_RC(vectordata, RC)
    newarray = zeros(size(vectordata)[1],size(vectordata)[2])

    for i in 1:size(vectordata)[1]
        for j in 1:size(vectordata)[2]
            newarray[i,j] = vectordata[i,j][RC]
        end
    end
    return newarray
end

## CR exp resource, type I consumer
function expI_resiso(p)
    @unpack r, a = p
    return r / a
end

function expI_coniso(p)
    @unpack m, a, e = p
    return m / ( a * e ) 
end

let
    par = CRPar(a=1.6, m=0.7)
    resconrange = 0.0:0.01:3.0
    vector_data = [cr_expI_model([R, C], par, NaN) for C in resconrange, R in resconrange]
    U = retrieve_RC(vector_data, 1)
    V = retrieve_RC(vector_data, 2)
    speed = sqrt.(U.^2 .+ V.^2)
    lw = 5 .* speed ./ maximum(speed) # Line Widths
    
    
    expI_plot = figure()
    hlines(expI_resiso(par), 0.0, 3.0, colors="blue")
    vlines(expI_coniso(par), 0.0, 3.0, colors="orange")
    streamplot(collect(resconrange), collect(resconrange), U, V, density = 0.6, color = "k", linewidth = lw)
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
    resconrange = 0.0:0.005:3.0
    vector_data = [cr_logI_model([R, C], par, NaN) for C in resconrange, R in resconrange]
    U = retrieve_RC(vector_data, 1)
    V = retrieve_RC(vector_data, 2)
    speed = sqrt.(U.^2 .+ V.^2)
    lw = 5 .* speed ./ maximum(speed)

    logI_plot = figure()
    plot(Rrange, [logI_resiso(R, par) for R in Rrange], color="blue")
    vlines(logI_coniso(par), 0.0, 3.0, colors="orange")
    streamplot(collect(resconrange), collect(resconrange), U, V, density = 0.6, color = "k", linewidth = lw)
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
    par = CRPar(r = 1.5, e = 0.45)
    Rrange = 0.0:0.1:3.0
    resconrange = 0.0:0.005:3.0
    vector_data = [cr_logII_model([R, C], par, NaN) for C in resconrange, R in resconrange]
    U = retrieve_RC(vector_data, 1)
    V = retrieve_RC(vector_data, 2)
    speed = sqrt.(U.^2 .+ V.^2)
    lw = 5 .* speed ./ maximum(speed)

    logII_plot = figure()
    plot(collect(Rrange), [logII_resiso(R, par) for R in Rrange], color="blue")
    vlines(logII_coniso(par), 0.0, 3.0, colors="orange")
    streamplot(collect(resconrange), collect(resconrange), U, V, density = 0.6, color = "k", linewidth = lw)

    xlabel("Resource")
    ylabel("Consumer")
    xlim(0,3)
    ylim(0,3)
    return logII_plot
end

## CR exp resource, type II consumer

let
    par = CRPar(r=0.5)
    Rrange = 0.0:0.1:100.0
    resconrange = 0.0:0.1:100.0
    vector_data = [cr_expII_model([R, C], par, NaN) for C in resconrange, R in resconrange]
    U = retrieve_RC(vector_data, 1)
    V = retrieve_RC(vector_data, 2)
    speed = sqrt.(U.^2 .+ V.^2)
    lw = 5 .* speed ./ maximum(speed)

    expII_plot = figure()
    plot(collect(Rrange), [expII_resiso(R, par) for R in Rrange], color="blue")
    vlines(expII_coniso(par), 0.0, 100.0, colors="orange")
    streamplot(collect(resconrange), collect(resconrange), U, V, density = 0.6, color = "k", linewidth = lw)

    xlabel("Resource")
    ylabel("Consumer")
    xlim(0,30)
    ylim(0,30)
    return expII_plot
end

