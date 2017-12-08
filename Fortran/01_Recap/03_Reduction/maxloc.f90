PROGRAM reduce

  USE mpi
  IMPLICIT NONE

  INTEGER, PARAMETER :: tag = 100

  INTEGER :: rank, recv
  INTEGER :: nproc, ierr
  INTEGER, DIMENSION(:), ALLOCATABLE :: seed
  INTEGER :: rand_size, time, rank_recv
  REAL :: randval
   :: maxloc_data_out, maxloc_data_in

  CALL MPI_Init(ierr)

  CALL MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

  CALL RANDOM_SEED(size=rand_size)
  ALLOCATE(seed(1:rand_size))
  CALL SYSTEM_CLOCK(time)
  seed = time + rank
  CALL RANDOM_SEED(put=seed)
  DEALLOCATE(seed)
  CALL RANDOM_NUMBER(randval)
  randval = randval * 100

  !Note that unlike in C, we're using an array of reals. The second one contains
  !an integer. This is necessary for compatability with F77 which has no structs
  maxloc_data_out(1) = randval
  maxloc_data_out(2) = rank

  !Note that type is MPI_2REAL. That's two reals packed together
  !Also
  !MPI_2DOUBLE_PRECISION - Two double precisions packed together
  !MPI_2INTEGER - Two integers packed together
  CALL MPI_Reduce(maxloc_data_out, maxloc_data_in, 1, MPI_2REAL, MPI_MAXLOC, &
      0, MPI_COMM_WORLD, ierr)
  rank_recv = maxloc_data_in(2)

  PRINT *, "On rank ", rank, " random number was ", randval

  IF (rank == 0) THEN
  PRINT *, "MPI_Reduce with MPI_MAXLOC gives maximum random value as ", &
      maxloc_data_in(1), " on rank ", rank_recv
  END IF

  CALL MPI_Finalize(ierr)

END PROGRAM reduce
