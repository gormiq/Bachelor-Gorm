//=================================================================
// This file implements the steady-state equilibrium of the model
// described in Sections 3.1–3.11 of the thesis.
//
// IMPORTANT SIMPLIFICATIONS vs. the full theoretical model:
//   1. The model is STATIC (comparative statics only).
//      The household Euler equation and capital accumulation
//      are not solved dynamically. We jump directly to the
//      steady state implied by the theory (Section 3.11).
//   2. Capital (K) and labor (L) are FIXED PARAMETERS in each
//      sector. Factor markets (r, w) are not explicitly cleared.
//      This means we do not endogenously allocate K and L across
//      sectors, their allocation is taken as given.
//   3. The dummy AR(1) variable is a technical requirement of
//      Dynare: the software needs at least one lagged variable
//      to build a dynamic system. It has no economic meaning.
//
// Structure of the file:
//   1. Variable declarations
//   2. Exogenous variable (policy instrument)
//   3. Parameter declarations and calibration
//   4. Model equations
//   5. Initial values (steady state at s = 0, from Julia)
//   6. Steady-state solver call
//=================================================================


//=================================================================
// 1. Endogenous variables
//=================================================================

var

    //==========Energy prices (Section 3.4)===========
    Pf          // fossil energy price:    Pf = cf / zf
    Pr          // renewable energy price: Pr = cr / zr - s

    //==========Sector-specific CES energy price indices (Section 3.3)===========
    PE1         // energy price index in sector 1 (fossil-intensive)
    PE2         // energy price index in sector 2 (renewable-intensive)

    //==========Energy services demanded by each sector (Section 3.3)===========
    E1          // total energy services in sector 1
    E2          // total energy services in sector 2

    //==========Sectoral output (Section 3.2)===========
    Y1          // gross output of sector 1
    Y2          // gross output of sector 2

    //==========Energy mix by sector (Section 3.3)===========
    Ef1         // fossil energy demand in sector 1
    Er1         // renewable energy demand in sector 1
    Ef2         // fossil energy demand in sector 2
    Er2         // renewable energy demand in sector 2

    //==========Aggregate energy (Section 3.4 market clearing)===========
    Ef          // total fossil energy:    Ef = Ef1 + Ef2
    Er          // total renewable energy: Er = Er1 + Er2

    //==========Aggregate quantities (Sections 3.6–3.8)===========
    Y           // aggregate output:   Y = Y1 + Y2
    C           // private consumption
    I           // investment = delta * K  (steady-state condition)
    T           // lump-sum tax = s * Er   (government budget)

    //==========Key policy outcome===========
    renewable_share   // share of renewables in total energy: Er/(Ef+Er)

    //==========Technical variable (no economic content)===========
    dummy;      // AR(1) placeholder required by Dynare


//=================================================================
// 2. Exogenous variable — the policy instrument
//=================================================================

varexo s;       // renewable energy subsidy
                // Admissible range: 0 <= s < cr/zr  (price must stay positive)


//=================================================================
// 3. Parameters and calibration
//=================================================================
// All values correspond to baseline_parameters() in model.jl.

parameters
    // Production function parameters (Section 3.2)
    alpha1      // capital share in sector 1
    beta1       // labor share in sector 1
    gamma1      // energy share in sector 1  (= 1 - alpha1 - beta1, set below)
    alpha2      // capital share in sector 2
    beta2       // labor share in sector 2
    gamma2      // energy share in sector 2  (= 1 - alpha2 - beta2, set below)

    // Productivity
    A1          // TFP in sector 1
    A2          // TFP in sector 2
    chi         // energy efficiency parameter (Section 3.2)

    // CES energy aggregator (Section 3.3)
    sigma       // elasticity of substitution between fossil and renewable
    omega1      // fossil weight in sector 1  (higher => more fossil-intensive)
    omega2      // fossil weight in sector 2  (lower  => more renewable-intensive)

    // Energy sector cost and productivity (Section 3.4)
    cf          // unit cost parameter, fossil energy production
    cr          // unit cost parameter, renewable energy production
    zf          // productivity in fossil energy production
    zr          // productivity in renewable energy production

    // Fixed factor endowments per sector (simplification — see note above)
    K1 K2       // capital in sectors 1 and 2
    L1 L2       // labor  in sectors 1 and 2
    Kbar        // total capital stock  (= K1 + K2, used for investment)

    // Capital and steady state
    delta       // depreciation rate (Section 3.1)

    // Technical parameter for the dummy equation
    rho_dummy;

//==========Calibration===========
alpha1 = 0.30;
beta1  = 0.60;
gamma1 = 1 - alpha1 - beta1;   // = 0.10  (energy share, sector 1)

