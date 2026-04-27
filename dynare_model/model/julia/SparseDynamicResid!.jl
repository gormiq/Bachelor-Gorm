function SparseDynamicResid!(T::Vector{<: Real}, residual::AbstractVector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real}, steady_state::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(residual) == 1
    @assert length(y) == 3
    @assert length(x) == 1
    @assert length(params) == 1
@inbounds begin
    residual[1] = (y[2]) - (params[1]*y[1]+x[1]);
end
    return nothing
end

