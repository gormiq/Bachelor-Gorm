using Plots

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

    plot(
        data.subsidies,
        data.renewable_share,
        xlabel = "Renewable subsidy",
        ylabel = "Renewable share",
        title = "Renewable Share and Subsidy",
        label = "Renewable share",
        linewidth = 2
    )
end

function plot_aggregate_output(results)
    data = extract_series(results)

    plot(
        data.subsidies,
        data.Y,
        xlabel = "Renewable subsidy",
        ylabel = "Aggregate output",
        title = "Aggregate Output and Subsidy",
        label = "Aggregate output",
        linewidth = 2
    )
end

function plot_sectoral_output(results)
    data = extract_series(results)

    plot(
        data.subsidies,
        data.Y1,
        xlabel = "Renewable subsidy",
        ylabel = "Sectoral output",
        title = "Sectoral Output and Subsidy",
        label = "Sector 1",
        linewidth = 2
    )

    plot!(
        data.subsidies,
        data.Y2,
        label = "Sector 2",
        linewidth = 2
    )
end

function plot_energy_prices(results)
    data = extract_series(results)

    plot(
        data.subsidies,
        data.PE1,
        xlabel = "Renewable subsidy",
        ylabel = "Energy price index",
        title = "Sectoral Energy Prices and Subsidy",
        label = "Sector 1",
        linewidth = 2
    )

    plot!(
        data.subsidies,
        data.PE2,
        label = "Sector 2",
        linewidth = 2
    )
end