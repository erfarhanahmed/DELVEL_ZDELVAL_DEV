*----------------------------------------------------------------------*
***INCLUDE ZMM_REP_TECHNICAL_REVIEW_USI01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9001 INPUT.
data : ans_y type n.
  g_ok_code = sy-ucomm.

  CASE g_ok_code.

    WHEN 'BACK'.
*      LEAVE TO SCREEN 0.
      LEAVE to LIST-PROCESSING.
      call TRANSACTION 'ZTRCR'.

*      PERFORM back_program.

    WHEN 'EXIT'.
      LEAVE PROGRAM.
*      call TRANSACTION 'ZTRCR'.

*      PERFORM exit_program.

    when 'NEXT'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9001.
      else.

      ENDIF.
      PERFORM call_next_screen_9002.

    when 'FIRST'.
      PERFORM call_first_screen_9001.

    when 'SAVE'.
      PERFORM call_save_9001.

    when 'LAST'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9001.
      else.
      ENDIF.
      PERFORM call_last_9004.

    when 'DELETE'.
      PERFORM delete_record.

  ENDCASE.

ENDMODULE.                 " USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*&      Form  BACK_PROGRAM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM BACK_PROGRAM .
*  CASE sy-dynnr.
*    WHEN '9001'.
**      leave to LIST-PROCESSING and RETURN TO SCREEN 0.
*      call TRANSACTION 'ZTRCR'.
*      PERFORM exit_program.
*    when '9002'.
**     Destroy Control.
*      IF NOT g_editor3 IS INITIAL.
*        CALL METHOD g_editor3->free
*          EXCEPTIONS
*            OTHERS = 1.
*        IF sy-subrc NE 0.
**         add your handling
*        ENDIF.
**       free ABAP object also
*        FREE g_editor3.
*      ENDIF.
*
**     Destroy Control.
*      IF NOT g_editor4 IS INITIAL.
*        CALL METHOD g_editor4->free
*          EXCEPTIONS
*            OTHERS = 1.
*        IF sy-subrc NE 0.
**         add your handling
*        ENDIF.
**       free ABAP object also
*        FREE g_editor4.
*      ENDIF.
*
**     Destroy Control.
*      IF NOT g_editor5 IS INITIAL.
*        CALL METHOD g_editor5->free
*          EXCEPTIONS
*            OTHERS = 1.
*        IF sy-subrc NE 0.
**         add your handling
*        ENDIF.
**       free ABAP object also
*        FREE g_editor5.
*      ENDIF.
*
**     destroy container
*      IF NOT g_editor_container IS INITIAL.
*        CALL METHOD g_editor_container->free
*          EXCEPTIONS
*            OTHERS = 1.
*        IF sy-subrc <> 0.
**         add your handling
*        ENDIF.
**       free ABAP object also
*        FREE g_editor_container.
*      ENDIF.
*
*      CALL METHOD cl_gui_cfw=>flush
*        EXCEPTIONS
*          OTHERS = 1.
*      IF sy-subrc NE 0.
**         add your handling
*      ENDIF.
*
**     set screen
*      SET SCREEN 9001.
*      LEAVE SCREEN.
*
*    when '9003'.
**     Destroy Control.
*      IF NOT g_editor6 IS INITIAL.
*        CALL METHOD g_editor6->free
*          EXCEPTIONS
*            OTHERS = 1.
*        IF sy-subrc NE 0.
**         add your handling
*        ENDIF.
**       free ABAP object also
*        FREE g_editor6.
*      ENDIF.
*
**     Destroy Control.
*      IF NOT g_editor7 IS INITIAL.
*        CALL METHOD g_editor7->free
*          EXCEPTIONS
*            OTHERS = 1.
*        IF sy-subrc NE 0.
**         add your handling
*        ENDIF.
**       free ABAP object also
*        FREE g_editor7.
*      ENDIF.
*
**     Destroy Control.
*      IF NOT g_editor8 IS INITIAL.
*        CALL METHOD g_editor8->free
*          EXCEPTIONS
*            OTHERS = 1.
*        IF sy-subrc NE 0.
**         add your handling
*        ENDIF.
**       free ABAP object also
*        FREE g_editor8.
*      ENDIF.
*
**     destroy container
*      IF NOT g_editor_container IS INITIAL.
*        CALL METHOD g_editor_container->free
*          EXCEPTIONS
*            OTHERS = 1.
*        IF sy-subrc <> 0.
**         add your handling
*        ENDIF.
**       free ABAP object also
*        FREE g_editor_container.
*      ENDIF.
*
*      CALL METHOD cl_gui_cfw=>flush
*        EXCEPTIONS
*          OTHERS = 1.
*      IF sy-subrc NE 0.
**         add your handling
*      ENDIF.
*
**     set screen
*      SET SCREEN 9002.
*      LEAVE SCREEN.



