PROGRAM type

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

  !Create the type
  CALL MPI_Type_contiguous(,,,)

  !Register the type
  CALL MPI_Type_commit(contig_type, ierr)

  IF (rank == 0) PRINT *,'MPI_Type_contiguous used as send and recieve types'
  !Sendrecv using the type. Note that sendcount and recvcount are now both 1
  CALL MPI_Sendrecv(values, , , right, tag, values_recv, &
      , , left, tag, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)
  PRINT *,"Rank ", rank, " got message from rank ", left, " with total of ", &
      SUM(values_recv)

  CALL MPI_Finalize(ierr)

END PROGRAM type
