"""
Isotope Composite Type
"""
struct Isotope
	name::String
	symbol::Symbol
    isot_symbol::String
	atomic_number::Int
	mass_number::Int
	abundance::Float64
    mass::typeof((1.0±1.0)u)
	spin::Rational{Int}
    parity::Int
	is_radioactive::Bool
    half_life::Union{Missing, typeof((1.0±1.0)s)}
    gfactor::Union{Missing, typeof(1.0±1.0)}
    quadrupole_moment::Union{Missing,typeof((1.0±1.0)b)}
end

Isotope(; name=missing,
          symbol=missing,
          isot_symbol=missing,
          atomic_number=missing,
          mass_number=missing,
          abundance=0.0,
          mass=missing,
          spin=missing,
          parity=missing,
          is_radioactive=missing,
          half_life=missing,
          gfactor=missing,
          quadrupole_moment=missing
       ) = 
Isotope(name, symbol, isot_symbol, atomic_number, mass_number, abundance, mass, spin, parity, is_radioactive, half_life, gfactor, quadrupole_moment)

function print_parity(io::IO, parity; pad=28)
    if !ismissing(parity)
        println(io, lpad("parity", pad), ": ", parity)
    end
end
function printpresent_Δ(io::IO, name, val, suffix="";pad=28)
    if !ismissing(val)
        println(io, lpad(name, pad), ": ", ustrip(val), suffix)
    end
end

Base.repr(istp::Isotope) = print("isotopes(", istp.name, ", ", istp.mass_number, ")")
Base.show(io::IO, istp::Isotope) = print(io, istp.isot_symbol)

function Base.show(io::IO, ::MIME"text/plain", istp::Isotope)
	println(io, istp.name, ' ', istp.isot_symbol, ", Z=", istp.atomic_number,':')
	printpresent(io, "atomic number", istp.atomic_number; pad=28)
	printpresent(io, "mass number", istp.mass_number; pad=28)
	printpresent(io, "natural abundance", istp.abundance; pad=28)
	printpresent_Δ(io, "mass", istp.mass, " u"; pad=28)
	printpresent(io, "spin", istp.spin; pad=28)
	print_parity(io, istp.parity; pad=28)
	printpresent(io, "is radioactive", istp.is_radioactive; pad=28)
    printpresent_Δ(io, "half-life", istp.half_life, " s"; pad=28)
	printpresent_Δ(io, "g-factor", istp.gfactor; pad=28)
	printpresent_Δ(io, "electric quadrupole moment", istp.quadrupole_moment, " barn"; pad=28)
end

"""
Isotopes composite type
"""
struct Isotopes
	data::Vector{Isotope}
	bynumber::Dict{NTuple{2,Int}, Isotope}
	byname::Dict{String, Isotope}
	bysymbol::Dict{Symbol, Isotope}
	byelement::Dict{Symbol, Vector{Isotope}}
	function Isotopes(data::Vector{Isotope})
		sort!(data, by = istp->(istp.atomic_number,istp.mass_number))
		bynumber = Dict{NTuple{2,Int},Isotope}((istp.atomic_number,istp.mass_number)=>istp for istp in data)
        byname = Dict{String,Isotope}(string(lowercase(istp.name),istp.mass_number)=>istp for istp in data)
		bysymbol = Dict{Symbol,Isotope}(Symbol(istp.symbol,istp.mass_number)=>istp for istp in data)
		byelement = Dict{Symbol,Vector{Isotope}}()
		for istp in data
			s = istp.symbol
			if haskey(byelement, s)
				push!(byelement[s], istp)
			else
				byelement[s] = [istp,]
			end
		end
		new(data, bynumber, byname, bysymbol, byelement)
	end
end

# Indexing stuff

Base.getindex(i::Isotopes, atomic_number::Int, mass_number::Int)= i.bynumber[(atomic_number, mass_number)]

Base.getindex(i::Isotopes, full_name::AbstractString) = i.byname[full_name |> lowercase]
Base.getindex(i::Isotopes, name::AbstractString, mass_number::Int) = i.byname[string(name|>lowercase, mass_number)]

Base.getindex(i::Isotopes, full_symbol::Symbol) = i.bysymbol[full_symbol]
Base.getindex(i::Isotopes, symbol::Symbol, mass_number::Int) = i.bysymbol[Symbol(symbol, mass_number)]

Base.getindex(i::Isotopes, el::Element, mass_number::Int) = isotopes[Symbol(el.symbol), mass_number]
Base.getindex(i::Isotopes, el::Element) = i.byelement[Symbol(el.symbol)]
Base.getindex(e::PeriodicTable.Elements, istp::Isotope) = elements[Symbol(istp.symbol)]

Base.haskey(i::Isotopes, atomic_numer::Int, mass_number::Int) = haskey(i.bynumber, (atomic_number, mass_number))
Base.haskey(i::Isotopes, full_name::AbstractString) = haskey(i.byname, full_name|>lowercase)
Base.haskey(i::Isotopes, name::AbstractString, mass_number::Int) = haskey(i.byname, string(name|>lowercase, mass_number))
Base.haskey(i::Isotopes, full_symbol::Symbol) = haskey(i.bysymbol, full_symbol)
Base.haskey(i::Isotopes, symbol::Symbol, mass_number::Int) = haskey(i.bysymbol, Symbol(symbol, mass_number))

# Function analogues of indexing

@inline (i::Isotopes)(atomic_number::Int, mass_number::Int) = i[atomic_number, mass_number]

@inline (i::Isotopes)(full_name::AbstractString) = i[full_name]

@inline (i::Isotopes)(name::AbstractString, mass_number::Int) = i[name,mass_number]

@inline (i::Isotopes)(full_symbol::Symbol) = i[full_symbol]

@inline (i::Isotopes)(symbol::Symbol, mass_number::Int) = i[symbol,mass_number]

@inline (i::Isotopes)(el::Element) = i[el]
@inline (i::Isotopes)(el::Element, mass_number::Int) = i[el, mass_number]
@inline (e::PeriodicTable.Elements)(istp::Isotope) = e[istp]

# Comparison stuff

get_numtuple(istp::Isotope) = (istp.atomic_number, istp.mass_number)

Base.isequal(istp1::Isotope, istp2::Isotope) = get_numtuple(istp1)==get_numtuple(istp2)
Base.isless(istp1::Isotope, istp2::Isotope) = isless(get_numtuple(istp1), get_numtuple(istp2))
