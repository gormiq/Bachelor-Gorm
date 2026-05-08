#################################################################
# run_experiments.jl
#
# Wrapper for running the Dynare steady-state model many times.
#
# It:
# 1. reads dynare_model.mod,
# 2. changes selected calibration values,
# 3. saves a unique temporary .mod file for each scenario,
# 4. runs Dynare,
# 5. reads the steady-state table from Dynare output,
# 6. saves results and produces clean plots.
#################################################################

using Printf
using Dates
using Plots


#################################################################
# 1. Files
#################################################################

BASE_MOD_FILE = "dynare_model.mod"
RESULTS_CSV   = "dynare_results.csv"

# The temporary file name changes for every scenario.
# This avoids Windows / OneDrive file-locking problems.
TEMP_MOD_FILE = Ref("")


#################################################################
# 2. Plot style
#################################################################

function set_plot_style()
    default(
        size = (850, 520),
        dpi = 300,
        linewidth = 2.5,
        markerstrokewidth = 0,
        markersize = 5,
        framestyle = :box,
        grid = true,
        legendfontsize = 9,
        tickfontsize = 9,
        guidefontsize = 11,
        titlefontsize = 13,
        fontfamily = "Computer Modern"
    )
end


#################################################################
# 3. Read base Dynare model
#################################################################

function read_base_model()
    if !isfile(BASE_MOD_FILE)
        error("Base Dynare file not found: $BASE_MOD_FILE")
    end

    return read(BASE_MOD_FILE, String)
end


#################################################################
# 4. Replace parameter or exogenous values in the .mod file
#################################################################
#
# Important:
# This function avoids regex backreferences such as \1.
# Earlier, that caused broken lines like:
#
#     \10.0;
#
#################################################################

function replace_assignment(model_text::String, name::String, value::Float64)

    pattern = Regex(
        "(?m)^\\s*" *
        name *
        "\\s*=\\s*[-+]?[0-9]*\\.?[0-9]+([eE][-+]?[0-9]+)?\\s*;"
    )

    replacement = "    " * name * " = " * string(value) * ";"

    new_text = replace(model_text, pattern => replacement)

    if new_text == model_text
        error("Could not find assignment for variable/parameter: $name")
    end

    return new_text
end


#################################################################
# 5. Create unique temporary Dynare model
#################################################################

function number_to_filename_part(x::Float64)
    return replace(string(x), "." => "_", "-" => "minus_")
end


function create_temp_model(;
    s_value = 0.0,
    sigma_value = 2.0,
    omega1_value = 0.70,
    omega2_value = 0.40
)

    model_text = read_base_model()

    model_text = replace_assignment(model_text, "s", s_value)
    model_text = replace_assignment(model_text, "sigma", sigma_value)
    model_text = replace_assignment(model_text, "omega1", omega1_value)
    model_text = replace_assignment(model_text, "omega2", omega2_value)

    s_txt      = number_to_filename_part(s_value)
    sigma_txt  = number_to_filename_part(sigma_value)
    omega1_txt = number_to_filename_part(omega1_value)
    omega2_txt = number_to_filename_part(omega2_value)

    timestamp = Dates.format(now(), "yyyymmdd_HHMMSS_s")

    temp_file =
        "dynare_temp_s$(s_txt)_sig$(sigma_txt)_om1$(omega1_txt)_om2$(omega2_txt)_$(timestamp).mod"

    TEMP_MOD_FILE[] = temp_file

    write(temp_file, model_text)

    temp_lines = split(read(temp_file, String), "\n")

    for (i, line) in enumerate(temp_lines)
        if occursin("\\", line) && !startswith(strip(line), "//")
            println("WARNING: possible problematic backslash in temporary .mod file.")
            println("File: $temp_file")
            println("Line $i: $line")
        end
    end

    return nothing
end


#################################################################
# 6. Run Dynare and capture output
#################################################################

