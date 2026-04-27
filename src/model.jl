function baseline_parameters()
    return (
        alpha1 = 0.30,
        beta1 = 0.60,
        alpha2 = 0.30,
        beta2 = 0.60,
        A1 = 1.0,
        A2 = 1.0,
        chi = 1.0,
        sigma = 2.0,
        omega1 = 0.7,
        omega2 = 0.4,
        cf = 1.0,
        cr = 1.2,
        zf = 1.0,
        zr = 1.0,
        K1 = 1.0,
        K2 = 1.0,
        L1 = 1.0,
        L2 = 1.0
    )
end

function energy_price_index(Pf, Pr, omega, sigma)
    inside = omega^sigma * Pf^(1 - sigma) + (1 - omega)^sigma * Pr^(1 - sigma)
    return inside^(1 / (1 - sigma))
end

function energy_demand(Y, PE, alpha, beta)
    gamma = 1 - alpha - beta
    return gamma * Y / PE
end

function fossil_demand(E, Pf, PE, omega, sigma)
    return omega^sigma * (Pf / PE)^(-sigma) * E
end

function renewable_demand(E, Pr, PE, omega, sigma)
    return (1 - omega)^sigma * (Pr / PE)^(-sigma) * E
end

function sector_output(A, K, L, E, alpha, beta, chi)
    gamma = 1 - alpha - beta
    return A * K^alpha * L^beta * (chi * E)^gamma
end

function solve_sector(A, K, L, alpha, beta, chi, omega, sigma, Pf, Pr)
    PE = energy_price_index(Pf, Pr, omega, sigma)

    Y_guess = A * K^alpha * L^beta * 1.0^(1 - alpha - beta)
    
    gamma = 1 - alpha - beta
    constant_part = A * K^alpha * L^beta * chi^gamma

    E = (gamma * constant_part / PE)^(1 / (1 - gamma))

    Y = sector_output(A, K, L, E, alpha, beta, chi)
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

function solve_model(s, params)
    Pf = params.cf / params.zf
    Pr = params.cr / params.zr - s

    if Pr <= 0
        error("Renewable energy price must be positive. Choose a smaller subsidy.")
    end

    sector1 = solve_sector(
        params.A1, params.K1, params.L1,
        params.alpha1, params.beta1,
        params.chi, params.omega1, params.sigma,
        Pf, Pr
    )

    sector2 = solve_sector(
        params.A2, params.K2, params.L2,
        params.alpha2, params.beta2,
        params.chi, params.omega2, params.sigma,
        Pf, Pr
    )

    Ef_total = sector1.Ef + sector2.Ef
    Er_total = sector1.Er + sector2.Er
    Y_total = sector1.Y + sector2.Y

    renewable_share = Er_total / (Ef_total + Er_total)

    return (
        subsidy = s,
        Pf = Pf,
        Pr = Pr,
        Y1 = sector1.Y,
        Y2 = sector2.Y,
        Y = Y_total,
        PE1 = sector1.PE,
        PE2 = sector2.PE,
        E1 = sector1.E,
        E2 = sector2.E,
        Ef1 = sector1.Ef,
        Er1 = sector1.Er,
        Ef2 = sector2.Ef,
        Er2 = sector2.Er,
        Ef = Ef_total,
        Er = Er_total,
        renewable_share = renewable_share
    )
end

using Dynare

context = @dynare "dynare_model.mod"