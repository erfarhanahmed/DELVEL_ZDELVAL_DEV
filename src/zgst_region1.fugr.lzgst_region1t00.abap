*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZGST_REGION1....................................*
DATA:  BEGIN OF STATUS_ZGST_REGION1                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZGST_REGION1                  .
CONTROLS: TCTRL_ZGST_REGION1
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZGST_REGION1                  .
TABLES: ZGST_REGION1                   .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
