*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSU_CHALLANNO...................................*
DATA:  BEGIN OF STATUS_ZSU_CHALLANNO                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSU_CHALLANNO                 .
CONTROLS: TCTRL_ZSU_CHALLANNO
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSU_CHALLANNO                 .
TABLES: ZSU_CHALLANNO                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
