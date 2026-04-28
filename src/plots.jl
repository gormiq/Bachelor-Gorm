using Plots
gr()

function plot_renewable_share(results)
    s = [r.subsidy for r in results]
    share = [r.renewable_share for r in results]

    p = plot(
        s, share;
        xlabel = "Renewable subsidy, s",
        ylabel = "Renewable share",
        title = "Renewable Energy Share",
        linewidth = 2,
        legend = false,
        size = (800, 500)
    )

    display(p)
    savefig(p, "figure1_renewable_share.png")
    println("Saved figure1_renewable_share.png")
end

function plot_aggregate_output(results)
    s = [r.subsidy for r in results]
    Y = [r.Y for r in results]

    p = plot(
        s, Y;
        xlabel = "Renewable subsidy, s",
        ylabel = "Aggregate output",
        title = "Aggregate Output",
        linewidth = 2,
        legend = false,
        size = (800, 500)
    )

    display(p)
    savefig(p, "figure2_aggregate_output.png")
    println("Saved figure2_aggregate_output.png")
end

function plot_sectoral_output(results)
    s = [r.subsidy for r in results]
    Y1 = [r.Y1 for r in results]
    Y2 = [r.Y2 for r in results]

    p = plot(
        s, Y1;
        xlabel = "Renewable subsidy, s",
        ylabel = "Sectoral output",
        title = "Sectoral Output",
        label = "Sector 1",
        linewidth = 2,
        size = (800, 500)
    )

    plot!(
        p, s, Y2;
        label = "Sector 2",
        linewidth = 2
    )

    display(p)
    savefig(p, "figure3_sectoral_output.png")
    println("Saved figure3_sectoral_output.png")
end

function plot_energy_prices(results)
    s = [r.subsidy for r in results]
    PE1 = [r.PE1 for r in results]
    PE2 = [r.PE2 for r in results]

    p = plot(
        s, PE1;
        xlabel = "Renewable subsidy, s",
        ylabel = "Energy price index",
        title = "Sectoral Energy Prices",
        label = "Sector 1",
        linewidth = 2,
        size = (800, 500)
    )

    plot!(
        p, s, PE2;
        label = "Sector 2",
        linewidth = 2
    )

    display(p)
    savefig(p, "figure4_sectoral_energy_prices.png")
    println("Saved figure4_sectoral_energy_prices.png")
end

function plot_sensitivity_sigma(results_base, results_low)
    s_base = [r.subsidy for r in results_base]
    share_base = [r.renewable_share for r in results_base]

    s_low = [r.subsidy for r in results_low]
    share_low = [r.renewable_share for r in results_low]

    p = plot(
        s_base, share_base;
        xlabel = "Renewable subsidy, s",
        ylabel = "Renewable share",
        title = "Sensitivity to Elasticity of Substitution",
        label = "σ = 2 (baseline)",
        linewidth = 2,
        size = (800, 500)
    )

    plot!(
        p, s_low, share_low;
        label = "σ = 1.2",
        linewidth = 2
    )

    display(p)
    savefig(p, "figure5_sensitivity_sigma.png")
    println("Saved figure5_sensitivity_sigma.png")
end