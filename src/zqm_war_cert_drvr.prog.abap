*&---------------------------------------------------------------------*
*& Report ZQM_WAR_CERT_DRVR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zqm_war_cert_drvr.

TABLES : ekkn, vbrp.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          audat TYPE vbak-audat,
          kunnr TYPE vbak-kunnr,
        END OF ty_vbak.

DATA : gt_vbak TYPE TABLE OF ty_vbak,
       wa_vbak TYPE ty_vbak.

TYPES : BEGIN OF ty_vbkd,
          vbeln TYPE vbkd-vbeln,
          bstkd TYPE vbkd-bstkd,
          bstdk TYPE vbkd-bstdk,
        END OF ty_vbkd.

DATA : gt_vbkd TYPE TABLE OF ty_vbkd,
       wa_vbkd TYPE ty_vbkd.

TYPES : BEGIN OF ty_ekko,
          ebeln TYPE ekko-ebeln,
          bedat TYPE ekko-bedat,
        END OF ty_ekko.

DATA : gt_ekko TYPE TABLE OF ty_ekko,
       wa_ekko TYPE ty_ekko.

TYPES : BEGIN OF ty_hdr,
          exnum TYPE j_1iexchdr-exnum,
          docyr TYPE j_1iexchdr-docyr,
          exdat TYPE j_1iexchdr-exdat,
          rdoc  TYPE j_1iexchdr-rdoc,
        END OF ty_hdr.

DATA : gt_hdr TYPE TABLE OF ty_hdr,
       wa_hdr TYPE ty_hdr.

TYPES : BEGIN OF ty_hdr1,
          exnum TYPE j_1iexchdr-exnum,
        END OF ty_hdr1.

DATA : gt_hdr1 TYPE TABLE OF ty_hdr1.

TYPES : BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
          name2 TYPE kna1-name2,
        END OF ty_kna1.

TYPES : BEGIN OF ty_final,
          name1 TYPE kna1-name1,
          name2 TYPE kna1-name2,
          ebeln TYPE ekko-ebeln,
          bedat TYPE ekko-bedat,
          vbeln TYPE vbak-vbeln,
          audat TYPE vbak-audat,
          exnum TYPE j_1iexchdr-exnum,
          exdat TYPE j_1iexchdr-exdat,
          ztext TYPE ztext,
        END OF ty_final.

DATA : gt_final TYPE TABLE OF zqm_warranty,
       wa_final TYPE zqm_warranty.

DATA : gt_vbrk TYPE STANDARD TABLE OF vbrk,
       wa_vbrk TYPE vbrk.

DATA : gt_kna1 TYPE TABLE OF ty_kna1,
       wa_kna1 TYPE ty_kna1.

DATA : gt_vbrp TYPE STANDARD TABLE OF vbrp,
       wa_vbrp TYPE vbrp,

       gt_ekkn TYPE STANDARD TABLE OF ekkn,
       wa_ekkn TYPE ekkn.

DATA : lv_ebeln TYPE ekko-ebeln.

DATA: it_return LIKE ddshretval OCCURS 0 WITH HEADER LINE.

DATA: it_dynpfld_mapping LIKE dselc OCCURS 0 WITH HEADER LINE.

TYPES : BEGIN OF ty_f4hdr,
          exnum TYPE j_1iexchdr-exnum,
          exdat TYPE j_1iexchdr-exdat,
          rdoc  TYPE j_1iexchdr-rdoc,
          kunag TYPE j_1iexchdr-kunag,
          kunwe TYPE j_1iexchdr-kunwe,
        END OF ty_f4hdr.

DATA : it_f4hdr TYPE TABLE OF ty_f4hdr,
       wa_f4hdr TYPE ty_f4hdr.


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*PARAMETERS : i_vbeln TYPE vbrp-vbeln OBLIGATORY.
*PARAMETERS : i_docyr TYPE j_1iexchdr-docyr OBLIGATORY.
  PARAMETERS : p_vbeln TYPE vbrk-vbeln , ""OBLIGATORY.obligatory commented by jyoti on 12.11.2024
               p_ebeln TYPE ekkn-ebeln.  "ADDED BY JYOTI ON 12.11.2024
SELECTION-SCREEN END OF BLOCK b1.
**
**AT SELECTION-SCREEN ON VALUE-REQUEST FOR i_exnum .
**
**  REFRESH : it_f4hdr , it_f4hdr[] .
**
**  SELECT exnum exdat rdoc kunag kunwe FROM j_1iexchdr INTO TABLE it_f4hdr
**                                        WHERE srgrp IN ( 'DO' , 'EX' ) .
**
**  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
**    EXPORTING
**      retfield    = 'EXNUM'
**      dynpprog    = sy-repid
**      dynpnr      = sy-dynnr
**      dynprofield = 'I_EXNUM'
**      value_org   = 'S'
**    TABLES
**      value_tab   = it_f4hdr.


