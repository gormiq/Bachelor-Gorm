using Dynare
using Plots
using Printf
 
 
# ================================================================
# 1. Configuration
# ================================================================
 
const BASE_MODFILE = raw"C:\Bachelor-Gorm\Bachelor-Gorm\dynare_model.mod"
 
# Generated experiment .mod files and PNG plots are written here.
const OUT_DIR = @__DIR__
 
# Sensitivity grids.
const SIGMA_GRID = [1.5, 2.0, 3.0, 4.0]
const CHI_GRID   = [0.8, 1.0, 1.2]
const PHIK_GRID  = [0.1, 0.5, 1.0, 2.0, 5.0]
const PHIL_GRID =  [0.05, 0.2, 0.5, 0.7]
const RAMP_GRID  = [0, 10, 20, 30]  
 
# Simulation horizon and terminal subsidy level (must match
# what the baseline .mod file targets in its endval block).
const PERIODS    = 300
const S_TERMINAL = 0.20
 
# Discount factor used in the welfare metric. Mirrors
# `beta_disc` in dynare_model.mod.
const BASE_BETA_DISC = 0.96
 
 
# ================================================================
# 2. Utility helpers
# ================================================================
 

safe_name(x) = replace(string(x), "." => "_")
 
 
function check_base_file()
    isfile(BASE_MODFILE) || error("Cannot find BASE_MODFILE: $(BASE_MODFILE)")
end
 
 
function run_dynare_file(modfile::String)
    expr = Meta.parse("@dynare $(repr(modfile))")
    return Core.eval(@__MODULE__, expr)
end
 
 
# ================================================================
# 3. Programmatic .mod file generation
# ================================================================
 

function replace_parameter(mod_text::String, param_name::String, value)
    pattern     = Regex("(?m)^\\s*$(param_name)\\s*=\\s*[-+0-9.eE]+\\s*;")
    replacement = "$(param_name) = $(value);"
 
    occursin(pattern, mod_text) ||
        error("Could not find parameter assignment for $(param_name)")
 
    return replace(mod_text, pattern => replacement)
end
 
 
function remove_old_perfect_foresight_block(mod_text::String)
    pattern = Regex(
        "(?s)perfect_foresight_setup\\s*\\([^;]*\\)\\s*;\\s*" *
        "perfect_foresight_solver\\s*[^;]*;"
    )
    return replace(mod_text, pattern => "")
end
 
 
function add_perfect_foresight_block(mod_text::String; periods::Int=PERIODS)
    block = """
 
    // =============================================================
    // Perfect foresight simulation added by experiments.jl
    // =============================================================
 
    perfect_foresight_setup(periods=$(periods));
    perfect_foresight_solver;
 
    """
    return mod_text * block
end
 
 
function build_experiment_modfile(param_name::String, value)
    check_base_file()
 
    base_text = read(BASE_MODFILE, String)
    mod_text  = replace_parameter(base_text, param_name, value)
    mod_text  = remove_old_perfect_foresight_block(mod_text)
    mod_text  = add_perfect_foresight_block(mod_text; periods=PERIODS)
 
    filename = "exp_$(param_name)_$(safe_name(value)).mod"
    filepath = joinpath(OUT_DIR, filename)
    write(filepath, mod_text)
    return filepath
end
 
 
function build_ramp_modfile(ramp_periods::Int)
    check_base_file()
 
    base_text = read(BASE_MODFILE, String)
    mod_text  = remove_old_perfect_foresight_block(base_text)
 
    if ramp_periods > 0
        period_list = join(1:ramp_periods, " ")
        value_list  = join((S_TERMINAL * t / ramp_periods for t in 1:ramp_periods), " ")
 
        shocks_block = """
 
        // =============================================================
        // Gradual subsidy ramp added by experiments.jl
        // =============================================================
 
        shocks;
            var s;
            periods $(period_list);
            values $(value_list);
        end;
 
        """
        mod_text *= shocks_block
    end
 
    mod_text = add_perfect_foresight_block(mod_text; periods=PERIODS)
 
    filepath = joinpath(OUT_DIR, "exp_ramp_$(ramp_periods).mod")
    write(filepath, mod_text)
    return filepath
