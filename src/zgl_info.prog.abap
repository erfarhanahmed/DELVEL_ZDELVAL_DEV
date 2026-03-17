*&---------------------------------------------------------------------*
*& Report ZGL_INFO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zgl_info.

TABLES : ska1,skb1, t001 .

TYPES : BEGIN OF ty,
          bukrs TYPE t001-bukrs,   "KP
          ktopl TYPE ska1-ktopl,
          saknr TYPE ska1-saknr,
          xbilk TYPE ska1-xbilk,
          txt50 TYPE skat-txt50,
        END OF ty .

DATA :lt TYPE TABLE OF ty,
      ls TYPE ty.




DATA : gt_fieldcat TYPE slis_t_fieldcat_alv,
       gs_fieldcat TYPE slis_fieldcat_alv,
       layout      TYPE STANDARD TABLE OF slis_layout_alv WITH HEADER LINE.
DATA: ls_layout TYPE slis_layout_alv.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001 .
SELECT-OPTIONS:S_bukrs FOR t001-bukrs  OBLIGATORY,
               ktopl FOR ska1-ktopl NO INTERVALS NO-EXTENSION OBLIGATORY DEFAULT '1000'.

SELECTION-SCREEN : END OF BLOCK b1 .
*SELECTION-SCREEN : end of BLOCK b1 .
START-OF-SELECTION .

  SELECT * FROM zcashflow INTO TABLE @DATA(gt_cash)
    WHERE ktopl IN @ktopl
    AND bukrs IN @s_bukrs .

  SELECT * FROM ska1 INTO  TABLE @DATA(gt_ska1)
     WHERE ktopl IN @ktopl.
*     and bukrs in @bukrs .


  LOOP AT gt_ska1 INTO DATA(gs).
           IF gs-saknr IS NOT INITIAL .
*       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
*         EXPORTING
*           input         = gs-saknr
*        IMPORTING
*          OUTPUT        = gs-saknr
*                 .
      ENDIF.
           READ TABLE gt_cash INTO DATA(fs) WITH KEY  saknr = gs-saknr .
           IF sy-subrc EQ 0 .
*       CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*         EXPORTING
*           input         =  gs-saknr
*        IMPORTING
*          OUTPUT        = gs-saknr
*                 .
             DELETE gt_ska1 WHERE saknr EQ gs-saknr .
           ENDIF.

*        SELECT bukrs FROM skb1 INTO  TABLE @DATA(gt_skb1)
*        WHERE gs-saknr IN @saknr.
  ENDLOOP .



  LOOP AT gt_ska1 INTO gs.
*    LOOP AT gt_skb1 into data(ps) where saknr = gs-saknr  .
*      ls-bukrs = ps-bukrs.
*   ENDLOOP.

    ls-ktopl =  gs-ktopl.
    ls-saknr =  gs-saknr.
    ls-xbilk =  gs-xbilk.
    select SINGLE bukrs into ls-bukrs from skb1 WHERE saknr = gs-saknr .
    SELECT SINGLE txt50  FROM skat INTO ls-txt50  WHERE ktopl EQ ls-ktopl AND saknr EQ  ls-saknr  .
      IF ls-bukrs IN s_bukrs.
        APPEND ls TO lt .
      ENDIF.

    CLEAR ls .
  ENDLOOP .

  PERFORM fieldcat.
  PERFORM display.


*  PERFORM fieldcat.
*  PERFORM display.

FORM  fieldcat.
  PERFORM build_fc USING  '1' '1'    'BUKRS'       'Company Code'            'LT'  '10' ' ' ' ' .
  PERFORM build_fc USING  '1' '2'    'KTOPL'       'Chart of Accounts'                          'LT'  '20' ' ' ' ' .
  PERFORM build_fc USING  '1' '3'    'SAKNR'          'G/L Account Number'                               'LT'  '10' ' ' ' ' .
  PERFORM build_fc USING  '1' '4'    'XBILK'    'Indicator: Account is a balance sheet account'                       'LT'  '10' ' ' ' '.
  PERFORM build_fc USING  '1' '4'    'TXT50'    'G/L Account Long Text'                       'LT'  '10' ' ' ' '.


