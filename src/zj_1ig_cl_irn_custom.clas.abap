class ZJ_1IG_CL_IRN_CUSTOM definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_filedata,
        ack_no        TYPE j_1ig_ack_no,
        ack_date      TYPE j_1ig_ack_date,
        irn           TYPE j_1ig_irn,
        signed_inv    TYPE j_1ig_sign_inv,
        signed_qrcode TYPE j_1ig_sign_qrcode,
        irn_status    TYPE j_1ig_irn_status,
        odn           TYPE j_1ig_odn,
        doc_date      TYPE sydatum,
        sel_gstin     TYPE j_1igstcd3,
        ewbno         TYPE j_1ig_ebillno,    "SAP Note 2904222
        ewbdt(21)     TYPE c,                "SAP Note 2904222
        ewbvalidtill(21) TYPE c,             "SAP Note 2904222
        cancel_date   TYPE j_1ig_canc_date,
      END OF ty_filedata .
  types:
    BEGIN OF ty_vbrk,
        vbeln TYPE vbeln_vf,
        fkart TYPE fkart,
        fkdat TYPE fkdat,
        gjahr TYPE gjahr,
        bukrs TYPE bukrs,
        xblnr TYPE xblnr_v1,
        bupla TYPE bupla,
      END OF ty_vbrk .
  types:
    BEGIN OF ty_vbrp,
        vbeln TYPE vbeln_vf,
        posnr TYPE posnr_vf,
        werks TYPE werks_d,
      END OF ty_vbrp .
  types:
    BEGIN OF ty_t001w,
        werks      TYPE werks_d,
        j_1bbranch TYPE j_1bbranc_,
      END OF ty_t001w .
  types:
    BEGIN OF ty_j_1bbranch,
        bukrs  TYPE bukrs,
        branch TYPE j_1bbranc_,
        gstin  TYPE j_1igstcd3,
      END OF ty_j_1bbranch .
  types:
    BEGIN OF ty_bkpf,
        bukrs TYPE bukrs,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        blart TYPE blart,
        bldat TYPE bldat,
        budat TYPE budat,
*        xblnr TYPE xblnr,
        xblnr TYPE xblnr_alt,
        awkey TYPE awkey,
      END OF ty_bkpf .
  types:
    BEGIN OF ty_bseg,
        bukrs TYPE bukrs,
        belnr TYPE belnr_d,
        gjahr TYPE gjahr,
        koart TYPE koart,
        bupla TYPE bupla,
      END OF ty_bseg .
  types:
    BEGIN OF ty_ewaybill,
      doctyp  TYPE j_1ig_doctyp,
      docno   TYPE j_1ig_docno,
      ebillno TYPE j_1ig_ebillno,
    END OF ty_ewaybill .
  types:
    BEGIN OF ty_xdata,
        line(2550) TYPE x,
      END OF ty_xdata .
  types:
    BEGIN OF ty_invrefnum1,
        bukrs       TYPE bukrs,
        docno       TYPE j_1ig_docno,
        doc_year    TYPE j_1ig_doc_year,
        doc_type    TYPE j_1ig_doctyp,
        odn         TYPE xblnr_alt,
        irn         TYPE j_1ig_irn,
        version     TYPE j_1ig_version,
        bupla       TYPE bupla,
        odn_date    TYPE j_1ig_odn_date,
        ack_no      TYPE j_1ig_ack_no,
        ack_date    TYPE j_1ig_ack_date,
        irn_status  TYPE j_1ig_irn_status,
        cancel_date TYPE j_1ig_canc_date,
      END OF ty_invrefnum1 .
  types:
    BEGIN OF ty_output,
        indicator   TYPE char04,
        bukrs       TYPE bukrs,
        docno       TYPE j_1ig_docno,
        doc_year    TYPE j_1ig_doc_year,
        doc_type    TYPE j_1ig_doctyp,
        odn         TYPE xblnr_alt,
        irn         TYPE j_1ig_irn,
        version     TYPE j_1ig_version,
        ack_no      TYPE j_1ig_ack_no,
        ack_date    TYPE j_1ig_ack_date,
        irn_status  TYPE j_1ig_irn_status,
        cancel_date TYPE j_1ig_canc_date,
        ewbno       TYPE j_1ig_ebillno,    "SAP Note 2904222
        ewbdt(21)   TYPE c,                "SAP Note 2904222
        ewbvalidtill(21) TYPE c,           "SAP Note 2904222
        message     TYPE string,
      END OF ty_output .
  types:
    BEGIN OF ty_odn_122,
           mblnr TYPE mblnr,
           mjahr TYPE mjahr,
           budat TYPE budat,
           werks TYPE werks_d,
           xblnr TYPE xblnr1,
           cputm_mkpf TYPE cputm,
           END OF ty_odn_122 .
  types:
    ty_r_odn_122_tt TYPE TABLE OF  ty_odn_122 .
  types:
    ty_r_vbeln TYPE RANGE OF vbeln_vf .
  types:
    ty_r_date TYPE RANGE OF sydatum .
  types:
    ty_r_status TYPE RANGE OF j_1ig_irn_status .
  types:
    ty_r_odn TYPE RANGE OF xblnr_alt .
  types:
    ty_r_bupla TYPE RANGE OF bupla .
  types:
    ty_r_tables TYPE RANGE OF tabname .
  types:
    ty_filedata_tt TYPE TABLE OF ty_filedata .
  types:
    ty_filedata1_tt TYPE TABLE OF string .
  types:
    ty_vbrk_tt TYPE TABLE OF ty_vbrk .
  types:
    ty_vbrp_tt TYPE TABLE OF ty_vbrp .
  types:
    ty_t001w_tt TYPE TABLE OF ty_t001w .
  types:
    ty_bkpf_tt TYPE TABLE OF ty_bkpf .
  types:
    ty_bseg_tt TYPE TABLE OF ty_bseg .
  types:
    ty_ewaybill_tt TYPE TABLE OF ty_ewaybill .
  types:
    ty_j_1bbranch_tt TYPE TABLE OF ty_j_1bbranch .
  types:
    ty_fg_files_tt TYPE TABLE OF file_info .
  types:
    ty_bg_files_tt TYPE TABLE OF salfldir .
  types:
    ty_invrefnum_tt TYPE STANDARD TABLE OF j_1ig_invrefnum .
  types:
    ty_ewaybill1_tt TYPE STANDARD TABLE OF j_1ig_ewaybill .
  types:
    ty_invrefnum1_tt TYPE TABLE OF ty_invrefnum1 .

  constants C_OPT_LIST type RSREST_OPL value 'EQ' ##NO_TEXT.
  constants C_J1IIRN type XUOBJECT value 'J_1IIRN' ##NO_TEXT.
  constants C_ACTVT type XUFIELD value 'ACTVT' ##NO_TEXT.
  constants C_BUKRS type XUFIELD value 'BUKRS' ##NO_TEXT.
  constants C_BUPLA type XUFIELD value 'BUPLA' ##NO_TEXT.
  constants C_01 type ACTIV_AUTH value '01' ##NO_TEXT.
  constants C_ACTIVE type J_1IG_IRN_STATUS value 'ACT' ##NO_TEXT.
  constants C_03 type ACTIV_AUTH value '03' ##NO_TEXT.
  constants C_KIND_S type RSSCR_KIND value 'S' ##NO_TEXT.
  constants C_S_STAT type BLOCKNAME value 'S_STAT' ##NO_TEXT.
  constants C_S_BP type BLOCKNAME value 'S_BP' ##NO_TEXT.
  constants C_SIGN_I type RALDB_SIGN value 'I' ##NO_TEXT.
  constants C_SIGN_EQ type RALDB_OPTI value 'EQ' ##NO_TEXT.
  class-data GV_SING type FLAG .
  class-data GV_BULK type FLAG .
  class-data GV_FG type FLAG .
  class-data GV_BG type FLAG .
  class-data GV_OB_INV type FLAG .
  class-data GV_OB_DIS type FLAG .
  class-data GV_BUKRS type BUKRS .
  class-data GV_GJAHR type GJAHR .
  class-data GV_DISP_GJAHR type GJAHR .
  class-data GT_DATE type TY_R_DATE .
  class-data GT_DATE1 type TY_R_DATE .
  class-data GT_DOC type TY_R_VBELN .
  class-data GT_STATUS type TY_R_STATUS .
  class-data GV_INT_NUM_FLAG type FLAG .
  class-data GV_FILE type LOCALFILE .
  class-data GV_DIR type STRING .
  class-data GV_BP type BUPLA .
  class-data GV_DIR1 type PFEFLNAMEL .
  class-data GV_CLOUD_CHECK type FLAG .
  class-data:
    gt_odn TYPE RANGE OF xblnr_alt .
  class-data:
    gt_bupla TYPE RANGE OF bupla .
  class-data:
    gt_output TYPE TABLE OF ty_output .
  class-data:
    gt_filedata TYPE TABLE OF ty_filedata .
  constants C_IN type CHAR2 value 'IN' ##NO_TEXT.
  class-data GT_OB_DOC type TY_R_VBELN .
  constants C_MODE type ENQMODE value 'E' ##NO_TEXT.
  constants C_INVREFNUM type TABNAME value 'J_1IG_INVREFNUM' ##NO_TEXT.
  constants C_EWAYBILL type TABNAME value 'J_1IG_EWAYBILL' ##NO_TEXT.
  constants C_STATUS_A type J_1IG_STAT value 'A' ##NO_TEXT.
  constants C_STATUS_P type J_1IG_STAT value 'P' ##NO_TEXT.
  constants C_STATUS_E type J_1IG_STAT value 'E' ##NO_TEXT.
  constants C_RFBU type GLVOR value 'RFBU' ##NO_TEXT.
  constants C_X type FLAG value 'X' ##NO_TEXT.
  constants C_SPACE type FLAG value '' ##NO_TEXT.
  constants:
    c_green_light(4) type c value '@08@' ##NO_TEXT.
  constants:
    c_red_light(4)   type c value '@0A@' ##NO_TEXT.
  constants C_ASC type CHAR10 value 'ASC' ##NO_TEXT.
  constants:
    C_SEP(2) type C value '":' ##NO_TEXT.
  constants C_CANCEL type J_1IG_IRN_STATUS value 'CNL' ##NO_TEXT.
  class-data GV_MANUAL_PROCESS type FLAG .
  class-data GV_AUTOMATE_PROCESS type FLAG .
  class-data:
    gt_canceldata TYPE TABLE OF ty_filedata .

  class-methods GET_FILENAME
    exporting
      !EX_FILE type LOCALFILE .
  class-methods INIT_SEL_SCREEN .
  methods CONSTRUCTOR
    importing
      !IM_OB_INV type FLAG
      !IM_CCODE type BUKRS
      !IM_FYEAR type GJAHR
      !IM_DISP_FYEAR type GJAHR
      !IM_BP type BUPLA
      !IM_DATE type TY_R_DATE
      !IM_FILE type LOCALFILE
      !IM_DOC type TY_R_VBELN
      !IM_STATUS type TY_R_STATUS
      !IM_OB_DIS type FLAG
      !IM_SING type FLAG
      !IM_BULK type FLAG
      !IM_FG type FLAG
      !IM_BG type FLAG
      !IM_DIR type STRING
      !IM_ODN type TY_R_ODN
      !IM_BUPLA type TY_R_BUPLA
      !IM_DIR1 type PFEFLNAMEL
      !IM_MANUAL_PROCESS type FLAG
      !IM_AUTOMATE_PROCESS type FLAG .
  methods MAIN .
  methods VAL_SEL_SCREEN .
  methods CLEAR_GLOBAL_DATA .
  methods FETCH_DATA
    exporting
      !EX_T_INVREFNUM type TY_INVREFNUM_TT
      !EX_T_EWAYBILL type TY_EWAYBILL1_TT .
  methods PREP_OB_DATA
    exporting
      !EX_T_INVREFNUM type TY_INVREFNUM_TT
      !EX_T_EWAYBILL type TY_EWAYBILL1_TT .
  methods PREP_FILE_DATA
    importing
      !IM_VALUE type STRING optional
    exporting
      !EX_SUBRC type I .
  methods DISP_TBL_DATA .
  methods DISP_OUT_DATA .
  class-methods GET_DIRECTORY_PATH
    importing
      !IM_FG type FLAG optional
    exporting
      !EX_DIR type STRING
      !EX_DIR1 type PFEFLNAMEL .
  methods DECODE_QRCODE
    importing
      !IM_QRCODE type J_1IG_SIGN_QRCODE
    exporting
      !EX_ODN type J_1IG_ODN
      !EX_DOC_DATE type SYDATUM
      !EX_SEL_GSTIN type J_1IGSTCD3 .
  methods OB_SING_DATA
    exporting
      !EX_T_VBRK type TY_VBRK_TT
      !EX_T_VBRP type TY_VBRP_TT
      !EX_T_T001W type TY_T001W_TT
      !EX_T_BKPF type TY_BKPF_TT
      !EX_T_BSEG type TY_BSEG_TT
      !EX_T_1BBRANCH type TY_J_1BBRANCH_TT
      !EX_T_EWAYBILL type TY_EWAYBILL_TT
      !EX_T_INVREFNUM type TY_INVREFNUM1_TT
      !EX_T_EWAYBILL_ACT type TY_EWAYBILL_TT .
  methods OB_BULK_DATA
    exporting
      !EX_T_VBRK type TY_VBRK_TT
      !EX_T_VBRP type TY_VBRP_TT
      !EX_T_T001W type TY_T001W_TT
      !EX_T_BKPF type TY_BKPF_TT
      !EX_T_BSEG type TY_BSEG_TT
      !EX_T_1BBRANCH type TY_J_1BBRANCH_TT
      !EX_T_EWAYBILL type TY_EWAYBILL_TT
      !EX_T_INVREFNUM type TY_INVREFNUM1_TT
      !EX_T_EWAYBILL_ACT type TY_EWAYBILL_TT .
  methods PROC_OB_DATA
    importing
      !IM_T_VBRK type TY_VBRK_TT
      !IM_T_VBRP type TY_VBRP_TT
      !IM_T_T001W type TY_T001W_TT
      !IM_T_BKPF type TY_BKPF_TT
      !IM_T_INVREFNUM type TY_INVREFNUM1_TT
      !IM_T_BSEG type TY_BSEG_TT
      !IM_T_1BBRANCH type TY_J_1BBRANCH_TT
      !IM_T_EWAYBILL type TY_EWAYBILL_TT optional
      !IM_T_EWAYBILL_ACT type TY_EWAYBILL_TT optional
    exporting
      !EX_T_INVREFNUM_UPD type TY_INVREFNUM_TT
      !EX_T_EWAYBILL_UPD type TY_EWAYBILL1_TT .
  methods SEG_FILE_DATA
    importing
      !IM_DATA type STRING
    changing
      !CH_FILEDATA type TY_FILEDATA .
  methods GET_OB_DATA
    exporting
      !EX_T_VBRK type TY_VBRK_TT
      !EX_T_VBRP type TY_VBRP_TT
      !EX_T_T001W type TY_T001W_TT
      !EX_T_BKPF type TY_BKPF_TT
      !EX_T_BSEG type TY_BSEG_TT
      !EX_T_1BBRANCH type TY_J_1BBRANCH_TT
      !EX_T_EWAYBILL type TY_EWAYBILL_TT
      !EX_T_INVREFNUM type TY_INVREFNUM1_TT
      !EX_T_EWAYBILL_ACT type TY_EWAYBILL_TT .
  methods GET_FILES
    exporting
      !EX_SUBRC type SYSUBRC
      !EX_T_FG_FILES type TY_FG_FILES_TT
      !EX_T_BG_FILES type TY_BG_FILES_TT .
  methods UPDATE_DB
    importing
      !IM_T_INVREFNUM type TY_INVREFNUM_TT
      !IM_T_EWAYBILL type TY_EWAYBILL1_TT optional .
  methods COL_FILE_DATA
    importing
      !IM_T_FILE_DATA type TY_FILEDATA1_TT .
  methods VAL_PREP_EBILL
    importing
      !IM_T_EWAYBILL type TY_EWAYBILL_TT
      !IM_T_EWAYBILL_ACT type TY_EWAYBILL_TT
      !IM_FILEDATA type TY_FILEDATA
      !IM_INVREFNUM type J_1IG_INVREFNUM
      !IM_OUTPUT type TY_OUTPUT
    exporting
      !EX_ERROR type FLAG
      !EX_EWAYBILL type J_1IG_EWAYBILL .
  methods LOCK_UNLOCK_TABLES
    importing
      !IM_T_TABLES type TY_R_TABLES
      !IM_LOCK type FLAG optional
    exporting
      !EX_LOCK type FLAG .
  methods PREP_CANCEL_DATA
    exporting
      !EX_T_INVREFNUM type TY_INVREFNUM_TT .
