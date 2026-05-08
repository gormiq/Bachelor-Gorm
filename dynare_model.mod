//=================================================================
// dynare_model.mod
//
// Full steady-state neoclassical general equilibrium model
// with renewable energy subsidies.
//
// Economic structure:
//   1. Representative household
//   2. Competitive final-good producer
//   3. Two intermediate goods sectors
//   4. Fossil and renewable energy
//   5. Renewable energy subsidy financed by lump-sum taxes
//
// The model is solved in steady state.
// It is not a transition-dynamics DSGE model.
//
// The household Euler equation is imposed in steady-state form:
//
//     r = 1 / beta - 1 + delta
//
// The policy variable is the renewable energy subsidy s.
// The baseline steady state uses s = 0.
//=================================================================


//=================================================================
// 1. Endogenous variables
//=================================================================

var
    // Energy prices
    Pf
    Pr

    // Sector-specific energy price indices
    PE1
    PE2

    // Energy services used by intermediate sectors
    E1
    E2

    // Output of intermediate goods sectors
    Y1
    Y2

    // Aggregate final output
    Y

    // Prices of intermediate goods
    P1
    P2

    // Capital and labor
    K1
    K2
    K
    L1
    L2
    L

    // Household and aggregate variables
    C
    I
    r
    w

    // Fossil and renewable energy demand by sector
    Ef1
    Er1
    Ef2
    Er2

    // Aggregate fossil and renewable energy
    Ef
    Er

    // Final-good resources used in energy production
    Mf
    Mr

    // Government
    T

    // Main policy outcome
    renewable_share

    // Technical variable without economic meaning
    dummy
;


//=================================================================
// 2. Exogenous policy variable
//=================================================================

varexo s;


//=================================================================
// 3. Parameters
//=================================================================

parameters
    // Production parameters in intermediate sectors
    alpha1
    beta1
    gamma1

    alpha2
    beta2
    gamma2

    // Productivity
    A1
    A2
    chi

    // Final-good aggregator parameter
    theta

    // Energy CES parameters
    sigma
    omega1
    omega2

    // Energy sector cost and productivity
    cf
    cr
    zf
    zr

    // Household / steady-state parameters
    beta
    delta
    Lbar

    // Technical parameter
    rho_dummy
;


//=================================================================
// 4. Calibration
//=================================================================

//---------------------------------------------------------------
// Intermediate goods production
//---------------------------------------------------------------

alpha1 = 0.30;
beta1  = 0.60;
gamma1 = 1 - alpha1 - beta1;

alpha2 = 0.30;
beta2  = 0.60;
gamma2 = 1 - alpha2 - beta2;

//---------------------------------------------------------------
// Productivity
//---------------------------------------------------------------

A1  = 1.0;
A2  = 1.0;

// Energy efficiency
chi = 1.0;

//---------------------------------------------------------------
// Final-good aggregator
//---------------------------------------------------------------
// theta = 0.5 means both sectoral goods have equal weight.

theta = 0.50;

//---------------------------------------------------------------
// Energy CES
//---------------------------------------------------------------
// sigma > 1 means fossil and renewable energy are substitutable.
// Do not set sigma = 1 in this formulation.

sigma = 2.0;

// Sector 1 is more fossil-oriented.
// Sector 2 is more renewable-oriented.

omega1 = 0.70;
omega2 = 0.40;

//---------------------------------------------------------------
// Energy sector
//---------------------------------------------------------------
// Renewable energy is more costly in the baseline calibration.

cf = 1.0;
cr = 1.2;

zf = 1.0;
zr = 1.0;

//---------------------------------------------------------------
// Household / steady state
//---------------------------------------------------------------

beta  = 0.96;
delta = 0.08;

// Labor normalization
Lbar = 1.0;

//---------------------------------------------------------------
// Technical dummy parameter
//---------------------------------------------------------------

rho_dummy = 0.5;


//=================================================================
// 5. Model equations
//=================================================================

model;


//=================================================================
// Energy prices
//=================================================================
// Fossil energy price equals unit production cost.
// Renewable energy price is reduced by the subsidy.

Pf = cf / zf;

Pr = cr / zr - s;


//=================================================================
// Sector-specific energy price indices
//=================================================================
// These are CES unit cost indices for energy services.

PE1 =
(
    omega1^sigma * Pf^(1 - sigma)
    +
    (1 - omega1)^sigma * Pr^(1 - sigma)
)^(1 / (1 - sigma));

PE2 =
(
    omega2^sigma * Pf^(1 - sigma)
    +
    (1 - omega2)^sigma * Pr^(1 - sigma)
)^(1 / (1 - sigma));


