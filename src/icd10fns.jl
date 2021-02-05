Base.convert(::Type{T}, x::AbstractString) where {T<:AbstractICD10} = T(x)

Base.print(io::IO, icd::T, punct = ICDOPTS[:punct]) where {T<:AbstractICD10} =
  if punct
    if icd.level == 3
      write(io, Ref(icd.data[1:3]), '.')
    elseif icd.level == 4
      write(io, Ref(icd.data[1:3]), '.', Ref(icd.data[4]))
    elseif icd.level == 5
      write(io, Ref(icd.data[1:3]), '.', Ref(icd.data[4:5]))
    elseif icd.level == 6
      write(io, Ref(icd.data[1:3]), '.', Ref(icd.data[4:6]))
    elseif icd.level == 7
      write(io, Ref(icd.data[1:3]), '.', Ref(icd.data[4:7]))
    end
  else
    write(io, Ref(icd.data[1:icd.level]))
  end

Base.show(io::IO, icd::T) where {T<:AbstractICD10} = print(io, icd)

Base.isless(icd1::AbstractICD10, icd2::AbstractICD10) = icd1.data < icd2.data

Base.length(icd::T) where {T<:AbstractICD10} = icd.level

Base.:(==)(icd1::AbstractICD10, icd2::AbstractICD10) =
  icd1.level == icd2.level && icd1.data == icd2.data

## ICD10 functions #####

"""
    isvalidcode(icd, validcodes)

Takes an AbstractICD10 and compares it with a list of valid codes.
"""
isvalidcode(icd::T, validcodes) where {T<:AbstractICD10} = icd in validcodes

"""
    icd3(icdcode)

Returns the initial 3 digits of an ICD10 code. Use for
comparing codes just on first 3 digits.
"""
icd3(icdcode::T) where {T<:AbstractICD10} = icdcode.data[1:3]

"""
    icd4(icdcode)

Returns the initial 4 digits of an ICD10 code. Use for
comparing codes just on first 4 digits.
"""
icd4(icdcode::T) where {T<:AbstractICD10} = icdcode.data[1:4]
