*&---------------------------------------------------------------------*
*& Report ZPSFC_OBJECT_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpsfc_object_list.

* general declarations
INCLUDE ppcoincl.

* internal tables holding objects
DATA caufvd_p_tab LIKE SORTED TABLE OF caufvd_p WITH UNIQUE KEY
                  aufnr                         WITH HEADER LINE.
DATA afpod_p_tab  LIKE SORTED TABLE OF afpod_p WITH UNIQUE KEY
                  aufnr posnr                  WITH HEADER LINE.
DATA affld_p_tab  LIKE SORTED TABLE OF affld_p WITH UNIQUE KEY
                  aufnr plnfl                  WITH HEADER LINE.
DATA afvgd_p_tab  LIKE SORTED TABLE OF afvgd_p WITH UNIQUE KEY
                  aufnrd aplfl vornr           WITH HEADER LINE.
DATA safvgd_p_tab LIKE SORTED TABLE OF afvgd_p WITH UNIQUE KEY
                  aufnrd aplfl vornr uvorn     WITH HEADER LINE.
DATA resbd_p_tab  LIKE SORTED TABLE OF resbd_p WITH UNIQUE KEY
                  posnr matnr rspos rsart      WITH HEADER LINE.
DATA affhd_p_tab  LIKE SORTED TABLE OF affhd_p WITH UNIQUE KEY
                  aufpl psnfh pzlfh            WITH HEADER LINE.
DATA rserob_tab LIKE rserob OCCURS 0 WITH HEADER LINE.

DATA: lv_first(18) TYPE c,
      lv_last(18)  TYPE c.
TYPES: ty_text_lines1   TYPE TABLE OF tline.
DATA: txt1        TYPE  tline,
      txt2        TYPE string,
      text_lines1 TYPE  ty_text_lines1.
* information related to layout of form
* linesize of long texts
CONSTANTS: linesize_ord   TYPE i VALUE '70',
           linesize_item  TYPE i VALUE '50',
           linesize_rout  TYPE i VALUE '70',
           linesize_seq   TYPE i VALUE '70',
           linesize_opr   TYPE i VALUE '40',
           linesize_sopr  TYPE i VALUE '40',
           linesize_pnote TYPE i VALUE '70',
           linesize_prt   TYPE i VALUE '40',
           linesize_cmp   TYPE i VALUE '54',
           con_max_txlen  TYPE i VALUE '35',
           con_prt_txlen  TYPE i VALUE '25'.
* general signs
CONSTANTS:  con_x(1)       TYPE c VALUE 'X'.

* Heigt of window main (number of lines)
DATA  lines_main(5) TYPE n VALUE 60.
* Space to be reserved for horizontal lines
DATA  n_space TYPE p DECIMALS 2 VALUE '0.5'.
DATA: ls_mard TYPE mard.


PERFORM print_sub.

*----------------------------------------------------------------------
FORM print_sub.

  DATA: subrc LIKE sy-subrc.

* fill data buffer in COPRINT
  PERFORM import_data CHANGING subrc.
  CHECK subrc IS INITIAL.
* reset box position in case of multiple calls
  CLEAR last_line.
* read list/printing info
  PERFORM get_info_list.
* check if SAPscript form was maintained
  IF print_co-forml = space.
    IF sy-batch = space AND sy-binpt = space.
      MESSAGE e298(c2) WITH print_co-lstid
      print_co-auart
      print_co-repid
      print_co-drvar.
    ELSE.
      MESSAGE i298(c2) WITH print_co-lstid
      print_co-auart
      print_co-repid
      print_co-drvar.
    ENDIF.
  ENDIF.
* read order headers
  PERFORM get_orders CHANGING subrc.
  CHECK subrc IS INITIAL.

*-process orders----------
  LOOP AT caufvd_p_tab.
    IF caufvd_p_tab-erdat IS INITIAL.
      MOVE sy-datum TO caufvd_p_tab-erdat.
    ENDIF.
*   fill DDIC structure
    caufvd_p = caufvd_p_tab.
*   read order item
    PERFORM get_item.
    READ TABLE afpod_p_tab INDEX 1.
    afpod_p = afpod_p_tab.
*   read serial number
    PERFORM get_info_serob.
*---loop over number of copies----------
    DO print_co-copys TIMES.
* reset box position in case of multiple printouts
      CLEAR last_line.
      IF sy-index GT 1.
        MOVE TEXT-dup TO print_co-drtxt.
      ENDIF.
*     open and start form
      PERFORM open_form USING 'OBJLST'.
*     print info of order header
      PERFORM print_order.
*     read sequences
      PERFORM get_seq.

*-----process sequences----------
      LOOP AT affld_p_tab.
        affld_p = affld_p_tab.
*       print sequence header
        PERFORM print_sequence.
*       read operation info
        PERFORM get_opr.

*-------process operations---------
        LOOP AT afvgd_p_tab.
          afvgd_p = afvgd_p_tab.
*         Clear activity types and standard values if no work center.
          IF afvgd_p-arbid IS INITIAL.
            CLEAR: afvgd_p-lar01,
                   afvgd_p-lar02,
                   afvgd_p-lar03,
                   afvgd_p-lar04,
                   afvgd_p-lar05,
                   afvgd_p-lar06,
                   afvgd_p-vge01,
                   afvgd_p-vgw01,
                   afvgd_p-vge02,
                   afvgd_p-vgw02,
                   afvgd_p-vge03,
                   afvgd_p-vgw03,
                   afvgd_p-vge04,
                   afvgd_p-vgw04,
                   afvgd_p-vge05,
                   afvgd_p-vgw05,
                   afvgd_p-vge06,
                   afvgd_p-vgw06.
          ENDIF.
*         read work center info
          PERFORM get_info_wc.
*         print info for operation
          PERFORM print_operation.

*         read components
          PERFORM get_cmp.
          flg_print_cmp_header = on.
*---------process components----------
          LOOP AT resbd_p_tab.
            REFRESH text_lines1.
            CLEAR txt1.
            resbd_p = resbd_p_tab.
            n_cmp = sy-tabix.
*           read material view
            PERFORM get_info_cmp.
*           print material info
            PERFORM print_component.
          ENDLOOP.   "resbd_p_tab

*         read production resources
          PERFORM get_prt.
          flg_print_prt_header = on.
*---------process production resources-----
          LOOP AT affhd_p_tab.
            affhd_p = affhd_p_tab.
            n_prt = sy-tabix.
*           print production resource info
            PERFORM print_prt.
          ENDLOOP.   "affhd_p_tab

*         read sub-operations
          PERFORM get_sop.
          flg_print_sop_header = on.
*---------process sub-operations----------
          LOOP AT safvgd_p_tab.
            afvgd_p = safvgd_p_tab.
*           Clear activity types and standard values if no work center.
            IF afvgd_p-arbid IS INITIAL.
              CLEAR: afvgd_p-lar01,
                     afvgd_p-lar02,
                     afvgd_p-lar03,
                     afvgd_p-lar04,
                     afvgd_p-lar05,
                     afvgd_p-lar06,
                     afvgd_p-vge01,
                     afvgd_p-vgw01,
                     afvgd_p-vge02,
                     afvgd_p-vgw02,
                     afvgd_p-vge03,
                     afvgd_p-vgw03,
                     afvgd_p-vge04,
                     afvgd_p-vgw04,
                     afvgd_p-vge05,
                     afvgd_p-vgw05,
                     afvgd_p-vge06,
                     afvgd_p-vgw06.
            ENDIF.
            n_sop = sy-tabix.
