__precompile__(true)

"""
The Isotopes module exports an `isotopes` variable that stores 
data (of type `Isotope` on all the isotopes I has gathered information about. In particular, it stores only the data about the ground states of the isotopes, and disregards their excited states.

The isotope data can be looked up using the combination of atomic number `n` and mass number `m` of the isotope via `isotopes[n, m]`. Alternatively, one can use instead of the atomic number the symbol or the name (case-insensitive) of the corresponding element, or the `Element` object from `PeriodicTable` itself.

One can also use a single symbol combined from the element symbol and mass number, like `isotopes[:H3]`. Similarly, one can use a single string composed from the element name and mass number, like `isotopes["hydrogen3"]`.

If one uses the `Element` object without the mass number, the list of the isotopes of the given element is returned. Try `isotopes[elements[:H]]`.
"""

module IsotopeTable

using Reexport, Unitful, Measurements
@reexport using PeriodicTable
import PeriodicTable: printpresent

export Element, elements, Isotope, isotopes, isotopes_df

import Unitful: u, g, cm, K, J, mol, Quantity, s, b, ustrip

include("isotopes.jl")
include("isotopes_data.jl")
const isotopes = Isotopes(_isotopes_data)

end 
