using Documenter, ICD10Utilities

makedocs(
	 sitename = "ICD-10 Utilities",
	 modules=[ICD10Utilities],
   pages=[
     "ICD-10" => "index.md",
     "icdo3.md",
     "icd10am.md",
     "icd10cm.md"
   ])

deploydocs(
    repo = "github.com/timbp/ICD10Utilities.jl.git",
    devbranch = "main",
)
