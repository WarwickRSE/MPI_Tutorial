#include <stdio.h>
#include <mpi.h>

int main(int argc, char ** argv)
{

  int rank, recv_rank, nproc, charlength;
  MPI_File file_handle;
  char outstr[50];

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  //Delete the existing file
  MPI_File_delete("out.txt", MPI_INFO_NULL);

  //Open the file for writing
  MPI_File_open(MPI_COMM_WORLD, "out.txt",
      MPI_MODE_WRONLY + MPI_MODE_CREATE, MPI_INFO_NULL, &file_handle);

  //MPI_IO is a binary output format. Have to manually add new line characters
  //Not unusual in C, but needs noting in Fortran
  charlength = sprintf(outstr, "Hello from processor %3d\n", rank);

  //Write using the shared pointer. Ordered guarantees that data is written
  //in rank order
  MPI_File_write_shared(file_handle, outstr, charlength,
      MPI_CHARACTER, MPI_STATUS_IGNORE);

  MPI_File_close(&file_handle);

  MPI_Finalize();
}
