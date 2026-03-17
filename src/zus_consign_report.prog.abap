*&---------------------------------------------------------------------*
*& Report ZUS_CONSIGNMENT_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zus_consign_report.
"MATNR KUNNR VBELN ERDAT

TABLES:vbak,vbap.
TYPES: BEGIN OF ty_consign,
         vbeln    TYPE vbak-vbeln,
         posnr_i  TYPE vbap-posnr,
         erdat    TYPE vbap-erdat,
         auart    TYPE vbak-auart,
         kunnr    TYPE vbak-kunnr,
         matnr_i  TYPE vbap-matnr,
         arktx_i  TYPE vbap-arktx,
         kwmeng_i TYPE vbap-kwmeng,
         werks_i  TYPE vbap-werks,
         netpr_i  TYPE vbap-netpr,
         netwr_i  TYPE vbap-netwr,
       END OF ty_consign,

       BEGIN OF ty_lips,
         vbeln   TYPE lips-vbeln,
         posnr_i TYPE lips-posnr,
         vgbel_i TYPE lips-vgbel,
         vgpos_i TYPE lips-vgpos,
         lfimg_i TYPE lips-lfimg,
         werks   TYPE lips-werks,
         pstyv_i TYPE lips-pstyv,
       END OF ty_lips,

       BEGIN OF ty_kna1,
         kunnr TYPE kna1-kunnr,
         name1 TYPE kna1-name1,
       END OF ty_kna1,

       BEGIN OF ty_mara,
         matnr   TYPE mara-matnr,
         mtart   TYPE mara-mtart,
         wrkst   TYPE mara-wrkst,
         zseries TYPE mara-zseries,
         zsize   TYPE mara-zsize,
         brand   TYPE mara-brand,
         moc     TYPE mara-moc,
         type    TYPE mara-type,
       END OF ty_mara,

       BEGIN OF ty_final,
         vbeln    TYPE vbap-vbeln,
         kunnr    TYPE kna1-kunnr,
         name1    TYPE kna1-name1,
         matnr    TYPE vbap-matnr,
         text     TYPE char255,
         wrkst    TYPE mara-wrkst,
         arktx    TYPE vbap-arktx,
         erdat    TYPE vbap-erdat,
         kwmeng   TYPE vbap-kwmeng,
         lfimg    TYPE lips-lfimg,
         open_qty TYPE vbap-kwmeng,
         pic_qty  TYPE lips-lfimg,
         con_qty  TYPE lips-lfimg,
         con_ret  TYPE lips-lfimg,
         con_isu  TYPE lips-lfimg,
         netpr    TYPE vbap-netpr,
         netwr    TYPE vbak-netwr,
         brand    TYPE mara-brand,
         zseries  TYPE mara-zseries,
         zsize    TYPE mara-zsize,
         moc      TYPE mara-moc,
         type     TYPE mara-type,
         werks    TYPE vbap-werks,
         kbn      TYPE lips-lfimg,
         ken      TYPE lips-lfimg,
         kan      TYPE lips-lfimg,
       END OF ty_final,

       BEGIN OF ty_down,
         KUNNR   TYPE char15,
         NAME1   TYPE char40,
         MATNR   TYPE char20,
         TEXT    TYPE char255,
         VBELN   TYPE char15,
         ERDAT   TYPE char15,
         KWMENG  TYPE char15,
         LFIMG   TYPE char15,
         PIC_QTY TYPE char15,
         CON_QTY TYPE char15,
         CON_RET TYPE char15,
         CON_ISU TYPE char15,
         OPEN_QTY TYPE char15,
         NETPR    TYPE char15,
         NETWR    TYPE char15,
         BRAND    TYPE char15,
         ZSERIES  TYPE char15,
         ZSIZE    TYPE char15,
         MOC      TYPE char15,
         TYPE     TYPE char15,
         ref      TYPE char15,
         werks    TYPE vbap-werks,
       END OF ty_down.

