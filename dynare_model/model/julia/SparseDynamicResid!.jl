function SparseDynamicResid!(T::Vector{<: Real}, residual::AbstractVector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(residual) == 32
    @assert length(y) == 96
    @assert length(x) == 1
    @assert length(params) == 21
@inbounds begin
    residual[1] = (y[33]) - (params[14]/params[16]);
    residual[2] = (y[34]) - (params[15]/params[17]-x[1]);
    residual[3] = (y[35]) - ((params[12]^params[11]*y[33]^(1-params[11])+(1-params[12])^params[11]*y[34]^(1-params[11]))^(1/(1-params[11])));
    residual[4] = (y[36]) - ((y[33]^(1-params[11])*params[13]^params[11]+y[34]^(1-params[11])*(1-params[13])^params[11])^(1/(1-params[11])));
    residual[5] = (y[41]) - (y[39]^params[10]*y[40]^(1-params[10]));
    residual[6] = (y[42]) - (y[41]*params[10]/y[39]);
    residual[7] = (y[43]) - (y[41]*(1-params[10])/y[40]);
    residual[8] = (y[39]) - (params[7]*y[44]^params[1]*y[47]^params[2]*(params[9]*y[37])^params[3]);
    residual[9] = (y[40]) - (params[8]*y[45]^params[4]*y[48]^params[5]*(params[9]*y[38])^params[6]);
    residual[10] = (y[44]) - (y[39]*y[42]*params[1]/(y[52]+params[19]));
    residual[11] = (y[45]) - (y[40]*y[43]*params[4]/(y[52]+params[19]));
    residual[12] = (y[47]) - (y[39]*y[42]*params[2]/y[53]);
    residual[13] = (y[48]) - (y[40]*y[43]*params[5]/y[53]);
    residual[14] = (y[37]) - (y[39]*y[42]*params[3]/y[35]);
    residual[15] = (y[38]) - (y[40]*y[43]*params[6]/y[36]);
    residual[16] = (y[54]) - (y[37]*params[12]^params[11]*(y[33]/y[35])^(-params[11]));
    residual[17] = (y[55]) - (y[37]*(1-params[12])^params[11]*(y[34]/y[35])^(-params[11]));
    residual[18] = (y[56]) - (y[38]*params[13]^params[11]*(y[33]/y[36])^(-params[11]));
    residual[19] = (y[57]) - (y[38]*(1-params[13])^params[11]*(y[34]/y[36])^(-params[11]));
    residual[20] = (y[58]) - (y[54]+y[56]);
    residual[21] = (y[59]) - (y[55]+y[57]);
    residual[22] = (y[58]) - (params[16]/params[14]*y[60]);
    residual[23] = (y[59]) - (params[17]/params[15]*y[61]);
    residual[24] = (y[46]) - (y[44]+y[45]);
    residual[25] = (y[49]) - (y[47]+y[48]);
    residual[26] = (y[49]) - (params[20]);
    residual[27] = (y[52]) - (params[19]+1/params[18]-1);
    residual[28] = (y[51]) - (params[19]*y[46]);
    residual[29] = (y[50]) - (y[41]-y[51]-y[60]-y[61]);
    residual[30] = (y[62]) - (x[1]*y[59]);
    residual[31] = (y[63]) - (y[59]/(y[58]+y[59]));
    residual[32] = (y[64]) - (params[21]*y[32]);
end
    return nothing
end

