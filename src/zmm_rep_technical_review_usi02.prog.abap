*----------------------------------------------------------------------*
***INCLUDE ZMM_REP_TECHNICAL_REVIEW_USI02 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9002 INPUT.

  g_ok_code = sy-ucomm.

  CASE g_ok_code.

*    WHEN 'BACK'.
*      PERFORM back_program.

    WHEN 'EXIT'.
      LEAVE to LIST-PROCESSING.
      call TRANSACTION 'ZTRCR'.
*      PERFORM exit_program.

    when 'NEXT'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9002.
      else.

      ENDIF.
      PERFORM call_next_screen_9003.

    when 'FIRSTPAGE'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9002.
      else.

      ENDIF.
      PERFORM call_first_screen_9001.

    when 'PREVIOUS'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9002.
      else.

      ENDIF.
      PERFORM call_first_screen_9001.
    when 'SAVE'.
      PERFORM call_save_9002.
    when 'LAST'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9002.
      else.

      ENDIF.
      PERFORM call_last_9004.
  ENDCASE.
ENDMODULE.                 " USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*&      Form  CALL_NEXT_SCREEN_9003
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_NEXT_SCREEN_9003 .
  call SCREEN '9003'.
ENDFORM.                    " CALL_NEXT_SCREEN_9003
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9003  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9003 INPUT.

  g_ok_code = sy-ucomm.

  CASE g_ok_code.

*    WHEN 'BACK'.
*      PERFORM back_program.
*
    WHEN 'EXIT'.
      PERFORM exit_program.

    when 'NEXT'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9003.
      else.

      ENDIF.
      PERFORM call_next_screen_9004.

    when 'FIRSTPAGE'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9003.
      else.

      ENDIF.
      PERFORM call_first_screen_9001.

    when 'PREVIOUS'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9003.
      else.

      ENDIF.
      PERFORM call_first_screen_9002.
    when 'SAVE'.
      PERFORM call_save_9003.
    when 'LAST'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9003.
      else.

      ENDIF.
      PERFORM call_last_9004.
  ENDCASE.

ENDMODULE.                 " USER_COMMAND_9003  INPUT
*&---------------------------------------------------------------------*
*&      Form  CALL_FIRST_SCREEN_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_FIRST_SCREEN_9002 .
  SET PF-STATUS 'MAIN9001'.

  SET SCREEN '9002'.
  LEAVE SCREEN.
ENDFORM.                    " CALL_FIRST_SCREEN_9002

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9003  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_9004 INPUT.

  g_ok_code = sy-ucomm.

  CASE g_ok_code.

*    WHEN 'BACK'.
*      PERFORM back_program.
*
    WHEN 'EXIT'.
      PERFORM exit_program.

*    when 'NEXT'.
*      PERFORM call_next_screen_9004.

    when 'FIRSTPAGE'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        PERFORM call_save_9004.
      else.

      ENDIF.
      PERFORM call_first_screen_9001.

    when 'PREVIOUS'.
      PERFORM call_pop_up_save CHANGING ans_y.
      if ans_y = 1.
        refresh fcode1.
        SET PF-STATUS 'MAIN9001'.
        PERFORM call_save_9004.
      else.

      ENDIF.
      PERFORM call_first_screen_9003.

    WHEN 'SAVE'.

      PERFORM call_save_9004.

  ENDCASE.

ENDMODULE.                 " USER_COMMAND_9003  INPUT
*&---------------------------------------------------------------------*
*&      Form  CALL_FIRST_SCREEN_9003
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_FIRST_SCREEN_9003 .
  SET PF-STATUS 'MAIN9001'.
  SET SCREEN '9003'.
  LEAVE SCREEN.
ENDFORM.                    " CALL_FIRST_SCREEN_9003
*&---------------------------------------------------------------------*
*&      Form  CALL_SAVE_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_SAVE_9002 .

* editor for 1. Enginerring and scope
  PERFORM create_text_9002 USING 'ZTR3'.
  PERFORM create_text_9002 USING 'ZTR4'.
  PERFORM create_text_9002 USING 'ZTR5'.

* Text for Remark Box
  PERFORM create_text_9002 USING 'ZT3R'.
  PERFORM create_text_9002 USING 'ZT4R'.
  PERFORM create_text_9002 USING 'ZT5R'.

  if g_mytable3[] is NOT INITIAL or
     g_mytable4[] is NOT INITIAL or
     g_mytable5[] is NOT INITIAL.
    MESSAGE 'Data was Saved.' TYPE 'S'.
  endif.
