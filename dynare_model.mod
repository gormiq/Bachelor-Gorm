var Pf Pr PE1 PE2 E1 E2 Y1 Y2 Ef1 Er1 Ef2 Er2 Ef Er Y renewable_share C I T dummy;

varexo s;

parameters alpha1 beta1 alpha2 beta2 A1 A2 chi sigma omega1 omega2 cf cr zf zr K1 K2 L1 L2 Kbar gamma1 gamma2 delta rho_dummy;

alpha1 = 0.30;
beta1  = 0.60;
alpha2 = 0.30;
beta2  = 0.60;

A1 = 1.0;
A2 = 1.0;
chi = 1.0;
sigma = 2.0;

omega1 = 0.7;
omega2 = 0.4;

cf = 1.0;
cr = 1.2;
zf = 1.0;
zr = 1.0;

K1 = 1.0;
K2 = 1.0;
L1 = 1.0;
L2 = 1.0;
Kbar = K1 + K2;

gamma1 = 1 - alpha1 - beta1;
gamma2 = 1 - alpha2 - beta2;

delta = 0.08;
rho_dummy = 0.5;

model;

Pf = cf / zf;
Pr = cr / zr - s;

PE1 = (omega1^sigma * Pf^(1-sigma) + (1-omega1)^sigma * Pr^(1-sigma))^(1/(1-sigma));
PE2 = (omega2^sigma * Pf^(1-sigma) + (1-omega2)^sigma * Pr^(1-sigma))^(1/(1-sigma));

Y1 = A1 * K1^alpha1 * L1^beta1 * (chi * E1)^gamma1;
Y2 = A2 * K2^alpha2 * L2^beta2 * (chi * E2)^gamma2;

PE1 = gamma1 * Y1 / E1;
PE2 = gamma2 * Y2 / E2;

Ef1 = omega1^sigma * (Pf / PE1)^(-sigma) * E1;
Er1 = (1-omega1)^sigma * (Pr / PE1)^(-sigma) * E1;

Ef2 = omega2^sigma * (Pf / PE2)^(-sigma) * E2;
Er2 = (1-omega2)^sigma * (Pr / PE2)^(-sigma) * E2;

Ef = Ef1 + Ef2;
Er = Er1 + Er2;

Y = Y1 + Y2;

T = s * Er;
I = delta * Kbar;

Y = C + I + (cf/zf) * Ef + (cr/zr) * Er;

renewable_share = Er / (Ef + Er);

dummy = rho_dummy * dummy(-1);

end;

initval;

s = 0.0;

Pf = 1.0;
Pr = 1.2;

PE1 = 1.77;
PE2 = 2.17;

E1 = 0.041;
E2 = 0.033;

Y1 = 0.727;
Y2 = 0.710;

Ef1 = 0.063;
Er1 = 0.008;

Ef2 = 0.025;
Er2 = 0.039;

Ef = 0.088;
Er = 0.047;

Y = 1.437;
renewable_share = 0.347;

I = 0.16;
T = 0.0;
C = 1.19;

dummy = 0.0;

end;

steady;