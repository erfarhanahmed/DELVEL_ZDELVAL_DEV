*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCONF_MAIL......................................*
DATA:  BEGIN OF STATUS_ZCONF_MAIL                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCONF_MAIL                    .
CONTROLS: TCTRL_ZCONF_MAIL
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZCONF_MAIL                    .
TABLES: ZCONF_MAIL                     .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
