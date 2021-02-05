## ICD10CM #####
"""
    ICD10CM

An ICD-10-CM code

Fields are `level`, indicating the number of digits in the code, and `data` containing the code.
"""
struct ICD10CM <: AbstractICD10
  level::Int8
  data::NTuple{7,UInt8}
end

"""
    ICD10CM(str::String, validateinput = false)

Create an ICD10CM code from a string.

ICD10CM codes have the form `ANC[.][C[C[C[C]]]]` where `A` is a letter A-Z,
`N` is a digit 0-9, and `C` is a letter or digit. Parts in brackets are optional.

If `validateinput=true` then the input string is checked for valid format using
a regex.
"""
function ICD10CM(str::AbstractString, validateinput = false)
  punct = occursin(".", str) ? true : false
  if validateinput
    validICD10CMinput(str, punct) || throw(
      DomainError(
        str,
        "ICD-10-CM codes should have format `ANC[.][C[C[C[C]]]]` where `A` is a letter A-Z, `N` is a digit 0-9, and `C` is a letter or digit, and parts in brackets are optional",
      ),
    )
  end
  level = punct ? length(str) - 1 : length(str)
  ch4 = punct ? 5 : 4

  if level == 3
    return ICD10CM(
      level,
      (NTuple{3,UInt8}.(str)..., UInt8(0), UInt8(0), UInt8(0), UInt8(0)),
    )
  elseif level == 4
    return ICD10CM(
      level,
      (NTuple{3,UInt8}.(str)..., UInt8(str[ch4]), UInt8(0), UInt8(0), UInt8(0)),
    )
  elseif level == 5
    return ICD10CM(
      level,
      (NTuple{3,UInt8}.(str)..., UInt8(str[ch4]), UInt8(str[ch4+1]), UInt8(0), UInt8(0)),
    )
  elseif level == 6
    return ICD10CM(
      level,
      (
        NTuple{3,UInt8}.(str)...,
        UInt8(str[ch4]),
        UInt8(str[ch4+1]),
        UInt8(str[ch4+2]),
        UInt8(0),
      ),
    )
  elseif level == 7
    return ICD10CM(
      level,
      (
        NTuple{3,UInt8}.(str)...,
        UInt8(str[ch4]),
        UInt8(str[ch4+1]),
        UInt8(str[ch4+2]),
        UInt8(str[ch4+3]),
      ),
    )
  else
    throw(DomainError(str, "ICD-10-CM codes should be 3-7 characters excluding the period"))
  end
end

"""
    ICD10CM(icd::T) where T <: AbstractICD10

Create an ICD-10-CM code from another type of ICD-10 code.

Note this just changes the type. It does not translate concepts between versions.

Most ICD-10 versions have up to 5 digits, while ICD-10-CM has up to 7, so this conversion cannot be exact.
"""
ICD10CM(icd::T) where {T<:AbstractICD10} = ICD10(icd)

"""
    ICD10(icd::ICD10CM)

Convert from ICD10CM to ICD10.

Note that ICD-10-CM codes may have up to 7 digits, while other ICD-10 versions
only have up to 5.

**This function truncates longer codes.**

Note this just changes the type. It does not translate concepts between versions.
"""
ICD10(icd::ICD10CM) = ICD10(min(icd.level, 5), icd.data[1:5])

"""
    ICD10AM(icd::ICD10CM)

Convert from ICD10CM to ICD10AM.

Note that ICD-10-CM codes may have up to 7 digits, while other ICD-10 versions
only have up to 5.

**This function truncates longer codes.**

Note this just changes the type. It does not translate concepts between versions.
"""
ICD10AM(icd::ICD10CM) = ICD10AM(min(icd.level, 5), icd.data[1:5])

"""
    ICD10CA(icd::ICD10CM)

Convert from ICD10CM to ICD10CA.

Note that ICD-10-CM codes may have up to 7 digits, while other ICD-10 versions
only have up to 5.

**This function truncates longer codes.**

Note this just changes the type. It does not translate concepts between versions.
"""
ICD10CA(icd::ICD10CM) = ICD10CA(min(icd.level, 5), icd.data[1:5])

"""
    ICD10GM(icd::ICD10CM)

Convert from ICD10CM to ICD10GM.

Note that ICD-10-CM codes may have up to 7 digits, while other ICD-10 versions
only have up to 5.

**This function truncates longer codes.**

Note this just changes the type. It does not translate concepts between versions.
"""
ICD10GM(icd::ICD10CM) = ICD10GM(min(icd.level, 5), icd.data[1:5])

function validICD10CMinput(str::String, punct)
  icdfmt =
    punct ? r"^[[:upper:]][[:digit:]][[:upper:][:digit:]]\.[[:upper:][:digit:]]{1,4}$" :
    r"^[[:upper:]][[:digit:]][[:upper:][:digit:]]{1,5}$"
  return occursin(icdfmt, str)
end
