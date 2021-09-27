"""
    append_gs!(model::JuMP.Model, x, ng::Int)

Append inequality constraints (auto-generated)

# Arguments
    `model::JuMP.Model`: optimization model
    `x::JuMP.variables`: optimization model variables
    `ng::Int`: number of inequality constraints
"""
function append_gs!(model::JuMP.Model, x, ng::Int)
    for ig = 1:ng 
        if ig == 1 
            @NLconstraint(model, -Inf <= g1(x...) <= 0)
        elseif ig == 2 
            @NLconstraint(model, -Inf <= g2(x...) <= 0)
        elseif ig == 3 
            @NLconstraint(model, -Inf <= g3(x...) <= 0)
        elseif ig == 4 
            @NLconstraint(model, -Inf <= g4(x...) <= 0)
        elseif ig == 5 
            @NLconstraint(model, -Inf <= g5(x...) <= 0)
        elseif ig == 6 
            @NLconstraint(model, -Inf <= g6(x...) <= 0)
        elseif ig == 7 
            @NLconstraint(model, -Inf <= g7(x...) <= 0)
        elseif ig == 8 
            @NLconstraint(model, -Inf <= g8(x...) <= 0)
        elseif ig == 9 
            @NLconstraint(model, -Inf <= g9(x...) <= 0)
        elseif ig == 10 
            @NLconstraint(model, -Inf <= g10(x...) <= 0)
        elseif ig == 11 
            @NLconstraint(model, -Inf <= g11(x...) <= 0)
        elseif ig == 12 
            @NLconstraint(model, -Inf <= g12(x...) <= 0)
        elseif ig == 13 
            @NLconstraint(model, -Inf <= g13(x...) <= 0)
        elseif ig == 14 
            @NLconstraint(model, -Inf <= g14(x...) <= 0)
        elseif ig == 15 
            @NLconstraint(model, -Inf <= g15(x...) <= 0)
        elseif ig == 16 
            @NLconstraint(model, -Inf <= g16(x...) <= 0)
        elseif ig == 17 
            @NLconstraint(model, -Inf <= g17(x...) <= 0)
        elseif ig == 18 
            @NLconstraint(model, -Inf <= g18(x...) <= 0)
        elseif ig == 19 
            @NLconstraint(model, -Inf <= g19(x...) <= 0)
        elseif ig == 20 
            @NLconstraint(model, -Inf <= g20(x...) <= 0)
        end
    end
end
