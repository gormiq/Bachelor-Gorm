##############################################################
# This file runs the numerical experiment used in the thesis.
#
# For a given set of parameters the code solves the model for
# different values of the renewable energy subsidy.
#
# The output is a list of results. Each element of the list
# contains the equilibrium values for one subsidy level.
##############################################################


##############################################################
# Run simulation over a grid of subsidy values
##############################################################
#
# Arguments:
# - params: model parameters from baseline_parameters()
# - s_min: lowest subsidy value
# - s_max: highest subsidy value
# - n: number of subsidy values between s_min and s_max
#
# Example:
# results = run_simulation(params, s_min = 0.0, s_max = 0.5, n = 6)
#
# This solves the model for:
# s = 0.0, 0.1, 0.2, 0.3, 0.4, 0.5

function run_simulation(params; s_min = 0.0, s_max = 0.5, n = 11)

    # Create a grid of subsidy values
    s_values = range(s_min, s_max, length = n)

    # Empty list for storing model results
    results = []

    # Solve the model for each subsidy level
    for s in s_values
        result = solve_model(s, params)
        push!(results, result)
    end

    return results
end