protected section.
private section.
ENDCLASS.



CLASS ZJ_1IG_CL_IRN_CUSTOM IMPLEMENTATION.


  METHOD CLEAR_GLOBAL_DATA.

*---Clear Global data
    CLEAR: gt_output,gt_filedata,gt_canceldata.

  ENDMETHOD.


  METHOD COL_FILE_DATA.

    DATA: lwa_filedata TYPE ty_filedata.

    FIELD-SYMBOLS: <lfs_data> TYPE string.

    LOOP AT im_t_file_data ASSIGNING <lfs_data>.
      seg_file_data( EXPORTING
                       im_data = <lfs_data>
                     CHANGING
                       ch_filedata = lwa_filedata ).
      AT LAST.
        IF lwa_filedata-signed_qrcode IS NOT INITIAL.
          decode_qrcode( EXPORTING
                           im_qrcode    = lwa_filedata-signed_qrcode
                         IMPORTING
                           ex_odn       = lwa_filedata-odn
                           ex_doc_date  = lwa_filedata-doc_date
                           ex_sel_gstin = lwa_filedata-sel_gstin ).
        ENDIF.
        IF lwa_filedata IS NOT INITIAL.
          IF lwa_filedata-cancel_date IS NOT INITIAL OR lwa_filedata-irn_status EQ c_cancel.
            APPEND lwa_filedata TO gt_canceldata.
          ELSE.
            APPEND lwa_filedata TO gt_filedata.
          ENDIF.
        ENDIF.
        CLEAR lwa_filedata.
      ENDAT.
    ENDLOOP.

  ENDMETHOD.


  METHOD CONSTRUCTOR.

*---Initialize the global variables
    gv_ob_inv     = im_ob_inv.
    gv_ob_dis     = im_ob_dis.
    gv_sing       = im_sing.
    gv_bulk       = im_bulk.
    gv_bukrs      = im_ccode.
    gv_bp         = im_bp.
    gt_date       = im_date.
    gt_doc        = im_doc.
    gt_status     = im_status.
    gv_file       = im_file.
    gv_dir        = im_dir.
    gv_dir1       = im_dir1.
    gv_fg         = im_fg.
    gv_bg         = im_bg.
    gt_odn        = im_odn.
    gt_bupla      = im_bupla.
    gv_gjahr      = im_fyear.
    gv_disp_gjahr = im_disp_fyear.
    gv_manual_process =  im_manual_process.
    gv_automate_process =  im_automate_process.

  ENDMETHOD.


  METHOD DECODE_QRCODE.

    DATA: lt_xdata TYPE TABLE OF ty_xdata,
          lt_data  TYPE TABLE OF string,
          l_value  TYPE xstring,
          l_data   TYPE string,
          l_len    TYPE i,
          l_tabix  TYPE sytabix.
    DATA: ls_odn TYPE xblnr1.
    FIELD-SYMBOLS: <lfs_data> TYPE string.

*---Clear Exporting data
    CLEAR: ex_odn,ex_doc_date,ex_sel_gstin.

*---Begin of SAP Note 2904222 Changes
    SPLIT im_qrcode AT '.' INTO TABLE lt_data.
    READ TABLE lt_data ASSIGNING <lfs_data> INDEX 2.
    IF sy-subrc EQ 0.
*---End of SAP Note 2904222 Changes

    CALL FUNCTION 'SCMS_BASE64_DECODE_STR'
      EXPORTING
        input  = <lfs_data>                   "SAP Note 2904222
      IMPORTING
        output = l_value
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc EQ 0.

      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = l_value
        IMPORTING
          output_length = l_len
        TABLES
          binary_tab    = lt_xdata.
      IF lt_xdata IS NOT INITIAL.

        CALL FUNCTION 'SCMS_BINARY_TO_STRING'
          EXPORTING
            input_length = l_len
          IMPORTING
            text_buffer  = l_data
          TABLES
            binary_tab   = lt_xdata
          EXCEPTIONS
            failed       = 1
            OTHERS       = 2.
        IF sy-subrc EQ 0 AND l_data IS NOT INITIAL.
          REPLACE: ALL OCCURRENCES OF ':'  IN l_data WITH ',',
                   ALL OCCURRENCES OF '"{\"' IN l_data WITH space,
                   ALL OCCURRENCES OF '\"' IN l_data WITH space.

          CLEAR: lt_data.                       "SAP Note 2904222
          SPLIT l_data AT ',' INTO TABLE lt_data.

*---ODN/Document Document, Can't sort and use the Binary search
*---as it changes the sequence of data
          READ TABLE lt_data TRANSPORTING NO FIELDS
            WITH KEY table_line = 'DocNo'.
          IF sy-subrc EQ 0.
            l_tabix = sy-tabix + 1.
*            UNASSIGN: <lfs_data>.               "SAP Note 2904222
              READ TABLE lt_data INTO ls_odn INDEX l_tabix.

              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = ls_odn
                IMPORTING
                  output = ls_odn.

              IF sy-subrc EQ 0.
                ex_odn = ls_odn. " commented for SAP Note 2941538
*     Begin of changes for SAP Note 2941538
              IF gv_int_num_flag eq c_x.
                ex_odn = ls_odn.
                ex_odn = ex_odn+6(10).
              ELSE.
                IF ls_odn CO '0123456789'.
                  ex_odn = ls_odn.
                  ex_odn = ex_odn+4(16).
                ELSE.
                  ex_odn = ls_odn.
                ENDIF.
              ENDIF.
*     End of changes for SAP Note 2941538
            ENDIF.
          ENDIF.

*---Document Date, Can't sort and use the Binary search
*---as it changes the sequence of data
          READ TABLE lt_data TRANSPORTING NO FIELDS
            WITH KEY table_line = 'DocDt'.
          IF sy-subrc EQ 0.
            CLEAR: l_tabix.
            l_tabix = sy-tabix + 1.
            UNASSIGN: <lfs_data>.
            READ TABLE lt_data ASSIGNING <lfs_data> INDEX l_tabix.
*---Begin of SAP Note 2904222 Changes
            IF sy-subrc EQ 0 AND strlen( <lfs_data> ) EQ 10.
              CONCATENATE <lfs_data>+6(4) <lfs_data>+3(2)
                <lfs_data>+0(2) INTO ex_doc_date.
*---End of SAP Note 2904222 Changes
            ENDIF.
          ENDIF.

*---Seller GSTIN, Can't sort and use the Binary search
*---as it changes the sequence of data
          READ TABLE lt_data TRANSPORTING NO FIELDS
            WITH KEY table_line = 'SellerGstin'.
          IF sy-subrc EQ 0.
            CLEAR: l_tabix.
            l_tabix = sy-tabix + 1.
            UNASSIGN: <lfs_data>.
            READ TABLE lt_data ASSIGNING <lfs_data> INDEX l_tabix.
            IF sy-subrc EQ 0.
              ex_sel_gstin = <lfs_data>.
            ENDIF.
          ENDIF.

        ENDIF.
      ENDIF.
    ENDIF.
    ENDIF.            "SAP Note 2904222

  ENDMETHOD.


  METHOD DISP_OUT_DATA.

    DATA: lo_salv_msg  TYPE REF TO cx_salv_msg,
          lo_alv_ref   TYPE REF TO cl_salv_table,
          lo_cols      TYPE REF TO cl_salv_columns,
          lo_column    TYPE REF TO cl_salv_column,
          lo_functions TYPE REF TO cl_salv_functions,
          l_error_text TYPE string.

    TRY.
        CALL METHOD cl_salv_table=>factory
          IMPORTING
            r_salv_table = lo_alv_ref
          CHANGING
            t_table      = gt_output.
      CATCH cx_salv_msg INTO lo_salv_msg.
        l_error_text = lo_salv_msg->get_text( ).
        MESSAGE e000 WITH l_error_text.
    ENDTRY.

    lo_cols = lo_alv_ref->get_columns( ).

    IF gv_automate_process EQ c_x." Contingency Code check

      lo_cols->set_column_position( columnname = 'INDICATOR' position   = 1 ).
      lo_cols->set_column_position( columnname = 'BUKRS' position   = 2 ).
      lo_cols->set_column_position( columnname = 'DOCNO' position   = 3 ).
      lo_cols->set_column_position( columnname = 'DOC_YEAR' position   = 4 ).
      lo_cols->set_column_position( columnname = 'DOC_TYPE' position   = 5 ).
      lo_cols->set_column_position( columnname = 'ODN' position   = 6 ).
      lo_cols->set_column_position( columnname = 'MESSAGE' position   = 7 ).
      lo_cols->set_column_position( columnname = 'IRN' position   = 8 ).
      lo_cols->set_column_position( columnname = 'VERSION' position   = 9 ).
      lo_cols->set_column_position( columnname = 'ACK_NO' position   = 10 ).
      lo_cols->set_column_position( columnname = 'ACK_DATE' position   = 11 ).
      lo_cols->set_column_position( columnname = 'EWBNO' position   = 12 ).
      lo_cols->set_column_position( columnname = 'EWBDT' position   = 13 ).
      lo_cols->set_column_position( columnname = 'EWBVALIDTILL' position   = 14 ).
      lo_cols->set_column_position( columnname = 'CANCEL_DATE' position   = 15 ).
      lo_cols->set_column_position( columnname = 'IRN_STATUS' position   = 16 ).

    ENDIF.

    TRY.
        lo_column = lo_cols->get_column( 'INDICATOR' ).
        lo_column->set_long_text( 'Status' ).
        lo_column->set_medium_text( 'Status' ).
        lo_column->set_short_text( 'Status' ).
        lo_column->set_output_length( 6 ).
        IF gv_ob_dis EQ c_x.
          lo_column->set_visible( c_space ).
        ENDIF.
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'BUKRS' ).
        lo_column->set_long_text( 'Company Code' ).
        lo_column->set_medium_text( 'Company Code' ).
        lo_column->set_short_text( 'Comp. Code' ).
        lo_column->set_output_length( 4 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'DOCNO' ).
        lo_column->set_long_text( 'Document Number' ).
        lo_column->set_medium_text( 'Document Number' ).
        lo_column->set_short_text( 'Document' ).
        lo_column->set_leading_zero( c_space ).
        lo_column->set_output_length( 10 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'DOC_YEAR' ).
        IF gv_ob_dis EQ c_x.
          lo_column->set_visible( c_space ).
        ENDIF.
        IF gv_automate_process EQ c_x." Contingency Code check
          lo_column->set_visible( c_space ).
        ENDIF.
        lo_column->set_long_text( 'Document Fiscal Year' ).
        lo_column->set_medium_text( 'Document Fiscal Year' ).
        lo_column->set_short_text( 'Doc. Year' ).
        lo_column->set_output_length( 4 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'DOC_TYPE' ).
        IF gv_automate_process EQ c_x." Contingency Code check
          lo_column->set_visible( c_space ).
        ENDIF.
        lo_column->set_long_text( 'Document Type' ).
        lo_column->set_medium_text( 'Document Type' ).
        lo_column->set_short_text( 'Doc. Type' ).
        lo_column->set_output_length( 4 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'ODN' ).
        lo_column->set_long_text( 'Official Document Number' ).
        lo_column->set_medium_text( 'ODN' ).
        lo_column->set_short_text( 'ODN' ).
        lo_column->set_leading_zero( c_space ).
        lo_column->set_output_length( 26 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'IRN' ).
        lo_column->set_long_text( 'Invoice Reference Number' ).
        lo_column->set_medium_text( 'Inv. Ref. Number' ).
        lo_column->set_short_text( 'IRN' ).
        lo_column->set_output_length( 64 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'VERSION' ).
        IF gv_ob_dis EQ c_x.
          lo_column->set_visible( c_space ).
        ENDIF.
        IF gv_automate_process EQ c_x." Contingency Code check
          lo_column->set_visible( c_space ).
        ENDIF.
        lo_column->set_short_text( 'Version' ).
        lo_column->set_output_length( 3 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'ACK_NO' ).
        lo_column->set_long_text( 'Acknowledgement Number' ).
        lo_column->set_medium_text( 'Ack. Number' ).
        lo_column->set_short_text( 'Ack. No' ).
        lo_column->set_output_length( 20 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'ACK_DATE' ).
        lo_column->set_long_text( 'Acknowledgement Date' ).
        lo_column->set_medium_text( 'Acknowledgement Date' ).
        lo_column->set_short_text( 'Ack. Date' ).
        lo_column->set_output_length( 21 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'IRN_STATUS' ).
        lo_column->set_output_length( 6 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'CANCEL_DATE' ).
        lo_column->set_medium_text( 'Cancelled Date' ).
        lo_column->set_short_text( 'Canc. Date' ).
        lo_column->set_output_length( 21 ).
      CATCH cx_salv_not_found.
    ENDTRY.

