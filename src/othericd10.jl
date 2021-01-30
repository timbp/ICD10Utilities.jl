for t in (:ICD10AM, :ICD10CA, :ICD10GM)
  @eval begin
    struct $t <: AbstractICD10
      level::Int8
      data::NTuple{5,UInt8}
    end

    function $t(str::AbstractString, validateinput = false)
      punct = occursin(".", str) ? true : false
      if validateinput
        valid $tinput(str, punct) || throw(
          DomainError(
            str,
            "ICD-10 codes should have format `ANN[.][N[N]]` where `A` is letter A-Z, `N` is decimal digit, and parts in brackets are optional",
          ),
        )
      end
      level = punct ? length(str) - 1 : length(str)
      ch4 = punct ? 5 : 4

      if level == 3
        return $t(level, (NTuple{3,UInt8}.(str)..., UInt8(0), UInt8(0)))
      elseif level == 4
        return $t(level, (NTuple{3,UInt8}.(str)..., UInt8(str[ch4]), UInt8(0)))
      elseif level == 5
        return $t(level, (NTuple{3,UInt8}.(str)..., UInt8(str[ch4]), UInt8(str[ch4+1])))
      else
        throw(
          DomainError(str, "ICD-10 codes should be 3-5 characters excluding the period"),
        )
      end
    end

    function $t(icd::T) where {T<:AbstractICD10}
      $t(icd.level, icd.data)
    end
  end
end

"""
    ICD10AM

Australian version of ICD-10
"""
ICD10AM

"""
    ICD10CA

Canadian version of ICD-10
"""
ICD10CA

# """
#     ICD10CM

# United States version of ICD-10
# """
# ICD10CM

"""
    ICD10GM

German version of ICD-10
"""
ICD10GM

"""
    ICD10AM(str::String, validateinput = false)

Create an ICD10AM code from a string.

ICD10AM codes have the form `ANN[.][N[N]]` where `A` is a letter A-Z and
`N` is
a digit 0-9. Parts in brackets are optional.

If `validateinput=true` then the input string is checked for valid format using
a regex.
"""
ICD10AM(str::AbstractString, validateinput = false)

"""
    ICD10CA(str::String, validateinput = false)

Create an ICD10CA code from a string.

ICD10CA codes have the form `ANN[.][N[N]]` where `A` is a letter A-Z and
`N` is a digit 0-9. Parts in brackets are optional.

If `validateinput=true` then the input string is checked for valid format using
a regex.
"""
ICD10CA(str::AbstractString, validateinput = false)

"""
    ICD10GM(str::String, validateinput = false)

Create an ICD10GM code from a string.

ICD10GM codes have the form `ANN[.][N[N]]` where `A` is a letter A-Z and
`N` is a digit 0-9. Parts in brackets are optional.

If `validateinput=true` then the input string is checked for valid format using
a regex.
"""
ICD10GM(str::AbstractString, validateinput = false)

"""
    ICD10AM(icd::T) where {T<:AbstractICD10}

Convert ICD-10 code to Australian ICD-10-AM.

Note this just changes the type of the code. It does not do any checking or
translating of concepts between versions.
"""
ICD10AM(icd::T) where {T<:AbstractICD10}
"""
    ICD10CA(icd::T) where {T<:AbstractICD10}

Convert ICD-10 code to Canadian ICD-10-CA.

Note this just changes the type of the code. It does not do any checking or
translating of concepts between versions.
"""
ICD10CA(icd::T) where {T<:AbstractICD10}
# """
#     ICD10CM(icd::T) where {T<:AbstractICD10}

# Convert ICD-10 code to United States ICD-10-CM.

# Note this just changes the type of the code. It does not do any checking or
# translating of concepts between versions.
# """
# ICD10CM(icd::T) where {T<:AbstractICD10}
"""
    ICD10GM(icd::T) where {T<:AbstractICD10}

Convert ICD-10 code to German ICD-10-GM.

Note this just changes the type of the code. It does not do any checking or
translating of concepts between versions.
"""
ICD10GM(icd::T) where {T<:AbstractICD10}
