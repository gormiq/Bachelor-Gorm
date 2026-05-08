function SparseDynamicG2!(T::Vector{<: Real}, g2_v::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(g2_v) == 73
    @assert length(y) == 96
    @assert length(x) == 1
    @assert length(params) == 21
@inbounds begin
g2_v[1]=(-(get_power_deriv(params[12]^params[11]*y[33]^(1-params[11])+(1-params[12])^params[11]*y[34]^(1-params[11]),1/(1-params[11]),1)*params[12]^params[11]*get_power_deriv(y[33],1-params[11],2)+params[12]^params[11]*get_power_deriv(y[33],1-params[11],1)*params[12]^params[11]*get_power_deriv(y[33],1-params[11],1)*get_power_deriv(params[12]^params[11]*y[33]^(1-params[11])+(1-params[12])^params[11]*y[34]^(1-params[11]),1/(1-params[11]),2)));
g2_v[2]=(-(params[12]^params[11]*get_power_deriv(y[33],1-params[11],1)*(1-params[12])^params[11]*get_power_deriv(y[34],1-params[11],1)*get_power_deriv(params[12]^params[11]*y[33]^(1-params[11])+(1-params[12])^params[11]*y[34]^(1-params[11]),1/(1-params[11]),2)));
g2_v[3]=(-((1-params[12])^params[11]*get_power_deriv(y[34],1-params[11],1)*(1-params[12])^params[11]*get_power_deriv(y[34],1-params[11],1)*get_power_deriv(params[12]^params[11]*y[33]^(1-params[11])+(1-params[12])^params[11]*y[34]^(1-params[11]),1/(1-params[11]),2)+get_power_deriv(params[12]^params[11]*y[33]^(1-params[11])+(1-params[12])^params[11]*y[34]^(1-params[11]),1/(1-params[11]),1)*(1-params[12])^params[11]*get_power_deriv(y[34],1-params[11],2)));
g2_v[4]=(-(get_power_deriv(y[33]^(1-params[11])*params[13]^params[11]+y[34]^(1-params[11])*(1-params[13])^params[11],1/(1-params[11]),1)*params[13]^params[11]*get_power_deriv(y[33],1-params[11],2)+params[13]^params[11]*get_power_deriv(y[33],1-params[11],1)*params[13]^params[11]*get_power_deriv(y[33],1-params[11],1)*get_power_deriv(y[33]^(1-params[11])*params[13]^params[11]+y[34]^(1-params[11])*(1-params[13])^params[11],1/(1-params[11]),2)));
g2_v[5]=(-(params[13]^params[11]*get_power_deriv(y[33],1-params[11],1)*(1-params[13])^params[11]*get_power_deriv(y[34],1-params[11],1)*get_power_deriv(y[33]^(1-params[11])*params[13]^params[11]+y[34]^(1-params[11])*(1-params[13])^params[11],1/(1-params[11]),2)));
g2_v[6]=(-((1-params[13])^params[11]*get_power_deriv(y[34],1-params[11],1)*(1-params[13])^params[11]*get_power_deriv(y[34],1-params[11],1)*get_power_deriv(y[33]^(1-params[11])*params[13]^params[11]+y[34]^(1-params[11])*(1-params[13])^params[11],1/(1-params[11]),2)+get_power_deriv(y[33]^(1-params[11])*params[13]^params[11]+y[34]^(1-params[11])*(1-params[13])^params[11],1/(1-params[11]),1)*(1-params[13])^params[11]*get_power_deriv(y[34],1-params[11],2)));
g2_v[7]=(-(y[40]^(1-params[10])*get_power_deriv(y[39],params[10],2)));
g2_v[8]=(-(get_power_deriv(y[39],params[10],1)*get_power_deriv(y[40],1-params[10],1)));
g2_v[9]=(-(y[39]^params[10]*get_power_deriv(y[40],1-params[10],2)));
g2_v[10]=(-((-((-(y[41]*params[10]))*(y[39]+y[39])))/(y[39]*y[39]*y[39]*y[39])));
g2_v[11]=(-((-params[10])/(y[39]*y[39])));
g2_v[12]=(-((-((-(y[41]*(1-params[10])))*(y[40]+y[40])))/(y[40]*y[40]*y[40]*y[40])));
g2_v[13]=(-((-(1-params[10]))/(y[40]*y[40])));
g2_v[14]=(-(params[7]*y[44]^params[1]*y[47]^params[2]*params[9]*params[9]*get_power_deriv(params[9]*y[37],params[3],2)));
g2_v[15]=(-(params[9]*get_power_deriv(params[9]*y[37],params[3],1)*y[47]^params[2]*params[7]*get_power_deriv(y[44],params[1],1)));
g2_v[16]=(-(params[9]*get_power_deriv(params[9]*y[37],params[3],1)*params[7]*y[44]^params[1]*get_power_deriv(y[47],params[2],1)));
g2_v[17]=(-((params[9]*y[37])^params[3]*y[47]^params[2]*params[7]*get_power_deriv(y[44],params[1],2)));
g2_v[18]=(-((params[9]*y[37])^params[3]*params[7]*get_power_deriv(y[44],params[1],1)*get_power_deriv(y[47],params[2],1)));
g2_v[19]=(-((params[9]*y[37])^params[3]*params[7]*y[44]^params[1]*get_power_deriv(y[47],params[2],2)));
g2_v[20]=(-(params[8]*y[45]^params[4]*y[48]^params[5]*params[9]*params[9]*get_power_deriv(params[9]*y[38],params[6],2)));
g2_v[21]=(-(params[9]*get_power_deriv(params[9]*y[38],params[6],1)*y[48]^params[5]*params[8]*get_power_deriv(y[45],params[4],1)));
g2_v[22]=(-(params[9]*get_power_deriv(params[9]*y[38],params[6],1)*params[8]*y[45]^params[4]*get_power_deriv(y[48],params[5],1)));
g2_v[23]=(-((params[9]*y[38])^params[6]*y[48]^params[5]*params[8]*get_power_deriv(y[45],params[4],2)));
g2_v[24]=(-((params[9]*y[38])^params[6]*params[8]*get_power_deriv(y[45],params[4],1)*get_power_deriv(y[48],params[5],1)));
g2_v[25]=(-((params[9]*y[38])^params[6]*params[8]*y[45]^params[4]*get_power_deriv(y[48],params[5],2)));
g2_v[26]=(-(params[1]/(y[52]+params[19])));
g2_v[27]=(-((-(y[42]*params[1]))/((y[52]+params[19])*(y[52]+params[19]))));
g2_v[28]=(-((-(y[39]*params[1]))/((y[52]+params[19])*(y[52]+params[19]))));
g2_v[29]=(-((-((-(y[39]*y[42]*params[1]))*(y[52]+params[19]+y[52]+params[19])))/((y[52]+params[19])*(y[52]+params[19])*(y[52]+params[19])*(y[52]+params[19]))));
g2_v[30]=(-(params[4]/(y[52]+params[19])));
g2_v[31]=(-((-(y[43]*params[4]))/((y[52]+params[19])*(y[52]+params[19]))));
g2_v[32]=(-((-(y[40]*params[4]))/((y[52]+params[19])*(y[52]+params[19]))));
g2_v[33]=(-((-((-(y[40]*y[43]*params[4]))*(y[52]+params[19]+y[52]+params[19])))/((y[52]+params[19])*(y[52]+params[19])*(y[52]+params[19])*(y[52]+params[19]))));
g2_v[34]=(-(params[2]/y[53]));
g2_v[35]=(-((-(y[42]*params[2]))/(y[53]*y[53])));
g2_v[36]=(-((-(y[39]*params[2]))/(y[53]*y[53])));
g2_v[37]=(-((-((-(y[39]*y[42]*params[2]))*(y[53]+y[53])))/(y[53]*y[53]*y[53]*y[53])));
g2_v[38]=(-(params[5]/y[53]));
g2_v[39]=(-((-(y[43]*params[5]))/(y[53]*y[53])));
g2_v[40]=(-((-(y[40]*params[5]))/(y[53]*y[53])));
g2_v[41]=(-((-((-(y[40]*y[43]*params[5]))*(y[53]+y[53])))/(y[53]*y[53]*y[53]*y[53])));
g2_v[42]=(-((-((-(y[39]*y[42]*params[3]))*(y[35]+y[35])))/(y[35]*y[35]*y[35]*y[35])));
g2_v[43]=(-((-(y[42]*params[3]))/(y[35]*y[35])));
g2_v[44]=(-((-(y[39]*params[3]))/(y[35]*y[35])));
g2_v[45]=(-(params[3]/y[35]));
g2_v[46]=(-((-((-(y[40]*y[43]*params[6]))*(y[36]+y[36])))/(y[36]*y[36]*y[36]*y[36])));
g2_v[47]=(-((-(y[43]*params[6]))/(y[36]*y[36])));
g2_v[48]=(-((-(y[40]*params[6]))/(y[36]*y[36])));
g2_v[49]=(-(params[6]/y[36]));
g2_v[50]=(-(y[37]*params[12]^params[11]*1/y[35]*1/y[35]*get_power_deriv(y[33]/y[35],(-params[11]),2)));
g2_v[51]=(-(y[37]*params[12]^params[11]*(get_power_deriv(y[33]/y[35],(-params[11]),1)*(-1)/(y[35]*y[35])+1/y[35]*(-y[33])/(y[35]*y[35])*get_power_deriv(y[33]/y[35],(-params[11]),2))));
g2_v[52]=(-(params[12]^params[11]*1/y[35]*get_power_deriv(y[33]/y[35],(-params[11]),1)));
g2_v[53]=(-(y[37]*params[12]^params[11]*((-y[33])/(y[35]*y[35])*(-y[33])/(y[35]*y[35])*get_power_deriv(y[33]/y[35],(-params[11]),2)+get_power_deriv(y[33]/y[35],(-params[11]),1)*(-((-y[33])*(y[35]+y[35])))/(y[35]*y[35]*y[35]*y[35]))));
g2_v[54]=(-(params[12]^params[11]*get_power_deriv(y[33]/y[35],(-params[11]),1)*(-y[33])/(y[35]*y[35])));
g2_v[55]=(-(y[37]*(1-params[12])^params[11]*1/y[35]*1/y[35]*get_power_deriv(y[34]/y[35],(-params[11]),2)));
g2_v[56]=(-(y[37]*(1-params[12])^params[11]*(get_power_deriv(y[34]/y[35],(-params[11]),1)*(-1)/(y[35]*y[35])+1/y[35]*(-y[34])/(y[35]*y[35])*get_power_deriv(y[34]/y[35],(-params[11]),2))));
g2_v[57]=(-((1-params[12])^params[11]*1/y[35]*get_power_deriv(y[34]/y[35],(-params[11]),1)));
g2_v[58]=(-(y[37]*(1-params[12])^params[11]*((-y[34])/(y[35]*y[35])*(-y[34])/(y[35]*y[35])*get_power_deriv(y[34]/y[35],(-params[11]),2)+get_power_deriv(y[34]/y[35],(-params[11]),1)*(-((-y[34])*(y[35]+y[35])))/(y[35]*y[35]*y[35]*y[35]))));
g2_v[59]=(-((1-params[12])^params[11]*get_power_deriv(y[34]/y[35],(-params[11]),1)*(-y[34])/(y[35]*y[35])));
g2_v[60]=(-(y[38]*params[13]^params[11]*1/y[36]*1/y[36]*get_power_deriv(y[33]/y[36],(-params[11]),2)));
g2_v[61]=(-(y[38]*params[13]^params[11]*(get_power_deriv(y[33]/y[36],(-params[11]),1)*(-1)/(y[36]*y[36])+1/y[36]*(-y[33])/(y[36]*y[36])*get_power_deriv(y[33]/y[36],(-params[11]),2))));
g2_v[62]=(-(params[13]^params[11]*1/y[36]*get_power_deriv(y[33]/y[36],(-params[11]),1)));
g2_v[63]=(-(y[38]*params[13]^params[11]*((-y[33])/(y[36]*y[36])*(-y[33])/(y[36]*y[36])*get_power_deriv(y[33]/y[36],(-params[11]),2)+get_power_deriv(y[33]/y[36],(-params[11]),1)*(-((-y[33])*(y[36]+y[36])))/(y[36]*y[36]*y[36]*y[36]))));
g2_v[64]=(-(params[13]^params[11]*get_power_deriv(y[33]/y[36],(-params[11]),1)*(-y[33])/(y[36]*y[36])));
g2_v[65]=(-(y[38]*(1-params[13])^params[11]*1/y[36]*1/y[36]*get_power_deriv(y[34]/y[36],(-params[11]),2)));
g2_v[66]=(-(y[38]*(1-params[13])^params[11]*(get_power_deriv(y[34]/y[36],(-params[11]),1)*(-1)/(y[36]*y[36])+1/y[36]*(-y[34])/(y[36]*y[36])*get_power_deriv(y[34]/y[36],(-params[11]),2))));
g2_v[67]=(-((1-params[13])^params[11]*1/y[36]*get_power_deriv(y[34]/y[36],(-params[11]),1)));
g2_v[68]=(-(y[38]*(1-params[13])^params[11]*((-y[34])/(y[36]*y[36])*(-y[34])/(y[36]*y[36])*get_power_deriv(y[34]/y[36],(-params[11]),2)+get_power_deriv(y[34]/y[36],(-params[11]),1)*(-((-y[34])*(y[36]+y[36])))/(y[36]*y[36]*y[36]*y[36]))));
g2_v[69]=(-((1-params[13])^params[11]*get_power_deriv(y[34]/y[36],(-params[11]),1)*(-y[34])/(y[36]*y[36])));
g2_v[70]=(-1);
g2_v[71]=(-((-((-y[59])*(y[58]+y[59]+y[58]+y[59])))/((y[58]+y[59])*(y[58]+y[59])*(y[58]+y[59])*(y[58]+y[59]))));
g2_v[72]=(-(((-((y[58]+y[59])*(y[58]+y[59])))-(-y[59])*(y[58]+y[59]+y[58]+y[59]))/((y[58]+y[59])*(y[58]+y[59])*(y[58]+y[59])*(y[58]+y[59]))));
g2_v[73]=(-((-(y[58]*(y[58]+y[59]+y[58]+y[59])))/((y[58]+y[59])*(y[58]+y[59])*(y[58]+y[59])*(y[58]+y[59]))));
end
    return nothing
end

