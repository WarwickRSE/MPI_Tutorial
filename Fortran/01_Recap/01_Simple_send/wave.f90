PROGRAM wave

  USE mpi
  IMPLICIT NONE

  INTEGER, PARAMETER :: tag = 100

  INTEGER :: rank, recv_rank
  INTEGER :: nproc
  INTEGER :: left, right
  INTEGER :: ierr

  CALL MPI_Init(ierr)

  CALL MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

  !Set up periodic domain
  left = rank - 1
  IF (left < 0) left = nproc - 1
  right = rank + 1
  IF (right > nproc - 1) right = 0

  IF (rank == 0) THEN
    CALL MPI_Ssend(rank)
    CALL MPI_Recv(recv_rank)
  ELSE
    CALL MPI_Recv(recv_rank)
    CALL MPI_Ssend(rank)
  END IF

  PRINT *,"Rank ", rank, " got message from rank ", left, " of ", recv_rank

  CALL MPI_Finalize(ierr)

END PROGRAM wave