*  PERFORM build_fc USING  '1' '1'     'KTOPL'       'Chart of Accounts'                          'LT'  '20' ' ' ' ' .
*  PERFORM build_fc USING  '1' '2'     'SAKNR'          'G/L Account Number'                               'LT'  '10' ' ' ' ' .
*  PERFORM build_fc USING  '1' '3'     'XBILK'    'Indicator: Account is a balance sheet account'                       'LT'  '10' ' ' ' '.
*  PERFORM build_fc USING  '1' '3'     'TXT50'    'G/L Account Long Text'                       'LT'  '10' ' ' ' '.
ENDFORM .

FORM build_fc  USING        pr_row TYPE i
                            pr_count TYPE i
                            pr_fname TYPE string
                            pr_title TYPE string
                            pr_table TYPE slis_tabname
                            pr_width TYPE c
                            pr_sum   TYPE c
*                            pr_len TYPE c
                            lcase TYPE c.
*                         .   outputlen like dd03p-outputlen .

  gs_fieldcat-row_pos   = pr_row.
  gs_fieldcat-col_pos   = pr_count.
  gs_fieldcat-fieldname = pr_fname.
  gs_fieldcat-seltext_l = pr_title.
  gs_fieldcat-tabname   = pr_table.
  gs_fieldcat-outputlen = pr_width.
*  gs_fieldcat-do_sum    = pr_sum.
*  gs_fieldcat-outputlen = outputlen...
*  gs_fieldcat-outputlen = prlen.,.
  gs_fieldcat-lowercase = lcase.

*  IF pr_fname EQ 'ANBTR'.
*    gs_fieldcat-do_sum = 'X'.
*  ENDIF.

  APPEND gs_fieldcat TO gt_fieldcat.
  CLEAR gs_fieldcat.



ENDFORM .





*&---------------------------------------------------------------------*
*& Form DISPLAY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display .
*  SET LAYOUT..
  ls_layout-colwidth_optimize = 'X'.
  ls_layout-zebra = 'X'.


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP'
*     I_CALLBACK_PF_STATUS_SET = 'PF_STATUS_SET'
*     I_CALLBACK_USER_COMMAND  = 'USER_COMMAND'
      is_layout              = ls_layout
      it_fieldcat            = gt_fieldcat
      i_background_id        = 'AIW_BG'
*     it_sort                = lt_sort[]
      i_save                 = 'A'
      i_default              = 'X'
*     IT_EVENTS              = GT_ALV_EVENT
    TABLES
      t_outtab               = lt
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

FORM top.

  DATA: lt_listheader TYPE TABLE OF slis_listheader,
        ls_listheader TYPE slis_listheader,
        ls_month_name TYPE t7ru9a-regno,
        gstin         TYPE j_1bbranch-gstin,
        gs_string     TYPE string,
        gs_month(2)   TYPE n,
        t_line        LIKE ls_listheader-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.
  DATA : cdate   TYPE sy-datum.
  REFRESH lt_listheader.
  CLEAR ls_listheader.

*  CONCATENATE 'DAILY DISPATCH REPORT'." LS_MONTH_NAME SY-DATUM+0(4) INTO GS_STRING SEPARATED BY ' '.
  ls_listheader-typ = 'H'.
  ls_listheader-info = 'NON ASSIGN G/L ACCOUNTS'."GS_STRING.
  APPEND ls_listheader TO lt_listheader.


  cdate = sy-datum.

  gs_string = ''.
  CONCATENATE 'Report Date:' cdate+6(2) '.' cdate+4(2) '.' cdate+0(4) INTO gs_string SEPARATED BY ''.
  ls_listheader-typ = 'S'.
  ls_listheader-info =  gs_string.
  APPEND ls_listheader TO lt_listheader.




  DESCRIBE TABLE gt_ska1 LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. Of Records: ' ld_linesc
   INTO t_line SEPARATED BY space.

  ls_listheader-typ  = 'A'.
  ls_listheader-info = t_line.
  APPEND ls_listheader TO lt_listheader.
  CLEAR: ls_listheader, t_line.


  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_listheader
*     i_logo             = 'AIW_ALV_PHOTO'
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .
ENDFORM.
