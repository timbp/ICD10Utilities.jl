# Additional functionality depends on IHPA electronic code lists #####
include("loadicd10amachiecl.jl")

## ICD10AM functions #####

"""
    isvalidcode(icdcode::ICD10AM)

Takes an ICD10AM code and checks it is in the electronic code lists and valid.

Electronic code lists can be obtained from the [Independent Hospital Pricing
Authority](https://www.ihpa.gov.au/what-we-do/icd-10-am-achi-acs-classification),
and need to be imported into the local package before this function
can be used. See [`importicd10amcodes`](@ref)

"Valid" codes are those that exist and are valid for use in coding (e.g.
3-digit codes are often not valid for use if they have 4- or 5-digit subcodes).
"""
function isvalidcode(icdcode::ICD10AM)
  isdefined(ICD10Utilities, :ICD10AMcodes) ||
    isfile(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2")) ||
    error(
      "You need to import the ICD-10-AM/ACHI electronic code lists (obtained from Independent Hospital Pricing Authority at https://ar-drg.laneprint.com.au/) to use validation. Run `importicd10amcodes(<filename>` where `<filename>` is the path to the `disease.txt` file from IHPA.",
    )
  if !isdefined(ICD10Utilities, :ICD10AMcodes)
    global ICD10AMcodes =
      load(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"), "icd10amcodes")
  end

  f(icdcode, codelist = ICD10AMcodes)::Bool =
    icdcode in codelist.icdcode && codelist.validforcoding[codelist.icdcode.==icdcode][]

  return f(icdcode)
end
## TO DO #####
# Need a method that takes a date and checks if the code is inactive on that date.
# also want to be able to check if a code is valid in a particular edition.
