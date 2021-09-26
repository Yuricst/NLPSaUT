"""
Automated generator for constraint append function
"""


function genetate_equalityconstraints_function(nh=100)
	open("append_equalityconstraints.jl", "w+") do io
		write(io, "\"\"\"\n")
		write(io, "    append_hs!(model::JuMP.Model, x, nh::Int)\n\n")
	    write(io, "Append equalty constraints (auto-generated)\n\n")
	    write(io, "# Arguments\n")
	    write(io, "    `model::JuMP.Model`: optimization model\n")
	    write(io, "    `x::JuMP.variables`: optimization model variables\n")
	    write(io, "    `nh::Int`: number of equality constraints\n")
	    write(io, "\"\"\"\n")
	    write(io, "function append_hs!(model::JuMP.Model, x, nh::Int)\n")
	    write(io, "    for ih = 1:nh \n")
		write(io, "        if ih == 1 \n")
		write(io, "            @NLconstraint(model, h1(x...) == 0)\n")
	    for j = 2:nh
		    write(io, "        elseif ih == $j \n")
		    write(io, "            @NLconstraint(model, h$j(x...) == 0)\n")
	    end
	     write(io, "        end\n")
	    write(io, "    end\n")
	    write(io, "end\n")
	end
end


function genetate_inequalityconstraints_function(ng=100)
	open("append_inequalityconstraints.jl", "w+") do io
		write(io, "\"\"\"\n")
		write(io, "    append_gs!(model::JuMP.Model, x, ng::Int)\n\n")
	    write(io, "Append inequality constraints (auto-generated)\n\n")
	    	    write(io, "# Arguments\n")
	    write(io, "    `model::JuMP.Model`: optimization model\n")
	    write(io, "    `x::JuMP.variables`: optimization model variables\n")
	    write(io, "    `ng::Int`: number of inequality constraints\n")
	    write(io, "\"\"\"\n")
	    write(io, "function append_gs!(model::JuMP.Model, x, ng::Int)\n")
	    write(io, "    for ig = 1:ng \n")
		write(io, "        if ig == 1 \n")
		write(io, "            @NLconstraint(model, g1(x...) <= 0)\n")
	    for j = 2:ng
		    write(io, "        elseif ig == $j \n")
		    write(io, "            @NLconstraint(model, g$j(x...) <= 0)\n")
	    end
	     write(io, "        end\n")
	    write(io, "    end\n")
	    write(io, "end\n")
	end
end



genetate_equalityconstraints_function()
genetate_inequalityconstraints_function()