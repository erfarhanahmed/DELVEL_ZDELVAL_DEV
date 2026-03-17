*----------------------------------------------------------------------*
* PDF Form CONVERSION FOR: PSFC_OBJECT_LIST_PDF

* Author:Satyanarayana P V V ,C-User:C5056725
*
* Date# : 20.08.2004
*
* Program description: PP Object list  Modified print program for
*                      to display in PDF.

*----------------------------------------------------------------------*
*Modified PSFC_OBJECT_LIST_PDF for use with Smartform
*----------------------------------------------------------------------*
REPORT psfc_object_list.

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
           con_max_txlen  TYPE i VALUE '35'.
* general signs
CONSTANTS:  con_x(1)       TYPE c VALUE 'X'.

* Heigt of window main (number of lines)
DATA  lines_main(5) TYPE n VALUE 60.
* Space to be reserved for horizontal lines
DATA  n_space TYPE p DECIMALS 2 VALUE '0.5'.

*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*

CONSTANTS: gc_type_seq TYPE c VALUE 'X', "Type for sequence
           gc_type_opr TYPE c VALUE 'A', "Type for Operation
           gc_type_com TYPE c VALUE 'C', "Type for components
           gc_type_pro TYPE c VALUE 'P', "Type for production reso
           gc_type_sub TYPE c VALUE 'S'. "Type for sub operations

*Data to execute pdf
DATA: gv_fp_outputparams TYPE sfpoutputparams, " Output parameters
      gv_interface_type  TYPE fpinterfacetype, " interface name
      gv_w_cx_root       TYPE REF TO cx_root,  " Exception class
      gv_mesg            TYPE string,          " for handling messages
      gv_fm_name         TYPE rs38l_fnam,      " Function Name
      gv_fpformoutput    TYPE fpformoutput,    " Form Output
      gi_err             TYPE i VALUE 0.

DATA: gv_first_write_form TYPE i,
      gv_seq_counter      TYPE i VALUE  1, "counter for seq
      gv_oper_counter     TYPE i VALUE  1, "counter for operations
      gv_comp_counter     TYPE i VALUE  1, "counter for components
      gv_res_counter      TYPE i VALUE  1, "counter for resource
      gv_sopr_counter     TYPE i VALUE  1. "counter for suboperations

* Declaration of structures and Internal table for PDF

DATA: gs_caufvd_p       TYPE caufvd_p,
      gs_print_co       TYPE print_co,
      gs_ppprcolord     TYPE ppprcolord,

      gt_sfc_conf       TYPE STANDARD TABLE OF sfc_conf,
      gs_sfc_conf       TYPE sfc_conf,

      gt_affld_p        TYPE STANDARD TABLE OF ppsfc_object_affld_p_pdf,
      gs_affld_p        TYPE ppsfc_object_affld_p_pdf,

      gt_afvgd_p        TYPE STANDARD TABLE OF ppsfc_object_afvgd_p_pdf,
      gs_afvgd_p        TYPE ppsfc_object_afvgd_p_pdf,

      gt_resbd_p        TYPE STANDARD TABLE OF ppsfc_object_resbd_p_pdf,
      gs_resbd_p        TYPE ppsfc_object_resbd_p_pdf,

      gt_affhd_p        TYPE STANDARD TABLE OF ppsfc_object_affhd_p_pdf,
      gs_affhd_p        TYPE ppsfc_object_affhd_p_pdf,

      gt_subopr         TYPE STANDARD TABLE OF  ppsfc_object_subopr_pdf,
      gs_subopr         TYPE ppsfc_object_subopr_pdf,

      gt_ltext          TYPE STANDARD TABLE OF  ppsfc_object_ltext_s_pdf,
      gs_ltext          TYPE ppsfc_object_ltext_s_pdf,

      gt_tdline         TYPE STANDARD TABLE OF  ppsfc_object_tdline_pdf,
      gs_tdline         TYPE ppsfc_object_tdline_pdf,

      gt_serial_numbers TYPE STANDARD TABLE OF  ppsfc_object_ltext_s_pdf,
      gs_serial_numbers TYPE ppsfc_object_ltext_s_pdf.



