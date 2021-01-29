Base.convert(::Type{T}, x::AbstractString) where {T<:AbstractICD10} = T(x)

Base.print(io::IO, icd::T, punct = ICDOPTS[:punct]) where {T<:AbstractICD10} =
  if punct
    if icd.level == 3
      write(io, Ref(icd.ANN), '.')
    elseif icd.level == 4
      write(io, Ref(icd.ANN), '.', Ref(icd.N4))
    elseif icd.level == 5
      write(io, Ref(icd.ANN), '.', Ref(icd.N4), Ref(icd.N5))
    end
  else
    if icd.level == 3
      write(io, Ref(icd.ANN))
    elseif icd.level == 4
      write(io, Ref(icd.ANN), Ref(icd.N4))
    elseif icd.level == 5
      write(io, Ref(icd.ANN), Ref(icd.N4), Ref(icd.N5))
    end
  end

Base.show(io::IO, icd::T) where {T<:AbstractICD10} = print(io, icd)

Base.isless(icd::AbstractICD10, icd2::AbstractICD10) =
(icd.ANN..., icd.N4, icd.N5) < (icd2.ANN..., icd2.N4, icd2.N5)

Base.length(icd::T) where {T<:AbstractICD10} = icd.level

Base.:(==)(icd1::AbstractICD10, icd2::AbstractICD10) = (icd1.ANN..., icd1.N4, icd1.N5) == (icd2.ANN..., icd2.N4, icd2.N5)
## ICD10 functions #####

"""
    isvalidcode(icd, validcodes)

Takes an AbstractICD10 and compares it with a list of valid codes.
"""
isvalidcode(icd::T, validcodes) where {T<:AbstractICD10} = icd in validcodes

"""
    icd3(icdcode)

Returns the initial 3 digits of an ICD10 code as NTuple{3,UInt8}. Use for
comparing codes just on first 3 digits.
"""
icd3(icdcode::T) where {T<:AbstractICD10} = icdcode.ANN

"""
    icd4(icdcode)

Returns the initial 4 digits of an ICD10 code as NTuple{4,UInt8}. Use for
comparing codes just on first 4 digits.
"""
icd4(icdcode::T) where {T<:AbstractICD10} = (icdcode.ANN..., icdcode.N4)
