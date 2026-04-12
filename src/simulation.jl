function run_simulation(params; s_min = 0.0, s_max = 0.5, n = 11)
    s_values = range(s_min, s_max, length = n)
    results = []

    for s in s_values
        result = solve_model(s, params)
        push!(results, result)
    end

    return results
end