#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <mpi.h>

#define TAG 100

int main(int argc, char ** argv)
{

  int rank, nproc, recv, randval;
  time_t t;

  struct {
  } maxloc_data_out, maxloc_data_in;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  //Get random number between 0 and 99. + rank so different number on each
  srand((unsigned) time(&t)+ rank);
  randval = rand() % 100;

  maxloc_data_out.value = randval;
  maxloc_data_out.rank = rank; //Have to put rank in here manually

  //Note that type is MPI_2INT. That's two integers packed together
  //Also
  /*MPI_FLOAT_INT - Float and Int
    MPI_DOUBLE_INT - Double and Int
    MPI_LONG_INT - Long and Int
    MPI_SHORT_INT - Short and Int
    MPI_LONG_DOUBLE_INT - Long Double and Int
  */
  MPI_Reduce(&maxloc_data_out, &maxloc_data_in, 1, MPI_2INT, MPI_MAXLOC, 0,
      MPI_COMM_WORLD);

  printf("On rank %3d, random number was %3d\n", rank, randval);

  if (rank == 0) {
  printf("MPI_Reduce with MPI_MAXLOC gives maximum random value as %3d on rank %3d\n"
      , maxloc_data_in.value, maxloc_data_in.rank);
  }

  MPI_Finalize();

}
