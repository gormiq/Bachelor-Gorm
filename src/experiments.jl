#=================================================================
# Kombinacja experiments
# Two-sector neoclassical model with renewable energy subsidies
#
# Research question:
#   What determines the net benefit of a renewable energy subsidy,
#   and how should the subsidy be designed to maximize it?
#
# Structure:
#   Part A — Long-run determinants (sigma, chi)
#   Part B — Adjustment costs and transition path (phi_K, phi_L)
#   Part C — Gradual subsidy introduction
#=================================================================

using Dynare
using Plots
using Printf


#=================================================================
# 1. Base calibration
#=================================================================

base_params = Dict(
    # Sectoral production
    "alpha1"    => 0.33,
    "beta1"     => 0.61,
    "alpha2"    => 0.33,
    "beta2"     => 0.61,
    "A1"        => 1.0,
    "A2"        => 1.0,
    "chi"       => 1.0,

    # CES final-good aggregator
    "eta"       => 0.50,
    "rho"       => 5.0,

    # CES energy aggregator
    "sigma"     => 2.0,
    "omega1"    => 0.85,
    "omega2"    => 0.15,

    # Energy production
    "cf"        => 1.0,
    "cr"        => 1.05,
    "zf"        => 1.0,
    "zr"        => 1.0,

    # Household and capital accumulation
    "beta_disc" => 0.96,
    "delta"     => 0.08,
    "Lbar"      => 1.0,

    # Intersectoral adjustment costs
    "phiK"      => 0.5,
    "phiL"      => 0.2
)


#=================================================================
# 2. Experiment configuration
#=================================================================

const S_TERMINAL = 0.20        # Terminal subsidy level
const PERIODS    = 300         # Length of simulation

const SIGMA_GRID = [1.5, 2.0, 3.0, 4.0]
const CHI_GRID   = [0.8, 1.0, 1.2]
const PHIK_GRID  = [0.1, 0.5, 1.0, 2.0, 5.0]
const PHIL_GRID  = [0.05, 0.2, 0.5, 1.0]
const RAMP_GRID  = [0, 10, 20, 30]   # 0 = immediate jump


#=================================================================
# 3. .mod file template generator
#=================================================================

