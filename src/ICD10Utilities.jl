module ICD10Utilities

using CSV, TypedTables, DataFrames, Dates, CategoricalArrays
using FileIO

import Base: isless, show, string, ==

export ICD10Code
export ICD10AM, ACHI
export ICD10AMAge
export isvalidcode

greet() = print("Hello World!")

abstract type ICD10Code end

struct ICD10AM <: ICD10Code
  ANN::String
  NN::String

  function ICD10AM(ANN, NN)
    ann = r"^[[:upper:]][[:digit:]]{2}$"
    nn = r"^[[:digit:]]{1,2}$"
    NN = isnothing(NN) ? "" : NN
    occursin(ann, ANN) ||
      throw(ErrorException("Must follow pattern `ANN.[N[N]]` where A is upper case letter, N is decimal digit, and parts in brackets are optional"))
    (NN == "" || occursin(nn, NN)) ||
      throw(ErrorException("Must follow pattern `ANN.[N[N]]` where A is upper case letter, N is decimal digit, and parts in brackets are optional"))
    return new(ANN, NN)
  end
end

function ICD10AM(ANNx::String)
  if occursin(".", ANNx)
    ANN, NN = split(ANNx, ".")
    ICD10AM(ANN, NN)
  else
    lastindex(ANNx) == 3 ? ICD10AM(ANNx, "") :
    ICD10AM(ANNx[1:3], ANNx[4:lastindex(ANNx)])
  end
end

function Base.isless(icd1::ICD10Code, icd2::ICD10Code)
  return icd1.ANN < icd2.ANN || icd1.ANN == icd2.ANN && icd1.NN < icd2.NN
end

Base.isless(str::String, icd::ICD10Code) = isless(str, string(icd))
Base.isless(icd::ICD10Code, str::String) = isless(string(icd), str)

function (==)(str::String, icd::ICD10Code)
  return occursin(".", str) ? str == string(icd, punct = true) : str == string(icd, punct=false)
end
(==)(icd::ICD10Code, str::String) = str == icd

function Base.string(icd::ICD10Code; punct = true)
  return punct ? icd.ANN * "." * icd.NN : icd.ANN * icd.NN
end

Base.show(io::IO, icd::ICD10Code) = print(io, icd.ANN * "." * icd.NN)

function isvalidcode(icd::ICD10Code, validcodes)
  return icd in validcodes
end

function isvalidcode(code::ICD10AM)
  isdefined(ICD10Utilities, :_ICD10AMcodes_) ||
    throw(ErrorException("You need to import the ICD-10-AM/ACHI electronic code lists (obtained from Independent Hospital Pricing Authority at https://ar-drg.laneprint.com.au/) to use validation"))
  return code in _ICD10AMcodes_.code_id && _ICD10AMcodes_.valid[_ICD10AMcodes_.code_id.==code][]
end

struct ACHI
  NNNNN::String
  NN::String

  function ACHI(NNNNN, NN)
    nnnnn = r"^[[:digit:]]{5}$"
    nn = r"^[[:digit:]]{1,2}$"
    (occursin(nnnnn, NNNNN) && occursin(nn, NN)) ||
      throw(ErrorException("Must follow pattern `NNNNN-NN` where N is decimal digit"))
    return new(NNNNN, NN)
  end
end

function ACHI(NNNNNx::String)
  if occursin("-", NNNNNx)
    NNNNN, NN = split(NNNNNx, "-")
    ACHI(NNNNN, NN)
  else
    ACHI(NNNNNx[1:5], NNNNNx[6:lastindex(NNNNNx)])
  end
end

function (==)(str::String, achi::ACHI)
  occursin("-", str) ? str == string(achi, punct = true) : str == string(achi; punct=false)
end
(==)(achi::ACHI, str::String) = str == achi

function Base.string(achi::ACHI; punct = true)
  return punct ? achi.NNNNN * "-" * achi.NN : achi.NNNNN * achi.NN
end

Base.show(io::IO, achi::ACHI) = print(io, achi.NNNNN * "-" * achi.NN)

function isvalidcode(achi::ACHI)
  isdefined(ICD10AMUtilities, :_ACHIcodes_) ||
    throw(ErrorException("You need to import the ICD10AM/ACHI electronic code lists (obtained from Independent Hospital Pricing Authority at https://ar-drg.laneprint.com.au/) to use validation"))
  return code in _ACHIcodes_.code_id && _ACHIcodes_.valid[_ACHIcodes_.code_id.==achi][]
end

struct ICD10AMAge
  agecode::Int16

  function ICD10AMAge(age)
    return (age in 0:6 || age in 11:13 || age in 101:111 || age in 201:324) ? new(age) :
           throw(ErrorException("Invalid age code"))
  end
end

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

function __init__()
  if isfile(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"))
    global _ICD10AMcodes_ = load(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"), "icd10amcodes")
  end
  if isfile(normpath(@__DIR__, "..", "data", "achicodes.jld2"))
    global _ACHIcodes_ =
      load(normpath(@__DIR__, "..", "data", "achicodes.jld2"), "achicodes")
  end
end

end # module
