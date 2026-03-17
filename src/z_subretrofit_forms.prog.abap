*&---------------------------------------------------------------------*
*&  Include           Z_SUBRETROFIT_FORMS
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  COUNTRY_CHECK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM COUNTRY_CHECK .

CALL FUNCTION 'J_1BSA_COMPONENT_ACTIVE'
      EXPORTING
        bukrs                      = p_bukrs
        component                  = 'IN'
      EXCEPTIONS
        component_not_active       = 1
        OTHERS                     = 2.
  IF sy-subrc NE 0.
    MESSAGE e012.
    EXIT.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SHOW_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SHOW_DATA .

*Generate an instance of the ALV table object

TRY .
  CALL METHOD cl_salv_table=>factory
    IMPORTING
      r_salv_table = gr_table
    CHANGING
      t_table      = lt_subsrc.
CATCH CX_SALV_MSG .
ENDTRY.



**Get the reference to the ALV toolbar functions
  gr_functions = gr_table->get_functions( ).
**Set all toolbar functions
  gr_functions->set_all( abap_true ).

*Display the ALV table.
  gr_table->display( ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_CHALLANS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_CHALLANS .
"Not getting seq-no, assuming it is wrong.
IF s_chln IS NOT INITIAL.
    SELECT * FROM j_1ig_subcon INTO TABLE lt_subsrc
                                  WHERE bukrs EQ p_bukrs
                                  AND   chln_inv IN s_chln
                                  AND   status IN ('P', 'F').

    IF sy-subrc NE '0'.
      MESSAGE 'No Valid Challans exists' TYPE 'E'.
    ENDIF.
ELSE.
    SELECT * FROM j_1ig_subcon INTO TABLE lt_subsrc
                                  WHERE bukrs EQ p_bukrs
                                  AND   status IN ('P', 'F').

    IF sy-subrc NE '0'.
      MESSAGE 'No Valid Challans exists' TYPE 'E'.
    ENDIF.
ENDIF.

*ch_oqty least qty is the actual status of challan & item.
DATA: ls_chtab TYPE chtab,
      ls_sub1  TYPE J_1IG_SUBCON.
CLEAR: ls_chtab, ls_sub1.
SORT lt_subsrc BY chln_inv item ch_oqty DESCENDING.
*  MOVE-CORRESPONDING lt_subsrc[] TO gt_chtab[].
**gt_subact contains actual status of challan records.
*  MOVE-CORRESPONDING lt_subsrc[] TO gt_subact[].
LOOP AT lt_subsrc INTO ls_sub1.
  MOVE-CORRESPONDING ls_sub1 TO ls_chtab.
  APPEND ls_chtab TO gt_chtab.
  APPEND ls_sub1  TO gt_subact.
 CLEAR: ls_chtab, ls_sub1.
ENDLOOP.
  DELETE ADJACENT DUPLICATES FROM gt_chtab COMPARING chln_inv item.
*gt_chtab contains list of all challans & items

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS_CHLNS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM PROCESS_CHLNS .
DATA : seq_no TYPE j_1ig_subcon-seq_no VALUE IS INITIAL.
CLEAR: ls_sub, gs_chtab.

LOOP AT gt_chtab INTO gs_chtab.
  LOOP AT lt_subsrc INTO ls_sub WHERE chln_inv = gs_chtab-chln_inv
                                  AND     item = gs_chtab-item.
   seq_no = seq_no + 1.
   ls_sub-seq_no = seq_no.
   ls_sub-AENAM  = sy-uname.
   ls_sub-AEDAT  = sy-datum.
   ls_sub-UTIME  = sy-UZEIT.
*Updating challan table (lt_subsrc) with seq_no
     MODIFY lt_subsrc FROM ls_sub TRANSPORTING seq_no aenam aedat utime
                                         WHERE chln_inv = ls_sub-chln_inv
                                           AND     item = ls_sub-item
                                           AND  ch_oqty = ls_sub-ch_oqty.

  ENDLOOP.
  CLEAR: seq_no, ls_sub.
ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_CHLNS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDATE_CHLNS .
IF simulate EQ 'X'.
  PERFORM SHOW_DATA.
ELSEIF update EQ 'X' .
  PERFORM LOCK_DOC.
  PERFORM UPDATE_TABLE.
  COMMIT WORK AND WAIT.
ENDIF.
FREE: lt_subsrc, gt_chtab, gt_subact.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LOCK_DOC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM LOCK_DOC .

CALL FUNCTION 'ENQUEUE_E_TABLE'
 EXPORTING
   MODE_RSTABLE         = 'E'
   TABNAME              = 'J_1IG_SUBCON'
*   VARKEY               =
*   X_TABNAME            = ' '
*   X_VARKEY             = ' '
*   _SCOPE               = '2'
*   _WAIT                = ' '
*   _COLLECT             = ' '
 EXCEPTIONS
   FOREIGN_LOCK         = 1
   SYSTEM_FAILURE       = 2
   OTHERS               = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
   MESSAGE e532(8i) WITH 'J_1IG_SUBCON'.
ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPDATE_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM UPDATE_TABLE .

  DELETE j_1ig_subcon FROM TABLE gt_subact.
  IF sy-subrc EQ 0.
      UPDATE j_1ig_subcon FROM TABLE lt_subsrc.
      IF sy-subrc EQ '0'.
        MESSAGE s045(j_1ig_msgs).
*        PERFORM log_create.
*        CALL FUNCTION 'BAL_DSP_LOG_DISPLAY'.
      ELSE.
        MESSAGE a308(8i) WITH 'J_1IG_SUBCON' .
      ENDIF.
  ELSE.
    MESSAGE a308(8i) WITH 'J_1IG_SUBCON' .
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  LOG_CREATE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM LOG_CREATE .
DATA: ls_log        TYPE bal_s_log,
      ls_msg        TYPE bal_s_msg,
      lv_msgno      TYPE symsgno,
      ls_sub2       TYPE j_1ig_subcon.


  ls_log-object = 'J_1IG_SUB'.
  ls_log-subobject = 'ZCHLN'.

  LOOP AT lt_subsrc INTO ls_sub2.
    CONCATENATE ls_sub2-MBLNR    '_'
                ls_sub2-ZEILE    '_'
                ls_sub2-MJAHR    '_'
                ls_sub2-CHLN_INV '_'
                ls_sub2-ITEM    INTO
                ls_log-extnumber.
    ls_log-aldate     = sy-datum.
    ls_log-altime     = sy-uzeit.
    ls_log-aluser     = sy-uname.
    ls_log-alprog     = sy-repid.

* create an initial log file
  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log                 = ls_log
    IMPORTING
      e_log_handle            = gv_log_handle
    EXCEPTIONS
      log_header_inconsistent = 1
      OTHERS                  = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  ENDLOOP.
CLEAR ls_sub2.
ENDFORM.
