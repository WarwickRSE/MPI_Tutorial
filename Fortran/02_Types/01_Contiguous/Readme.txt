simple.f90
--------
Example code using normal sends and receives

type.f90
------
The calls to MPI_Type_contiguous and MPI_Sendrecv are all missing parts of
their signatures. Fill them in so that you get the same answer as simple.c
