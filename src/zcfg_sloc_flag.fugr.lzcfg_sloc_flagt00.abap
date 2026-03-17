*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCFG_SLOC_FLAG..................................*
DATA:  BEGIN OF STATUS_ZCFG_SLOC_FLAG                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCFG_SLOC_FLAG                .
CONTROLS: TCTRL_ZCFG_SLOC_FLAG
            TYPE TABLEVIEW USING SCREEN '0100'.
*.........table declarations:.................................*
TABLES: *ZCFG_SLOC_FLAG                .
TABLES: ZCFG_SLOC_FLAG                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
