*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCT_ATINN_MAP...................................*
DATA:  BEGIN OF STATUS_ZCT_ATINN_MAP                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCT_ATINN_MAP                 .
CONTROLS: TCTRL_ZCT_ATINN_MAP
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZCT_ATINN_MAP                 .
TABLES: ZCT_ATINN_MAP                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
