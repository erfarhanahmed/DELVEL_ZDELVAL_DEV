*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZITEM_CLASS21...................................*
DATA:  BEGIN OF STATUS_ZITEM_CLASS21                 .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZITEM_CLASS21                 .
CONTROLS: TCTRL_ZITEM_CLASS21
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZITEM_CLASS21                 .
TABLES: ZITEM_CLASS21                  .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