DATA: it_consign TYPE TABLE OF ty_consign,
      wa_consign TYPE          ty_consign,

      it_return TYPE TABLE OF ty_consign,
      wa_return TYPE          ty_consign,

      it_us12 TYPE TABLE OF ty_consign,
      wa_us12 TYPE          ty_consign,

      it_us10 TYPE TABLE OF ty_consign,
      wa_us10 TYPE          ty_consign,

      it_lips    TYPE TABLE OF ty_lips,
      wa_lips    TYPE          ty_lips,

      it_lips_ret    TYPE TABLE OF ty_lips,
      wa_lips_ret    TYPE          ty_lips,

      it_lips_us12    TYPE TABLE OF ty_lips,
      wa_lips_us12    TYPE          ty_lips,

      it_lips_us10    TYPE TABLE OF ty_lips,
      wa_lips_us10    TYPE          ty_lips,

      it_mara    TYPE TABLE OF ty_mara,
      wa_mara    TYPE          ty_mara,

      it_kna1    TYPE TABLE OF ty_kna1,
      wa_kna1    TYPE          ty_kna1,

      it_final   TYPE TABLE OF ty_final,
      wa_final   TYPE          ty_final,

      it_down    TYPE TABLE OF ty_down,
      wa_down    TYPE          ty_down.


DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.
DATA : I_SORT TYPE SLIS_T_SORTINFO_ALV ,
       WA_SORT LIKE LINE OF I_SORT .


DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt TYPE tline,
      ls_mattxt TYPE tline.

DATA:data TYPE string.
SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_vbeln FOR vbap-vbeln,
                s_matnr FOR vbap-matnr,
                s_kunnr FOR vbak-kunnr,
                s_erdat FOR vbap-erdat,
                s_werks FOR vbap-werks OBLIGATORY DEFAULT 'US01'.
*PARAMETERS :    p_werks TYPE vbap-werks DEFAULT 'US01'.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\usa'.
SELECTION-SCREEN END OF BLOCK b2.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM sort_data.
  PERFORM get_fcat.
  PERFORM get_display.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  SELECT vbeln
         posnr_i
         erdat
         auart
         kunnr
         matnr_i
         arktx_i
         kwmeng_i
         werks_i
         netpr_i
         netwr_i  FROM wb2_v_vbak_vbap2 INTO TABLE it_consign
         WHERE vbeln IN s_vbeln
           AND matnr_i IN s_matnr
           AND kunnr IN s_kunnr
           AND erdat IN s_erdat
           AND werks_i IN s_werks
           AND auart IN ( 'US09', 'US10','US11','US10' ).

DELETE it_consign WHERE werks_i = 'PL01'.
  IF it_consign IS NOT INITIAL.
*
*  SELECT vbeln
*         posnr_i
*         erdat
*         auart
*         kunnr
*         matnr_i
*         arktx_i
*         kwmeng_i
*         werks_i
*         netpr_i
*         netwr_i  FROM wb2_v_vbak_vbap2 INTO TABLE it_us10
*         FOR ALL ENTRIES IN it_consign
*         WHERE kunnr = it_consign-kunnr
*           AND matnr_i = it_consign-matnr_i
*           AND auart = 'US10'.
*
*   SELECT vbeln
*         posnr_i
*         erdat
*         auart
*         kunnr
*         matnr_i
*         arktx_i
*         kwmeng_i
*         werks_i
*         netpr_i
*         netwr_i  FROM wb2_v_vbak_vbap2 INTO TABLE it_return
*         FOR ALL ENTRIES IN it_consign
*         WHERE kunnr = it_consign-kunnr
*           AND matnr_i = it_consign-matnr_i
*           AND auart = 'US11'.
*
*     SELECT vbeln
*         posnr_i
*         erdat
*         auart
*         kunnr
*         matnr_i
*         arktx_i
*         kwmeng_i
*         werks_i
*         netpr_i
*         netwr_i  FROM wb2_v_vbak_vbap2 INTO TABLE it_us12
*         FOR ALL ENTRIES IN it_consign
*         WHERE kunnr = it_consign-kunnr
*           AND matnr_i = it_consign-matnr_i
*           AND auart = 'US12'.


    SELECT vbeln
           posnr_i
           vgbel_i
           vgpos_i
           lfimg_i
           werks
           pstyv_i  FROM wb2_v_likp_lips2 INTO TABLE it_lips
           FOR ALL ENTRIES IN it_consign
           WHERE vgbel_i = it_consign-vbeln
             AND vgpos_i = it_consign-posnr_i.

    SELECT matnr
           mtart
           wrkst
           zseries
           zsize
           brand
           moc
           type    FROM mara INTO TABLE it_mara
           FOR ALL ENTRIES IN it_consign
           WHERE matnr = it_consign-matnr_i.

    SELECT kunnr
           name1 FROM kna1 INTO TABLE it_kna1
           FOR ALL ENTRIES IN it_consign
           WHERE kunnr = it_consign-kunnr.

  ENDIF.