*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*

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
* read order headers
  PERFORM get_orders CHANGING subrc.
  CHECK subrc IS INITIAL.

*-process orders----------
  LOOP AT caufvd_p_tab.
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
* Refresh interface tables of PDF Form.
* Components list.
      CLEAR gt_resbd_p.
      REFRESH gt_resbd_p.
* Long Texts.
      CLEAR gt_ltext.
      REFRESH gt_ltext.
* Operations.
      CLEAR gt_afvgd_p.
      REFRESH gt_afvgd_p.
* Sub operations.
      CLEAR gt_subopr.
      REFRESH gt_subopr.
* Sequences.
      CLEAR gt_affld_p.
      REFRESH gt_affld_p.
* reset box position in case of multiple printouts
      CLEAR last_line.
      IF sy-index GT 1.
        MOVE TEXT-dup TO print_co-drtxt.
      ENDIF.
*   open pdf form
      PERFORM open_form.

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
*         read work center info
          PERFORM get_info_wc.
*         print info for operation
          PERFORM print_operation.

*         read components
          PERFORM get_cmp.
          flg_print_cmp_header = on.
*---------process components----------
          LOOP AT resbd_p_tab.
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
            n_sop = sy-tabix.
*           print sub-operations info
            PERFORM print_sub_opr.
          ENDLOOP.   "safvgd_p_tab

        ENDLOOP.  " afvgd_p_tab

      ENDLOOP.   " affld_p_tab

*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
*     This perform calls PDF form
      IF gi_err <> 1.
*        PERFORM print_pdf.
        PERFORM print_sf.
        PERFORM close_form.
      ENDIF.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    ENDDO.   "print_co-copys
  ENDLOOP.   " caufvd_p_tab
ENDFORM.                    "print_sub

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
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  PERFORM print_header.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
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

  PERFORM get_seq_text TABLES ltxt_lines.
  DESCRIBE TABLE ltxt_lines LINES n_lines.                 " long text
  IF n_lines < 1.
    IF NOT affld_p-ltxa1 IS INITIAL.                       " short text
      ADD 2 TO n_lines.
    ENDIF.
  ENDIF.

*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  MOVE affld_p-plnfl TO gs_affld_p-plnfl.

  MOVE: affld_p-seq_txt   TO gs_affld_p-seq_txt,
        affld_p-bezfl     TO gs_affld_p-bezfl,
        affld_p-vornr1    TO gs_affld_p-vornr1,
        affld_p-vornr2    TO gs_affld_p-vornr2.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
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
  PERFORM get_operation_text TABLES ltxt_lines USING linesize_opr.

*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  MOVE: afvgd_p-vornr TO gs_afvgd_p-vornr,
        affld_p-plnfl TO gs_afvgd_p-plnfl.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
* operation data
  MOVE afvgd_p-ltxa1 TO tline-tdline.
  IF NOT afvgd_p-txtsp IS INITIAL.
    READ TABLE ltxt_lines INDEX 1 INTO tline-tdline.
  ENDIF.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  MOVE: afvgd_p-arbpl TO gs_afvgd_p-arbpl,
        afvgd_p-werks TO gs_afvgd_p-werks,
        tline-tdline  TO gs_afvgd_p-tdline,
        afvgd_p-ssavd TO gs_afvgd_p-ssavd,
        afvgd_p-ssedd TO gs_afvgd_p-ssedd,
        afvgd_p-rueck TO gs_afvgd_p-rueck.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
