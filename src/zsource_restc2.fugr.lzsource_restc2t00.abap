*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZSOURCE_RESTC2..................................*
DATA:  BEGIN OF STATUS_ZSOURCE_RESTC2                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSOURCE_RESTC2                .
CONTROLS: TCTRL_ZSOURCE_RESTC2
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZSOURCE_RESTC2                .
TABLES: ZSOURCE_RESTC2                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
