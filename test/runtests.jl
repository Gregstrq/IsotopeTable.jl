using IsotopeTable, Test

O16 = isotopes(:O16)

@testset "Accessing isotopes" begin
    @test O16 === isotopes[:O, 16] === isotopes(:O, 16)
    @test O16 === isotopes["oxygen", 16] === isotopes("oxygen", 16)
    @test O16 === isotopes["oxygen16"] === isotopes("oxygen16")
    @test O16 === isotopes[8, 16] === isotopes(8, 16)
end

@testset "Accessing isomers" begin
    Np236 = isotopes(:Np236)
    @test Np236 === isotopes[:Np, 236] === isotopes(:Np, 236)
    @test Np236 === isotopes["neptunium", 236] === isotopes("neptunium", 236)
    @test Np236 === isotopes["neptunium236"] === isotopes("neptunium236")
    @test Np236 === isotopes[93, 236] === isotopes(93, 236)
    Np236m = isotopes(:Np236m1)
    @test Np236m === isotopes[:Np, 236, 1] === isotopes(:Np, 236, 1)
    @test Np236m === isotopes["neptunium", 236, 1] === isotopes("neptunium", 236, 1)
    @test Np236m === isotopes["neptunium236m1"] === isotopes("neptunium236m1")
    @test Np236m === isotopes[93, 236, 1] === isotopes(93, 236, 1)
end

@testset "Comparisons" begin
    Np235 = isotopes(:Np235)
    Np236 = isotopes(:Np236)
    Np236m = isotopes(:Np236m1)
    Np237 = isotopes(:Np237)
    @test Np235 < Np236
    @test Np236 < Np236m
    @test Np236m < Np237
    @test Np235 < Np237
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


