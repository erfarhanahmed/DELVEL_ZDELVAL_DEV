*----------------------------------------------------------------------*
***INCLUDE ZMM_REP_TECHNICAL_REVIEW_USI03 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9009  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9009 INPUT.

  g_ok_code = sy-ucomm.

  CASE g_ok_code.

    WHEN 'BACK'.
      PERFORM back_program_9009.
*
    WHEN 'EXIT'.
      PERFORM exit_program.

    when 'NEXT'.
      PERFORM call_next_screen_9010.

*    when 'FIRST'.
*      PERFORM call_first_screen_9009.

    when 'SAVE'.
      PERFORM call_save_9009.
*
    when 'LAST'.
      PERFORM call_last_9010.

    WHEN 'DELETE'.
      PERFORM delete_record_cr.

  ENDCASE.


ENDMODULE.                 " USER_COMMAND_9009  INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_9009  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9009 OUTPUT.
  SET PF-STATUS 'MAIN9001'.
  SET TITLEBAR 'COMM_REVIEW'.

  if sy-dynnr = '9009'.
    APPEND 'PREVIOUS'  TO fcode2.
    APPEND 'NEXT' TO fcode2.
    APPEND 'FIRSTPAGE' TO fcode2.
  endif.
  SET PF-STATUS 'MAIN9001' EXCLUDING fcode2.

  SELECT * from zCOMM_review
  into TABLE it_zCOMM
  WHERE vbeln = p_sono.

  if it_zCOMM[] is NOT INITIAL.
    read TABLE it_zCOMM with KEY vbeln = p_sono.
    if sy-subrc eq 0.

      if IT_zcomm-CR_1 IS NOT INITIAL or
            IT_zcomm-CR_2 IS NOT INITIAL or
            IT_zcomm-CR_3 IS NOT INITIAL or
            IT_zcomm-CR_4 IS NOT INITIAL or
            IT_zcomm-CR_5 IS NOT INITIAL or
            IT_zcomm-CR_6 IS NOT INITIAL or
            IT_zcomm-CR_7_RATE IS NOT INITIAL or
            IT_zcomm-CR_8_TEXT IS NOT INITIAL or
            IT_zcomm-CR_9_TEXT IS NOT INITIAL or
            IT_zcomm-CR_10_TEXT IS NOT INITIAL or
            IT_zcomm-CR_11_TEXT IS NOT INITIAL or
            IT_zcomm-CR_12_TEXT IS NOT INITIAL.

        if zCOMM_review-CR_1 is INITIAL.
          zcomm_review-cr_1       = it_zcomm-cr_1.
        else.
          zcomm_review-cr_1       = zcomm_review-cr_1.
        endif.

        if zCOMM_review-CR_2 is INITIAL.
          zcomm_review-cr_2       = it_zcomm-cr_2.
        else.
          zcomm_review-cr_2       = zcomm_review-cr_2.
        endif.

        if zCOMM_review-CR_3 is INITIAL.
          zcomm_review-cr_3      = it_zcomm-cr_3.
        else.
          zcomm_review-cr_3       = zcomm_review-cr_3.
        endif.

        if zCOMM_review-CR_4 is INITIAL.
          zcomm_review-cr_4       = it_zcomm-cr_4.
        else.
          zcomm_review-cr_4       = zcomm_review-cr_4.
        endif.

        if zCOMM_review-CR_5 is INITIAL.
          zcomm_review-cr_5       = it_zcomm-cr_5.
        else.
          zcomm_review-cr_5       = zcomm_review-cr_5.
        endif.

        if zCOMM_review-CR_6 is INITIAL.
          zcomm_review-cr_6       = it_zcomm-cr_6.
        else.
          zcomm_review-cr_6       = zcomm_review-cr_6.
        endif.

        if zCOMM_review-CR_7_rate is INITIAL.
          zcomm_review-cr_7_rate       = it_zcomm-cr_7_rate.
        else.
          zcomm_review-cr_7_rate       = zcomm_review-cr_7_rate.
        endif.

        if zCOMM_review-CR_8_text is INITIAL.
          zcomm_review-CR_8_text       = it_zcomm-CR_8_text.
        else.
          zcomm_review-CR_8_text       = zcomm_review-CR_8_text.
        endif.

        if zCOMM_review-CR_9_text is INITIAL.
          zcomm_review-CR_9_text       = it_zcomm-CR_9_text.
        else.
          zcomm_review-CR_9_text       = zcomm_review-CR_9_text.
        endif.

        if zCOMM_review-CR_10_text is INITIAL.
          zcomm_review-CR_10_text       = it_zcomm-CR_10_text.
        else.
          zcomm_review-CR_10_text       = zcomm_review-CR_10_text.
        endif.

        if zCOMM_review-CR_11_text is INITIAL.
          zcomm_review-CR_11_text       = it_zcomm-CR_11_text.
        else.
          zcomm_review-CR_11_text       = zcomm_review-CR_11_text.
        endif.

        if zCOMM_review-CR_12_text is INITIAL.
          zcomm_review-CR_12_text       = it_zcomm-CR_12_text.
        else.
          zcomm_review-CR_12_text       = zcomm_review-CR_12_text.
        endif.

      ENDIF.

    ENDIF.

  ENDIF.

