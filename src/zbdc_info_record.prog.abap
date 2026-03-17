REPORT zbdc_info_record
       NO STANDARD PAGE HEADING LINE-SIZE 255.
TABLES: sscrfields.
TYPES:BEGIN OF ty_str,
        lifnr(10),
        matnr(18),
        ekorg(04),
        werks(04),
        norbm(13),
        mwskz(02),
        netpr(11),
        gkwrt(11),
        datbi(10),
        IDNLF(35),
        URZZT(16),           "Number or Casting weight       "added by pankaj 27.10.2021
      END OF ty_str.

TYPES: trux_t_text_data(4096) TYPE c OCCURS 0.
DATA : text TYPE string .
DATA:it_itab    TYPE TABLE OF ty_str,
     wa_itab    TYPE          ty_str,
     it_msg     LIKE TABLE OF bdcmsgcoll,
     wa         TYPE  bdcmsgcoll , "WITH HEADER LINE,
     it_bdcdata TYPE TABLE OF bdcdata,
     wa_bdcdata TYPE bdcdata.
DATA : rawdata(4096) TYPE c OCCURS 0.
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_file TYPE rlgrap-filename.
PARAMETERS     : ctu_mode  LIKE ctu_params-dismode DEFAULT 'N'.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) w_button USER-COMMAND but1.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS : r1 RADIOBUTTON GROUP r,  " Standard
               r2 RADIOBUTTON GROUP r.  " Subcontracting
SELECTION-SCREEN END OF BLOCK b2.

INITIALIZATION.
*Assign Text string To Button
  w_button = 'Download Excel Template'.

AT SELECTION-SCREEN.

  IF sscrfields-ucomm EQ 'BUT1' .
    SUBMIT  zinfo_record_excel VIA SELECTION-SCREEN .
  ENDIF.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name = syst-cprog
*     DYNPRO_NUMBER       = SYST-DYNNR
*     FIELD_NAME   = ' '
    IMPORTING
      file_name    = p_file.
  .

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'x'
      i_tab_raw_data       = rawdata
      i_filename           = p_file
    TABLES
      i_tab_converted_data = it_itab
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.


*include bdcrecx1.

START-OF-SELECTION.

