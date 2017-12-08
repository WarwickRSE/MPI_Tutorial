mpi_file_write_ordered.f90
------------------------
The calls to MPI_File_open and MPI_File_write are missing parts
put them in place

mpi_file_write_shared.f90
-----------------------
This code is complete and working. Try adding loops to write many times
to both this and mpi_file_write_ordered.c. See if you can determine any
speed difference caused by the ordering
