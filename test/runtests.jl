using Test
using ICD10Utilities
@testset "ICD-10" begin
  @testset "ICD10" begin
    @test_throws DomainError ICD10("A00.000", true)
    @test_throws DomainError ICD10("A00.A", true)
    @test_throws DomainError ICD10("000.00", true)
    ICDOPTS[:punct] = false
    @test_throws DomainError ICD10("A00000",  true)
    @test_throws DomainError ICD10("A00A",  true)
    @test_throws DomainError ICD10("00000",  true)
    ICDOPTS[:punct] = true

    @test ICD10("A00") < ICD10("A00.01")
    @test ICD10("A00.01") < ICD10("A0002")

    @test ICD10("A00.01") == ICD10("A00.01")

    @test string(ICD10("A0000")) == "A00.00"
    @test string(ICD10("A0000")) == "A00.00"

    ICDOPTS[:punct] = false
    @test string(ICD10("A0000")) != "A00.00"
    @test string(ICD10("A0000")) == "A0000"
    ICDOPTS[:punct] = true

    @test isvalidcode(ICD10("A00"), ICD10["A00.01", "A00.02", "A00"])
  end
  @testset "Other ICD-10 versions" begin
    @test isdefined(ICD10Utilities, :ICD10AM)
    @test isdefined(ICD10Utilities, :ICD10CA)
    @test isdefined(ICD10Utilities, :ICD10CM)
    @test isdefined(ICD10Utilities, :ICD10GM)
  end
end

@testset "ICD10AM/ACHI" begin
  @testset "ACHI" begin
    @test_throws DomainError ACHI("12345-678", true)
    @test_throws DomainError ACHI("12345678", true)
    @test_throws DomainError ACHI("A2345-67", true)
    @test_throws DomainError ACHI("A234567", true)
    @test_throws DomainError ACHI("1234-567", true)

    @test ACHI("12345-67") == ACHI("1234567")

    ICDOPTS[:punct] = true
    @test string(ACHI("12345-67")) == "12345-67"
    ICDOPTS[:punct] = false
    @test string(ACHI("12345-67")) == "1234567"
    ICDOPTS[:punct] = true
  end

  @testset "ICD10AM age coding" begin
    @test_throws DomainError ICD10AMAge(7)
    @test_throws DomainError ICD10AMAge("15")
  end

  @testset "ICD10AM/ACHI functions requiring electronic codes lists" begin
    if isdefined(ICD10Utilities, :_ICD10AMcodes_)
      @test isvalidcode(ICD10AM("A00.1"))
      @test !isvalidcode(ICD10AM("A00"))
    else
      @test_throws ErrorException isvalidcode(ICD10AM("A00.1"))
    end
    if isdefined(ICD10Utilities, :_ACHIcodes_)
      @test isvalidcode(ACHI("10801-00"))
      @test !isvalidcode(ACHI("12345-67"))
    else
      @test_throws ErrorException isvalidcode(ACHI("10801-00"))
    end
  end
end
