function SparseStaticG1!(T::Vector{<: Real}, g1_v::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(g1_v) == 55
    @assert length(y) == 20
    @assert length(x) == 1
    @assert length(params) == 23
@inbounds begin
g1_v[1]=1;
g1_v[2]=(-(params[9]^params[8]*get_power_deriv(y[1],1-params[8],1)*get_power_deriv(params[9]^params[8]*y[1]^(1-params[8])+(1-params[9])^params[8]*y[2]^(1-params[8]),1/(1-params[8]),1)));
g1_v[3]=(-(params[10]^params[8]*get_power_deriv(y[1],1-params[8],1)*get_power_deriv(y[1]^(1-params[8])*params[10]^params[8]+y[2]^(1-params[8])*(1-params[10])^params[8],1/(1-params[8]),1)));
g1_v[4]=(-(y[5]*params[9]^params[8]*1/y[3]*get_power_deriv(y[1]/y[3],(-params[8]),1)));
g1_v[5]=(-(y[6]*params[10]^params[8]*1/y[4]*get_power_deriv(y[1]/y[4],(-params[8]),1)));
g1_v[6]=1;
g1_v[7]=(-(get_power_deriv(params[9]^params[8]*y[1]^(1-params[8])+(1-params[9])^params[8]*y[2]^(1-params[8]),1/(1-params[8]),1)*(1-params[9])^params[8]*get_power_deriv(y[2],1-params[8],1)));
g1_v[8]=(-(get_power_deriv(y[1]^(1-params[8])*params[10]^params[8]+y[2]^(1-params[8])*(1-params[10])^params[8],1/(1-params[8]),1)*(1-params[10])^params[8]*get_power_deriv(y[2],1-params[8],1)));
g1_v[9]=(-(y[5]*(1-params[9])^params[8]*1/y[3]*get_power_deriv(y[2]/y[3],(-params[8]),1)));
g1_v[10]=(-(y[6]*(1-params[10])^params[8]*1/y[4]*get_power_deriv(y[2]/y[4],(-params[8]),1)));
g1_v[11]=1;
g1_v[12]=1;
g1_v[13]=(-(y[5]*params[9]^params[8]*get_power_deriv(y[1]/y[3],(-params[8]),1)*(-y[1])/(y[3]*y[3])));
g1_v[14]=(-(y[5]*(1-params[9])^params[8]*get_power_deriv(y[2]/y[3],(-params[8]),1)*(-y[2])/(y[3]*y[3])));
g1_v[15]=1;
g1_v[16]=1;
g1_v[17]=(-(y[6]*params[10]^params[8]*get_power_deriv(y[1]/y[4],(-params[8]),1)*(-y[1])/(y[4]*y[4])));
g1_v[18]=(-(y[6]*(1-params[10])^params[8]*get_power_deriv(y[2]/y[4],(-params[8]),1)*(-y[2])/(y[4]*y[4])));
g1_v[19]=(-(params[5]*params[15]^params[1]*params[17]^params[2]*params[7]*get_power_deriv(params[7]*y[5],params[20],1)));
g1_v[20]=(-((-(y[7]*params[20]))/(y[5]*y[5])));
g1_v[21]=(-(params[9]^params[8]*(y[1]/y[3])^(-params[8])));
g1_v[22]=(-((1-params[9])^params[8]*(y[2]/y[3])^(-params[8])));
g1_v[23]=(-(params[6]*params[16]^params[3]*params[18]^params[4]*params[7]*get_power_deriv(params[7]*y[6],params[21],1)));
g1_v[24]=(-((-(y[8]*params[21]))/(y[6]*y[6])));
g1_v[25]=(-(params[10]^params[8]*(y[1]/y[4])^(-params[8])));
g1_v[26]=(-((1-params[10])^params[8]*(y[2]/y[4])^(-params[8])));
g1_v[27]=1;
g1_v[28]=(-(params[20]/y[5]));
g1_v[29]=(-1);
g1_v[30]=1;
g1_v[31]=(-(params[21]/y[6]));
g1_v[32]=(-1);
g1_v[33]=1;
g1_v[34]=(-1);
g1_v[35]=1;
g1_v[36]=(-1);
g1_v[37]=1;
g1_v[38]=(-1);
g1_v[39]=1;
g1_v[40]=(-1);
g1_v[41]=1;
g1_v[42]=(-(params[11]/params[13]));
g1_v[43]=(-((-y[14])/((y[13]+y[14])*(y[13]+y[14]))));
g1_v[44]=1;
g1_v[45]=(-x[1]);
g1_v[46]=(-(params[12]/params[14]));
g1_v[47]=(-(y[13]/((y[13]+y[14])*(y[13]+y[14]))));
g1_v[48]=1;
g1_v[49]=1;
g1_v[50]=1;
g1_v[51]=(-1);
g1_v[52]=1;
g1_v[53]=(-1);
g1_v[54]=1;
g1_v[55]=1-params[23];
end
    return nothing
end

