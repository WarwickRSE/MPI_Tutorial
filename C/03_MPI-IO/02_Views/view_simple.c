#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char ** argv)
{

  int rank, recv_rank, nproc, index;
  MPI_File file_handle;
  MPI_Comm cart_comm;
  MPI_Datatype view_type;
  MPI_Offset disp=0;
  int sizes[2], subsizes[2]={1,1}, starts[2];
  int coords[2], periods[2] = {0,0};
  //NOTE! If you don't set this to zero then MPI_Dims_create will try to use
  // the numbers that you put here. If you don't specify then you can get
  // anything
  int nprocs_cart[2]={0,0};
  char outstr;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  MPI_Dims_create(nproc, 2, nprocs_cart);
  MPI_Cart_create(MPI_COMM_WORLD, 2, nprocs_cart, periods, 1, &cart_comm);
  MPI_Comm_rank(cart_comm, &rank);
  MPI_Cart_coords(cart_comm, rank, 2, coords);

  if(rank ==0) {
    printf("Processors subdivided as %2d %2d\n", nprocs_cart[0], 
        nprocs_cart[1]);
  }

  MPI_Barrier(cart_comm);

  //Delete the existing file
  MPI_File_delete("out.txt", MPI_INFO_NULL);

  //Open the file for writing
  MPI_File_open(MPI_COMM_WORLD, "out.txt",
      MPI_MODE_WRONLY + MPI_MODE_CREATE, MPI_INFO_NULL, &file_handle);

  //Create the string. Character based on rank and a newline.
  outstr = 'A' + rank;

  for(index = 0; index < 2; ++index){
    //You have one character per processor in each direction
    sizes[index] = nprocs_cart[index];
    starts[index] = coords[index];
  }

  //Using MPI_ORDER_FORTRAN in C so that you get the same answer as the
  //Fortran code, can freely change to MPI_ORDER_C
  MPI_Type_create_subarray(2, sizes, subsizes, starts, MPI_ORDER_FORTRAN,
      MPI_CHARACTER, &view_type);
  MPI_Type_commit(&view_type);

  MPI_File_set_view(file_handle, disp, MPI_BYTE, view_type, "native",
      MPI_INFO_NULL);

  //Write using the individual file pointer
  MPI_File_write(file_handle, &outstr, 1,
      MPI_CHARACTER, MPI_STATUS_IGNORE);

  MPI_File_close(&file_handle);

  MPI_Finalize();
}
