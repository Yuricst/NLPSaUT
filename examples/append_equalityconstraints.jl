"""
    append_hs!(model::JuMP.Model, x, nh::Int)

Append equalty constraints (auto-generated)

# Arguments
    `model::JuMP.Model`: optimization model
    `x::JuMP.variables`: optimization model variables
    `nh::Int`: number of equality constraints
"""
function append_hs!(model::JuMP.Model, x, nh::Int)
    for ih = 1:nh 
        if ih == 1 
            @NLconstraint(model, h1(x...) == 0)
        elseif ih == 2 
            @NLconstraint(model, h2(x...) == 0)
        elseif ih == 3 
            @NLconstraint(model, h3(x...) == 0)
        elseif ih == 4 
            @NLconstraint(model, h4(x...) == 0)
        elseif ih == 5 
            @NLconstraint(model, h5(x...) == 0)
        elseif ih == 6 
            @NLconstraint(model, h6(x...) == 0)
        elseif ih == 7 
            @NLconstraint(model, h7(x...) == 0)
        elseif ih == 8 
            @NLconstraint(model, h8(x...) == 0)
        elseif ih == 9 
            @NLconstraint(model, h9(x...) == 0)
        elseif ih == 10 
            @NLconstraint(model, h10(x...) == 0)
        elseif ih == 11 
            @NLconstraint(model, h11(x...) == 0)
        elseif ih == 12 
            @NLconstraint(model, h12(x...) == 0)
        elseif ih == 13 
            @NLconstraint(model, h13(x...) == 0)
        elseif ih == 14 
            @NLconstraint(model, h14(x...) == 0)
        elseif ih == 15 
            @NLconstraint(model, h15(x...) == 0)
        elseif ih == 16 
            @NLconstraint(model, h16(x...) == 0)
        elseif ih == 17 
            @NLconstraint(model, h17(x...) == 0)
        elseif ih == 18 
            @NLconstraint(model, h18(x...) == 0)
        elseif ih == 19 
            @NLconstraint(model, h19(x...) == 0)
        elseif ih == 20 
            @NLconstraint(model, h20(x...) == 0)
        end
    end
end