* operation text
  LOOP AT ltxt_lines FROM 2.
    tline-tdline = ltxt_lines.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    IF tline-tdline <> space.
      gs_tdline-plnfl    = gs_afvgd_p-plnfl.
      gs_tdline-tdline   = tline-tdline.
      gs_tdline-vornr    = gs_afvgd_p-vornr.
      gs_tdline-counter  = gv_oper_counter.
      gs_tdline-type     = gc_type_opr.
      APPEND gs_tdline  TO gt_tdline.
    ENDIF.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  ENDLOOP.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  gs_afvgd_p-counter = gv_oper_counter.
  gv_oper_counter    = gv_oper_counter + 1.
  gs_afvgd_p-aplzl   =  afvgd_p-aplzl .
  APPEND gs_afvgd_p TO gt_afvgd_p.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
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
  PERFORM get_operation_text TABLES ltxt_lines USING linesize_sopr.
  DESCRIBE TABLE ltxt_lines LINES n_lines.
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
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  MOVE: afvgd_p-uvorn TO gs_subopr-uvorn,
        afvgd_p-arbpl TO gs_subopr-arbpl,
        tline-tdline  TO gs_subopr-tdline,
        afvgd_p-ssavd TO gs_subopr-ssavd,
        afvgd_p-ssedd TO gs_subopr-ssedd,
        afvgd_p-rueck TO gs_subopr-rueck.
  gs_subopr-plnfl = gs_afvgd_p-plnfl.
  gs_subopr-vornr = gs_afvgd_p-vornr.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
* suboperation text
  LOOP AT ltxt_lines FROM 2.
    tline-tdline = ltxt_lines.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    IF tline-tdline <> space.
      gs_tdline-plnfl   =  gs_subopr-plnfl.
      gs_tdline-tdline  = tline-tdline.
      gs_tdline-type    = gc_type_sub.
      gs_tdline-counter = gv_sopr_counter.
      APPEND  gs_tdline TO gt_tdline.
    ENDIF.
    CLEAR   gs_tdline.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  ENDLOOP.

*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  gs_subopr-counter =  gv_sopr_counter.
  gv_sopr_counter   = gv_sopr_counter + 1 .
  APPEND gs_subopr TO gt_subopr.
  CLEAR gs_subopr.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
* last entry ? -> insert space
  DESCRIBE TABLE safvgd_p_tab LINES sy-dbcnt.
  IF sy-dbcnt = n_sop.
    CLEAR last_object_printed.
  ENDIF.
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

  DATA  ltxt_lines LIKE tline OCCURS 0 WITH HEADER LINE.
  DATA: ls_resbd_p       TYPE resbd_p,
        l_maktx          TYPE msfcv-maktx,
        l_split_cmp_data TYPE flag.

  PERFORM get_cmp_text TABLES ltxt_lines.
  CLEAR n_lines.

* component header to be printed?
  IF NOT flg_print_cmp_header IS INITIAL.
    CLEAR flg_print_cmp_header.
    PERFORM print_lst_header USING 'CMP'.
  ENDIF.
* write data
  last_object_printed = obj-mat.
  MOVE 1 TO lines_printed.
  lines_left = lines_main - last_line - 1.
  MOVE-CORRESPONDING resbd_p TO gs_resbd_p.    "++Jayant
  IF l_split_cmp_data <> space.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    MOVE: resbd_p-bdmng TO gs_resbd_p-bdmng,
          resbd_p-matnr TO gs_resbd_p-matnr,
          msfcv-maktx   TO gs_resbd_p-matxt.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
*   copy resbd_p into local structure
    ls_resbd_p = resbd_p.
*    CLEAR resbd_p.
*   copy material short text into local parameter
    l_maktx = msfcv-maktx.
    CLEAR msfcv-maktx.
    resbd_p-bdmng = ls_resbd_p-bdmng.
    resbd_p-meins = ls_resbd_p-meins.
    resbd_p-bdter = ls_resbd_p-bdter.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    MOVE: resbd_p-posnr TO gs_resbd_p-posnr,
          resbd_p-matnr TO gs_resbd_p-matnr,
          msfcv-maktx   TO gs_resbd_p-matxt,
          resbd_p-bdmng TO gs_resbd_p-bdmng,
          resbd_p-meins TO gs_resbd_p-meins,
          resbd_p-bdter TO gs_resbd_p-bdter.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
*   recopy resbd_p from local structure
    resbd_p = ls_resbd_p.
*   recopy material short text from local parameter
    msfcv-maktx = l_maktx.
    CLEAR l_split_cmp_data.
  ELSE.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    MOVE: resbd_p-posnr TO gs_resbd_p-posnr,
          resbd_p-matnr TO gs_resbd_p-matnr,
          msfcv-maktx   TO gs_resbd_p-matxt,
          resbd_p-bdmng TO gs_resbd_p-bdmng,
          resbd_p-meins TO gs_resbd_p-meins,
          resbd_p-bdter TO gs_resbd_p-bdter.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  ENDIF.
