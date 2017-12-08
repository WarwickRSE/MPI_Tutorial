PROGRAM wave

  USE mpi
  IMPLICIT NONE

  INTEGER :: rank, recv_rank, nproc
  INTEGER :: group, comm_group
  INTEGER :: ierr, window, intsize, icycle
  INTEGER(KIND=MPI_ADDRESS_KIND) :: size_of_window, offset
  INTEGER, DIMENSION(:), ALLOCATABLE :: ranks

  CALL MPI_Init(ierr)

  CALL MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

  !In C would just use sizeof()
  !In Fortran2008, could use C_SIZEOF
  !NOTE! This routine returns the size of AN ELEMENT
  !Not the size of an array if you give it an array
  CALL MPI_Sizeof(recv_rank, intsize, ierr)
  !Just using a single int here
  size_of_window = intsize

  !Create a group corresponding to all processors. Groups are just abstract
  !collections of processors and don't mean as much as communicators
  CALL MPI_Comm_group(MPI_COMM_WORLD, comm_group, ierr)

  !Create the window. This is a piece of memory that's available for remote
  !access. In this case, a single 4 byte integer
  CALL MPI_Win_create(recv_rank, size_of_window, intsize, MPI_INFO_NULL, &
      MPI_COMM_WORLD, window, ierr)

  IF (rank == 0) THEN
    !You have to pass MPI_Win_start a group of processors that it can access
    !Use MPI_Group_incl to create a group of all processors other than 0
    !If you include ranks here that will not also call MPI_Win_post then
    !You will get a lock in MPI_Put
    ALLOCATE(ranks(nproc-1))
    !TODO Loop to populate list of processors for group should go here
    CALL MPI_Group_incl(comm_group, nproc-1, ranks, group, ierr)
    DEALLOCATE(ranks)

    !On processor zero, have to use MPI_Win_start to start the "access epoch"
    !This allows rank 0 to MPI_Get and MPI_Put into windows on other processor
    !It does not allow other processors to access the window on rank 0
    CALL MPI_Win_start(group, 0, window, ierr)
  ELSE
    !You have to pass MPI_Win_post a group of processors that can write to it
    !Use MPI_Group_incl to create a group consisting only of processor 0
    !You MUST NOT include processors here that will not be writing or
    !MPI_Win_wait will lock
    ALLOCATE(ranks(1))
    ranks = 0
    CALL MPI_Group_incl(comm_group, 1, ranks, group, ierr)
    DEALLOCATE(ranks)

    !On all other ranks, use MPI_Win_post to start the "exposure epoch"
    !This makes their data available to ranks within the group, but they
    !cannot call MPI_Get or MPI_Put themselves
    CALL MPI_Win_post(group, 0, window, ierr)
  END IF

  !Put the result into the first (zeroth) slot
  offset = 0
  !Actual call to put the data in the remote processor
  IF (rank == 0) THEN
    DO icycle = 1, nproc - 1
      CALL MPI_Put(icycle, , , , , , , &
          , )
    END DO
  END IF

  IF (rank == 0) THEN
    !On processor zero, exit the "access epoch"
    CALL MPI_Win_complete(window, ierr)
  ELSE
    !On all of the other processors, wait for sending to complete and then
    !exit the "exposure epoch"
    CALL MPI_Win_wait(window, ierr)
  END IF

  PRINT *,"Rank ", rank, " got message from rank 0 of ", recv_rank

  CALL MPI_Finalize(ierr)

END PROGRAM wave
