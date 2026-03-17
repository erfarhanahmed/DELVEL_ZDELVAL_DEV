*&---------------------------------------------------------------------*
*& Report ZPP_ROUTING_UPLOAD
*&---------------------------------------------------------------------*
*&Report: ZSU_VENDOR_REJECTION
*&Transaction: ZSU_VREJ
*&Functional Cosultant: Subhashish Pandey
*&Technical Consultant: Shreya Sankpal/ Nilay Brahme
*&TR: DEVK912961
*&Date: 08.12.2023
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
REPORT zpp_routing_upload NO STANDARD PAGE HEADING
        MESSAGE-ID zdel.

TABLES :SSCRFIELDS.

TYPES: BEGIN OF ty_record,
         matnr     TYPE mara-matnr,
         werks     TYPE t001w-werks,
         verwe     TYPE plkod-verwe,
*         usage TYPE plkod-verwe,
         statu     TYPE plkod-statu,
         vornr(10),
         arbpl     TYPE plpod-arbpl,
         steus     TYPE plpod-steus,
         ltxa1     TYPE plpod-ltxa1,
         vgw01(12),        " TYPE plpod-vgw01,
         vge01     TYPE plpod-vge01,
*        ZUONR,
*        FRDLB,
*        INFNR,
*        EKORG,
*        SAKTO,
       END OF ty_record.

DATA gt_record  TYPE TABLE OF ty_record.
DATA gt_bdcdata TYPE TABLE OF bdcdata.


CONSTANTS :
*  c_tcode(04) TYPE c VALUE 'XD01',      "Tran. Code - XD01
*  c_a(01)     TYPE c VALUE 'A',
*  c_e(01)     TYPE c VALUE 'E',       "Indicator - MSG type ERROR
  c_x(01)     TYPE c VALUE 'X'.       "Assigning the Value X

*>>
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*SELECTION-SCREEN SKIP 1.
PARAMETERS: p_file  TYPE localfile. "OBLIGATORY.                "File to upload data.

SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
*SELECTION-SCREEN SKIP 1.
PARAMETERS p1 AS CHECKBOX.
*PARAMETERS: p1 no-display RADIOBUTTON GROUP g1 DEFAULT 'X',                "Foreground
*            p2 RADIOBUTTON GROUP g1 .                            "Background
*SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN END OF BLOCK b2.


SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN END OF LINE.


*----------------------------------------------------------------------*
* Initialization Event
*----------------------------------------------------------------------*
INITIALIZATION.

W_BUTTON = 'Download Excel Template'.

*----------------------------------------------------------------------*
* AT SELECTION-SCREEN
*----------------------------------------------------------------------*

AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM EQ 'BUT1' .
    SUBMIT  ZSU_ROUTING_UPLOAD_EXCEL VIA SELECTION-SCREEN .
  ENDIF.


*---------------------------------------------------------------------*
*  At Selection-screen on value-request for p_file
*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
**To provide F4 Help for the file path on the Selection Screen
  PERFORM get_file CHANGING p_file.



START-OF-SELECTION.
* Upload the flat file
  PERFORM upload_file USING p_file.
*  changing it_records.
  IF gt_record IS INITIAL.
    MESSAGE e000 WITH 'No Data has been Uploaded'.
  ENDIF.

  PERFORM run_bdc.
*&---------------------------------------------------------------------*
*&      Form  GET_FILE
*&---------------------------------------------------------------------*
FORM get_file CHANGING pv_file TYPE rlgrap-filename.

*F4 for the File Path
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = pv_file.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  UPLOAD_FILE
*&---------------------------------------------------------------------*
FORM upload_file  USING pv_file TYPE rlgrap-filename.

  DATA: lv_filename TYPE rlgrap-filename,
        lv_raw      TYPE truxs_t_text_data.

  lv_filename = pv_file.

*Upload Excel File
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_tab_raw_data       = lv_raw
      i_filename           = lv_filename
    TABLES
      i_tab_converted_data = gt_record
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  RUN_BDC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM run_bdc .

  DATA ls_record TYPE ty_record.

  LOOP AT gt_record INTO ls_record.

    PERFORM bdc_dynpro  USING 'SAPLCPDI' '1010'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '/00'.
    PERFORM bdc_field   USING 'RC27M-MATNR'  ls_record-matnr.  "'21S011512C02000000'.
    PERFORM bdc_field   USING 'RC27M-WERKS'  ls_record-werks.  "'PL01'.
    PERFORM bdc_field   USING 'RC271-PLNNR'  ' '.
*    PERFORM bdc_field   USING 'RC271-STTAG'  '31.03.2017'.

    PERFORM bdc_dynpro  USING 'SAPLCPDA' '1200'.
*    PERFORM bdc_field   USING 'BDC_OKCODE'   '/00'.
    PERFORM bdc_field   USING 'BDC_OKCODE'    '=VOUE'.
    PERFORM bdc_field   USING 'PLKOD-PLNAL'  '1'.
    PERFORM bdc_field   USING 'PLKOD-KTEXT'  ls_record-ltxa1.
    "'21,SR,-,115,S12,FC,F07/F10/F12U,SERRAT'  & 'ED'.
*    PERFORM bdc_field   USING 'PLKOD-WERKS'  'PL01'.
    PERFORM bdc_field   USING 'PLKOD-VERWE'  ls_record-verwe.  "'1'.
    PERFORM bdc_field   USING 'PLKOD-STATU'  ls_record-statu.  "'4'.
*    PERFORM bdc_field   USING 'PLKOD-LOSBS'  '99,999,999'.
*    PERFORM bdc_field   USING 'PLKOD-PLNME'   'NOS'.

