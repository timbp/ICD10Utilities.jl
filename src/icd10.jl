## ICD10 #####
"""
    ICD10

An ICD-10 code (standard WHO version).

Fields are `level`, indicating if it is a 3, 4, or 5 digit code, and `data` containing the code.
"""
struct ICD10 <: AbstractICD10
  level::Int8
  data::NTuple{5,UInt8}
end

"""
    ICD10(str::String, validateinput = false)

Create an ICD10 code from a string.

ICD10 codes have the form `ANN[.][N[N]]` where `A` is a letter A-Z and
`N` is a digit 0-9. Parts in brackets are optional.

If `validateinput=true` then the input string is checked for valid format using
a regex.
"""
function ICD10(str::AbstractString, validateinput = false)
  punct = occursin(".", str) ? true : false
  if validateinput
    validICD10input(str, punct) || throw(
      DomainError(
        str,
        "ICD-10 codes should have format `ANN[.][N[N]]` where `A` is letter A-Z, `N` is decimal digit, and parts in brackets are optional",
      ),
    )
  end
  level = punct ? length(str) - 1 : length(str)
  ch4 = punct ? 5 : 4

  if level == 3
    return ICD10(level, (NTuple{3,UInt8}.(str)..., UInt8(0), UInt8(0)))
  elseif level == 4
    return ICD10(level, (NTuple{3,UInt8}.(str)..., UInt8(str[ch4]), UInt8(0)))
  elseif level == 5
    return ICD10(level, (NTuple{3,UInt8}.(str)..., UInt8(str[ch4]), UInt8(str[ch4+1])))
  else
    throw(DomainError(str, "ICD-10 codes should be 3-5 characters excluding the period"))
  end
end

"""
    ICD10(icd::T) where T <: AbstractICD10

Create an ICD-10 code from another type of ICD-10 code.

Note this just changes the type. It does not translate concepts between versions.
"""
ICD10(icd::T) where {T<:AbstractICD10} = ICD10(icd)


function validICD10input(str::String, punct)
  icdfmt =
    punct ? r"^[[:upper:]][[:digit:]]{2}\.[[:digit:]]{1,2}$" :
    r"^[[:upper:]][[:digit:]]{2}[[:digit:]]{1,2}$"
  return occursin(icdfmt, str)
end
