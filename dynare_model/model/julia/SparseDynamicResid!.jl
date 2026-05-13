function SparseDynamicResid!(T::Vector{<: Real}, residual::AbstractVector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(residual) == 31
    @assert length(y) == 93
    @assert length(x) == 1
    @assert length(params) == 20
@inbounds begin
    residual[1] = (y[32]) - (params[14]/params[16]);
    residual[2] = (y[33]) - (params[15]/params[17]-x[1]);
    residual[3] = (y[34]) - ((params[12]^params[11]*y[32]^(1-params[11])+(1-params[12])^params[11]*y[33]^(1-params[11]))^(1/(1-params[11])));
    residual[4] = (y[35]) - ((y[32]^(1-params[11])*params[13]^params[11]+y[33]^(1-params[11])*(1-params[13])^params[11])^(1/(1-params[11])));
    residual[5] = (y[40]) - (y[38]^params[10]*y[39]^(1-params[10]));
    residual[6] = (y[41]) - (y[40]*params[10]/y[38]);
    residual[7] = (y[42]) - (y[40]*(1-params[10])/y[39]);
    residual[8] = (y[38]) - (params[7]*y[43]^params[1]*y[46]^params[2]*(params[9]*y[36])^params[3]);
    residual[9] = (y[39]) - (params[8]*y[44]^params[4]*y[47]^params[5]*(params[9]*y[37])^params[6]);
    residual[10] = (y[43]) - (y[38]*y[41]*params[1]/y[51]);
    residual[11] = (y[44]) - (y[39]*y[42]*params[4]/y[51]);
    residual[12] = (y[46]) - (y[38]*y[41]*params[2]/y[52]);
    residual[13] = (y[47]) - (y[39]*y[42]*params[5]/y[52]);
    residual[14] = (y[36]) - (y[38]*y[41]*params[3]/y[34]);
    residual[15] = (y[37]) - (y[39]*y[42]*params[6]/y[35]);
    residual[16] = (y[53]) - (y[36]*params[12]^params[11]*(y[32]/y[34])^(-params[11]));
    residual[17] = (y[54]) - (y[36]*(1-params[12])^params[11]*(y[33]/y[34])^(-params[11]));
    residual[18] = (y[55]) - (y[37]*params[13]^params[11]*(y[32]/y[35])^(-params[11]));
    residual[19] = (y[56]) - (y[37]*(1-params[13])^params[11]*(y[33]/y[35])^(-params[11]));
    residual[20] = (y[57]) - (y[53]+y[55]);
    residual[21] = (y[58]) - (y[54]+y[56]);
    residual[22] = (y[57]) - (params[16]/params[14]*y[59]);
    residual[23] = (y[58]) - (params[17]/params[15]*y[60]);
    residual[24] = (y[45]) - (y[43]+y[44]);
    residual[25] = (y[48]) - (y[46]+y[47]);
    residual[26] = (y[48]) - (params[20]);
    residual[27] = (y[45]) - ((1-params[19])*y[14]+y[50]);
    residual[28] = (y[80]/y[49]) - (params[18]*(1-params[19]+y[82]));
    residual[29] = (y[49]) - (y[40]-y[50]-y[59]-y[60]);
    residual[30] = (y[61]) - (x[1]*y[58]);
    residual[31] = (y[62]) - (y[58]/(y[57]+y[58]));
end
    return nothing
end

