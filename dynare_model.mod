var y;
varexo e;

parameters rho;

rho = 0.9;

model;
y = rho*y(-1) + e;
end;

initval;
y = 0;
e = 0;
end;

shocks;
var e; stderr 0.01;
end;

steady;
check;
stoch_simul(order=1, irf=20);