* component text
  LOOP AT ltxt_lines.
    tline-tdline = ltxt_lines.

    PERFORM print_lst_header USING 'CMP'.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    IF tline-tdline <> space.
      gs_tdline-plnfl   = gs_afvgd_p-plnfl.
      gs_tdline-vornr   = gs_afvgd_p-vornr.
      gs_tdline-counter = gv_comp_counter.
      gs_tdline-tdline  = tline-tdline.
      gs_tdline-type    = gc_type_com.
      APPEND  gs_tdline   TO gt_tdline.
    ENDIF.
    CLEAR  gs_tdline.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  ENDLOOP.

* Segmentation
  gs_resbd_p-sgt_scat = resbd_p-sgt_scat.
  gs_resbd_p-sgt_rcat = resbd_p-sgt_rcat.

*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  gs_resbd_p-counter  = gv_comp_counter.
  gv_comp_counter     = gv_comp_counter + 1.
  gs_resbd_p-vornr    = gs_afvgd_p-vornr.
  gs_resbd_p-plnfl    = gs_afvgd_p-plnfl.
  APPEND gs_resbd_p TO gt_resbd_p.
  CLEAR  gs_resbd_p.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
* last entry ? -> insert space
  DESCRIBE TABLE resbd_p_tab LINES sy-dbcnt.
  IF sy-dbcnt = n_cmp.
    ADD n_space TO lines_printed.
    CLEAR last_object_printed.
  ENDIF.

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

  PERFORM get_prt_text TABLES ltxt_lines.
  DESCRIBE TABLE ltxt_lines LINES n_lines.
* prt header to be printed?
  IF NOT flg_print_prt_header IS INITIAL.
    CLEAR flg_print_prt_header.
    PERFORM print_lst_header USING 'PRT'.
  ENDIF.
* write data
  last_object_printed = obj-fhm.
  MOVE 1 TO lines_printed.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  MOVE:
      affhd_p-psnfh     TO gs_affhd_p-psnfh,
      affhd_p-fhwrk     TO gs_affhd_p-fhwrk,
      affhd_p-fhmnr     TO gs_affhd_p-fhmnr,
      affhd_p-fhktx     TO gs_affhd_p-fhktx,
      affhd_p-mgsol     TO gs_affhd_p-mgsol,
      affhd_p-mgsoleh   TO gs_affhd_p-mgsoleh,
      affhd_p-ssfhd     TO gs_affhd_p-ssfhd,
      affhd_p-sefhd     TO gs_affhd_p-sefhd,
      affhd_p-aplzl     TO gs_affhd_p-aplzl.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
* print text
  LOOP AT ltxt_lines.
    tline-tdline = ltxt_lines.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    IF tline-tdline <> space.
      gs_tdline-aplzl    = gs_afvgd_p-aplzl.
      gs_tdline-tdline   = tline-tdline.
      gs_tdline-type     = gc_type_pro.
      gs_tdline-counter  = gv_sopr_counter.
      APPEND  gs_tdline TO gt_tdline.
    ENDIF.
    CLEAR   gs_tdline.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  ENDLOOP.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  gs_affhd_p-counter  =  gv_sopr_counter.
  gv_sopr_counter     = gv_sopr_counter + 1.
  gs_affhd_p-aplzl    = gs_afvgd_p-aplzl.
  APPEND gs_affhd_p TO gt_affhd_p.
  CLEAR gs_affhd_p.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*

* last entry? -> insert space
  DESCRIBE TABLE affhd_p_tab LINES sy-dbcnt.
  IF sy-dbcnt = n_prt.
  ENDIF.
ENDFORM.                    " PRINT_PRT
*&---------------------------------------------------------------------*
*&      Form  PRINT_ORD_TEXT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_ord_text.

  DATA  ltxt_lines LIKE tline OCCURS 0 WITH HEADER LINE.

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
*   print long text?
    IF NOT caufvd_p-ltext IS INITIAL.
      LOOP AT ltxt_lines.
        tline-tdline = ltxt_lines.