function run_dynare()
    dynare_command = """
    using Dynare
    @dynare "$(TEMP_MOD_FILE[])"
    """

    cmd = `$(Base.julia_cmd()) -e $dynare_command`

    out_buf = IOBuffer()
    err_buf = IOBuffer()

    run(pipeline(cmd, stdout = out_buf, stderr = err_buf))

    out_str = String(take!(out_buf))
    err_str = String(take!(err_buf))

    output = out_str * "\n" * err_str

    return output
end


#################################################################
# 7. Extract steady-state values from Dynare output
#################################################################

function parse_steady_state(output::String)

    results = Dict{String, Float64}()

    clean_output = replace(output, r"\e\[[0-9;]*m" => "")

    for line in split(clean_output, "\n")

        if !occursin("│", line)
            continue
        end

        parts = split(line, "│")

        if length(parts) != 2
            continue
        end

        name = strip(parts[1])
        value_text = strip(parts[2])

        if !occursin(r"^[A-Za-z_][A-Za-z0-9_]*$", name)
            continue
        end

        try
            value = parse(Float64, value_text)
            results[name] = value
        catch
            continue
        end
    end

    println("Variables read from Dynare steady state:")
    println(sort(collect(keys(results))))

    return results
end


#################################################################
# 8. Run one scenario
#################################################################

function run_one_scenario(;
    s_value = 0.0,
    sigma_value = 2.0,
    omega1_value = 0.70,
    omega2_value = 0.40
)

    println("------------------------------------------------------")
    println("Running scenario:")
    println("s      = $s_value")
    println("sigma  = $sigma_value")
    println("omega1 = $omega1_value")
    println("omega2 = $omega2_value")
    println("------------------------------------------------------")

    create_temp_model(
        s_value = s_value,
        sigma_value = sigma_value,
        omega1_value = omega1_value,
        omega2_value = omega2_value
    )

    output = run_dynare()

    ss = parse_steady_state(output)

    required_variables = [
        "Y",
        "Y1",
        "Y2",
        "C",
        "I",
        "K",
        "Ef",
        "Er",
        "renewable_share",
        "T",
        "PE1",
        "PE2"
    ]

    for variable in required_variables
        if !haskey(ss, variable)

            println(output)

            println("======================================================")
            println("Dynare did not return steady-state variable: $variable")
            println("This means the temporary Dynare model did not solve or the output was not parsed.")
            println("Check file: $(TEMP_MOD_FILE[])")
            println("Current parameters:")
            println("s      = $s_value")
            println("sigma  = $sigma_value")
            println("omega1 = $omega1_value")
            println("omega2 = $omega2_value")
            println("======================================================")

            error("Missing steady-state variable: $variable")
        end
    end

    return ss
end


#################################################################
# 9. Store one result row
#################################################################

function make_result_row(experiment, s_value, sigma_value, omega1_value, omega2_value, ss)

    return (
        experiment = experiment,
        s = s_value,
        sigma = sigma_value,
        omega1 = omega1_value,
        omega2 = omega2_value,

        Y = ss["Y"],
        Y1 = ss["Y1"],
        Y2 = ss["Y2"],
        output_gap = ss["Y2"] - ss["Y1"],

        C = ss["C"],
        I = ss["I"],
        K = ss["K"],

        Ef = ss["Ef"],
        Er = ss["Er"],
        renewable_share = ss["renewable_share"],

        T = ss["T"],

        PE1 = ss["PE1"],
        PE2 = ss["PE2"]
    )
end


#################################################################
# 10. Baseline subsidy experiment
#################################################################

