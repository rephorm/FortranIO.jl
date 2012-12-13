module FortranIO
    export read_record

import Base.read

function read_record_array{T}(io::IO, ::Type{T})
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

function read_record(io::IO, types...)
    nb = read(io, Int32)

    ret = Any[]
    # read in arrays
    for T in types
        v = read(io, T)
        push(ret, v)
    end

    nb_check = read(io, Int32)
    (nb == nb_check) || error("Invalid data $nb != $nb_check.")

    ret
end

function write_record(io::IO, values...)
    # TODO: support Strings

    # determine record size
    nb = 0 
    for v in values 
        if (isa(v, AbstractArray))
            nb += numel(v) * sizeof(eltype(v))
        elseif (isa(typeof(v), BitsKind))
            nb += sizeof(v)
        else
            error("Unsupported value type: $(typeof(v))")
        end
    end
    nb = int32(nb)
 
    # write record
    write(io, nb)
    for v in values 
        write(io, v)
    end
    write(io, nb)
end

end # module FortranIO