*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
        MOVE tline-tdline TO gs_ltext.
        APPEND gs_ltext TO gt_ltext.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      ENDLOOP.
*   short text?
    ELSEIF NOT caufvd_p-ktext IS INITIAL.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      MOVE caufvd_p-ktext TO gs_caufvd_p-ktext.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    ENDIF.
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

  DATA sfc_conf_tab LIKE sfc_conf OCCURS 0 WITH HEADER LINE.

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
    DESCRIBE TABLE sfc_conf_tab LINES n_lines. ADD 1 TO n_lines.

*   configuration
    LOOP AT sfc_conf_tab.
      sfc_conf = sfc_conf_tab.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      MOVE: sfc_conf-atbez TO gs_sfc_conf-atbez,
            sfc_conf-atwtb TO gs_sfc_conf-atwtb.
      APPEND gs_sfc_conf TO gt_sfc_conf.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    ENDLOOP.

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

  DATA     ltxt_lines LIKE tline OCCURS 0 WITH HEADER LINE.
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
    ADD 1 TO lines_printed.
    LOOP AT ltxt_lines.
      tline-tdline = ltxt_lines.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      MOVE  tline-tdline TO gs_ltext.
      APPEND gs_ltext TO gt_ltext.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    ENDLOOP.

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

  DATA     ltxt_lines LIKE tline OCCURS 0 WITH HEADER LINE.
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

* write text
    LOOP AT ltxt_lines.
      tline-tdline = ltxt_lines.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      MOVE tline-tdline TO gs_ltext.
      APPEND gs_ltext TO gt_ltext.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    ENDLOOP.

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
    ltxt_lines = resbd_p-potx1.
    APPEND ltxt_lines.
  ENDIF.

ENDFORM.                    " PRINT_CMP_TEXT
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
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  MOVE: afvgd_p-vornr TO gs_afvgd_p-vornr,
        affld_p-plnfl TO gs_afvgd_p-plnfl.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*

ENDFORM.                    " PRINT_PRT_HEADER
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

*   print long text?
    IF NOT affld_p-txtsp IS INITIAL.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      MOVE affld_p-txtsp TO gs_affld_p-txtsp.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      LOOP AT ltxt_lines.
        tline-tdline = ltxt_lines.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
        IF tline-tdline <> space.
          gs_tdline-plnfl   = gs_affld_p-plnfl.
          gs_tdline-tdline  = tline-tdline.
          gs_tdline-counter = gv_seq_counter.
          gs_tdline-type    = gc_type_seq.
          APPEND gs_tdline  TO gt_tdline.
        ENDIF.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      ENDLOOP.
*   short text?
    ELSEIF NOT affld_p-ltxa1 IS INITIAL.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      MOVE affld_p-ltxa1 TO gs_affld_p-ltxa1.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    ENDIF.
  ENDIF.

*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  gs_affld_p-counter =  gv_seq_counter .
  gv_seq_counter     =  gv_seq_counter + 1.
  APPEND gs_affld_p TO gt_affld_p.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*

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
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  MOVE: caufvd_p-aufnr TO gs_caufvd_p-aufnr,
        caufvd_p-matnr TO gs_caufvd_p-matnr.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*

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
** 3 serial numbers in a row
  DESCRIBE TABLE rserob_tab LINES n_lines. MOVE 1 TO ind.
  WHILE ind <= n_lines.
*     header
    IF NOT print_header IS INITIAL.
      MOVE 1 TO lines_printed.
      CLEAR print_header.
    ENDIF.
*     fill line
    CLEAR tline.
    DO.
      IF ind > n_lines.
        EXIT.
      ENDIF.
      READ TABLE rserob_tab INDEX ind.
      ADD 1 TO ind.
      CASE sy-index.
        WHEN 1. WRITE rserob_tab-sernr TO tline-tdline+1(18).
        WHEN 2. WRITE rserob_tab-sernr TO tline-tdline+25(18).
        WHEN 3. WRITE rserob_tab-sernr TO tline-tdline+50(18).
      ENDCASE.
