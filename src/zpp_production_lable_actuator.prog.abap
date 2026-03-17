*&---------------------------------------------------------------------*
*& REPORT  ZPP_PRODUCTION_LABLE_ACTUATOR
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
* PROGRAM NAME           :   ZPP_PRODUCTION_LABLE_ACTUATOR
* OBJECT ID              :
* FUNCTIONAL ANALYST     :  SWAPNIL CHAUDHARI
* PROGRAMMER             :  RAUT SUNITA
* START DATE             :  12/04/2011
* INITIAL TRANSPORT NO   :
* DESCRIPTION            :  REPORT TO PRINT PRODUCTION LABELS.
*----------------------------------------------------------------------*
* INCLUDES               :
* FUNCTION MODULES       : SSF_FUNCTION_MODULE_NAME,LF_FM_NAME,
*                          BAPI_OBJCL_GETDETAIL,CS_BOM_EXPL_MAT_V2.
* LOGICAL DATABASE       :
* TRANSACTION CODE       : ZPPLABEL
* EXTERNAL REFERENCES    :
*----------------------------------------------------------------------*
*                    MODIFICATION LOG
*----------------------------------------------------------------------*
* DATE      | MODIFIED BY   | CTS NUMBER   | COMMENTS
*----------------------------------------------------------------------*
REPORT  zpp_production_lable_actuator.

TABLES : afpo,
         mara,
         ser05,
         objk.

TYPES: BEGIN OF t_afpo,
         aufnr TYPE afpo-aufnr,
         matnr TYPE afpo-matnr,
         pwerk TYPE afpo-pwerk,
       END OF t_afpo.

TYPES: BEGIN OF t_mara,
         matnr TYPE afpo-matnr,
         zsize TYPE mara-zsize,
         brand TYPE mara-brand,
       END OF t_mara.

TYPES: BEGIN OF t_ser05,
         obknr   TYPE ser05-obknr,
         ppaufnr TYPE ser05-ppaufnr,
       END OF t_ser05.

TYPES: BEGIN OF t_objk,
         obknr TYPE objk-obknr,
         sernr TYPE objk-sernr,
       END OF t_objk.

TYPES: BEGIN OF t_mara1,
         matnr   TYPE mara-matnr,
         v_extwg TYPE mara-extwg,
       END OF t_mara1.

TYPES: BEGIN OF t_makt,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF t_makt.

TYPES: BEGIN OF t_makt1,
         matnr TYPE makt-matnr,
         maktx TYPE makt-maktx,
       END OF t_makt1.

DATA:it_afpo TYPE STANDARD TABLE OF t_afpo,
     wa_afpo TYPE t_afpo.
DATA: gs_afko TYPE afko.

DATA:it_mara TYPE STANDARD TABLE OF t_mara,
     wa_mara TYPE t_mara.

DATA:it_ser05 TYPE STANDARD TABLE OF t_ser05,
     wa_ser05 TYPE t_ser05.

DATA:it_objk TYPE STANDARD TABLE OF t_objk,
     wa_objk TYPE t_objk.

DATA:it_mara1 TYPE STANDARD TABLE OF t_mara1,
     wa_mara1 TYPE t_mara1.

DATA:it_makt TYPE STANDARD TABLE OF t_makt,
     wa_makt TYPE t_makt.

DATA:it_makt1 TYPE STANDARD TABLE OF t_makt1,
     wa_makt1 TYPE t_makt1.

DATA:it_final TYPE STANDARD TABLE OF zpp_label,
     wa_final TYPE zpp_label.

DATA: it_stb TYPE STANDARD TABLE OF stpox,
      wa_stb TYPE stpox.

DATA:lf_fm_name TYPE rs38l_fnam,
     v_aufnr    TYPE afpo-aufnr,
     v_rating   TYPE char05,
     v_body     TYPE char05,
     v_ball     TYPE char05,
     v_seat     TYPE char05,
     v_stem     TYPE char05,
     v_disc     TYPE char05,
     v_asupply  TYPE char20,
     v_afail    TYPE char20,
     v_actsize  TYPE char40,
     v_vsize    TYPE char40.