*  ENDCASE.
ENDFORM.                    " BACK_PROGRAM
*&---------------------------------------------------------------------*
*&      Form  EXIT_PROGRAM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM EXIT_PROGRAM .
* Destroy Control. for CC_ATTENDEE
  IF NOT g_editor1 IS INITIAL.
    CALL METHOD g_editor1->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
*     add your handling
    ENDIF.
*   free ABAP object also
    FREE g_editor1.
  ENDIF.

* Destroy Control. for CC_DIST
  IF NOT g_editor2 IS INITIAL.
    CALL METHOD g_editor2->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
*     add your handling
    ENDIF.
*   free ABAP object also
    FREE g_editor2.
  ENDIF.


  IF NOT g_editor3 IS INITIAL.
    CALL METHOD g_editor3->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
*     add your handling
    ENDIF.
*   free ABAP object also
    FREE g_editor3.
  ENDIF.

  IF NOT g_editor4 IS INITIAL.
    CALL METHOD g_editor4->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
*     add your handling
    ENDIF.
*   free ABAP object also
    FREE g_editor4.
  ENDIF.

  IF NOT g_editor5 IS INITIAL.
    CALL METHOD g_editor5->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
*     add your handling
    ENDIF.
*   free ABAP object also
    FREE g_editor5.
  ENDIF.

  IF NOT g_editor6 IS INITIAL.
    CALL METHOD g_editor6->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
*     add your handling
    ENDIF.
*   free ABAP object also
    FREE g_editor6.
  ENDIF.

  IF NOT g_editor7 IS INITIAL.
    CALL METHOD g_editor7->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
*     add your handling
    ENDIF.
*   free ABAP object also
    FREE g_editor7.
  ENDIF.

  IF NOT g_editor8 IS INITIAL.
    CALL METHOD g_editor8->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
*     add your handling
    ENDIF.
*   free ABAP object also
    FREE g_editor8.
  ENDIF.
* destroy container
  IF NOT g_editor_container IS INITIAL.
    CALL METHOD g_editor_container->free
      EXCEPTIONS
        OTHERS = 1.
    IF sy-subrc NE 0.
*     add your handling
    ENDIF.
*   free ABAP object also
    FREE g_editor_container.
  ENDIF.

* finally flush
  CALL METHOD cl_gui_cfw=>flush
    EXCEPTIONS
      OTHERS = 1.
  IF sy-subrc NE 0.
*   add your handling
  ENDIF.
  LEAVE LIST-PROCESSING.
  call TRANSACTION 'ZTRCR'.
ENDFORM.                    " EXIT_PROGRAM
*&---------------------------------------------------------------------*
*&      Form  CALL_NEXT_SCREEN_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_NEXT_SCREEN_9002 .

  call SCREEN '9002'.

ENDFORM.                    " CALL_NEXT_SCREEN_9002
*&---------------------------------------------------------------------*
*&      Form  CALL_FIRST_SCREEN_9001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_FIRST_SCREEN_9001 .
  SET SCREEN '9001'.
  LEAVE SCREEN.
ENDFORM.                    " CALL_FIRST_SCREEN_9001

