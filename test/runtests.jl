using Test
using ICD10Utilities
@testset "ICD-10-AM/ACHI" begin
  @testset "ICD10AM" begin
    @test_throws DomainError ICD10AM("A00.000")
    @test_throws DomainError ICD10AM("A00.A")
    @test_throws DomainError ICD10AM("000.00")
    @test_throws DomainError ICD10AM("A00000")
    @test_throws DomainError ICD10AM("A00A")
    @test_throws DomainError ICD10AM("00000")

    @test ICD10AM("A00") < ICD10AM("A00.01")
    @test ICD10AM("A00.01") < ICD10AM("A0002")
    @test ICD10AM("A00") < "A00.01"
    @test ICD10AM("A00.01") < "A0002"

    @test ICD10AM("A00.01") == ICD10AM("A00.01")
    @test ICD10AM("A00.01") == "A00.01"
    @test ICD10AM("A00.01") == "A0001"

    @test ICD10AM("A00.01") != "A000"

    @test string(ICD10AM("A00", "00")) == "A00.00"
    @test string(ICD10AM("A00", "00"); punct = true) == "A00.00"
    @test string(ICD10AM("A00", "00"); punct = false) != "A00.00"
    @test string(ICD10AM("A00", "00"); punct = false) == "A0000"

    @test isvalidcode(ICD10AM("A00"), ["A00.01", "A00.02", "A00"])
  end

  @testset "ACHI" begin
    @test_throws DomainError ACHI("12345-678")
    @test_throws DomainError ACHI("12345678")
    @test_throws DomainError ACHI("A2345-67")
    @test_throws DomainError ACHI("A234567")
    @test_throws DomainError ACHI("1234-567")

    @test ACHI("12345-67") == ACHI("1234567")
    @test ACHI("12345-67") == "1234567"
    @test ACHI("12345-67") == "12345-67"
    @test "1234567" == ACHI("12345-67")

    @test string(ACHI("12345-67")) == "12345-67"
    @test string(ACHI("12345-67"); punct = true) == "12345-67"
    @test string(ACHI("12345-67"); punct = false) == "1234567"
  end

  @testset "ICD10AM age coding" begin
    @test_throws DomainError ICD10AMAge(7)
    @test_throws DomainError ICD10AMAge("15")
  end
end