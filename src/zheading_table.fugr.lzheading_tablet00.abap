*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZHEADING_TABLE..................................*
DATA:  BEGIN OF STATUS_ZHEADING_TABLE                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZHEADING_TABLE                .
CONTROLS: TCTRL_ZHEADING_TABLE
            TYPE TABLEVIEW USING SCREEN '0001'.
*.........table declarations:.................................*
TABLES: *ZHEADING_TABLE                .
TABLES: ZHEADING_TABLE                 .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
