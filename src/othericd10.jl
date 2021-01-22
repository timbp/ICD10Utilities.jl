# Standard WHO ICD-10
struct ICD10 <: ICD10Code
  ANN::String
  NN::String

  ICD10(ANN, NN) = validicd10format(ANN, NN) && return new(ANN, NN)
end

ICD10(icd::String) = ICD10(ICD10AM(icd))
ICD10(icd::T) where T <: ICD10Code = ICD10(icd.ANN, icd.NN)

# Canadian ICD-10-CA
struct ICD10CA <: ICD10Code
  ANN::String
  NN::String

  ICD10CA(ANN, NN) = validicd10format(ANN, NN) && return new(ANN, NN)
end

ICD10CA(icd::String) = ICD10CA(ICD10AM(icd))
ICD10CA(icd::T) where T <: ICD10Code = ICD10CA(icd.ANN, icd.NN)

# US ICD-10-CM
struct ICD10CM <: ICD10Code
  ANN::String
  NN::String

  ICD10CM(ANN, NN) = validicd10format(ANN, NN) && return new(ANN, NN)
end

ICD10CM(icd::String) = ICD10CM(ICD10AM(icd))
ICD10CM(icd::T) where T <: ICD10Code = ICD10CM(icd.ANN, icd.NN)

# German ICD-10-GM
struct ICD10GM <: ICD10Code
  ANN::String
  NN::String

  ICD10GM(ANN, NN) = validicd10format(ANN, NN) && return new(ANN, NN)
end

ICD10GM(icd::String) = ICD10GM(ICD10AM(icd))
ICD10GM(icd::T) where T <: ICD10Code = ICD10GM(icd.ANN, icd.NN)

