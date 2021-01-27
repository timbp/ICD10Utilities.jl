"""
    importicd10amcodes(fname)

Import the ICD-10-AM electronic code lists into the package.

Electronic code lists can be obtained from the [Independent Hospital Pricing
Authority](https://www.ihpa.gov.au/what-we-do/icd-10-am-achi-acs-classification).

This function just imports the `disease.txt` table.
"""
function importicd10amcodes(fname)
  icdcodes = CSV.File(fname)
  Level = Int8.(icdcodes.Level)
  code_id = ICD10AM.(icdcodes.code_id)
  dagger = Bool.(icdcodes.dagger)
  asterisk = Bool.(icdcodes.asterisk)
  valid = Bool.(icdcodes.valid)
  aust_code = Bool.(icdcodes.aust_code)
  ascii_desc = String.(icdcodes.ascii_desc)
  ascii_short_desc = String.(icdcodes.ascii_short_desc)
  dtfmt = DateFormat("d/m/y")
  effective_from = passmissing(Date).(icdcodes.effective_from, dtfmt)
  inactive = passmissing(Date).(icdcodes.inactive, dtfmt)
  reactivated = passmissing(Date).(icdcodes.reactivated, dtfmt)
  sex = recode(
    categorical(icdcodes.sex; levels = 1:2, compress = true),
    1 => "male",
    2 => "female",
  )
  Stype = recode(
    categorical(icdcodes.Stype; levels = 1:2, compress = true),
    1 => "fatal",
    2 => "warning",
  )
  AgeL = passmissing(ICD10AMAge).(icdcodes.AgeL)
  AgeH = passmissing(ICD10AMAge).(icdcodes.AgeH)
  Atype = recode(
    categorical(icdcodes.Atype; levels = 1:2, compress = true),
    1 => "fatal",
    2 => "warning",
  )
  RDiag = Bool.(icdcodes.RDiag)
  Morph_Code = Bool.(icdcodes.Morph_Code)
  concept_change = passmissing(Date).(icdcodes.concept_change, dtfmt)
  UnacceptPDx = Bool.(icdcodes.UnacceptPDx)
  global ICD10AMcodes = Table(;
    level = Level,
    icdcode = code_id,
    dagger = dagger,
    asterisk = asterisk,
    validforcoding = valid,
    australiancode = aust_code,
    description = ascii_desc,
    shortdescription = ascii_short_desc,
    effectivefrom = effective_from,
    inactive = inactive,
    reactivated = reactivated,
    sex = sex,
    stype = Stype,
    agel = AgeL,
    ageh = AgeH,
    atype = Atype,
    rarenotifiabledx = RDiag,
    morphcoderequired = Morph_Code,
    conceptchange = concept_change,
    unacceptpdx = UnacceptPDx,
  )
  save(
    normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"),
    Dict("icd10amcodes" => Table(ICD10AMcodes)),
  )
end

"""
    importachicodes(fname)

Import the ACHI electronic code lists into the package.

Electronic code lists can be obtained from the [Independent Hospital Pricing
Authority](https://www.ihpa.gov.au/what-we-do/icd-10-am-achi-acs-classification).

This function just imports the `interven.txt` table.
"""
function importachicodes(fname)
  achicodes = CSV.File(fname)
  Code_id = ACHI.(achicodes.Code_id)
  Code_id = ACHI.(achicodes.Code_id)
  Block = Int16.(achicodes.Block)
  dtfmt = DateFormat("d/m/y")
  ascii_desc = String.(achicodes.ascii_desc)
  ascii_short_desc = String.(achicodes.ascii_short_desc)
  effective_from = passmissing(Date).(achicodes.effective_from, dtfmt)
  inactive = passmissing(Date).(achicodes.inactive, dtfmt)
  sex = recode(
    categorical(achicodes.sex; levels = 1:2, compress = true),
    1 => "male",
    2 => "female",
  )
  Stype = recode(
    categorical(achicodes.Stype; levels = 1:2, compress = true),
    1 => "fatal",
    2 => "warning",
  )
  AgeL = passmissing(ICD10AMAge).(achicodes.AgeL)
  AgeL = passmissing(ICD10AMAge).(achicodes.AgeL)
  AgeH = passmissing(ICD10AMAge).(achicodes.AgeH)
  Atype = recode(
    categorical(achicodes.Atype; levels = 1:2, compress = true),
    1 => "fatal",
    2 => "warning",
  )
  global ACHIcodes = Table(;
    achicode = Code_id,
    block = Block,
    description = ascii_desc,
    shortdescription = ascii_short_desc,
    effectivefrom = effective_from,
    inactive = inactive,
    sex = sex,
    stype = Stype,
    agel = AgeL,
    ageh = AgeH,
    atype = Atype,
  )
  save(
    normpath(@__DIR__, "..", "data", "achicodes.jld2"),
    Dict("achicodes" => Table(ACHIcodes)),
  )
end