*       endif.
      IF sy-index = 3. EXIT. ENDIF.
    ENDDO.
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    MOVE tline-tdline TO gs_serial_numbers.
    APPEND gs_serial_numbers TO gt_serial_numbers.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
  ENDWHILE.
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
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    MOVE caufvd_p-prodnet TO gs_caufvd_p-prodnet.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    MOVE caufvd_p-maufnr TO gs_caufvd_p-maufnr.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
*   leading order
    IF caufvd_p-maufnr EQ space.

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

*----------------------------------------------------------------------*
* Start of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
      MOVE: caufvd_p-lead_aufnr  TO gs_caufvd_p-lead_aufnr,
            caufvd_p-maufnr      TO gs_caufvd_p-maufnr,
            ppprcolord-bdter     TO gs_ppprcolord-bdter,
            ppprcolord-vornr     TO gs_ppprcolord-vornr,
            ppprcolord-arbpl     TO gs_ppprcolord-arbpl,
            ppprcolord-werks     TO gs_ppprcolord-werks.
*----------------------------------------------------------------------*
* End of PDF changes   C5056725    19/08/2004
*----------------------------------------------------------------------*
    ENDIF.

  ENDIF.

ENDFORM.                    " PRINT_COL_ORD_INFO
*&---------------------------------------------------------------------*
*&      Form  print_pdf
*&---------------------------------------------------------------------*
*       This form for PDF calling
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_pdf .

* To get data to PDF form

  CALL FUNCTION gv_fm_name
    EXPORTING
*     /1BCDWB/DOCPARAMS  =
      longtext           = gt_tdline
      ltext              = gt_ltext
      serial_numbers     = gt_serial_numbers
      suboperations      = gt_subopr
      resource           = gt_affhd_p
      components         = gt_resbd_p
      operation          = gt_afvgd_p
      sequence           = gt_affld_p
      configuration      = gt_sfc_conf
      corder             = gs_ppprcolord
      object             = gs_print_co
      header             = gs_caufvd_p
    IMPORTING
      /1bcdwb/formoutput = gv_fpformoutput
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.                    " print_pdf

*&---------------------------------------------------------------------*
*&      Form  fill_outputparams
*&---------------------------------------------------------------------*
*This form will fill all the print parameters for the form            *
*---------------------------------------------------------------------*
*  -->  I_PRINT_OPTS                                                  *
*  <->  fp_OUTPUTPARAMS
*----------------------------------------------------------------------*
FORM fill_outputparams  USING  is_itcpo TYPE itcpo
                        CHANGING xs_outputparams TYPE sfpoutputparams.

  xs_outputparams-device     = is_itcpo-tdprinter.
  xs_outputparams-nodialog   = 'X'.
  xs_outputparams-preview    = is_itcpo-tdpreview.
  xs_outputparams-dest       = is_itcpo-tddest.
  xs_outputparams-reqnew     = is_itcpo-tdnewid.
  xs_outputparams-reqimm     = is_itcpo-tdimmed.
  xs_outputparams-reqdel     = is_itcpo-tddelete.
  xs_outputparams-reqfinal   = is_itcpo-tdfinal.
  xs_outputparams-senddate   = is_itcpo-tdsenddate.
  xs_outputparams-sendtime   = is_itcpo-tdsendtime.
  xs_outputparams-schedule   = is_itcpo-tdschedule.
  xs_outputparams-copies     = is_itcpo-tdcopies.
  xs_outputparams-dataset    = is_itcpo-tddataset.
  xs_outputparams-suffix1    = is_itcpo-tdsuffix1.
  xs_outputparams-suffix2    = is_itcpo-tdsuffix2.
  xs_outputparams-covtitle   = is_itcpo-tdcovtitle.
  xs_outputparams-cover      = is_itcpo-tdcover.
  xs_outputparams-receiver   = is_itcpo-tdreceiver.
  xs_outputparams-division   = is_itcpo-tddivision.
  xs_outputparams-lifetime   = is_itcpo-tdlifetime.
  xs_outputparams-authority  = is_itcpo-tdautority.
  xs_outputparams-rqposname  = is_itcpo-rqposname.
  xs_outputparams-arcmode    = is_itcpo-tdarmod.
  xs_outputparams-noarmch    = is_itcpo-tdnoarmch.
  xs_outputparams-title      = is_itcpo-tdtitle.
  xs_outputparams-nopreview  = is_itcpo-tdnoprev.
  xs_outputparams-noprint    = is_itcpo-tdnoprint.

