## ACHI #####
"""
    ACHI

An ACHI (Australian Classification of Health Interventions) code.
"""
struct ACHI
  NNNNN::String
  NN::String
end

function validachiinput(NNNNNNN, punct = true)
  achifmt = punct ? r"^[[:digit:]]{5}-[[:digit:]]{2}$" : r"^[[:digit:]]{5}[[:digit:]]{2}$"
  return occursin(achifmt, NNNNNNN)
end

"""
    ACHI(NNNNNx::String, punct=true, validateinput=false)

Create an ACHI code from a string.

ACHI codes consist of 7 digits (0-9), usually with a hypen after the first 5 digits.

If `punct=false` then the input is assumed to be simply 7 decimal digits.

If `validateinput=true` then the input is checked using a regex and returns a DomainError
if the format is not correct. Note this only checks the input format; it does not
check if the code actually exists in ACHI.
"""
function ACHI(NNNNNx::String, punct = true, validateinput = false)
  if validateinput
    validachiinput(NNNNNx, punct) || throw(
      DomainError(
        NNNNNx,
        "ACHI codes must have format `NNNNN-NN` where `N` is a decimal digit. The hyphen can be omitted (but then set `punct=false`)",
      ),
    )
  end
  NNNNN = SubString(NNNNNx, 1, 5)
  NN = punct ? SubString(NNNNNx, 7) : SubString(NNNNNx, 6)
  ACHI(NNNNN, NN)
end

## ACHI Base functions #####
(==)(str::String, achi::ACHI) =
  occursin("-", str) ? str == string(achi, true) : str == string(achi, false)
(==)(achi::ACHI, str::String) = str == achi

"""
    string(achi::ACHI, punct = true)

Convert an ACHI code to a string.

If `punct = false` then omit the hyphen ("NNNNNNN" instead of "NNNNN-NN")
"""
Base.string(achi::ACHI, punct = true) = punct ? achi.NNNNN * "-" * achi.NN : achi.NNNNN * achi.NN

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