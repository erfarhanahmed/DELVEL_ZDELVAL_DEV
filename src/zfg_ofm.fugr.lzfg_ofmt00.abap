*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZOFM_BOOKING....................................*
DATA:  BEGIN OF STATUS_ZOFM_BOOKING                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOFM_BOOKING                  .
CONTROLS: TCTRL_ZOFM_BOOKING
            TYPE TABLEVIEW USING SCREEN '0001'.
*...processing: ZOFM_REV........................................*
DATA:  BEGIN OF STATUS_ZOFM_REV                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZOFM_REV                      .
CONTROLS: TCTRL_ZOFM_REV
            TYPE TABLEVIEW USING SCREEN '0002'.
*.........table declarations:.................................*
TABLES: *ZOFM_BOOKING                  .
TABLES: *ZOFM_REV                      .
TABLES: ZOFM_BOOKING                   .
TABLES: ZOFM_REV                       .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