*           print sub-operations info
            PERFORM print_sub_opr.
          ENDLOOP.   "safvgd_p_tab

        ENDLOOP.  " afvgd_p_tab

      ENDLOOP.   " affld_p_tab

*     close and end form
      PERFORM close_form.

    ENDDO.   "print_co-copys

  ENDLOOP.   " caufvd_p_tab

ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  PRINT_ORDER_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_order.

* print header
* header info is contained in windows of type 'VAR'

* print barcode?
  IF NOT print_co-barco IS INITIAL.
    PERFORM print_barcode.
  ENDIF.
* collective order info
  PERFORM print_col_ord_info.
* serial numbers
  PERFORM print_serialnum.
* print long text
  PERFORM print_ord_text.
* print configuration
  PERFORM print_configuration.
* print production note
  PERFORM print_prod_note.
* print routing text
  PERFORM print_routing_text.

ENDFORM.                    " PRINT_ORDER
*&---------------------------------------------------------------------*
*&      Form  IMPORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM import_data CHANGING subrc LIKE sy-subrc.

  CALL FUNCTION 'CO_PRINT_IMPORT_DATA'
    EXCEPTIONS
      memory_id_ppt_not_exist = 1
      memory_id_ppi_not_exist = 2
      memory_id_pps_not_exist = 3
      OTHERS                  = 4.
  subrc = sy-subrc.


ENDFORM.                    " IMPORT_DATA

*&---------------------------------------------------------------------*
*&      Form  GET_ORDERS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_orders
     CHANGING subrc   TYPE sy-subrc.

  CLEAR subrc.
  CALL FUNCTION 'CO_PRINT_GET_ORD'
    EXPORTING
      aufnr_imp        = print_co-aufnr
      flg_prtbl_opr    = on
      flg_prtbl_sop    = on
      flg_prtbl_cmp    = on
      flg_prtbl_prt    = on
    CHANGING
      caufvd_p_tab_exp = caufvd_p_tab[]
    EXCEPTIONS
      entry_not_found  = 1
      OTHERS           = 2.
  subrc = sy-subrc.

ENDFORM.                    " GET_ORDERS
*&---------------------------------------------------------------------*
*&      Form  GET_INFO_LIST
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_info_list.

  CALL FUNCTION 'CO_PRINT_GET_INFO_LIST'
    IMPORTING
      print_co_exp   = print_co
      print_opts_exp = print_opts
    EXCEPTIONS
      OTHERS         = 0.

* print-type
  CASE print_co-drart.
    WHEN reprint.
      MOVE TEXT-dup TO print_co-drtxt.
    WHEN OTHERS.
      MOVE TEXT-org TO print_co-drtxt.
  ENDCASE.

ENDFORM.                    " GET_INFO_LIST
*&---------------------------------------------------------------------*
*&      Form  GET_POS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_item.

  CALL FUNCTION 'CO_PRINT_GET_ITEM'
    EXPORTING
      caufvd_p_imp    = caufvd_p
      posnr_imp       = '0001'
    CHANGING
      afpod_p_tab_exp = afpod_p_tab[]
    EXCEPTIONS
      entry_not_found = 1
      OTHERS          = 2.

ENDFORM.                    " GET_item
*&---------------------------------------------------------------------*
*&      Form  GET_SEQ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_seq.

  CALL FUNCTION 'CO_PRINT_GET_SEQ'
    EXPORTING
      caufvd_p_imp    = caufvd_p
*     AFVGD_P_IMP     =
*     RESBD_P_IMP     =
*     AFFHD_P_IMP     =
*     FLG_NO_REFRESH  =
      flg_prtbl_opr   = on
      flg_prtbl_sop   = on
      flg_prtbl_cmp   = on
      flg_prtbl_prt   = on
    CHANGING
      affld_p_tab_exp = affld_p_tab[]
    EXCEPTIONS
      entry_not_found = 1
      too_many_params = 2
      OTHERS          = 3.

ENDFORM.                    " GET_SEQ

*&---------------------------------------------------------------------*
*&      Form  PRINT_SEQUENCE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_sequence.

  DATA  ltxt_lines LIKE tline OCCURS 0 WITH HEADER LINE.

* check if there is enough space
  lines_left = lines_main - last_line.
  PERFORM get_seq_text TABLES ltxt_lines.
  DESCRIBE TABLE ltxt_lines LINES n_lines.                 " long text
  IF n_lines < 1.
    IF NOT affld_p-ltxa1 IS INITIAL.                       " short text
      ADD 2 TO n_lines.
    ENDIF.
  ENDIF.
  ADD 3 TO n_lines. ADD n_space TO n_lines.                " seq title
  IF lines_left < n_lines.  PERFORM new_page.  ENDIF.
* space
  IF last_line > 1.                   " not at top of the page!
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'EMPTY_LINE'
        window  = 'MAIN'.
    ADD 1 TO last_line.
  ENDIF.
* sequence header
  MOVE 1 TO lines_printed.
  ADD n_space TO lines_printed.
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'TITLE_SEQ'
      window  = 'MAIN'.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_SPACE'
      window  = 'MAIN'.
  ADD lines_printed TO last_line.
* sequence data
  MOVE 2 TO lines_printed.
  ADD n_space TO lines_printed.
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'DATA_SEQ'
      window  = 'MAIN'.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_SPACE'
      window  = 'MAIN'.
  ADD lines_printed TO last_line.

* sequence text
  PERFORM print_seq_text TABLES ltxt_lines.

ENDFORM.                    " PRINT_SEQUENCE
*&---------------------------------------------------------------------*
*&      Form  PRINT_OPERATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_operation.

  DATA:  ltxt_lines  LIKE tline OCCURS 0 WITH HEADER LINE.

* check if there is enough space
  lines_left = lines_main - last_line.
  PERFORM get_operation_text TABLES ltxt_lines USING linesize_opr.
  n_lines = 4 + n_space.
  IF lines_left < n_lines.  PERFORM new_page.  ENDIF.
* operation header
  MOVE 1 TO lines_printed. ADD n_space TO lines_printed.
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'TITLE_OPR'
      window  = 'MAIN'.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_SPACE'
      window  = 'MAIN'.
  ADD lines_printed TO last_line.
* operation data
  MOVE afvgd_p-ltxa1 TO tline-tdline.
  IF NOT afvgd_p-txtsp IS INITIAL.
    READ TABLE ltxt_lines INDEX 1 INTO tline-tdline.
  ENDIF.
  lines_printed = 2.
  lines_left = lines_main - last_line - 2.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'DATA_OPR'
      window  = 'MAIN'.
* operation text
  LOOP AT ltxt_lines FROM 2.
    tline-tdline = ltxt_lines-tdline.
    SUBTRACT 1 FROM lines_left.
    IF lines_left <= 0.
