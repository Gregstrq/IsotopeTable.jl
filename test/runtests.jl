using IsotopeTable, Test

O16 = isotopes(:O16)

@testset "Accessing isotopes" begin
    @test O16 === isotopes[:O, 16] === isotopes(:O, 16)
    @test O16 === isotopes["oxygen", 16] === isotopes("oxygen", 16)
    @test O16 === isotopes["oxygen16"] === isotopes("oxygen16")
    @test O16 === isotopes[8, 16] === isotopes(8, 16)
end


hydrogen_isots = isotopes.(:H, 1:7)
hydrogen_arr = map(elements, hydrogen_isots)
hydrogen_arr2 = [elements[hi] for hi in hydrogen_isots]
H = elements[:H]
@testset "Interfacing with Elements" begin
    @test all(map(===, hydrogen_isots, isotopes[H]))
    @test all(map(===, hydrogen_isots, isotopes(H)))
    @test all([H===he for he in hydrogen_arr])
    @test all([H===he for he in hydrogen_arr2])
    @test_throws KeyError elements[isotopes[:n1]]
    @test_throws KeyError elements(isotopes(:n1))
end


