load("FortranIO")

f = open("data.bin")
x = FortranIO.read_record(f, Int64)
y = FortranIO.read_record(f, Float64)

expected_x = linspace(1,20,20)
expected_y = 1.0/expected_x

assert(all(x .== expected_x))
assert(all(y .== expected_y))


