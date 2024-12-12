"""
Exapmle with simple shooting-method in CR3BP

We consider a phasing problem with a single maneuver.
"""

using GLMakie
using Ipopt
using JuMP
using LinearAlgebra
using OrdinaryDiffEq

include(joinpath(@__DIR__, "../src/NLPSaUT.jl"))


function cr3bp_rhs!(du,u,p,t)
    # unpack state
    x, y, z = u[1], u[2], u[3]
    vx, vy, vz = u[4], u[5], u[6]
    # compute distances
    r1 = sqrt( (x+p[1])^2 + y^2 + z^2 );
    r2 = sqrt( (x-1+p[1])^2 + y^2 + z^2 );
    # derivatives of positions
    du[1] = u[4]
    du[2] = u[5]
    du[3] = u[6]
    # derivatives of velocities
    du[4] = 2*vy + x - ((1-p[1])/r1^3)*(p[1]+x) + (p[1]/r2^3)*(1-p[1]-x);
    du[5] = -2*vx + y - ((1-p[1])/r1^3)*y - (p[1]/r2^3)*y;
    du[6] = -((1-p[1])/r1^3)*z - (p[1]/r2^3)*z;
    return
end

# initial state
rv0 = [1.0809931218390707, 0.0, -2.0235953267405354E-01,
       0.0, -1.9895001215078018E-01, 0.0]
period_0 = 2.3538670417546639E+00
tspan = [0.0, 0.9*period_0]
μ = 1.215058560962404e-02
params_ode = [μ,]

# problem dimensions
nx = 3
nh = 3
ng = 0
lx = -0.5 * ones(nx,)
ux =  0.5 * ones(nx,)
x0 = [0.0, 0.0, 0.0]

base_ode_problem = ODEProblem(
    cr3bp_rhs!,
    rv0,
    tspan,
    params_ode,
)

function get_trajectory(DV::T...) where {T<:Real}
    ode_problem = remake(base_ode_problem; u0 = rv0 + [0; 0; 0; DV...])
    sol = solve(ode_problem, Tsit5(); reltol = 1e-12, abstol = 1e-12)
    return sol
end

function f_fitness(DV::T...) where {T<:Real}
    # integrate trajectory
    sol = get_trajectory(DV)

    # final state deviation
    xf = sol.u[end]
    
	# objective
    f = norm(DV) #+ norm(rv0[4:6] - xf[4:6])
    
    # equality constraints for final state
    h = rv0[1:3] - xf[1:3]
    return [f; h]
end

fitness_init = f_fitness(0.0, 0.0, 0.0)


# get model
order = 2
diff_f = "forward"
model = NLPSaUT.build_model(Ipopt.Optimizer, f_fitness, nx, nh, ng, lx, ux, x0; disable_memoize = false)
set_optimizer_attribute(model, "tol", 1e-12)
set_optimizer_attribute(model, "print_level", 5)
println(model)

# run optimizer
optimize!(model)
xopt = value.(model[:x])

# checks
@assert is_solved_and_feasible(model)

# plot
sol_initialguess = get_trajectory(x0)
sol_optimal = get_trajectory(xopt)

fig = Figure(size=(500,500))
ax = Axis3(fig[1,1]; aspect = :data, xlabel = "x", ylabel = "y", zlabel = "z")
scatter!(ax, [rv0[1]], [rv0[2]], [rv0[3]], markersize = 10, color = :red)
lines!(ax, Array(sol_initialguess)[1,:], Array(sol_initialguess)[2,:], Array(sol_initialguess)[3,:],
       color = :grey, label="Initial guess")
lines!(ax, Array(sol_optimal)[1,:], Array(sol_optimal)[2,:], Array(sol_optimal)[3,:],
       color = :red, label="Optimal two-impulse phasing trajectory")
axislegend(ax)
display(fig)
