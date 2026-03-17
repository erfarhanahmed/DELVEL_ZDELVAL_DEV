*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZEINV_LINK_FI...................................*
DATA:  BEGIN OF STATUS_ZEINV_LINK_FI                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZEINV_LINK_FI                 .
CONTROLS: TCTRL_ZEINV_LINK_FI
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZEINV_LINK_FI                 .
TABLES: ZEINV_LINK_FI                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
