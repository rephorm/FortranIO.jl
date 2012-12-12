FortanIO.jl
===========

Fortran binary (unformatted) file input/output for Julia.

Example
-------

Assume we have some fortran code like the following that saves out data to `data.bin`.

```fortran90
    integer*8 :: x(100)
    real*8 :: y(100)
    
    ! ... code that calculates something in x and y ...

    open(unit=9, file="data.bin", form="unformatted")
    write(9) x
    write(9) y
    close(9)
```

This can be read into julia as follows:

```julia
    load("FortranIO")
    f = open("data.bin")
    x = FortranIO.read_record(f, Int64)
    y = FortranIO.read_record(f, Float64)
```

An array of the appropriate size is returned by `FortranIO.read_record`.

Limitations
-----------
Currently, there is no support for reading multiple types from a single record (e.g., if the fortran code above had used `write(9) x, y`, instead of two separate writes).