function baseline_subsidy_experiment()

    s_grid = collect(0.0:0.05:0.50)

    results = []

    for s_value in s_grid

        println("Running baseline subsidy scenario: s = $s_value")

        sigma_value = 2.0
        omega1_value = 0.70
        omega2_value = 0.40

        ss = run_one_scenario(
            s_value = s_value,
            sigma_value = sigma_value,
            omega1_value = omega1_value,
            omega2_value = omega2_value
        )

        push!(
            results,
            make_result_row(
                "baseline_subsidy",
                s_value,
                sigma_value,
                omega1_value,
                omega2_value,
                ss
            )
        )
    end

    return results
end


#################################################################
# 11. Sensitivity analysis: elasticity of substitution
#################################################################

function sigma_sensitivity_experiment()

    s_grid = collect(0.0:0.05:0.50)

    sigma_grid = [1.2, 2.0, 5.0]

    results = []

    for sigma_value in sigma_grid

        for s_value in s_grid

            println("Running sigma sensitivity: sigma = $sigma_value, s = $s_value")

            omega1_value = 0.70
            omega2_value = 0.40

            ss = run_one_scenario(
                s_value = s_value,
                sigma_value = sigma_value,
                omega1_value = omega1_value,
                omega2_value = omega2_value
            )

            push!(
                results,
                make_result_row(
                    "sigma_sensitivity",
                    s_value,
                    sigma_value,
                    omega1_value,
                    omega2_value,
                    ss
                )
            )
        end
    end

    return results
end


#################################################################
# 12. Sensitivity analysis: sectoral heterogeneity
#################################################################

function heterogeneity_sensitivity_experiment()

    s_grid = collect(0.0:0.05:0.50)

    scenarios = [
        (
            label = "small_difference",
            omega1 = 0.60,
            omega2 = 0.50
        ),
        (
            label = "baseline_difference",
            omega1 = 0.70,
            omega2 = 0.40
        ),
        (
            label = "large_difference",
            omega1 = 0.90,
            omega2 = 0.20
        )
    ]

    results = []

    for scenario in scenarios

        for s_value in s_grid

            println(
                "Running heterogeneity sensitivity: " *
                scenario.label *
                ", s = $s_value"
            )

            sigma_value = 2.0
            omega1_value = scenario.omega1
            omega2_value = scenario.omega2

            ss = run_one_scenario(
                s_value = s_value,
                sigma_value = sigma_value,
                omega1_value = omega1_value,
                omega2_value = omega2_value
            )

            push!(
                results,
                make_result_row(
                    scenario.label,
                    s_value,
                    sigma_value,
                    omega1_value,
                    omega2_value,
                    ss
                )
            )
        end
    end

    return results
end


#################################################################
# 13. Save results to CSV
#################################################################

function save_results(results)

    open(RESULTS_CSV, "w") do io

        println(
            io,
            "experiment,s,sigma,omega1,omega2,Y,Y1,Y2,output_gap,C,I,K,Ef,Er,renewable_share,T,PE1,PE2"
        )

        for r in results
            println(
                io,
                "$(r.experiment),$(r.s),$(r.sigma),$(r.omega1),$(r.omega2),$(r.Y),$(r.Y1),$(r.Y2),$(r.output_gap),$(r.C),$(r.I),$(r.K),$(r.Ef),$(r.Er),$(r.renewable_share),$(r.T),$(r.PE1),$(r.PE2)"
            )
        end
    end

    println("Saved results to $RESULTS_CSV")
end


#################################################################
# 14. Helper functions for plots
#################################################################

function baseline_results(results)
    return filter(r -> r.experiment == "baseline_subsidy", results)
end


function save_clean_plot(filename)
    savefig(filename)
    println("Saved plot: $filename")
end


#################################################################
# 15. Baseline plots
#################################################################

function plot_baseline_renewable_share(results)

    data = baseline_results(results)

    plot(
        [r.s for r in data],
        [r.renewable_share for r in data],
        xlabel = "Renewable subsidy, s",
        ylabel = "Renewable share",
        title = "Renewable Energy Share",
        marker = :circle,
        legend = false
    )

    save_clean_plot("figure_1_renewable_share.png")
end


