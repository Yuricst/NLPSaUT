"""
Test for memoization
"""

using FiniteDifferences
using GLMakie
using Ipopt
using JuMP
using Test


# push!(LOAD_PATH, joinpath(@__DIR__, "../src/"))
# using NLPSaUT
include(joinpath(@__DIR__, "../src/NLPSaUT.jl"))

# problem dimensions
nx = 2                   # number of decision vectors
nh = 1                   # number of equality constraints
ng = 2                   # number of inequality constraints
x0 = [-1.2, 10]

function f_fitness(x::T...) where {T<:Real}
	# objective
    f = x[1]^2 - x[2]
    
    # equality constraints
    h = zeros(T, 1)
    h = x[1]^3 + x[2] - 2.4

    # inequality constraints
    g = zeros(T, 2)
    g[2] = -0.3x[1] + x[2] - 2   # y <= 0.3x + 2
    g[1] = x[1] + x[2] - 5      # y <= -x + 5
    return [f; h; g]
end

f_fitness_nosplat(x) = f_fitness(x...)

# jacobian with FiniteDifferences.jl
jac = FiniteDifferences.jacobian(FiniteDifferences.forward_fdm(order, 1), f_fitness_nosplat, x0)[1]

# memoization
nfitness = 1 + nh + ng
memoized_fitness = NLPSaUT.memoize_fitness(f_fitness, nx, nfitness)
∇memoized_fitness = NLPSaUT.memoize_fitness_gradient(f_fitness, nfitness, "forward", 2)


@assert memoized_fitness[1](x0...) ≈ -8.56

dffoo = zeros(nx)
@show ∇memoized_fitness[1](dffoo, x0...)
@show dffoo

println("Done!")


