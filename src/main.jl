###############################################################
# This file runs the full numerical analysis.
#
# It loads the model, runs the simulations, and creates all
# figures used in Section 4 of the thesis.
###############################################################


include("model.jl")
include("simulation.jl")
include("plots.jl")


###############################################################
# Baseline simulation
###############################################################
# The model is solved for different values of the renewable
# energy subsidy. These are policy scenarios, not time periods.

params = baseline_parameters()

results = run_simulation(
    params,
    s_min = 0.0,
    s_max = 0.5,
    n = 6
)


###############################################################
# Baseline figures
###############################################################
# These figures use the baseline parameter values.

plot_renewable_share(results)
plot_aggregate_output(results)
plot_sectoral_output(results)
plot_energy_prices(results)
plot_consumption(results)


###############################################################
# Sensitivity analysis
###############################################################
# Here we change the elasticity of substitution between fossil
# and renewable energy from sigma = 2.0 to sigma = 1.2.
#
# This checks whether the main results depend on the value of
# the substitution elasticity.

params_base = baseline_parameters()
params_low_sigma = merge(params_base, (sigma = 1.2,))

results_base = run_simulation(
    params_base,
    s_min = 0.0,
    s_max = 0.5,
    n = 6
)

results_low = run_simulation(
    params_low_sigma,
    s_min = 0.0,
    s_max = 0.5,
    n = 6
)


# Figure for sensitivity analysis

plot_sensitivity_sigma(results_base, results_low)