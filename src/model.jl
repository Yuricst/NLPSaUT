"""
Building model
"""


"""
	build_model(f_fitness::Function, nx::Int, nh::Int, ng::Int, lx::Vector, ux::Vector, x0::Vector=nothing, fd_type::Function=nothing, order::Int=2)

Build model for NLP problem with memoized fitness function.

# Arguments:
- `optimizer`: optimizer to use with the model
- `f_fitness::Function`: fitness function, returning [f, h, g]
- `nx::Int`: number of decision variables 
- `nh::Int`: number of equality constraints 
- `ng::Int`: number of inequality constraints 
- `lx::Vector`: lower bounds on decision variables 
- `ux::Vector`: upper bounds on decision variables 
- `x0::Vector`: initial guess
- `auto_diff::Bool`: whether to use automatic differentiation
- `order::Int`: order of FiniteDifferences, minimum is 2
- `fd_type::String`: finite-difference method, "forward", "backward", or "central"
"""
function build_model(
	optimizer,
	f_fitness::Function, 
	nx::Int, 
	nh::Int, 
	ng::Int, 
	lx::Vector, 
	ux::Vector, 
	x0::Vector;
	auto_diff::Bool = true,
	order::Int=2, 
	fd_type::String="forward",
)
	# Construct JuMP model
	model = Model(optimizer)
	build_model!(model, f_fitness, nx, nh, ng, lx, ux, x0; auto_diff = auto_diff, order = order, fd_type = fd_type)
	return model
end



"""
	build_model!(model::JuMP.Model, f_fitness::Function, nx::Int, nh::Int, ng::Int, lx::Vector, ux::Vector, x0::Vector=nothing)

Extend model for NLP problem via memoized fitness function.

# Arguments:
- `model::JuMP.Model`: model to append objective and constraints
- `f_fitness::Function`: fitness function, returning [f, h, g]
- `nx::Int`: number of decision variables 
- `nh::Int`: number of equality constraints 
- `ng::Int`: number of inequality constraints 
- `lx::Vector`: lower bounds on decision variables 
- `ux::Vector`: upper bounds on decision variables 
- `x0::Vector`: initial guess
- `auto_diff::Bool`: whether to use automatic differentiation
- `order::Int`: order of FiniteDifferences, minimum is 2
- `fd_type::String`: finite-difference method, "forward", "backward", or "central"
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
	auto_diff::Bool = true,
	order::Int = 2,
	fd_type::String = "forward",
)
	# number of fitness variables
	nfitness = 1 + nh + ng

	# get memoized fitness function
	memoized_fitness = memoize_fitness(f_fitness, nfitness)
	if auto_diff == false
		∇memoized_fitness = memoize_fitness_gradient(f_fitness, nfitness, fd_type, order)
	end

	# set variables
	if isnothing(x0) == true
		x0 = ones(nx,)
	end
	@variable(model, lx[i] <= x[i in 1:nx] <= ux[i], start = x0[i])

	# register NLP function
	if auto_diff
		@operator(model, fobj, nx, memoized_fitness[1])
	else
		@operator(model, fobj, nx, memoized_fitness[1], ∇memoized_fitness[1])
	end
	@objective(model, Min, fobj(x...))

	# append equality constraints
	for i in 1:nh
		if auto_diff
			op = add_nonlinear_operator(
				model,
				nx,
				memoized_fitness[1+i];
				name = Symbol("op_h_$i"),		# need to explicitly define unique name!
			)
		else
			op = add_nonlinear_operator(
				model,
				nx,
				memoized_fitness[1+i],
				∇memoized_fitness[1+i];
				name = Symbol("op_h_$i"),		# need to explicitly define unique name!
			)
		end
		@constraint(model, op(x...) == 0)
	end
	
	# append inequality constraints
	for i in 1:ng
		if auto_diff
			op = add_nonlinear_operator(
				model,
				nx,
				memoized_fitness[1+nh+i];
				name = Symbol("op_g_$i"),		# need to explicitly define unique name!
			)
		else
			op = add_nonlinear_operator(
				model,
				nx,
				memoized_fitness[1+nh+i],
				∇memoized_fitness[1+nh+i];
				name = Symbol("op_g_$i"),		# need to explicitly define unique name!
			)
		end
		@constraint(model, op(x...) <= 0)
	end
	return
end

