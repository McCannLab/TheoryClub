# # Model Parameters
@with_kw mutable struct CRPar
    r = 2.0
    k = 3.0
    a = 1.1
    h = 0.8
    e = 0.7
    m = 0.4
end

## CR exp resource, type I consumer
function cr_expI_model(du, u, p, t)
    @unpack r, a, e, m = p
    R, C, = u
    du[1] = r * R - a * R * C
    du[2] = e * a * R * C - m * C
    return
end

function cr_expI_model(u, p, t)
    du = similar(u)
    cr_expI_model(du, u, p, t)
    return du
end


## CR log resource, type I consumer
function cr_logI_model(du, u, p, t)
    @unpack r, k, a, e, m = p
    R, C, = u
    du[1] = r * R * (1 - R / k) - a * R * C
    du[2] = e * a * R * C - m * C
    return
end

function cr_logI_model(u, p, t)
    du = similar(u)
    cr_logI_model(du, u, p, t)
    return du
end


## CR log resource, type II consumer
function cr_logII_model(du, u, p, t)
    @unpack r, k, a, e, h, m = p
    R, C, = u
    du[1] = r * R * (1 - R / k) - a * R * C / (1 + a * h * R)
    du[2] = e * a * R * C / (1 + a * h * R) - m * C
    return
end

function cr_logII_model(u, p, t)
    du = similar(u)
    cr_logII_model(du, u, p, t)
    return du
end

## CR exp resource, type II consumer
function cr_expII_model(du, u, p, t)
    @unpack r, a, e, h, m = p
    R, C, = u
    du[1] = r * R  - a * R * C / (1 + a * h * R)
    du[2] = e * a * R * C / (1 + a * h * R) - m * C
    return
end

function cr_expII_model(u, p, t)
    du = similar(u)
    cr_expII_model(du, u, p, t)
    return du
end



