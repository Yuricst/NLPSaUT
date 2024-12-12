"""
Memoize functions for fitness evaluation
"""


"""
    memoize_fitness(f_fitness::Function, n_outputs::Int)

Memoize fitness function. 
Because `foo_i` is auto-differentiated with ForwardDiff, our cache needs to
work when `x` is a `Float64` and a `ForwardDiff.Dual`.

See: 
https://jump.dev/JuMP.jl/stable/tutorials/nonlinear/tips_and_tricks/#Memoization
"""
function memoize_fitness(f_fitness::Function, n_outputs::Int)
    last_x, last_f = nothing, nothing
    last_dx, last_dfdx = nothing, nothing
    function f_fitness_i(i::Int, x::T...) where {T<:Real}
        if T == Float64
            if x != last_x
                last_x, last_f = x, f_fitness(x...)
            end
            return last_f[i]::T
        else
            # if x != last_dx       # uncommenting this makes it buggy with ODEProblem...
                last_dx, last_dfdx = x, f_fitness(x...)
            # end
            return last_dfdx[i]::T
        end
    end
    return [(x...) -> f_fitness_i(i, x...) for i in 1:n_outputs]
end


"""
    memoize_fitness_gradient(f_fitness::Function, nfitness::Int, fd_type::Function, order::Int=2)

Create memoized gradient computation with method specified by `fd_type`
    - `fd_type = "forward"` use `FiniteDifferences.forward_fdm()`
    - `fd_type = "central"` use `FiniteDifferences.central_fdm()`
    - `fd_type = "backward"` use `FiniteDifferences.backward_fdm()`
"""
function memoize_fitness_gradient(
    f_fitness::Function,
    nfitness::Int, 
    fd_type::String = "forward", 
    order::Int = 2
)
	# create fitness function alias with no splatting for FiniteDifferences.jacobian
	f_fitness_nosplat(x) = f_fitness(x...)
    last_x, last_f = nothing, nothing

    # Memoized function for gradient and jacobians
    if cmp(fd_type, "forward")==0
        function foo_fwd(i::Int, df::AbstractVector{T}, x::T...)::Nothing where {T<:Real}
            if x != last_x
                # update
                last_x = x
            	jac2 = FiniteDifferences.jacobian(FiniteDifferences.forward_fdm(order, 1), f_fitness_nosplat, x)
                last_f = jac2[1]
            end
            df[:] = last_f[i,:]
            return
        end
        return [(df, x...) -> foo_fwd(i, df, x...) for i in 1:nfitness]

    elseif cmp(fd_type, "central")==0

        function foo_cent(i::Int, df::AbstractVector{T}, x::T...)::Nothing where {T<:Real}
            if x != last_x
                # update
                last_x = x
                jac2 = FiniteDifferences.jacobian(FiniteDifferences.central_fdm(order, 1), f_fitness_nosplat, x)
                last_f = jac2[1]
            end
            df[:] = last_f[i,:]
            return
        end
        return [(df, x...) -> foo_cent(i, df, x...) for i in 1:nfitness]

    elseif cmp(fd_type, "backward")==0

        function foo_bck(i::Int, df::AbstractVector{T}, x::T...)::Nothing where {T<:Real}
            if x != last_x
                # update
                last_x = x
                jac2 = FiniteDifferences.jacobian(FiniteDifferences.backward_fdm(order, 1), f_fitness_nosplat, x)
                last_f = jac2[1]
            end
            df[:] = last_f[i,:]
            return
        end
        return [(df, x...) -> foo_bck(i, df, x...) for i in 1:nfitness]

    end
end

