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
        elseif ig == 21 
            @NLconstraint(model, -Inf <= g21(x...) <= 0)
        elseif ig == 22 
            @NLconstraint(model, -Inf <= g22(x...) <= 0)
        elseif ig == 23 
            @NLconstraint(model, -Inf <= g23(x...) <= 0)
        elseif ig == 24 
            @NLconstraint(model, -Inf <= g24(x...) <= 0)
        elseif ig == 25 
            @NLconstraint(model, -Inf <= g25(x...) <= 0)
        elseif ig == 26 
            @NLconstraint(model, -Inf <= g26(x...) <= 0)
        elseif ig == 27 
            @NLconstraint(model, -Inf <= g27(x...) <= 0)
        elseif ig == 28 
            @NLconstraint(model, -Inf <= g28(x...) <= 0)
        elseif ig == 29 
            @NLconstraint(model, -Inf <= g29(x...) <= 0)
        elseif ig == 30 
            @NLconstraint(model, -Inf <= g30(x...) <= 0)
        elseif ig == 31 
            @NLconstraint(model, -Inf <= g31(x...) <= 0)
        elseif ig == 32 
            @NLconstraint(model, -Inf <= g32(x...) <= 0)
        elseif ig == 33 
            @NLconstraint(model, -Inf <= g33(x...) <= 0)
        elseif ig == 34 
            @NLconstraint(model, -Inf <= g34(x...) <= 0)
        elseif ig == 35 
            @NLconstraint(model, -Inf <= g35(x...) <= 0)
        elseif ig == 36 
            @NLconstraint(model, -Inf <= g36(x...) <= 0)
        elseif ig == 37 
            @NLconstraint(model, -Inf <= g37(x...) <= 0)
        elseif ig == 38 
            @NLconstraint(model, -Inf <= g38(x...) <= 0)
        elseif ig == 39 
            @NLconstraint(model, -Inf <= g39(x...) <= 0)
        elseif ig == 40 
            @NLconstraint(model, -Inf <= g40(x...) <= 0)
        elseif ig == 41 
            @NLconstraint(model, -Inf <= g41(x...) <= 0)
        elseif ig == 42 
            @NLconstraint(model, -Inf <= g42(x...) <= 0)
        elseif ig == 43 
            @NLconstraint(model, -Inf <= g43(x...) <= 0)
        elseif ig == 44 
            @NLconstraint(model, -Inf <= g44(x...) <= 0)
        elseif ig == 45 
            @NLconstraint(model, -Inf <= g45(x...) <= 0)
        elseif ig == 46 
            @NLconstraint(model, -Inf <= g46(x...) <= 0)
        elseif ig == 47 
            @NLconstraint(model, -Inf <= g47(x...) <= 0)
        elseif ig == 48 
            @NLconstraint(model, -Inf <= g48(x...) <= 0)
        elseif ig == 49 
            @NLconstraint(model, -Inf <= g49(x...) <= 0)
        elseif ig == 50 
            @NLconstraint(model, -Inf <= g50(x...) <= 0)
        elseif ig == 51 
            @NLconstraint(model, -Inf <= g51(x...) <= 0)
        elseif ig == 52 
            @NLconstraint(model, -Inf <= g52(x...) <= 0)
        elseif ig == 53 
            @NLconstraint(model, -Inf <= g53(x...) <= 0)
        elseif ig == 54 
            @NLconstraint(model, -Inf <= g54(x...) <= 0)
        elseif ig == 55 
            @NLconstraint(model, -Inf <= g55(x...) <= 0)
        elseif ig == 56 
            @NLconstraint(model, -Inf <= g56(x...) <= 0)
        elseif ig == 57 
            @NLconstraint(model, -Inf <= g57(x...) <= 0)
        elseif ig == 58 
            @NLconstraint(model, -Inf <= g58(x...) <= 0)
        elseif ig == 59 
            @NLconstraint(model, -Inf <= g59(x...) <= 0)
        elseif ig == 60 
            @NLconstraint(model, -Inf <= g60(x...) <= 0)
        elseif ig == 61 
            @NLconstraint(model, -Inf <= g61(x...) <= 0)
        elseif ig == 62 
            @NLconstraint(model, -Inf <= g62(x...) <= 0)
        elseif ig == 63 
            @NLconstraint(model, -Inf <= g63(x...) <= 0)
        elseif ig == 64 
            @NLconstraint(model, -Inf <= g64(x...) <= 0)
        elseif ig == 65 
            @NLconstraint(model, -Inf <= g65(x...) <= 0)
        elseif ig == 66 
            @NLconstraint(model, -Inf <= g66(x...) <= 0)
        elseif ig == 67 
            @NLconstraint(model, -Inf <= g67(x...) <= 0)
        elseif ig == 68 
            @NLconstraint(model, -Inf <= g68(x...) <= 0)
        elseif ig == 69 
            @NLconstraint(model, -Inf <= g69(x...) <= 0)
        elseif ig == 70 
            @NLconstraint(model, -Inf <= g70(x...) <= 0)
        elseif ig == 71 
            @NLconstraint(model, -Inf <= g71(x...) <= 0)
        elseif ig == 72 
            @NLconstraint(model, -Inf <= g72(x...) <= 0)
        elseif ig == 73 
            @NLconstraint(model, -Inf <= g73(x...) <= 0)
        elseif ig == 74 
            @NLconstraint(model, -Inf <= g74(x...) <= 0)
        elseif ig == 75 
            @NLconstraint(model, -Inf <= g75(x...) <= 0)
        elseif ig == 76 
            @NLconstraint(model, -Inf <= g76(x...) <= 0)
        elseif ig == 77 
            @NLconstraint(model, -Inf <= g77(x...) <= 0)
        elseif ig == 78 
            @NLconstraint(model, -Inf <= g78(x...) <= 0)
        elseif ig == 79 
            @NLconstraint(model, -Inf <= g79(x...) <= 0)
        elseif ig == 80 
            @NLconstraint(model, -Inf <= g80(x...) <= 0)
        elseif ig == 81 
            @NLconstraint(model, -Inf <= g81(x...) <= 0)
        elseif ig == 82 
            @NLconstraint(model, -Inf <= g82(x...) <= 0)
        elseif ig == 83 
            @NLconstraint(model, -Inf <= g83(x...) <= 0)
        elseif ig == 84 
            @NLconstraint(model, -Inf <= g84(x...) <= 0)
        elseif ig == 85 
            @NLconstraint(model, -Inf <= g85(x...) <= 0)
        elseif ig == 86 
            @NLconstraint(model, -Inf <= g86(x...) <= 0)
        elseif ig == 87 
            @NLconstraint(model, -Inf <= g87(x...) <= 0)
        elseif ig == 88 
            @NLconstraint(model, -Inf <= g88(x...) <= 0)
        elseif ig == 89 
            @NLconstraint(model, -Inf <= g89(x...) <= 0)
        elseif ig == 90 
            @NLconstraint(model, -Inf <= g90(x...) <= 0)
        elseif ig == 91 
            @NLconstraint(model, -Inf <= g91(x...) <= 0)
        elseif ig == 92 
            @NLconstraint(model, -Inf <= g92(x...) <= 0)
        elseif ig == 93 
            @NLconstraint(model, -Inf <= g93(x...) <= 0)
        elseif ig == 94 
            @NLconstraint(model, -Inf <= g94(x...) <= 0)
        elseif ig == 95 
            @NLconstraint(model, -Inf <= g95(x...) <= 0)
        elseif ig == 96 
            @NLconstraint(model, -Inf <= g96(x...) <= 0)
        elseif ig == 97 
            @NLconstraint(model, -Inf <= g97(x...) <= 0)
        elseif ig == 98 
            @NLconstraint(model, -Inf <= g98(x...) <= 0)
        elseif ig == 99 
            @NLconstraint(model, -Inf <= g99(x...) <= 0)
        elseif ig == 100 
            @NLconstraint(model, -Inf <= g100(x...) <= 0)
        end
    end
end
