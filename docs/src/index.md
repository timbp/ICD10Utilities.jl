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
more than 100 years old. The tenth revision, _International Classification of
Diseases and Related Health Problems, 10th Revision_ (ICD-10) was first released
by the World Health Organization (WHO) in 1992. It is used for classifying
diagnoses (and place and cause) in health data.

Some countries have developed customised versions under licence from WHO. These
include Australia (ICD-10-AM), Canada (ICD-10-CA), the United States
(ICD-10-CM), and Germany (ICD-10-GM). This package defines types for each of
these customised versions, and functions for working with them.

## Use

An ICD-10 code can be created from a string using [`ICD10("A00.1")`](@ref
ICD10). Similar constructors exist for the country-specific versions (e.g.
[`ICD10AM("A00.1")`](@ref ICD10AM(::String))).

Some databases store ICD-10 codes as strings without the `.`. In this case, you
can pass a second argument `false` to indicate that punctuation is not used
(e.g. [`ICD10AM("A001", false)`](@ref ICD10AM(::String))). If you do not set the
second argument correctly for your input, you wiil get wrong codes as output.

You can also validate the input format by passing a third argument (e.g.
[`ICD10CA("A00.1", true, true)`](@ref ICD10CA(::String))). This will usually not
be necessary as in most cases codes will be obtained from a health database and
so will already have been validated. It is much slower to validate the input
format.

ICD10 codes can be compared lexicographically using `<`, `>`, or `isless`.

Codes of the same type can be tested for equality (e.g.
`ICD10AM("A00.1") == ICD10AM("A001", false)`), but codes of different types
cannot be directly compared as there is no guarantee that the same code in
different versions indicates the same concept. You can convert to `String` to
compare codes of different types.

## Types

```@docs
ICD10
ICD10AM
ICD10CA
ICD10CM
ICD10GM
```

## Functions

```@docs
ICD10(::String)
ICD10(::ICD10Code)
ICD10AM(::String)
ICD10AM(::ICD10Code)
ICD10CA(::String)
ICD10CA(::ICD10Code)
ICD10CM(::String)
ICD10CM(::ICD10Code)
ICD10GM(::String)
ICD10GM(::ICD10Code)
Base.string(::ICD10Code)
isvalidcode(icd::ICD10Code, validcodes)
```
