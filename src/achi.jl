## ACHI #####
"""
    ACHI

An ACHI (Australian Classification of Health Interventions) code.
"""
struct ACHI
  data::NTuple{7,UInt8}
end

function validachiinput(str, punct)
  achifmt = punct ? r"^[[:digit:]]{5}-[[:digit:]]{2}$" : r"^[[:digit:]]{5}[[:digit:]]{2}$"
  return occursin(achifmt, str)
end

"""
    ACHI(str::String, validateinput=false)

Create an ACHI code from a string.

ACHI codes consist of 7 digits (0-9), usually with a hypen after the first 5 digits.

If `validateinput=true` then the input is checked using a regex. Note this only checks the input format; it does not
check if the code actually exists in ACHI.
"""
function ACHI(str::String, validateinput = false)
  punct = occursin("-", str) ? true : false
  if validateinput
    validachiinput(str, punct) || throw(
      DomainError(
        str,
        "ACHI codes should have format `NNNNN-NN` where `N` is a decimal digit. The hyphen can be omitted.",
      ),
    )
  end
  ch6 = punct ? 7 : 6
  return ACHI((NTuple{5,UInt8}.(str[1:5])..., NTuple{2,UInt8}.(str[ch6:end])...))
end

## ACHI Base functions #####

function Base.print(io::IO, achi::ACHI, punct = ICDOPTS[:punct])
  if punct
    write(io, Ref(achi.data[1:5]), "-", Ref(achi.data[6:7]))
  else
    write(io, Ref(achi))
  end
end

Base.show(io::IO, achi::ACHI) = print(io, achi, ICDOPTS[:punct])

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

## ACHI functions #####
"""
    isvalidcode(code:ACHI)

Takes an ACHI code and checks it is in the electronic code lists and valid.

Electronic code lists can be obtained from the [Independent Hospital Pricing
Authority](https://www.ihpa.gov.au/what-we-do/icd-10-am-achi-acs-classification),
and need to be imported into the local package before this function
can be used. See [`importachicodes`](@ref)

"Valid" codes are those that exist.
"""
function isvalidcode(achi::ACHI)
  isdefined(ICD10Utilities, :ACHIcodes) ||
    isfile(normpath(@__DIR__, "..", "data", "achicodes.jld2")) ||
    throw(
      ErrorException(
        "You need to import the ICD10AM/ACHI electronic code lists (obtained from Independent Hospital Pricing Authority at https://ar-drg.laneprint.com.au/) to use validation. Run `importachicodes(<filename>` where `<filename>` is the path to the `interven.txt` file from IHPA.",
      ),
    )
  if !isdefined(ICD10Utilities, :ACHIcodes)
    global ACHIcodes = load(normpath(@__DIR__, "..", "data", "achicodes.jld2"), "achicodes")
  end

  f(achi, codelist = ACHIcodes)::Bool = achi in codelist.achicode

  return f(achi)
end
## TO DO #####
# Need a method that takes a date and checks if the code is inactive at that date.
# Also want to check if a code is valid in a particular version
