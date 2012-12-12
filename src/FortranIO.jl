module FortranIO
    export read_record

import Base.read

function read_record{T}(io::IO, ::Type{T})
    # read number of bytes in record
    nb = read(io, Int32)
    mod(nb, sizeof(T)) == 0 || error("Record size is not a multiple of type size")

    # read in array
    arr = Array(T, div(nb,sizeof(T)))
    arr = read(io, arr) # XXX StringIO doesn't fill the array in place!

    nb_check = read(io, Int32)
    (nb == nb_check) || error("Invalid data $nb != $nb_check.")

    arr
end

function write_record{T}(io::IO, a::Array{T})
    n = int32(numel(a) * sizeof(T))
    write(io, n)
    write(io, a)
    write(io, n)
end

function write_record{T}(io::IO, v::T)
    n = int32(sizeof(T))
    write(io, n)
    write(io, v)
    write(io, n)
end

end # module FortranIO