function build_mod_file(filename::String;
                       params::Dict      = base_params,
                       ramp_periods::Int = 0)

    # ---- Build optional shocks block for gradual subsidy ----
    if ramp_periods > 0
        ramp_lines = String[]
        for t in 1:ramp_periods
            s_t = S_TERMINAL * t / ramp_periods
            push!(ramp_lines, "    var s; periods $(t); values $(s_t);")
        end
        shocks_block = "shocks;\n" * join(ramp_lines, "\n") * "\nend;\n"
    else
        shocks_block = ""
    end

    # ---- Write .mod file ----
    mod_text = """
    //=================================================================
    // 1. Endogenous variables
    //=================================================================

    var Pf Pr PE1 PE2 E1 E2 Y1 Y2 Y P1 P2 K1 K2 K L1 L2 L
        C I r w Ef1 Er1 Ef2 Er2 Ef Er Mf Mr T renewable_share;

    varexo s;

    //=================================================================
    // 2. Parameters
    //=================================================================

    parameters alpha1 beta1 gamma1 alpha2 beta2 gamma2 A1 A2 chi
        eta rho sigma omega1 omega2 cf cr zf zr
        beta_disc delta Lbar phiK phiL;

    //=================================================================
    // 3. Calibration
    //=================================================================

    alpha1 = $(params["alpha1"]);
    beta1  = $(params["beta1"]);
    gamma1 = 1 - alpha1 - beta1;

    alpha2 = $(params["alpha2"]);
    beta2  = $(params["beta2"]);
    gamma2 = 1 - alpha2 - beta2;

    A1  = $(params["A1"]);
    A2  = $(params["A2"]);
    chi = $(params["chi"]);

    eta = $(params["eta"]);
    rho = $(params["rho"]);

    sigma  = $(params["sigma"]);
    omega1 = $(params["omega1"]);
    omega2 = $(params["omega2"]);

    cf = $(params["cf"]);
    cr = $(params["cr"]);
    zf = $(params["zf"]);
    zr = $(params["zr"]);

    beta_disc = $(params["beta_disc"]);
    delta     = $(params["delta"]);
    Lbar      = $(params["Lbar"]);

    phiK = $(params["phiK"]);
    phiL = $(params["phiL"]);

    //=================================================================
    // 4. Model equations
    //=================================================================

    model;

        // Energy prices
        Pf = cf / zf;
        Pr = cr / zr - s;

        // Sector-specific CES energy price indices
        PE1 = (omega1^sigma * Pf^(1-sigma) + (1-omega1)^sigma * Pr^(1-sigma))^(1/(1-sigma));
        PE2 = (omega2^sigma * Pf^(1-sigma) + (1-omega2)^sigma * Pr^(1-sigma))^(1/(1-sigma));

        // CES final-good producer
        Y  = (eta * Y1^((rho-1)/rho) + (1-eta) * Y2^((rho-1)/rho))^(rho/(rho-1));
        P1 = eta     * (Y/Y1)^(1/rho);
        P2 = (1-eta) * (Y/Y2)^(1/rho);

        // Intermediate goods production
        Y1 = A1 * K1^alpha1 * L1^beta1 * (chi * E1)^gamma1;
        Y2 = A2 * K2^alpha2 * L2^beta2 * (chi * E2)^gamma2;

        // Capital FOC with adjustment cost wedge
        P1 * alpha1 * Y1 / K1 = r + phiK * (K1 - K1(-1));
        P2 * alpha2 * Y2 / K2 = r + phiK * (K2 - K2(-1));

        // Labor FOC with adjustment cost wedge
        P1 * beta1 * Y1 / L1 = w + phiL * (L1 - L1(-1));
        P2 * beta2 * Y2 / L2 = w + phiL * (L2 - L2(-1));

        // Energy FOC
        E1 = P1 * gamma1 * Y1 / PE1;
        E2 = P2 * gamma2 * Y2 / PE2;

        // Conditional energy demands
        Ef1 = omega1^sigma     * (Pf/PE1)^(-sigma) * E1;
        Er1 = (1-omega1)^sigma * (Pr/PE1)^(-sigma) * E1;
        Ef2 = omega2^sigma     * (Pf/PE2)^(-sigma) * E2;
        Er2 = (1-omega2)^sigma * (Pr/PE2)^(-sigma) * E2;

        // Energy market clearing
        Ef = Ef1 + Ef2;
        Er = Er1 + Er2;

        // Energy production
        Ef = (zf/cf) * Mf;
        Er = (zr/cr) * Mr;

        // Factor market clearing
        K = K1 + K2;
        L = L1 + L2;
        L = Lbar;

        // Law of motion for capital
        K = (1-delta) * K(-1) + I;

        // Euler equation
        C(+1) / C = beta_disc * (1 - delta + r(+1));

        // Resource constraint with adjustment costs
        C = Y - I - Mf - Mr
            - (phiK/2) * (K1 - K1(-1))^2
            - (phiK/2) * (K2 - K2(-1))^2
            - (phiL/2) * (L1 - L1(-1))^2
            - (phiL/2) * (L2 - L2(-1))^2;

        // Government budget
        T = s * Er;

        // Renewable share
        renewable_share = Er / (Ef + Er);

    end;

    //=================================================================
    // 5. Initial steady state (s = 0)
    //=================================================================

    initval;
        s = 0.0;
        Pf = 1.0;       Pr = 1.05;
        PE1 = 1.3442;   PE2 = 1.4073;
        E1 = 0.008;     E2 = 0.0075;
        Y1 = 0.428;     Y2 = 0.423;     Y = 0.426;
        P1 = 0.499;     P2 = 0.501;
        K1 = 0.58;      K2 = 0.575;     K = 1.155;
        L1 = 0.502;     L2 = 0.498;     L = 1.0;
        C = 0.312;      I = 0.092;
        r = 0.1217;     w = 0.264;
        Ef1 = 0.0104;   Er1 = 0.0003;
        Ef2 = 0.0003;   Er2 = 0.0098;
        Ef = 0.0107;    Er = 0.0101;
        Mf = 0.0107;    Mr = 0.0106;
        T = 0.0;        renewable_share = 0.484;
    end;
    steady;

    //=================================================================
    // 6. Terminal steady state (s = S_TERMINAL)
    //=================================================================

    endval;
        s = $(S_TERMINAL);
        Pf = 1.0;       Pr = $(params["cr"]/params["zr"] - S_TERMINAL);
        PE1 = 1.335;    PE2 = 1.146;
        E1 = 0.0079;    E2 = 0.0095;
        Y1 = 0.421;     Y2 = 0.438;     Y = 0.429;
        P1 = 0.502;     P2 = 0.498;
        K1 = 0.573;     K2 = 0.591;     K = 1.164;
        L1 = 0.492;     L2 = 0.508;     L = 1.0;
        C = 0.312;      I = 0.093;
        r = 0.1217;     w = 0.266;
        Ef1 = 0.0102;   Er1 = 0.0004;
        Ef2 = 0.0003;   Er2 = 0.0125;
        Ef = 0.0105;    Er = 0.0129;
        Mf = 0.0105;    Mr = 0.0136;
        T = 0.0026;     renewable_share = 0.552;
    end;
    steady;

    //=================================================================
    // 7. Subsidy schedule (gradual ramp, optional)
    //=================================================================

    $(shocks_block)

    //=================================================================
    // 8. Perfect foresight simulation
    //=================================================================

    perfect_foresight_setup(periods=$(PERIODS));
    perfect_foresight_solver;
    """

    open(filename, "w") do f
        write(f, mod_text)
    end
