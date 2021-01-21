module ICD10AMUtils

using CSV, TypedTables, DataFrames, Dates, CategoricalArrays
using FileIO

import Base: isless, show, string, ==

export ICD10AMCode, ACHICode
export ICDAge

greet() = print("Hello World!")

struct ICD10AMCode
  ANN::String
  NN::String

  function ICD10AMCode(ANN, NN)
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

function ICD10AMCode(ANNx::String)
  if occursin(".", ANNx)
    ANN, NN = split(ANNx, ".")
    ICD10AMCode(ANN, NN)
  else
    lastindex(ANNx) == 3 ? ICD10AMCode(ANNx, "") :
    ICD10AMCode(ANNx[1:3], ANNx[4:lastindex(ANNx)])
  end
end

function Base.isless(icd1::ICD10AMCode, icd2::ICD10AMCode)
  return icd1.ANN < icd2.ANN || icd1.ANN == icd2.ANN && icd1.NN < icd2.NN
end

Base.isless(str::String, icd::ICD10AMCode) = isless(ICD10AMCode(str), icd)
Base.isless(icd::ICD10AMCode, str::String) = isless(icd, ICD10AMCode(str))

function (==)(str::String, icd::ICD10AMCode)
  return occursin(".", str) ? str == string(icd, punct=true) : str == string(icd)
end
(==)(icd::ICD10AMCode, str::String) = str == icd

# Base.string(icd::ICD10AMCode) = icd.ANN * icd.NN
function Base.string(icd::ICD10AMCode; punct=false)
  return punct ? icd.ANN * "." * icd.NN : icd.ANN * icd.NN
end

Base.show(io::IO, icd::ICD10AMCode) = print(io, icd.ANN * "." * icd.NN)

function isvalidcode(code::ICD10AMCode)
  isdefined(ICD10AMUtils, :icdcodes) ||
    throw(ErrorException("You need to import the ICD10AM/ACHI electronic code lists (obtained from IHPA) to use validation"))
  return code in icdcodes.code_id && icdcodes.valid[icdcodes.code_id .== code][]
end
function isvalidcode(code::ACHICode)
  isdefined(ICD10AMUtils, :achiodes) ||
    throw(ErrorException("You need to import the ICD10AM/ACHI electronic code lists (obtained from IHPA) to use validation"))
  return code in achicodes.code_id && achicodes.valid[achicodes.code_id .== achi][]
end

struct ACHICode
  NNNNN::String
  NN::String

  function ACHICode(NNNNN, NN)
    nnnnn = r"^[[:digit:]]{5}$"
    nn = r"^[[:digit:]]{1,2}$"
    (occursin(nnnnn, NNNNN) && occursin(nn, NN)) ||
      throw(ErrorException("Must follow pattern `NNNNN-NN` where N is decimal digit"))
    return new(NNNNN, NN)
  end
end

function ACHICode(NNNNNx::String)
  if occursin("-", NNNNNx)
    NNNNN, NN = split(NNNNNx, "-")
    ACHICode(NNNNN, NN)
  else
    lastindex(NNNNNx) == 7 ? ACHICode(NNNNNx, "") :
    ACHICode(NNNNNx[1:5], NNNNNx[6:lastindex(NNNNNx)])
  end
end

(==)(str::String, achi::ACHICode) = occursin("-", str) ? str == string(achi, punct=true) : str == string(achi)
(==)(achi::ACHICode, str::String) = str == achi

function (==)(str::String, achi::ACHICode)
  return occursin("-", str) ? str == string(achi, punct=true) : str == string(achi)
end
(==)(achi::ACHICode, str::String) = str == achi

function Base.string(achi::ACHICode; punct=false)
  return punct ? achi.NNNNN * "-" * achi.NN : achi.NNNNN * achi.NN
end

Base.show(io::IO, achi::ACHICode) = print(io, achi.NNNNN * "-" * achi.NN)

struct ICDAge
  agecode::Int16

  function ICDAge(age)
    return (age in 0:6 || age in 11:13 || age in 101:111 || age in 201:324) ? new(age) :
           throw(ErrorException("Invalid age code"))
  end
end

ICDAge(age::String) = ICDAge(parse(Int, age))

function Base.show(io::IO, age::ICDAge)
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

Base.isless(age::ICDAge, age2::ICDAge) = isless(age.agecode, age2.agecode)"), "icdcodes")
  end
  if isfile(normpath(@__DIR__, "..", "data", "achicodes.jld2"))
    global achicodes = load(normpath(@__DIR__, "..", "data", "achicodes.jld2"), "achicodes")
  end
end

end # module
  if isfile(normpath(@__DIR__, "..", "data", "icdcodes.jld2"))
    global icdcodes = load(normpath(@__DIR__, "..", "data", "icdcodes.jld2"), "icdcodes")
  end
  if isfile(normpath(@__DIR__, "..", "data", "achicodes.jld2"))
    global achicodes = load(normpath(@__DIR__, "..", "data", "achicodes.jld2"),
                            "achicodes")
  end
end

end # module