* print frame.
      ADD n_space TO lines_printed.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_SPACE'
          window  = 'MAIN'.
      PERFORM position_frame CHANGING psfc_frame.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_OPR'
          window  = 'MAIN'.
      ADD lines_printed TO last_line.
      PERFORM new_page.
* operation header
      MOVE 1 TO lines_printed. ADD n_space TO lines_printed.
      PERFORM position_frame CHANGING psfc_frame.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'TITLE_OPR'
          window  = 'MAIN'.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_SPACE'
          window  = 'MAIN'.
      ADD lines_printed TO last_line.
      lines_left = lines_main - last_line - 1.
      CLEAR lines_printed.
    ENDIF.
    ADD 1 TO lines_printed.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'LTXT_OPR'
        window  = 'MAIN'.
  ENDLOOP.
* print frame.
  ADD n_space TO lines_printed.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_SPACE'
      window  = 'MAIN'.
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_OPR'
      window  = 'MAIN'.
  ADD lines_printed TO last_line.
ENDFORM.                    " PRINT_OPERATION
*&---------------------------------------------------------------------*
*&      Form  GET_SOP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_sop.

  CALL FUNCTION 'CO_PRINT_GET_SOP'
    EXPORTING
*     CAUFVD_P_IMP     =
*     AFFLD_P_IMP      =
      afvgd_p_imp      = afvgd_p_tab
*     FLG_NO_REFRESH   =
      flg_chk_cntrlkey = print_co-psteu
    CHANGING
      safvgd_p_tab_exp = safvgd_p_tab[]
    EXCEPTIONS
      entry_not_found  = 1
      too_many_params  = 2
      OTHERS           = 3.

ENDFORM.                    " GET_SOP
*&---------------------------------------------------------------------*
*&      Form  PRINT_SUB_OPR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_sub_opr.

  DATA  ltxt_lines LIKE tline OCCURS 0 WITH HEADER LINE.

* check if there is enough space
  lines_left = lines_main - last_line.
  PERFORM get_operation_text TABLES ltxt_lines USING linesize_sopr.
  DESCRIBE TABLE ltxt_lines LINES n_lines.
  IF NOT flg_print_sop_header IS INITIAL.
    ADD 2 TO n_lines. ADD n_space TO n_lines.
  ENDIF.
  ADD 1 TO n_lines. ADD n_space TO n_lines.
  IF lines_left < n_lines.
    PERFORM new_page.
    flg_print_sop_header = on.
  ENDIF.

* sop header to be printed?
  IF NOT flg_print_sop_header IS INITIAL.
    CLEAR flg_print_sop_header.
    PERFORM print_lst_header USING 'SOP'.
  ENDIF.
* write data
  last_object_printed = obj-sop.
  MOVE 1 TO lines_printed.
  MOVE afvgd_p-ltxa1 TO tline-tdline.
  IF NOT afvgd_p-txtsp IS INITIAL.
    READ TABLE ltxt_lines INDEX 1 INTO tline-tdline.
  ENDIF.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'DATA_SOP'
      window  = 'MAIN'.
* suboperation text
  LOOP AT ltxt_lines FROM 2.
    tline-tdline = ltxt_lines-tdline.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'LTXT_SOP'
        window  = 'MAIN'.
    ADD 1 TO lines_printed.
  ENDLOOP.

* last entry ? -> insert space
  DESCRIBE TABLE safvgd_p_tab LINES sy-dbcnt.
  IF sy-dbcnt = n_sop.
    ADD n_space TO lines_printed.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    CLEAR last_object_printed.
  ENDIF.
* frame
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_SOP'
      window  = 'MAIN'.
  ADD lines_printed TO last_line.

ENDFORM.                    " PRINT_SUB_OPR
*&---------------------------------------------------------------------*
*&      Form  GET_CMP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_cmp.

  CALL FUNCTION 'CO_PRINT_GET_CMP'
    EXPORTING
*     CAUFVD_P_IMP    =
*     AFFLD_P_IMP     =
      afvgd_p_imp     = afvgd_p
*     FLG_NO_REFRESH  =
    CHANGING
      resbd_p_tab_exp = resbd_p_tab[]
    EXCEPTIONS
      entry_not_found = 1
      too_many_params = 2
      OTHERS          = 3.

ENDFORM.                    " GET_CMP
*&---------------------------------------------------------------------*
*&      Form  PRINT_COMPONENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_component.

  DATA:  ltxt_lines LIKE tline OCCURS 0 WITH HEADER LINE.

  DATA: ls_resbd_p       TYPE resbd_p,
        l_maktx          TYPE msfcv-maktx,
        l_split_cmp_data TYPE flag.

* check if there is enough space
  lines_left = lines_main - last_line.
  PERFORM get_cmp_text TABLES ltxt_lines.
  CLEAR n_lines.
  IF NOT flg_print_cmp_header IS INITIAL.
    ADD 2 TO n_lines. "ADD n_space TO n_lines.
  ENDIF.
  IF strlen( msfcv-maktx ) > con_max_txlen.
*   split component data into 2 rows
    l_split_cmp_data = con_x.
    ADD 1 TO n_lines.
  ENDIF.
  "ADD 1 TO n_lines. "ADD n_space TO n_lines.
  IF lines_left < n_lines.
    PERFORM new_page.
    flg_print_cmp_header = on.
  ENDIF.

  PERFORM get_material_text USING resbd_p_tab-matnr.

* component header to be printed?
  IF NOT flg_print_cmp_header IS INITIAL.
    CLEAR flg_print_cmp_header.
    PERFORM print_lst_header USING 'CMP'.
  ENDIF.
* write data
  last_object_printed = obj-mat.
  MOVE 1 TO lines_printed.
  lines_left = lines_main - last_line - 1.

  CLEAR ls_mard.
  SELECT SINGLE * FROM mard INTO ls_mard
    WHERE matnr = resbd_p-matnr
      AND werks = resbd_p-werks
      AND lgort = resbd_p-lgort.


  IF l_split_cmp_data <> space.
**   split component data into 2 rows
*    CALL FUNCTION 'WRITE_FORM'
*      EXPORTING
*        element = 'DATA_CMP1'
*        window  = 'MAIN'.
**   write second line of component data
*    ADD 1 TO lines_printed.
*    lines_left = lines_main - last_line - 2.
**   copy resbd_p into local structure
*    ls_resbd_p = resbd_p.
*    CLEAR resbd_p.
**   copy material short text into local parameter
*    l_maktx = msfcv-maktx.
*    CLEAR msfcv-maktx.
*    resbd_p-bdmng = ls_resbd_p-bdmng.
*    resbd_p-meins = ls_resbd_p-meins.
*    resbd_p-bdter = ls_resbd_p-bdter.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'DATA_CMP'
        window  = 'MAIN'.
**   recopy resbd_p from local structure
*    resbd_p = ls_resbd_p.
**   recopy material short text from local parameter
*    msfcv-maktx = l_maktx.
*    CLEAR l_split_cmp_data.
  ELSE.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'DATA_CMP'
        window  = 'MAIN'.
  ENDIF.
* component text
  LOOP AT ltxt_lines.
    tline-tdline = ltxt_lines-tdline.
    SUBTRACT 1 FROM lines_left.
    IF lines_left <= 0.
