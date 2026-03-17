report ZUSOP_NEW
       no standard page heading line-size 255.

*include bdcrecx1.
*
*parameters: dataset(132) lower case.
***    DO NOT CHANGE - the generated data section - DO NOT CHANGE    ***
*
*   If it is nessesary to change the data section use the rules:
*   1.) Each definition of a field exists of two lines
*   2.) The first line shows exactly the comment
*       '* data element: ' followed with the data element
*       which describes the field.
*       If you don't have a data element use the
*       comment without a data element name
*   3.) The second line shows the fieldname of the
*       structure, the fieldname must consist of
*       a fieldname and optional the character '_' and
*       three numbers and the field length in brackets
*   4.) Each field must be type C.
*
***** Generated data section with specific formatting - DO NOT CHANGE  ***
**data: begin of record,
*** data element: VBELN_VA
**        VBELN_001(030),
*** data element: BSTKD
**        BSTKD_002(035),
*** data element: BSTDK
**        BSTDK_003(010),
*** data element: KUNWE
**        KUNNR_004(010),
*** data element: KETDAT
**        KETDAT_005(010),
*** data element: KPRGBZ
**        KPRGBZ_006(001),
*** data element: PRSDT
**        PRSDT_007(010),
*** data element: DZTERM
**        ZTERM_008(004),
*** data element: INCO1
**        INCO1_009(003),
*** data element: INCO2
**        INCO2_010(028),
**      end of record.
**
***** End generated data section ***

*start-of-selection.
*
*perform open_dataset using dataset.
*perform open_group.
*
*do.

*read dataset dataset into record.
*if sy-subrc <> 0. exit. endif.

TYPES : BEGIN OF ty_final,
  VBELN     TYPE VBAK-VBELN,
  BSTKD     TYPE VBKD-BSTKD,
  BSTDK     TYPE VBKD-BSTDK,
  KUNNR     TYPE KUWEV-KUNNR,
  KETDAT    TYPE RV45A-KETDAT,
  KPRGBZ    TYPE RV45A-KPRGBZ,
  PRSDT     TYPE VBKD-PRSDT,
  ZTERM     TYPE VBKD-ZTERM,
  INCO1     TYPE VBKD-INCO1,
  INCO2     TYPE VBKD-INCO2,
  END OF ty_final.

DATA: lt_final TYPE TABLE Of ty_final,
      ls_final TYPE ty_final.

TYPES  : BEGIN OF t_error,
           infnr TYPE eina-infnr, "info type
         END OF t_error.

DATA : gt_error TYPE STANDARD TABLE OF t_error,
       gs_error TYPE t_error.

DATA : lt_bdcdata TYPE TABLE OF bdcdata WITH HEADER LINE, "BDCDATA
       ls_bdcdata LIKE lt_bdcdata . "work area BDCDATA
DATA : lt_msg     TYPE TABLE OF bdcmsgcoll,   " Collecting Error messages
       ls_msg     TYPE bdcmsgcoll,
       w_msg1(51).

TYPES :  fs_struct(4096) TYPE c OCCURS 0.

DATA: w_struct TYPE fs_struct.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_file TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

start-of-selection.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = w_struct
      i_filename           = p_file
    TABLES
      i_tab_converted_data = lt_final
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
*perform open_group.

LOOP AT lt_final INTO ls_final.

  REFRESH lt_bdcdata.
  CLEAR ls_bdcdata.

perform bdc_dynpro      using 'SAPMV45A' '0102'.
perform bdc_field       using 'BDC_CURSOR'
                              'VBAK-VBELN'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'VBAK-VBELN'
                              ls_final-VBELN."record-VBELN_001.
perform bdc_dynpro      using 'SAPMV45A' '4001'.
perform bdc_field       using 'BDC_OKCODE'
                              '=KDOK'.
*perform bdc_field       using 'VBKD-BSTKD'
*                               record-BSTKD_002.
*perform bdc_field       using 'VBKD-BSTDK'
*                               record-BSTDK_003.
*perform bdc_field       using 'KUWEV-KUNNR'
*                               record-KUNNR_004.
*perform bdc_field       using 'RV45A-KETDAT'
*                              record-KETDAT_005.
*perform bdc_field       using 'RV45A-KPRGBZ'
*                              record-KPRGBZ_006.
*perform bdc_field       using 'VBKD-PRSDT'
*                              record-PRSDT_007.
*perform bdc_field       using 'VBKD-ZTERM'
*                              record-ZTERM_008.
*perform bdc_field       using 'VBKD-INCO1'
*                              record-INCO1_009.
*perform bdc_field       using 'VBKD-INCO2'
*                              record-INCO2_010.
perform bdc_field       using 'BDC_CURSOR'
                              'RV45A-MABNR(01)'.
perform bdc_dynpro      using 'SAPDV70A' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'DNAST-KSCHL(01)'.
perform bdc_field       using 'BDC_OKCODE'
                              '=V70S'.
*perform bdc_transaction using 'VA02'.

CALL TRANSACTION 'VA02' USING lt_bdcdata "call transaction
     MODE 'N' "N-no screen mode, A-all screen mode, E-error screen mode
     UPDATE 'S' "A-assynchronous, S-synchronous
     MESSAGES INTO lt_msg. "messages

CLEAR ls_final .

ENDLOOP.

**enddo.
**
**perform close_group.
**perform close_dataset using dataset.
*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR lt_bdcdata.
  lt_bdcdata-program  = program.
  lt_bdcdata-dynpro   = dynpro.
  lt_bdcdata-dynbegin = 'X'.
  APPEND lt_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF fval <> space.
    CLEAR lt_bdcdata.
    lt_bdcdata-fnam = fnam.
    lt_bdcdata-fval = fval.
*    SHIFT lt_bdcdata-fval LEFT DELETING LEADING space.
    APPEND lt_bdcdata.
*  ENDIF.
ENDFORM.
