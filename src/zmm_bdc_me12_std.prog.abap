REPORT zmm_bdc_me12_std
       NO STANDARD PAGE HEADING LINE-SIZE 255.

***--------------------------- Structure Declaration ------------------------

TABLES: sscrfields.

TYPES  : BEGIN OF t_done,
           infnr TYPE eina-infnr, "info type
         END OF t_done.

DATA : gt_done TYPE STANDARD TABLE OF t_done,
       gs_done TYPE t_done.

TYPES  : BEGIN OF t_error,
           infnr TYPE eina-infnr, "info type
         END OF t_error.

DATA : gt_error TYPE STANDARD TABLE OF t_error,
       gs_error TYPE t_error.


TYPES : BEGIN OF ty_data,
          ekorg    TYPE eine-ekorg, "purchase organisation
          werks    TYPE eine-werks, "plant
          infnr    TYPE eina-infnr, "info type
          date_frm TYPE rv13a-datab, " from date
          amount   TYPE string,  "konp-kbetr,  "amount
          upp_lim  TYPE string,  "konp-gkwrt,  "Upper Limit
          URZZT    TYPE eina-URZZT,   "Number or Casting weight       "added by pankaj 28.10.2021
        END OF ty_data.

DATA : gt_final TYPE STANDARD TABLE OF ty_data.

DATA  : bdcdata         LIKE bdcdata OCCURS 0 WITH HEADER LINE,
        lv_buffer(4096) TYPE c OCCURS 0,
        tt_bdcmsgcall   TYPE STANDARD TABLE OF bdcmsgcoll.






SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN SKIP.
PARAMETERS :  f_name TYPE rlgrap-filename. " OBLIGATORY.
PARAMETERS :  mode TYPE ctu_params-dismode DEFAULT 'A'.
SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS : r1 RADIOBUTTON GROUP r,  " Standard
               r2 RADIOBUTTON GROUP r.  " Subcontracting
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
SELECTION-SCREEN END OF LINE."


INITIALIZATION.
  w_button = TEXT-003.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR f_name.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = f_name.

AT SELECTION-SCREEN.
  IF sscrfields-ucomm EQ 'BUT1'.
    SUBMIT zmm_bdc_me12_std_excel AND RETURN.
  ENDIF.


START-OF-SELECTION.

  DATA lt_excel LIKE alsmex_tabline OCCURS 0 WITH HEADER LINE.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = lv_buffer
      i_filename           = f_name
    TABLES
      i_tab_converted_data = gt_final
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*BREAK primus.

  LOOP AT gt_final INTO DATA(gs_final).
    REFRESH bdcdata.
    PERFORM bdc_dynpro      USING 'SAPMM06I' '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RM06I-NORMB'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'EINA-LIFNR'
                                  ''.
    PERFORM bdc_field       USING 'EINA-MATNR'
                                  ''.
    PERFORM bdc_field       USING 'EINE-EKORG'
                                   gs_final-ekorg."               '1000'.
    PERFORM bdc_field       USING 'EINE-WERKS'
                                  gs_final-werks. "'PL01'.
    PERFORM bdc_field       USING 'EINA-INFNR'
                                  gs_final-infnr. "'5300000068'.
    IF r1 = 'X'.
    PERFORM bdc_field       USING 'RM06I-NORMB'
                                  'X'.
    ELSEIF r2 = 'X'.
      PERFORM bdc_field       USING 'RM06I-LOHNB'
                                  'X'.
    ENDIF.
    PERFORM bdc_dynpro      USING 'SAPMM06I' '0101'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'EINA-MAHN1'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=KO'.

    "" added by pankaj 28.10.2021
     perform bdc_field      USING 'EINA-URZZT'
                                     gs_final-URZZT.    " EINA-URZZT.
**perform bdc_field       using 'EINA-MAHN1'
**                              '10'.
**perform bdc_field       using 'EINA-MAHN2'
**                              '20'.
**perform bdc_field       using 'EINA-MAHN3'
**                              '30'.
**perform bdc_field       using 'EINA-URZLA'
**                              'IN'.
**perform bdc_field       using 'EINA-REGIO'
**                              '13'.
**perform bdc_field       using 'EINA-MEINS'
**                              'EA'.
**perform bdc_field       using 'EINA-UMREZ'
**                              '1'.
**perform bdc_field       using 'EINA-UMREN'
**                              '1'.
    PERFORM bdc_dynpro      USING 'SAPLV14A' '0102'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'VAKE-DATAB(01)'.
***    PERFORM bdc_field       USING 'RV13A-DATAB'
***                                    gs_final-date_frm."                 '08.06.2018'.
**perform bdc_field       using 'RV13A-DATBI'
**                              '31.12.9999'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=NEWD'.
    PERFORM bdc_dynpro      USING 'SAPMV13A' '0201'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KONP-KBETR(01)'.

    CONCATENATE gs_final-date_frm+6(2) '.' gs_final-date_frm+4(2) '.' gs_final-date_frm+0(4) INTO DATA(lv_date).
    CONDENSE lv_date.
    SHIFT gs_final-upp_lim LEFT DELETING LEADING space.
    SHIFT gs_final-amount LEFT DELETING LEADING space.
   PERFORM bdc_field       USING 'RV13A-DATAB'
                                   lv_date . "gs_final-date_frm.   " '08.06.2018'.

    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=PDAT'.


    PERFORM bdc_dynpro      USING 'SAPMV13A' '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KONP-GKWRT'.
    PERFORM bdc_field       USING 'RV13A-DATAB'
                                   lv_date . "gs_final-date_frm.   " '08.06.2018'.
**perform bdc_field       using 'RV13A-DATBI'
**                              '31.12.9999'.
    PERFORM bdc_field       USING 'KONP-KBETR'
                                    gs_final-amount. "            '              19'.
****perform bdc_field       using 'KONP-KONWA'
****                              'INR'.
****perform bdc_field       using 'KONP-KPEIN'
****                              '    1'.
****perform bdc_field       using 'KONP-KMEIN'
****                              'EA'.
    PERFORM bdc_field       USING 'KONP-GKWRT'
                                   gs_final-upp_lim. "'              70'.

    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=SICH'.
***perform bdc_field       using 'KONP-STFKZ'
***                              'A'.
***perform bdc_field       using 'KONP-KZNEP'
***                              'X'.

    CALL TRANSACTION 'ME12' USING bdcdata
                            MODE mode
                            MESSAGES INTO tt_bdcmsgcall.


    IF sy-msgv1 IS NOT INITIAL AND ( sy-msgty = 'S' OR sy-msgty = 'W' ).
      gs_done-infnr = sy-msgv1.

      APPEND gs_done TO gt_done.
    ELSE .

      gs_error-infnr = gs_final-infnr.
      APPEND gs_error TO gt_error.
    ENDIF.

  ENDLOOP.

  WRITE /  'SUCESSFULLY CHANGE INFO RECORD '.
  LOOP AT gt_done INTO gs_done.
    WRITE / gs_done-infnr .
  ENDLOOP.

  WRITE /  'ERROR WHILE CHANGING INFO RECORD '.
  LOOP AT gt_error INTO gs_error.
    WRITE / gs_error-infnr .
    CLEAR gs_final.
  ENDLOOP.

*  *----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.

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
ENDFORM.