ENDMODULE.                 " STATUS_9009  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  CALL_NEXT_SCREEN_9010
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_NEXT_SCREEN_9010 .
  call SCREEN '9010'.
ENDFORM.                    " CALL_NEXT_SCREEN_9010
*&---------------------------------------------------------------------*
*&      Form  CALL_FIRST_SCREEN_9009
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_FIRST_SCREEN_9009 .
  call SCREEN '9009'.
ENDFORM.                    " CALL_FIRST_SCREEN_9009
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9010  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9010 INPUT.
  g_ok_code = sy-ucomm.

  CASE g_ok_code.

    WHEN 'BACK'.
      PERFORM back_program_9009.
*
    WHEN 'EXIT'.
      PERFORM exit_program.

*    when 'NEXT'.
*      PERFORM call_next_screen_9010.

    when 'FIRSTPAGE'.
      PERFORM call_first_screen_9009.

    when 'SAVE'.
      PERFORM call_save_9010.
*
    when 'LAST'.
      PERFORM call_last_9010.

  ENDCASE.
ENDMODULE.                 " USER_COMMAND_9010  INPUT
*&---------------------------------------------------------------------*
*&      Form  CALL_LAST_9010
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_LAST_9010 .
  call SCREEN '9010'.
ENDFORM.                    " CALL_LAST_9010
*&---------------------------------------------------------------------*
*&      Module  STATUS_9010  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9010 OUTPUT.
  if sy-dynnr = '9010'.
    APPEND 'PREVIOUS'  TO fcode3.
    APPEND 'NEXT' TO fcode3.
    APPEND 'LAST' TO fcode3.
  endif.
  SET PF-STATUS 'MAIN9001' EXCLUDING fcode3.


  if it_zcomm[] is NOT INITIAL.
    read TABLE it_zcomm with KEY vbeln = p_sono.
    if sy-subrc eq 0.

      if it_zcomm-CR_13_TEXT  ne ' ' or
       it_zcomm-CR_14 ne ' ' or
       it_zcomm-CR_15 ne ' ' or
       it_zcomm-CR_16 ne ' ' or
       it_zcomm-CR_17 ne ' ' or
       it_zcomm-CR_18_text ne ' ' or
       it_zcomm-CR_19 ne ' ' or
       it_zcomm-CR_20 ne ' ' or
       it_zcomm-CR_21_TEXT ne ' ' or
       it_zcomm-CR_22_TEXT ne ' ' or
       it_zcomm-CR_23_TEXT ne ' ' or
       it_zcomm-CR_24 ne ' ' or
       it_zcomm-CR_25 ne ' ' or
       it_zcomm-CR_26 ne ' ' or
       it_zcomm-CR_27 ne ' ' or
       it_zcomm-CR_28 ne ' ' or
       it_zcomm-CR_29 ne ' ' or
       it_zcomm-CR_30 ne ' ' or
       it_zcomm-CR_31 ne ' ' or
       it_zcomm-CR_32 ne ' ' or
       it_zcomm-CR_33_text ne ' ' or
       it_zcomm-CR_34_text ne ' ' or
       it_zcomm-CR_35 ne ' ' or
       it_zcomm-CR_36 ne ' ' or
       it_zcomm-CR_37_text ne ' ' or
       it_zcomm-CR_38 ne ' '.

        if zcomm_review-Cr_13_text is INITIAL.
          zcomm_review-Cr_13_text       = it_zcomm-Cr_13_text.
        else.
          zcomm_review-Cr_13_text      =  zcomm_review-Cr_13_text.
        endif.

        if zcomm_review-Cr_14 is INITIAL.
          zcomm_review-Cr_14       = it_zcomm-Cr_14.
        else.
          zcomm_review-Cr_14      =  zcomm_review-Cr_14.
        endif.

        if zcomm_review-Cr_15 is INITIAL.
          zcomm_review-Cr_15       = it_zcomm-Cr_15.
        else.
          zcomm_review-Cr_15      =  zcomm_review-Cr_15.
        endif.

        if zcomm_review-Cr_16 is INITIAL.
          zcomm_review-Cr_16       = it_zcomm-Cr_16.
        else.
          zcomm_review-Cr_16      =  zcomm_review-Cr_16.
        endif.

        if zcomm_review-Cr_17 is INITIAL.
          zcomm_review-Cr_17       = it_zcomm-Cr_17.
        else.
          zcomm_review-Cr_17      =  zcomm_review-Cr_17.
        endif.

        if zcomm_review-Cr_18_text is INITIAL.
          zcomm_review-Cr_18_text       = it_zcomm-Cr_18_text.
        else.
          zcomm_review-Cr_18_text      =  zcomm_review-Cr_18_text.
        endif.

        if zcomm_review-Cr_19 is INITIAL.
          zcomm_review-Cr_19       = it_zcomm-Cr_19.
        else.
          zcomm_review-Cr_19      =  zcomm_review-Cr_19.
        endif.

        if zcomm_review-Cr_20 is INITIAL.
          zcomm_review-Cr_20       = it_zcomm-Cr_20.
        else.
          zcomm_review-Cr_20      =  zcomm_review-Cr_20.
        endif.

        if zcomm_review-Cr_21_text is INITIAL.
          zcomm_review-Cr_21_text       = it_zcomm-Cr_21_text.
        else.
          zcomm_review-Cr_21_text      =  zcomm_review-Cr_21_text.
        endif.

        if zcomm_review-Cr_22_text is INITIAL.
          zcomm_review-Cr_22_text       = it_zcomm-Cr_22_text.
        else.
          zcomm_review-Cr_22_text      =  zcomm_review-Cr_22_text.
        endif.

        if zcomm_review-Cr_23_text is INITIAL.
          zcomm_review-Cr_23_text       = it_zcomm-Cr_23_text.
        else.
          zcomm_review-Cr_23_text      =  zcomm_review-Cr_23_text.
        endif.

        if zcomm_review-Cr_24 is INITIAL.
          zcomm_review-Cr_24       = it_zcomm-Cr_24.
        else.
          zcomm_review-Cr_24      =  zcomm_review-Cr_24.
        endif.

        if zcomm_review-Cr_25 is INITIAL.
          zcomm_review-Cr_25       = it_zcomm-Cr_25.
        else.
          zcomm_review-Cr_25      =  zcomm_review-Cr_25.
        endif.

        if zcomm_review-Cr_26 is INITIAL.
          zcomm_review-Cr_26       = it_zcomm-Cr_26.
        else.
          zcomm_review-Cr_26      =  zcomm_review-Cr_26.
        endif.

        if zcomm_review-Cr_27 is INITIAL.
          zcomm_review-Cr_27       = it_zcomm-Cr_27.
        else.
          zcomm_review-Cr_27      =  zcomm_review-Cr_27.
        endif.

        if zcomm_review-Cr_28 is INITIAL.
          zcomm_review-Cr_28       = it_zcomm-Cr_28.
        else.
          zcomm_review-Cr_28      =  zcomm_review-Cr_28.
        endif.

        if zcomm_review-Cr_29 is INITIAL.
          zcomm_review-Cr_29       = it_zcomm-Cr_29.
        else.
          zcomm_review-Cr_29      =  zcomm_review-Cr_29.
        endif.

        if zcomm_review-Cr_30 is INITIAL.
          zcomm_review-Cr_30       = it_zcomm-Cr_30.
        else.
          zcomm_review-Cr_30      =  zcomm_review-Cr_30.
        endif.

        if zcomm_review-Cr_31 is INITIAL.
          zcomm_review-Cr_31       = it_zcomm-Cr_31.
        else.
          zcomm_review-Cr_31      =  zcomm_review-Cr_31.
        endif.

        if zcomm_review-Cr_32 is INITIAL.
          zcomm_review-Cr_32      = it_zcomm-Cr_32.
        else.
          zcomm_review-Cr_32      =  zcomm_review-Cr_32.
        endif.

        if zcomm_review-Cr_33_text is INITIAL.
          zcomm_review-Cr_33_text       = it_zcomm-Cr_33_text.
        else.
          zcomm_review-Cr_33_text      =  zcomm_review-Cr_33_text.
        endif.

        if zcomm_review-Cr_34_text is INITIAL.
          zcomm_review-Cr_34_text       = it_zcomm-Cr_34_text.
        else.
          zcomm_review-Cr_34_text      =  zcomm_review-Cr_34_text.
        endif.

        if zcomm_review-Cr_35 is INITIAL.
          zcomm_review-Cr_35      = it_zcomm-Cr_35.
        else.
          zcomm_review-Cr_35      =  zcomm_review-Cr_35.
        endif.

        if zcomm_review-Cr_36 is INITIAL.
          zcomm_review-Cr_36      = it_zcomm-Cr_36.
        else.
          zcomm_review-Cr_36      =  zcomm_review-Cr_36.
        endif.

        if zcomm_review-Cr_37_text is INITIAL.
          zcomm_review-Cr_37_text       = it_zcomm-Cr_37_text.
        else.
          zcomm_review-Cr_37_text      =  zcomm_review-Cr_37_text.
        endif.


        if zcomm_review-Cr_38 is INITIAL.
          zcomm_review-Cr_38      = it_zcomm-Cr_38.
        else.
          zcomm_review-Cr_38      =  zcomm_review-Cr_38.
        endif.



      endif.

    ENDIF.
  ENDIF.

