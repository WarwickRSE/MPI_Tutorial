PROGRAM simple_write

  USE mpi
  IMPLICIT NONE

  INTEGER :: rank, nproc, ierr
  INTEGER :: file_handle
  CHARACTER(len=50) :: outstr

  CALL MPI_Init(ierr)

  CALL MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)

  !Delete the existing file
  CALL MPI_File_delete('out.txt', MPI_INFO_NULL, ierr)

  !Open the file for writing
  CALL MPI_File_open(MPI_COMM_WORLD,, &
      MPI_MODE_WRONLY + MPI_MODE_CREATE, MPI_INFO_NULL,, )

  !MPI_IO is a binary output format. Have to manually add new line characters
  WRITE(outstr,'(A,I3,A)') "Hello from processor ", rank, NEW_LINE(' ')

  !Write using the shared pointer. Ordered guarantees that data is written
  !in rank order
  CALL MPI_File_write_ordered(file_handle, , , &
      , ,)

  !Close the file
  CALL MPI_File_close(file_handle, ierr)


  CALL MPI_Finalize(ierr)

END PROGRAM simple_write