START-OF-SELECTION.
  PERFORM get_data.
  PERFORM sort_data.

  READ TABLE gt_vbrp INTO wa_vbrp INDEX 1.
  IF sy-subrc = 0.
    IF wa_vbrp-vbeln IS NOT INITIAL.
      PERFORM print.
    ELSE.
      MESSAGE 'Invoice not done' TYPE 'E'.
    ENDIF.
  ENDIF.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

*****      SELECT exnum docyr exdat rdoc FROM j_1iexchdr INTO TABLE gt_hdr
*****      WHERE exnum = i_exnum and docyr = i_docyr.

**  SELECT SINGLE exnum docyr exdat rdoc FROM j_1iexchdr INTO wa_hdr
**                     WHERE exnum = i_exnum . "and docyr = i_docyr.
******
**  IF wa_hdr IS NOT INITIAL.
  IF p_vbeln IS NOT INITIAL AND p_ebeln IS NOT INITIAL.
    SELECT ebeln vbeln vbelp FROM ekkn INTO CORRESPONDING FIELDS OF TABLE gt_ekkn
        WHERE ebeln = p_ebeln.
    SELECT vbeln FROM vbrp
       INTO @DATA(wa_vbeln)
       FOR ALL ENTRIES IN @gt_ekkn
        WHERE aubel = @gt_ekkn-vbeln
        AND  aupos = @gt_ekkn-vbelp.
    ENDSELECT.
    IF p_vbeln NE wa_vbeln.
      MESSAGE 'Please check Invoice no is related to Po no' TYPE 'E'.
    ENDIF.

  ENDIF.


  IF p_vbeln IS INITIAL.
    SELECT ebeln vbeln vbelp FROM ekkn INTO CORRESPONDING FIELDS OF TABLE gt_ekkn
      WHERE ebeln = p_ebeln.

    SELECT vbeln FROM vbrp
      INTO p_vbeln
      FOR ALL ENTRIES IN gt_ekkn
       WHERE aubel = gt_ekkn-vbeln
       AND  aupos = gt_ekkn-vbelp.
    ENDSELECT.
  ENDIF.

  SELECT vbeln aubel FROM vbrp INTO CORRESPONDING FIELDS OF TABLE gt_vbrp
*         WHERE vbeln = i_vbeln.
    WHERE vbeln = p_vbeln .

  SELECT vbeln fkdat xblnr FROM vbrk INTO CORRESPONDING FIELDS OF TABLE gt_vbrk
*          WHERE vbeln = i_vbeln.
    WHERE vbeln = p_vbeln .

**  ENDIF.

  IF gt_vbrp[] IS NOT INITIAL.

    SELECT vbeln audat kunnr FROM vbak INTO TABLE gt_vbak
      FOR ALL ENTRIES IN gt_vbrp
      WHERE vbeln = gt_vbrp-aubel.

  ENDIF.


  IF gt_vbak[] IS NOT INITIAL.

    SELECT kunnr name1 name2 FROM kna1 INTO TABLE gt_kna1
      FOR ALL ENTRIES IN gt_vbak
      WHERE kunnr = gt_vbak-kunnr.

    SELECT * FROM vbkd INTO CORRESPONDING FIELDS OF TABLE gt_vbkd
      FOR ALL ENTRIES IN gt_vbak
      WHERE vbeln = gt_vbak-vbeln.

  ENDIF.



ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_data .
  BREAK fujiabap.

  LOOP AT gt_vbrp INTO wa_vbrp.

    READ TABLE gt_vbrk INTO wa_vbrk WITH KEY vbeln = wa_vbrp-vbeln.

    IF sy-subrc = 0.

      wa_final-fkdat = wa_vbrk-fkdat.
      wa_final-inv_no = wa_vbrk-vbeln.

    ENDIF.

    READ TABLE gt_vbak INTO wa_vbak WITH KEY vbeln = wa_vbrp-aubel.

    IF sy-subrc = 0.

      READ TABLE gt_vbkd INTO wa_vbkd WITH KEY vbeln = wa_vbak-vbeln.

      IF sy-subrc = 0.

        wa_final-bstkd = wa_vbkd-bstkd.
        wa_final-bstdk = wa_vbkd-bstdk.

      ENDIF.

      wa_final-vbeln = wa_vbak-vbeln.
      wa_final-audat = wa_vbak-audat.

      DATA : id       TYPE thead-tdid VALUE '0001',
             spras    TYPE thead-tdspras VALUE 'E',
             lv_name  TYPE thead-tdname,
             lines    TYPE TABLE OF tline,
             wa_lines TYPE tline.
      DATA(lo_text_reader) = NEW zcl_read_text( ).
      DATA : lv_lines1 TYPE STRING.


      lv_name = wa_final-vbeln.
      CONCATENATE lv_name '000010' INTO lv_name.

      CLEAR  lv_lines1.
      lo_text_reader->read_text_string( EXPORTING id = id name = lv_name object = 'VBBP' IMPORTING lv_lines = lv_lines1 ).
      lv_lines1 = wa_final-ztext.

