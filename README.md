# NLPSaUT
Wrapper for constructing NLP model with JuMP

This module provides a wrapper to build a JuMP module around a user-defined NLP problem. 
Internally, a memoized function for the fitness function is created (see [JuMP Tips and tricks on NLP](https://jump.dev/JuMP.jl/stable/tutorials/nonlinear/tips_and_tricks/)). 
The function must return a fitness vector, which stores the objective, equality constraint(s), and inequality constraint(s), in this order.  

The module supports either appending variables, objectives, and constraints into an existing `JuMP.Model` constructed a priori; if a `JuMP.Model` is not provided, an `Ipopt` based `JuMP.Model` is constructed by default. 

Derivatives are computed using `FiniteDifferences`. 

### Dependencies
- `JuMP`, `Ipopt`, `FiniteDifferences`

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

Then, the `NLPSaUT` module may be used as follows:

```julia
using JuMP
using NLPSaUT

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
```

If the derivative method and order is to be specified, replace the above with:

```julia
# problem dimensions
nx = 2                   # number of decision vectors
nh = 1                   # number of equality constraints
ng = 2                   # number of inequality constraints
lx = -10*ones(nx,)
ux =  10*ones(nx,)
x0 = [1.2, 0.9]

# get model
order = 2
diff_f = "forward"
x, model = build_model(f_fitness, nx, nh, ng, lx, ux, x0, order, diff_f)
set_optimizer_attribute(model, "tol", 1e-6)
set_optimizer_attribute(model, "print_level", 5)

optimize!(model)
```

If using a pre-build model, use the mutating version of the function:

```julia
# build SNOPT7 model
using SNOPT7
model = Model(optimizer_with_attributes(SNOPT7.Optimizer, "print_level"=>5, "system_information"=>"yes"))

# problem dimensions
nx = 2                   # number of decision vectors
nh = 1                   # number of equality constraints
ng = 2                   # number of inequality constraints
lx = -10*ones(nx,)
ux =  10*ones(nx,)
x0 = [1.2, 0.9]

# get model
order = 2
diff_f = "forward"
x = build_model!(model, f_fitness, nx, nh, ng, lx, ux, x0, order, diff_f)

optimize!(model)
```
