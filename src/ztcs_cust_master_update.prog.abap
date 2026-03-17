*&---------------------------------------------------------------------*
*&  Report ZTCS_CUST_MASTER_UPDATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTCS_CUST_MASTER_UPDATE
       no standard page heading line-size 255.
*--------------------data declaration------------------------------------------------*
TYPE-POOLS ole2 .

DATA: application TYPE ole2_object,
      workbook    TYPE ole2_object,
      sheet       TYPE ole2_object,
      cells       TYPE ole2_object,
      cell1       TYPE ole2_object,
      cell2       TYPE ole2_object,
      range       TYPE ole2_object,
      font        TYPE ole2_object,
      column      TYPE ole2_object,
      shading     TYPE ole2_object,
      border      TYPE ole2_object.
CONSTANTS: row_max TYPE i VALUE 256.
DATA index TYPE i.
DATA: ld_colindx TYPE i,   "COLUMN INDEX
      ld_rowindx TYPE i.   "ROW INDEX

TYPES: BEGIN OF t_data,
         field1  TYPE string,
         field2  TYPE string,
         field3  TYPE string,
         field4  TYPE string,
         field5  TYPE string,
         field6  TYPE string,
         field7  TYPE string,
         field8  TYPE string,
         field9  TYPE string,
*         field10 TYPE string,
*         field11 TYPE string,
*         field12 TYPE string,
*         field13 TYPE string,
*         field14 TYPE string,
*         field15 TYPE string,
       END OF t_data.

DATA: it_col_no     TYPE STANDARD TABLE OF t_data,
      wa_col_no     LIKE LINE OF it_col_no,
      it_header     TYPE STANDARD TABLE OF t_data,
      wa_header     LIKE LINE OF it_header,
      it_sub_header TYPE STANDARD TABLE OF t_data,
      wa_sub_header LIKE LINE OF it_sub_header,
      it_data       TYPE STANDARD TABLE OF t_data,
      wa_data       LIKE LINE OF it_data.

*FIELD SYMBOL TO HOLD VALUES
FIELD-SYMBOLS: <fs>.

DATA: BEGIN OF itab1 OCCURS 0, first_name(10), END OF itab1.
DATA: BEGIN OF itab2 OCCURS 0, last_name(10), END OF itab2.
DATA: BEGIN OF itab3 OCCURS 0, formula(50), END OF itab3.

TYPES : BEGIN OF   ty_log,
          werks  TYPE string,
          matnr  TYPE string,
          plnty  TYPE string,
          verid  TYPE string,
          text1  TYPE string,
          adatu  TYPE string,
          bdatu  TYPE string,
          bstmi  TYPE string,
          bstma  TYPE string,
          plnnr  TYPE string,
          alnal  TYPE string,
          stlal  TYPE string,
          stlan  TYPE string,
          serkz  TYPE string,
          mdv01  TYPE string,
          status TYPE string,
        END   OF ty_log.

TYPES:BEGIN OF ty_fname,
        fname(50) TYPE c,
      END OF ty_fname.

DATA :lt_log        TYPE TABLE OF ty_log WITH HEADER LINE.
*      LT_BDCDATA    TYPE TABLE OF BDCDATA WITH HEADER LINE,
*      LT_BDCMSGCOLL TYPE TABLE OF BDCMSGCOLL WITH HEADER LINE.

DATA :lt_fname TYPE TABLE OF ty_fname,
      ls_fname TYPE ty_fname.


TYPES: BEGIN OF ty_final, "user defined types as per flat file
         kunnr      TYPE RF02D-kunnr,
         bukrs      TYPE rf02d-bukrs,
         vkorg      TYPE mvke-vkorg,
         vtweg      TYPE mvke-vtweg,
         division   TYPE RF02D-SPART,
*         pan_no     TYPE J_1IMOCUST-J_1IPANNO,
         aadhar_no  TYPE J_1IMOCUST-AADHAAR_NO,
         taxkd      TYPE KNVI-TAXKD,
       END OF ty_final.
DATA : it_final TYPE TABLE OF ty_final, "mara internal table
       wa_final TYPE ty_final. "mara work area
