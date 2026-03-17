*&---------------------------------------------------------------------*
*& Report ZPACKING_DETAIL_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpacking_detail_report.
TYPE-POOLS: slis.


TABLES : likp,vbfa,vbrk,lips,mara.


TYPES :BEGIN OF ty_final,
*         cnt TYPE i,
         vbeln     TYPE likp-vbeln,
         bldat     TYPE likp-bldat,
         INBOUND   TYPE LIKP-VBELN,
         vbeln2    TYPE vbfa-vbeln,
         xblnr     TYPE vbrk-xblnr,
         fkdat     TYPE  vbrk-fkdat,
         name1     TYPE   adrc-name1,
         consignee TYPE   name1,
         buyer    TYPE    name1,
         vhilm_ku  TYPE    vekp-vhilm_ku,
         text      TYPE string,
         kdmat     TYPE     vbap-kdmat,
         matnr     TYPE    lips-matnr,
         maktx     TYPE    makt-maktx,
         p_qty   TYPE lips-lfimg,
        posnr    TYPE vepo-posnr,
*         lfimg     TYPE   lips-lfimg,
         vgbel     TYPE lips-vgbel,
         vgpos     TYPE lips-vgpos,
         zseries   TYPE mara-zseries,
         zsize     TYPE   mara-zsize,
         brand     TYPE     mara-brand,
         kgun      TYPE  lips-lfimg,
         ntgew     TYPE  lips-ntgew,
         descr     TYPE   makt-maktx,
         vkbur     TYPE  lips-vkbur,
*         werks     TYPE lips-werks,


         ref         TYPE char15,
          time        TYPE char10,
       END OF ty_final.

TYPES :BEGIN OF ty_DOWN,
*         cnt TYPE i,
         vbeln     TYPE likp-vbeln,
         bldat     TYPE likp-bldat,
         INBOUND   TYPE LIKP-VBELN,
         vbeln2    TYPE vbfa-vbeln,
         xblnr     TYPE vbrk-xblnr,
         fkdat     TYPE  vbrk-fkdat,
         name1     TYPE   adrc-name1,
         consignee TYPE   name1,
         buyer    TYPE    name1,
         vhilm_ku  TYPE    vekp-vhilm_ku,
         text      TYPE string,
         kdmat     TYPE     vbap-kdmat,
         matnr     TYPE    lips-matnr,
         maktx     TYPE    makt-maktx,
         p_qty   TYPE lips-lfimg,
          posnr    TYPE vepo-posnr,
*         lfimg     TYPE   lips-lfimg,
         vgbel     TYPE lips-vgbel,
         vgpos     TYPE lips-vgpos,
         zseries   TYPE mara-zseries,
         zsize     TYPE   mara-zsize,
         brand     TYPE     mara-brand,
         kgun      TYPE  lips-lfimg,
         ntgew     TYPE  lips-ntgew,
         descr     TYPE   makt-maktx,
         vkbur     TYPE  lips-vkbur,
          ref         TYPE char15,
          time        TYPE char10,
*         werks     TYPE lips-werks,

       END OF ty_DOWN.


DATA: it_fcat  TYPE slis_t_fieldcat_alv,
      wa_fcat  LIKE LINE OF it_fcat,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final.
DATA:it_down TYPE TABLE OF ty_down,
     wa_down TYPE          ty_down.

DATA : adr TYPE adrnr.
DATA : n_adrnr TYPE adrnr.
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS : p_date FOR likp-bldat,
                 i_date FOR vbfa-erdat.
*                 vbeln FOR likp-vbeln.

PARAMETERS : plant TYPE t001w-werks DEFAULT  'PL01'.


SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK b2.


SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.



AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF  screen-name = 'PLANT'.

      screen-input = 0.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.




START-OF-SELECTION.

  PERFORM get_data.
*PERFORM sort_data.
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

*  BREAK PRIMUS.

  SELECT vbeln , bldat ,kunnr , kunag FROM likp INTO TABLE @DATA(it_likp)" 1 , 2
  WHERE bldat in @p_date
  AND  VKORG = '1000'.
*    *  AND VBELN IN @VBELN.
*  WHERE vbeln IN @vbeln.
*************************CONSIGNEE***
IF SY-SUBRC <> 0.

  MESSAGE 'No data found' TYPE 'E'.

ENDIF.
*SELECT SINGLE ADRNR FROM KNA1 INTO


