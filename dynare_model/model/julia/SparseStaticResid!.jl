function SparseStaticResid!(T::Vector{<: Real}, residual::AbstractVector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(residual) == 32
    @assert length(y) == 32
    @assert length(x) == 1
    @assert length(params) == 21
@inbounds begin
    residual[1] = (y[1]) - (params[14]/params[16]);
    residual[2] = (y[2]) - (params[15]/params[17]-x[1]);
    residual[3] = (y[3]) - ((params[12]^params[11]*y[1]^(1-params[11])+(1-params[12])^params[11]*y[2]^(1-params[11]))^(1/(1-params[11])));
    residual[4] = (y[4]) - ((y[1]^(1-params[11])*params[13]^params[11]+y[2]^(1-params[11])*(1-params[13])^params[11])^(1/(1-params[11])));
    residual[5] = (y[9]) - (y[7]^params[10]*y[8]^(1-params[10]));
    residual[6] = (y[10]) - (y[9]*params[10]/y[7]);
    residual[7] = (y[11]) - (y[9]*(1-params[10])/y[8]);
    residual[8] = (y[7]) - (params[7]*y[12]^params[1]*y[15]^params[2]*(params[9]*y[5])^params[3]);
    residual[9] = (y[8]) - (params[8]*y[13]^params[4]*y[16]^params[5]*(params[9]*y[6])^params[6]);
    residual[10] = (y[12]) - (y[7]*y[10]*params[1]/(y[20]+params[19]));
    residual[11] = (y[13]) - (y[8]*y[11]*params[4]/(y[20]+params[19]));
    residual[12] = (y[15]) - (y[7]*y[10]*params[2]/y[21]);
    residual[13] = (y[16]) - (y[8]*y[11]*params[5]/y[21]);
    residual[14] = (y[5]) - (y[7]*y[10]*params[3]/y[3]);
    residual[15] = (y[6]) - (y[8]*y[11]*params[6]/y[4]);
    residual[16] = (y[22]) - (y[5]*params[12]^params[11]*(y[1]/y[3])^(-params[11]));
    residual[17] = (y[23]) - (y[5]*(1-params[12])^params[11]*(y[2]/y[3])^(-params[11]));
    residual[18] = (y[24]) - (y[6]*params[13]^params[11]*(y[1]/y[4])^(-params[11]));
    residual[19] = (y[25]) - (y[6]*(1-params[13])^params[11]*(y[2]/y[4])^(-params[11]));
    residual[20] = (y[26]) - (y[22]+y[24]);
    residual[21] = (y[27]) - (y[23]+y[25]);
    residual[22] = (y[26]) - (params[16]/params[14]*y[28]);
    residual[23] = (y[27]) - (params[17]/params[15]*y[29]);
    residual[24] = (y[14]) - (y[12]+y[13]);
    residual[25] = (y[17]) - (y[15]+y[16]);
    residual[26] = (y[17]) - (params[20]);
    residual[27] = (y[20]) - (params[19]+1/params[18]-1);
    residual[28] = (y[19]) - (params[19]*y[14]);
    residual[29] = (y[18]) - (y[9]-y[19]-y[28]-y[29]);
    residual[30] = (y[30]) - (x[1]*y[27]);
    residual[31] = (y[31]) - (y[27]/(y[26]+y[27]));
    residual[32] = (y[32]) - (y[32]*params[21]);
end
    return nothing
end

