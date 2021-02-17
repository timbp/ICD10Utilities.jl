"""
    ICDO3

An ICD-O-3 cancer morphology code.
"""
struct ICDO3 <: AbstractICD10
  data::NTuple{6,UInt8}
end

function validICDO3input(str)
  icdO3fmt = r"^M[[:digit:]]{4}(/){0,1}[[:digit:]]{1}$"
  return occursin(icdO3fmt, str)
end

"""
    ICDO3(str::String, validateinput=false)

Create an ICDO3 code from a string.

ICDO3 codes consist of the letter `M` followed by 4 digits, a slash `/`, and a final behaviour digit.

If `validateinput=true` then the input is checked using a regex. Note this only checks the input format; it does not
check if the code actually exists.
"""
function ICDO3(str::String, validateinput = false)
  if validateinput
    validICDO3input(str) || throw(
      DomainError(
        str,
        "ICD-O-3 codes should have format `MNNNN/N` where `M` is the upper case letter 'M', `N` is a decimal digit.",
        ),
        )
  end
  return ICDO3((NTuple{5,UInt8}.(str[1:5])..., UInt8(str[end])))
end

## ICD-O-3 Base functions #####

function Base.print(io::IO, icdO3::ICDO3, punct = ICDOPTS[:punct])
  if punct
    write(io, Ref(icdO3.data[1:5]), "/", Ref(icdO3.data[6]))
  else
    write(io, Ref(icdO3))
  end
end

Base.show(io::IO, ::MIME"text/plain", icdO3::ICDO3) = print(io, icdO3, ICDOPTS[:punct])

Base.convert(::Type{T}, x::AbstractString) where {T<:ICDO3} = T(x)
