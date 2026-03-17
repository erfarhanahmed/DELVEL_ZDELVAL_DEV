*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEINV_LINK......................................*
DATA:  BEGIN OF STATUS_ZEINV_LINK                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEINV_LINK                    .
CONTROLS: TCTRL_ZEINV_LINK
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZEINV_LINK                    .
TABLES: ZEINV_LINK                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
