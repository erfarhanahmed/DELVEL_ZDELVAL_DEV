*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSU_PRCERT_TABLE................................*
DATA:  BEGIN OF STATUS_ZSU_PRCERT_TABLE              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSU_PRCERT_TABLE              .
CONTROLS: TCTRL_ZSU_PRCERT_TABLE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSU_PRCERT_TABLE              .
TABLES: ZSU_PRCERT_TABLE               .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
