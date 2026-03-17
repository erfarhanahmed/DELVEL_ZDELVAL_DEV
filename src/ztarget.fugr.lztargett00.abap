*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZTARGET.........................................*
DATA:  BEGIN OF STATUS_ZTARGET                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTARGET                       .
CONTROLS: TCTRL_ZTARGET
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZTARGET                       .
TABLES: ZTARGET                        .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
