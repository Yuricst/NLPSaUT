"""
Building model
"""


"""
	build_model(f_fitness::Function, nx::Int, nh::Int, ng::Int, lx::Vector, ux::Vector, x0::Vector=nothing)

Build model for NLP problem. 

# Arguments:
	- f_fitness::Function`: fitness function, returning [f, h, g]

# Returns
	- `tuple`: JuMP variables and JuMP model

# Example
	x, model = build_model(f_fitness, nx, nh, ng, lx, ux, x0)

"""
function build_model(f_fitness::Function, nx::Int, nh::Int, ng::Int, lx::Vector, ux::Vector, x0::Vector=nothing)

	## Construct JuMP model
	println("Constructing JuMP model...")
	model = Model(Ipopt.Optimizer)
	x = build_model!(model, f_fitness, nx, nh, ng, lx, ux, x0)
	return x, model

end



"""
	build_model!(model::JuMP.Model, f_fitness::Function, nx::Int, nh::Int, ng::Int, lx::Vector, ux::Vector, x0::Vector=nothing)

Extend model for NLP problem. 

# Arguments:
	- `model::JuMP.Model`: model to append objective and constraints

# Returns
	- `tuple`: JuMP variables and JuMP model

# Example
	x, model = build_model(f_fitness, nx, nh, ng, lx, ux, x0)

"""
function build_model!(model::JuMP.Model, f_fitness::Function, nx::Int, nh::Int, ng::Int, lx::Vector, ux::Vector, x0::Vector=nothing)
	# number of fitness variables
	nfitness = 1 + nh + ng

	## get functions
	memoized_fitness  = memoize_fitness(f_fitness, nfitness)
	∇memoized_fitness = memoize_fitness_gradient(f_fitness, nfitness)

	# set variables
	if isnothing(x0) == true
		x0 = ones(nx,)
	end
	@variable(model, lx[i] <= x[i=keys(lx)] <= ux[i], start = x0[i])

	# set functions
	hs = [Symbol("h"*string(idx)) for idx = 1:nh]
	gs = [Symbol("g"*string(idx)) for idx = 1:ng]

	register(model, :f,  nx, memoized_fitness[1], ∇memoized_fitness[1])

	for ih = 1:nh
	    register(model, hs[ih], nx, memoized_fitness[1+ih], ∇memoized_fitness[1+ih])
	end

	for ig = 1:ng
	    register(model, gs[ig], nx, memoized_fitness[1+nh+ig], ∇memoized_fitness[1+nh+ig])
	end

	# append objective
	@NLobjective(model, Min, f(x...))

	# append equality constraints
	append_hs!(model, x, nh)

	# append equality constraints
	append_gs!(model, x, ng)

	return x

end

