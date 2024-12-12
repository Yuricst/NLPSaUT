"""
Make documentation with Documenter.jl
"""

using Documenter

include(joinpath(dirname(@__FILE__), "../src/NLPSaUT.jl"))

makedocs(
    clean = false,
    build = dirname(@__FILE__),
	# modules  = [NLPSaUT],
    format   = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    sitename = "NLPSaUT.jl",
    # options
    pages = [
		"Home" => "index.md",
        "Tutorials" => Any[
            "Basics" => "basics.md",
        ],
		"API" => Any[
			"Core" => "api_core.md",
		],
    ],
	# assets = [
    #     "./assets/logo.png",
    # ],
)