****************
  SELECT vbeln,  matnr, lfimg, brgew,werks , ntgew, vgbel, vgpos , vkbur
  FROM lips
  INTO TABLE @DATA(it_lips)
    FOR ALL ENTRIES IN @it_likp
    WHERE vbeln = @it_likp-vbeln
    AND WERKS = @PLANT.




  SELECT vbeln , vbelv,ERDAT FROM vbfa                     " 4
    INTO TABLE @DATA(it_vbfa)
    FOR ALL ENTRIES IN @it_likp
    WHERE vbelv = @it_likp-vbeln
    AND vbtyp_n = 'M'
    AND ERDAT IN @I_DATE.


  SELECT vbeln , posnr , venum , vemng
  INTO  TABLE @DATA(it_vepo)
  FROM vepo
    FOR ALL ENTRIES IN @it_likp
  WHERE vbeln = @it_likp-vbeln.

*SORT it_vepo by posnr ASCENDING.

  SELECT  exidv , vhilm , vhilm_ku, ntgew ,venum
FROM vekp
INTO TABLE @DATA(it_vekp)
    FOR ALL ENTRIES IN @it_vepo
WHERE venum = @it_vepo-venum.

*customer item code *****************
  SELECT  vbelv, posnv
  FROM vbfa
  INTO TABLE @DATA(temp_vbfa)
    FOR ALL ENTRIES IN @it_vepo
  WHERE vbelv = @it_vepo-vbeln
  AND   posnv = @it_vepo-posnr.

  SELECT vbeln ,posnr , kdmat
  FROM vbap
    INTO TABLE @DATA(it_vbap)
    FOR ALL ENTRIES IN @temp_vbfa
    WHERE vbeln = @temp_vbfa-vbelv
    AND posnr = @temp_vbfa-posnv.
*********************cust item code end*****

  SELECT vbeln , xblnr , fkdat FROM vbrk                  " 5 , 6
    INTO TABLE @DATA(it_vbrk)
    FOR ALL ENTRIES IN @it_vbfa
    WHERE vbeln = @it_vbfa-vbeln.




  SELECT  adrnr , werks INTO TABLE  @DATA(it_adrnr)
      FROM t001w
    FOR ALL ENTRIES IN @it_lips
      WHERE werks = @it_lips-werks.

  SELECT addrnumber , name1 FROM adrc

      INTO TABLE @DATA(it_adrc)
    FOR ALL ENTRIES IN @it_adrnr

    WHERE addrnumber = @it_adrnr-adrnr.

  SELECT matnr ,zseries , zsize , brand
    FROM mara INTO TABLE @DATA(it_mara)
    FOR ALL ENTRIES IN @it_lips
    WHERE matnr = @it_lips-matnr.

  SELECT matnr , maktx
FROM makt
INTO TABLE @DATA(it_makt)
    FOR ALL ENTRIES IN @it_lips
WHERE matnr = @it_lips-matnr.

SELECT VBELV , VGBEL, VGPOS, POSNV FROM VBRP INTO TABLE @DATA(IT_VBRP)
  FOR ALL ENTRIES IN @IT_VEPO
  WHERE VGBEL = @IT_VEPO-vbeln
     AND VGPOS = @IT_vepo-posnr.

***********buyer ****************************

*SELECT vbeln, kunag FROM likp INTO TABLE @data(it_kunag)
*  FOR ALL ENTRIES IN @it_likp
*WHERE vbeln = @

DATA: count TYPE i ,
     LV_STRING TYPE string,
    LV_NAME TYPE THEAD-TDNAME ,
 GT_LINES TYPE TABLE OF TLINE.
*********************PROCESS DATA ************************************
  LOOP AT it_likp INTO DATA(wa_likp).

    wa_final-vbeln = wa_likp-vbeln.
    wa_final-bldat = wa_likp-bldat.
    DATA(l_kunnr) = wa_likp-kunnr.
    DATA(l_kunag) = wa_likp-kunag.

SELECT SINGLE VBELN FROM LIKP INTO WA_FINAL-INBOUND
  WHERE VERUR = WA_FINAL-VBELN.

    SELECT SINGLE adrnr FROM kna1 INTO adr
      WHERE kunnr = l_kunnr.

    SELECT SINGLE name1 FROM adrc INTO wa_final-consignee
      WHERE addrnumber = adr.