ENDFORM.                    " fill_outputparams
*&---------------------------------------------------------------------*
*&      Form  print_header
*&---------------------------------------------------------------------*
*       data collection for header
*----------------------------------------------------------------------*
FORM print_header .
* Data collection for header
  BREAK prims.
  MOVE-CORRESPONDING caufvd_p TO gs_caufvd_p.
  MOVE: print_co-lstnm     TO gs_print_co-lstnm,
        print_co-drtxt     TO gs_print_co-drtxt,
        caufvd_p-matnr     TO gs_caufvd_p-matnr,
        caufvd_p-mat_stxt  TO gs_caufvd_p-mat_stxt,
        caufvd_p-aufnr     TO gs_caufvd_p-aufnr,
        caufvd_p-gltrs     TO gs_caufvd_p-gltrs,
        caufvd_p-gstrs     TO gs_caufvd_p-gstrs,
        caufvd_p-dispo     TO gs_caufvd_p-dispo,
        caufvd_p-txt_dispo TO gs_caufvd_p-txt_dispo,
        caufvd_p-txt_fevor TO gs_caufvd_p-txt_fevor,
        caufvd_p-auart     TO gs_caufvd_p-auart,
        caufvd_p-txt_auart TO gs_caufvd_p-txt_auart,
        caufvd_p-sttxt     TO gs_caufvd_p-sttxt,
        caufvd_p-werks     TO gs_caufvd_p-werks,
        caufvd_p-txt_werk  TO gs_caufvd_p-txt_werk,
        caufvd_p-rsnum     TO gs_caufvd_p-rsnum,
        caufvd_p-ftrms     TO gs_caufvd_p-ftrms,
        caufvd_p-gmein     TO gs_caufvd_p-gmein,
        caufvd_p-fevor     TO gs_caufvd_p-fevor,
        caufvd_p-gamng     TO gs_caufvd_p-gamng,

**************Start of correction: Modifield this field  for creation date display, by c5075678 on Date: 13/02/2006.
        caufvd_p-erdat     TO gs_caufvd_p-erdat.
**************end-of-correction: Modifield this field  for creation date display, by c5075678 on Date: 13/02/2006.

  gs_caufvd_p-sgt_scat   = afpod_p-sgt_scat. " Segmentation


ENDFORM.                    " print_header
*&---------------------------------------------------------------------*
*&      Form  open_form
*&---------------------------------------------------------------------*
*       This form opens the pdf form
*----------------------------------------------------------------------*

FORM open_form .

* This perform will fill all the print parameters for the form
  PERFORM fill_outputparams USING    print_opts
                            CHANGING gv_fp_outputparams.


*  To start the pdf
***  CALL FUNCTION 'FP_JOB_OPEN'
***    CHANGING
***      ie_outputparams = gv_fp_outputparams
***    EXCEPTIONS
***      cancel          = 1
***      usage_error     = 2
***      system_error    = 3
***      internal_error  = 4
***      OTHERS          = 5.
***  IF sy-subrc <> 0.
***    gi_err = 1.
***    EXIT.
***  ENDIF.
  print_co-actpage = 1.

*  TRY.
*      CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
*        EXPORTING
*          i_name           = print_co-form_pdf
*        IMPORTING
*          e_funcname       = gv_fm_name
*          e_interface_type = gv_interface_type.
*
*    CATCH cx_root INTO gv_w_cx_root.
*      gi_err = 1.
*  ENDTRY.

ENDFORM.                    " open_form
*&---------------------------------------------------------------------*
*&      Form  close_form
*&---------------------------------------------------------------------*
*       This form closes the pdf form
*----------------------------------------------------------------------*
FORM close_form .

***  CALL FUNCTION 'FP_JOB_CLOSE'
**** IMPORTING
****   E_RESULT             =
***    EXCEPTIONS
***      usage_error    = 1
***      system_error   = 2
***      internal_error = 3
***      OTHERS         = 4.
***  IF sy-subrc <> 0.
***    MESSAGE ID sy-msgid TYPE 'I' NUMBER sy-msgno
***            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
***  ENDIF.

