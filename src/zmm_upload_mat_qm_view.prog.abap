*&---------------------------------------------------------------------*
*& Report ZMM_UPLOAD_MAT_QM_VIEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm_upload_mat_qm_view
  NO STANDARD PAGE HEADING LINE-SIZE 255.


TYPES: BEGIN OF t_log,
         ind       LIKE sy-tabix,
         typ(1),
         matnr     LIKE rmmg1-matnr,
         msg(1000),
       END OF t_log.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,  "Material Number
         qmpur TYPE mara-qmpur,  "QM in Procurement is Active
         mtart TYPE mara-mtart,  "Material Type
         maktx TYPE makt-maktx,
       END OF ty_mara.

*Internal Table
DATA : v_mtart LIKE mara-mtart.
DATA : BEGIN OF it_mm01 OCCURS 0,
         matnr LIKE rmmg1-matnr,  "Material Number
         werks TYPE werks_d,      "Plant
         art   LIKE rmqam-art,    "Inspection Type
         rmqam LIKE rmqam-aktiv,  "Inspection Type - Material Combination is Active-INDICATOR
       END OF it_mm01.

DATA: it_mara TYPE STANDARD TABLE OF ty_mara,
      wa_mara TYPE ty_mara.
DATA: bdcdata  LIKE bdcdata OCCURS 0 WITH HEADER LINE,
      bdcdata1 LIKE bdcdata OCCURS 0 WITH HEADER LINE.

DATA: messtab LIKE bdcmsgcoll OCCURS 0 WITH HEADER LINE.

DATA: i_log TYPE t_log OCCURS 0 WITH HEADER LINE.
DATA: i_slog  TYPE t_log OCCURS 0 WITH HEADER LINE,
      wa_slog TYPE t_log.
DATA: ind LIKE sy-tabix.
DATA: p_matnr LIKE rmmg1-matnr.
DATA: msg(1000).
DATA: l_mtart TYPE mara-mtart.
DATA: ls_errtxt TYPE string. "Error Line
DATA: BEGIN OF it_err_dl OCCURS 0.
    INCLUDE STRUCTURE it_mm01.
DATA: errtxt TYPE string,
      END OF it_err_dl.

** Internal table for Material Master View Selection Screens
DATA: BEGIN OF t_bildtab OCCURS 0.
    INCLUDE STRUCTURE mbildtab.
DATA: END OF t_bildtab.

DATA: ldate LIKE sy-datum.
DATA : wa_mm01 LIKE LINE OF it_mm01.
*         wa_mm01_temp LIKE LINE OF it_mm01.
DATA: lw_mara LIKE LINE OF it_mara.
DATA: li_len TYPE i. "Length of field

DATA: wa_file-matnr TYPE matnr,
      wa_file-werks TYPE t001w-werks,
      wa_file-mtart TYPE  mtart,
      wa_file-art   TYPE rmqam-art,    "83 Inspection Type
      wa_file-aktiv TYPE rmqam-aktiv.  "84 QA Control Key

*>>
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS ctumode LIKE ctu_params-dismode DEFAULT 'N' NO-DISPLAY.
PARAMETERS cupdate LIKE ctu_params-updmode DEFAULT 'L'NO-DISPLAY.
*PARAMETERS w_file LIKE rlgrap-filename OBLIGATORY. " Input File
SELECTION-SCREEN END OF BLOCK b1.


REFRESH bdcdata.

IMPORT wa_file-matnr wa_file-werks wa_file-mtart wa_file-art wa_file-aktiv FROM MEMORY ID 'zqual' .

PERFORM bdc_dynpro      USING 'SAPLMGMM' '0060'.
PERFORM bdc_field       USING 'BDC_CURSOR'
                              'RMMG1-MATNR'.
PERFORM bdc_field       USING 'BDC_OKCODE'
                              '=ENTR'.
PERFORM bdc_field       USING 'RMMG1-MATNR'
                              wa_file-matnr .
PERFORM bdc_dynpro      USING 'SAPLMGMM' '0070'.
PERFORM bdc_field       USING 'BDC_CURSOR'
                              'MSICHTAUSW-DYTXT(01)'.
PERFORM bdc_field       USING 'BDC_OKCODE'
                              '=ENTR'.
PERFORM bdc_field       USING 'MSICHTAUSW-KZSEL(01)'
                              'X'.
PERFORM bdc_dynpro      USING 'SAPLMGMM' '4004'.
PERFORM bdc_field       USING 'BDC_OKCODE'
                              '=SP23'.
PERFORM bdc_dynpro      USING 'SAPLMGMM' '0081'.
PERFORM bdc_field       USING 'BDC_CURSOR'
                              'RMMG1-WERKS'.
PERFORM bdc_field       USING 'BDC_OKCODE'
                              '=ENTR'.
PERFORM bdc_field       USING 'RMMG1-WERKS'
                              wa_file-werks.
PERFORM bdc_dynpro      USING 'SAPLMGMM' '4000'.
PERFORM bdc_field       USING 'BDC_OKCODE'
                              '=PB01'.
PERFORM bdc_dynpro      USING 'SAPLQPLS' '0100'.
PERFORM bdc_field       USING 'BDC_CURSOR'
                              'RMQAM-ARGUMENT'.
PERFORM bdc_field       USING 'BDC_OKCODE'
                              '=NEU'.
PERFORM bdc_dynpro      USING 'SAPLQPLS' '0100'.
PERFORM bdc_field       USING 'BDC_CURSOR'
                              'RMQAM-AKTIV(01)'.
PERFORM bdc_field       USING 'BDC_OKCODE'
                              '=WEIT'.
PERFORM bdc_field       USING 'RMQAM-ART(01)'    wa_file-art.
*                              '01'.
PERFORM bdc_field       USING 'RMQAM-AKTIV(01)'  wa_file-aktiv.
*                              'X'.
PERFORM bdc_dynpro      USING 'SAPLMGMM' '4000'.
PERFORM bdc_field       USING 'BDC_OKCODE'
                              '=BU'.

PERFORM call_transaction USING 'MM02'.

REFRESH bdcdata.

*&---------------------------------------------------------------------*
*&      Form  call_transaction
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->TCODE      text
*----------------------------------------------------------------------*
FORM call_transaction  USING tcode.
  DATA: ls_errtxt TYPE string. "Error Line
  DATA: lw_err_dl LIKE LINE OF it_err_dl. "Download error Records
  WAIT UP TO 3 SECONDS .
  CALL TRANSACTION tcode USING bdcdata
                       MODE  ctumode
                       UPDATE cupdate.
ENDFORM.                    " call_transaction


*&---------------------------------------------------------------------*
*&      Form  bdc_dynpro
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PROGRAM    text
*      -->DYNPRO     text
*----------------------------------------------------------------------*
FORM bdc_dynpro  USING  program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.

ENDFORM.                    " bdc_dynpro


*&---------------------------------------------------------------------*
*&      Form  bdc_field
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FNAM       text
*      -->FVAL       text
*----------------------------------------------------------------------*
FORM bdc_field  USING fnam fval.
  IF fval NE ' '.
    CLEAR bdcdata.
    bdcdata-fnam = fnam.
    bdcdata-fval = fval.
    APPEND bdcdata.
  ENDIF.
ENDFORM.                    " bdc_field
