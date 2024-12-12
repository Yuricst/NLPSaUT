# NLPSaUT

The `NLPSaUT` module constructs a `JuMP` `model` for a generic nonlinear program (NLP).
The expected use case is solving a differentiable (either analytically or numerically) nonconvex NLP with gradient-based algorithms such as Ipopt or SNOPT. 

The user is expected to provide a "fitness function" ([pygmo](https://github.com/esa/pygmo2)-style), which evaluates the objective, equality, and inequality constraints. 
Derivatives of `f_fitness` is taken using `ForwardDiff.jl` (which is the default `JuMP` behavior according to its [docs](https://jump.dev/JuMP.jl/stable/tutorials/nonlinear/operator_ad/#Gradient)); as such, `f_fitness` should be written in a way that is compatiable to `ForwardDiff.jl` ([read here as to why it is `ForwardDiff`, not `ReverseDiff`](https://jump.dev/JuMP.jl/stable/manual/nonlinear/#Automatic-differentiation-2)). 
For reference, here's the [JuMP docs page on common mistakes when using `ForwardDiff.jl`](https://jump.dev/JuMP.jl/stable/manual/nonlinear/#Common-mistakes-when-writing-a-user-defined-operator). 

The `model` constructed by `NLPSaUT` utilizes `memoization` to economize on the fitness evaluation (see [JuMP Tips and tricks on NLP](https://jump.dev/JuMP.jl/stable/tutorials/nonlinear/tips_and_tricks/)). 

## Quick start

1. `git clone` this repository
2. start julia-repl
3. activate & instantiate package (first time)

```julia-repl
pkg> activate .
julia> using Pkg                # first time only
julia> Pkg.instantiate()        # first time only
```

4. run tests

```julia-repl
(NLPSaUT) pkg> test
```

### Note

- To use with SNOPT, it's probably better to go through [`GAMS.jl`](https://github.com/GAMS-dev/gams.jl?tab=readme-ov-file) rather than to use [`SNOPT7.jl`](https://github.com/snopt/SNOPT7.jl) directly (installing `SNOPT7.jl` currently errors on julia v1.10)