ENDFORM.                    " CALL_SAVE_9002
*&---------------------------------------------------------------------*
*&      Form  CREATE_TEXT_9002
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0105   text
*----------------------------------------------------------------------*
FORM CREATE_TEXT_9002  USING    VALUE(P_ztr).
  refresh it_line.

  if p_ztr = 'ZTR3'.

*   retrieve table from control
    CALL METHOD g_editor3->get_text_as_r3table
      IMPORTING
        table = g_mytable3.

    loop at g_mytable3 into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZTR4'.
*   retrieve table from control
    CALL METHOD g_editor4->get_text_as_r3table
      IMPORTING
        table = g_mytable4.

    loop at g_mytable4 into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZTR5'.
*   retrieve table from control
    CALL METHOD g_editor5->get_text_as_r3table
      IMPORTING
        table = g_mytable5.

    loop at g_mytable5 into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.
* remark - Eng & scope

  elseif p_ztr = 'ZT3R'.
*   retrieve table from control
    CALL METHOD g_editor3r->get_text_as_r3table
      IMPORTING
        table = g_mytable3r.

    loop at g_mytable3r into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZT4R'.
*   retrieve table from control
    CALL METHOD g_editor4r->get_text_as_r3table
      IMPORTING
        table = g_mytable4r.

    loop at g_mytable4r into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZT5R'.
*   retrieve table from control
    CALL METHOD g_editor5r->get_text_as_r3table
      IMPORTING
        table = g_mytable5r.

    loop at g_mytable5r into wa_mytable.
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
ENDFORM.                    " CREATE_TEXT_9002
*&---------------------------------------------------------------------*
*&      Form  CALL_SAVE_9003
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_SAVE_9003 .

  PERFORM create_text_9003 USING 'ZTR6'.
  PERFORM create_text_9003 USING 'ZTR7'.
  PERFORM create_text_9003 USING 'ZTR8'.
  PERFORM create_text_9003 USING 'ZT6R'.
  PERFORM create_text_9003 USING 'ZT7R'.
  PERFORM create_text_9003 USING 'ZT8R'.

  if g_mytable6[] is NOT INITIAL or
     g_mytable7[] is NOT INITIAL or
     g_mytable8[] is NOT INITIAL.
    MESSAGE 'Data was Saved.' TYPE 'S'.
  endif.
ENDFORM.                    " CALL_SAVE_9003
*&---------------------------------------------------------------------*
*&      Form  CREATE_TEXT_9003
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0263   text
*----------------------------------------------------------------------*
FORM CREATE_TEXT_9003  USING    VALUE(P_ztr).
  refresh it_line.

  if p_ztr = 'ZTR6'.

*   retrieve table from control
    CALL METHOD g_editor6->get_text_as_r3table
      IMPORTING
        table = g_mytable6.

    loop at g_mytable6 into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZTR7'.
*   retrieve table from control
    CALL METHOD g_editor7->get_text_as_r3table
      IMPORTING
        table = g_mytable7.

    loop at g_mytable7 into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZTR8'.
*   retrieve table from control
    CALL METHOD g_editor8->get_text_as_r3table
      IMPORTING
        table = g_mytable8.

    loop at g_mytable8 into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZT6R'.
*   retrieve table from control
    CALL METHOD g_editor6r->get_text_as_r3table
      IMPORTING
        table = g_mytable6r.

    loop at g_mytable6r into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZT7R'.
*   retrieve table from control
    CALL METHOD g_editor7r->get_text_as_r3table
      IMPORTING
        table = g_mytable7r.

    loop at g_mytable7r into wa_mytable.
      it_line-TDLINE = wa_mytable.
      append it_line.
      clear : it_line , wa_mytable.

    ENDLOOP.

  elseif p_ztr = 'ZT8R'.
*   retrieve table from control
    CALL METHOD g_editor8r->get_text_as_r3table
      IMPORTING
        table = g_mytable8r.

    loop at g_mytable8r into wa_mytable.
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
ENDFORM.                    " CREATE_TEXT_9003
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT6_9003
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT6_9003 .
*   create control container
  CREATE OBJECT g_editor_container
    EXPORTING
      container_name              = 'CC_4'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_4'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor6
        EXPORTING
         parent = g_editor_container
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

* READ Text for Expediting & Inspection

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable6.
    clear wa_mytable.
  endloop.

*   send table to control
  CALL METHOD g_editor6->set_text_as_r3table
    EXPORTING
      table = g_mytable6.
*   to handle different containers
  g_container_linked = 1.


