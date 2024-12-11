"""Dev for new NLP interface"""

using Ipopt
using JuMP

include(joinpath(@__DIR__, "../src/NLPSaUT.jl"))

function_calls = 0
function foo(x, y)
    global function_calls += 1
    common_term = x^2 + y^2
    term_1 = sqrt(1 + common_term)
    term_2 = common_term
    return term_1, term_2
end

function memoize(foo::Function, n_outputs::Int)
    last_x, last_f = nothing, nothing
    last_dx, last_dfdx = nothing, nothing
    function foo_i(i, x::T...) where {T<:Real}
        if T == Float64
            if x !== last_x
                last_x, last_f = x, foo(x...)
            end
            return last_f[i]::T
        else
            if x !== last_dx
                last_dx, last_dfdx = x, foo(x...)
            end
            return last_dfdx[i]::T
        end
    end
    return [(x...) -> foo_i(i, x...) for i in 1:n_outputs]
end

memoized_foo = NLPSaUT.memoize_fitness(foo, 2, 2)


model = Model(Ipopt.Optimizer)
set_silent(model)
@variable(model, x[1:2] >= 0, start = 0.1)
@operator(model, op_foo_1, 2, memoized_foo[1])
@operator(model, op_foo_2, 2, memoized_foo[2])
@objective(model, Max, op_foo_1(x[1], x[2]))
@constraint(model, op_foo_2(x[1], x[2]) <= 2)
function_calls = 0
optimize!(model)
@assert is_solved_and_feasible(model)
# Test.@test objective_value(model) ≈ √3 atol = 1e-4
# Test.@test value.(x) ≈ [1.0, 1.0] atol = 1e-4
println("Memoized approach: function_calls = $(function_calls)")

# function f_fitness(x...)    
# 	# objective
#     f = x[1]^2 - x[2]
    
#     # equality constraints
#     h = zeros(1,)
#     h = x[1]^3 + x[2] - 1

#     # inequality constraints
#     g = zeros(2,)
#     g[1] = x[1]^2 + x[2]^2 - 1
#     g[2] = x[2] - 2
    
#     fitness = vcat(f,h,g)[:]
#     return fitness
# end


# nx = 2
# nh = 0
# ng = 0
# nfitness = 1 + nh + ng

# memoized_fitness = NLPSaUT.memoize_fitness(f_fitness, nx, nfitness)

# lx = -10*ones(nx,)
# ux =  10*ones(nx,)
# x0 = [1.2, 0.9]

# model = Model(Ipopt.Optimizer)
# @variable(model, lx[i] <= x[i=keys(lx)] <= ux[i], start = x0[i])
# fobj = @expression(model, x[1]^2 + x[2]^2)

# @objective(model, Min, fobj)#(x...))

# optimize!(model)