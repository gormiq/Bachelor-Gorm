##############################################################
# This file creates and saves plots used in Section 4.
#
# Each function takes simulation results as input and produces
# one figure. The figures are saved as PNG files in the main
# project folder.
##############################################################

using Plots
gr()


##############################################################
# Helper function for saving plots
##############################################################
# This avoids repeating display(), savefig(), and println()
# in every plotting function, because i had this problem before.

function show_and_save(p, filename)
    display(p)
    savefig(p, filename)
    println("Saved ", filename)
end


##############################################################
# Figure 1: Renewable energy share
##############################################################

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

    show_and_save(p, "figure1_renewable_share.png")
end


##############################################################
# Figure 2: Aggregate output
##############################################################

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

    show_and_save(p, "figure2_aggregate_output.png")
end


##############################################################
# Figure 3: Sectoral output
##############################################################

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

    show_and_save(p, "figure3_sectoral_output.png")
end


##############################################################
# Figure 4: Sector-specific energy price indices
##############################################################

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

    show_and_save(p, "figure4_sectoral_energy_prices.png")
end


##############################################################
# Figure 5: Sensitivity analysis
##############################################################
# This compares the baseline elasticity of substitution
# with a lower value of sigma.

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
        label = "sigma = 2 (baseline)",
        linewidth = 2,
        size = (800, 500)
    )

    plot!(
        p, s_low, share_low;
        label = "sigma = 1.2",
        linewidth = 2
    )

    show_and_save(p, "figure5_sensitivity_sigma.png")
end


##############################################################
# Figure 6: Consumption
##############################################################

function plot_consumption(results)
    s = [r.subsidy for r in results]
    C = [r.C for r in results]

    p = plot(
        s, C;
        xlabel = "Renewable subsidy, s",
        ylabel = "Consumption",
        title = "Consumption",
        linewidth = 2,
        legend = false,
        size = (800, 500)
    )

    show_and_save(p, "figure6_consumption.png")
end