ENDMODULE.                 " STATUS_9010  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  BACK_PROGRAM_9009
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BACK_PROGRAM_9009 .
  if sy-dynnr = '9009'.
    LEAVE PROGRAM.
  ELSEIF sy-dynnr = '9010'.
    call SCREEN '9009'.
  ENDIF.
ENDFORM.                    " BACK_PROGRAM_9009
*&---------------------------------------------------------------------*
*&      Form  CALL_SAVE_9009
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_SAVE_9009 .

  if it_zcomm[] is INITIAL.

    if zcomm_review-CR_1 ne ' ' or
       zcomm_review-CR_2 ne ' ' or
       zcomm_review-CR_3 ne ' ' or
       zcomm_review-CR_4 ne ' ' or
       zcomm_review-CR_5 ne ' ' or
       zcomm_review-CR_6 ne ' ' or
       zcomm_review-CR_7_RATE ne ' ' or
       zcomm_review-CR_8_TEXT ne ' ' or
       zcomm_review-CR_9_TEXT ne ' ' or
       zcomm_review-CR_10_TEXT ne ' ' or
       zcomm_review-CR_11_TEXT ne ' ' or
       zcomm_review-CR_12_TEXT ne ' '.

      zcomm_review-vbeln  = p_sono.
      zcomm_review-CR_1  = zcomm_review-CR_1.
      zcomm_review-cr_2 = zcomm_review-cr_2.
      zcomm_review-cr_3 = zcomm_review-cr_3.
      zcomm_review-cr_4 = zcomm_review-cr_4.
      zcomm_review-cr_5 = zcomm_review-cr_5.
      zcomm_review-cr_6 = zcomm_review-cr_6.
      zcomm_review-cr_7_rate = zcomm_review-cr_7_rate.
      zcomm_review-cr_8_text =  zcomm_review-cr_8_text.
      zcomm_review-cr_9_text = zcomm_review-cr_9_text.
      zcomm_review-cr_10_text = zcomm_review-cr_10_text.
      zcomm_review-cr_11_text = zcomm_review-cr_11_text.
      zcomm_review-cr_12_text = zcomm_review-cr_12_text.
      insert zcomm_review.
      commit WORK.
      if sy-subrc eq 0.
        MESSAGE 'Data was Saved.' TYPE 'S'.
      endif.
    endif.

  else.

    zcomm_review-vbeln  = p_sono.
    zcomm_review-CR_1  = zcomm_review-CR_1.
    zcomm_review-cr_2 = zcomm_review-cr_2.
    zcomm_review-cr_3 = zcomm_review-cr_3.
    zcomm_review-cr_4 = zcomm_review-cr_4.
    zcomm_review-cr_5 = zcomm_review-cr_5.
    zcomm_review-cr_6 = zcomm_review-cr_6.
    zcomm_review-cr_7_rate = zcomm_review-cr_7_rate.
    zcomm_review-cr_8_text =  zcomm_review-cr_8_text.
    zcomm_review-cr_9_text = zcomm_review-cr_9_text.
    zcomm_review-cr_10_text = zcomm_review-cr_10_text.
    zcomm_review-cr_11_text = zcomm_review-cr_11_text.
    zcomm_review-cr_12_text = zcomm_review-cr_12_text.