* print frame.
*      ADD n_space TO lines_printed.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_SPACE'
          window  = 'MAIN'.
      PERFORM position_frame CHANGING psfc_frame.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_CMP'
          window  = 'MAIN'.
      ADD lines_printed TO last_line.
      PERFORM new_page.
      PERFORM print_lst_header USING 'CMP'.
      lines_left = lines_main - last_line - 1.
      CLEAR lines_printed.
    ENDIF.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'LTXT_CMP'
        window  = 'MAIN'.
    ADD 1 TO lines_printed.
  ENDLOOP.

  LOOP AT text_lines1 INTO txt1.
    SUBTRACT 1 FROM lines_left.
    IF lines_left <= 0.
* print frame.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_SPACE'
          window  = 'MAIN'.
      PERFORM position_frame CHANGING psfc_frame.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_CMP'
          window  = 'MAIN'.
      ADD lines_printed TO last_line.
      PERFORM new_page.
      PERFORM print_lst_header USING 'CMP'.
      lines_left = lines_main - last_line - 1.
      CLEAR lines_printed.
    ENDIF.

    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'DATA_CMP_TEXT'
        window  = 'MAIN'.
    ADD 1 TO lines_printed.
  ENDLOOP.
  ADD 1 TO lines_printed.
  DESCRIBE TABLE resbd_p_tab LINES sy-dbcnt.
  IF sy-dbcnt = n_cmp.
*    ADD n_space TO lines_printed.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    CLEAR last_object_printed.
  ENDIF.
* frame
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_CMP'
      window  = 'MAIN'.
  ADD lines_printed TO last_line.
  "ADD n_space TO lines_printed.
  "lines_left = lines_left - n_space.
ENDFORM.                    " PRINT_COMPONENT
*&---------------------------------------------------------------------*
*&      Form  GET_OPR
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_opr.

  CALL FUNCTION 'CO_PRINT_GET_OPR'
    EXPORTING
*     CAUFVD_P_IMP    =
      affld_p_imp     = affld_p
*     SAFVGD_P_IMP    =
*     RESBD_P_IMP     =
*     AFFHD_P_IMP     =
*     FLG_NO_REFRESH  =
      flg_chk_ctrlkey = print_co-psteu
*     FLG_PRTBL_SOP   =
*     FLG_PRTBL_CMP   =
*     FLG_PRTBL_PRT   =
    CHANGING
      afvgd_p_tab_exp = afvgd_p_tab[]
    EXCEPTIONS
      entry_not_found = 1
      too_many_params = 2
      OTHERS          = 3.

ENDFORM.                    " GET_OPR
*&---------------------------------------------------------------------*
*&      Form  GET_PRT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_prt.

  CALL FUNCTION 'CO_PRINT_GET_PRT'
    EXPORTING
*     CAUFVD_P_IMP    =
*     AFFLD_P_IMP     =
      afvgd_p_imp     = afvgd_p
*     FLG_NO_REFRESH  =
    CHANGING
      affhd_p_tab_exp = affhd_p_tab[]
    EXCEPTIONS
      entry_not_found = 1
      too_many_params = 2
      OTHERS          = 3.


ENDFORM.                    " GET_PRT
*&---------------------------------------------------------------------*
*&      Form  PRINT_PRT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_prt.

  DATA  ltxt_lines LIKE tline OCCURS 0 WITH HEADER LINE.
  DATA: ls_affhd_p       TYPE affhd_p,
        l_split_prt_data TYPE flag,
        li_prtlen        TYPE i.

* check if there is enough space
  lines_left = lines_main - last_line.
  PERFORM get_prt_text TABLES ltxt_lines.
  DESCRIBE TABLE ltxt_lines LINES n_lines.
  IF NOT flg_print_prt_header IS INITIAL.
    ADD 2 TO n_lines. ADD n_space TO n_lines.
  ENDIF.
  li_prtlen = strlen( affhd_p-fhktx ).
  IF li_prtlen > con_prt_txlen.
*   split prt data into 2 rows
    l_split_prt_data = con_x.
    ADD 1 TO n_lines.
  ENDIF.
  ADD 1 TO n_lines. ADD n_space TO n_lines.
  IF lines_left < n_lines.
    PERFORM new_page.
    flg_print_prt_header = on.
  ENDIF.

* prt header to be printed?
  IF NOT flg_print_prt_header IS INITIAL.
    CLEAR flg_print_prt_header.
    PERFORM print_lst_header USING 'PRT'.
  ENDIF.
* write data
  last_object_printed = obj-fhm.
  MOVE 1 TO lines_printed.
  IF l_split_prt_data <> space.
*   copy affhd_p into local structure
    ls_affhd_p = affhd_p.
    affhd_p-fhktx = affhd_p-fhktx(con_prt_txlen).
*   split prt data into 2 rows
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'DATA_PRT1'
        window  = 'MAIN'.
*   write second line of component data
    ADD 1 TO lines_printed.
    CLEAR affhd_p.
    affhd_p-fhktx   = ls_affhd_p-fhktx+con_prt_txlen.
    affhd_p-mgsol   = ls_affhd_p-mgsol.
    affhd_p-mgsoleh = ls_affhd_p-mgsoleh.
    affhd_p-ssfhd   = ls_affhd_p-ssfhd.
    affhd_p-sefhd   = ls_affhd_p-sefhd.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'DATA_PRT2'
        window  = 'MAIN'.
    affhd_p = ls_affhd_p.
    CLEAR l_split_prt_data.
  ELSE.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'DATA_PRT'
        window  = 'MAIN'.
  ENDIF.
* print text
  LOOP AT ltxt_lines.
    tline-tdline = ltxt_lines-tdline.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'LTXT_PRT'
        window  = 'MAIN'.
    ADD 1 TO lines_printed.
  ENDLOOP.

* last entry? -> insert space
  DESCRIBE TABLE affhd_p_tab LINES sy-dbcnt.
  IF sy-dbcnt = n_prt.
    ADD n_space TO lines_printed.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    CLEAR last_object_printed.
  ENDIF.
* draw frame
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_PRT'
      window  = 'MAIN'.
  ADD lines_printed TO last_line.


ENDFORM.                    " PRINT_PRT
*&---------------------------------------------------------------------*
*&      Form  OPEN_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0175   text                                                *
*----------------------------------------------------------------------*
FORM open_form USING startpage.

  CALL FUNCTION 'OPEN_FORM'
    EXPORTING
      device   = 'PRINTER'
      dialog   = space
      form     = print_co-forml
      language = print_co-spras
      options  = print_opts
    EXCEPTIONS
      canceled = 01
      device   = 02
      form     = 03
      options  = 04
      unclosed = 05.
  CALL FUNCTION 'START_FORM'
    EXPORTING
      startpage = startpage.

* reset counter for page numbers
  print_co-actpage = 1.

ENDFORM.                    " OPEN_FORM
*&---------------------------------------------------------------------*
*&      Form  CLOSE_FORM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM close_form.

* close actual page with a horizontal line
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'HORIZ_LINE'
      window  = 'MAIN'.
* close form
  CALL FUNCTION 'END_FORM'.
  CALL FUNCTION 'CLOSE_FORM'
    IMPORTING
      result = pr_result
    EXCEPTIONS
      OTHERS = 01.