end
 
 
# ================================================================
# 4. Reading simulation results
# ================================================================
 

function read_simulations(vars)
    out = Dict{String,Vector{Float64}}()
    for v in vars
        x = simulation(v)
        out[string(v)] = vec(Float64.(Array(x)))
    end
    return out
end
 
 
function run_simulation(modfile::String)
    run_dynare_file(modfile)
 
    vars = (:C, :K, :Y, :I, :renewable_share, :K1, :K2, :L1, :L2)
    return read_simulations(vars)
end
 
 
# ================================================================
# 5. Experiment loops
# ================================================================
 

function run_grid(grid, param_name::String)
    results = Dict{Float64,Dict{String,Vector{Float64}}}()
 
    for v in grid
        try
            modfile = build_experiment_modfile(param_name, v)
            results[Float64(v)] = run_simulation(modfile)
            println("SUCCESS: ", param_name, " = ", v)
        catch err
            println("FAILED:  ", param_name, " = ", v)
            println(err)
        end
    end
 
    return results
end
 
 
exp_sigma() = run_grid(SIGMA_GRID, "sigma")
exp_chi()   = run_grid(CHI_GRID,   "chi")
exp_phiK()  = run_grid(PHIK_GRID,  "phiK")
exp_phiL()  = run_grid(PHIL_GRID,  "phiL")
 
 
function exp_gradual()
    results = Dict{Int,Dict{String,Vector{Float64}}}()
 
    for r in RAMP_GRID
        try
            modfile = build_ramp_modfile(r)
            results[r] = run_simulation(modfile)
            println("SUCCESS: ramp = ", r)
        catch err
            println("FAILED:  ramp = ", r)
            println(err)
        end
    end
 
    return results
end
 
 
# ================================================================
# 6. Outcome metrics
# ================================================================
 

function compute_metrics(traj::Dict{String,Vector{Float64}},
                         beta_disc::Float64)
 
    C = traj["C"]
    return (
        delta_C = C[end] - C[1],
        C_min   = minimum(C),
        welfare = sum(beta_disc^(t-1) * log(C[t]) for t in 1:length(C)),
        rs_init = traj["renewable_share"][1],
        rs_term = traj["renewable_share"][end],
    )
end
 
 
# ================================================================
# 7. Plotting helpers
# ================================================================
 

function plot_transition(grid, results,
                         varname::String, ylabel::String;
                         title::String       = "",
                         param_label::String = "",
                         outfile::String     = "")
 
    grid_present = filter(v -> haskey(results, Float64(v)) || haskey(results, v), grid)
 
    if isempty(grid_present)
        println("No successful simulations for plot: ", title)
        return nothing
    end
 
    p = plot(
        title  = title,
        xlabel = "Period",
        ylabel = ylabel,
        legend = :bottomright,
    )
 
    for v in grid_present
        key = haskey(results, Float64(v)) ? Float64(v) : v
        plot!(p, results[key][varname];
              label     = string(param_label, "=", v),
              linewidth = 2)
    end
 
    if !isempty(outfile)
        savefig(p, joinpath(OUT_DIR, outfile))
        println("Saved: ", outfile)
    end
 
    return p
