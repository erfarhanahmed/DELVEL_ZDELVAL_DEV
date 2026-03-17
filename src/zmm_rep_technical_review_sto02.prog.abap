*----------------------------------------------------------------------*
***INCLUDE ZMM_REP_TECHNICAL_REVIEW_STO02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9002 OUTPUT.
  SET PF-STATUS 'MAIN9001'.
   APPEND 'DELETE' TO fcode4.
    SET PF-STATUS 'MAIN9001' EXCLUDING fcode4.

  clear: wa_mytable,
         it_line_1.
  refresh it_line_1.

* editor for 1. Enginerring and scope
  IF g_editor3 IS INITIAL.
    PERFORM read_text_9002 USING 'ZTR3'.
    PERFORM create_editor_cont3_9002.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.

* editor for 2. Vendor doc requirement
  IF g_editor4 IS INITIAL.
    PERFORM read_text_9002 USING 'ZTR4'.
    PERFORM create_editor_cont4_9002.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.

* editor for 3. Product Certification requirement
  IF g_editor5 IS INITIAL.
    PERFORM read_text_9002 USING 'ZTR5'.
    PERFORM create_editor_cont5_9002.
    refresh it_line_1.
    clear it_line_1.
  endif.


* Remark editor for 1. Enginerring and scope
  IF g_editor3r IS INITIAL.
    PERFORM read_text_9002 USING 'ZT3R'.
    PERFORM create_editor_cont3r_9002.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.

* remark editor for 2. Vendor doc requirement
  IF g_editor4r IS INITIAL.
    PERFORM read_text_9002 USING 'ZT4R'.
    PERFORM create_editor_cont4r_9002.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.

* remark editor for 3. Product Certification requirement
  IF g_editor5r IS INITIAL.
    PERFORM read_text_9002 USING 'ZT5R'.
    PERFORM create_editor_cont5r_9002.
    refresh it_line_1.
    clear it_line_1.
  endif.



ENDMODULE.                 " STATUS_9002  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_9003  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9003 OUTPUT.

    APPEND 'DELETE' TO fcode1.
    SET PF-STATUS 'MAIN9001' EXCLUDING fcode1.

  refresh it_line_1.
  clear it_line_1.
* editor for 4. Expediting & Inspection
  IF g_editor6 IS INITIAL.
    PERFORM read_text_9003 USING 'ZTR6'.
    PERFORM create_editor_cont6_9003.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.

* editor for 5. QA Inspection
  IF g_editor7 IS INITIAL.
    PERFORM read_text_9003 USING 'ZTR7'.
    PERFORM create_editor_cont7_9003.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.


* editor for 6. Post Despatch Doc Requirements
  IF g_editor8 IS INITIAL.
    PERFORM read_text_9003 USING 'ZTR8'.
    PERFORM create_editor_cont8_9003.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.

* Remark editor for 1. Enginerring and scope
  IF g_editor6r IS INITIAL.
    PERFORM read_text_9003 USING 'ZT6R'.
    PERFORM create_editor_cont6r_9002.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.

* remark editor for 2. Vendor doc requirement
  IF g_editor7r IS INITIAL.
    PERFORM read_text_9003 USING 'ZT7R'.
    PERFORM create_editor_cont7r_9002.
    refresh it_line_1.
    clear it_line_1.
  ENDIF.

* remark editor for 3. Product Certification requirement
  IF g_editor8r IS INITIAL.
    PERFORM read_text_9003 USING 'ZT8R'.
    PERFORM create_editor_cont8r_9002.
    refresh it_line_1.
    clear it_line_1.
  endif.
