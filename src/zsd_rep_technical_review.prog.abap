*&---------------------------------------------------------------------*
*& Report  ZSD_REP_TECHNICAL_REVIEW
*&
*&---------------------------------------------------------------------*
*======================================================================*
*                          MODULE POOL REPORT                          *
*======================================================================*
*======================================================================*
*CASE/OBJ ID        :       Report                                     *
*PROGRAM ID         :       ZSD_REP_TECHNICAL_REVIEW                   *
*CORRECTION         :       Initial Development(----)                  *
*DESCRIPTION        :       Technical REview & Commercial review for
*                           Sales Order                                *
*CREATED BY         :       Marmik Shah                                *
*DATE               :       17.04.2011                                 *
*TCode              :       ZTRCR                                      *
*======================================================================*

*======================================================================*
* Modification Log : (Latest modification should be on the Top)        *
*======================================================================*
*   DATE     PGMR         NAME             CORRECTION  CASE/OBJ ID     *
*======================================================================*
*======================================================================*

REPORT  ZSD_REP_TECHNICAL_REVIEW.

*======================================================================*
*         I N C L U D E S (D A T A    D E C L A R A T I O N S)         *
*======================================================================*

include ZMM_REP_TECH_REVIEW_DECLAR.
include ZMM_REP_TECH_REVIEW_SELSCR.

*======================================================================*
*                    I N I T I A L I Z A T I O N                       *
*----------------------------------------------------------------------*
* The INITIALIZATION is only required if processing is needed to move  *
* default values to SELECT-OPTIONS and PARAMETERS                      *
*======================================================================*
INITIALIZATION.

*======================================================================*
*                  S T A R T - O F - S E L E C T I O N                 *
*======================================================================*

start-of-selection.
  PERFORM SO_Validation.
end-of-SELECTION.


*======================================================================*
*                    E N D - O F - S E L E C T I O N                   *
*======================================================================*
END-OF-SELECTION.


  INCLUDE ZMM_REP_TECHNICAL_REVIEW_STO01.

  INCLUDE ZMM_REP_TECHNICAL_REVIEW_USI01.

  INCLUDE ZMM_REP_TECHNICAL_REVIEW_USI02.

  INCLUDE ZMM_REP_TECHNICAL_REVIEW_STO02.

  INCLUDE ZMM_REP_TECHNICAL_REVIEW_USI03.

  INCLUDE ZSD_REP_TECHNICAL_REVIEW_PRF01.
*&---------------------------------------------------------------------*
*&      Form  SO_VALIDATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SO_VALIDATION .
  data : lv_so like vbak-vbeln.

*  refresh : fcode, fcode1, fcode2.

  SELECT SINGLE vbeln FROM
    vbak
    INTO lv_so
    WHERE vbeln = p_sono.

  if lv_so is INITIAL.
    MESSAGE 'Please Enter Correct Sales Order No' TYPE 'I'.
  else.
    PERFORM call_TR_CR_form.

  ENDIF.


ENDFORM.                    " SO_VALIDATION
*&---------------------------------------------------------------------*
*&      Form  CALL_TR_CR_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_TR_CR_FORM .
if p_sono is NOT  INITIAL and rb_tr = 'X'.
    if cb_prnt = 'X'.

      SELECT * from
        ztech_review
        into TABLE lt_ztech_review
        WHERE vbeln = p_sono.

      if lt_ztech_review[] is NOT INITIAL.
        PERFORM print_TR_form.
      else.
        MESSAGE 'No Technical Review for entered Sales Order' TYPE 'S'.
      endif.
    else.

      call screen 9001.

    endif.

  elseif p_sono is NOT  INITIAL and rb_cr = 'X'.
    if cb_prnt = 'X'.
      SELECT * from
        zcomm_review
        into TABLE lt_zcomm_review
        WHERE vbeln = p_sono.

      if lt_zcomm_review[] is NOT INITIAL.
        PERFORM print_CR_form.
      else.
        MESSAGE 'No Commercial Review for entered Sales Order' TYPE 'S'.
      endif.
    else.
      call SCREEN 9009.
    ENDIF.
  endif.

ENDFORM.                    " CALL_TR_CR_FORM