DATA: it_bdcdata TYPE TABLE OF bdcdata . "BDCDATA
DATA: wa_bdcdata TYPE bdcdata . "work area BDCDATA
DATA : bdcmsg TYPE TABLE OF bdcmsgcoll. "BDC message table
DATA : raw_data(4096) TYPE c OCCURS 0.

TABLES :sscrfields.

*------------------------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE gitl.
*SELECTION-SCREEN SKIP.
PARAMETERS : p_file TYPE rlgrap-filename.
PARAMETERS : ctu_mode LIKE ctu_params-dismode DEFAULT 'E'.
SELECTION-SCREEN:END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
SELECTION-SCREEN END OF LINE.

*&*--------------------------------------------------------------------*
*&*   INITIALIZATION
*&*--------------------------------------------------------------------*
INITIALIZATION.
  "GITL = 'Selection Screen'.

  w_button = 'Download Excel Template'.


AT SELECTION-SCREEN.
  IF sscrfields-ucomm EQ 'BUT1'.
    SUBMIT zsd_uplaod_excel VIA SELECTION-SCREEN.
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
*     FIELD_NAME    = ' '
    IMPORTING
      file_name     = p_file.
*--------------------------------------------------------------------*
START-OF-SELECTION.


  PERFORM get_data.

*--------------------------------------------------------------------*


start-of-selection.

LOOP AT it_final INTO wa_final.

    REFRESH it_bdcdata.

perform bdc_dynpro      using 'SAPMF02D' '0101'.
perform bdc_field       using 'BDC_CURSOR'
                              'RF02D-D0320'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'RF02D-KUNNR'
                              wa_final-kunnr. "'16'.
perform bdc_field       using 'RF02D-BUKRS'
                              wa_final-bukrs. ".'1000'.
perform bdc_field       using 'RF02D-VKORG'
                              wa_final-vkorg. "'1000'.
perform bdc_field       using 'RF02D-VTWEG'
                              wa_final-vtweg."'01'.
perform bdc_field       using 'RF02D-SPART'
                              wa_final-division."'01'.
perform bdc_field       using 'RF02D-D0110'
                              'X'.
perform bdc_field       using 'RF02D-D0320'
                              'X'.
perform bdc_dynpro      using 'SAPMF02D' '0110'.
perform bdc_field       using 'BDC_CURSOR'
                              'KNA1-ANRED'.
perform bdc_field       using 'BDC_OKCODE'
                              '=OPFI'.
*perform bdc_field       using 'KNA1-ANRED'
*                              'Ms.'.
*perform bdc_field       using 'KNA1-NAME1'
*                              'TATA MOTORS LTD-R001'.
*perform bdc_field       using 'KNA1-SORTL'
*                              '05AAACT272'.
*perform bdc_field       using 'KNA1-NAME2'
*                              '35'.
*perform bdc_field       using 'KNA1-STRAS'
*                              '1'.
*perform bdc_field       using 'KNA1-ORT01'
*                              'UDHAMSINGH NAGAR'.
*perform bdc_field       using 'KNA1-PSTLZ'
*                              '412308'.
*perform bdc_field       using 'KNA1-LAND1'
*                              'IN'.
*perform bdc_field       using 'KNA1-REGIO'
*                              '35'.
*perform bdc_field       using 'KNA1-SPRAS'
*                              'EN'.
*perform bdc_field       using 'KNA1-TELFX'
*                              '080-7287076-79'.
perform bdc_dynpro      using 'SAPLJ1I_MASTER' '0200'.
perform bdc_field       using 'BDC_OKCODE'
                              '=CIN_CUSTOMER_FC3'.
perform bdc_field       using 'BDC_CURSOR'
                              'J_1IMOCUST-J_1IEXCD'.
*perform bdc_field       using 'J_1IMOCUST-J_1IEXCD'
*                              'AAACT2727QXM017'.
*perform bdc_field       using 'J_1IMOCUST-J_1IEXCICU'
*                              '1'.
perform bdc_dynpro      using 'SAPLJ1I_MASTER' '0200'.
perform bdc_field       using 'BDC_OKCODE'
                              '=CIN_CUSTOMER_FC5'.
perform bdc_field       using 'BDC_CURSOR'
                              'J_1IMOCUST-J_1IPANNO'.
