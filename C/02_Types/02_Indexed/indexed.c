#include <stdio.h>
#include <mpi.h>

#define TAG 100
#define NITEMS 8

int main(int argc, char** argv)
{

  int rank, recv_rank, nproc, left, right, iitems, sum;
  int values[NITEMS], values_recv[NITEMS];
  int lengths[2], displacements[2];
  MPI_Datatype index_type;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  //Set up periodic domain
  left = rank - 1;
  if (left < 0) left = nproc - 1;
  right = rank + 1;
  if (right > nproc - 1) right = 0;

  for (iitems = 0; iitems < NITEMS; ++iitems){
    values[iitems] = rank;
    values_recv[iitems] = 0;
  }

  lengths[0] = ; lengths[1] = ;
  displacements[0] = ; displacements[1] = ;

  MPI_Type_indexed(2, lengths, displacements, MPI_INT, &index_type);

  MPI_Type_commit(&index_type);

  if (rank == 0) printf("MPI_Type_indexed used as send and recieve types\n");

  MPI_Sendrecv(values, 1, index_type, right, TAG, values_recv, 1,
      index_type, left, TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

  MPI_Type_free(&index_type);

  if (rank == 0) {
    printf("Detailed result on rank 0 is ");
    for (iitems = 0; iitems < NITEMS; ++iitems){
      printf("%3d ", values_recv[iitems]);
    }
    printf("\n");
  }

  MPI_Finalize();

}
