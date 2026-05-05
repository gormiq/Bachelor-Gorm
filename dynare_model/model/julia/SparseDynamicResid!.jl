function SparseDynamicResid!(T::Vector{<: Real}, residual::AbstractVector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(residual) == 20
    @assert length(y) == 60
    @assert length(x) == 1
    @assert length(params) == 23
@inbounds begin
    residual[1] = (y[21]) - (params[13]/params[15]);
    residual[2] = (y[22]) - (params[14]/params[16]-x[1]);
    residual[3] = (y[23]) - ((params[11]^params[10]*y[21]^(1-params[10])+(1-params[11])^params[10]*y[22]^(1-params[10]))^(1/(1-params[10])));
    residual[4] = (y[24]) - ((y[21]^(1-params[10])*params[12]^params[10]+y[22]^(1-params[10])*(1-params[12])^params[10])^(1/(1-params[10])));
    residual[5] = (y[27]) - (params[7]*params[17]^params[1]*params[19]^params[2]*(params[9]*y[25])^params[3]);
    residual[6] = (y[28]) - (params[8]*params[18]^params[4]*params[20]^params[5]*(params[9]*y[26])^params[6]);
    residual[7] = (y[23]) - (y[27]*params[3]/y[25]);
    residual[8] = (y[24]) - (y[28]*params[6]/y[26]);
    residual[9] = (y[29]) - (y[25]*params[11]^params[10]*(y[21]/y[23])^(-params[10]));
    residual[10] = (y[30]) - (y[25]*(1-params[11])^params[10]*(y[22]/y[23])^(-params[10]));
    residual[11] = (y[31]) - (y[26]*params[12]^params[10]*(y[21]/y[24])^(-params[10]));
    residual[12] = (y[32]) - (y[26]*(1-params[12])^params[10]*(y[22]/y[24])^(-params[10]));
    residual[13] = (y[33]) - (y[29]+y[31]);
    residual[14] = (y[34]) - (y[30]+y[32]);
    residual[15] = (y[35]) - (y[27]+y[28]);
    residual[16] = (y[38]) - (x[1]*y[34]);
    residual[17] = (y[37]) - (params[22]*params[21]);
    residual[18] = (y[35]) - (y[37]+y[36]+params[13]/params[15]*y[33]+params[14]/params[16]*y[34]);
    residual[19] = (y[39]) - (y[34]/(y[33]+y[34]));
    residual[20] = (y[40]) - (params[23]*y[20]);
end
    return nothing
end

