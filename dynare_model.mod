//=================================================================
// Neoclassical general equilibrium model
// with renewable energy subsidies
//=================================================================

//=================================================================
// 1. Endogenous variables
//=================================================================

var
    Pf              (long_name='Fossil energy price')
    Pr              (long_name='Renewable energy price')
    PE1             (long_name='Energy price index sector 1')
    PE2             (long_name='Energy price index sector 2')
    E1              (long_name='Energy services sector 1')
    E2              (long_name='Energy services sector 2')
    Y1              (long_name='Output sector 1')
    Y2              (long_name='Output sector 2')
    Y               (long_name='Aggregate final output')
    P1              (long_name='Price of intermediate good 1')
    P2              (long_name='Price of intermediate good 2')
    K1              (long_name='Capital sector 1')
    K2              (long_name='Capital sector 2')
    K               (long_name='Aggregate capital')
    L1              (long_name='Labor sector 1')
    L2              (long_name='Labor sector 2')
    L               (long_name='Aggregate labor')
    C               (long_name='Household consumption')
    I               (long_name='Investment')
    r               (long_name='Return on capital')
    w               (long_name='Wage')
    Ef1             (long_name='Fossil energy demand sector 1')
    Er1             (long_name='Renewable energy demand sector 1')
    Ef2             (long_name='Fossil energy demand sector 2')
    Er2             (long_name='Renewable energy demand sector 2')
    Ef              (long_name='Aggregate fossil energy')
    Er              (long_name='Aggregate renewable energy')
    Mf              (long_name='Final goods used in fossil energy production')
    Mr              (long_name='Final goods used in renewable energy production')
    T               (long_name='Lump-sum tax')
    renewable_share (long_name='Renewable energy share')
;

//=================================================================
// 2. Exogenous policy variable
//=================================================================

varexo s;

//=================================================================
// 3. Parameters
//=================================================================

parameters
    alpha1
    beta1
    gamma1
    alpha2
    beta2
    gamma2
    A1
    A2
    chi
    theta
    sigma
    omega1
    omega2
    cf
    cr
    zf
    zr
    beta
    delta
    Lbar
;

//=================================================================
// 4. Calibration
//=================================================================

alpha1 = 0.33;
beta1  = 0.62;
gamma1 = 1 - alpha1 - beta1;

alpha2 = 0.33;
beta2  = 0.62;
gamma2 = 1 - alpha2 - beta2;

A1  = 1.0;
A2  = 1.0;
chi = 1.0;

theta = 0.50;

sigma  = 2.0;
omega1 = 0.70;
omega2 = 0.40;

cf = 1.0;
cr = 1.05;
zf = 1.0;
zr = 1.0;

beta  = 0.96;
delta = 0.08;
Lbar  = 1.0;

//=================================================================
// 5. Model equations
//=================================================================

model;

//---------------------------------------------------------------
// Energy prices
//---------------------------------------------------------------

Pf = cf / zf;

Pr = cr / zr - s;

//---------------------------------------------------------------
// Sector-specific energy price indices
//---------------------------------------------------------------

PE1 = ( omega1^sigma * Pf^(1-sigma) + (1-omega1)^sigma * Pr^(1-sigma) )^(1/(1-sigma));

PE2 = ( omega2^sigma * Pf^(1-sigma) + (1-omega2)^sigma * Pr^(1-sigma) )^(1/(1-sigma));

//---------------------------------------------------------------
// Final-good producer
//---------------------------------------------------------------

Y = Y1^theta * Y2^(1-theta);

P1 = theta * Y / Y1;

P2 = (1-theta) * Y / Y2;

//---------------------------------------------------------------
// Intermediate goods production
//---------------------------------------------------------------

Y1 = A1 * K1^alpha1 * L1^beta1 * (chi * E1)^gamma1;

Y2 = A2 * K2^alpha2 * L2^beta2 * (chi * E2)^gamma2;

//---------------------------------------------------------------
// Capital FOC
//---------------------------------------------------------------

K1 = P1 * alpha1 * Y1 / r;
K2 = P2 * alpha2 * Y2 / r;

//---------------------------------------------------------------
// Labor FOC
//---------------------------------------------------------------

L1 = P1 * beta1 * Y1 / w;
L2 = P2 * beta2 * Y2 / w;

//---------------------------------------------------------------
// Energy FOC
//---------------------------------------------------------------

