module POMP

## Time is the (abstract) type for times.
Time = Union{Int64,Float64}
RealTime = Float64

## LogLik is the type for log likelihoods, etc.
## We may at some point need more precision....
LogLik = Float64

include("reshape.jl")
include("constructor.jl")
include("helpers.jl")
include("rinit.jl")
include("rprocess.jl")
include("rmeasure.jl")
include("logdmeasure.jl")
include("simulate.jl")
include("resample.jl")
include("pfilter.jl")
include("melt.jl")

include("examples/Examples.jl")

end # module
