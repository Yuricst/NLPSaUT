# NLPJuMP
Wrapper for constructing NLP with Julia

This module provides a wrapper to build a JuMP module around a user-defined NLP problem.
The function must return a fitness vector, which stores the objective, equality constraint(s), and inequality constraint(s), in this order.  
Derivatives are computed using `FiniteDifferences`. 

### Examples

Define a fitness function to return the objective, equality constraint(s), and inequality constraint(s):

```julia
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
```

Then, the `NLPJuMP` module may be used as follows:

```julia
using JuMP
push!(LOAD_PATH, "../NLPJuMP/src/")
using NLPJuMP

# problem dimensions
nx = 2                   # decision vectors
nh = 1                   # equality constraints
ng = 2                   # inequality constraints
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
```
