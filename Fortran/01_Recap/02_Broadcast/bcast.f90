PROGRAM reduce

  USE mpi
  IMPLICIT NONE

  INTEGER, PARAMETER :: tag = 100

  INTEGER :: rank, recv
  INTEGER :: nproc, ierr

  CALL MPI_Init(ierr)

  CALL MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

  IF (rank == 0) THEN
    WRITE(*,'(A)', ADVANCE='NO') 'Please enter an integer number :'
    READ(*,'(2I20)') recv
  END IF

  CALL MPI_Bcast(recv, , , , , )
  PRINT *, 'On rank ', rank, ' MPI_Bcast gives value of ', recv

  CALL MPI_Finalize(ierr)

END PROGRAM reduce