E1 = P1 * gamma1 * Y1 / PE1;
E2 = P2 * gamma2 * Y2 / PE2;

//---------------------------------------------------------------
// Conditional energy demands
//---------------------------------------------------------------

Ef1 = omega1^sigma * (Pf/PE1)^(-sigma) * E1;
Er1 = (1-omega1)^sigma * (Pr/PE1)^(-sigma) * E1;

Ef2 = omega2^sigma * (Pf/PE2)^(-sigma) * E2;
Er2 = (1-omega2)^sigma * (Pr/PE2)^(-sigma) * E2;

//---------------------------------------------------------------
// Energy market clearing
//---------------------------------------------------------------

Ef = Ef1 + Ef2;
Er = Er1 + Er2;

//---------------------------------------------------------------
// Energy production
//---------------------------------------------------------------

Ef = (zf/cf) * Mf;
Er = (zr/cr) * Mr;

//---------------------------------------------------------------
// Factor market clearing
//---------------------------------------------------------------

K = K1 + K2;
L = L1 + L2;
L = Lbar;

//---------------------------------------------------------------
// DYNAMICZNE: Law of motion for capital
//---------------------------------------------------------------

K = (1-delta) * K(-1) + I;

//---------------------------------------------------------------
// DYNAMICZNE: Euler equation
//---------------------------------------------------------------

C(+1) / C = beta * (1 - delta + r(+1));

//---------------------------------------------------------------
// Resource constraint
//---------------------------------------------------------------

C = Y - I - Mf - Mr;

//---------------------------------------------------------------
// Government budget
//---------------------------------------------------------------

T = s * Er;

//---------------------------------------------------------------
// Renewable share
//---------------------------------------------------------------

renewable_share = Er / (Ef + Er);

end;

//=================================================================
// 6. Initial values — baseline SS (s = 0)
//=================================================================

initval;

    s = 0.0;

    Pf = 1.0000000;
    Pr = 1.0500000;

    PE1 = 1.7369727;
    PE2 = 1.9886364;

    E1 = 0.0059791;
    E2 = 0.0052224;

    Y1 = 0.4168285;
    Y2 = 0.4140180;
    Y  = 0.4154209;

    P1 = 0.4983115;
    P2 = 0.5016942;

    K1 = 0.5633790;
    K2 = 0.5633790;
    K  = 1.1267580;

    L1 = 0.5000000;
    L2 = 0.5000000;
    L  = 1.0000000;

    C  = 0.3045092;
    I  = 0.0901406;

    r  = 0.1216667;
    w  = 0.2575610;

    Ef1 = 0.0088393;
    Er1 = 0.0014726;

    Ef2 = 0.0033045;
    Er2 = 0.0067438;

    Ef = 0.0121438;
    Er = 0.0082164;

    Mf = 0.0121438;
    Mr = 0.0086273;

    T  = 0.0000000;

    renewable_share = 0.4035539;

end;

steady;

//=================================================================
// 7. Terminal values — docelowy SS (s = 0.20)
//=================================================================

endval;

    s = 0.20;

    Pf = 1.0000000;
    Pr = 0.8500000;   // cr/zr - s = 1.05 - 0.20

    PE1 = 1.7369727;
    PE2 = 1.9886364;

    E1 = 0.0059791;
    E2 = 0.0052224;

    Y1 = 0.4168285;
    Y2 = 0.4140180;
    Y  = 0.4154209;

    P1 = 0.4983115;
    P2 = 0.5016942;

    K1 = 0.5633790;
    K2 = 0.5633790;
    K  = 1.1267580;

    L1 = 0.5000000;
    L2 = 0.5000000;
    L  = 1.0000000;

    C  = 0.3045092;
    I  = 0.0901406;

    r  = 0.1216667;
    w  = 0.2575610;

    Ef1 = 0.0088393;
    Er1 = 0.0014726;

    Ef2 = 0.0033045;
    Er2 = 0.0067438;

    Ef = 0.0121438;
    Er = 0.0082164;

    Mf = 0.0121438;
    Mr = 0.0086273;

    T  = 0.0000000;

    renewable_share = 0.4035539;

end;

steady;

//=================================================================
// 8. Perfect foresight simulation
//=================================================================

perfect_foresight_setup(periods=200);
perfect_foresight_solver;

rplot C;
rplot K;
rplot r;
rplot renewable_share;
rplot Ef Er;