*    PERFORM bdc_dynpro  USING 'SAPLCPDA' '1200'.
*    PERFORM bdc_field   USING 'BDC_OKCODE'    '=VOUE'.
*    PERFORM bdc_field   USING 'PLKOD-KTEXT'  '21,SR,-,115,S12,FC,F07/F10/F12U,SERRAT'  & 'ED'.
*    PERFORM bdc_field   USING 'PLKOD-WERKS'   'PL01'.
*    PERFORM bdc_field   USING 'PLKOD-VERWE'  '1'.
*    PERFORM bdc_field   USING 'PLKOD-STATU'  '4'.
*    PERFORM bdc_field   USING 'PLKOD-LOSBS'  '99,999,999'.
*    PERFORM bdc_field   USING 'PLKOD-PLNME'  'NOS'.

    PERFORM bdc_dynpro  USING 'SAPLCPDI' '1400'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '/00'.
    PERFORM bdc_field   USING 'PLPOD-ARBPL(01)' ls_record-arbpl.   "'ACT'.

*    PERFORM bdc_dynpro  USING 'SAPLCPDI' '1400'.
*    PERFORM bdc_field   USING 'BDC_OKCODE'  '/00'.
*    PERFORM bdc_field   USING 'RC27X-ENTRY_ACT'  '1'.
    PERFORM bdc_field   USING 'PLPOD-STEUS(01)'  ls_record-steus.
    PERFORM bdc_field   USING 'PLPOD-LTXA1(01)'  ls_record-ltxa1.
    "'21,SR,-,115,S12,FC,F07/F10/F12U,SERRAT' & 'ED'.
    PERFORM bdc_field   USING 'PLPOD-VGW01(01)'  ls_record-vgw01.   "'37'.
    PERFORM bdc_field   USING 'PLPOD-VGE01(01)'  ls_record-vge01.   "

    PERFORM bdc_dynpro  USING 'SAPLCPDI' '1400'.
    PERFORM bdc_field   USING 'BDC_OKCODE'   '=MATA'.
    PERFORM bdc_field   USING 'RC27X-ENTRY_ACT'  '1'.
    PERFORM bdc_field   USING 'RC27X-FLG_SEL(01)'   'X'.

    PERFORM bdc_dynpro  USING 'SAPLCMDI' '1000'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '=MARA'.

    PERFORM bdc_dynpro  USING 'SAPLCMDI' '1000'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '=NEW'.

    PERFORM bdc_dynpro  USING 'SAPLCM01' '1090'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '=GOON'.
    PERFORM bdc_field   USING 'RCM01-VORNR'  '0010'.
    PERFORM bdc_field   USING 'RCM01-PLNFL'  '0'.

    PERFORM bdc_dynpro  USING 'SAPLCMDI' '1000'.
    PERFORM bdc_field   USING 'BDC_OKCODE'  '=BU'.
    PERFORM bdc_transaction USING 'CA01'.

  ENDLOOP.

ENDFORM.
*&--------------------------------------------------------------------*
*&      Form  bdc_dynpro
*&--------------------------------------------------------------------*
FORM bdc_dynpro  USING rprogram TYPE bdc_prog
                       rdynpro  TYPE bdc_dynr.

*Work Area for the Internal table T_BDCDATA
  DATA : wa_bdcdata TYPE bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-program  = rprogram.
  wa_bdcdata-dynpro   = rdynpro.
  wa_bdcdata-dynbegin = c_x.
  APPEND wa_bdcdata TO gt_bdcdata.

ENDFORM.                    " bdc_dynpro
*&--------------------------------------------------------------------*
*&      Form  bdc_field
*&--------------------------------------------------------------------*
FORM bdc_field  USING rfnam TYPE fnam_____4
                      rfval.
*Work Area for the Internal table T_BDCDATA
  DATA : wa_bdcdata TYPE bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = rfnam.
  wa_bdcdata-fval = rfval.
  APPEND wa_bdcdata TO gt_bdcdata.

ENDFORM.                    " bdc_field
*----------------------------------------------------------------------*
*        Start new transaction according to parameters                 *
*----------------------------------------------------------------------*
FORM bdc_transaction USING tcode.

  DATA: l_mstring(480).
  DATA: messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE.
  DATA: l_subrc LIKE sy-subrc,
        ctumode LIKE ctu_params-dismode VALUE 'N',
        cupdate LIKE ctu_params-updmode VALUE 'L'.

  IF p1 = 'X'.
    ctumode = 'A'.
  ELSE.
    ctumode = 'N'.
  ENDIF.

  REFRESH messtab.
  CALL TRANSACTION tcode USING gt_bdcdata
                   MODE   ctumode
                   UPDATE cupdate
                   MESSAGES INTO messtab.
  l_subrc = sy-subrc.
*    IF SMALLLOG <> 'X'.
  WRITE: / 'CALL_TRANSACTION', tcode,
           'returncode:'(i05),
           l_subrc,  'RECORD:', sy-index.
  LOOP AT messtab.
    MESSAGE ID     messtab-msgid
            TYPE   messtab-msgtyp
            NUMBER messtab-msgnr
            INTO l_mstring
            WITH messtab-msgv1
                 messtab-msgv2
                 messtab-msgv3
                 messtab-msgv4.
    WRITE: / messtab-msgtyp, l_mstring(250).
  ENDLOOP.
  WRITE: / '!----------------*--------------->'.
  SKIP.
*    ENDIF.
  REFRESH gt_bdcdata.
ENDFORM.
