*&---------------------------------------------------------------------*
*& REPORT  ZMM_GRN_TAGPRINT
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
* PROGRAM NAME           :   ZMM_GRN_TAGPRINT
* OBJECT ID              :
* FUNCTIONAL ANALYST     :  ABHINAY GANDHE
* PROGRAMMER             :  RAUT SUNITA
* START DATE             :  12/04/2011
* INITIAL TRANSPORT NO   :
* DESCRIPTION            :  REPORT TO TAKE GRN TAGPRINT.
*----------------------------------------------------------------------*
* INCLUDES               :
* FUNCTION MODULES       : SSF_FUNCTION_MODULE_NAME,LF_FM_NAME,
*                          F4IF_INT_TABLE_VALUE_REQUEST
* LOGICAL DATABASE       :
* TRANSACTION CODE       : ZMMGRNLABEL
* EXTERNAL REFERENCES    :
*----------------------------------------------------------------------*
*                    MODIFICATION LOG
*----------------------------------------------------------------------*
* DATE      | MODIFIED BY   | CTS NUMBER   | COMMENTS
*----------------------------------------------------------------------*
REPORT  zmm_grn_tagprint.

TABLES : mseg,
         mkpf,
         mara.
TYPES: BEGIN OF st_mkpf,
         mblnr TYPE mkpf-mblnr,
         mjahr TYPE mkpf-mjahr,
         budat TYPE mkpf-budat,
         bldat TYPE mkpf-bldat,
         xblnr TYPE mkpf-xblnr,
       END OF st_mkpf.

TYPES: BEGIN OF st_final,
         zeile TYPE mseg-zeile,
         mblnr TYPE mseg-mblnr,
         mjahr TYPE mseg-mjahr,
         matnr TYPE mseg-matnr,
         lifnr TYPE mseg-lifnr,
         menge TYPE mseg-menge,
         meins TYPE mseg-meins,
         lsmng TYPE mseg-lsmng,
         budat TYPE mkpf-budat,
         bldat TYPE mkpf-bldat,
         xblnr TYPE mkpf-xblnr,
         name  TYPE  lfa1-name1,
         maktx TYPE makt-maktx,
         input TYPE char4,
         groes TYPE mara-groes,
         lgort TYPE mseg-lgort,
       END OF st_final,

       BEGIN OF ty_series,
         mblnr TYPE mkpf-mblnr,
       END OF ty_series,

       BEGIN OF ty_series1,
         mjahr TYPE mkpf-mjahr,
       END OF ty_series1.

DATA : wa_mkpf TYPE st_mkpf,
       it_mkpf TYPE TABLE OF st_mkpf.

DATA : wa_final TYPE st_final,
       it_final TYPE TABLE OF st_final.

DATA : it_lfa1 LIKE TABLE OF lfa1 WITH HEADER LINE.
DATA : it_makt LIKE TABLE OF makt  WITH HEADER LINE.
DATA : it_mara LIKE TABLE OF mara  WITH HEADER LINE.

DATA:lf_fm_name TYPE rs38l_fnam.

DATA: t_series  TYPE STANDARD TABLE OF ty_series,
      t_series1 TYPE STANDARD TABLE OF ty_series1.

DATA pp_mblnr TYPE mblnr.

***SELECTION SCREEN
SELECTION-SCREEN: BEGIN OF BLOCK a WITH FRAME.
PARAMETERS:    p_mblnr LIKE mkpf-mblnr OBLIGATORY.
PARAMETERS:       p_mjahr  LIKE mkpf-mjahr.
SELECTION-SCREEN: END OF BLOCK a.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_mblnr.
  SELECT  mblnr
  FROM mkpf
  INTO  TABLE t_series.

  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = 'MBLNR'
      dynpprog        = sy-repid
      dynpnr          = sy-dynnr
      dynprofield     = 'P_MBLNR'
      value_org       = 'S'
    TABLES
      value_tab       = t_series[]
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    pp_mblnr = p_mblnr.
  ENDIF.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM process_data.
  PERFORM display_data.
***********************************************************************
FORM get_data .
****SELECTING DATA FROM MKPF.
  SELECT mblnr budat xblnr bldat
  INTO CORRESPONDING FIELDS OF TABLE it_mkpf
  FROM mkpf
  WHERE mblnr = p_mblnr
    AND mjahr = p_mjahr.

****SELECTING DATA FROM MSEG.
  IF NOT it_mkpf[] IS INITIAL.
    SELECT mblnr zeile matnr menge meins lifnr lsmng  lgort
    INTO CORRESPONDING FIELDS OF TABLE it_final
    FROM mseg
    WHERE mblnr = p_mblnr AND
          mjahr = p_mjahr AND
         ( bwart = text-001 OR  bwart = text-002 ).
  ENDIF.

  IF NOT it_final[] IS INITIAL.
****SELECTING VENDOR FROM LFA1.
    SELECT name1 lifnr
    INTO CORRESPONDING FIELDS OF TABLE it_lfa1
    FROM lfa1
    FOR ALL ENTRIES IN
    it_final WHERE lifnr = it_final-lifnr.

****SELECTING MATERIAL DESCRIPTION FROM MAKT.
    SELECT matnr maktx
    INTO CORRESPONDING FIELDS OF TABLE it_makt
    FROM makt
    FOR ALL ENTRIES IN  it_final
    WHERE matnr = it_final-matnr.

****SELECTING MATERIAL FROM MARA.
    SELECT matnr groes
    INTO CORRESPONDING FIELDS OF TABLE it_mara
    FROM mara  FOR ALL ENTRIES IN it_final
    WHERE matnr = it_final-matnr.
  ENDIF.

ENDFORM.                    " GET_DATA
***********************************************************************
FORM process_data .

  LOOP AT it_final INTO wa_final.

    READ TABLE it_mkpf INTO wa_mkpf WITH KEY mblnr = wa_final-mblnr.
    IF sy-subrc = 0.
      wa_final-budat = wa_mkpf-budat.
      wa_final-bldat = wa_mkpf-bldat.
      wa_final-xblnr = wa_mkpf-xblnr.
    ENDIF.

    READ TABLE it_makt  WITH KEY matnr = wa_final-matnr.
    IF sy-subrc = 0.
      wa_final-maktx = it_makt-maktx.
    ENDIF.

    READ TABLE it_lfa1 WITH KEY lifnr = wa_final-lifnr.
    IF sy-subrc = 0.
      wa_final-name  = it_lfa1-name1.
    ENDIF.

    READ TABLE it_mara  WITH KEY matnr = wa_final-matnr.
    IF sy-subrc = 0.
      wa_final-groes = it_mara-groes.
    ENDIF.

    wa_final-input = '1'.
    MODIFY it_final FROM wa_final TRANSPORTING budat bldat xblnr name maktx groes input.

  ENDLOOP.

ENDFORM.                    " PROCESS_DATA
***********************************************************************
FORM display_data .
  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = 'ZMM_MATERIAL_INWARD_TAG'
    IMPORTING
      fm_name            = lf_fm_name
    EXCEPTIONS
      no_form            = 1
      no_function_module = 2
      OTHERS             = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF.

  CALL FUNCTION lf_fm_name
    EXPORTING
      p_mblnr          = p_mblnr
      p_mjahr          = p_mjahr
    TABLES
      it_final         = it_final[]
    EXCEPTIONS
      formatting_error = 1
      internal_error   = 2
      send_error       = 3
      user_canceled    = 4
      OTHERS           = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.                    " DISPLAY_DATA
