include("model.jl")
include("simulation.jl")
include("plots.jl")

params = baseline_parameters()

results = run_simulation(params, s_min = 0.0, s_max = 0.5, n = 6)

plot_renewable_share(results)
plot_aggregate_output(results)
plot_sectoral_output(results)
plot_energy_prices(results)