## ICD10 #####
"""
   ICD10

An ICD-10 code.
"""
struct ICD10 <: ICD10Code
  ANN::String
  NN::String
end

"""
   ICD10("ANN.NN")
   ICD10("ANNNN")

Create an ICD-10 code from a string.

ICD-10 codes have the form `ANN[.][N[N]]` where `A` is a letter A-Z and
`N` is a digit 0-9. Parts in brackets are optional.
"""
function ICD10(ANNx::String)
  ANN = SubString(ANNx, 1:3)
  NN = occursin(".", ANNx) ? SubString(ANNx, 5:lastindex(ANNx)) : SubString(ANNx, 4:lastindex(ANNx))
  validicd10format(ANN, NN) && ICD10(ANN, NN)
end

"""
   ICD10(icd::T) where T <: ICD10Code

Create an ICD-10 code from another type of ICD-10 code.
"""
ICD10(icd::T) where {T<:ICD10Code} = ICD10(icd.ANN, icd.NN)
