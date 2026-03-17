*&---------------------------------------------------------------------*
*& Report YMM_MAT_CIN_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_MM_UPLOAD_MAT_CIN
       NO STANDARD PAGE HEADING LINE-SIZE 255.

DATA: wa_file-matnr      TYPE matnr,
      wa_file-werks      TYPE t001w-werks,
      wa_file-j_1ichid   TYPE j_1ichid,
      wa_file-j_1igrxref TYPE j_1igrxref-mblnr,
      wa_file-j_1icapind TYPE j_1icapind,
      wa_file-j_1imoom   TYPE j_1imoom,
      wa_file-j_1iassval TYPE j_1iassval-j_1ivalass,
      wa_file-mtart      TYPE mara-mtart,
      wa_file-j_1isubind TYPE j_1imtchid-j_1isubind,
      wa_file-mtpos_mara TYPE mara-mtpos_mara.
DATA : bdcdata LIKE bdcdata    OCCURS 0 WITH HEADER LINE.
DATA : v_assval TYPE char14.

*>>
SELECTION-SCREEN BEGIN OF LINE.
*  PARAMETERS SESSION RADIOBUTTON GROUP CTU.  "create session
*  SELECTION-SCREEN COMMENT 3(20) TEXT-S07 FOR FIELD SESSION.
*  selection-screen position 45.
*  PARAMETERS CTU RADIOBUTTON GROUP  CTU.     "call transaction
*  SELECTION-SCREEN COMMENT 48(20) TEXT-S08 FOR FIELD CTU.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN BEGIN OF LINE.
*  SELECTION-SCREEN COMMENT 3(20) TEXT-S01 FOR FIELD GROUP.
*  selection-screen position 25.
*  PARAMETERS GROUP(12).                      "group name of session
*  SELECTION-SCREEN COMMENT 48(20) TEXT-S05 FOR FIELD CTUMODE.
SELECTION-SCREEN POSITION 70.
PARAMETERS ctumode LIKE ctu_params-dismode DEFAULT 'N' NO-DISPLAY.
PARAMETERS cupdate LIKE ctu_params-updmode DEFAULT 'L' NO-DISPLAY.
"A: show all dynpros
"E: show dynpro on error only
"N: do not display dynpro
SELECTION-SCREEN END OF LINE.
*include bdcrecx1.

*>>
START-OF-SELECTION.

  IMPORT wa_file-matnr wa_file-mtart wa_file-werks wa_file-j_1ichid
         wa_file-j_1igrxref wa_file-j_1icapind
         wa_file-j_1imoom wa_file-j_1iassval wa_file-j_1isubind
         wa_file-mtpos_mara
  FROM MEMORY ID 'zcin'.

  PERFORM bdc_dynpro   USING 'SAPLMGMM' '0060'.
  PERFORM bdc_field    USING 'BDC_OKCODE'  '=ENTR'.
  PERFORM bdc_field    USING 'RMMG1-MATNR'   wa_file-matnr .

  PERFORM bdc_dynpro   USING 'SAPLMGMM' '0070'.
  PERFORM bdc_field    USING 'BDC_CURSOR' 'MSICHTAUSW-DYTXT(06)'.
  "'MSICHTAUSW-DYTXT(09)'.
  PERFORM bdc_field    USING 'BDC_OKCODE'  '=ENTR'.
  PERFORM bdc_field    USING 'MSICHTAUSW-KZSEL(01)'     " 'MSICHTAUSW-KZSEL(09)'
                                'X'.

  PERFORM bdc_dynpro      USING 'SAPLMGMM' '4004'.
  PERFORM bdc_field       USING 'BDC_OKCODE'
                                '=SP07'.
  PERFORM bdc_field    USING 'MARA-MTPOS_MARA' wa_file-mtpos_mara.

  PERFORM bdc_dynpro   USING 'SAPLMGMM' '0081'.
  PERFORM bdc_field    USING 'BDC_OKCODE'  '=ENTR'.
  PERFORM bdc_field    USING 'RMMG1-WERKS'   'SU01'.

  PERFORM bdc_dynpro   USING 'SAPLMGMM' '4004'.      "'4000'.
  PERFORM bdc_field    USING 'BDC_OKCODE'  '/00'.
  PERFORM bdc_field    USING 'BDC_CURSOR'   'J_1IASSVAL-J_1IVALASS'.
  PERFORM bdc_field    USING 'J_1IMTCHID-J_1ICHID'    wa_file-j_1ichid."
  PERFORM bdc_field    USING 'J_1IMTCHID-J_1ISUBIND'  wa_file-j_1isubind.
*                              'X'.
  PERFORM bdc_field    USING 'J_1IMTCHID-J_1ICAPIND'  wa_file-j_1icapind. "
  PERFORM bdc_field    USING 'J_1IMTCHID-J_1IGRXREF'  wa_file-j_1igrxref."
  PERFORM bdc_field    USING 'J_1IMODDET-J_1IMOOM'    wa_file-matnr.
  v_assval =  wa_file-j_1iassval.
  CONDENSE v_assval.
  PERFORM bdc_field    USING 'J_1IASSVAL-J_1IVALASS'  v_assval.
  PERFORM bdc_dynpro   USING 'SAPLSPO1' '0300'.
  PERFORM bdc_field    USING 'BDC_OKCODE'  '=YES'.

  PERFORM bdc_transaction USING 'MM02'.



*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF FVAL <> NODATA.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
*  ENDIF.
ENDFORM.                    "BDC_FIELD

*&---------------------------------------------------------------------*
*&      Form  BDC_TRANSACTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->TCODE      text
*----------------------------------------------------------------------*
FORM bdc_transaction USING tcode.
  DATA: l_mstring(480).
  DATA: l_subrc LIKE sy-subrc.
* batch input session
*  IF SESSION = 'X'.
*    CALL FUNCTION 'BDC_INSERT'
*         EXPORTING TCODE     = TCODE
*         TABLES    DYNPROTAB = BDCDATA.
*    IF SMALLLOG <> 'X'.
*      WRITE: / 'BDC_INSERT'(I03),
*               TCODE,
*               'returncode:'(I05),
*               SY-SUBRC,
*               'RECORD:',
*               SY-INDEX.
*    ENDIF.
** call transaction using
*  ELSE.
*    REFRESH MESSTAB.
  CALL TRANSACTION tcode USING bdcdata
                   MODE   ctumode
                   UPDATE cupdate.
*                     MESSAGES INTO MESSTAB.

  REFRESH bdcdata.
ENDFORM.                    "BDC_TRANSACTION
