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
    x = FortranIO.read_record_array(f, Int64)
    y = FortranIO.read_record_array(f, Float64)
    close(f)
```

An array of the appropriate size is returned by `FortranIO.read_record_array`.

If, instead of two separate calls to `write` in the fortran code above, a single call had been used:

```fortran90
    write(9) x, y
```

Then, the values can be loaded in julia using

```julia
    FortranIO.read_record(f, Array(Int64,100), Array(Float64,100))
```

Values can also be written:

```julia
    f = open("file.bin", "w")
    # Write a record containing one Int64
    FortranIO.write_record(f, 10)
    # Write a second record containing several values of different types
    FortranIO.write_record(f, [1,2,3], int32(4), 5.0)
    close(f)
```
