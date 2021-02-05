# ICD-10-CM

ICD-10-CM is the United States Clinical Modification of ICD-10.

It differs from other version in allowing up to 7 digits in codes, and allowing
letters as well as numbers in digits 3--7.

## Types
```@docs
ICD10CM
```

## Functions

```@docs
ICD10CM(::String)
ICD10CM(::AbstractICD10)
ICD10(::ICD10CM)
ICD10AM(::ICD10CM)
ICD10CA(::ICD10CM)
ICD10GM(::ICD10CM)
```