ENDFORM.                    " CREATE_EDITOR_CONT6_9003
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT7_9003
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT7_9003 .
*   create control container
  CREATE OBJECT g_editor_container
    EXPORTING
      container_name              = 'CC_5'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_5'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor7
        EXPORTING
         parent = g_editor_container
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

* READ Text for Expediting & Inspection

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable7.
    clear wa_mytable.
  endloop.

*   send table to control
  CALL METHOD g_editor7->set_text_as_r3table
    EXPORTING
      table = g_mytable7.
*   to handle different containers
  g_container_linked = 1.

*    REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI

**   create control container
*    CREATE OBJECT g_editor_container
*      EXPORTING
*        container_name              = 'CC_R_4'
*      EXCEPTIONS
*        cntl_error                  = 1
*        cntl_system_error           = 2
*        create_error                = 3
*        lifetime_error              = 4
*        lifetime_dynpro_dynpro_link = 5.
*    IF sy-subrc NE 0.
**      add your handling
*    ENDIF.
*    g_mycontainer = 'CC_R_4'.
*
**   create calls constructor, which initializes, creats and links
**   TextEdit Control
*    CREATE OBJECT g_editor6
*          EXPORTING
*           parent = g_editor_container
*           wordwrap_mode =
**             cl_gui_textedit=>wordwrap_off
*              cl_gui_textedit=>wordwrap_at_fixed_position
**             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
*           wordwrap_position = line_length
*           wordwrap_to_linebreak_mode = cl_gui_textedit=>true.
*
**   to handle different containers
*    g_container_linked = 1.
*
*    REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI
ENDFORM.                    " CREATE_EDITOR_CONT7_9003
*&---------------------------------------------------------------------*
*&      Form  CREATE_EDITOR_CONT8_9003
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CREATE_EDITOR_CONT8_9003 .
*   create control container
  CREATE OBJECT g_editor_container
    EXPORTING
      container_name              = 'CC_6'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5.
  IF sy-subrc NE 0.
*      add your handling
  ENDIF.
  g_mycontainer = 'CC_6'.

*   create calls constructor, which initializes, creats and links
*   TextEdit Control
  CREATE OBJECT g_editor8
        EXPORTING
         parent = g_editor_container
         wordwrap_mode =
*             cl_gui_textedit=>wordwrap_off
            cl_gui_textedit=>wordwrap_at_fixed_position
*             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
         wordwrap_position = line_length
         wordwrap_to_linebreak_mode = cl_gui_textedit=>true.

* READ Text for Expediting & Inspection

  loop at it_line_1.
    wa_mytable = it_line_1-tdline.
    APPEND wa_mytable to g_mytable8.
    clear wa_mytable.
  endloop.

*   send table to control
  CALL METHOD g_editor8->set_text_as_r3table
    EXPORTING
      table = g_mytable8.
*   to handle different containers
  g_container_linked = 1.

*    REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI

**   create control container
*    CREATE OBJECT g_editor_container
*      EXPORTING
*        container_name              = 'CC_R_4'
*      EXCEPTIONS
*        cntl_error                  = 1
*        cntl_system_error           = 2
*        create_error                = 3
*        lifetime_error              = 4
*        lifetime_dynpro_dynpro_link = 5.
*    IF sy-subrc NE 0.
**      add your handling
*    ENDIF.
*    g_mycontainer = 'CC_R_4'.
*
**   create calls constructor, which initializes, creats and links
**   TextEdit Control
*    CREATE OBJECT g_editor6
*          EXPORTING
*           parent = g_editor_container
*           wordwrap_mode =
**             cl_gui_textedit=>wordwrap_off
*              cl_gui_textedit=>wordwrap_at_fixed_position
**             cl_gui_textedit=>WORDWRAP_AT_WINDOWBORDER
*           wordwrap_position = line_length
*           wordwrap_to_linebreak_mode = cl_gui_textedit=>true.
*
**   to handle different containers
*    g_container_linked = 1.
*
*    REFRESH g_mytable.  " to initialize table upon OK_CODE 'BACK' at PAI
ENDFORM.                    " CREATE_EDITOR_CONT8_9003
*&---------------------------------------------------------------------*
*&      Form  CALL_SAVE_9004
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CALL_SAVE_9004 .

  if it_ztech[] is NOT INITIAL.


    if ztech_review-COMM_DATE_1 is NOT INITIAL or ztech_review-ACT_DATE_1 is NOT INITIAL or
       ztech_review-DEL_DATE_1  is NOT INITIAL or ztech_review-PERSON_1 is NOT INITIAL or
       ztech_review-COMM_DATE_2 is NOT INITIAL or ztech_review-ACT_DATE_2 is NOT INITIAL or
       ztech_review-DEL_DATE_2  is NOT INITIAL or ztech_review-PERSON_2 is NOT INITIAL or
       ztech_review-COMM_DATE_3 is NOT INITIAL or ztech_review-ACT_DATE_3 is NOT INITIAL or
       ztech_review-DEL_DATE_3  is NOT INITIAL or ztech_review-PERSON_3 is NOT INITIAL or
       ztech_review-COMM_DATE_4 is NOT INITIAL or ztech_review-ACT_DATE_4 is NOT INITIAL or
       ztech_review-DEL_DATE_4  is NOT INITIAL or ztech_review-PERSON_4 is NOT INITIAL or
       ztech_review-COMM_DATE_5 is NOT INITIAL or ztech_review-ACT_DATE_5 is NOT INITIAL or
       ztech_review-DEL_DATE_5  is NOT INITIAL or ztech_review-PERSON_5 is NOT INITIAL or
       ztech_review-COMM_DATE_6 is NOT INITIAL or ztech_review-ACT_DATE_6 is NOT INITIAL or
       ztech_review-DEL_DATE_6  is NOT INITIAL or ztech_review-PERSON_6 is NOT INITIAL or
       ztech_review-COMM_DATE_7 is NOT INITIAL or ztech_review-ACT_DATE_7 is NOT INITIAL or
       ztech_review-DEL_DATE_7  is NOT INITIAL or ztech_review-PERSON_7 is NOT INITIAL or
       ztech_review-COMM_DATE_8 is NOT INITIAL or ztech_review-ACT_DATE_8 is NOT INITIAL or
       ztech_review-DEL_DATE_8  is NOT INITIAL or ztech_review-PERSON_8 is NOT INITIAL or
       ztech_review-COMM_DATE_9 is NOT INITIAL or ztech_review-ACT_DATE_9 is NOT INITIAL or
       ztech_review-DEL_DATE_9  is NOT INITIAL or ztech_review-PERSON_9 is NOT INITIAL or
       ztech_review-COMM_DATE_10 is NOT INITIAL or ztech_review-ACT_DATE_10 is NOT INITIAL or
       ztech_review-DEL_DATE_10  is NOT INITIAL or ztech_review-PERSON_10 is NOT INITIAL or
       ztech_review-COMM_DATE_11 is NOT INITIAL or ztech_review-ACT_DATE_11 is NOT INITIAL or
       ztech_review-DEL_DATE_11  is NOT INITIAL or ztech_review-PERSON_11 is NOT INITIAL or
       ztech_review-COMM_DATE_12 is NOT INITIAL or ztech_review-ACT_DATE_12 is NOT INITIAL or
       ztech_review-DEL_DATE_12  is NOT INITIAL or ztech_review-PERSON_12 is NOT INITIAL or
       ztech_review-COMM_DATE_13 is NOT INITIAL or ztech_review-ACT_DATE_13 is NOT INITIAL or
       ztech_review-DEL_DATE_13  is NOT INITIAL or ztech_review-PERSON_13 is NOT INITIAL or
       ztech_review-COMM_DATE_14 is NOT INITIAL or ztech_review-ACT_DATE_14 is NOT INITIAL or
       ztech_review-DEL_DATE_14  is NOT INITIAL or ztech_review-PERSON_14 is NOT INITIAL or
       ztech_review-COMM_DATE_15 is NOT INITIAL or ztech_review-ACT_DATE_15 is NOT INITIAL or
       ztech_review-DEL_DATE_15  is NOT INITIAL or ztech_review-PERSON_15 is NOT INITIAL.

      ztech_review-COMM_DATE_1       = ztech_review-COMM_DATE_1.
      ztech_review-ACT_DATE_1        = ztech_review-ACT_DATE_1.
      ztech_review-DEL_DATE_1        = ztech_review-DEL_DATE_1.
      ztech_review-PERSON_1          = ztech_review-PERSON_1.

      ztech_review-COMM_DATE_2       = ztech_review-COMM_DATE_2.
      ztech_review-ACT_DATE_2        = ztech_review-ACT_DATE_2.
      ztech_review-DEL_DATE_2        = ztech_review-DEL_DATE_2.
      ztech_review-PERSON_2          = ztech_review-PERSON_2.

      ztech_review-COMM_DATE_3       = ztech_review-COMM_DATE_3.
      ztech_review-ACT_DATE_3        = ztech_review-ACT_DATE_3.
      ztech_review-DEL_DATE_3        = ztech_review-DEL_DATE_3.
      ztech_review-PERSON_3          = ztech_review-PERSON_3.

      ztech_review-COMM_DATE_4       = ztech_review-COMM_DATE_4.
      ztech_review-ACT_DATE_4        = ztech_review-ACT_DATE_4.
      ztech_review-DEL_DATE_4        = ztech_review-DEL_DATE_4.
      ztech_review-PERSON_4          = ztech_review-PERSON_4.

      ztech_review-COMM_DATE_5       = ztech_review-COMM_DATE_5.
      ztech_review-ACT_DATE_5        = ztech_review-ACT_DATE_5.
      ztech_review-DEL_DATE_5        = ztech_review-DEL_DATE_5.
      ztech_review-PERSON_5          = ztech_review-PERSON_5.

      ztech_review-COMM_DATE_6       = ztech_review-COMM_DATE_6.
      ztech_review-ACT_DATE_6        = ztech_review-ACT_DATE_6.
      ztech_review-DEL_DATE_6        = ztech_review-DEL_DATE_6.
      ztech_review-PERSON_6          = ztech_review-PERSON_6.

      ztech_review-COMM_DATE_7       = ztech_review-COMM_DATE_7.
      ztech_review-ACT_DATE_7        = ztech_review-ACT_DATE_7.
      ztech_review-DEL_DATE_7        = ztech_review-DEL_DATE_7.
      ztech_review-PERSON_7          = ztech_review-PERSON_7.

      ztech_review-COMM_DATE_8       = ztech_review-COMM_DATE_8.
      ztech_review-ACT_DATE_8        = ztech_review-ACT_DATE_8.
      ztech_review-DEL_DATE_8        = ztech_review-DEL_DATE_8.
      ztech_review-PERSON_8          = ztech_review-PERSON_8.

      ztech_review-COMM_DATE_9       = ztech_review-COMM_DATE_9.
      ztech_review-ACT_DATE_9        = ztech_review-ACT_DATE_9.
      ztech_review-DEL_DATE_9        = ztech_review-DEL_DATE_9.
      ztech_review-PERSON_9          = ztech_review-PERSON_9.

      ztech_review-COMM_DATE_10       = ztech_review-COMM_DATE_10.
      ztech_review-ACT_DATE_10        = ztech_review-ACT_DATE_10.
      ztech_review-DEL_DATE_10        = ztech_review-DEL_DATE_10.
      ztech_review-PERSON_10          = ztech_review-PERSON_10.

      ztech_review-COMM_DATE_11       = ztech_review-COMM_DATE_11.
      ztech_review-ACT_DATE_11        = ztech_review-ACT_DATE_11.
      ztech_review-DEL_DATE_11        = ztech_review-DEL_DATE_11.
      ztech_review-PERSON_11          = ztech_review-PERSON_11.

      ztech_review-COMM_DATE_12       = ztech_review-COMM_DATE_12.
      ztech_review-ACT_DATE_12        = ztech_review-ACT_DATE_12.
      ztech_review-DEL_DATE_12        = ztech_review-DEL_DATE_12.
      ztech_review-PERSON_12          = ztech_review-PERSON_12.

      ztech_review-COMM_DATE_13       = ztech_review-COMM_DATE_13.
      ztech_review-ACT_DATE_13        = ztech_review-ACT_DATE_13.
      ztech_review-DEL_DATE_13        = ztech_review-DEL_DATE_13.
      ztech_review-PERSON_13          = ztech_review-PERSON_13.

      ztech_review-COMM_DATE_14       = ztech_review-COMM_DATE_14.
      ztech_review-ACT_DATE_14        = ztech_review-ACT_DATE_14.
      ztech_review-DEL_DATE_14        = ztech_review-DEL_DATE_14.
      ztech_review-PERSON_14          = ztech_review-PERSON_14.

      ztech_review-COMM_DATE_15       = ztech_review-COMM_DATE_15.
      ztech_review-ACT_DATE_15        = ztech_review-ACT_DATE_15.
      ztech_review-DEL_DATE_15        = ztech_review-DEL_DATE_15.
      ztech_review-PERSON_15          = ztech_review-PERSON_15.

      ztech_review-vbeln = p_sono.
      update ztech_review.
      commit WORK.

      MESSAGE 'Data was Saved.' TYPE 'S'.

    endif.
  endif.
ENDFORM.                    " CALL_SAVE_9004
