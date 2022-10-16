# IsotopeTable.jl

The package provides [PeriodicTable.jl](https://github.com/JuliaPhysics/PeriodicTable.jl) inspired interface to the data on various isotopes. The data on Isotopes was generated using [this repo](https://github.com/Gregstrq/Isotope-data).

[![Build status (Github Actions)](https://github.com/Gregstrq/IsotopeTable.jl/workflows/CI/badge.svg)](https://github.com/Gregstrq/IsotopeTable.jl/actions)
[![codecov.io](http://codecov.io/github/Gregstrq/IsotopeTable.jl/coverage.svg?branch=main)](http://codecov.io/github/Gregstrq/IsotopeTable.jl?branch=main)

## Overview

Similarly to [PeriodicTable.jl](https://github.com/JuliaPhysics/PeriodicTable.jl),
`IsotopeTable.jl` exports the global variable `isotopes`, which is a collection of `Isotope` structures.

### Accessing Isotopes

In this package, we consider only the isotopes in the nuclear ground states. Therefore, each isotope is uniquely identified by its atomic number (number of protons) and mass number (total number of protons and neutrons). Each isotope corresponds to a unique element of Periodic Table, which has the same atomic number. As such, instead of atomic number, one can use interchangeably element symbol, element name (case insensitive) and even `Element` structure from `PeriodicTable.jl` itself!

Let's consider the isotope ¹²C, which has atomic number 6 and mass number 12.
These are all the valid ways to access information about it:

|                         | indexing interface           | function interface            |
| :---------------------- | :-----------------           | :-----------------            |
| atomic and mass numbers | `isotopes[6, 12]`            | `isotopes(6, 12)`             |
| symbol, mass number     | `isotopes[:C, 12]`           | `isotopes(:C, 12)`            |
| symbol + mass number    | `isotopes[:C12]`             | `isotopes(:C12)`              |
| name, mass number       | `isotopes["carbon", 12]`     | `isotopes("carbon", 12)`      |
| name + mass number      | `isotopes["carbon12"]`       | `isotopes("carbon12")`        |
| Element, mass number    | `isotopes[elements[:C], 12]` | `isotopes(elements[:C], 12)`  |

### Interfacing with PeriodicTable.jl

As we have already seen, we can use an `Element` in place of atomic number to access a particular isotope.
But there are additional neat tricks in store.

`isotopes[elements[:C]]` or `isotopes(elements[:C])` returns the vector of all the carbon isotopes.
Correspondingly, `elements[isotopes[:C12]]` or `elements(isotopes[:C12])` returns the carbon element from PeriodicTable.jl.

### Pretty printing

When you look up an isotope in the REPL, the data is pretty printed:
```julia
julia> isotopes[:H3]
Hydrogen ³H, Z=1:
               atomic number: 1
                 mass number: 3
           natural abundance: 0.0
                        mass: 3.01604928132 ± 8.0e-11 u
                        spin: 1//2
                      parity: 1
              is radioactive: true
                   half-life: 3.8878e8 ± 630000.0 s
                    g-factor: 5.95792492 ± 2.8e-8
  electric quadrupole moment: 0.0 ± 0.0 barn
```