*&---------------------------------------------------------------------*
*&      Form  CALL_NEXT_SCREEN_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_NEXT_SCREEN_9004 .

  call SCREEN '9004'.

ENDFORM.                    " CALL_NEXT_SCREEN_9004
*&---------------------------------------------------------------------*
*&      Form  CALL_SAVE_9001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_SAVE_9001 .

  if it_ztech[] is INITIAL.

    if ztech_review-client ne ' ' or
       ztech_review-ref_no ne ' ' or
       ztech_review-tr_date ne ' ' or
       ztech_review-project ne ' ' or
       ztech_review-metting_loc ne ' ' or
       ztech_review-subject ne ' ' or
       ztech_review-meeting_date ne ' ' or
       ztech_review-rec_by ne ' ' or
       ztech_review-app_by ne ' '.

      ztech_review-vbeln  = p_sono.
      ztech_review-client = ztech_review-client.
      ztech_review-ref_no = ztech_review-ref_no.
      ztech_review-tr_date = ztech_review-tr_date.
      ztech_review-project = ztech_review-project.
      ztech_review-metting_loc = ztech_review-metting_loc.
      ztech_review-subject = ztech_review-subject.
      ztech_review-meeting_date = ztech_review-meeting_date.
      ztech_review-rec_by = ztech_review-rec_by.
      ztech_review-app_by = ztech_review-app_by.
      insert ztech_review.
      commit WORK.
    endif.

  else.
    ztech_review-vbeln  = p_sono.
    ztech_review-client = ztech_review-client.
    ztech_review-ref_no = ztech_review-ref_no.
    ztech_review-tr_date = ztech_review-tr_date.
    ztech_review-project = ztech_review-project.
    ztech_review-metting_loc = ztech_review-metting_loc.
    ztech_review-subject = ztech_review-subject.
    ztech_review-meeting_date = ztech_review-meeting_date.
    ztech_review-rec_by = ztech_review-rec_by.
    ztech_review-app_by = ztech_review-app_by.

    loop at it_ztech.
      it_ztech-vbeln  = p_sono.
      it_ztech-client = ztech_review-client.
      it_ztech-ref_no = ztech_review-ref_no.
      it_ztech-tr_date = ztech_review-tr_date.
      it_ztech-project = ztech_review-project.
      it_ztech-metting_loc = ztech_review-metting_loc.
      it_ztech-subject = ztech_review-subject.
      it_ztech-meeting_date = ztech_review-meeting_date.
      it_ztech-rec_by = ztech_review-rec_by.
      it_ztech-app_by = ztech_review-app_by.

      modify it_ztech TRANSPORTING vbeln client ref_no tr_Date project metting_loc subject meeting_date rec_by app_by.
      clear it_ztech.
    ENDLOOP.

    update  ztech_review FROM TABLE it_ztech.
    commit WORK.
  ENDIF.



  PERFORM create_text_9001 USING 'ZTR1'.
  PERFORM create_text_9001 USING 'ZTR2'.
  if g_mytable1[] is NOT INITIAL or
   g_mytable2[] is NOT INITIAL.
    MESSAGE 'Data was Saved.' TYPE 'S'.
  endif.
ENDFORM.                    " CALL_SAVE_9001
*&---------------------------------------------------------------------*
*&      Form  CREATE_TEXT_9001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0461   text
*----------------------------------------------------------------------*
FORM CREATE_TEXT_9001  USING    VALUE(P_ztr).

  refresh it_line.
  clear wa_mytable.

  if p_ztr = 'ZTR1'.
*   retrieve table from control
    CALL METHOD g_editor1->get_text_as_r3table
      IMPORTING
        table = g_mytable1.

    loop at g_mytable1 into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZTR2'.
*   retrieve table from control
    CALL METHOD g_editor2->get_text_as_r3table
      IMPORTING
        table = g_mytable2.

    loop at g_mytable2 into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.
  endif.

  fname = p_sono.

  CALL FUNCTION 'CREATE_TEXT'
    EXPORTING
      FID               = p_ztr
      FLANGUAGE         = sy-langu
      FNAME             = fname
      FOBJECT           = 'ZTR'
