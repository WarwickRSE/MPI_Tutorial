#include <stdio.h>
#include <mpi.h>

#define TAG 100

int main(int argc, char ** argv)
{

  int rank, recv_rank, nproc, left, right;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  //Set up periodic domain
  left = rank - 1;
  if (left < 0) left = nproc - 1;
  right = rank + 1;
  if (right > nproc - 1) right = 0;

  //Complete the calls to MPI_Ssend to send rank to the processor at rank
  // "right"
  if (rank == 0) {
    MPI_Ssend(&rank);
    MPI_Recv(&recv_rank);
  } else {
    MPI_Recv(&recv_rank);
    MPI_Ssend(&rank);
  }

  printf("Rank %3d got message from rank %3d of %3d\n", rank, left, recv_rank);

  MPI_Finalize();

}