SELECT SINGLE adrnr FROM kna1 INTO n_adrnr
  WHERE kunnr = l_kunag.

   SELECT SINGLE name1 FROM adrc INTO wa_final-buyer
      WHERE addrnumber = n_adrnr.



    READ TABLE it_vbfa INTO DATA(wa_vbfa) WITH KEY vbelv = wa_final-vbeln.

    wa_final-vbeln2  = wa_vbfa-vbeln.

    READ TABLE it_vbrk INTO DATA(wa_vbrk) WITH KEY vbeln = wa_final-vbeln2.

    wa_final-xblnr   = wa_vbrk-xblnr.
    wa_final-fkdat   = wa_vbrk-fkdat.



    ON CHANGE OF wa_final-vbeln.

      LOOP AT it_lips INTO DATA(wa_lips) WHERE vbeln = wa_final-vbeln.


        wa_final-matnr  = wa_lips-matnr.
*        wa_FINAL-lfimg  = wa_lips-lfimg.
*        wa_final-ntgew  = wa_lips-ntgew.
        wa_final-vgbel = wa_lips-vgbel.
        wa_final-vgpos = wa_lips-vgpos.
        DATA(LV_PLANT) = wa_lips-werks.
        wa_final-vkbur = wa_lips-vkbur.
        wa_final-kgun = wa_lips-ntgew / wa_lips-lfimg.
*        wa_final-cnt = count + 1.


        READ TABLE it_adrnr INTO DATA(wa_adrnr) WITH  KEY werks = LV_PLANT."wa_final-werks.


        READ TABLE it_adrc INTO DATA(wa_adrc) WITH  KEY addrnumber  = wa_adrnr-adrnr.

        wa_final-name1    = wa_adrc-name1.


        READ TABLE it_makt INTO DATA(wa_makt) WITH KEY matnr = wa_final-matnr.

        wa_final-maktx    = wa_makt-maktx.

        READ TABLE it_mara INTO DATA(wa_mara) WITH KEY matnr = wa_final-matnr.

        wa_final-zseries = wa_mara-zseries.
        wa_final-zsize = wa_mara-zsize.
        wa_final-brand = wa_mara-brand.
*BREAK primus.
*        READ TABLE it_vepo INTO DATA(wa_vepo) WITH KEY posnr = wa_final-vgpos VBELN = WA_FINAL-VBELN.
        LOOP AT  it_vepo INTO DATA(wa_vepo) WHERE posnr = wa_final-vgpos AND VBELN = WA_FINAL-VBELN.

        DATA(l_vnum)  = wa_vepo-venum.
        wa_final-posnr = wa_vepo-posnr.
        wa_final-p_qty = wa_vepo-vemng.
*            wa_final-kgun = wa_lips-ntgew * wa_final-p_qty.
    wa_final-ntgew  = wa_final-kgun * wa_final-p_qty.
        READ TABLE it_vekp INTO DATA(wa_vekp) WITH KEY venum = l_vnum.

        wa_final-vhilm_ku = wa_vekp-vhilm_ku.

*          append wa_final TO it_final.

        SELECT SINGLE maktx FROM makt INTO wa_final-descr WHERE matnr = wa_vekp-vhilm .

        READ TABLE temp_vbfa INTO DATA(wa_temp_vbfa) WITH  KEY vbelv = wa_vepo-vbeln
                                                                posnv = wa_vepo-posnr.

        READ TABLE it_vbap INTO DATA(wa_vbap) WITH KEY vbeln = wa_temp_vbfa-vbelv
                                                        posnr = wa_temp_vbfa-posnv.

        wa_final-kdmat = wa_vbap-kdmat.


READ TABLE IT_VBRP INTO DATA(WA_VBRP) WITH  KEY VGBEL = WA_VEPO-VBELN
                                                 VGPOS = WA_VEPO-POSNR.

CONCATENATE wa_vbrp-VBELV wa_vbrp-POSNV INTO LV_STRING.
lv_name = lv_string.

CALL FUNCTION 'READ_TEXT'
  EXPORTING
   CLIENT                        = SY-MANDT
    id                            = '0001'
    language                      = sy-langu
    NAME                          = LV_name
    OBJECT                        = 'VBBP'
*   ARCHIVE_HANDLE                = 0
*   LOCAL_CAT                     = ' '
* IMPORTING
*   HEADER                        =
*   OLD_LINE_COUNTER              =
  TABLES
    lines                         = GT_LINES
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
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

IF NOT GT_lines IS INITIAL.
       READ TABLE GT_lines INTO DATA(wa_lines) INDEX 1.

       WA_FINAL-TEXT = WA_LINES-TDLINE.
      ENDIF.


CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_FINAL-ref.

      CONCATENATE wa_FINAL-ref+0(2) wa_FINAL-ref+2(3) wa_FINAL-ref+5(4)
                      INTO wa_final-ref SEPARATED BY '-'.

      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO wa_final-time SEPARATED BY ':'.


        APPEND wa_final TO it_final.
