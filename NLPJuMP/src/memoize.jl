"""
Memoize functions
"""


"""
    memoize_fitness(f_fitness::Function, n_outputs::Int)

Memoize fitness function. 
Because `foo_i` is auto-differentiated with ForwardDiff, our cache needs to
work when `x` is a `Float64` and a `ForwardDiff.Dual`.
"""
function memoize_fitness(f_fitness::Function, n_outputs::Int)
    last_x, last_f = nothing, nothing
    last_dx, last_dfdx = nothing, nothing
    function f_fitness_i(i, x::T...) where {T<:Real}
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

Create memoized gradient computation with FiniteDifferences
"""
function memoize_fitness_gradient(f_fitness::Function, nfitness::Int)
	# create memoized version
	f_fitness_nosplat(x) = f_fitness(x...)
    last_x, last_f = nothing, nothing
    function foo_i(i, df::AbstractVector{T}, x...) where {T} #::T...)# where {T<:Real}
        if x != last_x
            # update
            last_x = x
            jac2 = FiniteDifferences.jacobian(FiniteDifferences.central_fdm(5, 1), f_fitness_nosplat, x)
            res = []
            for i = 1:nfitness
                push!(res, jac2[1][i,:])
            end
            last_f = res
        end
        # store jacobian
        df[:] = last_f[i][:]
        return
    end
    return [(df, x...) -> foo_i(i, df, x...) for i in 1:nfitness]
end