*
    loop at it_zcomm.

      it_zcomm-vbeln  = p_sono.
      it_zcomm-CR_1  = zcomm_review-CR_1.
      it_zcomm-cr_2 = zcomm_review-cr_2.
      it_zcomm-cr_3 = zcomm_review-cr_3.
      it_zcomm-cr_4 = zcomm_review-cr_4.
      it_zcomm-cr_5 = zcomm_review-cr_5.
      it_zcomm-cr_6 = zcomm_review-cr_6.
      it_zcomm-cr_7_rate = zcomm_review-cr_7_rate.
      it_zcomm-cr_8_text =  zcomm_review-cr_8_text.
      it_zcomm-cr_9_text = zcomm_review-cr_9_text.
      it_zcomm-cr_10_text = zcomm_review-cr_10_text.
      it_zcomm-cr_11_text = zcomm_review-cr_11_text.
      it_zcomm-cr_12_text = zcomm_review-cr_12_text.

      modify it_zCOMM TRANSPORTING vbeln cr_1 cr_2 cr_3 cr_4 cr_5 cr_6 cr_7_rate cr_8_text cr_9_text cr_10_text
                                   cr_11_text cr_12_text.

      clear it_zCOMM.

      update  zcomm_review FROM TABLE it_zcomm.
      commit WORK.
      if sy-subrc eq 0.
        MESSAGE 'Data was Saved.' TYPE 'S'.
      endif.

    ENDLOOP.
  endif.