*---Begin of SAP Note 2904222 Changes
    TRY.
        lo_column = lo_cols->get_column( 'EWBNO' ).
        lo_column->set_medium_text( 'E-way Bill Number' ).
        lo_column->set_short_text( 'E-way Bill' ).
        lo_column->set_output_length( 12 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'EWBDT' ).
        lo_column->set_medium_text( 'E-way Bill Date' ).
        lo_column->set_short_text( 'E-way Date' ).
        lo_column->set_output_length( 21 ).
      CATCH cx_salv_not_found.
    ENDTRY.

    TRY.
        lo_column = lo_cols->get_column( 'EWBVALIDTILL' ).
        lo_column->set_medium_text( 'E-way Valid Till' ).
        lo_column->set_short_text( 'Valid Till' ).
        lo_column->set_output_length( 21 ).
      CATCH cx_salv_not_found.
    ENDTRY.
*---End of SAP Note 2904222 Changes

    TRY.
        lo_column = lo_cols->get_column( 'MESSAGE' ).
        lo_column->set_long_text( 'Message' ).
        lo_column->set_medium_text( 'Message' ).
        lo_column->set_short_text( 'Message' ).
        lo_column->set_output_length( 100 ).
        IF gv_ob_dis EQ c_x.
          lo_column->set_visible( c_space ).
        ENDIF.
      CATCH cx_salv_not_found.
    ENDTRY.

    lo_functions = lo_alv_ref->get_functions( ).

    lo_functions->set_all( c_x ).

    lo_alv_ref->display( ).

  ENDMETHOD.


  METHOD DISP_TBL_DATA.

* Begin of changes by C5310376
  TYPES : BEGIN OF ty_ewbill,
              bukrs TYPE bukrs,
              doctyp TYPE j_1ig_doctyp,
              docno TYPE j_1ig_docno,
              gjahr TYPE gjahr,
              ebillno TYPE j_1ig_ebillno,
              egen_dat TYPE j_1ig_egendat,
              egen_time TYPE j_1ig_egentime,
              vdtodate  TYPE j_1ig_vdtodate,
              vdtotime TYPE j_1ig_vdtotime,
          END OF ty_ewbill.

   DATA : lt_ewaybill TYPE STANDARD TABLE OF ty_ewbill,
          lw_ewaybill TYPE ty_ewbill.

   DATA : lt_date(10),
          lt_time(8).

   FIELD-SYMBOLS: <fs_output> TYPE ty_output.

* End of changes by C5310376

*---Get required data from J_1IG_INVREFNUM and J_1IG_EWAYBILL, partial Primary Key is used
    SELECT bukrs docno doc_year doc_type odn
           irn version ack_no ack_date
           irn_status cancel_date
      FROM j_1ig_invrefnum
      INTO CORRESPONDING FIELDS OF TABLE gt_output
      WHERE bukrs      EQ gv_bukrs
        AND docno      IN gt_doc
        AND doc_year   EQ gv_disp_gjahr
        AND odn        IN gt_odn
        AND bupla      IN gt_bupla
        AND odn_date   IN gt_date1
        AND irn_status IN gt_status.
    IF sy-subrc EQ 0.
      SORT gt_output BY bukrs docno.

*  Begin of changes by C5310376
      SELECT bukrs doctyp docno
             gjahr ebillno
             egen_dat egen_time
             vdtodate vdtotime
      FROM j_1ig_ewaybill
      INTO TABLE lt_ewaybill
      FOR ALL ENTRIES IN gt_output
      WHERE bukrs = gt_output-bukrs AND
            docno = gt_output-docno AND
            doctyp = gt_output-doc_type AND
            gjahr = gt_output-doc_year.

      IF sy-subrc EQ 0.
       LOOP AT gt_output ASSIGNING <fs_output>.
        READ TABLE lt_ewaybill INTO lw_ewaybill WITH KEY bukrs = <fs_output>-bukrs
                                                         doctyp = <fs_output>-doc_type
                                                         gjahr = <fs_output>-doc_year
                                                         docno = <fs_output>-docno.
        IF sy-subrc EQ 0.
            <fs_output>-ewbno = lw_ewaybill-ebillno.
            CONCATENATE lw_ewaybill-egen_dat+6(2) lw_ewaybill-egen_dat+4(2) lw_ewaybill-egen_dat+0(4) INTO lt_date SEPARATED BY '.'.
            CONCATENATE lw_ewaybill-egen_time+0(2) lw_ewaybill-egen_time+2(2) lw_ewaybill-egen_time+4(2) INTO lt_time SEPARATED BY ':'.
            CONCATENATE lt_date lt_time INTO <fs_output>-ewbdt SEPARATED BY space.

            CONCATENATE lw_ewaybill-vdtodate+6(2) lw_ewaybill-vdtodate+4(2) lw_ewaybill-vdtodate+0(4) INTO lt_date SEPARATED BY '.'.
            CONCATENATE lw_ewaybill-vdtotime+0(2) lw_ewaybill-vdtotime+2(2) lw_ewaybill-vdtotime+4(2) INTO lt_time SEPARATED BY ':'.
            CONCATENATE lt_date lt_time INTO <fs_output>-ewbvalidtill SEPARATED BY space.
        ENDIF.
       ENDLOOP.
      ENDIF.
*  End of changes by C5310376
    ELSE.
      MESSAGE i000 WITH TEXT-t05.
      LEAVE LIST-PROCESSING.
    ENDIF.

  ENDMETHOD.


  METHOD FETCH_DATA.

*---Clear Exporting parameter
    CLEAR: ex_t_invrefnum,ex_t_ewaybill.    "SAP Note 2904222

    CASE c_x.
      WHEN gv_ob_inv.
        prep_ob_data( IMPORTING
                        ex_t_invrefnum = ex_t_invrefnum     "SAP Note 2904222
                        ex_t_ewaybill  = ex_t_ewaybill ).   "SAP Note 2904222
      WHEN gv_ob_dis.
        disp_tbl_data( ).
      WHEN OTHERS.
*---Do Nothing
    ENDCASE.

  ENDMETHOD.


  METHOD GET_DIRECTORY_PATH.

    DATA: l_text TYPE string.
*          l_app_dir TYPE dxlpath.

*---Clear Exporting parameter
    CLEAR: ex_dir,ex_dir1.

    l_text = TEXT-t04.

    IF im_fg EQ c_x.
      CALL METHOD cl_gui_frontend_services=>directory_browse
        EXPORTING
          window_title         = l_text
        CHANGING
          selected_folder      = ex_dir
        EXCEPTIONS
          cntl_error           = 1
          error_no_gui         = 2
          not_supported_by_gui = 3
          OTHERS               = 4.
      IF sy-subrc NE 0.
        CLEAR: l_text.
        MESSAGE i000 WITH TEXT-t33.
        LEAVE LIST-PROCESSING.
      ENDIF.
    ELSE.

      CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
        IMPORTING
          serverfile       = ex_dir1
        EXCEPTIONS
          canceled_by_user = 1
          OTHERS           = 2.
      IF sy-subrc NE 0.
        CLEAR: l_text.
        MESSAGE i000 WITH TEXT-t33.
        LEAVE LIST-PROCESSING.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD GET_FILENAME.

    DATA: lt_file_table TYPE STANDARD TABLE OF file_table,
          l_retcode     TYPE i.

    FIELD-SYMBOLS <lfs_file_table> TYPE file_table.

*---Clear Exporting Parameter
    CLEAR ex_file.

*---Dialog box to upload the file name
    CALL METHOD cl_gui_frontend_services=>file_open_dialog
      CHANGING
        file_table              = lt_file_table
        rc                      = l_retcode
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5.
    IF sy-subrc NE 0.
      MESSAGE i000 WITH TEXT-t34.
    ENDIF.

*---Copy file path to Selection Screen
    READ TABLE lt_file_table ASSIGNING <lfs_file_table>
       INDEX 1.
    IF sy-subrc EQ 0.
      ex_file = <lfs_file_table>-filename.
    ENDIF.

  ENDMETHOD.


  METHOD GET_FILES.

    DATA: l_filecount TYPE i.

*---Clear Exporting data
    CLEAR: ex_subrc,ex_t_fg_files,ex_t_bg_files.

    IF gv_fg EQ c_x.
      CALL METHOD cl_gui_frontend_services=>directory_list_files
        EXPORTING
          directory                   = gv_dir
          files_only                  = c_x
        CHANGING
          file_table                  = ex_t_fg_files
          count                       = l_filecount
        EXCEPTIONS
          cntl_error                  = 1
          directory_list_files_failed = 2
          wrong_parameter             = 3
          error_no_gui                = 4
          not_supported_by_gui        = 5
          OTHERS                      = 6.
      IF sy-subrc EQ 0.
        ex_subrc = sy-subrc.
      ELSE.
        ex_subrc = sy-subrc.
      ENDIF.
    ELSE.
      CALL FUNCTION 'RZL_READ_DIR_LOCAL'
        EXPORTING
          name               = gv_dir1
          nrlines            = 50000
        TABLES
          file_tbl           = ex_t_bg_files
        EXCEPTIONS
          argument_error     = 1
          not_found          = 2
          no_admin_authority = 3
          OTHERS             = 4.
      IF sy-subrc EQ 0.
        ex_subrc = sy-subrc.
      ELSE.
        ex_subrc = sy-subrc.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD GET_OB_DATA.

    DATA: lt_vbrk      TYPE ty_vbrk_tt,
          lt_vbrp      TYPE ty_vbrp_tt,
          lt_t001w     TYPE ty_t001w_tt,
          lt_bkpf      TYPE ty_bkpf_tt,
          lt_bseg      TYPE ty_bseg_tt,
          lt_1bbranch  TYPE ty_j_1bbranch_tt,
          lt_invrefnum TYPE ty_invrefnum1_tt,
          lt_vbrp_tmp  TYPE TABLE OF ty_vbrp,
          lt_bseg_tmp  TYPE TABLE OF ty_bseg,
          lt_t001w_tmp TYPE TABLE OF ty_t001w,
          lt_filedata  TYPE TABLE OF ty_filedata,          "SAP Note 2896060
*---Begin of SAP Note 2904222 Changes
          lt_filedata_tmp TYPE TABLE OF ty_filedata,
          lt_ewaybill  TYPE TABLE OF ty_ewaybill,
          lt_ewaybill_act TYPE TABLE OF ty_ewaybill,
          lr_gjahr     TYPE RANGE OF gjahr,
          lwa_gjahr    LIKE LINE  OF lr_gjahr,
          lr_docno     TYPE RANGE OF j_1ig_docno,
          lwa_docno    LIKE LINE  OF lr_docno,
          lr_doctyp    TYPE RANGE OF j_1ig_doctyp,
          lwa_doctyp   LIKE LINE  OF lr_doctyp,
*---End of SAP Note 2904222 Changes
          lr_vbeln     TYPE RANGE OF vbeln_vf,
          lr_bukrs     TYPE RANGE OF bukrs,
          lr_bupla     TYPE RANGE OF j_1bbranc_,
          lwa_bupla    LIKE LINE  OF lr_bupla.

    FIELD-SYMBOLS: <lfs_t001w> TYPE ty_t001w,
                   <lfs_vbrk>  TYPE ty_vbrk,           "SAP Note 2904222
                   <lfs_bkpf>  TYPE ty_bkpf,           "SAP Note 2904222
                   <lfs_bseg>  TYPE ty_bseg.