endloop.
*        CLEAR : WA_FINAL.
      ENDLOOP.
    ENDON.

CLEAR : WA_FINAL.
  ENDLOOP.

  IF P_DOWN = 'X'.




  IT_DOWN[] = IT_FINAL.

  ENDIF.
*******************END PROCESS DATA *************************************************


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

  PERFORM fcat USING :     '1'   'VBELN'           'IT_FINAL'      'Packing List No.'                           '18' ,
                           '2'   'BLDAT'           'IT_FINAL'      'Packing list date'                             '18',
                           '3'   'INBOUND'                 'IT_FINAL'      'Inbound Delivery No.'                           '18' ,

                           '4'   'VBELN2'           'IT_FINAL'      'Billing Doc No.'                        '18' ,
                           '5'   'XBLNR'           'IT_FINAL'      'Invoice No.'                       '18' ,
                           '6'   'FKDAT'             'IT_FINAL'      'Invoice Date'                           '18' ,
                           '7'   'NAME1'             'IT_FINAL'      'Name of exporter'                           '18' ,
                           '8'   'CONSIGNEE'              'IT_FINAL'      'Consignee'                            '18' ,
                           '9'   'BUYER'                'IT_FINAL'      'Buyer'                            '18' ,
                          '10'   'VHILM_KU'          'IT_FINAL'      'Marks & Nos'                                 '18' ,
                          '11'   'TEXT'     'IT_FINAL'      'PO Reference'                            '18' ,
                          '12'   'KDMAT'           'IT_FINAL'      'Customer Item code'                           '18' ,
                          '13'   'MATNR'           'IT_FINAL'      'Delval Item code'                     '18' ,
                          '14'   'MAKTX'           'IT_FINAL'      'Item Description'                             '18' ,
                          '15'   'P_QTY'           'IT_FINAL'      'Packed QTY'                          '10' ,
                          '16'   'POSNR'           'IT_FINAL'      'Packed Line item'                          '18' ,
                          '17'   'VGBEL'           'IT_FINAL'      'SO No.'                          '18' ,
                          '18'   'VGPOS'           'IT_FINAL'      'PO Sr No.'                          '18' ,
                          '19'   'ZSERIES'           'IT_FINAL'      'Series'                          '18' ,
                          '20'   'ZSIZE'           'IT_FINAL'      'Size'                          '18' ,
                          '21'   'BRAND'           'IT_FINAL'      'Brand'                          '18' ,
                          '22'   'KGUN'           'IT_FINAL'      'Wt in Kgs'                          '18' ,
                          '23'   'NTGEW'           'IT_FINAL'      'Net Wt in Kgs'                          '18' ,
                          '24'   'DESCR'           'IT_FINAL'      'Description Pkg Material'                          '40' ,
                          '25'   'VKBUR'           'IT_FINAL'      'Branch'                          '18' .

*                          '26'   'P_QTY'           'IT_FINAL'      'Packed QTY'                          '18' .



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
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = sy-repid
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
*   IS_LAYOUT                         =
   IT_FIELDCAT                       = it_fcat
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   I_SAVE                            = 'X'
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = it_final
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


  IF p_down = 'X'.

    PERFORM download.

  ENDIF.

ENDFORM.





FORM fcat  USING   VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
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


  lv_file = 'ZPACKING_DETAILS_REPORT.TXT'.


  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPACKING_DETAILS_REPORT started on', sy-datum, 'at', sy-uzeit.
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

*********************************************SQL UPLOAD FILE *****************************************
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


  lv_file = 'ZPACKING_DETAILS.TXT'.


  CONCATENATE p_folder '\' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZPACKING_DETAILS_REPORT started on', sy-datum, 'at', sy-uzeit.
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
FORM cvs_header  USING    hd_csv.

DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE  'Packing List No'
                 'Packing list date'
                 'Inbound Delivery No.'
                 'Billing Doc No.'
                 'Invoice No.'
                 'Invoice Date'
                 'Name of exporter'
                  'Consignee'
                  'Buyer'
                  'Marks & Nos'
                  'PO Reference'
                  'Customer Item code'
                  'Delval Item code'
                  'Item Description'
                  'Packed QTY'
                  'Packed Line itm'
                  'SO No.'
                  'PO Sr No.'
                    'Series'
                  'Size'
                  'Brand'
                  'Wt in Kgs'
                  'Net Wt in Kgs'
                  'Description Pkg Material'
                  'Branch'
                  'Refresh Date'
                   'Refresh Time'
              INTO Hd_csv
                SEPARATED BY l_field_seperator.



ENDFORM.