*perform bdc_field       using 'J_1IMOCUST-J_1IPANNO'
*                               wa_final-pan_no." 'AAACT2727O'.
perform bdc_dynpro      using 'SAPLJ1I_MASTER' '0200'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BACK'.
perform bdc_field       using 'BDC_CURSOR'
                              'J_1IMOCUST-AADHAAR_NO'.
perform bdc_field       using 'J_1IMOCUST-AADHAAR_NO'
                              wa_final-aadhar_no."'123456789012'.
perform bdc_dynpro      using 'SAPMF02D' '0110'.
perform bdc_field       using 'BDC_CURSOR'
                              'KNA1-ANRED'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
*perform bdc_field       using 'KNA1-ANRED'
*                              'Ms.'.
*perform bdc_field       using 'KNA1-NAME1'
*                              'TATA MOTORS LTD-R001'.
*perform bdc_field       using 'KNA1-SORTL'
*                              '05AAACT272'.
*perform bdc_field       using 'KNA1-NAME2'
*                              '35'.
*perform bdc_field       using 'KNA1-STRAS'
*                              '1'.
*perform bdc_field       using 'KNA1-ORT01'
*                              'UDHAMSINGH NAGAR'.
*perform bdc_field       using 'KNA1-PSTLZ'
*                              '412308'.
*perform bdc_field       using 'KNA1-LAND1'
*                              'IN'.
*perform bdc_field       using 'KNA1-REGIO'
*                              '35'.
*perform bdc_field       using 'KNA1-SPRAS'
*                              'EN'.
*perform bdc_field       using 'KNA1-TELFX'
*                              '080-7287076-79'.
perform bdc_dynpro      using 'SAPMF02D' '0320'.
perform bdc_field       using 'BDC_CURSOR'
                              'KNVV-PERFK'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
*perform bdc_field       using 'KNVV-INCO1'
*                              'FH'.
*perform bdc_field       using 'KNVV-INCO2'
*                              'UDHAMSINGH NAGAR'.
*perform bdc_field       using 'KNVV-ZTERM'
*                              'YP31'.
*perform bdc_field       using 'KNVV-KTGRD'
*                              '01'.
perform bdc_dynpro      using 'SAPMF02D' '1350'.
perform bdc_field       using 'BDC_CURSOR'
                              'KNVI-TAXKD(05)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'KNVI-TAXKD(05)'
                             wa_final-taxkd." '0'.
perform bdc_dynpro      using 'SAPMF02D' '1350'.
perform bdc_field       using 'BDC_CURSOR'
                              'KNVI-TAXKD(05)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=UPDA'.
*perform bdc_transaction using 'XD02'.


CALL TRANSACTION 'XD02' USING it_bdcdata "call transaction
                              MODE ctu_mode"'A' "N-no screen mode, A-all screen mode, E-error screen mode
                              UPDATE 'S' "'A' "A-assynchronous, S-synchronous
                              MESSAGES INTO  bdcmsg. "messages
    IF sy-subrc IS INITIAL.
      MESSAGE 'Data Uploaded Successfully.' TYPE 'S'.
    ENDIF.

CLEAR : wa_final.

ENDLOOP.


DATA : wa_bdcmsg LIKE LINE OF bdcmsg.
  IF bdcmsg IS NOT INITIAL. "display messages
    LOOP AT bdcmsg INTO wa_bdcmsg.
      WRITE:/ wa_bdcmsg-tcode, wa_bdcmsg-msgtyp, wa_bdcmsg-msgv1, wa_bdcmsg-fldname .
      CLEAR wa_bdcmsg.
    ENDLOOP.
  ENDIF.
FORM bdc_dynpro USING program dynpro.
  CLEAR wa_bdcdata.
  wa_bdcdata-program  = program. "program
  wa_bdcdata-dynpro   = dynpro. "screen
  wa_bdcdata-dynbegin = 'X'. "begin
  APPEND wa_bdcdata TO it_bdcdata..
ENDFORM.

FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = fnam. "field name ex: matnr
  wa_bdcdata-fval = fval. "field value ex: testmat001
  APPEND wa_bdcdata TO it_bdcdata.
*  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = raw_data
      i_filename           = p_file
    TABLES
      i_tab_converted_data = it_final
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.
