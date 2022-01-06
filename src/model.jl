"""
Building model
"""


"""
	build_model(f_fitness::Function, nx::Int, nh::Int, ng::Int, lx::Vector, ux::Vector, x0::Vector=nothing, diff_f::Function=nothing, order::Int=2)

Build model for NLP problem. 

# Arguments:
	- `f_fitness::Function`: fitness function, returning [f, h, g]
	- `nx::Int`: number of decision variables 
	- `nh::Int`: number of equality constraints 
	- `ng::Int`: number of inequality constraints 
	- `lx::Vector`: lower bounds on decision variables 
	- `ux::Vector`: upper bounds on decision variables 
	- `x0::Vector`: initial guess
	- `order::Int`: order of FiniteDifferences, minimum is 2
	- `diff_f::String`: finite-difference method, "forward", "backward", or "central"

# Returns
	- `tuple`: JuMP variables and JuMP model

# Example
	x, model = build_model(f_fitness, nx, nh, ng, lx, ux, x0)

"""
function build_model(
	f_fitness::Function, 
	nx::Int, 
	nh::Int, 
	ng::Int, 
	lx::Vector, 
	ux::Vector, 
	x0::Vector, 
	order::Int=2, 
	diff_f::String="forward",
	verbose::Bool=false,
)
	# Construct JuMP model
	model = Model(Ipopt.Optimizer)
	x = build_model!(model, f_fitness, nx, nh, ng, lx, ux, x0, order, diff_f, verbose)
	return x, model
end



"""
	build_model!(model::JuMP.Model, f_fitness::Function, nx::Int, nh::Int, ng::Int, lx::Vector, ux::Vector, x0::Vector=nothing)

Extend model for NLP problem. 

# Arguments:
	- `model::JuMP.Model`: model to append objective and constraints
	- `f_fitness::Function`: fitness function, returning [f, h, g]
	- `nx::Int`: number of decision variables 
	- `nh::Int`: number of equality constraints 
	- `ng::Int`: number of inequality constraints 
	- `lx::Vector`: lower bounds on decision variables 
	- `ux::Vector`: upper bounds on decision variables 
	- `x0::Vector`: initial guess
	- `order::Int`: order of FiniteDifferences, minimum is 2
	- `diff_f::String`: finite-difference method, "forward", "backward", or "central"

# Returns
	- `tuple`: JuMP variables and JuMP model

# Example
	x, model = build_model(f_fitness, nx, nh, ng, lx, ux, x0)

"""
function build_model!(
	model::JuMP.Model,
	f_fitness::Function,
	nx::Int,
	nh::Int,
	ng::Int,
	lx::Vector,
	ux::Vector,
	x0::Vector,
	order::Int=2,
	diff_f::String="forward",
	verbose::Bool=false,
)

	# =nothing, diff_f::Function=nothing, order::Int=2)

	# number of fitness variables
	nfitness = 1 + nh + ng

	## get functions
	if verbose
		println("Generating memoized functions...")
	end
	memoized_fitness  = memoize_fitness(f_fitness, nx, nfitness)
	if isnothing(diff_f) == true
		∇memoized_fitness = memoize_fitness_gradient(f_fitness, nx, nfitness, order)
	else
		∇memoized_fitness = memoize_fitness_gradient(f_fitness, nx, nfitness, diff_f, order)
	end

	# set variables
	if isnothing(x0) == true
		x0 = ones(nx,)
	end
	@variable(model, lx[i] <= x[i=keys(lx)] <= ux[i], start = x0[i])

	# set functions
	hs = [Symbol("h"*string(idx)) for idx = 1:nh]
	gs = [Symbol("g"*string(idx)) for idx = 1:ng]

	# register NLP function
	if verbose
		println("Registering nonlinear function...")
	end
	register(model, :f,  nx, memoized_fitness[1], ∇memoized_fitness[1])

	# append equality constraints
	if verbose
		println("Appending  objective & constraints to model...")
	end
	for ih = 1:nh
	    register(model, hs[ih], nx, memoized_fitness[1+ih], ∇memoized_fitness[1+ih])
	end

	# append inequality constraints
	for ig = 1:ng
	    register(model, gs[ig], nx, memoized_fitness[1+nh+ig], ∇memoized_fitness[1+nh+ig])
	end

	# append objective
	@NLobjective(model, Min, f(x...))

	# append equality constraints
	append_hs!(model, x, nh)

	# append equality constraints
	append_gs!(model, x, ng)
	if verbose
		println("Model ready!")
	end
	return x

end

