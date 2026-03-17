report ZBDC_MR21
       no standard page heading line-size 255.

TYPES : begin of t_excel_data,
        budat(10) TYPE c,
        bukrs(4) type c,
        werks(4) type c,
        matnr(18) type c,
        bwtar(10) type c,
        valpr(13) type c,
END OF t_excel_data.
types: BEGIN OF t_header_data,
      budat(10) TYPE c,
      bukrs(4) type c,
      werks(4) type c,
 end of t_header_data.


data : gt_excel_data type STANDARD TABLE OF t_excel_data,
       gs_excel_data type t_excel_data,
       gt_header_data TYPE STANDARD TABLE OF t_header_data,
       gs_header_data TYPE t_header_data,
       gt_bdcdata TYPE STANDARD TABLE OF bdcdata,
       gs_bdcdata TYPE bdcdata,
       gt_msgcoll type STANDARD TABLE OF bdcmsgcoll,
       gs_msgcoll TYPE bdcmsgcoll,

       gt_TAB_RAW_DATA(4096) type c OCCURS 0.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-009.
  PARAMETERS: f_name TYPE rlgrap-filename.
  PARAMETERS : mode TYPE mode DEFAULT 'E'.
SELECTION-SCREEN: end of BLOCK b1.
at SELECTION-SCREEN ON VALUE-REQUEST FOR f_name.

*DATA PROGRAM_NAME  TYPE SY-REPID.
*DATA DYNPRO_NUMBER TYPE SY-DYNNR.
*DATA FIELD_NAME    TYPE DYNPREAD-FIELDNAME.
*DATA FILE_NAME     TYPE IBIPPARMS-PATH.

CALL FUNCTION 'F4_FILENAME'
 EXPORTING
   PROGRAM_NAME        = SY-repid
   DYNPRO_NUMBER       = SY-DYNNR
*   FIELD_NAME          = ' '
 IMPORTING
   FILE_NAME           = F_NAME
          .

start-of-selection.

*DATA I_FIELD_SEPERATOR    TYPE CHAR01.
*DATA I_LINE_HEADER        TYPE CHAR01.
*DATA I_TAB_RAW_DATA       TYPE TRUXS_T_TEXT_DATA.
*DATA I_FILENAME           TYPE RLGRAP-FILENAME.
*DATA I_TAB_CONVERTED_DATA TYPE STANDARD TABLE.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          = I_FIELD_SEPERATOR
*   I_LINE_HEADER              = I_LINE_HEADER
    I_TAB_RAW_DATA             = gt_TAB_RAW_DATA
    I_FILENAME                 = f_name
  TABLES
    I_TAB_CONVERTED_DATA       = gt_excel_data
* EXCEPTIONS
*   CONVERSION_FAILED          = 1
          .
DELETE gt_excel_data INDEX 1.
MOVE-CORRESPONDING gt_excel_data to gt_header_data.
sort gt_header_data by budat bukrs werks.
delete ADJACENT DUPLICATES FROM gt_header_data COMPARING budat bukrs werks.
loop at gt_header_data
  into gs_header_data.
REFRESH gt_bdcdata.
perform bdc_dynpro      using 'SAPRCKM_MR21' '0201'.
perform bdc_field       using 'BDC_CURSOR'
                              'MR21HEAD-WERKS'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MR21HEAD-BUDAT'
                              gs_header_data-budat."'05.09.2015'.
perform bdc_field       using 'MR21HEAD-BUKRS'
                              gs_header_data-bukrs."'1000'.
perform bdc_field       using 'MR21HEAD-WERKS'
                              gs_header_data-werks."'1010'.
perform bdc_field       using 'MR21HEAD-SCREEN_VARIANT'
                              'MR21_LAGERMATERIAL_0250'.


perform bdc_dynpro      using 'SAPRCKM_MR21' '0201'.
perform bdc_field       using 'BDC_OKCODE'
                              '=PICK'.