ENDFORM.                    " CLOSE_FORM
*&---------------------------------------------------------------------*
*&      Form  PRINT_ORD_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_ord_text.

  DATA: ltxt_lines   LIKE tline OCCURS 0 WITH HEADER LINE,
        l_print_text TYPE p DECIMALS 2.

  CLEAR lines_printed.

* try to read long text
  IF NOT caufvd_p-ltext IS INITIAL.
    CALL FUNCTION 'CO_PRINT_GET_LTXT_ORD'
      EXPORTING
        caufvd_p_imp       = caufvd_p
        flg_table          = on
        lwidth             = linesize_ord
      IMPORTING
        ltxt_key_exp       = ltxt_key
      TABLES
        ltxt_lines_exp     = ltxt_lines
      EXCEPTIONS
        no_long_text       = 1
        error_reading_ltxt = 2
        OTHERS             = 3.
  ENDIF.

  IF NOT caufvd_p-ltext IS INITIAL OR NOT caufvd_p-ktext IS INITIAL.
*   check if there is enough space
    lines_left = lines_main - last_line.
    DESCRIBE TABLE ltxt_lines LINES n_lines. ADD 1 TO n_lines.
    IF n_lines < 2. MOVE 2 TO n_lines. ENDIF.
    ADD n_space TO n_lines.
*   reduce remaing lines for the textelement FRAME_SPACE
    SUBTRACT n_space FROM lines_left.
    IF lines_left < 2.
      PERFORM new_page.
      PERFORM horiz_line.
      lines_left = lines_main - last_line.
      SUBTRACT n_space FROM lines_left.
    ENDIF.
*   write title
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'TITLE_LTXT_HEAD'
        window  = 'MAIN'.
    ADD 1 TO lines_printed.
    SUBTRACT 1 FROM lines_left.
    ADD n_space TO l_print_text.
*   print long text?
    IF NOT caufvd_p-ltext IS INITIAL.
      LOOP AT ltxt_lines.
        IF lines_left < 1 AND l_print_text < n_lines.
*         print frame
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'FRAME_SPACE'
              window  = 'MAIN'.
          ADD n_space TO lines_printed.
          PERFORM position_frame CHANGING psfc_frame.
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element  = 'FRAME_TXT_HEAD'
              function = 'SET'
              window   = 'MAIN'.
          ADD lines_printed TO last_line.
          PERFORM new_page.
          PERFORM horiz_line.
          CLEAR lines_printed.
          lines_left = lines_main - last_line.
          SUBTRACT n_space FROM lines_left.
*         title
          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'TITLE_LTXT_HEAD'
              window  = 'MAIN'.
          ADD 1 TO lines_printed.
          SUBTRACT 1 FROM lines_left.
        ENDIF.
        tline-tdline = ltxt_lines-tdline.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'LTXT_HEAD'
            window  = 'MAIN'.
        ADD 1 TO lines_printed.
        ADD 1 TO l_print_text.
        SUBTRACT 1 FROM lines_left.
      ENDLOOP.
*   short text?
    ELSEIF NOT caufvd_p-ktext IS INITIAL.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'STXT_HEAD'
          window  = 'MAIN'.
      ADD 1 TO lines_printed.
    ENDIF.
*   print frame
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    ADD n_space TO lines_printed.
    PERFORM position_frame CHANGING psfc_frame.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element  = 'FRAME_TXT_HEAD'
        function = 'SET'
        window   = 'MAIN'.
    ADD lines_printed TO last_line.

  ENDIF.

ENDFORM.                    " PRINT_ORD_TEXT

*&---------------------------------------------------------------------*
*&      Form  PRINT_CONFIGURATION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_configuration.

  DATA: sfc_conf_tab LIKE sfc_conf OCCURS 0 WITH HEADER LINE,
        l_print_conf TYPE p DECIMALS 2.

  CLEAR lines_printed.
* read configuration of order header
  IF NOT afpod_p-cuobj IS INITIAL.
    CALL FUNCTION 'CO_PRINT_GET_INFO_ORD_CONFIG'
      EXPORTING
        caufvd_p_imp     = caufvd_p
      TABLES
        sfc_conf_tab_exp = sfc_conf_tab
      EXCEPTIONS
        no_configuration = 1
        entry_not_found  = 2
        OTHERS           = 3.
*   check if there is enough space
    lines_left = lines_main - last_line.
    DESCRIBE TABLE sfc_conf_tab LINES n_lines.
    ADD n_space TO n_lines.
*   reduce remaing lines for the textelement FRAME_SPACE
    SUBTRACT n_space FROM lines_left.
    IF lines_left < 2.
      PERFORM new_page.
      lines_left = lines_main - last_line.
      SUBTRACT n_space FROM lines_left.
    ENDIF.
*   title
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'TITLE_CONFIG'
        window  = 'MAIN'.
    ADD 1 TO lines_printed.
    SUBTRACT 1 FROM lines_left.
    ADD n_space TO l_print_conf.
*   configuration
    LOOP AT sfc_conf_tab.
      IF lines_left < 1 AND l_print_conf < n_lines.
*       print frame
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'FRAME_SPACE'
            window  = 'MAIN'.
        ADD n_space TO lines_printed.
        PERFORM position_frame CHANGING psfc_frame.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element  = 'FRAME_TXT_HEAD'
            function = 'SET'
            window   = 'MAIN'.
        ADD lines_printed TO last_line.
        PERFORM new_page.
        CLEAR lines_printed.
        lines_left = lines_main - last_line.
        SUBTRACT n_space FROM lines_left.
*       title
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'TITLE_CONFIG'
            window  = 'MAIN'.
        ADD 1 TO lines_printed.
        SUBTRACT 1 FROM lines_left.
      ENDIF.
      sfc_conf = sfc_conf_tab.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'TXT_CONFIG'
          window  = 'MAIN'.
      ADD 1 TO lines_printed.
      ADD 1 TO l_print_conf.
      SUBTRACT 1 FROM lines_left.
    ENDLOOP.
*   print frame
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    ADD n_space TO lines_printed.
    PERFORM position_frame CHANGING psfc_frame.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element  = 'FRAME_TXT_HEAD'
        function = 'SET'
        window   = 'MAIN'.
    ADD lines_printed TO last_line.

  ENDIF.

ENDFORM.                    " PRINT_CONFIGURATION
*&---------------------------------------------------------------------*
*&      Form  PRINT_PROD_NOTE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_prod_note.

  DATA: ltxt_lines   LIKE tline OCCURS 0 WITH HEADER LINE,
        l_print_text TYPE p DECIMALS 2.
  CLEAR lines_printed.

* read production note
  IF NOT afpod_p-kdauf IS INITIAL AND NOT afpod_p-fhwtx IS INITIAL.
    CALL FUNCTION 'CO_PRINT_GET_LTXT_PNOTE'
      EXPORTING
        afpod_p_imp        = afpod_p
        flg_table          = on
        lwidth             = linesize_pnote
      IMPORTING
        ltxt_key_exp       = ltxt_key
      TABLES
        ltxt_lines_exp     = ltxt_lines
      EXCEPTIONS
        no_customer_order  = 1
        no_long_text       = 2
        error_reading_ltxt = 3
        OTHERS             = 4.

