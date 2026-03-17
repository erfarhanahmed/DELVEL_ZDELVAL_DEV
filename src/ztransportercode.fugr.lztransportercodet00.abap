*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTRANSPORTERCODE................................*
DATA:  BEGIN OF STATUS_ZTRANSPORTERCODE              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTRANSPORTERCODE              .
CONTROLS: TCTRL_ZTRANSPORTERCODE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTRANSPORTERCODE              .
TABLES: ZTRANSPORTERCODE               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
