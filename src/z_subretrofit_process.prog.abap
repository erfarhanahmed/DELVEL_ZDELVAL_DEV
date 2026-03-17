*&---------------------------------------------------------------------*
*&  Include           Z_SUBRETROFIT_PROCESS
*&---------------------------------------------------------------------*

**Get all challans
PERFORM GET_CHALLANS.

**Process Challans
PERFORM PROCESS_CHLNS.

**Update table
PERFORM UPDATE_CHLNS.