*   check if there is enough space
    lines_left = lines_main - last_line.
    DESCRIBE TABLE ltxt_lines LINES n_lines. ADD 1 TO n_lines.
    ADD n_space TO n_lines.
*   reduce remaing lines for the textelement FRAME_SPACE
    SUBTRACT n_space FROM lines_left.
    IF lines_left < 2.
      PERFORM new_page.
      lines_left = lines_main - last_line.
      SUBTRACT n_space FROM lines_left.
    ENDIF.
*   write title
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'TITLE_PNOTE'
        window  = 'MAIN'.
    ADD 1 TO lines_printed.
    SUBTRACT 1 FROM lines_left.
    ADD n_space TO l_print_text.
    LOOP AT ltxt_lines.
      IF lines_left < 1 AND l_print_text < n_lines.
*       print frame
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'FRAME_SPACE'
            window  = 'MAIN'.
        ADD n_space TO lines_printed.
        PERFORM position_frame CHANGING psfc_frame.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element  = 'FRAME_TXT_HEAD'
            function = 'SET'
            window   = 'MAIN'.
        ADD lines_printed TO last_line.
        PERFORM new_page.
        CLEAR lines_printed.
        lines_left = lines_main - last_line.
        SUBTRACT n_space FROM lines_left.
*       title
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'TITLE_PNOTE'
            window  = 'MAIN'.
        ADD 1 TO lines_printed.
        SUBTRACT 1 FROM lines_left.
      ENDIF.
      tline-tdline = ltxt_lines-tdline.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'LTXT_HEAD'
          window  = 'MAIN'.
      ADD 1 TO lines_printed.
      ADD 1 TO l_print_text.
      SUBTRACT 1 FROM lines_left.
    ENDLOOP.
*   print frame
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    ADD n_space TO lines_printed.
    PERFORM position_frame CHANGING psfc_frame.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_TXT_HEAD'
        window  = 'MAIN'.
    ADD lines_printed TO last_line.

  ENDIF.

ENDFORM.                    " PRINT_PROD_NOTE
*&---------------------------------------------------------------------*
*&      Form  PRINT_ROUTING_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_routing_text.

  DATA: ltxt_lines   LIKE tline OCCURS 0 WITH HEADER LINE,
        l_print_text TYPE p DECIMALS 2.
  CLEAR lines_printed.

  CALL FUNCTION 'CO_PRINT_GET_LTXT_ROUT'
    EXPORTING
      caufvd_p_imp       = caufvd_p
      flg_table          = on
      lwidth             = linesize_rout
    IMPORTING
      ltxt_key_exp       = ltxt_key
    TABLES
      ltxt_lines_exp     = ltxt_lines
    EXCEPTIONS
      no_routing         = 1
      no_long_text       = 2
      error_reading_ltxt = 3
      OTHERS             = 4.

  IF sy-subrc = 0.
*   check if there is enough space
    lines_left = lines_main - last_line.
    DESCRIBE TABLE ltxt_lines LINES n_lines. ADD 1 TO n_lines.
    ADD n_space TO n_lines.
*   reduce remaing lines for the textelement FRAME_SPACE
    SUBTRACT n_space FROM lines_left.
    IF lines_left < 2.
      PERFORM new_page.
      lines_left = lines_main - last_line.
      SUBTRACT n_space FROM lines_left.
    ENDIF.
*   write title
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'TITLE_LTXT_ROUT'
        window  = 'MAIN'.
    ADD 1 TO lines_printed.
    SUBTRACT 1 FROM lines_left.
    ADD n_space TO l_print_text.
* write text
    LOOP AT ltxt_lines.
      IF lines_left < 1 AND l_print_text < n_lines.
*       print frame
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'FRAME_SPACE'
            window  = 'MAIN'.
        ADD n_space TO lines_printed.
        PERFORM position_frame CHANGING psfc_frame.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element  = 'FRAME_TXT_HEAD'
            function = 'SET'
            window   = 'MAIN'.
        ADD lines_printed TO last_line.
        PERFORM new_page.
        CLEAR lines_printed.
        lines_left = lines_main - last_line.
        SUBTRACT n_space FROM lines_left.
*       title
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'TITLE_LTXT_ROUT'
            window  = 'MAIN'.
        ADD 1 TO lines_printed.
        SUBTRACT 1 FROM lines_left.
      ENDIF.
      tline-tdline = ltxt_lines-tdline.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'LTXT_HEAD'
          window  = 'MAIN'.
      ADD 1 TO lines_printed.
      ADD 1 TO l_print_text.
      SUBTRACT 1 FROM lines_left.
    ENDLOOP.
*   print frame
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    ADD n_space TO lines_printed.
    PERFORM position_frame CHANGING psfc_frame.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_TXT_HEAD'
        window  = 'MAIN'.
    ADD lines_printed TO last_line.

  ENDIF.

ENDFORM.                    " PRINT_ROUTING_TEXT
*&---------------------------------------------------------------------*
*&      Form  GET_INFO_WC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_info_wc.

  CALL FUNCTION 'CO_PRINT_GET_INFO_WC'
    EXPORTING
      afvgd_p_imp     = afvgd_p
    IMPORTING
      rcr01_exp       = rcr01
    EXCEPTIONS
      no_work_center  = 1
      entry_not_found = 2
      OTHERS          = 3.

ENDFORM.                    " GET_INFO_WC
*&---------------------------------------------------------------------*
*&      Form  GET_CMP_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_cmp_text TABLES ltxt_lines STRUCTURE tline.

* long text
  IF NOT resbd_p-ltxsp IS INITIAL.
    CALL FUNCTION 'CO_PRINT_GET_LTXT_CMP'
      EXPORTING
        resbd_p_imp        = resbd_p
        flg_table          = on
        lwidth             = linesize_cmp
      IMPORTING
        ltxt_key_exp       = ltxt_key
      TABLES
        ltxt_lines_exp     = ltxt_lines
      EXCEPTIONS
        no_long_text       = 1
        error_reading_ltxt = 2
        OTHERS             = 3.
  ENDIF.
* Position text
  IF NOT resbd_p-textkz IS INITIAL AND
         ltxt_lines[] IS INITIAL   AND
     NOT resbd_p-potx1 IS INITIAL.
    ltxt_lines-tdline = resbd_p-potx1.
    APPEND ltxt_lines.
  ENDIF.

ENDFORM.                    " GET_CMP_TEXT
*&---------------------------------------------------------------------*
*&      Form  GET_PRT_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_prt_text TABLES ltxt_lines.

* long text
  IF NOT affhd_p-txtsp IS INITIAL.
    CALL FUNCTION 'CO_PRINT_GET_LTXT_PRT'
      EXPORTING
        affhd_p_imp        = affhd_p
        flg_table          = on
        lwidth             = linesize_prt
      IMPORTING
        ltxt_key_exp       = ltxt_key
      TABLES
        ltxt_lines_exp     = ltxt_lines
      EXCEPTIONS
        no_long_text       = 1
        error_reading_ltxt = 2
        OTHERS             = 3.

  ENDIF.

