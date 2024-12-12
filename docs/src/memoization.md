# Memoization

`NLPSaUT` internally converts the provided fitness function into a memoized function call, i.e. caching last computed results to avoid unecessary function calls - this is necessary since JuMP in general supports only operators with scalar-valued outputs [See JuMP docs](https://jump.dev/JuMP.jl/stable/tutorials/nonlinear/tips_and_tricks/#Memoization). 
We can purposefully turn this off to see why it is essential to use memoization.

!! info 
    The default behavior of `NLPSaUT` is set to use memoization, so users do not need to worry about this. This page is intended as a sanity-check that memoization does matter - especially when the fitness function is expensive, and/or when there are many constraints.

Let's consider the example with halo orbit phasing. 
We will import necessary modules and define our convenience propagation method.

```julia
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

# define convenience method for propagating trajectories
base_ode_problem = ODEProblem(cr3bp_rhs!, rv0, tspan, params_ode)

function get_trajectory(DV::T...) where {T<:Real}
    ode_problem = remake(base_ode_problem; u0 = rv0 + [0; 0; 0; DV...])
    sol = solve(ode_problem, Tsit5(); reltol = 1e-12, abstol = 1e-12)
    return sol
end

# problem dimensions
nx = 3
nh = 3
ng = 0
lx = -0.5 * ones(nx,)
ux =  0.5 * ones(nx,)
x0 = [0.0, 0.0, 0.0]
```

We now define our fitness function; we will include a `sleep` call to mimic an expensive fitness function. 

```julia
function f_fitness(DV::T...) where {T<:Real}
    # integrate trajectory
    sol = get_trajectory(DV...)

    # final state deviation
    xf = sol.u[end]
    
	# objective
    f = norm(DV) + norm(rv0[4:6] - xf[4:6])
    
    # equality constraints for final state
    h = rv0[1:3] - xf[1:3]

    # slow down the fitness evaluation to mimic expensive function
    sleep(0.2)
    return [f; h]
end
```

Now, when we build the JuMP model, we toggle the option `disable_memoize` to `true` (by default, this is set to `false`). 

```julia
# get model
model = NLPSaUT.build_model(Ipopt.Optimizer, f_fitness, nx, nh, ng, lx, ux, x0; disable_memoize = false)
set_optimizer_attribute(model, "tol", 1e-12)
set_optimizer_attribute(model, "print_level", 5)
optimize!(model)
```

The IPOPT output tells us

```
Number of Iterations....: 5

                                   (scaled)                 (unscaled)
Objective...............:   5.7727802113732851e-02    5.7727802113732851e-02
Dual infeasibility......:   1.3322676295501878e-15    1.3322676295501878e-15
Constraint violation....:   6.4392935428259079e-15    6.4392935428259079e-15
Variable bound violation:   0.0000000000000000e+00    0.0000000000000000e+00
Complementarity.........:   0.0000000000000000e+00    0.0000000000000000e+00
Overall NLP error.......:   6.4392935428259079e-15    6.4392935428259079e-15


Number of objective function evaluations             = 6
Number of objective gradient evaluations             = 6
Number of equality constraint evaluations            = 6
Number of inequality constraint evaluations          = 0
Number of equality constraint Jacobian evaluations   = 6
Number of inequality constraint Jacobian evaluations = 0
Number of Lagrangian Hessian evaluations             = 0
Total seconds in IPOPT                               = 11.244
```

Let's now re-build the model, this time with memoization turned on:

```julia
# get model
model = NLPSaUT.build_model(Ipopt.Optimizer, f_fitness, nx, nh, ng, lx, ux, x0)    # equivalent to setting disable_memoize = true explicitly
set_optimizer_attribute(model, "tol", 1e-12)
set_optimizer_attribute(model, "print_level", 5)
optimize!(model)
```

This yields the IPOPT output

```
Number of Iterations....: 5

                                   (scaled)                 (unscaled)
Objective...............:   5.7727802113732851e-02    5.7727802113732851e-02
Dual infeasibility......:   1.3322676295501878e-15    1.3322676295501878e-15
Constraint violation....:   6.4392935428259079e-15    6.4392935428259079e-15
Variable bound violation:   0.0000000000000000e+00    0.0000000000000000e+00
Complementarity.........:   0.0000000000000000e+00    0.0000000000000000e+00
Overall NLP error.......:   6.4392935428259079e-15    6.4392935428259079e-15


Number of objective function evaluations             = 6
Number of objective gradient evaluations             = 6
Number of equality constraint evaluations            = 6
Number of inequality constraint evaluations          = 0
Number of equality constraint Jacobian evaluations   = 6
Number of inequality constraint Jacobian evaluations = 0
Number of Lagrangian Hessian evaluations             = 0
Total seconds in IPOPT                               = 3.608
```

As expected, we converge to the exact same solution, with the same number of iterations, but a fraction of the computational time. 