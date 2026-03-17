*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOHPERC.........................................*
DATA:  BEGIN OF STATUS_ZOHPERC                       .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOHPERC                       .
CONTROLS: TCTRL_ZOHPERC
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZOHPERC                       .
TABLES: ZOHPERC                        .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
