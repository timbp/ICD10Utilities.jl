module ICD10Utilities

using CSV, TypedTables, Dates, CategoricalArrays, Missings
using FileIO

import Base: isless, show, string, ==, convert, startswith

export AbstractICD10
export ICD10
export ICD10AM, ACHI
export ICD10CA, ICD10CM, ICD10GM
export ICD10AMAge
export icd3
export isvalidcode

abstract type AbstractICD10 end

Broadcast.broadcastable(icdcode::AbstractICD10) = Ref(icdcode)

function validicd10input(ANNx::String, punct = true)
  icdfmt =
    punct ? r"^[[:upper:]][[:digit:]]{2}\.[[:digit:]]{1,2}$" :
    r"^[[:upper:]][[:digit:]]{2}[[:digit:]]{1,2}$"
  return occursin(icdfmt, ANNx)
end

include("icd10.jl")
include("icd10fns.jl")
include("othericd10.jl")
include("achi.jl")
include("icd10amfns.jl")

function __init__()
  if isfile(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"))
    global _ICD10AMcodes_ =
      load(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"), "icd10amcodes")
  end
  if isfile(normpath(@__DIR__, "..", "data", "achicodes.jld2"))
    global _ACHIcodes_ =
      load(normpath(@__DIR__, "..", "data", "achicodes.jld2"), "achicodes")
  end
end

end # module