*---Clear Exporting data
    CLEAR: ex_t_vbrk,ex_t_bkpf,ex_t_vbrp,
           ex_t_t001w,ex_t_bseg,ex_t_1bbranch,
           ex_t_ewaybill,ex_t_ewaybill_act,ex_t_invrefnum.   "SAP Note 2904222

*---Begin of SAP Note 2896060 Changes
    lt_filedata = gt_filedata.
    DELETE: lt_filedata WHERE irn_status EQ c_cancel,
            lt_filedata WHERE odn        EQ space.
*---End of SAP Note 2896060 Changes

*---Begin of SAP Note 2904222 Changes
    IF lt_filedata IS INITIAL.
      lt_filedata_tmp = gt_filedata.
      DELETE lt_filedata_tmp WHERE irn_status NE c_cancel.
      IF lt_filedata_tmp IS INITIAL AND gt_canceldata IS INITIAL.
        MESSAGE i000 WITH TEXT-t24.
        LEAVE LIST-PROCESSING.
      ENDIF.
      CLEAR: lt_filedata_tmp.
    ENDIF.
*---End of SAP Note 2904222 Changes

    IF lt_filedata IS NOT INITIAL.

      IF gv_int_num_flag EQ c_x.

*---Get Billing Document data from VBRK, full Primay Key is passed
        SELECT vbeln fkart fkdat gjahr
               bukrs xblnr bupla
          FROM vbrk INTO TABLE lt_vbrk
          FOR ALL ENTRIES IN lt_filedata
          WHERE vbeln EQ lt_filedata-odn+0(10)
            AND fkdat EQ lt_filedata-doc_date
            AND bukrs EQ gv_bukrs
            AND sfakn EQ space
            AND fksto EQ space.
        IF sy-subrc EQ 0.
          SORT lt_vbrk BY vbeln.
        ENDIF.

        IF gv_bukrs IS NOT INITIAL AND
           gv_gjahr IS NOT INITIAL.
*---Get Accounting Document data from BKPF, full Primary Key is passed
          SELECT bukrs belnr gjahr blart
                 bldat budat xblnr
            FROM bkpf INTO TABLE lt_bkpf
            FOR ALL ENTRIES IN lt_filedata
            WHERE bukrs EQ gv_bukrs
              AND belnr EQ lt_filedata-odn+2(10)
              AND gjahr EQ gv_gjahr
              AND bldat EQ lt_filedata-doc_date
              AND stblg EQ space.
          IF sy-subrc EQ 0.
            SORT lt_bkpf BY bukrs belnr gjahr.
          ENDIF.
        ENDIF.
      ELSE.

*---Get Billing Document data from VBRK
        SELECT vbeln fkart fkdat gjahr
               bukrs xblnr bupla
          FROM vbrk INTO TABLE lt_vbrk
          FOR ALL ENTRIES IN lt_filedata
          WHERE vbeln IN lr_vbeln       "To skip ATC Check
            AND fkdat EQ lt_filedata-doc_date
            AND bukrs EQ gv_bukrs
            AND sfakn EQ space
            AND xblnr EQ lt_filedata-odn+0(16)
            AND fksto EQ space.
        IF sy-subrc EQ 0.
          SORT lt_vbrk BY vbeln.
        ENDIF.

        IF gv_bukrs IS NOT INITIAL AND
           gv_gjahr IS NOT INITIAL.
*---Get Accounting Document data from BKPF, partial Primary Key is passed
          SELECT bukrs belnr gjahr blart
                 bldat budat xblnr
            FROM bkpf INTO TABLE lt_bkpf
            FOR ALL ENTRIES IN lt_filedata
            WHERE bukrs EQ gv_bukrs
              AND gjahr EQ gv_gjahr
              AND bldat EQ lt_filedata-doc_date
              AND belnr EQ lt_filedata-odn+2(10)
*              AND xblnr EQ lt_filedata-odn+0(16)
              AND stblg EQ space.
          IF sy-subrc EQ 0.
            SORT lt_bkpf BY bukrs belnr gjahr.
          ENDIF.
        ENDIF.
      ENDIF.

*---Begin of SAP Note 2904222 Changes
      lt_filedata_tmp = gt_filedata.
      SORT lt_filedata_tmp BY ewbno.
      DELETE: ADJACENT DUPLICATES FROM lt_filedata_tmp COMPARING ewbno,
              lt_filedata_tmp WHERE ewbno IS INITIAL.
      IF lt_filedata_tmp IS NOT INITIAL.
*---Get data from Ewaybill table, partial Primary Key passed
        SELECT doctyp docno ebillno
          FROM j_1ig_ewaybill
          INTO TABLE lt_ewaybill
          FOR ALL ENTRIES IN lt_filedata_tmp
          WHERE bukrs   IN lr_bukrs
            AND ebillno EQ lt_filedata_tmp-ewbno
            AND status  IN (c_status_a,c_status_e).
        IF sy-subrc EQ 0.
          SORT lt_ewaybill BY ebillno.
        ENDIF.

        IF gv_gjahr IS NOT INITIAL.
          lwa_gjahr-sign   = c_sign_i.
          lwa_gjahr-option = c_sign_eq.
          lwa_gjahr-low    = gv_gjahr.
          APPEND lwa_gjahr TO lr_gjahr.
        ENDIF.

        lwa_docno-sign   = c_sign_i.
        lwa_docno-option = c_sign_eq.
        lwa_doctyp-sign   = c_sign_i.
        lwa_doctyp-option = c_sign_eq.

        LOOP AT lt_vbrk ASSIGNING <lfs_vbrk>.
          lwa_docno-low  = <lfs_vbrk>-vbeln.
          lwa_doctyp-low = <lfs_vbrk>-fkart.
          APPEND: lwa_docno  TO lr_docno,
                  lwa_doctyp TO lr_doctyp.
          CLEAR: lwa_docno-low,lwa_doctyp-low.
        ENDLOOP.

        LOOP AT lt_bkpf ASSIGNING <lfs_bkpf>.
          lwa_docno-low  = <lfs_bkpf>-belnr.
          lwa_doctyp-low = <lfs_bkpf>-blart.
          APPEND: lwa_docno  TO lr_docno,
                  lwa_doctyp TO lr_doctyp.
          CLEAR: lwa_docno-low,lwa_doctyp-low.
        ENDLOOP.

*---Get data from Ewaybill table, partial Primary Key passed
*---Hitting table second time as entry can exist with
*---Active status in table with different EWay Bill Number
        IF lr_docno IS NOT INITIAL.
          SELECT doctyp docno ebillno
            FROM j_1ig_ewaybill
            INTO TABLE lt_ewaybill_act
            WHERE bukrs  EQ gv_bukrs
              AND doctyp IN lr_doctyp
              AND docno  IN lr_docno
              AND gjahr  IN lr_gjahr
              AND status EQ c_status_a.
          IF sy-subrc EQ 0.
            SORT lt_ewaybill_act BY doctyp docno.
          ENDIF.
        ENDIF.
        CLEAR: lt_filedata_tmp.
      ENDIF.
*---End of SAP Note 2904222 Changes

*---Begin of SAP Note 2896060 Changes
      CLEAR: lt_filedata.
      lt_filedata = gt_filedata.
      DELETE lt_filedata WHERE irn_status EQ c_active.
*---End of SAP Note 2896060 Changes

      IF lt_vbrk IS INITIAL AND lt_bkpf IS INITIAL AND        "SAP Note 2896060
         lt_filedata IS INITIAL.                              "SAP Note 2896060
        MESSAGE i000 WITH TEXT-t23.
        LEAVE LIST-PROCESSING.
      ENDIF.

      lwa_bupla-sign   = c_sign_i.
      lwa_bupla-option = c_sign_eq.

      IF lt_vbrk IS NOT INITIAL.
*---Get Plant details, partial Primary Key is passed
        SELECT vbeln posnr werks
          FROM vbrp INTO TABLE lt_vbrp
          FOR ALL ENTRIES IN lt_vbrk
          WHERE vbeln EQ lt_vbrk-vbeln.
        IF sy-subrc EQ 0.
          SORT lt_vbrp BY vbeln posnr.
          lt_vbrp_tmp = lt_vbrp.
          SORT lt_vbrp_tmp BY werks.
          DELETE ADJACENT DUPLICATES FROM lt_vbrp_tmp COMPARING werks.
          IF lt_vbrp_tmp IS NOT INITIAL.
*---Get Business Place details, full Primary Key is passed
            SELECT werks j_1bbranch
              FROM t001w INTO TABLE lt_t001w
              FOR ALL ENTRIES IN lt_vbrp_tmp
              WHERE werks EQ lt_vbrp_tmp-werks.
            IF sy-subrc EQ 0.
              SORT lt_t001w BY werks.
              lt_t001w_tmp = lt_t001w.
              SORT lt_t001w_tmp BY j_1bbranch.
              DELETE ADJACENT DUPLICATES FROM lt_t001w_tmp COMPARING j_1bbranch.
              LOOP AT lt_t001w_tmp ASSIGNING <lfs_t001w>.
                CLEAR: lwa_bupla-low.
                lwa_bupla-low = <lfs_t001w>-j_1bbranch.
                APPEND lwa_bupla TO lr_bupla.
              ENDLOOP.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

      IF lt_bkpf IS NOT INITIAL.
*---Get required data, partial Primary Key is passed
        SELECT bukrs belnr gjahr
               koart bupla
          FROM bseg INTO TABLE lt_bseg
          FOR ALL ENTRIES IN lt_bkpf
          WHERE bukrs EQ lt_bkpf-bukrs
            AND belnr EQ lt_bkpf-belnr
            AND gjahr EQ lt_bkpf-gjahr
            AND koart EQ 'K'.
        IF sy-subrc EQ 0.
          SORT lt_bseg BY bukrs belnr gjahr.
          lt_bseg_tmp = lt_bseg.
          SORT lt_bseg_tmp BY bupla.
          DELETE ADJACENT DUPLICATES FROM lt_bseg_tmp COMPARING bupla.
          LOOP AT lt_bseg_tmp ASSIGNING <lfs_bseg>.
            CLEAR: lwa_bupla-low.
            lwa_bupla-low = <lfs_bseg>-bupla.
            APPEND lwa_bupla TO lr_bupla.
          ENDLOOP.
        ENDIF.
      ENDIF.

*---Get GSTIN details, full Primary Key is passed
      IF lr_bupla[] IS NOT INITIAL.
        SELECT bukrs branch gstin
          FROM j_1bbranch
          INTO TABLE lt_1bbranch
          WHERE bukrs  EQ gv_bukrs
            AND branch IN lr_bupla.
        IF sy-subrc EQ 0.
          SORT lt_1bbranch BY bukrs branch.
        ENDIF.
      ENDIF.

      IF gv_int_num_flag EQ c_space.
        SORT lt_vbrk BY xblnr.
        SORT lt_bkpf BY bukrs xblnr gjahr.
      ENDIF.

      ex_t_vbrk      = lt_vbrk.
      ex_t_vbrp      = lt_vbrp.
      ex_t_t001w     = lt_t001w.
      ex_t_bkpf      = lt_bkpf.
      ex_t_bseg      = lt_bseg.
      ex_t_1bbranch  = lt_1bbranch.
      ex_t_ewaybill  = lt_ewaybill.                        "SAP Note 2904222
      ex_t_ewaybill_act = lt_ewaybill_act.                 "SAP Note 2904222

    ENDIF.

*---Begin of SAP Note 2896060 Changes
    IF gt_filedata IS NOT INITIAL.
*---Get required data from j_1ig_invrefnum, partial Primary Key is used
      SELECT bukrs docno doc_year doc_type odn
             irn version bupla odn_date
             ack_no ack_date irn_status cancel_date
        FROM j_1ig_invrefnum
        INTO TABLE lt_invrefnum
        FOR ALL ENTRIES IN gt_filedata
        WHERE bukrs IN lr_bukrs           "To skip ATC Check
          AND irn EQ gt_filedata-irn.
      IF sy-subrc EQ 0.
        SORT lt_invrefnum BY irn version DESCENDING.
        ex_t_invrefnum = lt_invrefnum.
      ENDIF.
    ENDIF.
*---End of SAP Note 2896060 Changes

  ENDMETHOD.


  METHOD INIT_SEL_SCREEN.

    TYPE-POOLS sscr.

    DATA: lwa_opt_list TYPE sscr_opt_list,
          lwa_restrict TYPE sscr_restrict,
          lwa_as       TYPE sscr_ass.

    gv_cloud_check = cl_cos_utilities=>is_s4h_cloud( ).

*---Create the data for the restricted access to select option.
    lwa_opt_list-name       = c_opt_list.
    lwa_opt_list-options-eq = c_x.
    APPEND lwa_opt_list TO lwa_restrict-opt_list_tab.

*---Associate the select option to the option list
    lwa_as-kind    = c_kind_s.
    lwa_as-sg_main = c_sign_i.
    lwa_as-op_main = c_opt_list.
    lwa_as-name    = c_s_stat.
    APPEND lwa_as TO lwa_restrict-ass_tab.

    lwa_as-name    = c_s_bp.
    APPEND lwa_as TO lwa_restrict-ass_tab.

*---Restrict the Select Option
    CALL FUNCTION 'SELECT_OPTIONS_RESTRICT'
      EXPORTING
        restriction            = lwa_restrict
      EXCEPTIONS
        too_late               = 1
        repeated               = 2
        selopt_without_options = 3
        selopt_without_signs   = 4
        invalid_sign           = 5
        empty_option_list      = 6
        invalid_kind           = 7
        repeated_kind_a        = 8
        OTHERS                 = 9.
    IF sy-subrc NE 0.
      MESSAGE w000 WITH TEXT-t01.
    ENDIF.

  ENDMETHOD.


  METHOD LOCK_UNLOCK_TABLES.

    FIELD-SYMBOLS: <lfs_table> LIKE LINE OF im_t_tables.

