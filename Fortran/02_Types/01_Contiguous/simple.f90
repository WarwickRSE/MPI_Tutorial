PROGRAM simple

  USE mpi
  IMPLICIT NONE

  INTEGER, PARAMETER :: tag = 100
  INTEGER, PARAMETER :: nitems = 100

  INTEGER :: rank, recv_rank
  INTEGER :: nproc
  INTEGER :: left, right
  INTEGER :: ierr
  INTEGER :: contig_type
  INTEGER, DIMENSION(nitems) :: values, values_recv

  CALL MPI_Init(ierr)

  CALL MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

  !Set up periodic domain
  left = rank - 1
  IF (left < 0) left = nproc - 1
  right = rank + 1
  IF (right > nproc - 1) right = 0

  values = rank

  IF (rank == 0) PRINT *,'Conventional sendrecv'
  CALL MPI_Sendrecv(values, nitems, MPI_INTEGER, right, tag, values_recv, &
      nitems, MPI_INTEGER, left, tag, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
  PRINT *,"Rank ", rank, " got message from rank ", left, " with total of ", &
      SUM(values_recv)

  CALL MPI_Finalize(ierr)

END PROGRAM simple
