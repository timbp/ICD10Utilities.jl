# ICD-10-AM/ACHI

ICD-10-AM is the Australian modification of ICD-10. It has been in use for coding
diagnoses in all Australian public and private hospitals since 1998.

The _Australian Classification of Health Interventions_ is a companion coding
system for coding medical procedures and other interventions in Australia.

ICD-10-AM/ACHI is updated every 2--3 years. THe current 11th edition has been
in use since 1 July 2019.

ICD-10-AM/ACHI and the _Australian Coding Standards_ (ACS) are available for
purchase from the
[Independent Hospital Pricing Authority (IHPA)](https://www.ihpa.gov.au/what-we-do/icd-10-am-achi-acs-classification).

If you have access to the ICD-10-AM/ACHI electronic code lists (from IHPA), you
can import them into this package (see
[`ICD10Utilities.importicd10amcodes`](@ref) and
[`ICD10Utilities.importachicodes`](@ref) ) and use them for validating codes and
conducting other queries (e.g. look up description from a code).

Once imported, the codes are available in global variables
[ICD-10-AM code list](@ref) and [ACHI code list](@ref).

## Functions

### ICD-10-AM

```@docs
ICD10Utilities.importicd10amcodes
isvalidcode(::ICD10AM)
```

### ACHI

```@docs
ACHI
ACHI(::String)
ICD10Utilities.importachicodes
isvalidcode(::ACHI)
Base.string(::ACHI)
```

## Code lists

!!! note

    These tables are only available if you have imported the electronic code
    lists obtained from IHPA.

### ICD-10-AM code list

    ICD10Utilities._ICD10AMcodes_

The imported ICD-10-AM electronic code list.

This is a [`TypedTable`](https://typedtables.juliadata.org/stable/) created from
the `disease.txt` table in the electronic code lists. Some variable names are
changed.

\_ICD10AMcodes\_  | disease.txt    | description
------------------|----------------|--------------------------------------------------------------------------
level             | Level          | Number of digits in the code (3, 4, 5)
icdcode           | code\_id       | ICD-10-AM code
dagger            | dagger         | Is this a dagger code
asterisk          | asterisk       | Is this an asterisk code
validforcoding    | valid          | Can this code be used in coding, or is it just a placeholder for subcodes
australiancode    | australian     | Is this an Australian code (not part of WHO ICD-10)
description       | ascii_desc     | Description of the coded concept
shortdescription  | ascii_short_desc | Abbreviated description
effectivefrom     | effective\_from| Date the code came into use
inactive          | inactive       | Date when code became inactive
reactivated       | reactivated    | Date when code was reactivated
sex               | Sex            | Is code sex specific
stype             | Stype          |
agel              | AgeL           | Minimum patient age for assigning the code
ageh              | AgeH           | Maximum patient age for assigning the code
atype             | Atype          |
rarenotifiabledx  | RDiag          | Code refers to a rare or notifiable disease
morphcoderequired | Morph\_Code    | Use of this code requires an accompanying morphology code
conceptchange     | concept_change | Date this code was introduced to represent a new concept
unacceptpdx       | UnacceptPDx    | Can this code be used as a principal diagnosis

### ACHI code list

    ICD10Utilities._ACHIcodes_

The imported ACHI electronic code list.

This is a [`TypedTable`](https://typedtables.juliadata.org/stable/) created from
the `interven.txt` table in the electronic code lists. Some variable names are
changed.

\_ACHIcodes\_    | interven.txt       | description
-----------------|--------------------|-------------------------------------------
achicode         | Code\_id           | ACHI code
block            | Block              | ACHI block that includes the code
description      | ascii\_desc        | Description of the intervention
shortdescription | ascii\_short\_desc | Abbreviated description
effectivefrom    | effective\_from    | Date the code came into use
inactive         | inactive           | Date the code became inactive
sex              | Sex                | Code is sex-specific
stype            | Stype              |
agel             | AgeL               | Minimum patient age for assigning this code
ageh             | AgeH               | Maximum patient age for assigning this code
atype            | Atype              |