*         SAVE_DIRECT       = 'X'
*         FFORMAT           = '*'
    TABLES
      FLINES            = it_line
   EXCEPTIONS
     NO_INIT           = 1
     NO_SAVE           = 2
     OTHERS            = 3
            .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.                    " CREATE_TEXT_9001
*&---------------------------------------------------------------------*
*&      Form  CALL_LAST_9004
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_LAST_9004 .
*     set screen
  SET SCREEN 9004.
  LEAVE SCREEN.

ENDFORM.                    " CALL_LAST_9004
*&---------------------------------------------------------------------*
*&      Form  DELETE_RECORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DELETE_RECORD .
  data : ans type n.

  if it_ztech[] is NOT INITIAL.

    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
*     TITLEBAR                    = ' '
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
      DELETE FROM ZTECH_REVIeW
      WHERE vbeln = p_sono.
      COMMIT work.

      MESSAGE 'Record Deleted Successfully!' type 'S'.
      clear : ZTECH_REVIEW-CLIENT,
              ZTECH_REVIEW-REF_NO,
              ZTECH_REVIEW-TR_DATE,
              ZTECH_REVIEW-PROJECT,
              ZTECH_REVIEW-METTING_LOC,
              ZTECH_REVIEW-SUBJECT,
              ZTECH_REVIEW-MEETING_DATE,
              ZTECH_REVIEW-REC_BY,
              ZTECH_REVIEW-APP_BY.

      PERFORM delete_text_TR USING 'ZTR1'.
      PERFORM delete_text_TR USING 'ZTR2'.
      PERFORM delete_text_TR USING 'ZTR3'.
      PERFORM delete_text_TR USING 'ZTR4'.
      PERFORM delete_text_TR USING 'ZTR5'.
      PERFORM delete_text_TR USING 'ZTR6'.
      PERFORM delete_text_TR USING 'ZTR7'.
      PERFORM delete_text_TR USING 'ZTR8'.

      PERFORM delete_text_TR USING 'ZT3R'.
      PERFORM delete_text_TR USING 'ZT4R'.
      PERFORM delete_text_TR USING 'ZT5R'.
      PERFORM delete_text_TR USING 'ZT6R'.
      PERFORM delete_text_TR USING 'ZT7R'.
      PERFORM delete_text_TR USING 'ZT8R'.

    endif.

  ENDIF.

ENDFORM.                    " DELETE_RECORD
*&---------------------------------------------------------------------*
*&      Form  DELETE_TEXT_TR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0839   text
*----------------------------------------------------------------------*
FORM DELETE_TEXT_TR  USING    VALUE(P_ztr).
  data : l_fname like THEAD-TDNAME.
  l_fname = p_sono.
  CALL FUNCTION 'DELETE_TEXT'
    EXPORTING
*     CLIENT                = SY-MANDT
      ID                    = p_ztr
      LANGUAGE              = sy-langu
      NAME                  = l_fname
      OBJECT                = 'ZTR'
*     SAVEMODE_DIRECT       = ' '
*     TEXTMEMORY_ONLY       = ' '
*     LOCAL_CAT             = ' '
   EXCEPTIONS
     NOT_FOUND             = 1
     OTHERS                = 2
            .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


ENDFORM.                    " DELETE_TEXT_TR
*&---------------------------------------------------------------------*
*&      Form  CALL_POP_UP_SAVE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_ANS  text
*----------------------------------------------------------------------*
FORM CALL_POP_UP_SAVE  CHANGING P_ANS.
  data : ans1 type n.
  CALL FUNCTION 'POPUP_TO_CONFIRM'
 EXPORTING
*     TITLEBAR                    = ' '
*     DIAGNOSE_OBJECT             = ' '
   TEXT_QUESTION               = 'Are you sure you want to SAVE record?'
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
  ANSWER                      = ans1
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

  p_ans = ans1.


ENDFORM.                    " CALL_POP_UP_SAVE
