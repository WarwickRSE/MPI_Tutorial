wave.f90
------
All of the syntax for MPI_Ssend and MPI_Recv in this example are missing.
Put them in place

red_black.f90
------------
This only exists in the answers. Adapt it from wave.c. Remember that the idea
is to split the processors into adjacent red/black colours so that red 
(even rank numbered, say) processors send first while black receive. Then vice-versa
The modulo division operator (a%b in C and MOD(a,b) in Fortran) will help

sendrecv.f90
----------
Again, the syntax for MPI_Sendrecv is missing. Put it in place
