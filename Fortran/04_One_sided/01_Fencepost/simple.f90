PROGRAM mpi_fence

  USE mpi
  IMPLICIT NONE

  INTEGER :: rank, recv_rank, nproc
  INTEGER :: left, right
  INTEGER :: ierr, window, intsize
  INTEGER(KIND=MPI_ADDRESS_KIND) :: size_of_window, offset

  CALL MPI_Init(ierr)

  CALL MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

  !Set up periodic domain
  left = rank - 1
  IF (left < 0) left = nproc - 1
  right = rank + 1
  IF (right > nproc - 1) right = 0

  !In C would just use sizeof()
  !In Fortran2008, could use C_SIZEOF
  !NOTE! This routine returns the size of AN ELEMENT
  !Not the size of an array if you give it an array
  CALL MPI_Sizeof(recv_rank, intsize, ierr)
  !Just using a single int here
  size_of_window = intsize

  !Create the window. This is a piece of memory that's available for remote
  !access. In this case, a single 4 byte integer
  CALL MPI_Win_create(recv_rank, size_of_window, intsize, MPI_INFO_NULL, &
      MPI_COMM_WORLD, window, ierr)

  !Use collective synchronization model. After this command any processor
  !can use MPI_Put or MPI_Get on any other processor
!  CALL MPI_Win_fence(0, window, ierr)

  !Put the result into the first (zeroth) slot
  offset = 0
  !Actual call to put the data in the remote processor
  CALL MPI_Put(rank, 1, MPI_INTEGER, right, offset, 1, MPI_INTEGER, &
      window, ierr)

  !Call Win_fence again to end the access and exposure epochs
!  CALL MPI_Win_fence(0, window, ierr)

  PRINT *,"Rank ", rank, " got message from rank ", left, " of ", recv_rank

  CALL MPI_Finalize(ierr)

END PROGRAM mpi_fence
