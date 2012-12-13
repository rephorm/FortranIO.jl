load("FortranIO")

function test_single_entry_per_record()
    f = open("data.bin")
    x = FortranIO.read_record_array(f, Int64)
    y = FortranIO.read_record_array(f, Float64)

    expected_x = linspace(1,20,20)
    expected_y = 1.0/expected_x

    assert(all(x .== expected_x))
    assert(all(y .== expected_y))

    close(f)
end

function test_multiple_entries_per_record()
    f = open("data2.bin")

    x,y = FortranIO.read_record(f, Array(Int64, 20), Array(Float64, 20))

    expected_x = linspace(1,20,20)
    expected_y = 1.0/expected_x

    assert(all(x .== expected_x))
    assert(all(y .== expected_y))

    close(f)
end

test_single_entry_per_record()
test_multiple_entries_per_record()