ENDFORM.                    " GET_PRT_TEXT
*&---------------------------------------------------------------------*
*&      Form  PRINT_OPERATION_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_operation_text TABLES ltxt_lines USING linesize TYPE i.

* long text
  IF NOT afvgd_p-txtsp IS INITIAL.

    CALL FUNCTION 'CO_PRINT_GET_LTXT_OPR'
      EXPORTING
        afvgd_p_imp        = afvgd_p
        flg_table          = on
        lwidth             = linesize_opr
      IMPORTING
        ltxt_key_exp       = ltxt_key
      TABLES
        ltxt_lines_exp     = ltxt_lines
      EXCEPTIONS
        no_long_text       = 1
        error_reading_ltxt = 2
        OTHERS             = 3.

  ENDIF.

ENDFORM.                    " GET_OPERATION_TEXT

*&---------------------------------------------------------------------*
*&      Form  PRINT_SOPERATION_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_soperation_text.

  DATA     ltxt_lines LIKE tline OCCURS 0 WITH HEADER LINE.



ENDFORM.                    " PRINT_SOPERATION_TEXT

*&---------------------------------------------------------------------*
*&      Form  GET_INFO_SEROB
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_info_serob.

  CALL FUNCTION 'CO_PRINT_GET_INFO_SEROB'
    EXPORTING
*     CAUFVD_P_IMP      =
      afpod_p_imp       = afpod_p
    CHANGING
      rserob_tab_exp    = rserob_tab[]
    EXCEPTIONS
      entry_not_found   = 1
      imp_param_missing = 2
      too_many_params   = 3
      OTHERS            = 4.

ENDFORM.                    " GET_INFO_SEROB
*&---------------------------------------------------------------------*
*&      Form  POSITION_FRAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_PSFC_FRAME  text                                           *
*----------------------------------------------------------------------*
FORM position_frame CHANGING p_psfc_frame LIKE psfc_frame.

  DATA line LIKE last_line.

* frame position
  CLEAR psfc_frame-pos.
  line = last_line.       " - n_space * '0.25' .
  IF line < 0.
    p_psfc_frame-pos(1) = '-'.
  ELSE.
    p_psfc_frame-pos(1) = '+'.
  ENDIF.
  line = abs( line ).
  WRITE line TO p_psfc_frame-pos+1(8).
  TRANSLATE p_psfc_frame-pos USING ' 0'.
  TRANSLATE p_psfc_frame-pos USING ',.'.
* frame height
  WRITE lines_printed TO p_psfc_frame-height+1(6).
  TRANSLATE p_psfc_frame-height USING ',.'.

ENDFORM.                    " POSITION_FRAME
*&---------------------------------------------------------------------*
*&      Form  NEW_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM new_page.

* extend vertical lines of last frame if necessary.
  PERFORM extend_vert_lines.

* close actual page with a horizontal line
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'HORIZ_LINE'
      window  = 'MAIN'.
* new page
  CLEAR last_line.
  CALL FUNCTION 'CONTROL_FORM'
    EXPORTING
      command = 'NEW-PAGE'.
* increase counter for page numbers
  ADD 1 TO print_co-actpage.
* space
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'EMPTY_LINE'
      window  = 'MAIN'.
  ADD 1 TO last_line.

ENDFORM.                    " NEW_PAGE
*&---------------------------------------------------------------------*
*&      Form  GET_INFO_CMP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_info_cmp.

  CALL FUNCTION 'CO_PRINT_GET_INFO_MAT'
    EXPORTING
      resbd_p_imp     = resbd_p
    IMPORTING
      msfcv_exp       = msfcv
    EXCEPTIONS
      entry_not_found = 1
      OTHERS          = 2.
  IF sy-subrc <> 0.
    CLEAR msfcv.
  ENDIF.
ENDFORM.                    " GET_INFO_CMP
*&---------------------------------------------------------------------*
*&      Form  PRINT_LST_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_lst_header USING list TYPE c.

  DATA: title(9), header(10).
  WRITE 'TITLE_'  TO title.
  WRITE list      TO title+6(3).
  WRITE 'HEADER_' TO header.
  WRITE list      TO header+7(3).

*   check if there is enough space
  lines_left = lines_main - last_line.
  IF lines_left < 4.  PERFORM new_page.  ENDIF.
*   compnent header
  MOVE 1 TO lines_printed.
  ADD n_space TO lines_printed.
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = title
      window  = 'MAIN'.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_SPACE'
      window  = 'MAIN'.
  ADD lines_printed TO last_line.

  lines_printed = 1.
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = header
      window  = 'MAIN'.
  ADD 1 TO last_line.

ENDFORM.                    " PRINT_PRT_HEADER
*&---------------------------------------------------------------------*
*&      Form  HORIZ_LINE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM horiz_line.

  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'HORIZ_LINE'
      window  = 'MAIN'.

ENDFORM.                    " HORIZ_LINE
*&---------------------------------------------------------------------*
*&      Form  GET_SEQ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_seq_text TABLES ltxt_lines STRUCTURE tline.

* try to read long text
  IF NOT affld_p-txtsp IS INITIAL.
    CALL FUNCTION 'CO_PRINT_GET_LTXT_SEQ'
      EXPORTING
        affld_p_imp        = affld_p
        flg_table          = on
        lwidth             = linesize_seq
      IMPORTING
        ltxt_key_exp       = ltxt_key
      TABLES
        ltxt_lines_exp     = ltxt_lines
      EXCEPTIONS
        no_long_text       = 1
        error_reading_ltxt = 2
        OTHERS             = 3.
  ENDIF.
ENDFORM.                    " GET_SEQ_TEXT
*&---------------------------------------------------------------------*
*&      Form  PRINT_SEQ_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_seq_text TABLES ltxt_lines STRUCTURE tline.

  CLEAR lines_printed.

  IF NOT affld_p-txtsp IS INITIAL OR NOT affld_p-ltxa1 IS INITIAL.
*   check if there is enough space
    lines_left = lines_main - last_line.
    DESCRIBE TABLE ltxt_lines LINES n_lines. ADD 1 TO n_lines.
    IF n_lines < 2. MOVE 2 TO n_lines. ENDIF.
    ADD n_space TO n_lines.
    IF lines_left < n_lines. PERFORM new_page. ENDIF.
*   write title
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'TITLE_LTXT_SEQ'
        window  = 'MAIN'.
    ADD 1 TO lines_printed.
*   print long text?
    IF NOT affld_p-txtsp IS INITIAL.
      LOOP AT ltxt_lines.
        tline-tdline = ltxt_lines-tdline.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'LTXT_HEAD'
            window  = 'MAIN'.
        ADD 1 TO lines_printed.
      ENDLOOP.
*   short text?
    ELSEIF NOT affld_p-ltxa1 IS INITIAL.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'STXT_SEQ'
          window  = 'MAIN'.
      ADD 1 TO lines_printed.
    ENDIF.
*   print frame
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    ADD n_space TO lines_printed.
    PERFORM position_frame CHANGING psfc_frame.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_TXT_HEAD'
        window  = 'MAIN'.
    ADD lines_printed TO last_line.

  ENDIF.

