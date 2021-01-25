using Documenter, ICD10Utilities

makedocs(
	 sitename = "ICD-10 Utilities",
	 modules=[ICD10Utilities])

deploydocs(
    repo = "github.com/timbp/ICD10Utilities.jl.git",
)
