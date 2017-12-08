#include <stdio.h>
#include <mpi.h>

#define TAG 100

int main(int argc, char ** argv)
{

  int rank, recv_rank, nproc, left, right;
  MPI_Aint size_of_window, offset;
  MPI_Win window;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  offset = 0;
  size_of_window = sizeof(int);

  //Set up periodic domain
  left = rank - 1;
  if (left < 0) left = nproc - 1;
  right = rank + 1;
  if (right > nproc - 1) right = 0;

  //Create the window. This is a piece of memory that's available for remote
  //access. In this case, a single 4 byte integer
  MPI_Win_create(&recv_rank, size_of_window, sizeof(int), MPI_INFO_NULL,
      MPI_COMM_WORLD, &window);

  //Use collective synchronization model. After this command any processor
  //can use MPI_Put or MPI_Get on any other processor
//  MPI_Win_fence(0,window);

  //Put the result into the first (zeroth) slot
  offset = 0;
  //Actual call to put the data in the remote processor
  MPI_Put(&rank, 1, MPI_INT, right, offset, 1, MPI_INT,
      window);

  //Call Win_fence again to end the access and exposure epochs
//  MPI_Win_fence(0, window);

  printf("Rank %3d got message from rank %3d of %3d\n", rank, left, recv_rank);

  MPI_Finalize();

}