end


#=================================================================
# 4. Dynare runner and data extraction
#=================================================================

function run_and_extract(modfile::String)
    context = @dynare modfile
    sim     = context.results.model_results[1].simulations[1].data

    return Dict(
        "C"  => Vector(sim[!, :C]),
        "K"  => Vector(sim[!, :K]),
        "Y"  => Vector(sim[!, :Y]),
        "I"  => Vector(sim[!, :I]),
        "rs" => Vector(sim[!, :renewable_share]),
        "K1" => Vector(sim[!, :K1]),
        "K2" => Vector(sim[!, :K2]),
        "L1" => Vector(sim[!, :L1]),
        "L2" => Vector(sim[!, :L2])
    )
end


#=================================================================
# 5. Outcome metrics
#=================================================================

function compute_metrics(res::Dict, beta_disc::Float64)
    C       = res["C"]
    delta_C = C[end] - C[1]
    C_min   = minimum(C)
    welfare = sum(beta_disc^(t-1) * log(C[t]) for t in 1:length(C))

    return (
        delta_C = delta_C,
        C_min   = C_min,
        welfare = welfare,
        rs_init = res["rs"][1],
        rs_term = res["rs"][end]
    )
end


#=================================================================
# 6. Experiment loops
#=================================================================

# ---- Part A1: sigma variation ----
function exp_sigma()
    results = Dict()
    for s in SIGMA_GRID
        p = copy(base_params); p["sigma"] = s
        build_mod_file("exp_sigma_$(s).mod"; params=p)
        results[s] = run_and_extract("exp_sigma_$(s).mod")
    end
    return SIGMA_GRID, results
end

# ---- Part A2: chi variation ----
function exp_chi()
    results = Dict()
    for c in CHI_GRID
        p = copy(base_params); p["chi"] = c
        build_mod_file("exp_chi_$(c).mod"; params=p)
        results[c] = run_and_extract("exp_chi_$(c).mod")
    end
    return CHI_GRID, results
end

# ---- Part B1: phi_K variation ----
function exp_phiK()
    results = Dict()
    for pk in PHIK_GRID
        p = copy(base_params); p["phiK"] = pk
        build_mod_file("exp_phiK_$(pk).mod"; params=p)
        results[pk] = run_and_extract("exp_phiK_$(pk).mod")
    end
    return PHIK_GRID, results
end

# ---- Part B2: phi_L variation ----
function exp_phiL()
    results = Dict()
    for pl in PHIL_GRID
        p = copy(base_params); p["phiL"] = pl
        build_mod_file("exp_phiL_$(pl).mod"; params=p)
        results[pl] = run_and_extract("exp_phiL_$(pl).mod")
    end
    return PHIL_GRID, results