BREAK primus.
*perform open_group.
  LOOP AT  it_itab INTO wa_itab.


    PERFORM bdc_dynpro      USING 'SAPMM06I' '0100'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'RM06I-NORMB'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '/00'.
    PERFORM bdc_field       USING 'EINA-LIFNR'
                                  wa_itab-lifnr .           " '100006'.
    PERFORM bdc_field       USING 'EINA-MATNR'
                                  wa_itab-matnr  .                            "'121'.
    PERFORM bdc_field       USING 'EINE-EKORG'
                                  wa_itab-ekorg   .                    "'1000'.
    PERFORM bdc_field       USING 'EINE-WERKS'
                               wa_itab-werks    .
      IF R1  = 'X'.               "'PL01'.
    PERFORM bdc_field       USING 'RM06I-NORMB'
                                  'X'.
    ELSEIF R2 = 'X' .
      PERFORM bdc_field       USING 'RM06I-LOHNB'
                                  'X'.
      ENDIF.
    PERFORM bdc_dynpro      USING 'SAPMM06I' '0101'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'EINA-MAHN1'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=EINE'.

    perform bdc_field       using 'EINA-IDNLF'
                                     wa_itab-IDNLF.    " EINA-IDNLF.

    """"""""""added by Pankaj 28.10.2021""""""""""""
     perform bdc_field       using 'EINA-URZZT'
                                     wa_itab-URZZT.    " EINA-URZZT.

*perform bdc_field       using 'EINA-URZLA'
*                              'IN'.
*perform bdc_field       using 'EINA-REGIO'
*                              '13'.
*perform bdc_field       using 'EINA-MEINS'
*                              'EA'.
*perform bdc_field       using 'EINA-UMREZ'
*                              '1'.
*perform bdc_field       using 'EINA-UMREN'
*                              '1'.
    PERFORM bdc_dynpro      USING 'SAPMM06I' '0102'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'EINE-NETPR'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=KO'.
*perform bdc_field       using 'EINE-EKGRP'
*                              '101'.
    PERFORM bdc_field       USING 'EINE-NORBM'
                                  wa_itab-norbm.                      "'10'.
    PERFORM bdc_field       USING 'EINE-MWSKZ'
                                  wa_itab-mwskz.                    "'m4'.
*perform bdc_field       using 'EINE-IPRKZ'
*                              'D'.
    PERFORM bdc_field       USING 'EINE-NETPR'
                                  wa_itab-netpr.                        "'           100'.
*perform bdc_field       using 'EINE-WAERS'
*                              'INR'.
*perform bdc_field       using 'EINE-PEINH'
*                              '1'.
*perform bdc_field       using 'EINE-BPRME'
*                              'EA'.
*perform bdc_field       using 'EINE-BPUMZ'
*                              '1'.
*perform bdc_field       using 'EINE-BPUMN'
*                              '1'.
    PERFORM bdc_dynpro      USING 'SAPMV13A' '0201'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KONP-KSCHL(01)'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=PDAT'.
*perform bdc_field       using 'RV13A-DATAB'
*                              '11.06.2018'.
    PERFORM bdc_field       USING 'RV13A-DATBI'
                                    wa_itab-datbi.
*                              '31.12.9999'.
    PERFORM bdc_field       USING 'RV130-SELKZ(01)'
                                  'X'.
    PERFORM bdc_dynpro      USING 'SAPMV13A' '0300'.
    PERFORM bdc_field       USING 'BDC_CURSOR'
                                  'KONP-GKWRT'.
    PERFORM bdc_field       USING 'BDC_OKCODE'
                                  '=SICH'.
*perform bdc_field       using 'RV13A-DATAB'
*                              '11.06  .2018'.
*perform bdc_field       using 'RV13A-DATBI'
*                              '31.12.9999'.
*perform bdc_field       using 'KONP-KBETR'
*                              '         100.00'.
*perform bdc_field       using 'KONP-KONWA'
*                              'INR'.
*perform bdc_field       using 'KONP-KPEIN'
*                              '    1'.
*perform bdc_field       using 'KONP-KMEIN'
*                              'EA'.
    PERFORM bdc_field       USING 'KONP-GKWRT'
                                  wa_itab-gkwrt.                                  "'             200'.
*perform bdc_field       using 'KONP-STFKZ'
*                              'A'.
*perform bdc_field       using 'KONP-KZNEP'
*                              'X'.
*perform bdc_transaction using 'ME11'.

*    BREAK-POINT.

    CALL TRANSACTION 'ME11' USING it_bdcdata
                                MODE ctu_mode UPDATE 'S' MESSAGES INTO it_msg.


    CLEAR  it_bdcdata.

  ENDLOOP.
*perform close_group.


    """"""""""""""""""""""""ADDED BY SARIKA TALEKAR """""""""""""""""""""""""""""""'''''''''''
    DATA : infnr TYPE eina-infnr .
    DATA : IT_MSG1 TYPE CHAR100.
*    SELECT SINGLE infnr FROM eina INTO infnr WHERE matnr = wa_itab-matnr AND lifnr =  wa_itab-lifnr .
  LOOP AT it_msg INTO wa.


CALL FUNCTION 'FORMAT_MESSAGE'
 EXPORTING
   ID              =  WA-msgid
   LANG            = sy-langu
   NO              = WA-msgnR
   V1              = WA-msgv1
   V2              = WA-msgv2
   V3              = WA-msgv3
   V4              = WA-msgv4
 IMPORTING
   MSG             = IT_MSG1
 EXCEPTIONS
   NOT_FOUND       = 1
   OTHERS          = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
  IF  wa-msgtyp = 'S' .
  infnr =  WA-msgv1 .

     READ TABLE IT_MSG INTO WA WITH KEY msgtyp = 'W' .
IF SY-SUBRC = '0'.
          CONCATENATE 'Info record ' infnr 'generate with warning.' INTO text SEPARATED BY SPACE.
*          MESSAGE text TYPE 'I' DISPLAY LIKE 'E'.
write : / text .
ENDIF.
    ENDIF .
     IF  wa-msgtyp = 'E' .
      WRITE : / IT_MSG1 .
      ENDIF.
    ENDLOOP .

    """"""""""""""""""""""""END  BY SARIKA TALEKAR """""""""""""""""""""""""""""""'''''''''''

*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR wa_bdcdata.
  wa_bdcdata-program  = program.
  wa_bdcdata-dynpro   = dynpro.
  wa_bdcdata-dynbegin = 'X'.
  APPEND wa_bdcdata TO it_bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  IF fval <> space.
    CLEAR wa_bdcdata.
    wa_bdcdata-fnam = fnam.
    wa_bdcdata-fval = fval.
    APPEND wa_bdcdata TO it_bdcdata.
  ENDIF.
ENDFORM.                    "bdc_field
