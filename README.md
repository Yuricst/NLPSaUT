# NLPSaUT

The `NLPSaUT` module constructs a `JuMP` `model` for a generic nonlinear program (NLP).
The user is expected to provide a "fitness function", which evaluates the objective, equality, and inequality constraints. Below is an example: 

```julia
function f_fitness(x::T...) where {T<:Real}
	# compute objective
    f = x[1]^2 - x[2]
    
    # equality constraints
    h = zeros(T, 1)
    h = x[1]^3 + x[2] - 2.4

    # inequality constraints
    g = zeros(T, 2)
    g[2] = -0.3x[1] + x[2] - 2   # y <= 0.3x + 2
    g[1] = x[1] + x[2] - 5      # y <= -x + 5
    return [f; h; g]
end
```

The `model` constructed by `NLPSaUT` utilizes `memoization` to economize on the fitness evaluation (see [JuMP Tips and tricks on NLP](https://jump.dev/JuMP.jl/stable/tutorials/nonlinear/tips_and_tricks/)). 

## Quick start

1. `git clone` this repository
2. start julia-repl
3. activate & instantiate package (first time)

```julia-repl
pkg> activate .
julia> using Pkg
julia> Pkg.instantiate()
```

4. run tests

```julia-repl
(NLPSaUT) pkg> test
```


### Examples

For examples, see the `examples` directory.