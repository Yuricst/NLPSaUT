"""Example fitness functions"""


function fitness_example_01(x::T...) where {T<:Real}
	# objective
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