ENDFORM.                    " CALL_SAVE_9009
*&---------------------------------------------------------------------*
*&      Form  CALL_SAVE_9010
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_SAVE_9010 .
  if it_zcomm[] is NOT INITIAL.

    if zcomm_review-CR_13_TEXT  ne ' ' or
       zcomm_review-CR_14 ne ' ' or
       zcomm_review-CR_15 ne ' ' or
       zcomm_review-CR_16 ne ' ' or
       zcomm_review-CR_17 ne ' ' or
       zcomm_review-CR_18_text ne ' ' or
       zcomm_review-CR_19 ne ' ' or
       zcomm_review-CR_20 ne ' ' or
       zcomm_review-CR_21_TEXT ne ' ' or
       zcomm_review-CR_22_TEXT ne ' ' or
       zcomm_review-CR_23_TEXT ne ' ' or
       zcomm_review-CR_24 ne ' ' or
       zcomm_review-CR_25 ne ' ' or
       zcomm_review-CR_26 ne ' ' or
       zcomm_review-CR_27 ne ' ' or
       zcomm_review-CR_28 ne ' ' or
       zcomm_review-CR_29 ne ' ' or
       zcomm_review-CR_30 ne ' ' or
       zcomm_review-CR_31 ne ' ' or
       zcomm_review-CR_32 ne ' ' or
       zcomm_review-CR_33_text ne ' ' or
       zcomm_review-CR_34_text ne ' ' or
       zcomm_review-CR_35 ne ' ' or
       zcomm_review-CR_36 ne ' ' or
       zcomm_review-CR_37_text ne ' ' or
       zcomm_review-CR_38 ne ' '.

      zcomm_review-vbeln  = p_sono.
      zcomm_review-CR_13_text  = zcomm_review-CR_13_text.
      zcomm_review-cr_14 = zcomm_review-cr_14.
      zcomm_review-cr_15 = zcomm_review-cr_15.
      zcomm_review-cr_16 = zcomm_review-cr_16.
      zcomm_review-cr_17 = zcomm_review-cr_17.
      zcomm_review-cr_18_text = zcomm_review-cr_18_text.
      zcomm_review-cr_19 = zcomm_review-cr_19.
      zcomm_review-cr_20 =  zcomm_review-cr_20.
      zcomm_review-cr_21_text = zcomm_review-cr_21_text.
      zcomm_review-cr_22_text = zcomm_review-cr_22_text.
      zcomm_review-cr_23_text = zcomm_review-cr_23_text.
      zcomm_review-cr_24 = zcomm_review-cr_24.
      zcomm_review-cr_25 = zcomm_review-cr_25.
      zcomm_review-cr_26 = zcomm_review-cr_26.
      zcomm_review-cr_27 = zcomm_review-cr_27.
      zcomm_review-cr_28 = zcomm_review-cr_28.
      zcomm_review-cr_29 = zcomm_review-cr_29.
      zcomm_review-cr_30 = zcomm_review-cr_30.
      zcomm_review-cr_31 = zcomm_review-cr_31.
      zcomm_review-cr_32 = zcomm_review-cr_32.
      zcomm_review-cr_33_text = zcomm_review-cr_33_text.
      zcomm_review-cr_34_text = zcomm_review-cr_34_text.
      zcomm_review-cr_35 = zcomm_review-cr_35.
      zcomm_review-cr_36 = zcomm_review-cr_36.
      zcomm_review-cr_37_text = zcomm_review-cr_37_text.
      zcomm_review-cr_38 = zcomm_review-cr_38.

      update zcomm_review.
      commit WORK.
      if sy-subrc eq 0.
        MESSAGE 'Data was Saved.' TYPE 'S'.
      endif.
    endif.
  endif.
