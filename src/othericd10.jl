# Canadian ICD-10-CA
struct ICD10CA <: ICD10Code
  ANN::String
  NN::String
end

function ICD10CA(ANNx::String)
  ANN = SubString(ANNx, 1:3)
  NN = occursin(".", ANNx) ? SubString(ANNx, 5:lastindex(ANNx)) :
       SubString(ANNx, 4:lastindex(ANNx))
  return validicd10format(ANN, NN) && ICD10CA(ANN, NN)
end
ICD10CA(icd::T) where {T<:ICD10Code} = ICD10CA(icd.ANN, icd.NN)

# US ICD-10-CM
struct ICD10CM <: ICD10Code
  ANN::String
  NN::String
end

function ICD10CM(ANNx::String)
  ANN = SubString(ANNx, 1:3)
  NN = occursin(".", ANNx) ? SubString(ANNx, 5:lastindex(ANNx)) :
       SubString(ANNx, 4:lastindex(ANNx))
  return validicd10format(ANN, NN) && ICD10CM(ANN, NN)
end
ICD10CM(icd::T) where {T<:ICD10Code} = ICD10CM(icd.ANN, icd.NN)

# German ICD-10-GM
struct ICD10GM <: ICD10Code
  ANN::String
  NN::String
end

function ICD10GM(ANNx::String)
  ANN = SubString(ANNx, 1:3)
  NN = occursin(".", ANNx) ? SubString(ANNx, 5:lastindex(ANNx)) :
       SubString(ANNx, 4:lastindex(ANNx))
  return validicd10format(ANN, NN) && ICD10GM(ANN, NN)
end
ICD10GM(icd::T) where {T<:ICD10Code} = ICD10GM(icd.ANN, icd.NN)