ENDMODULE.                 " STATUS_9003  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_9004  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE STATUS_9004 OUTPUT.
  if sy-dynnr = '9004'.
    APPEND 'NEXT'  TO fcode1.
    APPEND 'LAST' TO fcode1.
    APPEND 'DELETE' TO fcode1.

    SET PF-STATUS 'MAIN9001' EXCLUDING fcode1.

  endif.

  if it_ztech[] is NOT INITIAL.
    read TABLE it_ztech with KEY vbeln = p_sono.
    if sy-subrc eq 0.

      if it_ztech-COMM_DATE_1 is NOT INITIAL or it_ztech-ACT_DATE_1 is NOT INITIAL or
        it_ztech-DEL_DATE_1  is NOT INITIAL or it_ztech-PERSON_1 is NOT INITIAL or
        it_ztech-COMM_DATE_2 is NOT INITIAL or it_ztech-ACT_DATE_2 is NOT INITIAL or
        it_ztech-DEL_DATE_2  is NOT INITIAL or it_ztech-PERSON_2 is NOT INITIAL or
        it_ztech-COMM_DATE_3 is NOT INITIAL or it_ztech-ACT_DATE_3 is NOT INITIAL or
        it_ztech-DEL_DATE_3  is NOT INITIAL or it_ztech-PERSON_3 is NOT INITIAL or
        it_ztech-COMM_DATE_4 is NOT INITIAL or it_ztech-ACT_DATE_4 is NOT INITIAL or
        it_ztech-DEL_DATE_4  is NOT INITIAL or it_ztech-PERSON_4 is NOT INITIAL or
        it_ztech-COMM_DATE_5 is NOT INITIAL or it_ztech-ACT_DATE_5 is NOT INITIAL or
        it_ztech-DEL_DATE_5  is NOT INITIAL or it_ztech-PERSON_5 is NOT INITIAL or
        it_ztech-COMM_DATE_6 is NOT INITIAL or it_ztech-ACT_DATE_6 is NOT INITIAL or
        it_ztech-DEL_DATE_6  is NOT INITIAL or it_ztech-PERSON_6 is NOT INITIAL or
        it_ztech-COMM_DATE_7 is NOT INITIAL or it_ztech-ACT_DATE_7 is NOT INITIAL or
        it_ztech-DEL_DATE_7  is NOT INITIAL or it_ztech-PERSON_7 is NOT INITIAL or
        it_ztech-COMM_DATE_8 is NOT INITIAL or it_ztech-ACT_DATE_8 is NOT INITIAL or
        it_ztech-DEL_DATE_8  is NOT INITIAL or it_ztech-PERSON_8 is NOT INITIAL or
        it_ztech-COMM_DATE_9 is NOT INITIAL or it_ztech-ACT_DATE_9 is NOT INITIAL or
        it_ztech-DEL_DATE_9  is NOT INITIAL or it_ztech-PERSON_9 is NOT INITIAL or
        it_ztech-COMM_DATE_10 is NOT INITIAL or it_ztech-ACT_DATE_10 is NOT INITIAL or
        it_ztech-DEL_DATE_10  is NOT INITIAL or it_ztech-PERSON_10 is NOT INITIAL or
        it_ztech-COMM_DATE_11 is NOT INITIAL or it_ztech-ACT_DATE_11 is NOT INITIAL or
        it_ztech-DEL_DATE_11  is NOT INITIAL or it_ztech-PERSON_11 is NOT INITIAL or
        it_ztech-COMM_DATE_12 is NOT INITIAL or it_ztech-ACT_DATE_12 is NOT INITIAL or
        it_ztech-DEL_DATE_12  is NOT INITIAL or it_ztech-PERSON_12 is NOT INITIAL or
        it_ztech-COMM_DATE_13 is NOT INITIAL or it_ztech-ACT_DATE_13 is NOT INITIAL or
        it_ztech-DEL_DATE_13  is NOT INITIAL or it_ztech-PERSON_13 is NOT INITIAL or
        it_ztech-COMM_DATE_14 is NOT INITIAL or it_ztech-ACT_DATE_14 is NOT INITIAL or
        it_ztech-DEL_DATE_14  is NOT INITIAL or it_ztech-PERSON_14 is NOT INITIAL or
        it_ztech-COMM_DATE_15 is NOT INITIAL or it_ztech-ACT_DATE_15 is NOT INITIAL or
        it_ztech-DEL_DATE_15  is NOT INITIAL or it_ztech-PERSON_15 is NOT INITIAL.

