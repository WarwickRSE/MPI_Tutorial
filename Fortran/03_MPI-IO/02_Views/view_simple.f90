PROGRAM simple_write

  USE mpi
  IMPLICIT NONE

  INTEGER :: rank, nproc, ierr, cart_comm
  INTEGER :: file_handle, view_type
  CHARACTER(len=1) :: outstr
  INTEGER, DIMENSION(2) :: sizes, subsizes, starts, nprocs_cart, coords
  LOGICAL, DIMENSION(2) :: periods = .FALSE.
  INTEGER(KIND=MPI_OFFSET_KIND) :: offset = 0

  nprocs_cart = 0
  CALL MPI_Init(ierr)

  CALL MPI_Comm_size(MPI_COMM_WORLD, nproc, ierr)
  CALL MPI_Comm_rank(MPI_COMM_WORLD, rank, ierr)
  !Use MPI commands to split processors up into 2D array
  CALL MPI_Dims_create(nproc, 2, nprocs_cart, ierr)
  CALL MPI_Cart_create(MPI_COMM_WORLD, 2, nprocs_cart, periods, .TRUE., &
      cart_comm, ierr)
  CALL MPI_Comm_rank(cart_comm, rank, ierr)
  CALL MPI_Cart_coords(cart_comm, rank, 2, coords, ierr)

  IF (rank == 0) THEN
    PRINT *,'Processors subdivided as ', nprocs_cart
  END IF

  CALL MPI_Barrier(MPI_COMM_WORLD, ierr)

  !Delete the existing file
  CALL MPI_File_delete('out.txt', MPI_INFO_NULL, ierr)

  !Open the file for writing
  CALL MPI_File_open(cart_comm, 'out.txt', &
      MPI_MODE_WRONLY + MPI_MODE_CREATE, MPI_INFO_NULL, file_handle, ierr)

  outstr = ACHAR(rank + ICHAR('A'))

  !You have one character per processor in this direction
  !Plus one in X for newline character
  sizes = nprocs_cart
  !Each processor except the one at the end of the line only
  !outputs a single character
  subsizes = (/1, 1/)
  !The start of the view is just the coordinate of the current processor since
  !each procssor is only writing one character (apart from the last processor
  !in each line)
  starts = coords
  CALL MPI_Type_create_subarray(2, sizes, subsizes, starts, MPI_ORDER_FORTRAN, &
      MPI_CHARACTER, view_type, ierr)
  CALL MPI_Type_commit(view_type, ierr)

  CALL MPI_File_set_view(file_handle, offset, MPI_BYTE, view_type, 'native', &
      MPI_INFO_NULL, ierr)

  CALL MPI_File_write_all(file_handle, outstr, 1, MPI_CHARACTER, &
      MPI_STATUS_IGNORE, ierr)

  !Close the file
  CALL MPI_File_close(file_handle, ierr)

  CALL MPI_Finalize(ierr)

END PROGRAM simple_write