**      CALL FUNCTION 'READ_TEXT'
**        EXPORTING
***         CLIENT                  = SY-MANDT
**          id                      = id
**          language                = 'E'
**          name                    = lv_name
**          object                  = 'VBBP'
***         ARCHIVE_HANDLE          = 0
***         LOCAL_CAT               = ' '
***   IMPORTING
***         HEADER                  =
***         OLD_LINE_COUNTER        =
**        TABLES
**          lines                   = lines
**        EXCEPTIONS
**          id                      = 1
**          language                = 2
**          name                    = 3
**          not_found               = 4
**          object                  = 5
**          reference_check         = 6
**          wrong_access_to_archive = 7
**          OTHERS                  = 8.
**      IF sy-subrc <> 0.
*** Implement suitable error handling here
**      ENDIF.
**
**      READ TABLE lines INTO wa_lines INDEX 1.
**
**      IF sy-subrc = 0.
**
**        wa_final-ztext = wa_lines-tdline.
**
**      ENDIF.

      READ TABLE gt_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbak-kunnr.

      IF sy-subrc = 0.

        wa_final-name1 = wa_kna1-name1.
        wa_final-name2 = wa_kna1-name2.

      ENDIF.

    ENDIF.
    APPEND wa_final TO gt_final.
  ENDLOOP.
sort gt_final by vbeln.
  DELETE ADJACENT DUPLICATES FROM gt_final COMPARING vbeln .
  BREAK kdeshmukh.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PRINT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM print .

*DATA : fm_name TYPE rs38l_fnam.
  DATA : lv_funcname    TYPE funcname,
         lv_doc_params  TYPE sfpdocparams,
         lwa_param      TYPE sfpoutputparams,
         ls_form_output TYPE fpformoutput.

lwa_param-DEVICE = 'PRINTER'.
lwa_param-DEST = 'LP01'.
IF SY-UCOMM = 'PRNT'.
lwa_param-NODIALOG = 'X'.
lwa_param-PREVIEW = ''.
lwa_param-REQIMM = 'X'.
ELSE.
lwa_param-NODIALOG = ''.
lwa_param-PREVIEW = 'X'.
ENDIF.



  CALL FUNCTION 'FP_JOB_OPEN'
    CHANGING
      ie_outputparams = lwa_param
    EXCEPTIONS
      cancel          = 1
      usage_error     = 2
      system_error    = 3
      internal_error  = 4
      OTHERS          = 5.
  IF sy-subrc <> 0.
    MESSAGE 'Error initializing Adobe form' TYPE 'E'.
  ENDIF.

  CALL FUNCTION 'FP_FUNCTION_MODULE_NAME'
    EXPORTING
      i_name     = 'ZQM_WAR_CERT'
    IMPORTING
      e_funcname = lv_funcname
*     E_INTERFACE_TYPE           =
*     EV_FUNCNAME_INBOUND        =
    .


  CALL FUNCTION lv_funcname  "'/1BCDWB/SM00000044'
    EXPORTING
      /1bcdwb/docparams  = lv_doc_params
      i_xblnr            = wa_vbrk-xblnr
      i_fkdat            = wa_vbrk-fkdat
      gt_final           = gt_final
    IMPORTING
      /1bcdwb/formoutput = ls_form_output
    EXCEPTIONS
      usage_error        = 1
      system_error       = 2
      internal_error     = 3
      OTHERS             = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  CALL FUNCTION 'FP_JOB_CLOSE'
* IMPORTING
*   E_RESULT             =
    EXCEPTIONS
      usage_error    = 1
      system_error   = 2
      internal_error = 3
      OTHERS         = 4.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.




*  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
*    EXPORTING
*      formname           = 'ZQM_WAR_CERT'
*    IMPORTING
*      fm_name            = fm_name
*    EXCEPTIONS
*      no_form            = 1
*      no_function_module = 2
*      OTHERS             = 3.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.
*
*  CALL FUNCTION fm_name
*    EXPORTING
**     ARCHIVE_INDEX              =
**     ARCHIVE_INDEX_TAB          =
**     ARCHIVE_PARAMETERS         =
**     CONTROL_PARAMETERS         =
**     MAIL_APPL_OBJ              =
**     MAIL_RECIPIENT             =
**     MAIL_SENDER                =
**     OUTPUT_OPTIONS             =
**     USER_SETTINGS              = 'X'
*      i_xblnr                    = wa_vbrk-xblnr
*      i_fkdat                    = wa_vbrk-fkdat
**   IMPORTING
**     DOCUMENT_OUTPUT_INFO       =
**     JOB_OUTPUT_INFO            =
**     JOB_OUTPUT_OPTIONS         =
*    TABLES
*      gt_final                   = gt_final[]
*   EXCEPTIONS
*     FORMATTING_ERROR           = 1
*     INTERNAL_ERROR             = 2
*     SEND_ERROR                 = 3
*     USER_CANCELED              = 4
*     OTHERS                     = 5
*            .
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.


ENDFORM.