***** 1

        if ztech_review-COMM_DATE_1 is INITIAL.
          ztech_review-COMM_DATE_1       = it_ztech-COMM_DATE_1.
        else.
          ztech_review-COMM_DATE_1       = ztech_review-COMM_DATE_1.
        endif.

        if ztech_review-ACT_DATE_1 is INITIAL.
          ztech_review-ACT_DATE_1       = it_ztech-ACT_DATE_1.
        else.
          ztech_review-ACT_DATE_1       = ztech_review-ACT_DATE_1.
        endif.

        if ztech_review-DEL_DATE_1 is INITIAL.
          ztech_review-DEL_DATE_1       = it_ztech-DEL_DATE_1.
        else.
          ztech_review-DEL_DATE_1       = ztech_review-DEL_DATE_1.
        endif.

        if ztech_review-PERSON_1 is INITIAL.
          ztech_review-PERSON_1       = it_ztech-PERSON_1.
        else.
          ztech_review-PERSON_1       = ztech_review-PERSON_1.
        endif.


**** 2
        if ztech_review-COMM_DATE_2 is INITIAL.
          ztech_review-COMM_DATE_2       = it_ztech-COMM_DATE_2.
        else.
          ztech_review-COMM_DATE_2       = ztech_review-COMM_DATE_2.
        endif.

        if ztech_review-ACT_DATE_2 is INITIAL.
          ztech_review-ACT_DATE_2       = it_ztech-ACT_DATE_2.
        else.
          ztech_review-ACT_DATE_2       = ztech_review-ACT_DATE_2.
        endif.

        if ztech_review-DEL_DATE_2 is INITIAL.
          ztech_review-DEL_DATE_2       = it_ztech-DEL_DATE_2.
        else.
          ztech_review-DEL_DATE_2       = ztech_review-DEL_DATE_2.
        endif.

        if ztech_review-PERSON_2 is INITIAL.
          ztech_review-PERSON_2       = it_ztech-PERSON_2.
        else.
          ztech_review-PERSON_2       = ztech_review-PERSON_2.
        endif.

***** 3
        if ztech_review-COMM_DATE_3 is INITIAL.
          ztech_review-COMM_DATE_3       = it_ztech-COMM_DATE_3.
        else.
          ztech_review-COMM_DATE_3       = ztech_review-COMM_DATE_3.
        endif.

        if ztech_review-ACT_DATE_3 is INITIAL.
          ztech_review-ACT_DATE_3       = it_ztech-ACT_DATE_3.
        else.
          ztech_review-ACT_DATE_3       = ztech_review-ACT_DATE_3.
        endif.

        if ztech_review-DEL_DATE_3 is INITIAL.
          ztech_review-DEL_DATE_3       = it_ztech-DEL_DATE_3.
        else.
          ztech_review-DEL_DATE_3       = ztech_review-DEL_DATE_3.
        endif.

        if ztech_review-PERSON_3 is INITIAL.
          ztech_review-PERSON_3       = it_ztech-PERSON_3.
        else.
          ztech_review-PERSON_3       = ztech_review-PERSON_3.
        endif.

*** 4
        if ztech_review-COMM_DATE_4 is INITIAL.
          ztech_review-COMM_DATE_4       = it_ztech-COMM_DATE_4.
        else.
          ztech_review-COMM_DATE_4       = ztech_review-COMM_DATE_4.
        endif.

        if ztech_review-ACT_DATE_4 is INITIAL.
          ztech_review-ACT_DATE_4       = it_ztech-ACT_DATE_4.
        else.
          ztech_review-ACT_DATE_4       = ztech_review-ACT_DATE_4.
        endif.

        if ztech_review-DEL_DATE_4 is INITIAL.
          ztech_review-DEL_DATE_4       = it_ztech-DEL_DATE_4.
        else.
          ztech_review-DEL_DATE_4       = ztech_review-DEL_DATE_4.
        endif.

        if ztech_review-PERSON_4 is INITIAL.
          ztech_review-PERSON_4      = it_ztech-PERSON_4.
        else.
          ztech_review-PERSON_4       = ztech_review-PERSON_4.
        endif.