alpha2 = 0.30;
beta2  = 0.60;
gamma2 = 1 - alpha2 - beta2;   // = 0.10  (energy share, sector 2)

A1  = 1.0;
A2  = 1.0;
chi = 1.0;

sigma  = 2.0;
omega1 = 0.7;   // sector 1: more fossil-oriented
omega2 = 0.4;   // sector 2: more renewable-oriented

cf = 1.0;   cr = 1.2;
zf = 1.0;   zr = 1.0;

K1 = 1.0;   K2 = 1.0;
L1 = 1.0;   L2 = 1.0;
Kbar = K1 + K2;

delta     = 0.08;
rho_dummy = 0.5;


//=================================================================
// 4. Model equations
//=================================================================
// There are 20 endogenous variables and 20 equations below.
// The model is solved for the steady state.

model;

//==========[1-2] Energy prices (Section 3.4)===========
// Fossil: marginal cost of production cf/zf, no subsidy
// Renewable: marginal cost cr/zr reduced by the subsidy s
Pf = cf / zf;
Pr = cr / zr - s;

//==========[3-4] CES energy price indices (Section 3.3)===========
// PE_j is the minimum cost of obtaining one unit of energy
// services in sector j, given the fossil/renewable price mix.
PE1 = ( omega1^sigma * Pf^(1-sigma) + (1-omega1)^sigma * Pr^(1-sigma) )^(1/(1-sigma));
PE2 = ( omega2^sigma * Pf^(1-sigma) + (1-omega2)^sigma * Pr^(1-sigma) )^(1/(1-sigma));

//==========[5-6] Sectoral output — Cobb-Douglas (Section 3.2)===========
Y1 = A1 * K1^alpha1 * L1^beta1 * (chi * E1)^gamma1;
Y2 = A2 * K2^alpha2 * L2^beta2 * (chi * E2)^gamma2;

//==========[7-8] FOC for energy demand (Section 3.2)===========
// From profit maximisation: PE_j = (1 - alpha_j - beta_j) * Y_j / E_j
// Combined with the production function, this pins down E_j.
// Note: equations [5-6] and [7-8] form a 2x2 system in (Y_j, E_j).
PE1 = gamma1 * Y1 / E1;
PE2 = gamma2 * Y2 / E2;

//==========[9-12] Conditional energy mix — CES cost minimisation (Section 3.3)===========
// Given total energy services E_j, firms minimise cost by
// splitting between fossil and renewable according to relative prices.
Ef1 = omega1^sigma     * (Pf / PE1)^(-sigma) * E1;
Er1 = (1-omega1)^sigma * (Pr / PE1)^(-sigma) * E1;
Ef2 = omega2^sigma     * (Pf / PE2)^(-sigma) * E2;
Er2 = (1-omega2)^sigma * (Pr / PE2)^(-sigma) * E2;

//==========[13-14] Energy market clearing (Section 3.4)===========
Ef = Ef1 + Ef2;
Er = Er1 + Er2;

//==========[15] Output aggregation (Section 3.2)===========
Y = Y1 + Y2;

//==========[16] Government budget constraint (Section 3.5)===========
// Subsidy payments to renewable producers are financed by lump-sum taxes.
T = s * Er;

//==========[17] Steady-state investment (Section 3.8)===========
// In steady state: I = delta * K  (from the Euler equation + law of motion)
I = delta * Kbar;

//==========[18] Goods market clearing / resource constraint (Section 3.6)===========
// Output is split between consumption, investment, and energy production costs.
// Energy costs use FULL prices cf/zf and cr/zr (not the subsidised Pr),
// because subsidies are pure transfers — not real resource costs.
Y = C + I + (cf/zf)*Ef + (cr/zr)*Er;

//==========[19] Renewable energy share===========
renewable_share = Er / (Ef + Er);

//==========[20] Dummy dynamic equation (technical, no economic content)===========
dummy = rho_dummy * dummy(-1);

end;


//=================================================================
// 5. Initial values for the steady-state solver
//=================================================================
// These are approximate values at s = 0, computed in Julia (model.jl).
// Dynare's 'steady' command will refine them numerically.

initval;
    s  = 0.0;

    Pf = 1.0;
    Pr = 1.2;

    PE1 = 1.77;
    PE2 = 2.17;

    E1 = 0.041;
    E2 = 0.033;

    Y1 = 0.727;
    Y2 = 0.710;

    Ef1 = 0.063;   Er1 = 0.008;
    Ef2 = 0.025;   Er2 = 0.039;

    Ef  = 0.088;
    Er  = 0.047;

    Y  = 1.437;
    C  = 1.190;
    I  = 0.160;
    T  = 0.000;

    renewable_share = 0.347;

    dummy = 0.0;
end;


//=================================================================
// 6. Solve for the steady state
//=================================================================

steady;