ENDFORM.                    " PRINT_SEQ_TEXT
*&---------------------------------------------------------------------*
*&      Form  PRINT_BARCODE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_barcode.

  MOVE 6 TO lines_printed. ADD n_space TO lines_printed.
  PERFORM position_frame CHANGING psfc_frame.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'TITLE_BC'
      window  = 'MAIN'.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'DATA_BC'
      window  = 'MAIN'.
  CALL FUNCTION 'WRITE_FORM'
    EXPORTING
      element = 'FRAME_SPACE'
      window  = 'MAIN'.
  ADD lines_printed TO last_line.

ENDFORM.                    " PRINT_BARCODE
*&---------------------------------------------------------------------*
*&      Form  PRINT_SERIALNUM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_serialnum.

  DATA ind   LIKE sy-tabix.
  DATA print_header VALUE 'X'.

  DESCRIBE TABLE rserob_tab LINES n_lines.
  IF n_lines <> 0.
*   check if there is enough space
    lines_left = lines_main - last_line.
    MOVE 2 TO n_lines. ADD n_space TO n_lines.
    IF lines_left < n_lines.
      PERFORM new_page.
    ENDIF.
* 3 serial numbers in a row
    DESCRIBE TABLE rserob_tab LINES n_lines. MOVE 1 TO ind.
    WHILE ind <= n_lines.
*     header
      IF NOT print_header IS INITIAL.
        READ TABLE rserob_tab INDEX 1.
        IF sy-subrc = 0.
          lv_first = rserob_tab-sernr.
          lv_last = lv_first + n_lines - 1.

          SHIFT lv_first LEFT DELETING LEADING '0'.
          CONDENSE lv_last.

          CALL FUNCTION 'WRITE_FORM'
            EXPORTING
              element = 'TITLE_SERIAL'
              window  = 'MAIN'.
          MOVE 1 TO lines_printed.
          CLEAR print_header.
          EXIT.
        ENDIF.
      ENDIF.
*     fill line
      CLEAR tline.
***      DO.
***        IF ind > n_lines. EXIT. ENDIF.
***        READ TABLE rserob_tab INDEX ind.
****      READ TABLE rserob_tab INDEX 1.
****        if sy-subrc = 0.
****        lv_first = rserob_tab-sernr.
****        lv_last = lv_first + n_lines.
****        condense lv_first.
****        condense lv_last.


***        ADD 1 TO ind.
***        CASE sy-index.
***          WHEN 1. WRITE rserob_tab-sernr TO tline-tdline+1(18).
***          WHEN 2. WRITE rserob_tab-sernr TO tline-tdline+25(18).
***          WHEN 3. WRITE rserob_tab-sernr TO tline-tdline+50(18).
***        ENDCASE.
****       endif.
***        IF sy-index = 3. EXIT. ENDIF.
***      ENDDO.
***      CALL FUNCTION 'WRITE_FORM'
***          EXPORTING
***                element  = 'TXT_SERIAL'
***                window   = 'MAIN'.
***      ADD 1 TO lines_printed.
*     last entry of page?
      lines_left = lines_main - ( last_line + lines_printed + n_space ).
      IF lines_left < 1.
        ADD n_space TO lines_printed.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element = 'FRAME_SPACE'
            window  = 'MAIN'.
        PERFORM position_frame CHANGING psfc_frame.
        CALL FUNCTION 'WRITE_FORM'
          EXPORTING
            element  = 'FRAME_TXT_HEAD'
            function = 'SET'
            window   = 'MAIN'.
        ADD lines_printed TO last_line.
        PERFORM new_page.
        MOVE 'X' TO print_header.
      ENDIF.

    ENDWHILE.
*   frame
    ADD n_space TO lines_printed.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    PERFORM position_frame CHANGING psfc_frame.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element  = 'FRAME_TXT_HEAD'
        function = 'SET'
        window   = 'MAIN'.
    ADD lines_printed TO last_line.

  ENDIF.

ENDFORM.                    " PRINT_SERIALNUM
*&---------------------------------------------------------------------*
*&      Form  PRINT_COL_ORD_INFO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_col_ord_info.

  IF caufvd_p-prodnet NE space.
    MOVE 1 TO lines_printed.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'TITLE_COL_ORD'
        window  = 'MAIN'.

*   leading order
    IF caufvd_p-maufnr EQ space.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'TXT_COL_ROOT'
          window  = 'MAIN'.
      ADD 1 TO lines_printed.

    ELSE.
      CALL FUNCTION 'CO_PRINT_GET_INFO_COL_ORD'
        EXPORTING
          caufvd_p_imp    = caufvd_p
        IMPORTING
          ppprcolord_exp  = ppprcolord
        EXCEPTIONS
          no_col_order    = 1
          entry_not_found = 2
          OTHERS          = 3.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'TXT_COL_DEP'
          window  = 'MAIN'.
      ADD 3 TO lines_printed.

    ENDIF.

    ADD n_space TO lines_printed.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_SPACE'
        window  = 'MAIN'.
    PERFORM position_frame CHANGING psfc_frame.
    CALL FUNCTION 'WRITE_FORM'
      EXPORTING
        element = 'FRAME_TXT_HEAD'
        window  = 'MAIN'.
    ADD lines_printed TO last_line.

  ENDIF.

ENDFORM.                    " PRINT_COL_ORD_INFO
*&---------------------------------------------------------------------*
*&      Form  EXTEND_VERT_LINES
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM extend_vert_lines.

* Sorry, this is not nice and not easy to understand but
* necessary to avoid that the closing horizontal line
* cuts through the last text line when the new-page occurs
* in the middle of a list of components, production resources
* or sub-operations.

  CASE last_object_printed.
    WHEN obj-sop.                       "sub-operation
      MOVE n_space TO lines_printed.
      PERFORM position_frame CHANGING psfc_frame.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_SOP'
          window  = 'MAIN'.
      ADD lines_printed TO last_line.
    WHEN obj-mat.                       "material component
      MOVE n_space TO lines_printed.
      PERFORM position_frame CHANGING psfc_frame.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_CMP'
          window  = 'MAIN'.
      ADD lines_printed TO last_line.
    WHEN obj-fhm.                       "production resource
      MOVE n_space TO lines_printed.
      PERFORM position_frame CHANGING psfc_frame.
      CALL FUNCTION 'WRITE_FORM'
        EXPORTING
          element = 'FRAME_PRT'
          window  = 'MAIN'.
      ADD lines_printed TO last_line.
    WHEN OTHERS.
      PERFORM position_frame CHANGING psfc_frame.
  ENDCASE.

  CLEAR last_object_printed.

ENDFORM.                    " EXTEND_VERT_LINES
*&---------------------------------------------------------------------*
*&      Form  GET_MATERIAL_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LTD_LINES  text
*----------------------------------------------------------------------*
FORM get_material_text  USING matnr1 TYPE matnr .

  DATA:      objname       TYPE          tdobname.
  objname = matnr1.
  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                  = SY-MANDT
      id                      = 'GRUN'
      language                = 'E'
      name                    = objname
      object                  = 'MATERIAL'
*     ARCHIVE_HANDLE          = 0
*     LOCAL_CAT               = ' '
*   IMPORTING
*     HEADER                  =
    TABLES
      lines                   = text_lines1
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
ENDFORM.                    " GET_MATERIAL_TEXT