//=================================================================
// Final-good producer
//=================================================================
// The two sectoral goods are not perfect substitutes.
// Aggregate output is a Cobb-Douglas composite.

Y = Y1^theta * Y2^(1 - theta);

// Sectoral prices come from the final-good producer's FOCs.
// The final good is the numeraire.

P1 = theta * Y / Y1;

P2 = (1 - theta) * Y / Y2;


//=================================================================
// Intermediate goods production
//=================================================================
// Each sector uses capital, labor, and energy services.

Y1 = A1 * K1^alpha1 * L1^beta1 * (chi * E1)^gamma1;

Y2 = A2 * K2^alpha2 * L2^beta2 * (chi * E2)^gamma2;


//=================================================================
// Capital and labor first-order conditions
//=================================================================
// Factor prices equal value marginal products.
// The sectoral price Pj matters because Y1 and Y2 are intermediate goods.

K1 = P1 * alpha1 * Y1 / (r + delta);
K2 = P2 * alpha2 * Y2 / (r + delta);


L1 = P1 * beta1 * Y1 / w;
L2 = P2 * beta2 * Y2 / w;



//=================================================================
// Energy first-order conditions
//=================================================================
// Energy price indices equal value marginal products of energy.

E1 = P1 * gamma1 * Y1 / PE1;
E2 = P2 * gamma2 * Y2 / PE2;


//=================================================================
// Conditional fossil and renewable energy demands
//=================================================================
// These equations come from CES cost minimization.
// They are the dual representation of the energy aggregator.

Ef1 = omega1^sigma * (Pf / PE1)^(-sigma) * E1;

Er1 = (1 - omega1)^sigma * (Pr / PE1)^(-sigma) * E1;

Ef2 = omega2^sigma * (Pf / PE2)^(-sigma) * E2;

Er2 = (1 - omega2)^sigma * (Pr / PE2)^(-sigma) * E2;


//=================================================================
// Energy market clearing
//=================================================================

Ef = Ef1 + Ef2;

Er = Er1 + Er2;


//=================================================================
// Energy production technologies
//=================================================================
// Mf and Mr are final-good resources used to produce energy.

Ef = (zf / cf) * Mf;

Er = (zr / cr) * Mr;


//=================================================================
// Factor market clearing
//=================================================================

K = K1 + K2;

L = L1 + L2;

L = Lbar;


//=================================================================
// Steady-state Euler condition
//=================================================================
// This is the steady-state version of the household Euler equation.

r = 1 / beta - 1 + delta;


//=================================================================
// Steady-state investment
//=================================================================

I = delta * K;


//=================================================================
// Aggregate resource constraint
//=================================================================
// Final output is used for consumption, investment,
// and energy production inputs.

C = Y - I - Mf - Mr;


//=================================================================
// Government budget constraint
//=================================================================
// Renewable energy subsidies are financed by lump-sum taxes.

T = s * Er;


//=================================================================
// Renewable share
//=================================================================

renewable_share = Er / (Ef + Er);


//=================================================================
// Technical dummy equation
//=================================================================
// This equation has no economic meaning.
// It only gives Dynare.jl one lagged variable.

dummy = rho_dummy * dummy(-1);


end;


//=================================================================
// 6. Initial values
//=================================================================
// These values correspond to the baseline no-subsidy steady state.
// They are used only as starting values for the nonlinear solver.
//=================================================================

initval;

    s = 0.0;

    Pf = 1.0;
    Pr = 1.2;

    PE1 = 1.7699115;
    PE2 = 2.1739130;

    E1 = 0.0085083;
    E2 = 0.0069271;

    Y1 = 0.3042915;
    Y2 = 0.2980992;
    Y  = 0.3011795;

    P1 = 0.4948863;
    P2 = 0.5051665;

    K1 = 0.3713171;
    K2 = 0.3713171;
    K  = 0.7426343;

    L1 = 0.5000000;
    L2 = 0.5000000;
    L  = 1.0000000;

    C = 0.2116508;
    I = 0.0594107;

    r = 0.1216667;
    w = 0.1807077;

    Ef1 = 0.0130600;
    Er1 = 0.0016658;

    Ef2 = 0.0052379;
    Er2 = 0.0081842;

    Ef = 0.0182979;
    Er = 0.0098500;

    Mf = 0.0182979;
    Mr = 0.0118200;

    T = 0.0000000;

    renewable_share = 0.3499382;

    dummy = 0.0;

end;


//=================================================================
// 7. Solve steady state
//=================================================================

steady;