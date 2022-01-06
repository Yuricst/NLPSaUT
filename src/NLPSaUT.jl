"""
NLPSaUT.jl

Wrapper to construct JuMP model for NLPs
"""
module NLPSaUT

using JuMP
using Ipopt
import FiniteDifferences

# generator for constraints
include("generate_append_function.jl")

# functions to build model
include("memoize.jl")
include("append_equalityconstraints.jl")
include("append_inequalityconstraints.jl")
include("model.jl")
include("examples.jl")

# export functions
export memoize_fitness, memoize_fitness_gradient
export build_model, build_model!

end