function plot_baseline_output(results)

    data = baseline_results(results)

    plot(
        [r.s for r in data],
        [r.Y for r in data],
        xlabel = "Renewable subsidy, s",
        ylabel = "Aggregate output",
        title = "Aggregate Output",
        marker = :circle,
        legend = false
    )

    save_clean_plot("figure_2_aggregate_output.png")
end


function plot_baseline_sectoral_output(results)

    data = baseline_results(results)

    plot(
        [r.s for r in data],
        [r.Y1 for r in data],
        xlabel = "Renewable subsidy, s",
        ylabel = "Sectoral output",
        title = "Sectoral Output",
        label = "Sector 1",
        marker = :circle
    )

    plot!(
        [r.s for r in data],
        [r.Y2 for r in data],
        label = "Sector 2",
        marker = :circle
    )

    save_clean_plot("figure_3_sectoral_output.png")
end


function plot_baseline_energy_prices(results)

    data = baseline_results(results)

    plot(
        [r.s for r in data],
        [r.PE1 for r in data],
        xlabel = "Renewable subsidy, s",
        ylabel = "Energy price index",
        title = "Sectoral Energy Prices",
        label = "Sector 1",
        marker = :circle
    )

    plot!(
        [r.s for r in data],
        [r.PE2 for r in data],
        label = "Sector 2",
        marker = :circle
    )

    save_clean_plot("figure_4_sectoral_energy_prices.png")
end


function plot_baseline_consumption(results)

    data = baseline_results(results)

    plot(
        [r.s for r in data],
        [r.C for r in data],
        xlabel = "Renewable subsidy, s",
        ylabel = "Consumption",
        title = "Consumption",
        marker = :circle,
        legend = false
    )

    save_clean_plot("figure_5_consumption.png")
end


#################################################################
# 16. Sensitivity plots: elasticity of substitution
#################################################################

function plot_sigma_sensitivity_renewable_share(results)

    data = filter(r -> r.experiment == "sigma_sensitivity", results)

    sigma_values = sort(unique([r.sigma for r in data]))

    first_sigma = sigma_values[1]

    first_data = filter(r -> r.sigma == first_sigma, data)

    plot(
        [r.s for r in first_data],
        [r.renewable_share for r in first_data],
        xlabel = "Renewable subsidy, s",
        ylabel = "Renewable share",
        title = "Sensitivity to Elasticity of Substitution",
        label = "σ = $(first_sigma)",
        marker = :circle
    )

    for sigma_value in sigma_values[2:end]

        sigma_data = filter(r -> r.sigma == sigma_value, data)

        plot!(
            [r.s for r in sigma_data],
            [r.renewable_share for r in sigma_data],
            label = "σ = $(sigma_value)",
            marker = :circle
        )
    end

    save_clean_plot("figure_6_sensitivity_sigma_renewable_share.png")
end


function plot_sigma_sensitivity_output(results)

    data = filter(r -> r.experiment == "sigma_sensitivity", results)

    sigma_values = sort(unique([r.sigma for r in data]))

    first_sigma = sigma_values[1]

    first_data = filter(r -> r.sigma == first_sigma, data)

    plot(
        [r.s for r in first_data],
        [r.Y for r in first_data],
        xlabel = "Renewable subsidy, s",
        ylabel = "Aggregate output",
        title = "Output Sensitivity to Elasticity of Substitution",
        label = "σ = $(first_sigma)",
        marker = :circle
    )

    for sigma_value in sigma_values[2:end]

        sigma_data = filter(r -> r.sigma == sigma_value, data)

        plot!(
            [r.s for r in sigma_data],
            [r.Y for r in sigma_data],
            label = "σ = $(sigma_value)",
            marker = :circle
        )
    end

    save_clean_plot("figure_7_sensitivity_sigma_output.png")
end


#################################################################
# 17. Sensitivity plots: sectoral heterogeneity
#################################################################

