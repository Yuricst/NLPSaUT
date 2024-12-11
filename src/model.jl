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
	optimizer,
	f_fitness::Function, 
	nx::Int, 
	nh::Int, 
	ng::Int, 
	lx::Vector, 
	ux::Vector, 
	x0::Vector, 
	order::Int=2, 
	diff_f::String="forward",
)
	# Construct JuMP model
	model = Model(optimizer)
	build_model!(model, f_fitness, nx, nh, ng, lx, ux, x0; order = order, diff_f = diff_f)
	return model
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
	x0::Vector;
	order::Int=2,
	diff_f::String="forward",
)
	# number of fitness variables
	nfitness = 1 + nh + ng

	# get memoized fitness function
	memoized_fitness = memoize_fitness(f_fitness, nx, nfitness)
	# if isnothing(diff_f) == true
	# 	∇memoized_fitness = memoize_fitness_gradient(f_fitness, nx, nfitness, order)
	# else
	# 	∇memoized_fitness = memoize_fitness_gradient(f_fitness, nx, nfitness, diff_f, order)
	# end

	# set variables
	if isnothing(x0) == true
		x0 = ones(nx,)
	end
	@variable(model, lx[i] <= x[i in 1:nx] <= ux[i], start = x0[i])

	# register NLP function
	@operator(model, fobj, nx, memoized_fitness[1])
	@objective(model, Min, fobj(x...))

	# append equality constraints
	for i in 1:nh
		op = add_nonlinear_operator(
			model,
			nx,
			memoized_fitness[1+i];
			name = Symbol("op_h_$i"),		# need to explicitly define unique name!
		)
		@constraint(model, op(x...) == 0)
	end
	
	# append inequality constraints
	for i in 1:ng
		op = add_nonlinear_operator(
			model,
			nx,
			memoized_fitness[1+nh+i];
			name = Symbol("op_g_$i"),		# need to explicitly define unique name!
		)
		@constraint(model, op(x...) <= 0)
	end
	return
end

