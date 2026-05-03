#################################################################
# The code:
# 1. sets baseline parameter values
# 2. computes energy prices and energy price indices
# 3. solves each final goods sector
# 4. aggregates sectoral outcomes
# 5. computes output, consumption, taxes, and renewable share.
#
# The economy has:
# I. two final goods sectors,
# II. one energy sector,
# III. two energy technologies: fossil and renewable.
#
# The main policy variable is the renewable energy subsidy s.
# A higher subsidy lowers the effective price of renewable energy.
#
# The file does not produce figures by itself.
# Figures are generated in plots.jl and executed from main.jl.
##################################################################


##################################################################
# 1. Baseline parameters
##################################################################

function baseline_parameters()
    return (
        # Production parameters in the two final goods sectors
        alpha1 = 0.30,     # capital share in Sector 1
        beta1  = 0.60,     # labor share in Sector 1

        alpha2 = 0.30,     # capital share in Sector 2
        beta2  = 0.60,     # labor share in Sector 2

        # Productivity in the two final goods sectors
        A1 = 1.0,
        A2 = 1.0,

        # Energy efficiency
        chi = 1.0,

        # Elasticity of substitution between fossil and renewable energy
        sigma = 2.0,

        # Energy composition parameters
        # Higher omega means a sector is more fossil-oriented.
        omega1 = 0.7,
        omega2 = 0.4,

        # Unit cost parameters in the energy sector
        cf = 1.0,          # fossil energy cost parameter
        cr = 1.2,          # renewable energy cost parameter

        # Productivity in energy production
        zf = 1.0,
        zr = 1.0,

        # Fixed capital and labor allocations
        K1 = 1.0,
        K2 = 1.0,
        L1 = 1.0,
        L2 = 1.0,

        # Depreciation rate of capital
        delta = 0.08
    )
end


##################################################################
# 2. Energy price index
##################################################################
# This function computes the CES price index for energy services.
# It combines the fossil energy price and the renewable energy price.

function energy_price_index(Pf, Pr, omega, sigma)
    inside = omega^sigma * Pf^(1 - sigma) +
             (1 - omega)^sigma * Pr^(1 - sigma)

    return inside^(1 / (1 - sigma))
end


##################################################################
# 3. Sectoral output
##################################################################
# Final output is produced with capital, labor, and energy services.
#
# Y = A * K^alpha * L^beta * (chi * E)^gamma
#
# where gamma is the energy share in production.

function sector_output(A, K, L, E, alpha, beta, chi)
    gamma = 1 - alpha - beta

    return A * K^alpha * L^beta * (chi * E)^gamma
end


##################################################################
# 4. Conditional demand for fossil and renewable energy
##################################################################
# These formulas come from minimizing the cost of obtaining
# one unit of energy services from fossil and renewable energy.

function fossil_demand(E, Pf, PE, omega, sigma)
    return omega^sigma * (Pf / PE)^(-sigma) * E
end

function renewable_demand(E, Pr, PE, omega, sigma)
    return (1 - omega)^sigma * (Pr / PE)^(-sigma) * E
end


##################################################################
# 5. Solve one final goods sector
##################################################################
# Given energy prices, this function computes:
# - sectoral energy price index,
# - demand for energy services,
# - sectoral output,
# - fossil and renewable energy demand.

function solve_sector(A, K, L, alpha, beta, chi, omega, sigma, Pf, Pr)
    gamma = 1 - alpha - beta

    # Sector-specific energy price index
    PE = energy_price_index(Pf, Pr, omega, sigma)

    # From the firm's FOC for energy:
    # PE = gamma * Y / E
    # combined with the production function.
    constant_part = A * K^alpha * L^beta * chi^gamma
    E = (gamma * constant_part / PE)^(1 / (1 - gamma))

    # Sectoral output
    Y = sector_output(A, K, L, E, alpha, beta, chi)

    # Energy mix
    Ef = fossil_demand(E, Pf, PE, omega, sigma)
    Er = renewable_demand(E, Pr, PE, omega, sigma)

    return (
        PE = PE,
        E = E,
        Ef = Ef,
        Er = Er,
        Y = Y
    )
end


##################################################################
# 6. Solve the full model for a given subsidy
##################################################################
# The subsidy s lowers the effective price of renewable energy:
#
# Pr = cr / zr - s
#
# The real resource cost of energy production is still:
#
# (cf/zf) * Ef + (cr/zr) * Er
#
# because subsidies are transfers financed by lump-sum taxes.

function solve_model(s, params)

    # Energy prices
    Pf = params.cf / params.zf
    Pr = params.cr / params.zr - s

    # Prevent negative renewable energy prices
    if Pr <= 0
        error("Renewable energy price must be positive. Choose a smaller subsidy.")
    end

    # Sector 1: more fossil-oriented
    sector1 = solve_sector(
        params.A1,
        params.K1,
        params.L1,
        params.alpha1,
        params.beta1,
        params.chi,
        params.omega1,
        params.sigma,
        Pf,
        Pr
    )

    # Sector 2: more renewable-oriented
    sector2 = solve_sector(
        params.A2,
        params.K2,
        params.L2,
        params.alpha2,
        params.beta2,
        params.chi,
        params.omega2,
        params.sigma,
        Pf,
        Pr
    )

    # Aggregate energy use
    Ef_total = sector1.Ef + sector2.Ef
    Er_total = sector1.Er + sector2.Er

    # Aggregate output
    Y_total = sector1.Y + sector2.Y

    # Steady-state investment
    K_total = params.K1 + params.K2
    I = params.delta * K_total

    # Real resource cost of energy production
    energy_cost = (params.cf / params.zf) * Ef_total +
                  (params.cr / params.zr) * Er_total

    # Consumption from the resource constraint
    C = Y_total - I - energy_cost

    # Government budget constraint
    T = s * Er_total

    # Renewable share in total energy use
    renewable_share = Er_total / (Ef_total + Er_total)

    return (
        subsidy = s,

        # Energy prices
        Pf = Pf,
        Pr = Pr,

        # Output
        Y1 = sector1.Y,
        Y2 = sector2.Y,
        Y = Y_total,

        # Consumption, investment, taxes
        C = C,
        I = I,
        T = T,

        # Sectoral energy price indices
        PE1 = sector1.PE,
        PE2 = sector2.PE,

        # Energy services
        E1 = sector1.E,
        E2 = sector2.E,

        # Fossil and renewable energy by sector
        Ef1 = sector1.Ef,
        Er1 = sector1.Er,
        Ef2 = sector2.Ef,
        Er2 = sector2.Er,

        # Aggregate fossil and renewable energy
        Ef = Ef_total,
        Er = Er_total,

        # Renewable energy share
        renewable_share = renewable_share
    )
end