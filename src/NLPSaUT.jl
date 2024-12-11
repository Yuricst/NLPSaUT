"""
NLPSaUT.jl

Wrapper to construct JuMP model for NLPs
"""
module NLPSaUT
    using JuMP
    using Ipopt
    import FiniteDifferences

    # functions to build model
    include("memoize.jl")
    include("model.jl")
    include("examples/example_fitness.jl")

    # export functions
    export memoize_fitness, memoize_fitness_gradient
    export build_model, build_model!
end
