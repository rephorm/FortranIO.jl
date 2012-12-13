module FortranIO
    export read_record

import Base.read

function read_record{T}(io::IO, ::Type{T})
    # read number of bytes in record
    nb = read(io, Int32)
    mod(nb, sizeof(T)) == 0 || error("Record size is not a multiple of type size")

    # read in array
    arr = Array(T, div(nb,sizeof(T)))
    arr = read(io, arr) # XXX IOString doesn't fill the array in place!

    nb_check = read(io, Int32)
    (nb == nb_check) || error("Invalid data $nb != $nb_check.")

    arr
end

function read_record(io::IO, arrays::Array...)
    nb = read(io, Int32)
    println("Read size: $nb")

    ret = Array[]
    # read in arrays
    for arr in arrays
        arr = read(io, arr) # this is needed until IOString is fixed
        push(ret, arr)
    end

    nb_check = read(io, Int32)
    (nb == nb_check) || error("Invalid data $nb != $nb_check.")

    ret
end

function write_record(io::IO, arrays::Array...)
    # determine record size
    nb = 0 
    for arr in arrays
        nb += numel(arr) * sizeof(eltype(arr))
    end
    nb = int32(nb)
 
    # write record
    write(io, nb)
    for arr in arrays
        println("Write $(arr)")
        write(io, arr)
    end
    write(io, nb)
end

function write_record(io::IO, items...)
    # first convert any non-array items to arrays
    items = map(x -> isa(x,AbstractArray) ? x : [x], items)
    println("Items: $(items)")
    write_record(io, items...)
end

function write_record{T}(io::IO, v::T)
    n = int32(sizeof(T))
    write(io, n)
    write(io, v)
    write(io, n)
end

end # module FortranIO
