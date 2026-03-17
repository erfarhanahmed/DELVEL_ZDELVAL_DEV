*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZASSET_TABLE....................................*
DATA:  BEGIN OF STATUS_ZASSET_TABLE                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZASSET_TABLE                  .
CONTROLS: TCTRL_ZASSET_TABLE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZASSET_TABLE                  .
TABLES: ZASSET_TABLE                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
