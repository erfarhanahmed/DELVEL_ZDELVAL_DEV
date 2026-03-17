*----------------------------------------------------------------------*
***INCLUDE ZMM_REP_TECHNICAL_REVIEW_STO01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9001 OUTPUT.

  data : lv_kunnr like vbak-kunnr.

  SET PF-STATUS 'MAIN9001'.
  SET TITLEBAR  'TECHNICAL REVIEW'.
  refresh it_line_1.

  clear : lv_kunnr.

  SELECT * from ztech_review
    into TABLE it_ztech
    WHERE vbeln = p_sono.

  SELECT SINGLE kunnr FROM
     vbak into lv_kunnr
     WHERE vbeln = p_sono.

  SELECT SINGLE name1 FROM kna1
    into   ztech_review-client
    WHERE kunnr = lv_kunnr.

  SELECT SINGLE bstnk FROM
    vbak into ztech_review-ref_no
    WHERE vbeln = p_sono.

  SELECT SINGLE bstdk FROM
 vbak into ztech_review-tr_date
 WHERE vbeln = p_sono.

  if it_ztech[] is NOT INITIAL.
    read TABLE it_ztech with KEY vbeln = p_sono.
    if sy-subrc eq 0.

      if it_ztech-client is NOT INITIAL or
         it_ztech-ref_no is NOT INITIAL or
         it_ztech-tr_date is NOT  INITIAL or
         it_ztech-project is NOT INITIAL or
         it_ztech-metting_loc is NOT INITIAL or
         it_ztech-subject is NOT INITIAL or
         it_ztech-meeting_date is NOT INITIAL or
         it_ztech-rec_by is NOT INITIAL or
         it_ztech-app_by is NOT INITIAL.


        if ztech_review-client is INITIAL.
          ztech_review-client       = it_ztech-client.
        else.
          ztech_review-client       = ztech_review-client.
        endif.

        if ztech_review-ref_no is INITIAL.
          ztech_review-ref_no       = it_ztech-ref_no.
        else.
          ztech_review-ref_no       = ztech_review-ref_no.
        endif.

        if ztech_review-tr_date is INITIAL.
          ztech_review-tr_date       = it_ztech-tr_date.
        else.
          ztech_review-tr_date      = ztech_review-tr_date.
        endif.

        if ztech_review-project is INITIAL.
          ztech_review-project       = it_ztech-project.
        else.
          ztech_review-project      = ztech_review-project.
        endif.

        if ztech_review-metting_loc is INITIAL.
          ztech_review-metting_loc       = it_ztech-metting_loc.
        else.
          ztech_review-metting_loc      = ztech_review-metting_loc.
        endif.

        if ztech_review-subject is INITIAL.
          ztech_review-subject       = it_ztech-subject.
        else.
          ztech_review-subject      = ztech_review-subject.
        endif.

        if ztech_review-meeting_date is INITIAL.
          ztech_review-meeting_date       = it_ztech-meeting_date.
        else.
          ztech_review-meeting_date      = ztech_review-meeting_date.
        endif.

        if ztech_review-rec_by is INITIAL.
          ztech_review-rec_by       = it_ztech-rec_by.
        else.
          ztech_review-rec_by      = ztech_review-rec_by.
        endif.

        if ztech_review-app_by is INITIAL.
          ztech_review-app_by       = it_ztech-app_by.
        else.
          ztech_review-app_by      = ztech_review-app_by.
        endif.
      endif.
    ENDIF.
  ENDIF.


  SO = P_SONO.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      INPUT  = SO
    IMPORTING
      OUTPUT = SO.

  if sy-dynnr = '9001'.
    APPEND 'PREVIOUS'  TO fcode.
    APPEND 'FIRSTPAGE' TO fcode.
    SET PF-STATUS 'MAIN9001' EXCLUDING fcode.
  endif.

  IF g_editor1 IS INITIAL.
    PERFORM read_text_9001 USING 'ZTR1'.
    PERFORM create_editor_cont1_9001.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.

  IF g_editor2 IS INITIAL.
    PERFORM read_text_9001 USING 'ZTR2'.
    PERFORM create_editor_cont2_9001.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.
ENDMODULE.                 " STATUS_9001  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT_9001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM READ_TEXT_9001 USING p_ztr.
  clear it_line_1.
  fname1 = p_sono.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*       CLIENT                        = SY-MANDT
      ID                            = p_ztr " 'ZTR'
      LANGUAGE                      = sy-langu
      NAME                          = fname1
      OBJECT                        = 'ZTR'
*       ARCHIVE_HANDLE                = 0
*       LOCAL_CAT                     = ' '
*     IMPORTING
*       HEADER                        =
    TABLES
      LINES                         = it_line_1
   EXCEPTIONS
     ID                            = 1
     LANGUAGE                      = 2
     NAME                          = 3
     NOT_FOUND                     = 4
     OBJECT                        = 5
     REFERENCE_CHECK               = 6
     WRONG_ACCESS_TO_ARCHIVE       = 7
     OTHERS                        = 8
            .
  IF SY-SUBRC <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.

ENDFORM.                    " READ_TEXT_9001
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT_9001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT1_9001 .
*   create control container
  CREATE OBJECT g_editor_container
    EXPORTING
      container_name              = 'CC_ATTENDEE'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_ATTENDEE'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor1
        EXPORTING
         parent = g_editor_container
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

*   to handle different containers
  g_container_linked = 1.

* READ Text for ATTENDEE from ZTR text ID

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable1.
    clear wa_mytable.
  endloop.

*   send table to control
  CALL METHOD g_editor1->set_text_as_r3table
    EXPORTING
      table = g_mytable1.
*    REFRESH g_mytable1.  " to initialize table upon OK_CODE 'BACK' at PAI

ENDFORM.                    " CREATE_EDITOR_CONT_9001
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT2_9001
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT2_9001 .

*   create control container
  CREATE OBJECT g_editor_container
    EXPORTING
      container_name              = 'CC_DIST'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_DIST'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor2
        EXPORTING
         parent = g_editor_container
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

*   to handle different containers
  g_container_linked = 1.

* READ Text for DISTRIBUTION from ZTR2 text ID

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable2.
    clear wa_mytable.
  endloop.

*   send table to control
  CALL METHOD g_editor2->set_text_as_r3table
    EXPORTING
      table = g_mytable2.
*    REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI

ENDFORM.                    " CREATE_EDITOR_CONT2_9001
