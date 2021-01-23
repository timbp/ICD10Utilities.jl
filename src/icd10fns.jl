## ICD10Code Base functions #####

convert(::Type{T}, x::ICD10Code) where {T<:ICD10Code} = T(x)
convert(::Type{T}, x::String) where {T<:ICD10Code} = T(x)
convert(::Type{String}, x::T) where {T<:ICD10Code} = string(x)

# ICD10 codes of same type can be equal, but not if different types (as we do not know that they refer to same concept)
# If you really want to test equality between different ICD10 types, convert to string first
# We allow `isless` because this is only meaninful lexicographically so cannot be confused with comparing concepts
(==)(icd::T, icd2::T) where {T<:ICD10Code} = icd.ANN == icd2.ANN && icd.NN == icd2.NN

function (==)(str::String, icd::ICD10Code)
  return occursin(".", str) ? str == string(icd; punct=true) :
         str == string(icd; punct=false)
end
(==)(icd::ICD10Code, str::String) = str == icd

function isless(icd1::ICD10Code, icd2::ICD10Code)
  return icd1.ANN < icd2.ANN || icd1.ANN == icd2.ANN && icd1.NN < icd2.NN
end

isless(str::String, icd::ICD10Code) = isless(str, string(icd))
isless(icd::ICD10Code, str::String) = isless(string(icd), str)

function string(icd::ICD10Code; punct=true)
  return punct ? icd.ANN * "." * icd.NN : icd.ANN * icd.NN
end

show(io::IO, icd::ICD10Code) = print(io, icd.ANN * "." * icd.NN)

startswith(icd::ICD10Code, s) = startswith(string(icd), s)

## ICD10 functions #####
"""
    isvalidcode(icd, validcodes)

Takes an ICD10Code and compares it with a list of valid codes.
"""
function isvalidcode(icd::ICD10Code, validcodes)
  return icd in validcodes
end

"""
    icd3(icdcode)

Returns the initial 3-digits of an ICD10 code as a string.
"""
icd3(icdcode::T) where {T<:ICD10Code} = icdcode.ANN
