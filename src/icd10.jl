## ICD10 #####
"""
    ICD10

An ICD-10 code.
"""
struct ICD10 <: AbstractICD10
  ANN::String
  NN::String
end

"""
    ICD10(ANNx::String, punct=true, validateinput = false)

Create an ICD-10 code from a string.

ICD-10 codes have the form `ANN[.][N[N]]` where `A` is a letter A-Z and
`N` is a digit 0-9. Parts in brackets are optional.

If `punct=false` then the `.` is assumed not present.

If `validateinput=true` then the input string is checked for valid format using
a regex. This takes 2–3 times as long as not checking.
"""
function ICD10(ANNx::String, punct = true, validateinput = false)
  if validateinput
    validicd10input(ANNx, punct) || throw(
      DomainError(
        (ANNx, punct),
        "ICD-10 codes must have format `ANN[.][N[N]], where `A` is a letter A-Z, `N` is a decimal digit, and parts in brackets are optional",
      ),
    )
  end
  ANN = SubString(ANNx, 1, 3)
  NN = punct ? SubString(ANNx, 5) : SubString(ANNx, 4)
  ICD10(ANN, NN)
end

"""
    ICD10(icd::T) where T <: AbstractICD10

Create an ICD-10 code from another type of ICD-10 code.

Note this just changes the type. It does not translate concepts between versions.
"""
ICD10(icd::T) where {T<:AbstractICD10} = ICD10(icd.ANN, icd.NN)