DATA: allocvaluesnum     TYPE STANDARD TABLE OF bapi1003_alloc_values_num,
      allocvalueschar    TYPE STANDARD TABLE OF bapi1003_alloc_values_char,
      allocvaluescurr    TYPE STANDARD TABLE OF bapi1003_alloc_values_curr,
      return             TYPE STANDARD TABLE OF bapiret2,
      objectkey          TYPE bapi1003_key-object,
      wa_allocvalueschar TYPE bapi1003_alloc_values_char,
      classnum           LIKE bapi1003_key-classnum.

DATA : formname TYPE tdsfname.

DATA: r_act, r_ball VALUE 'X', r_butt, r_auto.


*>>
SELECTION-SCREEN: BEGIN OF BLOCK a WITH FRAME TITLE TEXT-001.
PARAMETERS:    p_aufnr LIKE afpo-aufnr OBLIGATORY.
PARAMETERS:    p_text  TYPE char15.
PARAMETERS:    p_text1  TYPE char15 NO-DISPLAY.
SELECTION-SCREEN: END OF BLOCK a.

SELECTION-SCREEN SKIP.

*SELECTION-SCREEN BEGIN OF BLOCK b WITH FRAME TITLE TEXT-002.
*PARAMETERS :r_act  RADIOBUTTON GROUP sf DEFAULT 'X' USER-COMMAND lable,
*            r_ball RADIOBUTTON GROUP sf,
*            r_butt RADIOBUTTON GROUP sf,
*            r_auto RADIOBUTTON GROUP sf.
*SELECTION-SCREEN END OF BLOCK b.

*>>
AT SELECTION-SCREEN.
  SELECT aufnr FROM afpo
  UP TO 1 ROWS
  INTO v_aufnr
  WHERE aufnr = p_aufnr.
  ENDSELECT.
  IF sy-subrc <> 0.
    MESSAGE e007(zdel).
  ENDIF.
  CLEAR v_aufnr.

*>>
START-OF-SELECTION.
  PERFORM get_data.
  PERFORM process_data.
  PERFORM display_data.


*>>
FORM get_data .
****SELECTING MATERIAL NO AND PLANT FROM AFPO.
  SELECT SINGLE * FROM afko INTO gs_afko
    WHERE aufnr = p_aufnr.

  SELECT aufnr matnr pwerk
    FROM afpo
    INTO TABLE it_afpo
    WHERE aufnr = p_aufnr.
  IF sy-subrc = 0.
    SORT it_afpo BY aufnr.
  ENDIF.

****SELECTING SIZE FROM MARA
  IF NOT it_afpo IS INITIAL.
    SELECT matnr zsize brand
      FROM mara
      INTO TABLE it_mara
      FOR ALL ENTRIES IN it_afpo
      WHERE matnr = it_afpo-matnr.
    IF sy-subrc = 0.
      SORT it_mara BY matnr.
    ENDIF.

****SELECTING OBKNR FROM SER05
**    SELECT
**    obknr
**    ppaufnr
**    FROM ser05
**    INTO TABLE it_ser05
**    FOR ALL ENTRIES IN it_afpo
**    WHERE ppaufnr = it_afpo-aufnr.
**    IF sy-subrc = 0.
**      SORT it_ser05 BY obknr ppaufnr.
**    ENDIF.

****SELECTING SERIAL NO FROM OBJK
**    IF NOT it_ser05 IS INITIAL.
**      SELECT
**      obknr
**      sernr
**      FROM objk
**      INTO TABLE it_objk
**      FOR ALL ENTRIES IN it_ser05
**      WHERE obknr = it_ser05-obknr.
**      IF sy-subrc = 0.
**        SORT it_objk BY obknr sernr.
**      ENDIF.
**    ENDIF.
  ENDIF.

