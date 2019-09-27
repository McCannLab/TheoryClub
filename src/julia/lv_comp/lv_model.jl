## Inplace definition (the `du` array is passed to the function and changed), the default way to
## define this in Julia.
function lv_comp(du, u, p, t)
    @unpack r1, r2, α12, α21, K1, K2 = p
    du[1] = u[1] * r1 * (1 - (u[1] + α12 * u[2]) / K1)
    du[2] = u[2] * r2 * (1 - (u[2] + α21 * u[1]) / K2)
    return
end

## Make a version that allocates the output `du`, useful for symbolic calculations
function lv_comp(u, p, t)
    du = similar(u)
    lv_comp(du, u, p, t)
    return du
end

# # Model Parameters

@with_kw mutable struct LVPar
    α12 = 0.8
    α21 = 0.3
    r1 = 1.0
    r2 = 2.0
    K1 = 1.5
    K2 = 1.0
end