*---Clear Exporting data
    CLEAR: ex_lock.

    LOOP AT im_t_tables ASSIGNING <lfs_table>.
      CLEAR ex_lock.
      IF im_lock EQ c_x.
        CALL FUNCTION 'ENQUEUE_E_TABLE'
          EXPORTING
            mode_rstable   = c_mode
            tabname        = <lfs_table>-low
          EXCEPTIONS
            foreign_lock   = 1
            system_failure = 2
            OTHERS         = 3.
        IF sy-subrc EQ 0.
          ex_lock = c_x.
        ELSE.
          EXIT.
        ENDIF.
      ELSE.
*---Unlock the table
        CALL FUNCTION 'DEQUEUE_E_TABLE'
          EXPORTING
            mode_rstable = c_mode
            tabname      = <lfs_table>-low.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD MAIN.

    DATA: lt_invrefnum TYPE STANDARD TABLE OF j_1ig_invrefnum,    "SAP Note 2904222
          lt_ewaybill  TYPE STANDARD TABLE OF j_1ig_ewaybill.     "SAP Note 2904222

*---Selection Screen validation
    val_sel_screen( ).

*---Clear Global data
    clear_global_data( ).

*---Process data
    fetch_data( IMPORTING
                  ex_t_invrefnum = lt_invrefnum         "SAP Note 2904222
                  ex_t_ewaybill  = lt_ewaybill ).       "SAP Note 2904222

*---Database Update
    IF lt_invrefnum IS NOT INITIAL.
      update_db( EXPORTING                              "SAP Note 2904222
                   im_t_invrefnum = lt_invrefnum        "SAP Note 2904222
                   im_t_ewaybill  = lt_ewaybill ).      "SAP Note 2904222
    ENDIF.

  ENDMETHOD.


  METHOD OB_BULK_DATA.

    DATA: lt_fg_files  TYPE TABLE OF file_info,
          lt_bg_files  TYPE TABLE OF salfldir,
          lt_file_data TYPE TABLE OF string,    "SAP Note 2896060
          lwa_data     TYPE string,
          lwa_data1    TYPE string,             "SAP Note 2896060
          lwa_filedata TYPE ty_filedata,
          l_count      TYPE i,                  "SAP Note 2896060
          l_file       TYPE string,
          l_path       TYPE string,
          l_subrc      TYPE sysubrc.
    DATA: l_call_badi TYPE REF TO badi_j1ig_einvoice.
    DATA: ls_canceldata TYPE ty_filedata.

    FIELD-SYMBOLS: <lfs_file>  TYPE file_info,
                   <lfs_file1> TYPE salfldir.

*---Clear Exporting data
    CLEAR: ex_t_vbrk,ex_t_vbrp,ex_t_bkpf,ex_t_t001w,ex_t_bseg,
           ex_t_1bbranch,ex_t_ewaybill,ex_t_ewaybill_act,ex_t_invrefnum.    "SAP Note 2904222

*---Foreground radio button
    IF gv_fg EQ c_x.
      get_files( IMPORTING
                   ex_subrc      = l_subrc
                   ex_t_fg_files = lt_fg_files ).
      IF l_subrc EQ 0 AND lt_fg_files IS INITIAL.
        MESSAGE i000 WITH TEXT-t25.
        LEAVE LIST-PROCESSING.
      ELSEIF l_subrc NE 0.
        MESSAGE i000 WITH TEXT-t32.
        LEAVE LIST-PROCESSING.
      ENDIF.

      LOOP AT lt_fg_files ASSIGNING <lfs_file>.
        CLEAR l_file.
        CONCATENATE gv_dir '\' <lfs_file>-filename INTO l_file.
        prep_file_data( EXPORTING
                          im_value = l_file ).

      ENDLOOP.

*---Background radio button
    ELSEIF gv_bg EQ c_x.
      get_files( IMPORTING
                   ex_subrc      = l_subrc
                   ex_t_bg_files = lt_bg_files ).
      IF l_subrc EQ 0 AND lt_bg_files IS INITIAL.
        MESSAGE i000 WITH TEXT-t25.
        LEAVE LIST-PROCESSING.
      ELSEIF l_subrc NE 0.
        MESSAGE i000 WITH TEXT-t32.
        LEAVE LIST-PROCESSING.
      ENDIF.

      LOOP AT lt_bg_files ASSIGNING <lfs_file1>.
        CLEAR: l_path,l_count,lt_file_data.                   "SAP Note 2896060
        IF  <lfs_file1>-name IS NOT INITIAL.
          CONCATENATE gv_dir1 '/' <lfs_file1>-name INTO l_path.
          TRY.
              CALL FUNCTION 'FILE_VALIDATE_NAME'
                EXPORTING
                  logical_filename           = 'J_1IG_IRN_REPORT'
                CHANGING
                  physical_filename          = l_path
                EXCEPTIONS
                  logical_filename_not_found = 1
                  validation_failed          = 2
                  OTHERS                     = 3.
              IF sy-subrc EQ 0.

                OPEN DATASET l_path FOR INPUT IN TEXT MODE ENCODING DEFAULT.
                IF sy-subrc EQ 0.
                  DO.
                    CLEAR lwa_data.
*---Reads each line of file individually
                    READ DATASET l_path INTO lwa_data.
                    IF sy-subrc EQ 0.
*---Begin of SAP Note 2896060 Changes
                      CLEAR: lwa_data1.
                      lwa_data1 = lwa_data.
                      l_count = l_count + 1.
*---End of SAP Note 2896060 Changes
                      seg_file_data( EXPORTING
                                       im_data = lwa_data
                                     CHANGING
                                       ch_filedata = lwa_filedata ).
                    ELSE.
                      EXIT.
                    ENDIF.
                  ENDDO.

*---Begin of SAP Note 2896060 Changes
                  IF l_count EQ 1.
                    IF lwa_data1 CS 'AckNo'.
                      REPLACE: ALL OCCURRENCES OF '{' IN lwa_data1 WITH space,
                               ALL OCCURRENCES OF '}' IN lwa_data1 WITH space.
                      SPLIT lwa_data1 AT ',' INTO TABLE lt_file_data.
                      col_file_data( EXPORTING
                                       im_t_file_data = lt_file_data ).
                    ENDIF.
                  ELSE.
*---End of SAP Note 2896060 Changes
                  IF lwa_filedata-signed_qrcode IS NOT INITIAL.
                    decode_qrcode( EXPORTING
                                     im_qrcode    = lwa_filedata-signed_qrcode
                                   IMPORTING
                                     ex_odn       = lwa_filedata-odn
                                     ex_doc_date  = lwa_filedata-doc_date
                                     ex_sel_gstin = lwa_filedata-sel_gstin ).
                  ENDIF.
                  IF lwa_filedata IS NOT INITIAL.
                      IF lwa_filedata-cancel_date IS NOT INITIAL OR lwa_filedata-irn_status EQ c_cancel.      " SAP Note 2973308 Cancellation
                        APPEND lwa_filedata TO gt_canceldata.
                      ELSE.
                        APPEND lwa_filedata TO gt_filedata.
                      ENDIF.
                  ENDIF.
                  ENDIF.                  "SAP Note 2896060
                  CLEAR lwa_filedata.
                ENDIF.
              ENDIF.
            CATCH cx_root.
