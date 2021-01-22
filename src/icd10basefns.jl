## ICD10Code Base functions #####
function Base.isless(icd1::ICD10Code, icd2::ICD10Code)
  return icd1.ANN < icd2.ANN || icd1.ANN == icd2.ANN && icd1.NN < icd2.NN
end

Base.isless(str::String, icd::ICD10Code) = isless(str, string(icd))
Base.isless(icd::ICD10Code, str::String) = isless(string(icd), str)

# ICD10 codes of same type can be equal, but not if different types (as we do not know that they refer to same concept)
# If you really want to test equality between different ICD10 types, convert to string first
(==)(icd::T, icd2::T) where T <: ICD10Code = icd.ANN == icd2.ANN && icd.NN == icd2.NN

function (==)(str::String, icd::ICD10Code)
  return occursin(".", str) ? str == string(icd, punct = true) : str == string(icd, punct=false)
end
(==)(icd::ICD10Code, str::String) = str == icd

function Base.string(icd::ICD10Code; punct = true)
  return punct ? icd.ANN * "." * icd.NN : icd.ANN * icd.NN
end

Base.show(io::IO, icd::ICD10Code) = print(io, icd.ANN * "." * icd.NN)
