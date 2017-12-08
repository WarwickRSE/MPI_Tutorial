#include <stdio.h>
#include <mpi.h>

#define TAG 100

int main(int argc, char ** argv)
{

  int rank, nproc, src, dest;
  MPI_Aint size_of_window, offset;
  MPI_Win window;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  offset = 0;
  size_of_window = sizeof(int);

  //Create the window. This is a piece of memory that's available for remote
  //access. In this case, a single 4 byte integer
  MPI_Win_create(&dest, size_of_window, sizeof(int), MPI_INFO_NULL,
      MPI_COMM_WORLD, &window);

  //Use collective synchronization model. After this command any processor
  //can use MPI_Put or MPI_Get on any other processor
  MPI_Win_fence(0,window);

  //Put the result into the first (zeroth) slot
  offset = 0;

  //Accumulate ranks and zero destination
  src = rank;
  dest = 0;

  MPI_Accumulate(&src, , , , , , ,
      , );

  //Call Win_fence again to end the access and exposure epochs
  MPI_Win_fence(0, window);

  if (rank == 0) printf("Accumulated value is %3d\n", dest);


  MPI_Finalize();

}
