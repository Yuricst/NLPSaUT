"""
Example using NLPJuMP with Ipopt
"""

using JuMP
push!(LOAD_PATH, "../src/")
using NLPSaUT

NLPSaUT.test_ipopt()

# """
# User-defined fitness function

# # Returns:
# 	- `Vector`: vector stores [f, h, g] where f is objective, h is equality, and g is inequality constraints
# """
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


# # ------------------------------------------------------------------------- #
# ## Solve model
# # problem dimensions
# nx = 2                   # number of decision vectors
# nh = 1                   # number of equality constraints
# ng = 2                   # number of inequality constraints
# lx = -10*ones(nx,)
# ux =  10*ones(nx,)
# x0 = [1.2, 0.9]

# # get model
# order = 2
# diff_f = "forward"
# x, model = build_model(f_fitness, nx, nh, ng, lx, ux, x0)#, order, diff_f)
# set_optimizer_attribute(model, "tol", 1e-6)
# set_optimizer_attribute(model, "print_level", 5)
# println(model)

# # run optimizer
# optimize!(model)

# # print results
# println(termination_status(model))
# println("Decision vector: ")
# println(value.(x))
# println("Objective: ")
# println(objective_value(model))
