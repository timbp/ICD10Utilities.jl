# ICD10Utilities.jl

```@meta
CurrentModule = ICD10Utilities
```

This package provide functions for working with ICD-10 codes.

It is intended for researchers working with ICD-10 codes in administrative
health data. This is not a package for clinical coding.

!!! note

    There are no ICD codes included in this package.

## ICD-10

The _International Classification of Diseases and Related Health Problems_ is
more than 100 years old. The tenth revision,
_International Classification of and Related Health Problems, 10th Revision_ (ICD-10)
was first released by the World Health Organization (WHO) in 1992. It is used
for classifying diagnoses in health data.

Some countries have developed customised versions under licence from WHO. These
include Australia (ICD-10-AM), Canada (ICD-10-CA), the United States
(ICD-10-CM), and Germany (ICD-10-GM). This package defines types for each of
these customised versions, and functions for working with them.

## Use

An ICD-10 code can be created from a string using [`ICD10("A00.1")`](@ref
ICD10). Similar constructors exist for the country-specific versions (e.g.
[`ICD10AM("A00.1")`](@ref ICD10AM(::String))).

Some databases store ICD-10 codes as strings without the `.`. The constructor
will recognise this and correctly parse the string as an ICD-10 code.

You can also validate the input format by passing a second argument (e.g.
[`ICD10CA("A00.1", true)`](@ref ICD10CA(::String))). This will usually not
be necessary as in most cases codes will be obtained from a health database and
so will already have been validated. It is  slower to validate the input
format.

## Types

```@docs
AbstractICD10
ICD10
ICD10AM
ICD10CA
ICD10GM
```

## Functions

```@docs
ICD10(::String)
ICD10(::AbstractICD10)
ICD10AM(::String)
ICD10AM(::AbstractICD10)
ICD10CA(::String)
ICD10CA(::AbstractICD10)
ICD10GM(::String)
ICD10GM(::AbstractICD10)
isvalidcode(icd::AbstractICD10, validcodes)
icd3(::AbstractICD10)
icd4(::AbstractICD10)
seticdpunct(::Bool)
```

## Options
```@docs
ICDOPTS
```
