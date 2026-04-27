function SparseDynamicG1!(T::Vector{<: Real}, g1_v::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(g1_v) == 58
    @assert length(y) == 60
    @assert length(x) == 1
    @assert length(params) == 23
@inbounds begin
g1_v[1]=(-params[23]);
g1_v[2]=1;
g1_v[3]=(-(params[9]^params[8]*get_power_deriv(y[21],1-params[8],1)*get_power_deriv(params[9]^params[8]*y[21]^(1-params[8])+(1-params[9])^params[8]*y[22]^(1-params[8]),1/(1-params[8]),1)));
g1_v[4]=(-(params[10]^params[8]*get_power_deriv(y[21],1-params[8],1)*get_power_deriv(y[21]^(1-params[8])*params[10]^params[8]+y[22]^(1-params[8])*(1-params[10])^params[8],1/(1-params[8]),1)));
g1_v[5]=(-(y[25]*params[9]^params[8]*1/y[23]*get_power_deriv(y[21]/y[23],(-params[8]),1)));
g1_v[6]=(-(y[26]*params[10]^params[8]*1/y[24]*get_power_deriv(y[21]/y[24],(-params[8]),1)));
g1_v[7]=1;
g1_v[8]=(-(get_power_deriv(params[9]^params[8]*y[21]^(1-params[8])+(1-params[9])^params[8]*y[22]^(1-params[8]),1/(1-params[8]),1)*(1-params[9])^params[8]*get_power_deriv(y[22],1-params[8],1)));
g1_v[9]=(-(get_power_deriv(y[21]^(1-params[8])*params[10]^params[8]+y[22]^(1-params[8])*(1-params[10])^params[8],1/(1-params[8]),1)*(1-params[10])^params[8]*get_power_deriv(y[22],1-params[8],1)));
g1_v[10]=(-(y[25]*(1-params[9])^params[8]*1/y[23]*get_power_deriv(y[22]/y[23],(-params[8]),1)));
g1_v[11]=(-(y[26]*(1-params[10])^params[8]*1/y[24]*get_power_deriv(y[22]/y[24],(-params[8]),1)));
g1_v[12]=1;
g1_v[13]=1;
g1_v[14]=(-(y[25]*params[9]^params[8]*get_power_deriv(y[21]/y[23],(-params[8]),1)*(-y[21])/(y[23]*y[23])));
g1_v[15]=(-(y[25]*(1-params[9])^params[8]*get_power_deriv(y[22]/y[23],(-params[8]),1)*(-y[22])/(y[23]*y[23])));
g1_v[16]=1;
g1_v[17]=1;
g1_v[18]=(-(y[26]*params[10]^params[8]*get_power_deriv(y[21]/y[24],(-params[8]),1)*(-y[21])/(y[24]*y[24])));
g1_v[19]=(-(y[26]*(1-params[10])^params[8]*get_power_deriv(y[22]/y[24],(-params[8]),1)*(-y[22])/(y[24]*y[24])));
g1_v[20]=(-(params[5]*params[15]^params[1]*params[17]^params[2]*params[7]*get_power_deriv(params[7]*y[25],params[20],1)));
g1_v[21]=(-((-(y[27]*params[20]))/(y[25]*y[25])));
g1_v[22]=(-(params[9]^params[8]*(y[21]/y[23])^(-params[8])));
g1_v[23]=(-((1-params[9])^params[8]*(y[22]/y[23])^(-params[8])));
g1_v[24]=(-(params[6]*params[16]^params[3]*params[18]^params[4]*params[7]*get_power_deriv(params[7]*y[26],params[21],1)));
g1_v[25]=(-((-(y[28]*params[21]))/(y[26]*y[26])));
g1_v[26]=(-(params[10]^params[8]*(y[21]/y[24])^(-params[8])));
g1_v[27]=(-((1-params[10])^params[8]*(y[22]/y[24])^(-params[8])));
g1_v[28]=1;
g1_v[29]=(-(params[20]/y[25]));
g1_v[30]=(-1);
g1_v[31]=1;
g1_v[32]=(-(params[21]/y[26]));
g1_v[33]=(-1);
g1_v[34]=1;
g1_v[35]=(-1);
g1_v[36]=1;
g1_v[37]=(-1);
g1_v[38]=1;
g1_v[39]=(-1);
g1_v[40]=1;
g1_v[41]=(-1);
g1_v[42]=1;
g1_v[43]=(-(params[11]/params[13]));
g1_v[44]=(-((-y[34])/((y[33]+y[34])*(y[33]+y[34]))));
g1_v[45]=1;
g1_v[46]=(-x[1]);
g1_v[47]=(-(params[12]/params[14]));
g1_v[48]=(-(y[33]/((y[33]+y[34])*(y[33]+y[34]))));
g1_v[49]=1;
g1_v[50]=1;
g1_v[51]=1;
g1_v[52]=(-1);
g1_v[53]=1;
g1_v[54]=(-1);
g1_v[55]=1;
g1_v[56]=1;
g1_v[57]=1;
g1_v[58]=(-y[34]);
end
    return nothing
end