ENDFORM.                    " GET_DATA
***********************************************************************
FORM process_data .
  DATA: lv_objecttable TYPE  bapi1003_key-objecttable,
        lv_classtype   LIKE  bapi1003_key-classtype.

  CLEAR wa_afpo.
  READ TABLE it_afpo INTO wa_afpo WITH KEY aufnr = p_aufnr BINARY SEARCH.
  READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_afpo-matnr BINARY SEARCH.

  CASE wa_mara-brand.
    WHEN 'BFV'.                    "TEXT-027.
      classnum = 'ZBFV'.           "TEXT-005.
    WHEN 'BLV'.                    "TEXT-028.
      classnum = 'ZBLV'.           "TEXT-007.
    WHEN 'ACT'.                    "TEXT-023.
      classnum = 'ZACT'.           "TEXT-029.
    WHEN 'VAS'.                    "TEXT-030.
      classnum = 'ZAUT'.           "TEXT-026.
  ENDCASE.

  objectkey = wa_afpo-matnr.
  lv_objecttable = 'MARA'.          "TEXT-008.
  lv_classtype = '001'.             "TEXT-009.

*****  CALLING FM TO GET THE CHARACTERISTIC
  CALL FUNCTION 'BAPI_OBJCL_GETDETAIL'
    EXPORTING
      objectkey       = objectkey
      objecttable     = lv_objecttable
      classnum        = classnum
      classtype       = lv_classtype
    TABLES
      allocvaluesnum  = allocvaluesnum
      allocvalueschar = allocvalueschar
      allocvaluescurr = allocvaluescurr
      return          = return.

  CLEAR wa_allocvalueschar.
  LOOP AT allocvalueschar INTO wa_allocvalueschar.
    CASE wa_allocvalueschar-charact.
      WHEN 'BALL'.               "TEXT-010.
        v_ball = wa_allocvalueschar-value_char.
      WHEN 'BODY'.               "TEXT-011.
        v_body = wa_allocvalueschar-value_char.
      WHEN 'RATING'.             "TEXT-012.
        v_rating = wa_allocvalueschar-value_char.
      WHEN 'SEAT'.               "TEXT-013.
        v_seat = wa_allocvalueschar-value_char.
      WHEN 'STEM'.               "TEXT-014.
        v_stem = wa_allocvalueschar-value_char.
      WHEN 'DISC'.               "TEXT-015.
        v_disc = wa_allocvalueschar-value_char.
      WHEN 'AIR_FAIL_POSITION'.  "TEXT-020.
        v_afail = wa_allocvalueschar-value_char.
      WHEN 'MIN_AIR_PRESSURE'.   "TEXT-019.
        v_asupply = wa_allocvalueschar-value_char.
    ENDCASE.
  ENDLOOP.
***********************************************************************
  IF wa_afpo-matnr IS NOT INITIAL.
    SELECT matnr maktx
    FROM makt
    INTO TABLE it_makt1
      WHERE matnr = wa_afpo-matnr.
    IF sy-subrc = 0.
      SORT it_makt1 BY matnr.
    ENDIF.
*****CALLING FM TO EXPLODE MATERIAL.
    CALL FUNCTION 'CS_BOM_EXPL_MAT_V2'
      EXPORTING
        capid                 = 'PP01'
        datuv                 = sy-datum
        mehrs                 = 'X'
        mtnrv                 = wa_afpo-matnr
        stpst                 = 0
        svwvo                 = 'X'
        werks                 = wa_afpo-pwerk
        vrsvo                 = 'X'
      TABLES
        stb                   = it_stb
      EXCEPTIONS
        alt_not_found         = 1
        call_invalid          = 2
        material_not_found    = 3
        missing_authorization = 4
        no_bom_found          = 5
        no_plant_data         = 6
        no_suitable_bom_found = 7
        conversion_error      = 8
        OTHERS                = 9.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
           WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDIF.

  IF NOT it_stb IS INITIAL.
    SELECT matnr extwg
      FROM mara
      INTO  TABLE it_mara1
      FOR ALL ENTRIES IN it_stb
      WHERE matnr = it_stb-idnrk.
    IF sy-subrc = 0.
      SORT it_mara1 BY matnr.
    ENDIF.

    SELECT matnr maktx
      FROM makt
      INTO TABLE it_makt
         FOR ALL ENTRIES IN it_stb
         WHERE matnr = it_stb-idnrk
        AND spras  = sy-langu.
    IF sy-subrc = 0.
      SORT it_makt BY matnr.
    ENDIF.
  ENDIF.

  LOOP AT it_mara1 INTO wa_mara1.
    READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara1-matnr
    BINARY SEARCH.

    IF wa_mara1-v_extwg = 'ACT'.            "TEXT-023.
      v_actsize = wa_makt-maktx.
    ENDIF.

    IF wa_mara1-v_extwg = 'VAL'.            "TEXT-024.
      v_vsize = wa_makt-maktx.
    ENDIF.

  ENDLOOP.
