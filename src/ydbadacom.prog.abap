*&---------------------------------------------------------------------*
*&  Include           YDBADACOM
*&---------------------------------------------------------------------*
***INCLUDE DBADACOM .
DATA: BEGIN OF COMMON PART  DBADACOM.
DATA: BEGIN OF YANFM  OCCURS 5.
        INCLUDE STRUCTURE ANFM.
DATA: END   OF YANFM.

DATA: FLG_ARCHIVE.
* Additional Info for RASIMU, RAKOPL.
DATA: COM_IMPR LIKE IMPR,
      COM_IMAK LIKE IMAK,
      COM_PRPS LIKE PRPS,
      COM_AUFKV LIKE AUFKV,
      COM_IMAKPI LIKE STANDARD TABLE OF IMAKPI
                 WITH HEADER LINE,
      COM_IMAKPU LIKE STANDARD TABLE OF IMAKPU
                 WITH HEADER LINE,
      COM_ANLB   LIKE STANDARD TABLE OF ANLB                "virt2
                 WITH HEADER LINE,                          "virt2
* start of note 1366920
      COM_ANLBZA  LIKE STANDARD TABLE OF ANLBZA             "virt2
                  WITH HEADER LINE,                         "virt2
* end of note 1366920
      COM_ANLC   LIKE STANDARD TABLE OF ANLC                "virt2
                 WITH HEADER LINE,                          "virt2
      COM_ANEPV  LIKE STANDARD TABLE OF ANEPV               "virt2
                 WITH HEADER LINE.                          "virt2
RANGES: COM_R_ANLB FOR ANLB-AFABE.                          "virt2

* start of note 1366920
DATA: GT_BER_ANLBZA  LIKE STANDARD TABLE OF ANLBZA
                     WITH HEADER LINE.
* end of note 1366920
DATA: FLG_PERIODS TYPE C.                                   "n.0412316

DATA: G_APLSTAT LIKE SMMAIN-APLSTAT.                        "<0753211
DATA: G_SCMA_LOG_HANDLE TYPE BALLOGHNDL.                    "<0809226

DATA: HLP_OLD_AFAR        TYPE BOOLEAN.                     "> 949701


TYPES:
  BEGIN OF ty_s_depr_values,
    bukrs  TYPE anlp-bukrs,
    anln1  TYPE anlp-anln1,
    anln2  TYPE anlp-anln2,
    gjahr  TYPE anlp-gjahr,
    afaber TYPE anlp-afaber,
    peraf  TYPE anlp-peraf,
    posted TYPE char1,
    aufwz  TYPE anlp-aufwz,
    nafaz  TYPE anlp-nafaz,
    safaz  TYPE anlp-safaz,
    aafaz  TYPE anlp-aafaz,
    mafaz  TYPE anlp-mafaz,
    zinsz  TYPE anlp-zinsz,
    aufnz  TYPE anlp-aufwz,
  END OF ty_s_depr_values.

DATA: gv_com_period_offs      TYPE i,
      gb_com_simulate_periods TYPE abap_bool,
      gt_depr_values          TYPE TABLE OF ty_s_depr_values
                              WITH UNIQUE HASHED KEY tab_key COMPONENTS bukrs anln1 anln2 gjahr afaber peraf posted .
" end of changes note 2372072

DATA: END   OF COMMON PART.
