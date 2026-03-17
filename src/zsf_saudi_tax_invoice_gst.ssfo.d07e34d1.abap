
DATA ls_word TYPE spell.

*data: IN_WORDS TYPE SPELL.
*BREAK primus.
*CLEAR ls_word.
DATA AMT_IN_NUM   TYPE PC207-BETRG.

IF  LS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'SAR'.

DATA ls_word_AR(255) TYPE C.

AMT_IN_NUM = gv_t_gst.

CALL FUNCTION 'ZHR_AR_CHG_NB_WRDS_2'
  EXPORTING
    AMT_IN_NUM               = AMT_IN_NUM
 IMPORTING
   AMT_IN_WORDS             = ls_word_AR
 EXCEPTIONS
   DATA_TYPE_MISMATCH       = 1
   OTHERS                   = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.





*GV_GST_WRD_AR = ls_word_AR.
*      IF IN_WORDS-DECWORD = 'ZERO'.
*     CONCATENATE 'SAUDI RIYAL' IN_WORDS-WORD 'ONLY' INTO ls_word_AR SEPARATED BY SPACE.
**     ENDIF.
**     IF IN_WORDS-DECWORD IS NOT INITIAL.
*     ELSE.
*     CONCATENATE 'SAUDI RIYAL' IN_WORDS-WORD 'AND' IN_WORDS-DECWORD 'HALLALS ONLY' INTO ls_word_AR SEPARATED BY SPACE.
*     ENDIF.


CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = ls_word_AR
    LANG            = 'A'
 IMPORTING
   RSTRING         = GV_GST_WRD_AR
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.





*  CALL FUNCTION 'SPELL_AMOUNT'
*    EXPORTING
*      amount    = gv_t_gst
**      currency  = LS_BIL_INVOICE-HD_GEN-BIL_WAERK
**      FILLER    = ' '
**      language  = sy-langu
*      language  = 'A'
*    IMPORTING
*      in_words  = ls_word
*    EXCEPTIONS
*      not_found = 1
*      too_large = 2
*      OTHERS    = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
* ENDIF.
*
** CONCATENATE 'SAUDI RIYAL'  ls_word-word 'AND'
**             ls_word-decword 'HALALAS' INTO GV_GST_WRD_AR SEPARATED BY SPACE.
*GV_GST_WRD_AR = ls_word-word.
ELSEIF LS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'USD'.

  CALL FUNCTION 'SPELL_AMOUNT'
    EXPORTING
      amount    = gv_t_gst
      currency  = LS_BIL_INVOICE-HD_GEN-BIL_WAERK
*      FILLER    = ' '
*      language  = sy-langu
      language  = 'E'
    IMPORTING
      in_words  = ls_word
    EXCEPTIONS
      not_found = 1
      too_large = 2
      OTHERS    = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
 ENDIF.
 IF ls_word-decword NE 'ZERO'.
 CONCATENATE  ls_word-word'DOLLARS' 'AND'
             ls_word-decword 'CENTS ' INTO GV_GST_WRD_AR SEPARATED BY SPACE.
 ELSEIF
    ls_word-decword = 'ZERO' .
    CONCATENATE  ls_word-word'DOLLARS'
              INTO GV_GST_WRD_AR SEPARATED BY SPACE.

 ENDIF.
ENDIF.




*CLEAR lv_amt.
*lv_amt = gv_grand_tot.
*CLEAR ls_word_ar.
*BREAK-POINT.
DATA AMT_IN_NUM2   TYPE PC207-BETRG.
AMT_IN_NUM2 = gv_grand_tot.
IF  LS_BIL_INVOICE-HD_GEN-BIL_WAERK = 'SAR'.
DATA ls_word_tot_AR  TYPE char256.

  CALL FUNCTION 'ZHR_AR_CHG_NB_WRDS_2'
  EXPORTING
    AMT_IN_NUM               = AMT_IN_NUM2 "gv_grand_tot
 IMPORTING
   AMT_IN_WORDS             = ls_word_tot_AR
 EXCEPTIONS
   DATA_TYPE_MISMATCH       = 1
   OTHERS                   = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = ls_word_tot_AR
    LANG            = 'A'
 IMPORTING
   RSTRING         = GV_TOT_WRD_AR
* EXCEPTIONS
*   TOO_SMALL       = 1
*   OTHERS          = 2
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.


*DATA : av_SD TYPE CHAR256.
*
*DATA : av_SD2 TYPE CHAR256.
*
*CALL FUNCTION 'STRING_REVERSE'
*  EXPORTING
*    STRING          = ls_word_tot_AR
*    LANG            = 'A'
* IMPORTING
*   RSTRING         = av_SD
** EXCEPTIONS
**   TOO_SMALL       = 1
**   OTHERS          = 2
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.
**
*CLEAR: ls_word_tot_AR.
*ls_word_tot_AR = av_SD.
*CALL FUNCTION 'STRING_REVERSE'
*  EXPORTING
*    STRING          = ls_word_tot_AR
*    LANG            = 'A'
* IMPORTING
*   RSTRING         = av_SD2
** EXCEPTIONS
**   TOO_SMALL       = 1
**   OTHERS          = 2
*          .
*IF SY-SUBRC <> 0.
** Implement suitable error handling here
*ENDIF.
*
*ls_word_tot_AR = av_SD2.

*gv_tot_wrd_AR = ls_word_tot_AR.

ENDIF.