*IF it_return IS NOT INITIAL.
*    SELECT vbeln
*           posnr_i
*           vgbel_i
*           vgpos_i
*           lfimg_i
*           werks
*           pstyv_i  FROM wb2_v_likp_lips2 INTO TABLE it_lips_ret
*           FOR ALL ENTRIES IN it_return
*           WHERE vgbel_i = it_return-vbeln
*             AND vgpos_i = it_return-posnr_i.
*ENDIF.
*
*IF it_us12 IS NOT INITIAL.
*    SELECT vbeln
*           posnr_i
*           vgbel_i
*           vgpos_i
*           lfimg_i
*           werks
*           pstyv_i FROM wb2_v_likp_lips2 INTO TABLE it_lips_us12
*           FOR ALL ENTRIES IN it_us12
*           WHERE vgbel_i = it_us12-vbeln
*             AND vgpos_i = it_us12-posnr_i.
*ENDIF.
*
*IF it_us10 IS NOT INITIAL.
*    SELECT vbeln
*           posnr_i
*           vgbel_i
*           vgpos_i
*           lfimg_i
*           werks
*           pstyv_i  FROM wb2_v_likp_lips2 INTO TABLE it_lips_us10
*           FOR ALL ENTRIES IN it_us10
*           WHERE vgbel_i = it_us10-vbeln
*             AND vgpos_i = it_us10-posnr_i.
*ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_data .
SORT it_consign by kunnr matnr_i.
BREAK primus.
  LOOP AT it_consign INTO wa_consign.
    wa_final-vbeln = wa_consign-vbeln.
    wa_final-kunnr = wa_consign-kunnr.
    wa_final-matnr = wa_consign-matnr_i.
    wa_final-netpr = wa_consign-netpr_i.
    wa_final-netwr = wa_consign-netwr_i.
    wa_final-arktx = wa_consign-arktx_i.
    wa_final-erdat = wa_consign-erdat.

    wa_final-werks  = wa_consign-werks_i.
    IF wa_consign-auart = 'US09'.
      wa_final-kwmeng = wa_consign-kwmeng_i.
    ENDIF.
