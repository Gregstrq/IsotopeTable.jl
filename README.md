# IsotopeTable.jl

The package provides [PeriodicTable.jl](https://github.com/JuliaPhysics/PeriodicTable.jl) inspired interface to the data on various isotopes. The data on Isotopes was generated using [this repo](https://github.com/Gregstrq/Isotope-data).

[![Build status (Github Actions)](https://github.com/Gregstrq/IsotopeTable.jl/workflows/CI/badge.svg)](https://github.com/Gregstrq/IsotopeTable.jl/actions)
[![codecov.io](http://codecov.io/github/Gregstrq/IsotopeTable.jl/coverage.svg?branch=main)](http://codecov.io/github/Gregstrq/IsotopeTable.jl?branch=main)

## Overview

Similarly to [PeriodicTable.jl](https://github.com/JuliaPhysics/PeriodicTable.jl),
`IsotopeTable.jl` exports the global variable `isotopes`, which is a collection of `Isotope` structures.

### Accessing Isotopes

In this package, we consider nuclides in the nuclear ground states and metastable states. Therefore, each nuclide is uniquely identified by its atomic number (number of protons), mass number (total number of protons and neutrons) and metastable state (ground state, first metastable state etc.). Each nuclide corresponds to a unique element of Periodic Table, which has the same atomic number. As such, instead of atomic number, one can use interchangeably element symbol, element name (case insensitive) and even `Element` structure from `PeriodicTable.jl` itself!

Let's consider the nuclide ¹²C, which has atomic number 6 and mass number 12.
These are all the valid ways to access information about it:

|                         | indexing interface           | function interface            |
| :---------------------- | :-----------------           | :-----------------            |
| atomic and mass numbers | `isotopes[6, 12]`            | `isotopes(6, 12)`             |
| symbol, mass number     | `isotopes[:C, 12]`           | `isotopes(:C, 12)`            |
| symbol + mass number    | `isotopes[:C12]`             | `isotopes(:C12)`              |
| name, mass number       | `isotopes["carbon", 12]`     | `isotopes("carbon", 12)`      |
| name + mass number      | `isotopes["carbon12"]`       | `isotopes("carbon12")`        |
| Element, mass number    | `isotopes[elements[:C], 12]` | `isotopes(elements[:C], 12)`  |

Also isomers (metastable states) can be accessed. The ground state is selected by using the standard way mentioned above. For the metastable states, the letter "m" is appended together with an index 1, 2, 3, ... Take, Np236 for example:

|                         | indexing interface           | function interface            |
| :---------------------- | :-----------------           | :-----------------            |
| atomic and mass numbers | `isotopes[93, 236]`            | `isotopes(93, 236)`             |
| atomic, mass numbers, isomeric state | `isotopes[93, 236, 1]`            | `isotopes(93, 236, 1)`             |
| symbol, mass number, isomeric state    | `isotopes[:Np, 236, 1]`           | `isotopes(:Np, 236, 1)`            |
| name, mass number, isomeric state       | `isotopes["neptunium", 236, 1]`     | `isotopes("neptunium", 236, 1)`      |
| name + mass number + isomeric state     | `isotopes["neptunium236m1"]`       | `isotopes("neptunium236m1")`        |

### Interfacing with PeriodicTable.jl

As we have already seen, we can use an `Element` in place of atomic number to access a particular isotope.
But there are additional neat tricks in store.

`isotopes[elements[:C]]` or `isotopes(elements[:C])` returns the vector of all the carbon isotopes.
Correspondingly, `elements[isotopes[:C12]]` or `elements(isotopes[:C12])` returns the carbon element from PeriodicTable.jl.

### Pretty printing

When you look up an isotope in the REPL, the data is pretty printed:
```julia
julia> isotopes[:C12]
Carbon ¹²C, Z=6:
               atomic number: 6
                 mass number: 12
                 isomeric state: Ground state
           natural abundance: 98.94
                        mass: 12.0 ± 0.0 u
                        spin: 0//1
                      parity: 1
              is radioactive: false
                   half-life: Inf ± 0.0 s
                    g-factor: 0.0 ± 0.0
  electric quadrupole moment: 0.0 ± 0.0 barn
```

Or the first metastable state of Neptunium-236:
```julia
julia> isotopes[:Np236m1]
Neptunium ²³⁶⁻¹Np, Z=93:
               atomic number: 93
                 mass number: 236
              isomeric state: 1st metastable state
           natural abundance: 0.0
                        mass: 236.046568 ± 5.4e-5 u
                        spin: 1//1
                      parity: -1
              is radioactive: true
                   half-life: 810000.0 ± 1400.0 s
```
