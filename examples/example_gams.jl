"""Example using GAMS"""

using GAMS, JuMP

include(joinpath(@__DIR__, "../src/NLPSaUT.jl"))

# define problem
nx = 2                   # number of decision vectors
nh = 1                   # number of equality constraints
ng = 2                   # number of inequality constraints
lx = -10*ones(nx,)
ux =  10*ones(nx,)
x0 = [-1.2, 10]

# get model
order = 2
diff_f = "forward"
model = NLPSaUT.build_model(GAMS.Optimizer, NLPSaUT.fitness_example_01, nx, nh, ng, lx, ux, x0;)
# set_optimizer_attribute(model, "tol", 1e-12)
# set_optimizer_attribute(model, "print_level", 5)
println(model)

# run optimizer
optimize!(model)
xopt = value.(model[:x])

# checks
@assert is_solved_and_feasible(model)

# print results
println(termination_status(model))
println("Decision vector: ")
println(xopt)
println("Objective: ")
println(objective_value(model))

# plot contour
fig = Figure(size=(500,500))
ax = Axis(fig[1,1], xlabel="x1", ylabel="x2")
xs_grid = LinRange(-11, 11, 100)
ys_grid = LinRange(-11, 11, 100)
contourf!(ax, xs_grid, ys_grid, (x, y) -> f_fitness(x, y)[1], levels=20)

# plot constraints
lines!(ax, [x for x in xs_grid], [2.4 - x^3 for x in xs_grid], color=:blue)
fill_between!(ax, xs_grid, maximum(xs_grid) * ones(length(xs_grid)), 
    [0.3x + 2 for x in xs_grid], color=:black, alpha=0.35)
fill_between!(ax, xs_grid, maximum(xs_grid) * ones(length(xs_grid)), 
    [5 - x for x in xs_grid], color=:black, alpha=0.35)

# plot solution
scatter!(ax, [value(model[:x][1])], [value(model[:x][2])], markersize=5, color=:red)

xlims!(ax, minimum(xs_grid), maximum(xs_grid))
ylims!(ax, minimum(ys_grid), maximum(ys_grid))

# save figure
save(joinpath(@__DIR__, "contour_ipopt.png"), fig)
display(fig)