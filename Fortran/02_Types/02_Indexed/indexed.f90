PROGRAM type

  USE mpi
  IMPLICIT NONE

  INTEGER, PARAMETER :: tag = 100
  INTEGER, PARAMETER :: nitems = 8

  INTEGER :: rank, recv_rank
  INTEGER :: nproc
  INTEGER :: left, right
  INTEGER :: ierr
  INTEGER :: index_type
  INTEGER, DIMENSION(nitems) :: values, values_recv
  INTEGER, DIMENSION(2) :: lengths, displacements

  CALL MPI_Init(ierr)

  CALL MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

  !Set up periodic domain
  left = rank - 1
  IF (left < 0) left = nproc - 1
  right = rank + 1
  IF (right > nproc - 1) right = 0

  values = rank
  values_recv = 0

  lengths = (/, /)
  displacements = (/, /)
  !Create the type
  CALL MPI_Type_indexed(2, lengths, displacements, MPI_INTEGER, index_type, &
      ierr)

  !Register the type
  CALL MPI_Type_commit(index_type, ierr)

  IF (rank == 0) THEN
    PRINT *,'MPI_Type_indexed used as send and recieve types'
  END IF
  !Sendrecv using the type. Note that sendcount and recvcount are now both 1
  CALL MPI_Sendrecv(values, 1, index_type, right, tag, values_recv, &
      1, index_type, left, tag, MPI_COMM_WORLD, MPI_STATUS_IGNORE, ierr)

  IF (rank == 0) THEN
    PRINT *, 'Detailed result on rank 0 is ', values_recv
  END IF

  CALL MPI_Finalize(ierr)

END PROGRAM type