function scenario_label(name::String)

    if name == "small_difference"
        return "Small difference"
    elseif name == "baseline_difference"
        return "Baseline"
    elseif name == "large_difference"
        return "Large difference"
    else
        return name
    end
end


function plot_heterogeneity_output_gap(results)

    data = filter(
        r ->
            r.experiment == "small_difference" ||
            r.experiment == "baseline_difference" ||
            r.experiment == "large_difference",
        results
    )

    scenario_names = unique([r.experiment for r in data])

    first_scenario = scenario_names[1]

    first_data = filter(r -> r.experiment == first_scenario, data)

    plot(
        [r.s for r in first_data],
        [r.output_gap for r in first_data],
        xlabel = "Renewable subsidy, s",
        ylabel = "Sectoral output gap, Y₂ - Y₁",
        title = "Sectoral Output Gap",
        label = scenario_label(first_scenario),
        marker = :circle
    )

    for scenario in scenario_names[2:end]

        scenario_data = filter(r -> r.experiment == scenario, data)

        plot!(
            [r.s for r in scenario_data],
            [r.output_gap for r in scenario_data],
            label = scenario_label(scenario),
            marker = :circle
        )
    end

    save_clean_plot("figure_8_sensitivity_heterogeneity_output_gap.png")
end


function plot_heterogeneity_renewable_share(results)

    data = filter(
        r ->
            r.experiment == "small_difference" ||
            r.experiment == "baseline_difference" ||
            r.experiment == "large_difference",
        results
    )

    scenario_names = unique([r.experiment for r in data])

    first_scenario = scenario_names[1]

    first_data = filter(r -> r.experiment == first_scenario, data)

    plot(
        [r.s for r in first_data],
        [r.renewable_share for r in first_data],
        xlabel = "Renewable subsidy, s",
        ylabel = "Renewable share",
        title = "Renewable Share and Sectoral Heterogeneity",
        label = scenario_label(first_scenario),
        marker = :circle
    )

    for scenario in scenario_names[2:end]

        scenario_data = filter(r -> r.experiment == scenario, data)

        plot!(
            [r.s for r in scenario_data],
            [r.renewable_share for r in scenario_data],
            label = scenario_label(scenario),
            marker = :circle
        )
    end

    save_clean_plot("figure_9_sensitivity_heterogeneity_renewable_share.png")
end


#################################################################
# 18. Create all plots
#################################################################

function make_all_plots(results)

    set_plot_style()

    plot_baseline_renewable_share(results)
    plot_baseline_output(results)
    plot_baseline_sectoral_output(results)
    plot_baseline_energy_prices(results)
    plot_baseline_consumption(results)

    plot_sigma_sensitivity_renewable_share(results)
    plot_sigma_sensitivity_output(results)

    plot_heterogeneity_output_gap(results)
    plot_heterogeneity_renewable_share(results)
end


#################################################################
# 19. Main script
#################################################################

function main()

    println("Starting Dynare experiments...")

    all_results = []

    append!(all_results, baseline_subsidy_experiment())

    append!(all_results, sigma_sensitivity_experiment())

    append!(all_results, heterogeneity_sensitivity_experiment())

    save_results(all_results)

    make_all_plots(all_results)

    println("Finished all experiments.")
    println("Generated files:")
    println(" - $RESULTS_CSV")
    println(" - figure_1_renewable_share.png")
    println(" - figure_2_aggregate_output.png")
    println(" - figure_3_sectoral_output.png")
    println(" - figure_4_sectoral_energy_prices.png")
    println(" - figure_5_consumption.png")
    println(" - figure_6_sensitivity_sigma_renewable_share.png")
    println(" - figure_7_sensitivity_sigma_output.png")
    println(" - figure_8_sensitivity_heterogeneity_output_gap.png")
    println(" - figure_9_sensitivity_heterogeneity_renewable_share.png")
end


main()