***********************************************************************
*  CLEAR wa_objk.
*  LOOP AT it_objk INTO wa_objk.

**    READ TABLE it_ser05 INTO wa_ser05 WITH KEY obknr = wa_objk-obknr BINARY SEARCH.
  READ TABLE it_afpo INTO wa_afpo WITH KEY aufnr = p_aufnr.   "wa_ser05-ppaufnr BINARY SEARCH.
  READ TABLE it_mara INTO wa_mara WITH KEY matnr = wa_afpo-matnr BINARY SEARCH.
  READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_afpo-matnr BINARY SEARCH.
  READ TABLE it_makt1 INTO wa_makt1 WITH KEY matnr = wa_afpo-matnr BINARY SEARCH.
*****TAKING DATA INTO IT_FINAL.
  wa_final-matnr = wa_mara-matnr.
  wa_final-zsize = wa_mara-zsize.
*    wa_final-sernr = wa_objk-sernr.
  wa_final-maktx = wa_makt1-maktx.
  wa_final-pwerk = wa_afpo-pwerk.
  wa_final-rating = v_rating.
  wa_final-body = v_body.
  wa_final-ball = v_ball.
  wa_final-seat = v_seat.
  wa_final-stem = v_stem.
  wa_final-disc = v_disc.
  wa_final-asupply = v_asupply.
  wa_final-afail = v_afail.
  wa_final-actsize = v_actsize.
  wa_final-vsize = v_vsize.
  wa_final-brand = wa_mara-brand.
  wa_final-gstrs = gs_afko-gstrs.
  wa_final-remk1 = p_text.

  DATA: lv_srno  TYPE i, lv_totno TYPE i.
  "GSTRS
  lv_srno = 1.
  lv_totno = gs_afko-gamng.

  DO lv_totno TIMES.
    WRITE lv_srno TO wa_final-sernr LEFT-JUSTIFIED.
    CONDENSE  wa_final-sernr.
    CONCATENATE p_aufnr '-' wa_final-sernr INTO wa_final-sernr.  " = lv_srno.
    APPEND wa_final TO it_final.
    lv_srno = lv_srno + 1.
  ENDDO.
**  wa_final-sernr = wa_objk-sernr.
**  APPEND wa_final TO it_final.
*  ENDLOOP.
ENDFORM.                    " PROCESS_DATA
***********************************************************************
FORM display_data .

  IF r_act = 'X'.              "TEXT-003.
    formname = 'ZPP_BOX_STICKER_ACTUATOR'.     "TEXT-016.
  ELSEIF r_ball = 'X'.         "TEXT-003.
    formname = 'ZPP_NAME_PLATE_VALVE'.         "TEXT-017.
  ELSEIF r_butt = 'X'.         "TEXT-003.
    formname = 'ZPP_NAME_PLATE_VALVE'.         "TEXT-017.
  ELSEIF r_auto = 'X'.         "TEXT-003.
    formname = 'ZPP_NAME_PLATE_AUTOMATION'.    "TEXT-018.
  ENDIF.

  CALL FUNCTION 'SSF_FUNCTION_MODULE_NAME'
    EXPORTING
      formname           = formname
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
      p_aufnr          = p_aufnr
      p_text           = p_text
      p_text1          = p_text1
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

  CLEAR:it_afpo,it_mara,it_ser05,it_objk,it_mara1,it_makt, it_makt1,it_final,it_stb,allocvaluesnum ,allocvalueschar,
        allocvaluescurr,return.
  CLEAR:wa_afpo,wa_mara,wa_ser05,wa_objk,wa_mara1,wa_makt,wa_makt1,wa_final,wa_stb,wa_allocvalueschar.
  CLEAR:lf_fm_name,v_aufnr,v_rating,v_body,v_ball,v_seat,v_stem,v_disc,v_asupply,v_afail,v_actsize,v_vsize,
        objectkey,classnum,formname.
ENDFORM.                    " DISPLAY_DATA