**** 5
        if ztech_review-COMM_DATE_5 is INITIAL.
          ztech_review-COMM_DATE_5       = it_ztech-COMM_DATE_5.
        else.
          ztech_review-COMM_DATE_5       = ztech_review-COMM_DATE_5.
        endif.

        if ztech_review-ACT_DATE_5 is INITIAL.
          ztech_review-ACT_DATE_5       = it_ztech-ACT_DATE_5.
        else.
          ztech_review-ACT_DATE_5       = ztech_review-ACT_DATE_5.
        endif.

        if ztech_review-DEL_DATE_5 is INITIAL.
          ztech_review-DEL_DATE_5       = it_ztech-DEL_DATE_5.
        else.
          ztech_review-DEL_DATE_5       = ztech_review-DEL_DATE_5.
        endif.

        if ztech_review-PERSON_5 is INITIAL.
          ztech_review-PERSON_5       = it_ztech-PERSON_5.
        else.
          ztech_review-PERSON_5       = ztech_review-PERSON_5.
        endif.
***** 6

        if ztech_review-COMM_DATE_6 is INITIAL.
          ztech_review-COMM_DATE_6       = it_ztech-COMM_DATE_6.
        else.
          ztech_review-COMM_DATE_6       = ztech_review-COMM_DATE_6.
        endif.

        if ztech_review-ACT_DATE_6 is INITIAL.
          ztech_review-ACT_DATE_6       = it_ztech-ACT_DATE_6.
        else.
          ztech_review-ACT_DATE_6       = ztech_review-ACT_DATE_6.
        endif.

        if ztech_review-DEL_DATE_6 is INITIAL.
          ztech_review-DEL_DATE_6      = it_ztech-DEL_DATE_6.
        else.
          ztech_review-DEL_DATE_6       = ztech_review-DEL_DATE_6.
        endif.

        if ztech_review-PERSON_6 is INITIAL.
          ztech_review-PERSON_6       = it_ztech-PERSON_6.
        else.
          ztech_review-PERSON_6       = ztech_review-PERSON_6.
        endif.
**** 7
        if ztech_review-COMM_DATE_7 is INITIAL.
          ztech_review-COMM_DATE_7       = it_ztech-COMM_DATE_7.
        else.
          ztech_review-COMM_DATE_7       = ztech_review-COMM_DATE_7.
        endif.

        if ztech_review-ACT_DATE_7 is INITIAL.
          ztech_review-ACT_DATE_7       = it_ztech-ACT_DATE_7.
        else.
          ztech_review-ACT_DATE_7       = ztech_review-ACT_DATE_7.
        endif.

        if ztech_review-DEL_DATE_7 is INITIAL.
          ztech_review-DEL_DATE_7       = it_ztech-DEL_DATE_7.
        else.
          ztech_review-DEL_DATE_7       = ztech_review-DEL_DATE_7.
        endif.

        if ztech_review-PERSON_7 is INITIAL.
          ztech_review-PERSON_7       = it_ztech-PERSON_7.
        else.
          ztech_review-PERSON_7       = ztech_review-PERSON_7.
        endif.
*** 8
        if ztech_review-COMM_DATE_8 is INITIAL.
          ztech_review-COMM_DATE_8       = it_ztech-COMM_DATE_8.
        else.
          ztech_review-COMM_DATE_8       = ztech_review-COMM_DATE_8.
        endif.

        if ztech_review-ACT_DATE_8 is INITIAL.
          ztech_review-ACT_DATE_8       = it_ztech-ACT_DATE_8.
        else.
          ztech_review-ACT_DATE_8       = ztech_review-ACT_DATE_8.
        endif.

        if ztech_review-DEL_DATE_8 is INITIAL.
          ztech_review-DEL_DATE_8       = it_ztech-DEL_DATE_8.
        else.
          ztech_review-DEL_DATE_8       = ztech_review-DEL_DATE_8.
        endif.

        if ztech_review-PERSON_8 is INITIAL.
          ztech_review-PERSON_8       = it_ztech-PERSON_8.
        else.
          ztech_review-PERSON_8       = ztech_review-PERSON_8.
        endif.

