using Test
using ICD10Utilities
@testset "ICD-10" begin
  @testset "ICD10" begin
    @test_throws DomainError ICD10("A00.000", true, true)
    @test_throws DomainError ICD10("A00.A", true, true)
    @test_throws DomainError ICD10("000.00", true, true)
    @test_throws DomainError ICD10("A00000", false, true)
    @test_throws DomainError ICD10("A00A", false, true)
    @test_throws DomainError ICD10("00000", false, true)

    @test ICD10("A00") < ICD10("A00.01")
    @test ICD10("A00.01") < ICD10("A0002")
    @test ICD10("A00") < "A00.01"
    @test ICD10("A00.01") < "A0002"

    @test ICD10("A00.01") == ICD10("A00.01")
    @test ICD10("A00.01") == "A00.01"
    @test ICD10("A00.01") == "A0001"

    @test ICD10("A00.01") != "A000"

    @test string(ICD10("A00", "00")) == "A00.00"
    @test string(ICD10("A00", "00"); punct = true) == "A00.00"
    @test string(ICD10("A00", "00"); punct = false) != "A00.00"
    @test string(ICD10("A00", "00"); punct = false) == "A0000"

    @test isvalidcode(ICD10("A00"), ["A00.01", "A00.02", "A00"])
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
    @test_throws DomainError ACHI("12345-678", true, true)
    @test_throws DomainError ACHI("12345678", false, true)
    @test_throws DomainError ACHI("A2345-67", true, true)
    @test_throws DomainError ACHI("A234567", false, true)
    @test_throws DomainError ACHI("1234-567", true, true)

    @test ACHI("12345-67", true) == ACHI("1234567", false)
    @test ACHI("12345-67", true) == "1234567"
    @test ACHI("12345-67", true) == "12345-67"
    @test "1234567" == ACHI("12345-67", true)

    @test string(ACHI("12345-67", true)) == "12345-67"
    @test string(ACHI("12345-67", true), true) == "12345-67"
    @test string(ACHI("12345-67", true), false) == "1234567"
  end

  @testset "ICD10AM age coding" begin
    @test_throws DomainError ICD10AMAge(7)
    @test_throws DomainError ICD10AMAge("15")
  end

  @testset "ICD10AM/ACHI functions requiring electronic codes lists" begin
    if isdefined(ICD10Utilities, :_ICD10AMcodes_)
      @test isvalidcode(ICD10AM("A00.1"))
      @test isvalidcode(ICD10AM("A001", false))
      @test !isvalidcode(ICD10AM("A00"))
    else
      @test_throws ErrorException isvalidcode(ICD10AM("A00.1"))
    end
    if isdefined(ICD10Utilities, :_ACHIcodes_)
      @test isvalidcode(ACHI("10801-00"))
      @test isvalidcode(ACHI("1080100", false))
      @test !isvalidcode(ACHI("12345-67"))
    else
      @test_throws ErrorException isvalidcode(ACHI("10801-00"))
    end
  end
end
