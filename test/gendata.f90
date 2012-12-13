program gendata
  integer*8 :: x(20)
  real*8 :: y(20)
  integer i

  do i=1,20
    x(i) = i
    y(i) = 1.0d0 / i
  end do

  open(unit=9, file="data.bin", form='unformatted')
  write(9) x
  write(9) y
  close(9)

  open(unit=9, file="data2.bin", form='unformatted')
  write(9) x,y
  close(9)
end program
