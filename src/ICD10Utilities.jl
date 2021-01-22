module ICD10Utilities

using CSV, TypedTables, DataFrames, Dates, CategoricalArrays
using FileIO

import Base: isless, show, string, ==

export ICD10Code
export ICD10AM, ACHI
export ICD10AMAge
export isvalidcode

abstract type ICD10Code end

include("icd10am_achi.jl")

function __init__()
  if isfile(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"))
    global _ICD10AMcodes_ = load(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"), "icd10amcodes")
  end
  if isfile(normpath(@__DIR__, "..", "data", "achicodes.jld2"))
    global _ACHIcodes_ =
      load(normpath(@__DIR__, "..", "data", "achicodes.jld2"), "achicodes")
  end
end

end # module
