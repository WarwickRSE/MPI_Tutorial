#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define TAG 100

int main(int argc, char ** argv)
{

  int rank, recv_rank, nproc, icycle;
  MPI_Aint size_of_window, offset;
  MPI_Win window;
  MPI_Group comm_group, group;
  int *ranks;

  MPI_Init(&argc, &argv);
  MPI_Comm_size(MPI_COMM_WORLD, &nproc);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);

  offset = 0;
  size_of_window = sizeof(int);

  //Create a group corresponding to all processors. Groups are just abstract
  //collections of processors and don't mean as much as communicators
  MPI_Comm_group(MPI_COMM_WORLD, &comm_group);

  //Create the window. This is a piece of memory that's available for remote
  //access. In this case, a single 4 byte integer
  MPI_Win_create(&recv_rank, size_of_window, sizeof(int), MPI_INFO_NULL,
      MPI_COMM_WORLD, &window);

  if (rank == 0) {
    //You have to pass MPI_Win_start a group of processors that it can access
    //Use MPI_Group_incl to create a group of all processors other than 0
    //If you include ranks here that will not also call MPI_Win_post then
    //You will get a lock in MPI_Put
    ranks = (int*) malloc(sizeof(int) * (nproc-1));

    //TODO : PUT IN LOOP TO SET UP GROUP
    MPI_Group_incl(comm_group, nproc-1, ranks, &group);
    free(ranks);

    //On processor zero, have to use MPI_Win_start to start the "access epoch"
    //This allows rank 0 to MPI_Get and MPI_Put into windows on other processor
    //It does not allow other processors to access the window on rank 0
    MPI_Win_start(group, 0, window);
  } else {
    //You have to pass MPI_Win_post a group of processors that can write to it
    //Use MPI_Group_incl to create a group consisting only of processor 0
    //You MUST NOT include processors here that will not be writing or
    //MPI_Win_wait will lock
    ranks = (int*) malloc(sizeof(int));
    ranks[0] = 0;
    MPI_Group_incl(comm_group, 1, ranks, &group);
    free(ranks);

    //On all other ranks, use MPI_Win_post to start the "exposure epoch"
    //This makes their data available to ranks within the group, but they
    //cannot call MPI_Get or MPI_Put themselves
    MPI_Win_post(group, 0, window);
  }


  offset = 0;
  //Actual call to put the data in the remote processor
  if (rank == 0) {
    for (icycle = 1; icycle<nproc; ++icycle){
      MPI_Put(&icycle, , ,  , , , ,);
    }
  }

  if (rank == 0) {
    //On processor zero, exit the "access epoch"
    MPI_Win_complete(window);
  } else {
    //On all of the other processors, wait for sending to complete and then
    //exit the "exposure epoch"
    MPI_Win_wait(window);
  }


  printf("Rank %3d got message from rank 0 of %3d\n", rank, recv_rank);

  MPI_Finalize();

}