end
 
 
function plot_long_run(grid, results, param_label::String;
                       outfile::String="")
 
    grid_present = filter(v -> haskey(results, Float64(v)), grid)
 
    if isempty(grid_present)
        println("No successful simulations for long-run plot: ", param_label)
        return nothing
    end
 
    delta_C = [
        results[Float64(v)]["C"][end] - results[Float64(v)]["C"][1]
        for v in grid_present
    ]
 
    delta_rs = [
        results[Float64(v)]["renewable_share"][end] -
        results[Float64(v)]["renewable_share"][1]
        for v in grid_present
    ]
 
    p1 = plot(grid_present, delta_C;
              xlabel    = param_label,
              ylabel    = "ΔC",
              title     = "Long-run consumption gain",
              marker    = :circle,
              linewidth = 2,
              label     = "")
 
    p2 = plot(grid_present, delta_rs;
              xlabel    = param_label,
              ylabel    = "Δ renewable share",
              title     = "Long-run renewable share gain",
              marker    = :circle,
              linewidth = 2,
              label     = "")
 
    combined = plot(p1, p2; layout=(1, 2), size=(900, 350))
 
    if !isempty(outfile)
        savefig(combined, joinpath(OUT_DIR, outfile))
        println("Saved: ", outfile)
    end
 
    return combined
end
 
 
# ================================================================
# 8. Main
# ================================================================
 
function main()
    println("Checking baseline file...")
    check_base_file()
    println("Found baseline file: ", BASE_MODFILE)
 
    # ---- Part A1: elasticity of substitution sigma ----
    println()
    println("=== Part A1: sigma ===")
    res_sigma = exp_sigma()
    plot_long_run(SIGMA_GRID, res_sigma, "σ";
                  outfile="plot_sigma_longrun.png")
    plot_transition(SIGMA_GRID, res_sigma,
                    "renewable_share", "Renewable share";
                    title       = "Renewable share by σ",
                    param_label = "σ",
                    outfile     = "plot_sigma_rs.png")
 
    # ---- Part A2: energy efficiency chi ----
    println()
    println("=== Part A2: chi ===")
    res_chi = exp_chi()
    plot_long_run(CHI_GRID, res_chi, "χ";
                  outfile="plot_chi_longrun.png")
 
    # ---- Part B1: capital adjustment cost phi_K ----
    println()
    println("=== Part B1: phi_K ===")
    res_phiK = exp_phiK()
    plot_transition(PHIK_GRID, res_phiK, "C", "Consumption";
                    title="Consumption by φ_K", param_label="φ_K",
                    outfile="plot_phiK_C.png")
    plot_transition(PHIK_GRID, res_phiK, "renewable_share", "Renewable share";
                    title="Renewable share by φ_K", param_label="φ_K",
                    outfile="plot_phiK_rs.png")
    plot_transition(PHIK_GRID, res_phiK, "K", "Capital";
                    title="Capital by φ_K", param_label="φ_K",
                    outfile="plot_phiK_K.png")
 
    # ---- Part B2: labor adjustment cost phi_L ----
    println()
    println("=== Part B2: phi_L ===")
    res_phiL = exp_phiL()
    plot_transition(PHIL_GRID, res_phiL, "C", "Consumption";
                    title="Consumption by φ_L", param_label="φ_L",
                    outfile="plot_phiL_C.png")
 
    # ---- Part C: gradual subsidy ramp ----
    println()
    println("=== Part C: gradual subsidy ===")
    res_ramp = exp_gradual()
    plot_transition(RAMP_GRID, res_ramp, "C", "Consumption";
                    title="Consumption by ramp length", param_label="ramp",
                    outfile="plot_ramp_C.png")
    plot_transition(RAMP_GRID, res_ramp, "renewable_share", "Renewable share";
                    title="Renewable share by ramp length", param_label="ramp",
                    outfile="plot_ramp_rs.png")
 
    # ---- Welfare summary for Part C ----
    println()
    println("=== Welfare by ramp length ===")
    @printf "%-8s %-12s %-12s %-12s\n" "ramp" "ΔC" "C_min" "welfare"
    for r in RAMP_GRID
        haskey(res_ramp, r) || continue
        m = compute_metrics(res_ramp[r], BASE_BETA_DISC)
        @printf "%-8d %-12.5f %-12.5f %-12.4f\n" r m.delta_C m.C_min m.welfare
    end
end
 
 
main()