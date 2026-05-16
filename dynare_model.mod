//=================================================================
// Neoclassical two-sector general equilibrium model
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

varexo s   (long_name='Renewable energy subsidy');

//=================================================================
// 3. Parameters
//=================================================================

parameters
    alpha1     (long_name='Capital share sector 1')
    beta1      (long_name='Labor share sector 1')
    gamma1     (long_name='Energy share sector 1')
    alpha2     (long_name='Capital share sector 2')
    beta2      (long_name='Labor share sector 2')
    gamma2     (long_name='Energy share sector 2')
    A1         (long_name='TFP sector 1')
    A2         (long_name='TFP sector 2')
    chi        (long_name='Energy efficiency')
    eta        (long_name='CES final-good weight (sector 1)')
    rho        (long_name='Elasticity of substitution between sectors')
    sigma      (long_name='Elasticity of substitution fossil/renewable')
    omega1     (long_name='Fossil weight in sector 1 energy mix')
    omega2     (long_name='Fossil weight in sector 2 energy mix')
    cf         (long_name='Unit cost of fossil energy')
    cr         (long_name='Unit cost of renewable energy')
    zf         (long_name='Productivity in fossil energy production')
    zr         (long_name='Productivity in renewable energy production')
    beta_disc  (long_name='Household discount factor')
    delta      (long_name='Capital depreciation rate')
    Lbar       (long_name='Aggregate labor endowment')
    phiK       (long_name='Capital adjustment cost parameter')
    phiL       (long_name='Labor adjustment cost parameter')
;

//=================================================================
// 4. Calibration
//=================================================================

// Sectoral production - symmetric neoclassical shares
alpha1 = 0.33;
beta1  = 0.62;
gamma1 = 1 - alpha1 - beta1;

alpha2 = 0.33;
beta2  = 0.62;
gamma2 = 1 - alpha2 - beta2;

A1  = 1.0;
A2  = 1.0;
chi = 1.0;

// CES final good - symmetric weight, gross substitutes
eta = 0.50;
rho = 5.0;

// CES energy aggregator - strong asymmetry across sectors
// Sector 1 = fossil-heavy, Sector 2 = renewable-heavy
sigma  = 2.0;
omega1 = 0.85;
omega2 = 0.15;

// Energy production
cf = 1.0;
cr = 1.05;
zf = 1.0;
zr = 1.0;

// Household and capital accumulation
beta_disc = 0.96;
delta     = 0.08;
Lbar      = 1.0;

// Intersectoral adjustment costs
phiK = 0.5;
phiL = 0.2;

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
// Sector-specific CES energy price indices
//---------------------------------------------------------------

PE1 = ( omega1^sigma * Pf^(1-sigma) + (1-omega1)^sigma * Pr^(1-sigma) )^(1/(1-sigma));

PE2 = ( omega2^sigma * Pf^(1-sigma) + (1-omega2)^sigma * Pr^(1-sigma) )^(1/(1-sigma));

//---------------------------------------------------------------
// CES final-good producer (P_Y = 1 numeraire)
//---------------------------------------------------------------

Y = ( eta * Y1^((rho-1)/rho) + (1-eta) * Y2^((rho-1)/rho) )^(rho/(rho-1));

P1 = eta     * (Y/Y1)^(1/rho);

P2 = (1-eta) * (Y/Y2)^(1/rho);

//---------------------------------------------------------------
// Intermediate goods production
//---------------------------------------------------------------

Y1 = A1 * K1^alpha1 * L1^beta1 * (chi * E1)^gamma1;

Y2 = A2 * K2^alpha2 * L2^beta2 * (chi * E2)^gamma2;

//---------------------------------------------------------------
// Capital FOC with intersectoral adjustment cost wedge
// (Mussa 1978, Turnovsky 1997; wedge = 0 in steady state)
//---------------------------------------------------------------

P1 * alpha1 * Y1 / K1 = r + phiK * (K1 - K1(-1));