*---Do Nothing
          ENDTRY.
          CLOSE DATASET l_path.
        ENDIF.
      ENDLOOP.
    ENDIF.

    IF gt_filedata IS INITIAL AND gt_canceldata IS INITIAL.
      MESSAGE i000 WITH TEXT-t24.
      LEAVE LIST-PROCESSING.
    ELSE.
      IF gv_automate_process EQ c_x.  " for edocument table updatation

        IF gt_canceldata IS NOT INITIAL.
          LOOP AT gt_canceldata INTO ls_canceldata.
            APPEND ls_canceldata TO gt_filedata.
            CLEAR ls_canceldata.
          ENDLOOP.
          REFRESH gt_canceldata.
        ENDIF.

        GET BADI l_call_badi.
        CALL BADI l_call_badi->update_data
          EXPORTING
            im_bukrs    = gv_bukrs
            im_bupla    = gv_bp
            im_gjahr    = gv_gjahr
            ct_filedata = gt_filedata
          CHANGING
            ct_output   = gt_output.
      ELSE.
        get_ob_data( IMPORTING
                     ex_t_vbrk      = ex_t_vbrk
                     ex_t_vbrp      = ex_t_vbrp
                     ex_t_t001w     = ex_t_t001w
                     ex_t_bkpf      = ex_t_bkpf
                     ex_t_bseg      = ex_t_bseg
                     ex_t_1bbranch  = ex_t_1bbranch
                     ex_t_ewaybill  = ex_t_ewaybill           "SAP Note 2904222
                     ex_t_ewaybill_act = ex_t_ewaybill_act    "SAP Note 2904222
                     ex_t_invrefnum = ex_t_invrefnum ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD ob_sing_data.

    DATA: l_subrc TYPE i,
          l_value TYPE string.

    DATA: l_call_badi TYPE REF TO badi_j1ig_einvoice.
    DATA: ls_canceldata TYPE ty_filedata.

*---Clear Exporting data
    CLEAR: ex_t_vbrk,ex_t_bkpf,ex_t_vbrp,ex_t_t001w,ex_t_bseg,
           ex_t_1bbranch,ex_t_ewaybill,ex_t_ewaybill_act,ex_t_invrefnum.        "SAP Note 2904222

    l_value = gv_file.
    prep_file_data( EXPORTING
                      im_value = l_value
                    IMPORTING
                      ex_subrc = l_subrc ).
    IF gt_filedata IS INITIAL AND gt_canceldata IS INITIAL. "SAP Note 2973308
      IF l_subrc NE 0.
        MESSAGE i000 WITH TEXT-t35.
        LEAVE LIST-PROCESSING.
      ELSE.
        MESSAGE i000 WITH TEXT-t24.
        LEAVE LIST-PROCESSING.
      ENDIF.
    ELSE.
BREAK primus.
      IF gv_automate_process EQ c_x.  " for edocument table updatation

        IF gt_canceldata IS NOT INITIAL.
          LOOP AT gt_canceldata INTO ls_canceldata.
            APPEND ls_canceldata TO gt_filedata.
            CLEAR ls_canceldata.
          ENDLOOP.
          REFRESH gt_canceldata.
        ENDIF.
        GET BADI l_call_badi.
        CALL BADI l_call_badi->update_data
          EXPORTING
            im_bukrs    = gv_bukrs
            im_bupla    = gv_bp
            im_gjahr    = gv_gjahr
            ct_filedata = gt_filedata
          CHANGING
            ct_output   = gt_output.
      ELSE.
        get_ob_data( IMPORTING
                     ex_t_vbrk      = ex_t_vbrk
                     ex_t_vbrp      = ex_t_vbrp
                     ex_t_t001w     = ex_t_t001w
                     ex_t_bkpf      = ex_t_bkpf
                     ex_t_bseg      = ex_t_bseg
                     ex_t_1bbranch  = ex_t_1bbranch
                     ex_t_ewaybill  = ex_t_ewaybill            "SAP Note 2904222
                     ex_t_ewaybill_act = ex_t_ewaybill_act     "SAP Note 2904222
                     ex_t_invrefnum = ex_t_invrefnum ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD PREP_CANCEL_DATA.

    TYPES : BEGIN OF ty_ewaybill,
              bukrs  TYPE bukrs,
              doctyp TYPE j_1ig_doctyp,
              docno  TYPE j_1ig_docno,
              gjahr  TYPE gjahr,
              status TYPE j_1ig_stat,
            END OF ty_ewaybill.

    DATA: lt_cninvrefnum  TYPE TABLE OF ty_invrefnum1,
          lr_bukrs        TYPE RANGE OF bukrs,
          lwa_cninvrefnum TYPE ty_invrefnum1,
          lt_cnewaybill   TYPE TABLE OF ty_ewaybill,
          lwa_cnewaybill  TYPE ty_ewaybill,
          lwa_invrefnum   TYPE j_1ig_invrefnum,
          lwa_output      TYPE ty_output.

    FIELD-SYMBOLS: <lfs_filedata>  TYPE ty_filedata.

*
    IF gt_canceldata[] IS NOT INITIAL.
      SELECT bukrs docno doc_year doc_type odn
             irn version bupla odn_date
             ack_no ack_date irn_status cancel_date
        FROM j_1ig_invrefnum
        INTO TABLE lt_cninvrefnum
        FOR ALL ENTRIES IN gt_canceldata
        WHERE bukrs EQ gv_bukrs  "IN lr_bukrs           "To skip ATC Check
          AND doc_year EQ gv_gjahr
          AND irn EQ gt_canceldata-irn.
      IF sy-subrc EQ 0.
        SORT lt_cninvrefnum BY irn version DESCENDING.
        SELECT  bukrs doctyp docno gjahr status
               FROM j_1ig_ewaybill INTO TABLE lt_cnewaybill
               FOR ALL ENTRIES IN lt_cninvrefnum
               WHERE bukrs EQ gv_bukrs AND "IN lr_bukrs AND
                     doctyp EQ lt_cninvrefnum-doc_type AND
                     docno EQ lt_cninvrefnum-docno AND
                     gjahr EQ lt_cninvrefnum-doc_year.
        IF sy-subrc EQ 0.
          SORT lt_cnewaybill BY doctyp docno gjahr.
        ENDIF.
      ENDIF.
    ENDIF.

    LOOP AT gt_canceldata ASSIGNING <lfs_filedata>.
      READ TABLE lt_cninvrefnum INTO lwa_cninvrefnum
        WITH KEY irn = <lfs_filedata>-irn.
      IF sy-subrc EQ 0.
        <lfs_filedata>-ack_no = lwa_cninvrefnum-ack_no.
        <lfs_filedata>-ack_date = lwa_cninvrefnum-ack_date.
        <lfs_filedata>-odn = lwa_cninvrefnum-odn.
        <lfs_filedata>-irn_status = lwa_cninvrefnum-irn_status.
        IF lwa_cninvrefnum-irn_status EQ c_active.
          READ TABLE lt_cnewaybill INTO lwa_cnewaybill
            WITH KEY docno = lwa_cninvrefnum-docno.
*          IF sy-subrc EQ 0 AND lwa_cnewaybill-status NE c_status_a.
           IF lwa_cnewaybill-status NE c_status_a.
            MOVE-CORRESPONDING lwa_cninvrefnum TO lwa_invrefnum.
            lwa_invrefnum-version     = lwa_cninvrefnum-version + 1.
            lwa_invrefnum-irn_status  = c_cancel.
            lwa_invrefnum-cancel_date = <lfs_filedata>-cancel_date.
            lwa_invrefnum-ernam       = sy-uname.
            lwa_invrefnum-erdat       = sy-datum.
            lwa_invrefnum-erzet       = sy-uzeit.
            CLEAR: lwa_invrefnum-ack_no,lwa_invrefnum-ack_date,
                   lwa_invrefnum-signed_inv,lwa_invrefnum-signed_qrcode.
            APPEND lwa_invrefnum TO ex_t_invrefnum.
          ELSE.
            MOVE-CORRESPONDING: <lfs_filedata> TO lwa_output.
            lwa_output-indicator = c_red_light.
            lwa_output-message   = TEXT-t51.
            APPEND lwa_output TO gt_output.
          ENDIF.
        ELSE.
          MOVE-CORRESPONDING: <lfs_filedata> TO lwa_output.
          lwa_output-indicator = c_red_light.
          lwa_output-message   = TEXT-t50.
          APPEND lwa_output TO gt_output.
        ENDIF.
      ELSE.
        MOVE-CORRESPONDING: <lfs_filedata> TO lwa_output.
        lwa_output-indicator = c_red_light.
        lwa_output-message   = TEXT-t39.
        APPEND lwa_output TO gt_output.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD PREP_FILE_DATA.

    DATA: lt_file_data TYPE TABLE OF string,
          lt_file_data_tmp TYPE TABLE OF string,    "SAP Note 2896060
          lwa_data TYPE string.                     "SAP Note 2896060

*---Clear Exporting data
    CLEAR: ex_subrc.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = im_value
        filetype                = c_asc
      CHANGING
        data_tab                = lt_file_data
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.
    IF sy-subrc EQ 0.
*---Begin of SAP Note 2896060 Changes
      IF lines( lt_file_data ) EQ 1.
        LOOP AT lt_file_data INTO lwa_data.
          REPLACE: ALL OCCURRENCES OF '{' IN lwa_data WITH space,
                   ALL OCCURRENCES OF '}' IN lwa_data WITH space.
          SPLIT lwa_data AT ',' INTO TABLE lt_file_data_tmp.
        ENDLOOP.
        CLEAR: lt_file_data.
        lt_file_data = lt_file_data_tmp.
      ENDIF.

      col_file_data( EXPORTING
                       im_t_file_data = lt_file_data ).
*---End of SAP Note 2896060 Changes
    ELSE.
      ex_subrc = sy-subrc.
    ENDIF.

  ENDMETHOD.


  METHOD PREP_OB_DATA.

    DATA: lt_vbrk      TYPE TABLE OF ty_vbrk,
          lt_vbrp      TYPE TABLE OF ty_vbrp,
          lt_t001w     TYPE TABLE OF ty_t001w,
          lt_bkpf      TYPE TABLE OF ty_bkpf,
          lt_bseg      TYPE TABLE OF ty_bseg,
          lt_1bbranch  TYPE TABLE OF ty_j_1bbranch,
          lt_ewaybill  TYPE TABLE OF ty_ewaybill,       "SAP Note 2904222
          lt_ewaybill_act TYPE TABLE OF ty_ewaybill,    "SAP Note 2904222
          lt_invrefnum TYPE ty_invrefnum1_tt,
          lt_cninvrefnum  TYPE ty_invrefnum_tt,         "SAP Note 2973308 cancellation
          lwa_cninvrefnum TYPE j_1ig_invrefnum.          "SAP Note 2973308 cancellation

*---Clear Exporting parameter
    CLEAR: ex_t_invrefnum,ex_t_ewaybill.

    IF gv_sing EQ c_x.
      ob_sing_data( IMPORTING
                      ex_t_vbrk      = lt_vbrk
                      ex_t_vbrp      = lt_vbrp
                      ex_t_t001w     = lt_t001w
                      ex_t_bkpf      = lt_bkpf
                      ex_t_bseg      = lt_bseg
                      ex_t_1bbranch  = lt_1bbranch
                      ex_t_ewaybill  = lt_ewaybill          "SAP Note 2904222
                      ex_t_ewaybill_act = lt_ewaybill_act   "SAP Note 2904222
                      ex_t_invrefnum = lt_invrefnum ).
    ELSEIF gv_bulk EQ c_x.
      ob_bulk_data( IMPORTING
                      ex_t_vbrk      = lt_vbrk
                      ex_t_vbrp      = lt_vbrp
                      ex_t_t001w     = lt_t001w
                      ex_t_bkpf      = lt_bkpf
                      ex_t_bseg      = lt_bseg
                      ex_t_1bbranch  = lt_1bbranch
                      ex_t_ewaybill  = lt_ewaybill          "SAP Note 2904222
                      ex_t_ewaybill_act = lt_ewaybill_act   "SAP Note 2904222
                      ex_t_invrefnum = lt_invrefnum ).
    ENDIF.

    IF lt_vbrk IS NOT INITIAL OR lt_bkpf IS NOT INITIAL.
      proc_ob_data( EXPORTING
                      im_t_vbrk          = lt_vbrk
                      im_t_vbrp          = lt_vbrp
                      im_t_t001w         = lt_t001w
                      im_t_bkpf          = lt_bkpf
                      im_t_bseg          = lt_bseg
                      im_t_1bbranch      = lt_1bbranch
                      im_t_invrefnum     = lt_invrefnum
                      im_t_ewaybill      = lt_ewaybill       "SAP Note 2904222
                      im_t_ewaybill_act  = lt_ewaybill_act   "SAP Note 2904222
                    IMPORTING
                      ex_t_invrefnum_upd = ex_t_invrefnum      "SAP Note 2904222
                      ex_t_ewaybill_upd  = ex_t_ewaybill ).   "SAP Note 2904222
    ENDIF.

*   Begin of changes for SAP Note 2973308 cancellation
    IF gt_canceldata[] IS NOT INITIAL.
      CALL METHOD me->prep_cancel_data
        IMPORTING
          ex_t_invrefnum = lt_cninvrefnum.
      IF lt_cninvrefnum[] IS NOT INITIAL.
        LOOP AT lt_cninvrefnum INTO lwa_cninvrefnum.
          APPEND lwa_cninvrefnum TO ex_t_invrefnum.
          CLEAR lwa_cninvrefnum.
        ENDLOOP.
      ENDIF.
    ENDIF.
* End of changes for SAP Note 2973308 cancellation

  ENDMETHOD.


  METHOD PROC_OB_DATA.

    DATA: lwa_invrefnum  TYPE j_1ig_invrefnum,
          lwa_invrefnum1 TYPE ty_invrefnum1,
          lwa_ewaybill   TYPE j_1ig_ewaybill,       "SAP Note 2904222
          l_error        TYPE flag,                 "SAP Note 2904222
          l_fname1       TYPE string,
          l_fname2       TYPE string,
          lwa_output     TYPE ty_output.

    FIELD-SYMBOLS: <lfs_filedata>  TYPE ty_filedata,
                   <lfs_vbrk>      TYPE ty_vbrk,
                   <lfs_vbrp>      TYPE ty_vbrp,
                   <lfs_t001w>     TYPE ty_t001w,
                   <lfs_bkpf>      TYPE ty_bkpf,
                   <lfs_bseg>      TYPE ty_bseg,
                   <lfs_1bbranch>  TYPE ty_j_1bbranch.

*---Clear Exporting parameter
    CLEAR: ex_t_invrefnum_upd,ex_t_ewaybill_upd.

    IF gv_int_num_flag EQ c_x.
      l_fname1 = 'VBELN'.
      l_fname2 = 'BELNR'.
    ELSE.
      l_fname1 = l_fname2 = 'XBLNR'.
    ENDIF.

    LOOP AT gt_filedata ASSIGNING <lfs_filedata>.
      CLEAR: lwa_output,lwa_invrefnum,lwa_invrefnum1,l_error.       "SAP Note 2904222
      IF <lfs_filedata>-irn_status EQ c_active.
        MOVE-CORRESPONDING: <lfs_filedata> TO lwa_output,
                            <lfs_filedata> TO lwa_invrefnum.

*---Can't use the Binary Search as we need the latest entry
        READ TABLE im_t_invrefnum INTO lwa_invrefnum1
          WITH KEY irn = <lfs_filedata>-irn.
        IF sy-subrc EQ 0 AND lwa_invrefnum1-irn_status EQ c_active.
          MOVE-CORRESPONDING: lwa_invrefnum1 TO lwa_output.
          lwa_output-indicator = c_red_light.
          lwa_output-message   = TEXT-t26.
          APPEND lwa_output TO gt_output.
        ELSEIF lwa_invrefnum1-irn_status EQ c_cancel.
          MOVE-CORRESPONDING: lwa_invrefnum1 TO lwa_output.
          lwa_output-indicator = c_red_light.
          lwa_output-message   = TEXT-t50.
          APPEND lwa_output TO gt_output.
        ELSEIF <lfs_filedata>-odn           IS INITIAL OR
               <lfs_filedata>-irn           IS INITIAL OR
               <lfs_filedata>-signed_qrcode IS INITIAL OR
               <lfs_filedata>-signed_inv    IS INITIAL.
          lwa_output-indicator = c_red_light.
          lwa_output-message   = TEXT-t20.
          APPEND lwa_output TO gt_output.
        ELSEIF lwa_invrefnum1 IS NOT INITIAL.
          CLEAR: lwa_invrefnum.
          MOVE-CORRESPONDING: lwa_invrefnum1 TO lwa_invrefnum.
          CLEAR: lwa_invrefnum-cancel_date.
          lwa_invrefnum-version       = lwa_invrefnum1-version + 1.
          lwa_invrefnum-ack_no        = <lfs_filedata>-ack_no.
          lwa_invrefnum-ack_date      = <lfs_filedata>-ack_date.
          lwa_invrefnum-irn_status    = c_active.
          lwa_invrefnum-ernam         = sy-uname.
          lwa_invrefnum-erdat         = sy-datum.
          lwa_invrefnum-erzet         = sy-uzeit.
          lwa_invrefnum-signed_inv    = <lfs_filedata>-signed_inv.
          lwa_invrefnum-signed_qrcode = <lfs_filedata>-signed_qrcode.
          APPEND lwa_invrefnum TO ex_t_invrefnum_upd.
        ELSE.
          READ TABLE im_t_vbrk ASSIGNING <lfs_vbrk>
            WITH KEY (l_fname1) = <lfs_filedata>-odn
                     BINARY SEARCH.
          IF sy-subrc EQ 0.
            lwa_output-bukrs = lwa_invrefnum-bukrs = <lfs_vbrk>-bukrs.
            lwa_output-docno = lwa_invrefnum-docno = <lfs_vbrk>-vbeln.

            IF l_fname1 EQ 'VBELN'.
              lwa_output-odn = lwa_invrefnum-odn = <lfs_vbrk>-xblnr.
            ENDIF.

            IF <lfs_vbrk>-gjahr IS NOT INITIAL.
              lwa_invrefnum-doc_year = <lfs_vbrk>-gjahr.
            ELSEIF lwa_invrefnum-bukrs IS NOT INITIAL.
*---Begin of SAP Note 2904222 Changes
              CALL FUNCTION 'GET_CURRENT_YEAR'
               EXPORTING
                 bukrs   = <lfs_vbrk>-bukrs
                 date    = <lfs_vbrk>-fkdat
               IMPORTING
                 curry   = lwa_invrefnum-doc_year.
*---End of SAP Note 2904222 Changes
            ENDIF.

            lwa_output-doc_type = lwa_invrefnum-doc_type  = <lfs_vbrk>-fkart.
            lwa_output-doc_year = lwa_invrefnum-doc_year.

*---Begin of SAP Note 2896060 Changes
            IF <lfs_vbrk>-bukrs IS NOT INITIAL AND <lfs_vbrk>-bukrs NE gv_bukrs.
              lwa_output-indicator = c_red_light.
              CONCATENATE TEXT-t40 TEXT-t41 INTO lwa_output-message SEPARATED BY space.
              REPLACE: '&1' WITH <lfs_vbrk>-bukrs INTO lwa_output-message,
                       '&2' WITH gv_bukrs         INTO lwa_output-message.
              APPEND lwa_output TO gt_output.
            ELSE.
*---End of SAP Note 2896060 Changes
            lwa_invrefnum-version  = 1.

            IF <lfs_vbrk>-bupla IS INITIAL.
*---Can't use the Binary Search as we need the first entry
              READ TABLE im_t_vbrp ASSIGNING <lfs_vbrp>
                WITH KEY vbeln = <lfs_vbrk>-vbeln.
              IF sy-subrc EQ 0.
                READ TABLE im_t_t001w ASSIGNING <lfs_t001w>
                  WITH KEY werks = <lfs_vbrp>-werks
                  BINARY SEARCH.
                IF sy-subrc EQ 0.
                  lwa_invrefnum-bupla = <lfs_t001w>-j_1bbranch.
                ENDIF.
              ENDIF.
            ELSE.
              lwa_invrefnum-bupla  = <lfs_vbrk>-bupla.
            ENDIF.
            IF lwa_invrefnum-bupla IS INITIAL.
              lwa_output-indicator = c_red_light.
              lwa_output-message   = TEXT-t27.
              APPEND lwa_output TO gt_output.
            ELSE.
              IF gv_bp IS NOT INITIAL AND lwa_invrefnum-bupla NE gv_bp.
                lwa_output-indicator = c_red_light.
                CONCATENATE TEXT-t28 TEXT-t29 INTO lwa_output-message SEPARATED BY space.
                REPLACE: '&1' WITH lwa_invrefnum-bupla INTO lwa_output-message,
                         '&2' WITH gv_bp               INTO lwa_output-message.
                APPEND lwa_output TO gt_output.
              ELSE.
                READ TABLE im_t_1bbranch ASSIGNING <lfs_1bbranch>
                  WITH KEY bukrs  = gv_bukrs
                           branch = lwa_invrefnum-bupla
                    BINARY SEARCH.
                IF sy-subrc EQ 0.
                  IF <lfs_1bbranch>-gstin IS INITIAL.
                    lwa_output-indicator = c_red_light.
                    lwa_output-message   = TEXT-t30.
                    APPEND lwa_output TO gt_output.
                  ELSEIF <lfs_1bbranch>-gstin NE <lfs_filedata>-sel_gstin.
                    lwa_output-indicator = c_red_light.
                    lwa_output-message   = TEXT-t31.
                    REPLACE: '&1' WITH <lfs_1bbranch>-gstin     INTO lwa_output-message,
                             '&2' WITH <lfs_filedata>-sel_gstin INTO lwa_output-message.
                    APPEND lwa_output TO gt_output.
                  ELSE.
*---Begin of SAP Note 2904222 Changes
                    IF <lfs_filedata>-ewbno  IS NOT INITIAL AND
                        <lfs_filedata>-ewbdt IS NOT INITIAL.
                      val_prep_ebill( EXPORTING
                                        im_t_ewaybill     = im_t_ewaybill
                                        im_t_ewaybill_act = im_t_ewaybill_act
                                        im_invrefnum      = lwa_invrefnum
                                        im_filedata       = <lfs_filedata>
                                        im_output         = lwa_output
                                      IMPORTING
                                        ex_error          = l_error
                                        ex_ewaybill       = lwa_ewaybill ).
                    ENDIF.
                    IF l_error EQ space.
*---End of SAP Note 2904222 Changes
                    lwa_invrefnum-odn_date = <lfs_vbrk>-fkdat.
                    lwa_invrefnum-ernam    = sy-uname.
                    lwa_invrefnum-erdat    = sy-datum.
                    lwa_invrefnum-erzet    = sy-uzeit.
                    APPEND lwa_invrefnum TO ex_t_invrefnum_upd.
*---Begin of SAP Note 2904222 Changes
                      IF lwa_ewaybill IS NOT INITIAL.
                        APPEND lwa_ewaybill TO ex_t_ewaybill_upd.
                          CLEAR lwa_ewaybill.
                        ENDIF.
                    ENDIF.
*---End of SAP Note 2904222 Changes
                  ENDIF.
                ELSE.
                  lwa_output-indicator = c_red_light.
                  lwa_output-message   = TEXT-t30.
                  APPEND lwa_output TO gt_output.
                ENDIF.
              ENDIF.
            ENDIF.
            ENDIF.                                          "SAP Note 2896060
          ELSE.
            READ TABLE im_t_bkpf ASSIGNING <lfs_bkpf>
              WITH KEY bukrs      = gv_bukrs
*                       (l_fname2) = <lfs_filedata>-odn
                       belnr = <lfs_filedata>-odn+2(10)
                       gjahr      = gv_gjahr
                       BINARY SEARCH.
            IF sy-subrc EQ 0.
              lwa_output-bukrs = lwa_invrefnum-bukrs = <lfs_bkpf>-bukrs.
              lwa_output-docno = lwa_invrefnum-docno = <lfs_bkpf>-belnr.

              IF l_fname2 EQ 'XBLNR'.
                lwa_output-odn = lwa_invrefnum-odn = <lfs_bkpf>-belnr."xblnr.
              ENDIF.

              lwa_output-doc_year = lwa_invrefnum-doc_year = <lfs_bkpf>-gjahr.
              lwa_output-doc_type = lwa_invrefnum-doc_type = <lfs_bkpf>-blart.
              lwa_invrefnum-version  = 1.
              READ TABLE im_t_bseg ASSIGNING <lfs_bseg>
                WITH KEY bukrs = <lfs_bkpf>-bukrs
                         belnr = <lfs_bkpf>-belnr
                         gjahr = <lfs_bkpf>-gjahr
                         BINARY SEARCH.
              IF sy-subrc EQ 0.
                lwa_invrefnum-bupla = <lfs_bseg>-bupla.
              ENDIF.
              IF lwa_invrefnum-bupla IS INITIAL.
                lwa_output-indicator = c_red_light.
                lwa_output-message   = TEXT-t27.
                APPEND lwa_output TO gt_output.
              ELSE.
                IF gv_bp IS NOT INITIAL AND lwa_invrefnum-bupla NE gv_bp.
                  lwa_output-indicator = c_red_light.
                  CONCATENATE TEXT-t28 TEXT-t29 INTO lwa_output-message SEPARATED BY space.
                  REPLACE: '&1' WITH lwa_invrefnum-bupla INTO lwa_output-message,
                           '&2' WITH gv_bp               INTO lwa_output-message.
                  APPEND lwa_output TO gt_output.
                ELSE.

                  READ TABLE im_t_1bbranch ASSIGNING <lfs_1bbranch>
                    WITH KEY bukrs  = gv_bukrs
                             branch = lwa_invrefnum-bupla
                      BINARY SEARCH.
                  IF sy-subrc EQ 0.
                    IF <lfs_1bbranch>-gstin IS INITIAL.
                      lwa_output-indicator = c_red_light.
                      lwa_output-message   = TEXT-t30.
                      APPEND lwa_output TO gt_output.
                    ELSEIF <lfs_1bbranch>-gstin NE <lfs_filedata>-sel_gstin.
                      lwa_output-indicator = c_red_light.
                      lwa_output-message   = TEXT-t31.
                      REPLACE: '&1' WITH <lfs_1bbranch>-gstin     INTO lwa_output-message,
                               '&2' WITH <lfs_filedata>-sel_gstin INTO lwa_output-message.
                      APPEND lwa_output TO gt_output.
                    ELSE.
*---Begin of SAP Note 2904222 Changes
                      IF <lfs_filedata>-ewbno IS NOT INITIAL AND
                         <lfs_filedata>-ewbdt IS NOT INITIAL.
                        val_prep_ebill( EXPORTING
                                          im_t_ewaybill     = im_t_ewaybill
                                          im_t_ewaybill_act = im_t_ewaybill_act
                                          im_invrefnum      = lwa_invrefnum
                                          im_filedata       = <lfs_filedata>
                                          im_output         = lwa_output
                                        IMPORTING
                                          ex_error          = l_error
                                          ex_ewaybill       = lwa_ewaybill ).
                      ENDIF.
                      IF l_error EQ space.
*---End of SAP Note 2904222 Changes
                      lwa_invrefnum-odn_date = <lfs_bkpf>-budat.
                      lwa_invrefnum-ernam    = sy-uname.
                      lwa_invrefnum-erdat    = sy-datum.
                      lwa_invrefnum-erzet    = sy-uzeit.
                      APPEND lwa_invrefnum TO ex_t_invrefnum_upd.
*---Begin of SAP Note 2904222 Changes
                        IF lwa_ewaybill IS NOT INITIAL.
                          APPEND lwa_ewaybill TO ex_t_ewaybill_upd.
                          CLEAR lwa_ewaybill.
                        ENDIF.
                      ENDIF.
*---End of SAP Note 2904222 Changes
                    ENDIF.
                  ELSE.
                    lwa_output-indicator = c_red_light.
                    lwa_output-message   = TEXT-t30.
                    APPEND lwa_output TO gt_output.
                  ENDIF.
                ENDIF.
              ENDIF.
            ELSE.
              lwa_output-indicator = c_red_light.
              lwa_output-message   = TEXT-t07.
              APPEND lwa_output TO gt_output.
            ENDIF.
          ENDIF.
        ENDIF.

      ELSE.
*---Can't use the Binary Search as we need the latest entry
        READ TABLE im_t_invrefnum INTO lwa_invrefnum1
          WITH KEY irn = <lfs_filedata>-irn.
        IF sy-subrc EQ 0.
          IF lwa_invrefnum1-irn_status EQ c_active.
            MOVE-CORRESPONDING lwa_invrefnum1 TO lwa_invrefnum.
            lwa_invrefnum-version     = lwa_invrefnum1-version + 1.
            lwa_invrefnum-irn_status  = c_cancel.
            lwa_invrefnum-cancel_date = <lfs_filedata>-cancel_date.
            lwa_invrefnum-ernam       = sy-uname.
            lwa_invrefnum-erdat       = sy-datum.
            lwa_invrefnum-erzet       = sy-uzeit.
            CLEAR: lwa_invrefnum-ack_no,lwa_invrefnum-ack_date,
                   lwa_invrefnum-signed_inv,lwa_invrefnum-signed_qrcode.
            APPEND lwa_invrefnum TO ex_t_invrefnum_upd.
          ELSE.
            MOVE-CORRESPONDING: <lfs_filedata> TO lwa_output.
            lwa_output-indicator = c_red_light.
            lwa_output-message   = text-t38.
            APPEND lwa_output TO gt_output.
          ENDIF.
        ELSE.
          MOVE-CORRESPONDING: <lfs_filedata> TO lwa_output.
          lwa_output-indicator = c_red_light.
          lwa_output-message   = text-t39.
          APPEND lwa_output TO gt_output.
        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD SEG_FILE_DATA.

    DATA: lwa_value    TYPE string,
          l_irn        TYPE string,
          l_irn_status TYPE string,
          l_ewbno      TYPE string,                "SAP Note 2904222
          l_dummy      TYPE string.

    lwa_value = im_data.

    REPLACE: ALL OCCURRENCES OF ',' IN lwa_value WITH space,
             ALL OCCURRENCES OF '"' IN lwa_value WITH space.

    IF lwa_value CS 'AckNo'.
      SPLIT lwa_value AT 'AckNo:'         INTO l_dummy ch_filedata-ack_no.
      SHIFT: ch_filedata-ack_no LEFT DELETING LEADING space.
    ELSEIF lwa_value CS 'AckDt'.
      SPLIT lwa_value AT 'AckDt:'         INTO l_dummy ch_filedata-ack_date.
      SHIFT ch_filedata-ack_date LEFT DELETING LEADING space.
    ELSEIF lwa_value CS 'SignedInvoice'.
      SPLIT lwa_value AT 'SignedInvoice:' INTO l_dummy ch_filedata-signed_inv.
      SHIFT ch_filedata-signed_inv LEFT DELETING LEADING space.
    ELSEIF lwa_value CS 'SignedQRCode'.
      SPLIT lwa_value AT 'SignedQRCode:'  INTO l_dummy ch_filedata-signed_qrcode.
      SHIFT ch_filedata-signed_qrcode LEFT DELETING LEADING space.
    ELSEIF lwa_value CS 'Status'.
      SPLIT lwa_value AT 'Status:'        INTO l_dummy l_irn_status.
      SHIFT l_irn_status LEFT DELETING LEADING space.
      ch_filedata-irn_status = l_irn_status.
*---Begin of SAP Note 2904222 Changes
    ELSEIF lwa_value CS 'EwbNo'.
      SPLIT lwa_value AT 'EwbNo:'         INTO l_dummy l_ewbno.
      SHIFT l_ewbno LEFT DELETING LEADING space.
      ch_filedata-ewbno = l_ewbno.
      IF ch_filedata-ewbno EQ 0.
        CLEAR: ch_filedata-ewbno.
      ENDIF.
    ELSEIF lwa_value CS 'EwbDt'.
      SPLIT lwa_value AT 'EwbDt:'         INTO l_dummy ch_filedata-ewbdt.
      SHIFT ch_filedata-ewbdt LEFT DELETING LEADING space.
      IF ch_filedata-ewbdt EQ 'null'.
        CLEAR: ch_filedata-ewbdt.
      ENDIF.
    ELSEIF lwa_value CS 'EwbValidTill'.
      SPLIT lwa_value AT 'EwbValidTill:'  INTO l_dummy ch_filedata-ewbvalidtill.
      SHIFT ch_filedata-ewbvalidtill LEFT DELETING LEADING space.
      IF ch_filedata-ewbvalidtill EQ 'null'.
        CLEAR: ch_filedata-ewbvalidtill.
      ENDIF.
*---End of SAP Note 2904222 Changes
    ELSEIF lwa_value CS 'Irn'.
      SPLIT lwa_value AT 'Irn:'           INTO l_dummy l_irn.
      SHIFT l_irn LEFT DELETING LEADING space.
      ch_filedata-irn = l_irn.
    ELSEIF lwa_value CS 'CancelDate'.
      SPLIT lwa_value AT 'CancelDate:'    INTO l_dummy ch_filedata-cancel_date.
      SHIFT ch_filedata-cancel_date LEFT DELETING LEADING space.
    ENDIF.

  ENDMETHOD.


METHOD UPDATE_DB.

  DATA: lt_invrefnum TYPE STANDARD TABLE OF j_1ig_invrefnum,
        lt_ewaybill  TYPE STANDARD TABLE OF j_1ig_ewaybill,       "SAP Note 2904222
        lr_tables    TYPE RANGE OF tabname,                       "SAP Note 2904222
        lwa_tables   LIKE LINE OF lr_tables,                      "SAP Note 2904222
        lwa_output   TYPE ty_output,
        l_lock       TYPE flag,                                   "SAP Note 2904222
        l_indicator  TYPE char04,
        l_subrc      TYPE sysubrc,
        l_message    TYPE string.

  FIELD-SYMBOLS: <lfs_invrefnum> TYPE j_1ig_invrefnum,
                 <lfs_filedata>  TYPE ty_filedata.                "SAP Note 2904222

  lt_invrefnum = im_t_invrefnum.
*---Begin of SAP Note 2904222 Changes
  lt_ewaybill  = im_t_ewaybill.

  lwa_tables-sign   = c_sign_i.
  lwa_tables-option = c_sign_eq.
  lwa_tables-low    = c_invrefnum.
  APPEND lwa_tables TO lr_tables.

  IF im_t_ewaybill IS NOT INITIAL.
    CLEAR: lwa_tables-low.
    lwa_tables-low = c_ewaybill.
    APPEND lwa_tables TO lr_tables.
    SORT gt_filedata BY irn.
  ENDIF.

*---Lock the table
  lock_unlock_tables( EXPORTING
                        im_t_tables = lr_tables
                        im_lock     = c_x
                      IMPORTING
                        ex_lock     = l_lock ).
  IF l_lock EQ c_x.
*---End of SAP Note 2904222 Changes
*    TEST-SEAM non_exe.
      INSERT j_1ig_invrefnum FROM TABLE lt_invrefnum ACCEPTING DUPLICATE KEYS.
      IF sy-subrc EQ 0.
        l_subrc = sy-subrc.
        IF im_t_ewaybill IS INITIAL.            "SAP Note 2904222
        COMMIT WORK.
*---Begin of SAP Note 2904222 Changes
        ELSE.
          CLEAR: l_subrc.
          INSERT j_1ig_ewaybill FROM TABLE lt_ewaybill ACCEPTING DUPLICATE KEYS.
      IF sy-subrc EQ 0.
        l_subrc = sy-subrc.
        COMMIT WORK.
          ELSE.
            l_subrc = sy-subrc.
            ROLLBACK WORK.
          ENDIF.
        ENDIF.
      ELSE.
        l_subrc = sy-subrc.
*---End of SAP Note 2904222 Changes
      ENDIF.
*    END-TEST-SEAM.
    IF l_subrc EQ 0.
      l_indicator = c_green_light.
      l_message   = TEXT-t09.
    ELSE.
      l_indicator = c_red_light.
      l_message   = TEXT-t10.
    ENDIF.
  ELSE.
    l_indicator = c_red_light.
    l_message   = TEXT-t11.
  ENDIF.

*---Begin of SAP Note 2904222 Changes
*---Unlock the table
  lock_unlock_tables( EXPORTING
                        im_t_tables = lr_tables ).
*---End of SAP Note 2904222 Changes

  LOOP AT lt_invrefnum ASSIGNING <lfs_invrefnum>.
    CLEAR lwa_output.
    MOVE-CORRESPONDING <lfs_invrefnum> TO lwa_output.
    lwa_output-indicator = l_indicator.
    lwa_output-message   = l_message.
*---Begin of SAP Note 2904222 Changes
    IF im_t_ewaybill IS NOT INITIAL.
      READ TABLE gt_filedata ASSIGNING <lfs_filedata>
        WITH KEY irn = <lfs_invrefnum>-irn BINARY SEARCH.
      IF sy-subrc EQ 0.
        lwa_output-ewbno        = <lfs_filedata>-ewbno.
        lwa_output-ewbdt        = <lfs_filedata>-ewbdt.
        lwa_output-ewbvalidtill = <lfs_filedata>-ewbvalidtill.
      ENDIF.
    ENDIF.
*---End of SAP Note 2904222 Changes
    APPEND lwa_output TO gt_output.
  ENDLOOP.

  MESSAGE i000 WITH l_message.
ENDMETHOD.


  METHOD VAL_PREP_EBILL.

    DATA: l_ebillno  TYPE j_1ig_ebillno,
          l_vdfmdate TYPE j_1ig_vdfmdate,
          l_vdfmtime TYPE j_1ig_vdfmtime,
          l_vdtodate TYPE j_1ig_vdtodate,
          l_vdtotime TYPE j_1ig_vdtotime,
          l_status   TYPE j_1ig_stat,
          lwa_output TYPE ty_output.

    FIELD-SYMBOLS: <lfs_ewaybill> TYPE ty_ewaybill.

*---Clear Exporting data
    CLEAR: ex_ewaybill,ex_error.

    lwa_output = im_output.

    l_ebillno = im_filedata-ewbno.
    SHIFT l_ebillno LEFT DELETING LEADING '0'.

*---If Eway Bill Number length is not 12 characters
    IF strlen( l_ebillno ) NE 12.
      lwa_output-indicator = c_red_light.
      lwa_output-message   = TEXT-t42.
      APPEND lwa_output TO gt_output.
      ex_error = c_x.
      RETURN.
    ENDIF.

    l_ebillno = im_filedata-ewbno.
    READ TABLE im_t_ewaybill ASSIGNING <lfs_ewaybill>
      WITH KEY ebillno = l_ebillno BINARY SEARCH.
    IF sy-subrc EQ 0.
      lwa_output-indicator = c_red_light.
      CONCATENATE TEXT-t43 <lfs_ewaybill>-docno
        INTO lwa_output-message SEPARATED BY space.
      APPEND lwa_output TO gt_output.
      ex_error = c_x.
      RETURN.
    ENDIF.

    IF strlen( im_filedata-ewbdt ) EQ 19.
      CONCATENATE im_filedata-ewbdt+0(4) im_filedata-ewbdt+5(2)
                  im_filedata-ewbdt+8(2) INTO l_vdfmdate.
      CONCATENATE im_filedata-ewbdt+11(2) im_filedata-ewbdt+14(2)
                  im_filedata-ewbdt+17(2) INTO l_vdfmtime.
    ENDIF.

    IF strlen( im_filedata-ewbvalidtill ) EQ 19.
      CONCATENATE im_filedata-ewbvalidtill+0(4) im_filedata-ewbvalidtill+5(2)
                  im_filedata-ewbvalidtill+8(2) INTO l_vdtodate.
      CONCATENATE im_filedata-ewbvalidtill+11(2) im_filedata-ewbvalidtill+14(2)
                  im_filedata-ewbvalidtill+17(2) INTO l_vdtotime.
    ENDIF.

    IF l_vdtodate IS NOT INITIAL.
      IF l_vdfmdate GT l_vdtodate.
        lwa_output-indicator = c_red_light.
        CONCATENATE TEXT-t44 l_vdtodate
                    TEXT-t45 l_vdfmdate
                    INTO lwa_output-message
                    SEPARATED BY space.
        APPEND lwa_output TO gt_output.
        ex_error = c_x.
        RETURN.
      ELSEIF l_vdfmdate EQ l_vdtodate AND
             l_vdfmtime GT l_vdtotime.
        lwa_output-indicator = c_red_light.
        CONCATENATE TEXT-t46 l_vdtotime
                    TEXT-t47 l_vdfmtime
                    INTO lwa_output-message
                    SEPARATED BY space.
        APPEND lwa_output TO gt_output.
        ex_error = c_x.
        RETURN.
      ENDIF.
    ENDIF.

    IF l_vdtodate IS INITIAL.
      l_status = c_status_p.
    ELSE.
      UNASSIGN: <lfs_ewaybill>.
      READ TABLE im_t_ewaybill_act ASSIGNING <lfs_ewaybill>
        WITH KEY doctyp = im_invrefnum-doc_type
                 docno  = im_invrefnum-docno
                 BINARY SEARCH.
      IF sy-subrc EQ 0.
        lwa_output-indicator = c_red_light.
        CONCATENATE TEXT-t48 <lfs_ewaybill>-ebillno
          INTO lwa_output-message SEPARATED BY space.
        APPEND lwa_output TO gt_output.
        ex_error = c_x.
        RETURN.
      ENDIF.
      l_status = c_status_a.
    ENDIF.

    MOVE-CORRESPONDING im_invrefnum TO ex_ewaybill.
    ex_ewaybill-doctyp    = im_invrefnum-doc_type.
    ex_ewaybill-gjahr     = im_invrefnum-doc_year.
    ex_ewaybill-ebillno   = l_ebillno.
    ex_ewaybill-egen_dat  = ex_ewaybill-vdfmdate = l_vdfmdate.
    ex_ewaybill-egen_time = ex_ewaybill-vdfmtime = l_vdfmtime.
    ex_ewaybill-vdtodate  = l_vdtodate.
    ex_ewaybill-vdtotime  = l_vdtotime.
    ex_ewaybill-status    = l_status.
    ex_ewaybill-ernam     = sy-uname.
    ex_ewaybill-erdat     = sy-datum.

  ENDMETHOD.


  METHOD VAL_SEL_SCREEN.

    DATA: l_handler     TYPE REF TO j1ibadi_india_gst_irn,
          l_branch      TYPE j_1bbranc_,
          lwa_bupla     LIKE LINE OF gt_bupla,
          lwa_dd02v     TYPE dd02v,                       "SAP Note 2904222
          l_auth_flag   TYPE flag.

*---Restrict User from scheduling Background job for
*---Single upload, Bulk Upload Foreground options
    IF ( gv_sing   EQ c_x OR
         ( gv_bulk EQ c_x AND gv_fg EQ c_x ) ) AND
         gv_ob_dis EQ c_space AND
         sy-batch  EQ c_x.
      MESSAGE i000 WITH TEXT-t21.
      LEAVE LIST-PROCESSING.
    ENDIF.

    IF gv_cloud_check EQ c_space.

      GET BADI l_handler.
      CALL BADI l_handler->set_auth_int_num_flag
        CHANGING
          ex_auth_flag    = l_auth_flag
          ex_int_num_flag = gv_int_num_flag.

*---If Authorization flag is set, then do Authorization Check
      IF l_auth_flag EQ c_x.

        IF gv_ob_inv EQ c_x.
          AUTHORITY-CHECK OBJECT c_j1iirn
            ID c_actvt FIELD c_01
            ID c_bukrs FIELD gv_bukrs
            ID c_bupla FIELD '*'.
          IF sy-subrc NE 0.
            MESSAGE i000 WITH TEXT-t22.
            LEAVE LIST-PROCESSING.
          ENDIF.
        ELSE.

          IF gt_bupla IS INITIAL.
            AUTHORITY-CHECK OBJECT c_j1iirn
              ID c_actvt FIELD c_03
              ID c_bukrs FIELD gv_bukrs
              ID c_bupla FIELD '*'.
            IF sy-subrc NE 0.
              MESSAGE i000 WITH TEXT-t22.
              LEAVE LIST-PROCESSING.
            ENDIF.
          ELSE.
            LOOP AT gt_bupla INTO lwa_bupla.
              AUTHORITY-CHECK OBJECT c_j1iirn
                ID c_actvt FIELD c_03
                ID c_bukrs FIELD gv_bukrs
                ID c_bupla FIELD lwa_bupla-low.
              IF sy-subrc NE 0.
                MESSAGE i000 WITH TEXT-t22.
                LEAVE LIST-PROCESSING.
              ENDIF.
            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

    IF gv_ob_inv EQ c_x.

      IF gv_sing EQ c_x AND gv_file IS INITIAL.
        MESSAGE i000 WITH TEXT-t13.
        LEAVE LIST-PROCESSING.
      ENDIF.

      IF gv_bulk EQ c_x.
        IF gv_dir IS INITIAL AND gv_dir1 IS INITIAL.
          MESSAGE i000 WITH TEXT-t14.
          LEAVE LIST-PROCESSING.
        ENDIF.
      ENDIF.

      IF gv_bp IS NOT INITIAL.
*---Check the Business Place assigned to given Company Code,
*---Full Primary Key is used
        SELECT SINGLE branch
          FROM j_1bbranch
          INTO l_branch
          WHERE bukrs  EQ gv_bukrs
            AND branch EQ gv_bp.
        IF sy-subrc NE 0.
          MESSAGE i000 WITH TEXT-t36 TEXT-t37.
          LEAVE LIST-PROCESSING.
        ENDIF.
      ENDIF.

*---Begin of SAP Note 2904222 Changes
*---Check Ewabill table is present or not
      CALL FUNCTION 'DDIF_TABL_GET'
        EXPORTING
          name          = 'J_1IG_EWAYBILL'
        IMPORTING
          dd02v_wa      = lwa_dd02v
        EXCEPTIONS
          illegal_input = 1
          OTHERS        = 2.
      IF sy-subrc NE 0.
        MESSAGE i000 WITH TEXT-t49.
        LEAVE LIST-PROCESSING.
      ENDIF.
*---End of SAP Note 2904222 Changes

    ENDIF.

    IF gv_ob_dis EQ c_x AND gv_disp_gjahr IS INITIAL.
      MESSAGE i000 WITH TEXT-t16.
      LEAVE LIST-PROCESSING.
    ENDIF.

    IF gv_bukrs IS NOT INITIAL.
*---Validate Company Code is India Company Code or not
      CALL FUNCTION 'J_1BSA_COMPONENT_ACTIVE'
        EXPORTING
          bukrs                = gv_bukrs
          component            = c_in
        EXCEPTIONS
          component_not_active = 1
          OTHERS               = 2.
      IF sy-subrc NE 0.
        MESSAGE i000 WITH TEXT-t02.
        LEAVE LIST-PROCESSING.
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
