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
export seticdpunct

export ICD10AMcodes, ACHIcodes

"""
    ICDOPTS

Dictionary of options for ICD10Utilities.

`:punct`: if `true` (default), ICD-10 codes are displayed with `.` after third character,
          and ACHI codes are displayed with `-` after fifth character.
"""
const ICDOPTS = Dict{Symbol,Any}(
  :punct => true
  )
# easily set options
"""
    seticdpunct(v::Bool)

  Set `ICDOPTS[:punct]` to new value.
"""
seticdpunct(v::Bool) = ICDOPTS[:punct] = v

"""
    AbstractICD10

Abstract type for ICD-10 codes
"""
abstract type AbstractICD10 end

Broadcast.broadcastable(icdcode::T) where {T<:AbstractICD10} = Ref(icdcode)

include("icd10.jl")
include("icd10fns.jl")
include("othericd10.jl")
include("achi.jl")
include("icd10amfns.jl")

end # module
