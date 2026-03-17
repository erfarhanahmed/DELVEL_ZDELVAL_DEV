*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSU_HEADING.....................................*
DATA:  BEGIN OF STATUS_ZSU_HEADING                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSU_HEADING                   .
CONTROLS: TCTRL_ZSU_HEADING
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZSU_HEADING                   .
TABLES: ZSU_HEADING                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
