module ICD10Utilities

using CSV, TypedTables, Dates, CategoricalArrays, Missings
using FileIO

import Base: isless, show, (==)

export ICDOPTS

export AbstractICD10
export ICD10
export ICD10AM, ACHI
export ICD10CA, ICD10CM, ICD10GM
export ICD10AMAge
export icd3
export isvalidcode
export icd3, icd4

export ICD10AMcodes, ACHIcodes

const ICDOPTS = Dict(:punct => true)

abstract type AbstractICD10 end

Broadcast.broadcastable(icdcode::T) where {T<:AbstractICD10} = Ref(icdcode)

include("icd10.jl")
include("icd10fns.jl")
include("othericd10.jl")
include("achi.jl")
include("icd10amfns.jl")

end # module
