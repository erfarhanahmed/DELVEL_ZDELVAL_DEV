*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZPPCOMPLIANCE...................................*
DATA:  BEGIN OF STATUS_ZPPCOMPLIANCE                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPPCOMPLIANCE                 .
CONTROLS: TCTRL_ZPPCOMPLIANCE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZPPCOMPLIANCE                 .
TABLES: ZPPCOMPLIANCE                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