end

# ---- Part C: gradual subsidy ----
function exp_gradual()
    results = Dict()
    for r in RAMP_GRID
        build_mod_file("exp_ramp_$(r).mod"; params=base_params, ramp_periods=r)
        results[r] = run_and_extract("exp_ramp_$(r).mod")
    end
    return RAMP_GRID, results
end


#=================================================================
# 7. Plotting helpers
#=================================================================

function plot_transition(values, results, varname::String, ylabel::String;
                         title="", param_label="", outfile="")
    p = plot(title=title, xlabel="Period", ylabel=ylabel, legend=:bottomright)
    for v in values
        plot!(p, results[v][varname], label="$(param_label)=$(v)", linewidth=2)
    end
    isempty(outfile) || savefig(p, outfile)
    return p
end

function plot_long_run(values, results, param_label::String; outfile="")
    delta_Cs = [results[v]["C"][end]  - results[v]["C"][1]  for v in values]
    delta_rs = [results[v]["rs"][end] - results[v]["rs"][1] for v in values]

    p1 = plot(values, delta_Cs,
              xlabel=param_label, ylabel="ΔC",
              title="Long-run consumption gain",
              marker=:circle, linewidth=2, label="")

    p2 = plot(values, delta_rs,
              xlabel=param_label, ylabel="Δ renewable share",
              title="Long-run renewable share gain",
              marker=:circle, linewidth=2, label="")

    combined = plot(p1, p2, layout=(1,2), size=(900,350))
    isempty(outfile) || savefig(combined, outfile)
    return combined
end


#=================================================================
# 8. Main
#=================================================================

function main()

    println("=== Part A1: sigma ===")
    sigma_vals, res_sigma = exp_sigma()
    plot_long_run(sigma_vals, res_sigma, "sigma";
                  outfile="plot_sigma_longrun.png")
    plot_transition(sigma_vals, res_sigma, "rs", "Renewable share";
                    title="Renewable share by sigma",
                    param_label="σ",
                    outfile="plot_sigma_rs.png")

    println("=== Part A2: chi ===")
    chi_vals, res_chi = exp_chi()
    plot_long_run(chi_vals, res_chi, "chi";
                  outfile="plot_chi_longrun.png")

    println("=== Part B1: phi_K ===")
    phiK_vals, res_phiK = exp_phiK()
    plot_transition(phiK_vals, res_phiK, "C", "Consumption";
                    title="Consumption by phi_K",
                    param_label="φ_K",
                    outfile="plot_phiK_C.png")
    plot_transition(phiK_vals, res_phiK, "rs", "Renewable share";
                    title="Renewable share by phi_K",
                    param_label="φ_K",
                    outfile="plot_phiK_rs.png")
    plot_transition(phiK_vals, res_phiK, "K", "Capital";
                    title="Capital by phi_K",
                    param_label="φ_K",
                    outfile="plot_phiK_K.png")

    println("=== Part B2: phi_L ===")
    phiL_vals, res_phiL = exp_phiL()
    plot_transition(phiL_vals, res_phiL, "C", "Consumption";
                    title="Consumption by phi_L",
                    param_label="φ_L",
                    outfile="plot_phiL_C.png")

    println("=== Part C: gradual subsidy ===")
    ramps, res_ramp = exp_gradual()
    plot_transition(ramps, res_ramp, "C", "Consumption";
                    title="Consumption by ramp length",
                    param_label="ramp",
                    outfile="plot_ramp_C.png")
    plot_transition(ramps, res_ramp, "rs", "Renewable share";
                    title="Renewable share by ramp length",
                    param_label="ramp",
                    outfile="plot_ramp_rs.png")

    # ---- Welfare summary for gradual subsidy ----
    println("\n=== Welfare by ramp length ===")
    @printf "%-8s %-12s %-12s %-12s\n" "ramp" "ΔC" "C_min" "welfare"
    for r in ramps
        m = compute_metrics(res_ramp[r], base_params["beta_disc"])
        @printf "%-8d %-12.5f %-12.5f %-12.4f\n" r m.delta_C m.C_min m.welfare
    end

end

main()