*** 9
        if ztech_review-COMM_DATE_9 is INITIAL.
          ztech_review-COMM_DATE_9       = it_ztech-COMM_DATE_9.
        else.
          ztech_review-COMM_DATE_9       = ztech_review-COMM_DATE_9.
        endif.

        if ztech_review-ACT_DATE_9 is INITIAL.
          ztech_review-ACT_DATE_9       = it_ztech-ACT_DATE_9.
        else.
          ztech_review-ACT_DATE_9       = ztech_review-ACT_DATE_9.
        endif.

        if ztech_review-DEL_DATE_9 is INITIAL.
          ztech_review-DEL_DATE_9       = it_ztech-DEL_DATE_9.
        else.
          ztech_review-DEL_DATE_9       = ztech_review-DEL_DATE_9.
        endif.

        if ztech_review-PERSON_9 is INITIAL.
          ztech_review-PERSON_9       = it_ztech-PERSON_9.
        else.
          ztech_review-PERSON_9       = ztech_review-PERSON_9.
        endif.

**** 10
        if ztech_review-COMM_DATE_10 is INITIAL.
          ztech_review-COMM_DATE_10       = it_ztech-COMM_DATE_10.
        else.
          ztech_review-COMM_DATE_10       = ztech_review-COMM_DATE_10.
        endif.

        if ztech_review-ACT_DATE_10 is INITIAL.
          ztech_review-ACT_DATE_10       = it_ztech-ACT_DATE_10.
        else.
          ztech_review-ACT_DATE_10       = ztech_review-ACT_DATE_10.
        endif.

        if ztech_review-DEL_DATE_10 is INITIAL.
          ztech_review-DEL_DATE_10       = it_ztech-DEL_DATE_10.
        else.
          ztech_review-DEL_DATE_10       = ztech_review-DEL_DATE_10.
        endif.

        if ztech_review-PERSON_10 is INITIAL.
          ztech_review-PERSON_10       = it_ztech-PERSON_10.
        else.
          ztech_review-PERSON_10       = ztech_review-PERSON_10.
        endif.

**** 11
        if ztech_review-COMM_DATE_11 is INITIAL.
          ztech_review-COMM_DATE_11       = it_ztech-COMM_DATE_11.
        else.
          ztech_review-COMM_DATE_11       = ztech_review-COMM_DATE_11.
        endif.

        if ztech_review-ACT_DATE_11 is INITIAL.
          ztech_review-ACT_DATE_11       = it_ztech-ACT_DATE_11.
        else.
          ztech_review-ACT_DATE_11       = ztech_review-ACT_DATE_11.
        endif.

        if ztech_review-DEL_DATE_11 is INITIAL.
          ztech_review-DEL_DATE_11       = it_ztech-DEL_DATE_11.
        else.
          ztech_review-DEL_DATE_11       = ztech_review-DEL_DATE_11.
        endif.

        if ztech_review-PERSON_11 is INITIAL.
          ztech_review-PERSON_11       = it_ztech-PERSON_11.
        else.
          ztech_review-PERSON_11       = ztech_review-PERSON_11.
        endif.

