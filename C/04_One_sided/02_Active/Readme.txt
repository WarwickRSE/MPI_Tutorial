general.c
---------
The loop defining the processor group on processor 0 isn't there. Put it in
Remember that every processor that processor 0 calls MPI_Put on has to be in the
group

The signature for MPI_Put is missing. Fill it in

general_get.c
-------------
The signature for MPI_Win_create is missing Fill it in
