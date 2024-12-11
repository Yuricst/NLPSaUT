"""Minimal working example"""

using GLMakie
using Ipopt
using JuMP

function f_fitness(x::T...) where {T<:Real}
	# objective
    f = x[1]^2 - x[2]
    
    # equality constraints
    h = zeros(T, 1)
    h = x[1]^3 + x[2] - 2.4

    # inequality constraints
    g = zeros(T, 2)
    g[2] = -0.3x[1] + x[2] - 2   # y <= 0.3x + 2
    g[1] = x[1] + x[2] - 5      # y <= -x + 5
    
    fitness = [f; h; g]
    return fitness
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

# problem dimensions
nx = 2                   # number of decision vectors
nh = 1                   # number of equality constraints
ng = 2                   # number of inequality constraints
lx = -10*ones(nx,)
ux =  10*ones(nx,)
x0 = [-1.2, 10]

# get model
order = 2
diff_f = "forward"
model = Model(Ipopt.Optimizer)

# generate memoized fitness function 
nfitness = 1 + nh + ng
memoized_fitness = memoize(f_fitness, nfitness)

# set variables
@variable(model, lx[i] <= x[i in 1:nx] <= ux[i], start = x0[i])

# set objective
@operator(model, fobj, nx, memoized_fitness[1])
@objective(model, Min, fobj(x...))

# # append equality constraints
# h_ops = add_nonlinear_operator.(model, nx, memoized_fitness[2:1+nh])
# @constraint(model, hs[ih in 1:nh], h_ops[ih](x...) == 0)
# # h_funcs(i, x) = memoized_fitness[2:1+nh](x)[i]
# # @constraint(model, [i in 1:nh], h_funcs(i, x) == 0)

# # append inequality constraints
# g_ops = add_nonlinear_operator.(model, nx, memoized_fitness[2+nh:end])
# @constraint(model, gs[ig in 1:ng], g_ops[ig](x...) <= 0)
# # g_funcs(i, x) = memoized_fitness[2+nh:end][i](x...)
# # @constraint(model, [i in 1:ng], g_funcs(i, x) <= 0)

for i in 1:nh
    op = add_nonlinear_operator(
        model,
        nx,
        memoized_fitness[1+i];
        name = Symbol("op_h_$i"),
    )
    @constraint(model, op(x...) == 0)
end

for i in 1:ng
    op = add_nonlinear_operator(
        model,
        nx,
        memoized_fitness[1+nh+i];
        name = Symbol("op_g_$i"),
    )
    @constraint(model, op(x...) <= 0)
end

# run optimizer
optimize!(model)

# checks
@assert is_solved_and_feasible(model)
println(termination_status(model))
println("Decision vector: $(value.(model[:x]))")
println("Objective: $(objective_value(model))")

# plot contour
fig = Figure(size=(500,500))
ax = Axis(fig[1,1], xlabel="x1", ylabel="x2", title="g1 last")
xs_grid = LinRange(-11, 11, 100)
ys_grid = LinRange(-11, 11, 100)
contourf!(ax, xs_grid, ys_grid, (x, y) -> f_fitness(x, y)[1], levels=20)
lines!(ax, [x for x in xs_grid], [2.4 - x^3 for x in xs_grid], color=:blue)
fill_between!(ax, xs_grid, maximum(xs_grid) * ones(length(xs_grid)), 
    [0.3x + 2 for x in xs_grid], color=:black, alpha=0.35)
fill_between!(ax, xs_grid, maximum(xs_grid) * ones(length(xs_grid)), 
    [5 - x for x in xs_grid], color=:black, alpha=0.35)
scatter!(ax, [value(model[:x][1])], [value(model[:x][2])], markersize=5, color=:red)
xlims!(ax, minimum(xs_grid), maximum(xs_grid))
ylims!(ax, minimum(ys_grid), maximum(ys_grid))
display(fig)