**** 12
        if ztech_review-COMM_DATE_12 is INITIAL.
          ztech_review-COMM_DATE_12       = it_ztech-COMM_DATE_12.
        else.
          ztech_review-COMM_DATE_12       = ztech_review-COMM_DATE_12.
        endif.

        if ztech_review-ACT_DATE_12 is INITIAL.
          ztech_review-ACT_DATE_12       = it_ztech-ACT_DATE_12.
        else.
          ztech_review-ACT_DATE_12       = ztech_review-ACT_DATE_12.
        endif.

        if ztech_review-DEL_DATE_12 is INITIAL.
          ztech_review-DEL_DATE_12       = it_ztech-DEL_DATE_12.
        else.
          ztech_review-DEL_DATE_12       = ztech_review-DEL_DATE_12.
        endif.

        if ztech_review-PERSON_12 is INITIAL.
          ztech_review-PERSON_12       = it_ztech-PERSON_12.
        else.
          ztech_review-PERSON_12       = ztech_review-PERSON_12.
        endif.

**** 13
        if ztech_review-COMM_DATE_13 is INITIAL.
          ztech_review-COMM_DATE_13       = it_ztech-COMM_DATE_13.
        else.
          ztech_review-COMM_DATE_13       = ztech_review-COMM_DATE_13.
        endif.

        if ztech_review-ACT_DATE_13 is INITIAL.
          ztech_review-ACT_DATE_13       = it_ztech-ACT_DATE_13.
        else.
          ztech_review-ACT_DATE_13       = ztech_review-ACT_DATE_13.
        endif.

        if ztech_review-DEL_DATE_13 is INITIAL.
          ztech_review-DEL_DATE_13       = it_ztech-DEL_DATE_13.
        else.
          ztech_review-DEL_DATE_13       = ztech_review-DEL_DATE_13.
        endif.

        if ztech_review-PERSON_13 is INITIAL.
          ztech_review-PERSON_13       = it_ztech-PERSON_13.
        else.
          ztech_review-PERSON_13       = ztech_review-PERSON_13.
        endif.

**** 14
        if ztech_review-COMM_DATE_14 is INITIAL.
          ztech_review-COMM_DATE_14       = it_ztech-COMM_DATE_14.
        else.
          ztech_review-COMM_DATE_14       = ztech_review-COMM_DATE_14.
        endif.

        if ztech_review-ACT_DATE_14 is INITIAL.
          ztech_review-ACT_DATE_14       = it_ztech-ACT_DATE_14.
        else.
          ztech_review-ACT_DATE_14       = ztech_review-ACT_DATE_14.
        endif.

        if ztech_review-DEL_DATE_14 is INITIAL.
          ztech_review-DEL_DATE_14       = it_ztech-DEL_DATE_14.
        else.
          ztech_review-DEL_DATE_14       = ztech_review-DEL_DATE_14.
        endif.

        if ztech_review-PERSON_14 is INITIAL.
          ztech_review-PERSON_14       = it_ztech-PERSON_14.
        else.
          ztech_review-PERSON_14       = ztech_review-PERSON_14.
        endif.
**** 15
        if ztech_review-COMM_DATE_15 is INITIAL.
          ztech_review-COMM_DATE_15       = it_ztech-COMM_DATE_15.
        else.
          ztech_review-COMM_DATE_15       = ztech_review-COMM_DATE_15.
        endif.

        if ztech_review-ACT_DATE_15 is INITIAL.
          ztech_review-ACT_DATE_15       = it_ztech-ACT_DATE_15.
        else.
          ztech_review-ACT_DATE_15       = ztech_review-ACT_DATE_15.
        endif.

        if ztech_review-DEL_DATE_15 is INITIAL.
          ztech_review-DEL_DATE_15       = it_ztech-DEL_DATE_15.
        else.
          ztech_review-DEL_DATE_15       = ztech_review-DEL_DATE_15.
        endif.

        if ztech_review-PERSON_15 is INITIAL.
          ztech_review-PERSON_15       = it_ztech-PERSON_15.
        else.
          ztech_review-PERSON_15       = ztech_review-PERSON_15.
        endif.

      endif.
    ENDIF.


  ENDIF.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                 " STATUS_9004  OUTPUT
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT3_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT3_9002 .
*   create control container
  CREATE OBJECT g_editor_container1
    EXPORTING
      container_name              = 'CC_ENG'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_ENG'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor3
        EXPORTING
         parent = g_editor_container1
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