*    READ TABLE it_lips INTO wa_lips WITH KEY vgbel_i = wa_consign-vbeln vgpos_i = wa_consign-posnr_i.
*    IF sy-subrc = 0.
*      wa_final-lfimg = wa_lips-lfimg_i.
*    ENDIF.
    LOOP AT it_lips INTO wa_lips WHERE vgbel_i = wa_consign-vbeln AND vgpos_i = wa_consign-posnr_i.

     IF wa_consign-auart = 'US09'..
       wa_final-lfimg = wa_final-lfimg + wa_lips-lfimg_i.
     ENDIF.

     IF wa_consign-auart = 'US11'.
       wa_final-pic_qty = wa_final-pic_qty + wa_lips_ret-lfimg_i.
     ENDIF.
     IF wa_consign-auart = 'US12  '..
       wa_final-con_ret = wa_final-con_ret + wa_lips_us12-lfimg_i.
     ENDIF.

     IF wa_consign-auart = 'US10'.
       wa_final-con_isu = wa_final-con_isu + wa_lips_us10-lfimg_i.
     ENDIF.



     CASE wa_lips-pstyv_i.
     	WHEN 'KBN'.
        wa_final-kbn = wa_final-kbn + wa_lips-lfimg_i.
     	WHEN 'KAN' .
        wa_final-kan = wa_final-kan + wa_lips-lfimg_i.
     	WHEN 'KEN'.
        wa_final-ken = wa_final-ken + wa_lips-lfimg_i.
     ENDCASE.

    ENDLOOP.

    wa_final-open_qty = wa_final-kwmeng - wa_final-lfimg.
    READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_consign-matnr_i.
    IF sy-subrc = 0.
      wa_final-wrkst   = wa_mara-wrkst.
      wa_final-zseries = wa_mara-zseries.
      wa_final-zsize   = wa_mara-zsize.
      wa_final-brand   = wa_mara-brand.
      wa_final-moc     = wa_mara-moc.
      wa_final-type    = wa_mara-type   .
    ENDIF.

    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_consign-kunnr.
    IF sy-subrc = 0.
      wa_final-name1 = wa_kna1-name1.
    ENDIF.


    CLEAR: lv_lines, ls_mattxt,wa_lines,lv_name.
    REFRESH lv_lines.
    lv_name = wa_final-matnr.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'GRUN'
        language                = sy-langu
        name                    = lv_name
        object                  = 'MATERIAL'
      TABLES
        lines                   = lv_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
    IF NOT lv_lines IS INITIAL.
      LOOP AT lv_lines INTO wa_lines.
        IF NOT wa_lines-tdline IS INITIAL.
          CONCATENATE wa_final-text wa_lines-tdline INTO wa_final-text SEPARATED BY space.
        ENDIF.
      ENDLOOP.

    ENDIF.

*    LOOP AT it_return INTO wa_return WHERE kunnr = wa_consign-kunnr AND matnr_i = wa_consign-matnr_i.
*      READ TABLE it_lips_ret INTO wa_lips_ret WITH KEY vgbel_i = wa_return-vbeln vgpos_i = wa_return-posnr_i.
*        IF sy-subrc = 0.
*
*
*          CASE wa_lips_ret-pstyv_i.
*           WHEN 'KBN'.
*            wa_final-kbn = wa_final-kbn + wa_lips_ret-lfimg_i.
*           WHEN 'KAN' .
*            wa_final-kan = wa_final-kan + wa_lips_ret-lfimg_i.
*           WHEN 'KEN'.
*            wa_final-ken = wa_final-ken + wa_lips_ret-lfimg_i.
*          ENDCASE.
*
*        ENDIF.
*    ENDLOOP.

*    wa_final-con_qty = wa_final-lfimg + wa_final-pic_qty.

*    LOOP AT it_us12 INTO wa_us12 WHERE kunnr = wa_consign-kunnr AND matnr_i = wa_consign-matnr_i.
*      READ TABLE it_lips_us12 INTO wa_lips_us12 WITH KEY vgbel_i = wa_us12-vbeln vgpos_i = wa_us12-posnr_i.
*        IF sy-subrc = 0.
*
*
*          CASE wa_lips_us12-pstyv_i.
*           WHEN 'KBN'.
*            wa_final-kbn = wa_final-kbn + wa_lips_us12-lfimg_i.
*           WHEN 'KAN' .
*            wa_final-kan = wa_final-kan + wa_lips_us12-lfimg_i.
*           WHEN 'KEN'.
*            wa_final-ken = wa_final-ken + wa_lips_us12-lfimg_i.
*          ENDCASE.
*
*
*        ENDIF.
*    ENDLOOP.
*    wa_final-con_qty = wa_final-con_qty - wa_final-con_ret.

