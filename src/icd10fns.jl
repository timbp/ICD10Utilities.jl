## ICD10Code Base functions #####

Base.convert(::Type{T}, x::ICD10Code) where {T<:ICD10Code} = T(x)
Base.convert(::Type{T}, x::String) where {T<:ICD10Code} = T(x)
Base.convert(::Type{String}, x::T, punct=true) where {T<:ICD10Code} = string(x, punct)

# ICD10 codes of same type can be equal, but not if different types (as we do not know that they refer to same concept)
# If you really want to test equality between different ICD10 types, convert to string first
# We allow `isless` because this is only meaninful lexicographically so cannot be confused with comparing concepts
(==)(icd::T, icd2::T) where {T<:ICD10Code} = icd.ANN == icd2.ANN && icd.NN == icd2.NN

function (==)(str::String, icd::ICD10Code)
  occursin(".", str) ? str == string(icd, true) : str == string(icd, false)
end
(==)(icd::ICD10Code, str::String) = str == icd

Base.isless(icd1::ICD10Code, icd2::ICD10Code) =
  icd1.ANN < icd2.ANN || icd1.ANN == icd2.ANN && icd1.NN < icd2.NN
Base.isless(str::String, icd::ICD10Code) = isless(str, string(icd))
Base.isless(icd::ICD10Code, str::String) = isless(string(icd), str)

"""
    string(icdcode)
    string(icdcode, false)

Convert an ICD10 code to a string. Output will have punctuation unless `false` is passed as second argument.

"""
Base.string(icd::ICD10Code, punct = true) =
  punct ? icd.ANN * "." * icd.NN : icd.ANN * icd.NN

Base.show(io::IO, icd::ICD10Code) = print(io, icd.ANN * "." * icd.NN)

Base.startswith(icd::ICD10Code, s) = startswith(string(icd), s)

## ICD10 functions #####

"""
    isvalidcode(icd, validcodes)

Takes an ICD10Code and compares it with a list of valid codes.
"""
isvalidcode(icd::ICD10Code, validcodes) = icd in validcodes

"""
    icd3(icdcode)

Returns the initial 3-digits of an ICD10 code as a string.
"""
icd3(icdcode::T) where {T<:ICD10Code} = icdcode.ANN
