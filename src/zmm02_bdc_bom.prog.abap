report ZBOM_1
       no standard page heading line-size 255.

**include bdcrecx1.
**
**parameters: dataset(132) lower case.
**
**data: begin of record,
** data element: MATNR
**        MATNR_001(018),
** data element: XFELD
**        KZSEL_01_002(001),
** data element: MAKTX
**        MAKTX_003(040),
** data element: ZSER_CODE
**        ZSERIES_004(003),
** data element: ZBRAND
**        BRAND_005(003),
** data element: ZTYP
**        TYPE_006(003),
** data element: ZMOC
**        MOC_007(003),
** data element: ZBOM
**        BOM_008(015),
** data element: MEINS
**        MEINS_009(003),
** data element: MATKL
**        MATKL_010(009),
** data element: GEWEI
**        GEWEI_011(003),
** data element:
**        DESC_LANGU_GDTXT_012(016),
**      end of record.

*** End generated data section ***
TABLES : sscrfields.

TYPES : BEGIN OF ty_tab,
        matnr TYPE char20,
*        KZSEL_01_002 TYPE char20,
*        xfeld type char20,
*        maktx TYPE char20,
*        ZSERIES TYPE char20,
*        zbrand TYPE char20,
*        ztyp TYPE char20,
*        zmoc TYPE char20,
        zbom TYPE char20,
*        meins TYPE char20,
*        matkl TYPE char20,
*        gewei TYPE char20,
*        DESC_LANGU_GDTXT TYPE char20,
        msg   type string,
      END OF ty_tab.


 data : raw_table type TRUXS_T_TEXT_DATA.

 data :itab type standard table of ty_tab,
       wa_tab type ty_tab.

 data : gv_file type RLGRAP-FILENAME.

data : messtab like bdcmsgcoll occurs 0 WITH HEADER LINE.

data : it_bdcdata type STANDARD TABLE OF BDCDATa,
       wa_bdcdata type BDCDATA.


SELECTION-SCREEN SKIP.


 PARAMETERS : p_file type IBIPPARMS-path,
              p_mode type char1 OBLIGATORY
             DEFAULT 'E'.
SELECTION-SCREEN SKIP.

SELECTION-SCREEN : BEGIN OF LINE.
  SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN : END OF LINE.


INITIALIZATION.
W_BUTTON = 'Download excel Template'.
AT SELECTION-SCREEN.
IF SSCRFIELDS-UCOMM EQ 'BUT1'.
    SUBMIT ZBDC_UPLOAD VIA SELECTION-SCREEN AND RETURN.
 ENDIF.

at SELECTION-SCREEN on VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
   EXPORTING
     PROGRAM_NAME        = SYST-CPROG
     DYNPRO_NUMBER       = SYST-DYNNR
*     FIELD_NAME          = ' '
   IMPORTING
     FILE_NAME           = p_file.
            .
 start-of-selection.
 clear: gv_file, itab[].
       gv_file = p_file.

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
   I_FIELD_SEPERATOR          = 'X'
   I_LINE_HEADER              = 'X'
    i_tab_raw_data            = raw_table
    i_filename                = gv_file
  TABLES
    i_tab_converted_data       = itab
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
*perform open_dataset using dataset.
*perform open_group.

*do.

*read dataset dataset into record.
*if sy-subrc <> 0. exit. endif.
loop at itab into wa_tab.
  refresh it_bdcdata.

perform bdc_dynpro      using 'SAPLMGMM' '0060'.
perform bdc_field       using 'BDC_CURSOR'
                              'RMMG1-MATNR'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'RMMG1-MATNR'
                              wa_tab-matnr."record-MATNR_001.
perform bdc_dynpro      using 'SAPLMGMM' '0070'.
perform bdc_field       using 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=ENTR'.
perform bdc_field       using 'MSICHTAUSW-KZSEL(01)'
                              'X'.
perform bdc_dynpro      using 'SAPLMGMM' '4004'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BU'.
*perform bdc_field       using 'MAKT-MAKTX'
*                              wa_tab-maktx."record-MAKTX_003.
*perform bdc_field       using 'BDC_CURSOR'
*                              'MARA-BOM'.
*perform bdc_field       using 'MARA-ZSERIES'
*                              wa_tab-zseries."record-ZSERIES_004.
*perform bdc_field       using 'MARA-BRAND'
*                              wa_tab-zbrand. "record-BRAND_005.
*perform bdc_field       using 'MARA-TYPE'
*                               wa_tab-ztyp." record-TYPE_006.
*perform bdc_field       using 'MARA-MOC'
*                              wa_tab-zmoc." record-MOC_007.
perform bdc_field       using 'MARA-BOM'
                              wa_tab-zbom. "record-BOM_008.
*perform bdc_field       using 'MARA-MEINS'
*                              wa_tab-meins. "record-MEINS_009.
*perform bdc_field       using 'MARA-MATKL'
*                              wa_tab-matkl. "record-MATKL_010.
*perform bdc_field       using 'MARA-GEWEI'
*                              wa_tab-gewei. "record-GEWEI_011.
*perform bdc_field       using 'DESC_LANGU_GDTXT'
*                              wa_tab-desc_langu_gdtxt. "record-DESC_LANGU_GDTXT_012.
**perform bdc_transaction using 'MM02'.

*enddo.

*perform close_group.
*perform close_dataset using dataset.

call TRANSACTION 'MM02' USING it_BDCDATA MODE p_mode
                        UPDATE 'E' MESSAGES INTO messtab.
if messtab[] is NOT INITIAL.

loop at messtab.

CALL FUNCTION 'MESSAGE_TEXT_BUILD'
  EXPORTING
   msgid                      = messtab-msgid
   msgnr                      = messtab-msgnr
   MSGV1                      = messtab-msgv1
   MSGV2                      = messtab-msgv2
   MSGV3                      = messtab-msgv3
   MSGV4                      = messtab-msgv4
 IMPORTING
   MESSAGE_TEXT_OUTPUT       = wa_tab-msg.

          MODIFY itab from wa_tab TRANSPORTING msg.

exit.
ENDLOOP.
ENDIF.

CLEAR wa_tab.

ENDLOOP.


FORM BDC_DYNPRO USING PROGRAM DYNPRO.
  CLEAR wa_BDCDATA.
  wa_BDCDATA-PROGRAM  = PROGRAM.
  wa_BDCDATA-DYNPRO   = DYNPRO.
  wa_BDCDATA-DYNBEGIN = 'X'.
  APPEND wa_bdcdata to it_BDCDATA.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM BDC_FIELD USING FNAM FVAL.
  IF FVAL <> space. "NODATA.
    CLEAR wa_BDCDATA.
    wa_BDCDATA-FNAM = FNAM.
    wa_BDCDATA-FVAL = FVAL.
    APPEND wa_BDCDATA to it_bdcdata.
  ENDIF.
ENDFORM.
