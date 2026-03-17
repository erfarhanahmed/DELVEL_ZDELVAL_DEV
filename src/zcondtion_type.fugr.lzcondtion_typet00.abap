*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCONDTION_TYPE..................................*
DATA:  BEGIN OF STATUS_ZCONDTION_TYPE                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCONDTION_TYPE                .
CONTROLS: TCTRL_ZCONDTION_TYPE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCONDTION_TYPE                .
TABLES: ZCONDTION_TYPE                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
