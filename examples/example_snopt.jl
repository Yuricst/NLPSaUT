"""
Example using NLPSaUT with SNOPT7

# HS71
Polynomial objective and constraints
min x1 * x4 * (x1 + x2 + x3) + x3
st  x1 * x2 * x3 * x4 >= 25
    x1^2 + x2^2 + x3^2 + x4^2 = 40
    1 <= x1, x2, x3, x4 <= 5

Initial x = (1,5,5,1)
 (1.000..., 4.743..., 3.821..., 1.379...)
"""

using JuMP
using SNOPT7

push!(LOAD_PATH, "../src/")
using NLPSaUT


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
# build snopt model
model = Model(optimizer_with_attributes(SNOPT7.Optimizer,
                                        "print_level"=>5,
                                        "system_information"=>"yes"))

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
println(model)

# run optimizer
optimize!(model)

# print results
println(termination_status(model))
println("Decision vector: ")
println(value.(x))
println("Objective: ")
println(objective_value(model))
