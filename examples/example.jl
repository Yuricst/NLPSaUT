"""
Example using NLPJuMP
"""

using JuMP
push!(LOAD_PATH, "../NLPJuMP/src/")
using NLPJuMP


"""
User-defined fitness function

# Returns:
	- `Vector`: vector stores [f, h, g] where f is objective, h is equality, and g is inequality constraints
"""
function f_fitness(x...)    
	# objective
    f = x[1]^2 - x[2]
    
    # equality constraints
    h = zeros(1,)
    h = x[1]^3 + x[2] - 1

    # inequality constraints
    g = zeros(2,)
    g[1] = x[1]^2 + x[2]^2 - 1
    g[2] = x[2] - 2
    
    fitness = vcat(f,h,g)[:]
    return fitness
end


# ------------------------------------------------------------------------- #
## Solve model
# problem dimensions
nx = 2                   # number of decision vectors
nh = 1                   # number of equality constraints
ng = 2                   # number of inequality constraints
lx = -10*ones(nx,)
ux =  10*ones(nx,)
x0 = [1.2, 0.9]

# get model
x, model = build_model(f_fitness, nx, nh, ng, lx, ux, x0)
println(model)
optimize!(model)

# print results
println(termination_status(model))
println("Decision vector: ")
println(value.(x))
println("Objective: ")
println(objective_value(model))