ENDFORM.                    " close_form
*&---------------------------------------------------------------------*
*&      Form  PRINT_SF
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print_sf .
IF gs_caufvd_p-werks = 'PL01'.


  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZPP_PSFC_PRINT_LAY_SF'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = gv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.

      CALL FUNCTION gv_fm_name    "'/1BCDWB/SF00000035'
      EXPORTING
*       ARCHIVE_INDEX    =
*       ARCHIVE_INDEX_TAB          =
*       ARCHIVE_PARAMETERS         =
*       CONTROL_PARAMETERS         =
*       MAIL_APPL_OBJ    =
*       MAIL_RECIPIENT   =
*       MAIL_SENDER      =
*       OUTPUT_OPTIONS   =
*       USER_SETTINGS    = 'X'
        longtext         = gt_tdline
        ltext            = gt_ltext
        suboperations    = gt_subopr
        resource         = gt_affhd_p
        components       = gt_resbd_p
        operation        = gt_afvgd_p
        sequence         = gt_affld_p
        configuration    = gt_sfc_conf
        corder           = gs_ppprcolord
        object           = gs_print_co
        header           = gs_caufvd_p
        serial_numbers   = gt_serial_numbers
*   IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO  =
*       JOB_OUTPUT_OPTIONS         =
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.

ELSEIF gs_caufvd_p-werks = 'US01'.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZUS_PRODUCTION_ORDER'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = gv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.

      CALL FUNCTION gv_fm_name    "'/1BCDWB/SF00000035'
      EXPORTING
*       ARCHIVE_INDEX    =
*       ARCHIVE_INDEX_TAB          =
*       ARCHIVE_PARAMETERS         =
*       CONTROL_PARAMETERS         =
*       MAIL_APPL_OBJ    =
*       MAIL_RECIPIENT   =
*       MAIL_SENDER      =
*       OUTPUT_OPTIONS   =
*       USER_SETTINGS    = 'X'
        longtext         = gt_tdline
        ltext            = gt_ltext
        suboperations    = gt_subopr
        resource         = gt_affhd_p
        components       = gt_resbd_p
        operation        = gt_afvgd_p
        sequence         = gt_affld_p
        configuration    = gt_sfc_conf
        corder           = gs_ppprcolord
        object           = gs_print_co
        header           = gs_caufvd_p
        serial_numbers   = gt_serial_numbers
*   IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO  =
*       JOB_OUTPUT_OPTIONS         =
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.


ELSE.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZSU_PRODUCTION_ORDER'
*     VARIANT            = ' '
*     DIRECT_CALL        = ' '
    IMPORTING
      fm_name            = gv_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.

      CALL FUNCTION gv_fm_name    "'/1BCDWB/SF00000035'
      EXPORTING
*       ARCHIVE_INDEX    =
*       ARCHIVE_INDEX_TAB          =
*       ARCHIVE_PARAMETERS         =
*       CONTROL_PARAMETERS         =
*       MAIL_APPL_OBJ    =
*       MAIL_RECIPIENT   =
*       MAIL_SENDER      =
*       OUTPUT_OPTIONS   =
*       USER_SETTINGS    = 'X'
        longtext         = gt_tdline
        ltext            = gt_ltext
        suboperations    = gt_subopr
        resource         = gt_affhd_p
        components       = gt_resbd_p
        operation        = gt_afvgd_p
        sequence         = gt_affld_p
        configuration    = gt_sfc_conf
        corder           = gs_ppprcolord
        object           = gs_print_co
        header           = gs_caufvd_p
        serial_numbers   = gt_serial_numbers
*   IMPORTING
*       DOCUMENT_OUTPUT_INFO       =
*       JOB_OUTPUT_INFO  =
*       JOB_OUTPUT_OPTIONS         =
      EXCEPTIONS
        formatting_error = 1
        internal_error   = 2
        send_error       = 3
        user_canceled    = 4
        OTHERS           = 5.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
              WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDIF.
ENDIF.


ENDFORM.