P2 * alpha2 * Y2 / K2 = r + phiK * (K2 - K2(-1));

//---------------------------------------------------------------
// Labor FOC with intersectoral adjustment cost wedge
//---------------------------------------------------------------

P1 * beta1 * Y1 / L1 = w + phiL * (L1 - L1(-1));

P2 * beta2 * Y2 / L2 = w + phiL * (L2 - L2(-1));

//---------------------------------------------------------------
// Energy FOC
//---------------------------------------------------------------

E1 = P1 * gamma1 * Y1 / PE1;

E2 = P2 * gamma2 * Y2 / PE2;

//---------------------------------------------------------------
// Conditional energy demands (CES)
//---------------------------------------------------------------

Ef1 = omega1^sigma     * (Pf/PE1)^(-sigma) * E1;
Er1 = (1-omega1)^sigma * (Pr/PE1)^(-sigma) * E1;

Ef2 = omega2^sigma     * (Pf/PE2)^(-sigma) * E2;
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
// Law of motion for capital
//---------------------------------------------------------------

K = (1-delta) * K(-1) + I;

//---------------------------------------------------------------
// Euler equation
//---------------------------------------------------------------

C(+1) / C = beta_disc * (1 - delta + r(+1));

//---------------------------------------------------------------
// Resource constraint with quadratic adjustment costs
//---------------------------------------------------------------

C = Y - I - Mf - Mr
    - (phiK/2) * (K1 - K1(-1))^2
    - (phiK/2) * (K2 - K2(-1))^2
    - (phiL/2) * (L1 - L1(-1))^2
    - (phiL/2) * (L2 - L2(-1))^2;

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

    PE1 = 1.3442153;
    PE2 = 1.4072713;

    E1 = 0.0079518;
    E2 = 0.0075267;

    Y1 = 0.4280733;
    Y2 = 0.4231951;
    Y  = 0.4256318;

    P1 = 0.4994292;
    P2 = 0.5005754;

    K1 = 0.5798744;
    K2 = 0.5745810;
    K  = 1.1544554;

    L1 = 0.5022915;
    L2 = 0.4977085;
    L  = 1.0000000;

    C  = 0.3119943;
    I  = 0.0923564;

    r  = 0.1216667;
    w  = 0.2638923;

    Ef1 = 0.0103817;
    Er1 = 0.0002931;

    Ef2 = 0.0003352;
    Er2 = 0.0097676;

    Ef = 0.0107169;
    Er = 0.0100607;

    Mf = 0.0107169;
    Mr = 0.0105637;

    T  = 0.0000000;

    renewable_share = 0.4842249;

end;

steady;

//=================================================================
// 7. Terminal values — target SS (s = 0.20)
//=================================================================

endval;

    s = 0.20;

    Pf = 1.0000000;
    Pr = 0.8500000;   // cr/zr - s = 1.05 - 0.20

    PE1 = 1.3351657;
    PE2 = 1.1461321;

    E1 = 0.0079158;
    E2 = 0.0095068;

    Y1 = 0.4211288;
    Y2 = 0.4375118;
    Y  = 0.4293052;

    P1 = 0.5019265;
    P2 = 0.4981102;

    K1 = 0.5733212;
    K2 = 0.5910964;
    K  = 1.1644176;

    L1 = 0.4923670;
    L2 = 0.5076330;
    L  = 1.0000000;

    C  = 0.3121015;
    I  = 0.0931534;

    r  = 0.1216667;
    w  = 0.2661690;

    Ef1 = 0.0101950;
    Er1 = 0.0004391;

    Ef2 = 0.0002811;
    Er2 = 0.0124886;

    Ef = 0.0104761;
    Er = 0.0129277;

    Mf = 0.0104761;
    Mr = 0.0135751;

    T  = 0.0025855;

    renewable_share = 0.5523816;

end;

steady;

//=================================================================
// 8. Perfect foresight simulation
//=================================================================

perfect_foresight_setup(periods=300);
perfect_foresight_solver;