*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSAORDERCHK.....................................*
DATA:  BEGIN OF STATUS_ZSAORDERCHK                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSAORDERCHK                   .
CONTROLS: TCTRL_ZSAORDERCHK
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSAORDERCHK                   .
TABLES: ZSAORDERCHK                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