*CONCATENATE wa_consign-kunnr wa_consign-matnr_i INTO data.
*ON CHANGE OF data.
*    LOOP AT it_us10 INTO wa_us10 WHERE kunnr = wa_consign-kunnr AND matnr_i = wa_consign-matnr_i.
*      READ TABLE it_lips_us10 INTO wa_lips_us10 WITH KEY vgbel_i = wa_us10-vbeln vgpos_i = wa_us10-posnr_i.
*        IF sy-subrc = 0.
*
*
*          CASE wa_lips_us10-pstyv_i.
*           WHEN 'KBN'.
*            wa_final-kbn = wa_final-kbn + wa_lips_us10-lfimg_i.
*           WHEN 'KAN' .
*            wa_final-kan = wa_final-kan + wa_lips_us10-lfimg_i.
*           WHEN 'KEN'.
*            wa_final-ken = wa_final-ken + wa_lips_us10-lfimg_i.
*          ENDCASE.
*
*        ENDIF.
*    ENDLOOP.
*endon.
*    wa_final-con_qty = wa_final-con_qty - wa_final-con_isu.
    wa_final-con_qty = wa_final-kbn - wa_final-kan - wa_final-ken.

*    IF wa_final-con_qty < 0.
*      wa_final-con_qty = 0.
*    ENDIF.
    APPEND wa_final TO it_final.
    CLEAR wa_final.
  ENDLOOP.

IF p_down = 'X'.
  LOOP AT it_final INTO wa_final.
    wa_down-KUNNR     = wa_final-KUNNR   .
    wa_down-NAME1     = wa_final-NAME1   .
    wa_down-MATNR     = wa_final-MATNR   .
    wa_down-TEXT      = wa_final-TEXT    .
    wa_down-VBELN     = wa_final-VBELN   .
    wa_down-WERKS     = wa_final-WERKS   .
*    wa_down-ERDAT     = wa_final-ERDAT   .

    IF wa_final-ERDAT IS NOT INITIAL.
      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-ERDAT
          IMPORTING
            output = wa_down-ERDAT.

        CONCATENATE wa_down-ERDAT+0(2) wa_down-ERDAT+2(3) wa_down-ERDAT+5(4)
                        INTO wa_down-ERDAT SEPARATED BY '-'.
    ENDIF.




    wa_down-KWMENG    = wa_final-KWMENG  .
    wa_down-LFIMG     = wa_final-LFIMG   .
    wa_down-PIC_QTY   = abs( wa_final-PIC_QTY ).
    wa_down-CON_QTY   = abs( wa_final-CON_QTY ).
    wa_down-CON_RET   = wa_final-CON_RET .
    wa_down-CON_ISU   = wa_final-CON_ISU .
    wa_down-OPEN_QTY  = abs( wa_final-OPEN_QTY ).

