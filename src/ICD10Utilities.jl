module ICD10Utilities

using CSV, TypedTables, Dates, CategoricalArrays, Missings
using FileIO

import Base: isless, show, string, ==, convert, startswith

export ICD10Code
export ICD10
export ICD10AM, ACHI
export ICD10CA, ICD10CM, ICD10GM
export ICD10AMAge
export icd3
export isvalidcode

abstract type ICD10Code end

function validicd10format(ANN::AbstractString, NN::AbstractString)
  ann = r"^[[:upper:]][[:digit:]]{2}$"
  nn = r"^[[:digit:]]{1,2}$"
  occursin(ann, ANN) || throw(DomainError(ANN,
                    "Must follow pattern `ANN[.][N[N]]` where A is upper case letter, N is decimal digit, and parts in brackets are optional"))
  (NN == "" || occursin(nn, NN)) || throw(DomainError(NN,
                    "Must follow pattern `ANN[.][N[N]]` where A is upper case letter, N is decimal digit, and parts in brackets are optional"))
  return true
end

include("icd10.jl")
include("icd10am_achi.jl")
include("othericd10.jl")
include("icd10fns.jl")

Broadcast.broadcastable(icdcode::ICD10Code) = Ref(icdcode)

function __init__()
  if isfile(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"))
    global _ICD10AMcodes_ = load(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"),
                                 "icd10amcodes")
  end
  if isfile(normpath(@__DIR__, "..", "data", "achicodes.jld2"))
    global _ACHIcodes_ = load(normpath(@__DIR__, "..", "data", "achicodes.jld2"),
                              "achicodes")
  end
end

end # module
