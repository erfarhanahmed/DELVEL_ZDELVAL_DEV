*&---------------------------------------------------------------------*
*& Include          J_1IG_IRN_SEL_SCR
*&---------------------------------------------------------------------*

*---Selection criteria and parameters
SELECTION-SCREEN BEGIN OF BLOCK m1 WITH FRAME TITLE TEXT-t09.
  PARAMETERS: p_sl_man RADIOBUTTON GROUP r6 DEFAULT 'X',
              p_sl_aut RADIOBUTTON GROUP r6.
SELECTION-SCREEN END OF BLOCK m1.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-t01.
  PARAMETERS: p_ob_inv RADIOBUTTON GROUP r2 USER-COMMAND rb1 MODIF ID mx DEFAULT 'X',
              p_ob_dis RADIOBUTTON GROUP r2 MODIF ID mx.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-t02.
  PARAMETERS: p_sing RADIOBUTTON GROUP r4  USER-COMMAND rb3 MODIF ID m2 DEFAULT 'X',
              p_bulk RADIOBUTTON GROUP r4 MODIF ID m2.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b4 WITH FRAME TITLE TEXT-t07.
  PARAMETERS: p_fg RADIOBUTTON GROUP r5  USER-COMMAND rb4 MODIF ID m3 DEFAULT 'X',
              p_bg RADIOBUTTON GROUP r5 MODIF ID m1.
SELECTION-SCREEN END OF BLOCK b4.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-t08.
  PARAMETERS: p_ccode  TYPE bukrs OBLIGATORY,
              p_bp     TYPE bupla MODIF ID m8,
              p_fyear  TYPE gjahr MODIF ID m8,
              p_fyear1 TYPE gjahr MODIF ID m4 OBLIGATORY.

  SELECT-OPTIONS: s_doc   FOR w_doc  MODIF ID m4,
                  s_odn   FOR w_odn  MODIF ID m4,
                  s_bp    FOR w_bp   MODIF ID m4 NO INTERVALS,
                  s_date  FOR w_date MODIF ID m4.
  SELECT-OPTIONS: s_stat  FOR w_stat MODIF ID m4 NO INTERVALS.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE gv_title.
  PARAMETERS: p_file TYPE localfile  MODIF ID m5,
              p_dir  TYPE string     MODIF ID m6,
              p_dir1 TYPE pfeflnamel MODIF ID m7.
SELECTION-SCREEN END OF BLOCK b6.

AT SELECTION-SCREEN OUTPUT.
  IF p_sl_aut EQ c_x.
    LOOP AT SCREEN.
       if screen-group1 = 'MX'.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.

  ENDIF.



  IF p_ob_inv EQ c_x.
    LOOP AT SCREEN.
      IF screen-group1   EQ c_m4 OR
         ( p_sing        EQ c_x AND
         ( screen-group1 EQ c_m3 OR screen-group1 EQ c_m1 ) ) OR
         ( p_sing        EQ c_x AND
         ( screen-group1 EQ c_m6 OR screen-group1 EQ c_m7 ) ) OR
         ( p_bulk        EQ c_x AND screen-group1 EQ c_m5 ) OR
         ( p_bulk        EQ c_x AND
           j_1ig_cl_irn=>gv_cloud_check EQ c_x AND
           screen-group1 EQ c_m1 ) OR
         ( p_bulk        EQ c_x AND
         ( p_fg EQ c_x AND screen-group1 EQ c_m7 ) OR
         ( p_bg EQ c_x AND screen-group1 EQ c_m6 ) ).
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    CLEAR: s_bp[],s_doc[],
           s_date[],s_odn[],s_stat[].
  ELSE.
    LOOP AT SCREEN.
      IF screen-group1 EQ c_m2 OR
         screen-group1 EQ c_m3 OR
         screen-group1 EQ c_m1 OR
         screen-group1 EQ c_m5 OR
         screen-group1 EQ c_m6 OR
         screen-group1 EQ c_m7 OR
         screen-group1 EQ c_m8.
        screen-active = 0.
        MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    CLEAR: p_bp,p_file,p_dir,p_dir1.

    ENDIF.


  IF p_sing EQ c_x.
    gv_title = TEXT-t03.
  ELSE.
    IF p_fg EQ c_x.
      gv_title = TEXT-t05.
    ELSE.
      gv_title = TEXT-t06.
    ENDIF.
  ENDIF.

*----------------------------------------------------------------------*
* At Selection-Screen On Value-Request
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  j_1ig_cl_irn=>get_filename( IMPORTING
                                ex_file = p_file ).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dir.
  j_1ig_cl_irn=>get_directory_path( EXPORTING
                                      im_fg = c_x
                                    IMPORTING
                                      ex_dir = p_dir ).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_dir1.
  j_1ig_cl_irn=>get_directory_path( IMPORTING
                                      ex_dir1 = p_dir1 ).
