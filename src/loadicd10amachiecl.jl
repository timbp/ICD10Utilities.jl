function importicd10amcodes(fname)
  icdcodes = DataFrame(CSV.File(fname))
  icdcodes.Level = Int8.(icdcodes.Level)
  icdcodes.code_id = ICD10AMCode.(icdcodes.code_id)
  icdcodes.dagger = Bool.(icdcodes.dagger)
  icdcodes.asterisk = Bool.(icdcodes.asterisk)
  icdcodes.valid = Bool.(icdcodes.valid)
  icdcodes.aust_code = Bool.(icdcodes.aust_code)
  dtfmt = DateFormat("d/m/y")
  icdcodes.effective_from = passmissing(Date).(icdcodes.effective_from, dtfmt)
  icdcodes.inactive = passmissing(Date).(icdcodes.inactive, dtfmt)
  icdcodes.reactivated = passmissing(Date).(icdcodes.reactivated, dtfmt)
  icdcodes.sex = recode(categorical(icdcodes.sex, levels=1:2, compress=true), 1 => "male",
                        2 => "female")
  icdcodes.Stype = recode(categorical(icdcodes.Stype, levels=1:2, compress=true),
                          1 => "fatal", 2 => "warning")
  icdcodes.AgeL = passmissing(ICDAge).(icdcodes.AgeL)
  icdcodes.AgeH = passmissing(ICDAge).(icdcodes.AgeH)
  icdcodes.Atype = recode(categorical(icdcodes.Atype, levels=1:2, compress=true),
                          1 => "fatal", 2 => "warning")
  icdcodes.RDiag = Bool.(icdcodes.RDiag)
  icdcodes.Morph_Code = Bool.(icdcodes.Morph_Code)
  icdcodes.concept_change = passmissing(Date).(icdcodes.concept_change, dtfmt)
  icdcodes.UnacceptPDx = Bool.(icdcodes.UnacceptPDx)
  rename!(lowercase, icdcodes)
  save(normpath(@__DIR__, "..", "data", "icd10amcodes.jld2"), Dict("icd10amcodes" => Table(icdcodes)))
  global _ICD10AMcodes_ = Table(icdcodes)
end

function importachicodes(fname)
  achicodes = DataFrame(CSV.File(fname))
  achicodes.Code_id = ACHICode.(achicodes.Code_id)
  achicodes.Block = Int16.(achicodes.Block)
  dtfmt = DateFormat("d/m/y")
  achicodes.effective_from = passmissing(Date).(achicodes.effective_from, dtfmt)
  achicodes.inactive = passmissing(Date).(achicodes.inactive, dtfmt)
  achicodes.sex = recode(categorical(achicodes.sex, levels=1:2, compress=true), 1 => "male",
                        2 => "female")
  achicodes.Stype = recode(categorical(achicodes.Stype, levels=1:2, compress=true),
                          1 => "fatal", 2 => "warning")
  achicodes.AgeL = passmissing(ICDAge).(achicodes.AgeL)
  achicodes.AgeH = passmissing(ICDAge).(achicodes.AgeH)
  achicodes.Atype = recode(categorical(achicodes.Atype, levels=1:2, compress=true),
                          1 => "fatal", 2 => "warning")
  rename!(lowercase, achicodes)
  save(normpath(@__DIR__, "..", "data", "achicodes.jld2"), Dict("achicodes" => Table(achicodes)))
  global _ACHIcodes_ = Table(achicodes)
end
