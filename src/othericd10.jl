for t in (:ICD10AM, :ICD10CA, :ICD10CM, :ICD10GM)
  @eval begin
    struct $t <: AbstractICD10
      ANN::String
      NN::String
    end

    function $t(ANNx::String, punct = true, validateinput = false)
      if validateinput
        validicd10input(ANNx, punct) || throw(
          DomainError(
            (ANNx, punct),
            "ICD-10 codes must have format `ANN[.][N[N]], where `A` is a letter A-Z, `N` is a decimal digit, and parts in brackets are optional",
          ),
        )
      end
      ANN = SubString(ANNx, 1:3)
      NN = punct ? SubString(ANNx, 5:lastindex(ANNx)) : SubString(ANNx, 4:lastindex(ANNx))
      $t(ANN, NN)
    end

    $t(icd::T) where {T<:AbstractICD10} = $t(icd.ANN, icd.NN)
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

"""
    ICD10CM

United States version of ICD-10
"""
    ICD10CM

"""
    ICD10GM

German version of ICD-10
"""
    ICD10GM

"""
    ICD10AM(ANNx::String, punct=true, validateinput=false)

Create an Australian ICD-10-AM  code from a string.

If `punct=false` then the string is assumed not to contain a .

If `validateinput=true` then the input format is checked using a regex. this
takes 2–3 times as long as not validating.
"""
ICD10AM(ANNx::String, punct = true, validachiinput = false)

"""
    ICD10CA(ANNx::String, punct=true, validateinput=false)

Create a Canadian ICD-10-CA  code from a string.

If `punct=false` then the string is assumed not to contain a .

If `validateinput=true` then the input format is checked using a regex. this
takes 2–3 times as long as not validating.
"""
ICD10CA(ANNx::String, punct = true, validachiinput = false)

"""
    ICD10CM(ANNx::String, punct=true, validateinput=false)

Create a United States ICD-10-CM  code from a string.

If `punct=false` then the string is assumed not to contain a .

If `validateinput=true` then the input format is checked using a regex. this
takes 2–3 times as long as not validating.
"""
ICD10CM(ANNx::String, punct = true, validachiinput = false)

"""
    ICD10GM(ANNx::String, punct=true, validateinput=false)

Create a German ICD-10-GM  code from a string.

If `punct=false` then the string is assumed not to contain a .

If `validateinput=true` then the input format is checked using a regex. this
takes 2–3 times as long as not validating.
"""
ICD10GM(ANNx::String, punct = true, validachiinput = false)

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
"""
    ICD10CM(icd::T) where {T<:AbstractICD10}

Convert ICD-10 code to United States ICD-10-CM.

Note this just changes the type of the code. It does not do any checking or
translating of concepts between versions.
"""
ICD10CM(icd::T) where {T<:AbstractICD10}
"""
    ICD10GM(icd::T) where {T<:AbstractICD10}

Convert ICD-10 code to German ICD-10-GM.

Note this just changes the type of the code. It does not do any checking or
translating of concepts between versions.
"""
ICD10GM(icd::T) where {T<:AbstractICD10}
