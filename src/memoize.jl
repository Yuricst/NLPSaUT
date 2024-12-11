"""
Memoize functions for fitness evaluation
"""


"""
    memoize_fitness(f_fitness::Function, n_outputs::Int)

Memoize fitness function. 
Because `foo_i` is auto-differentiated with ForwardDiff, our cache needs to
work when `x` is a `Float64` and a `ForwardDiff.Dual`.
"""
function memoize_fitness(f_fitness::Function, nx::Int, n_outputs::Int)
    last_x, last_f = nothing, nothing
    last_dx, last_dfdx = nothing, nothing
    function f_fitness_i(i::Int, x::T...) where {T<:Real}
        if T == Float64
            if x != last_x
                last_x, last_f = x, f_fitness(x...)
            end
            return last_f[i]::T
        else
            if x != last_dx
                last_dx, last_dfdx = x, f_fitness(x...)
            end
            return last_dfdx[i]::T
        end
    end
    return [(x...) -> f_fitness_i(i, x...) for i in 1:n_outputs]
end


"""
    memoize_fitness_gradient(f_fitness::Function, n_outputs::Int, nx::Int)

Create memoized gradient computation with FiniteDifferences.forward_fdm()
"""
function memoize_fitness_gradient(
    f_fitness::Function, 
    nx::Int, 
    nfitness::Int, 
    order::Int=2
)
	diff_f = "forward"
    return memoize_fitness_gradient(f_fitness, nx, nfitness, diff_f, order)
end



"""
    memoize_fitness_gradient(f_fitness::Function, nfitness::Int, diff_f::Function, order::Int=2)

Create memoized gradient computation with method specified by `diff_f`
    - `diff_f = "forward"` use `FiniteDifferences.forward_fdm()`
    - `diff_f = "central"` use `FiniteDifferences.central_fdm()`
    - `diff_f = "backward"` use `FiniteDifferences.backward_fdm()`
"""
function memoize_fitness_gradient(
    f_fitness::Function, 
    nx::Int, 
    nfitness::Int, 
    diff_f::String, 
    order::Int=2
)
	# create memoized version
	f_fitness_nosplat(x) = f_fitness(x...)
    last_x, last_f = ones(nx), zeros(nx,nfitness)

    # Memoized function for gradient and jacobians
    if cmp(diff_f, "forward")==0
        
        function foo_fwd(i::Int, df::AbstractVector{T}, x...) where {T} #::T...)# where {T<:Real}
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

    elseif cmp(diff_f, "central")==0

        function foo_cent(i::Int, df::AbstractVector{T}, x...) where {T} #::T...)# where {T<:Real}
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

    elseif cmp(diff_f, "backward")==0

        function foo_bck(i::Int, df::AbstractVector{T}, x...) where {T} #::T...)# where {T<:Real}
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

