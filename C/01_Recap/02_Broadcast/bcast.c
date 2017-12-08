#include <stdio.h>
#include <mpi.h>

#define TAG 100

int main(int argc, char ** argv)
{

  int rank, nproc, recv;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  if (rank == 0) {
    printf("Please enter an integer number:");
    fflush(stdout);
    scanf("%d", &recv);
  }

  MPI_Bcast(&recv);

  printf("On rank %3d MPI_Bcast gives value of %3d\n", rank, recv);

  MPI_Finalize();

}