data counter(3) TYPE c VALUE 1.
data str TYPE string.
loop at gt_excel_data
  INTO gs_excel_data
  WHERE budat = gs_header_data-budat
  AND bukrs = gs_header_data-bukrs
  AND werks = gs_header_data-werks.

perform bdc_field       using 'BDC_CURSOR'
                              'CKI_MR21_0250-NEWVALPR(01)'.
perform bdc_field       using 'MR21HEAD-SCREEN_VARIANT'
                              'MR21_LAGERMATERIAL_BWKEY_0250'.


 CLEAR str.
 CONCATENATE  'CKI_MR21_0250-MATNR(0' counter ')' INTO str .
 CONDENSE str NO-GAPS .
perform bdc_field       using str "'CKI_MR21_0250-MATNR(01)'
                              gs_excel_data-matnr."'14006598'.

  CLEAR str.
  CONCATENATE  'CKI_MR21_0250-BWTAR(0' counter ')' INTO str .
  CONDENSE str NO-GAPS.

perform bdc_field       using str "'CKI_MR21_0250-BWTAR(01)'
                              gs_excel_data-bwtar."'IMPORT.COM'.

  CLEAR str.
  CONCATENATE  'CKI_MR21_0250-NEWVALPR(0' counter ')' INTO str .
  CONDENSE str NO-GAPS.

perform bdc_field       using str"'CKI_MR21_0250-NEWVALPR(02)'
                              gs_excel_data-valpr.

perform bdc_dynpro      using 'SAPRCKM_MR21' '0201'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
*perform bdc_field       using 'BDC_CURSOR'
*                              'CKI_MR21_0250-NEWVALPR(02)'.
*perform bdc_field       using 'MR21HEAD-SCREEN_VARIANT'
*                              'MR21_LAGERMATERIAL_BWKEY_0250'.
*perform bdc_field       using 'CKI_MR21_0250-MATNR(02)'
*                              '14006598'.
*perform bdc_field       using 'CKI_MR21_0250-BWTAR(02)'
*                              'LOCAL.COMP'.
*perform bdc_field       using 'CKI_MR21_0250-NEWVALPR(02)'
*
counter = counter + 1.
CLEAR gs_excel_data.
if counter = 12.
       perform bdc_field       using 'BDC_OKCODE'
                              '=DOWN'.
       perform bdc_dynpro      using 'SAPRCKM_MR21' '0201'.
       perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
ENDIF.                   "  '1'.
IF COUNTER =  12.
COUNTER = 3.
ENDIF.
endloop.
perform bdc_dynpro      using 'SAPRCKM_MR21' '0201'.
perform bdc_field       using 'BDC_OKCODE'
                              '=SAVE'.
perform bdc_field       using 'BDC_CURSOR'
                              'CKI_MR21_0250-MATNR(03)'.
perform bdc_field       using 'MR21HEAD-SCREEN_VARIANT'
                              'MR21_LAGERMATERIAL_BWKEY_0250'.
call transaction 'MR21'
USING gt_bdcdata
      mode Mode
      UPDATE 'S'
      MESSAGES INTO gt_msgcoll.
CLEAR gs_header_data.
ENDLOOP.
loop at gt_msgcoll INTO gs_msgcoll WHERE msgtyp = 'E'.
WRITE : / gs_msgcoll-msgv1 ,gs_msgcoll-msgv2, gs_msgcoll-msgv3 .
ENDLOOP.
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR gs_BDCDATA.
  gs_BDCDATA-PROGRAM  = PROGRAM.
  gs_BDCDATA-DYNPRO   = DYNPRO.
  gs_BDCDATA-DYNBEGIN = 'X'.
  APPEND gs_BDCDATA to gt_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  IF FVAL <> ''.
    CLEAR gs_BDCDATA.
    gs_BDCDATA-FNAM = FNAM.
    gs_BDCDATA-FVAL = FVAL.
    APPEND gs_BDCDATA to gt_bdcdata.
  ENDIF.
ENDFORM.