ENDFORM.                    " CALL_SAVE_9010
*&---------------------------------------------------------------------*
*&      Form  DELETE_RECORD_CR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DELETE_RECORD_CR .
  data : ans type n.

  if it_zcomm[] is NOT INITIAL.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
      TITLEBAR                    = 'Commercial Review'
*     DIAGNOSE_OBJECT             = ' '
        TEXT_QUESTION               = 'Are you sure you want to delete record?'
        TEXT_BUTTON_1               = 'Yes'
*     ICON_BUTTON_1               = ' '
        TEXT_BUTTON_2               = 'No'
*     ICON_BUTTON_2               = ' '
*     DEFAULT_BUTTON              = '1'
*     DISPLAY_CANCEL_BUTTON       = 'X'
*     USERDEFINED_F1_HELP         = ' '
*     START_COLUMN                = 25
*     START_ROW                   = 6
*     POPUP_TYPE                  =
*     IV_QUICKINFO_BUTTON_1       = ' '
*     IV_QUICKINFO_BUTTON_2       = ' '
     IMPORTING
       ANSWER                      = ans
*   TABLES
*     PARAMETER                   =
     EXCEPTIONS
       TEXT_NOT_FOUND              = 1
       OTHERS                      = 2
              .
    IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.


    if ans = 1.
      DELETE FROM ZCOMM_REVIeW
      WHERE vbeln = p_sono.
      COMMIT work.

      MESSAGE 'Record Deleted Successfully!' type 'S'.
*      clear : ZTECH_REVIEW-CLIENT,
*              ZTECH_REVIEW-REF_NO,
*              ZTECH_REVIEW-TR_DATE,
*              ZTECH_REVIEW-PROJECT,
*              ZTECH_REVIEW-METTING_LOC,
*              ZTECH_REVIEW-SUBJECT,
*              ZTECH_REVIEW-MEETING_DATE,
*              ZTECH_REVIEW-REC_BY,
*              ZTECH_REVIEW-APP_BY.

    endif.

  ENDIF.

ENDFORM.                    " DELETE_RECORD_CR