*   to handle different containers
  g_container_linked = 1.
* READ Text for ATTENDEE from ZTR3 text ID

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable3.
  endloop.

  if it_line_1[] is NOT INITIAL.
*   send table to control
    CALL METHOD g_editor3->set_text_as_r3table
      EXPORTING
        table = g_mytable3.
  endif.
*  REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI

ENDFORM.                    " CREATE_EDITOR_CONT3_9002
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0014   text
*----------------------------------------------------------------------*
FORM READ_TEXT_9002  USING    VALUE(P_ztr).
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
ENDFORM.                    " READ_TEXT_9002
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT4_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT4_9002 .
*   create control container
  CREATE OBJECT g_editor_container2
    EXPORTING
      container_name              = 'CC_2'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_2'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor4
        EXPORTING
         parent = g_editor_container2
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

* READ Text for ATTENDEE from ZTR4 text ID

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable4.
    clear wa_mytable.
  endloop.

  if it_line_1[] is NOT INITIAL.
*   send table to control
    CALL METHOD g_editor4->set_text_as_r3table
      EXPORTING
        table = g_mytable4.
  ENDIF.
*   to handle different containers
  g_container_linked = 1.

*  REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI

**   create control container
*  CREATE OBJECT g_editor_container
*    EXPORTING
*      container_name              = 'CC_R_2'
*    EXCEPTIONS
*      cntl_error                  = 1
*      cntl_system_error           = 2
*      create_error                = 3
*      lifetime_error              = 4
*      lifetime_dynpro_dynpro_link = 5.
*  IF sy-subrc NE 0.
**      add your handling
*  ENDIF.
*  g_mycontainer = 'CC_R_2'.
*
**   create calls constructor, which initializes, creats and links
**   TextEdit Control
*  CREATE OBJECT g_editor4
*        EXPORTING
*         parent = g_editor_container
*         wordwrap_mode =
**             cl_gui_textedit=>wordwrap_off
*            cl_gui_textedit=>wordwrap_at_fixed_position
**             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
*         wordwrap_position = line_length
*         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.
*
**   to handle different containers
*  g_container_linked = 1.

*  REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI
ENDFORM.                    " CREATE_EDITOR_CONT4_9002
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT5_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT5_9002 .
*   create control container
  CREATE OBJECT g_editor_container
    EXPORTING
      container_name              = 'CC_3'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_3'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor5
        EXPORTING
         parent = g_editor_container
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

* READ Text for ATTENDEE from ZTR5 text ID

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable5.
    clear wa_mytable.

  endloop.
  if it_line_1[] is NOT INITIAL.
*   send table to control
    CALL METHOD g_editor5->set_text_as_r3table
      EXPORTING
        table = g_mytable5.
*   to handle different containers
    g_container_linked = 1.
  endif.
  REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI

**   create control container
*  CREATE OBJECT g_editor_container
*    EXPORTING
*      container_name              = 'CC_R_3'
*    EXCEPTIONS
*      cntl_error                  = 1
*      cntl_system_error           = 2
*      create_error                = 3
*      lifetime_error              = 4
*      lifetime_dynpro_dynpro_link = 5.
*  IF sy-subrc NE 0.
**      add your handling
*  ENDIF.
*  g_mycontainer = 'CC_R_3'.
*
**   create calls constructor, which initializes, creats and links
**   TextEdit Control
*  CREATE OBJECT g_editor5
*        EXPORTING
*         parent = g_editor_container
*         wordwrap_mode =
**             cl_gui_textedit=>wordwrap_off
*            cl_gui_textedit=>wordwrap_at_fixed_position
**             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
*         wordwrap_position = line_length
*         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.
*
*
*
**   to handle different containers
*  g_container_linked = 1.
*
*  REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI


ENDFORM.                    " CREATE_EDITOR_CONT5_9002
*&---------------------------------------------------------------------*
*&      Form  READ_TEXT_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0014   text
*----------------------------------------------------------------------*
FORM READ_TEXT_9003  USING    VALUE(P_ztr).
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
ENDFORM.                    " READ_TEXT_9002
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT3R_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT3R_9002 .
*   create control container
  CREATE OBJECT g_editor_container1
    EXPORTING
      container_name              = 'CC_R_1'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_R_1'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor3r
        EXPORTING
         parent = g_editor_container1
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

*   to handle different containers
  g_container_linked = 1.
* READ Text for ATTENDEE from ZTR3 text ID

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable3r.
  endloop.

  if it_line_1[] is NOT INITIAL.
*   send table to control
    CALL METHOD g_editor3r->set_text_as_r3table
      EXPORTING
        table = g_mytable3r.
  endif.
ENDFORM.                    " CREATE_EDITOR_CONT3R_9002
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT4R_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT4R_9002 .
*   create control container
  CREATE OBJECT g_editor_container1
    EXPORTING
      container_name              = 'CC_R_2'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_R_2'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor4r
        EXPORTING
         parent = g_editor_container1
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

*   to handle different containers
  g_container_linked = 1.
* READ Text for ATTENDEE from ZTR3 text ID

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable4r.
  endloop.

  if it_line_1[] is NOT INITIAL.
*   send table to control
    CALL METHOD g_editor4r->set_text_as_r3table
      EXPORTING
        table = g_mytable4r.
  endif.
ENDFORM.                    " CREATE_EDITOR_CONT4R_9002
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT5R_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT5R_9002 .
*   create control container
  CREATE OBJECT g_editor_container1
    EXPORTING
      container_name              = 'CC_R_3'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_R_3'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor5r
        EXPORTING
         parent = g_editor_container1
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

*   to handle different containers
  g_container_linked = 1.
* READ Text for ATTENDEE from ZTR3 text ID

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable5r.
  endloop.

  if it_line_1[] is NOT INITIAL.
*   send table to control
    CALL METHOD g_editor5r->set_text_as_r3table
      EXPORTING
        table = g_mytable5r.
  endif.
ENDFORM.                    " CREATE_EDITOR_CONT5R_9002
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT6R_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT6R_9002 .
*   create control container
  CREATE OBJECT g_editor_container1
    EXPORTING
      container_name              = 'CC_R_4'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_R_4'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor6r
        EXPORTING
         parent = g_editor_container1
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

* READ Text for Expediting & Inspection

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable6r.
    clear wa_mytable.
  endloop.

*   send table to control
  CALL METHOD g_editor6r->set_text_as_r3table
    EXPORTING
      table = g_mytable6r.
*   to handle different containers
  g_container_linked = 1.

ENDFORM.                    " CREATE_EDITOR_CONT6R_9002
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT7R_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT7R_9002 .
*   create control container
  CREATE OBJECT g_editor_container1
    EXPORTING
      container_name              = 'CC_R_5'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_R_5'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor7r
        EXPORTING
         parent = g_editor_container1
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

* READ Text for Expediting & Inspection

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable7r.
    clear wa_mytable.
  endloop.

*   send table to control
  CALL METHOD g_editor7r->set_text_as_r3table
    EXPORTING
      table = g_mytable7r.
*   to handle different containers
  g_container_linked = 1.
ENDFORM.                    " CREATE_EDITOR_CONT7R_9002
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT8R_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT8R_9002 .
*   create control container
  CREATE OBJECT g_editor_container1
    EXPORTING
      container_name              = 'CC_R_6'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_R_6'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor8r
        EXPORTING
         parent = g_editor_container1
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

* READ Text for Expediting & Inspection

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable8r.
    clear wa_mytable.
  endloop.

*   send table to control
  CALL METHOD g_editor8r->set_text_as_r3table
    EXPORTING
      table = g_mytable8r.
*   to handle different containers
  g_container_linked = 1.
ENDFORM.                    " CREATE_EDITOR_CONT8R_9002