*    wa_down-MATNR    = wa_final-MATNR  .
    wa_down-NETPR    = wa_final-NETPR  .
    wa_down-NETWR    = wa_final-NETWR  .
    wa_down-BRAND    = wa_final-BRAND  .
    wa_down-ZSERIES  = wa_final-ZSERIES.
    wa_down-ZSIZE    = wa_final-ZSIZE  .
    wa_down-MOC      = wa_final-MOC    .
    wa_down-TYPE     = wa_final-TYPE   .


    IF wa_final-PIC_QTY < 0.
        CONDENSE wa_down-PIC_QTY.
        CONCATENATE '-' wa_down-PIC_QTY INTO wa_down-PIC_QTY.
    ENDIF.

    IF wa_final-CON_QTY < 0.
        CONDENSE wa_down-CON_QTY.
        CONCATENATE '-' wa_down-CON_QTY INTO wa_down-CON_QTY.
    ENDIF.

    IF wa_final-OPEN_QTY < 0.
        CONDENSE wa_down-OPEN_QTY.
        CONCATENATE '-' wa_down-OPEN_QTY INTO wa_down-OPEN_QTY.
    ENDIF.



    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.

  APPEND wa_down TO it_down.
  CLEAR wa_down.
  ENDLOOP.
ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .
  PERFORM fcat USING :   '1'   'KUNNR'           'IT_FINAL'      'Customer'                 ' '      '20' ,
                         '2'   'NAME1'           'IT_FINAL'      'Customer Name '           ' '        '20' ,
                         '3'   'MATNR'           'IT_FINAL'      'Material'                 ' '      '20',
                         '4'   'TEXT'            'IT_FINAL'      'Long Description'         ' '         '20' ,
                         '5'   'VBELN'           'IT_FINAL'      'Document No'              ' '       '10',
                         '6'   'ERDAT'           'IT_FINAL'      'Document Date'            ' '     '20' ,
                         '7'   'KWMENG'          'IT_FINAL'      'Unrestricted SO Qty'      'X'    '20',
                         '8'   'LFIMG'           'IT_FINAL'      'Full Up Qty'              'X'        '20',
                         '9'   'PIC_QTY'         'IT_FINAL'      'Pick Up Qty'              'X'        '20',
                         '10'  'CON_QTY'         'IT_FINAL'      'Consignment Qty'          'X'            '20',
                         '11'  'CON_RET'         'IT_FINAL'      'Cons Return Qty'          'X'            '20',
                         '12'  'CON_ISU'         'IT_FINAL'      'Cons Issue Qty'           'X'           '20',
                         '13'  'OPEN_QTY'        'IT_FINAL'      'Open Qty'                 'X' '20',
*                         '14'  'MATNR'           'IT_FINAL'      'Item Code'                    '20',
                         '14'  'NETPR'           'IT_FINAL'      'Unit Rate'                'X' '20',
                         '15'  'NETWR'           'IT_FINAL'      'Total Value'              'X'  '20',
                         '16'  'BRAND'           'IT_FINAL'      'BRAND'                    ' '    '10',
                         '17'  'ZSERIES'         'IT_FINAL'      'SERIES'                   ' '    '10',
                         '18'  'ZSIZE'           'IT_FINAL'      'SIZE'                     ' '    '10',
                         '19'  'MOC'             'IT_FINAL'      'MOC'                      ' '   '10',
                         '20'  'TYPE'            'IT_FINAL'      'TYPE'                     ' '    '10',
                         '21'  'WERKS'            'IT_FINAL'      'Plant'                     ' '    '10'.





ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0563   text
*      -->P_0564   text
*      -->P_0565   text
*      -->P_0566   text
*      -->P_0567   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5)
                    VALUE(p6).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-do_sum     = p5.
  wa_fcat-outputlen   = p6.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
      IT_SORT            = I_SORT
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
      I_SAVE             = 'X'
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

IF p_down = 'X'.

    PERFORM download.

ENDIF.


ENDFORM.


*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .


  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ZUS_CONSMNT.TXT'.


  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_CONSIGNMENT REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

********************************************************************************************
CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ZUS_CONSMNT.TXT'.


  CONCATENATE p_folder '\'  lv_file
    INTO lv_fullfile.

  WRITE: / 'ZUS_CONSIGNMENT REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Customer'
              'Customer Name '
              'Material'
              'Long Description'
              'Document No'
              'Document Date'
              'Unrestricted SO Qty'
              'Full Up Qty'
              'Pick Up Qty'
              'Consignment Qty'
              'Cons Return Qty'
              'Cons Issue Qty'
              'Open Qty'
              'Unit Rate'
              'Total Value'
              'BRAND'
              'SERIES'
              'SIZE'
              'MOC'
              'TYPE'
              'Refresh Date'
              'Plant'
               INTO pd_csv
               SEPARATED BY l_field_seperator.

ENDFORM.
