function SparseStaticG1!(T::Vector{<: Real}, g1_v::Vector{<: Real}, y::Vector{<: Real}, x::Vector{<: Real}, params::Vector{<: Real})
    @assert length(T) >= 0
    @assert length(g1_v) == 1
    @assert length(y) == 1
    @assert length(x) == 1
    @assert length(params) == 1
@inbounds begin
g1_v[1]=1-params[1];
end
    return nothing
end

