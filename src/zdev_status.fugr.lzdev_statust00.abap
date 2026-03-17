*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZDEV_STATUS.....................................*
DATA:  BEGIN OF STATUS_ZDEV_STATUS                   .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZDEV_STATUS                   .
CONTROLS: TCTRL_ZDEV_STATUS
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZDEV_STATUS                   .
TABLES: ZDEV_STATUS                    .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
