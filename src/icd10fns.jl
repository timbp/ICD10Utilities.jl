## AbstractICD10 Base functions #####

Base.convert(::Type{T}, x::AbstractICD10) where {T<:AbstractICD10} = T(x)
Base.convert(::Type{T}, x::String) where {T<:AbstractICD10} = T(x)
Base.convert(::Type{String}, x::T, punct=true) where {T<:AbstractICD10} = string(x, punct)

# Note these comparisons are lexicographic only; we are not implying underlying
# concepts are equal if codes come from different versions.
(==)(icd::AbstractICD10, icd2::AbstractICD10) = icd.ANN == icd2.ANN && icd.NN == icd2.NN

function (==)(str::String, icd::AbstractICD10)
  occursin(".", str) ? str == string(icd, true) : str == string(icd, false)
end
(==)(icd::AbstractICD10, str::String) = str == icd

Base.isless(icd1::AbstractICD10, icd2::AbstractICD10) =
  icd1.ANN < icd2.ANN || icd1.ANN == icd2.ANN && icd1.NN < icd2.NN
Base.isless(str::String, icd::AbstractICD10) = isless(str, string(icd))
Base.isless(icd::AbstractICD10, str::String) = isless(string(icd), str)

"""
    string(icdcode)
    string(icdcode, false)

Convert an ICD10 code to a string. Output will have punctuation unless `false` is passed as second argument.

"""
Base.string(icd::AbstractICD10, punct = true) =
  punct ? icd.ANN * "." * icd.NN : icd.ANN * icd.NN

Base.show(io::IO, icd::AbstractICD10) = print(io, icd.ANN * "." * icd.NN)

Base.startswith(icd::AbstractICD10, s) = startswith(string(icd), s)

## ICD10 functions #####

"""
    isvalidcode(icd, validcodes)

Takes an AbstractICD10 and compares it with a list of valid codes.
"""
isvalidcode(icd::AbstractICD10, validcodes) = icd in validcodes

"""
    icd3(icdcode)

Returns the initial 3-digits of an ICD10 code as a string.
"""
icd3(icdcode::T) where {T<:AbstractICD10} = icdcode.ANN
