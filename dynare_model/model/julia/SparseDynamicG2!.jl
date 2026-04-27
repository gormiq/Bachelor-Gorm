function SparseDynamicG2!(T::Vector{<: Real}, g2_v::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(g2_v) == 36
    @assert length(y) == 60
    @assert length(x) == 1
    @assert length(params) == 23
@inbounds begin
g2_v[1]=(-(get_power_deriv(params[9]^params[8]*y[21]^(1-params[8])+(1-params[9])^params[8]*y[22]^(1-params[8]),1/(1-params[8]),1)*params[9]^params[8]*get_power_deriv(y[21],1-params[8],2)+params[9]^params[8]*get_power_deriv(y[21],1-params[8],1)*params[9]^params[8]*get_power_deriv(y[21],1-params[8],1)*get_power_deriv(params[9]^params[8]*y[21]^(1-params[8])+(1-params[9])^params[8]*y[22]^(1-params[8]),1/(1-params[8]),2)));
g2_v[2]=(-(params[9]^params[8]*get_power_deriv(y[21],1-params[8],1)*(1-params[9])^params[8]*get_power_deriv(y[22],1-params[8],1)*get_power_deriv(params[9]^params[8]*y[21]^(1-params[8])+(1-params[9])^params[8]*y[22]^(1-params[8]),1/(1-params[8]),2)));
g2_v[3]=(-((1-params[9])^params[8]*get_power_deriv(y[22],1-params[8],1)*(1-params[9])^params[8]*get_power_deriv(y[22],1-params[8],1)*get_power_deriv(params[9]^params[8]*y[21]^(1-params[8])+(1-params[9])^params[8]*y[22]^(1-params[8]),1/(1-params[8]),2)+get_power_deriv(params[9]^params[8]*y[21]^(1-params[8])+(1-params[9])^params[8]*y[22]^(1-params[8]),1/(1-params[8]),1)*(1-params[9])^params[8]*get_power_deriv(y[22],1-params[8],2)));
g2_v[4]=(-(get_power_deriv(y[21]^(1-params[8])*params[10]^params[8]+y[22]^(1-params[8])*(1-params[10])^params[8],1/(1-params[8]),1)*params[10]^params[8]*get_power_deriv(y[21],1-params[8],2)+params[10]^params[8]*get_power_deriv(y[21],1-params[8],1)*params[10]^params[8]*get_power_deriv(y[21],1-params[8],1)*get_power_deriv(y[21]^(1-params[8])*params[10]^params[8]+y[22]^(1-params[8])*(1-params[10])^params[8],1/(1-params[8]),2)));
g2_v[5]=(-(params[10]^params[8]*get_power_deriv(y[21],1-params[8],1)*(1-params[10])^params[8]*get_power_deriv(y[22],1-params[8],1)*get_power_deriv(y[21]^(1-params[8])*params[10]^params[8]+y[22]^(1-params[8])*(1-params[10])^params[8],1/(1-params[8]),2)));
g2_v[6]=(-((1-params[10])^params[8]*get_power_deriv(y[22],1-params[8],1)*(1-params[10])^params[8]*get_power_deriv(y[22],1-params[8],1)*get_power_deriv(y[21]^(1-params[8])*params[10]^params[8]+y[22]^(1-params[8])*(1-params[10])^params[8],1/(1-params[8]),2)+get_power_deriv(y[21]^(1-params[8])*params[10]^params[8]+y[22]^(1-params[8])*(1-params[10])^params[8],1/(1-params[8]),1)*(1-params[10])^params[8]*get_power_deriv(y[22],1-params[8],2)));
g2_v[7]=(-(params[5]*params[15]^params[1]*params[17]^params[2]*params[7]*params[7]*get_power_deriv(params[7]*y[25],params[20],2)));
g2_v[8]=(-(params[6]*params[16]^params[3]*params[18]^params[4]*params[7]*params[7]*get_power_deriv(params[7]*y[26],params[21],2)));
g2_v[9]=(-((-((-(y[27]*params[20]))*(y[25]+y[25])))/(y[25]*y[25]*y[25]*y[25])));
g2_v[10]=(-((-params[20])/(y[25]*y[25])));
g2_v[11]=(-((-((-(y[28]*params[21]))*(y[26]+y[26])))/(y[26]*y[26]*y[26]*y[26])));
g2_v[12]=(-((-params[21])/(y[26]*y[26])));
g2_v[13]=(-(y[25]*params[9]^params[8]*1/y[23]*1/y[23]*get_power_deriv(y[21]/y[23],(-params[8]),2)));
g2_v[14]=(-(y[25]*params[9]^params[8]*(get_power_deriv(y[21]/y[23],(-params[8]),1)*(-1)/(y[23]*y[23])+1/y[23]*(-y[21])/(y[23]*y[23])*get_power_deriv(y[21]/y[23],(-params[8]),2))));
g2_v[15]=(-(params[9]^params[8]*1/y[23]*get_power_deriv(y[21]/y[23],(-params[8]),1)));
g2_v[16]=(-(y[25]*params[9]^params[8]*((-y[21])/(y[23]*y[23])*(-y[21])/(y[23]*y[23])*get_power_deriv(y[21]/y[23],(-params[8]),2)+get_power_deriv(y[21]/y[23],(-params[8]),1)*(-((-y[21])*(y[23]+y[23])))/(y[23]*y[23]*y[23]*y[23]))));
g2_v[17]=(-(params[9]^params[8]*get_power_deriv(y[21]/y[23],(-params[8]),1)*(-y[21])/(y[23]*y[23])));
g2_v[18]=(-(y[25]*(1-params[9])^params[8]*1/y[23]*1/y[23]*get_power_deriv(y[22]/y[23],(-params[8]),2)));
g2_v[19]=(-(y[25]*(1-params[9])^params[8]*(get_power_deriv(y[22]/y[23],(-params[8]),1)*(-1)/(y[23]*y[23])+1/y[23]*(-y[22])/(y[23]*y[23])*get_power_deriv(y[22]/y[23],(-params[8]),2))));
g2_v[20]=(-((1-params[9])^params[8]*1/y[23]*get_power_deriv(y[22]/y[23],(-params[8]),1)));
g2_v[21]=(-(y[25]*(1-params[9])^params[8]*((-y[22])/(y[23]*y[23])*(-y[22])/(y[23]*y[23])*get_power_deriv(y[22]/y[23],(-params[8]),2)+get_power_deriv(y[22]/y[23],(-params[8]),1)*(-((-y[22])*(y[23]+y[23])))/(y[23]*y[23]*y[23]*y[23]))));
g2_v[22]=(-((1-params[9])^params[8]*get_power_deriv(y[22]/y[23],(-params[8]),1)*(-y[22])/(y[23]*y[23])));
g2_v[23]=(-(y[26]*params[10]^params[8]*1/y[24]*1/y[24]*get_power_deriv(y[21]/y[24],(-params[8]),2)));
g2_v[24]=(-(y[26]*params[10]^params[8]*(get_power_deriv(y[21]/y[24],(-params[8]),1)*(-1)/(y[24]*y[24])+1/y[24]*(-y[21])/(y[24]*y[24])*get_power_deriv(y[21]/y[24],(-params[8]),2))));
g2_v[25]=(-(params[10]^params[8]*1/y[24]*get_power_deriv(y[21]/y[24],(-params[8]),1)));
g2_v[26]=(-(y[26]*params[10]^params[8]*((-y[21])/(y[24]*y[24])*(-y[21])/(y[24]*y[24])*get_power_deriv(y[21]/y[24],(-params[8]),2)+get_power_deriv(y[21]/y[24],(-params[8]),1)*(-((-y[21])*(y[24]+y[24])))/(y[24]*y[24]*y[24]*y[24]))));
g2_v[27]=(-(params[10]^params[8]*get_power_deriv(y[21]/y[24],(-params[8]),1)*(-y[21])/(y[24]*y[24])));
g2_v[28]=(-(y[26]*(1-params[10])^params[8]*1/y[24]*1/y[24]*get_power_deriv(y[22]/y[24],(-params[8]),2)));
g2_v[29]=(-(y[26]*(1-params[10])^params[8]*(get_power_deriv(y[22]/y[24],(-params[8]),1)*(-1)/(y[24]*y[24])+1/y[24]*(-y[22])/(y[24]*y[24])*get_power_deriv(y[22]/y[24],(-params[8]),2))));
g2_v[30]=(-((1-params[10])^params[8]*1/y[24]*get_power_deriv(y[22]/y[24],(-params[8]),1)));
g2_v[31]=(-(y[26]*(1-params[10])^params[8]*((-y[22])/(y[24]*y[24])*(-y[22])/(y[24]*y[24])*get_power_deriv(y[22]/y[24],(-params[8]),2)+get_power_deriv(y[22]/y[24],(-params[8]),1)*(-((-y[22])*(y[24]+y[24])))/(y[24]*y[24]*y[24]*y[24]))));
g2_v[32]=(-((1-params[10])^params[8]*get_power_deriv(y[22]/y[24],(-params[8]),1)*(-y[22])/(y[24]*y[24])));
g2_v[33]=(-1);
g2_v[34]=(-((-((-y[34])*(y[33]+y[34]+y[33]+y[34])))/((y[33]+y[34])*(y[33]+y[34])*(y[33]+y[34])*(y[33]+y[34]))));
g2_v[35]=(-(((-((y[33]+y[34])*(y[33]+y[34])))-(-y[34])*(y[33]+y[34]+y[33]+y[34]))/((y[33]+y[34])*(y[33]+y[34])*(y[33]+y[34])*(y[33]+y[34]))));
g2_v[36]=(-((-(y[33]*(y[33]+y[34]+y[33]+y[34])))/((y[33]+y[34])*(y[33]+y[34])*(y[33]+y[34])*(y[33]+y[34]))));
end
    return nothing
end

