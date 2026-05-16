using Dynare, Plots

cd("C:/Bachelor-Gorm/Bachelor-Gorm")
context = @dynare "dynare_model.mod"

sim = context.results.model_results[1].simulations[1]
data = sim.data

T = size(data, 1)
period = 1:T

# Pomocnicza funkcja konwertująca do zwykłego wektora
v(col) = collect(skipmissing(data[col]))

mkpath("dynare_model/graphs")

plot(period[1:length(v(:C))], v(:C), label="Consumption",
     title="Household Consumption", xlabel="Period", lw=2, color=:blue)
savefig("dynare_model/graphs/figure_1_consumption.png")

plot(period[1:length(v(:Y))], v(:Y), label="Output",
     title="Aggregate Output", xlabel="Period", lw=2, color=:green)
savefig("dynare_model/graphs/figure_2_output.png")

plot(period[1:length(v(:renewable_share))], v(:renewable_share),
     label="Renewable Share", title="Renewable Energy Share",
     xlabel="Period", lw=2, color=:orange)
savefig("dynare_model/graphs/figure_3_renewable.png")

plot(period[1:length(v(:K))], v(:K), label="Capital",
     title="Aggregate Capital", xlabel="Period", lw=2, color=:purple)
savefig("dynare_model/graphs/figure_4_capital.png")

plot(period[1:length(v(:I))], v(:I), label="Investment",
     title="Investment", xlabel="Period", lw=2, color=:red)
savefig("dynare_model/graphs/figure_5_investment.png")

plot(period[1:length(v(:Er))], v(:Er), label="Renewable Energy", lw=2, color=:green)
plot!(period[1:length(v(:Ef))], v(:Ef), label="Fossil Energy",
      title="Energy Demand", xlabel="Period", lw=2, color=:brown)
savefig("dynare_model/graphs/figure_6_energy.png")

println("✓ Wszystkie wykresy zapisane!")