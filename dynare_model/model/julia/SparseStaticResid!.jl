function SparseStaticResid!(T::Vector{<: Real}, residual::AbstractVector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(residual) == 20
    @assert length(y) == 20
    @assert length(x) == 1
    @assert length(params) == 23
@inbounds begin
    residual[1] = (y[1]) - (params[11]/params[13]);
    residual[2] = (y[2]) - (params[12]/params[14]-x[1]);
    residual[3] = (y[3]) - ((params[9]^params[8]*y[1]^(1-params[8])+(1-params[9])^params[8]*y[2]^(1-params[8]))^(1/(1-params[8])));
    residual[4] = (y[4]) - ((y[1]^(1-params[8])*params[10]^params[8]+y[2]^(1-params[8])*(1-params[10])^params[8])^(1/(1-params[8])));
    residual[5] = (y[7]) - (params[5]*params[15]^params[1]*params[17]^params[2]*(params[7]*y[5])^params[20]);
    residual[6] = (y[8]) - (params[6]*params[16]^params[3]*params[18]^params[4]*(params[7]*y[6])^params[21]);
    residual[7] = (y[3]) - (y[7]*params[20]/y[5]);
    residual[8] = (y[4]) - (y[8]*params[21]/y[6]);
    residual[9] = (y[9]) - (y[5]*params[9]^params[8]*(y[1]/y[3])^(-params[8]));
    residual[10] = (y[10]) - (y[5]*(1-params[9])^params[8]*(y[2]/y[3])^(-params[8]));
    residual[11] = (y[11]) - (y[6]*params[10]^params[8]*(y[1]/y[4])^(-params[8]));
    residual[12] = (y[12]) - (y[6]*(1-params[10])^params[8]*(y[2]/y[4])^(-params[8]));
    residual[13] = (y[13]) - (y[9]+y[11]);
    residual[14] = (y[14]) - (y[10]+y[12]);
    residual[15] = (y[15]) - (y[7]+y[8]);
    residual[16] = (y[19]) - (x[1]*y[14]);
    residual[17] = (y[18]) - (params[22]*params[19]);
    residual[18] = (y[15]) - (y[18]+y[17]+params[11]/params[13]*y[13]+params[12]/params[14]*y[14]);
    residual[19] = (y[16]) - (y[14]/(y[13]+y[14]));
    residual[20] = (y[20]) - (y[20]*params[23]);
end
    return nothing
end

