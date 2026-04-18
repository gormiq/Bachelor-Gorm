using Plots
gr()

function extract_series(results)
    subsidies = [r.subsidy for r in results]
    renewable_share = [r.renewable_share for r in results]
    Y = [r.Y for r in results]
    Y1 = [r.Y1 for r in results]
    Y2 = [r.Y2 for r in results]
    PE1 = [r.PE1 for r in results]
    PE2 = [r.PE2 for r in results]

    return (
        subsidies = subsidies,
        renewable_share = renewable_share,
        Y = Y,
        Y1 = Y1,
        Y2 = Y2,
        PE1 = PE1,
        PE2 = PE2
    )
end

function plot_renewable_share(results)
    data = extract_series(results)

    p = plot(
        data.subsidies,
        data.renewable_share;
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
    return p
end

function plot_aggregate_output(results)
    data = extract_series(results)

    p = plot(
        data.subsidies,
        data.Y;
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
    return p
end

function plot_sectoral_output(results)
    data = extract_series(results)

    p = plot(
        data.subsidies,
        data.Y1;
        xlabel = "Renewable subsidy, s",
        ylabel = "Sectoral output",
        title = "Sectoral Output",
        label = "Sector 1",
        linewidth = 2,
        size = (800, 500)
    )

    plot!(
        p,
        data.subsidies,
        data.Y2;
        label = "Sector 2",
        linewidth = 2
    )

    display(p)
    savefig(p, "figure3_sectoral_output.png")
    println("Saved figure3_sectoral_output.png")
    return p
end

function plot_energy_prices(results)
    data = extract_series(results)

    p = plot(
        data.subsidies,
        data.PE1;
        xlabel = "Renewable subsidy, s",
        ylabel = "Energy price index",
        title = "Sectoral Energy Prices",
        label = "Sector 1",
        linewidth = 2,
        size = (800, 500)
    )

    plot!(
        p,
        data.subsidies,
        data.PE2;
        label = "Sector 2",
        linewidth = 2
    )

    display(p)
    savefig(p, "figure4_sectoral_energy_prices.png")
    println("Saved figure4_sectoral_energy_prices.png")
    return p
end