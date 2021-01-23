# Australian ICD-10-AM
"""
    ICD10AM

An Australian ICD-10-AM code
"""
struct ICD10AM <: ICD10Code
  ANN::String
  NN::String
end

"""
    ICD10AM("ANN.NN")
    ICD10AM("ANNNN")

Create an ICD-10-AM code from a string.
"""
function ICD10AM(ANNx::String)
  ANN = SubString(ANNx, 1:3)
  NN = occursin(".", ANNx) ? SubString(ANNx, 5:lastindex(ANNx)) :
       SubString(ANNx, 4:lastindex(ANNx))
  return validicd10format(ANN, NN) && ICD10AM(ANN, NN)
end

"""
    ICD10AM(icd)

Create an ICD-10-AM code from another type of ICD10 code.
"""
ICD10AM(icd::T) where {T<:ICD10Code} = ICD10AM(icd.ANN, icd.NN)

## ACHI #####
"""
    ACHI

An ACHI (Australian Classification of Health Interventions) code.
"""
struct ACHI
  NNNNN::String
  NN::String
end

function validachiformat(NNNNN, NN)
  nnnnn = r"^[[:digit:]]{5}$"
  nn = r"^[[:digit:]]{1,2}$"
  (occursin(nnnnn, NNNNN) && occursin(nn, NN)) || throw(DomainError(NNNNN * "-" * NN,
                    "Must follow pattern `NNNNN-NN` where N is decimal digit (hyphen is optional)"))
  return true
end

"""
    ACHI("NNNNN-NN")
    ACHI("NNNNNNN")

Create an ACHI code from a string.
Create an ACHI code from a string.

ACHI codes consist of 7 digits (0-9), usually with a hypen after the first 5 digits.
"""
function ACHI(NNNNNx::String)
  NNNNN = SubString(NNNNNx, 1:5)
  NN = occursin("-", NNNNNx) ? SubString(NNNNNx, 7:lastindex(NNNNNx)) :
       SubString(NNNNNx, 6:lastindex(NNNNNx))
  validachiformat(NNNNN, NN) && return ACHI(NNNNN, NN)
end

## ACHI Base functions #####
(==)(str::String, achi::ACHI) = occursin("-", str) ? str == string(achi; punct=true) :
         str == string(achi; punct=false)
(==)(achi::ACHI, str::String) = str == achi

"""
    Base.string(achi::ACHI; punct = true)

Convert an ACHI code to a string.

If `punct = false` then omit the hyphen ("NNNNNNN" instead of "NNNNN-NN")
"""
function Base.string(achi::ACHI; punct=true)
  return punct ? achi.NNNNN * "-" * achi.NN : achi.NNNNN * achi.NN
end

Base.show(io::IO, achi::ACHI) = print(io, achi.NNNNN * "-" * achi.NN)

## Supporting types #####
"""
    ICD10AMAge

Age group encoding used in the ICD-10-AM electronic code lists.

  - 0-6 : 0 to 6 days
  - 11-13 : 1 to 3 weeks
  - 101-111 : 1 to 11 months
  - 201-324 : 1 to 124 years

All other values are invalid.
"""
struct ICD10AMAge
  agecode::Int16

  function ICD10AMAge(age)
    (age in 0:6 || age in 11:13 || age in 101:111 || age in 201:324) ? new(age) :
           throw(DomainError(age, "Invalid age code"))
  end
end

"""
    ICD10AMAge(agecode::String)

Convert a string representation of the age code to an ICD10AMAge.
"""
ICD10AMAge(age::String) = ICD10AMAge(parse(Int, age))

function Base.show(io::IO, age::ICD10AMAge)
  if age.agecode in 0:6
    print(io, string(age.agecode) * " days")
  elseif age.agecode in 11:13
    print(io, string(age.agecode - 10) * " weeks")
  elseif age.agecode in 101:111
    print(io, string(age.agecode - 100) * " months")
  else
    print(io, string(age.agecode - 200) * " years")
  end
end

# Additional functionality depends on IHPA electronic code lists #####
include("loadicd10amachiecl.jl")

## ICD10AM functions #####

"""
    isvalidcode(icdcode:ICD10AM)

Takes an ICD10AM code and checks it is in the electronic code lists and valid.

Electronic code lists can be obtained from the [Independent Hospital Pricing
Authority](https://www.ihpa.gov.au/what-we-do/icd-10-am-achi-acs-classification),
and need to be imported into the local package before this function
can be used. See []

"Valid" codes are those that exist and are valid for use in coding (e.g.
3-digit codes are often not valid for use if they have 4- or 5-digit subcodes).
"""
function isvalidcode(icdcode::ICD10AM)
  isdefined(ICD10Utilities, :_ICD10AMcodes_) ||
    error("You need to import the ICD-10-AM/ACHI electronic code lists (obtained from Independent Hospital Pricing Authority at https://ar-drg.laneprint.com.au/) to use validation")
  return icdcode in _ICD10AMcodes_.icdcode &&
         _ICD10AMcodes_.validforcoding[_ICD10AMcodes_.icdcode .== icdcode][]
end
## TO DO #####
# Need a method that takes a date and checks if the code is inactive on that date.
# also want to be able to check if a code is valid in a particular edition.

## ACHI functions #####
"""
    isvalidcode(code:ACHI)

Takes an ACHI code and checks it is in the electronic code lists and valid.

Electronic code lists can be obtained from the [Independent Hospital Pricing
Authority](https://www.ihpa.gov.au/what-we-do/icd-10-am-achi-acs-classification),
and need to be imported into the local package before this function
can be used.

"Valid" codes are those that exist.
"""
function isvalidcode(achi::ACHI)
  isdefined(ICD10Utilities, :_ACHIcodes_) ||
    throw(ErrorException("You need to import the ICD10AM/ACHI electronic code lists (obtained from Independent Hospital Pricing Authority at https://ar-drg.laneprint.com.au/) to use validation"))
  return code in _ACHIcodes_.code_id && _ACHIcodes_.valid[_ACHIcodes_.code_id .== achi][]
end
## TO DO #####
# Need a method that takes a date and checks if the code is inactive at that date.
## TO DO #####
# Need a method that takes a date and checks if the code is inactive at that date.
# Also want to check if a code is valid in a particular version
