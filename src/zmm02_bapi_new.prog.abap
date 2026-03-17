*&---------------------------------------------------------------------*
*& Report ZMM02_BAPI_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmm02_bapi_new NO STANDARD PAGE HEADING LINE-SIZE 255.


TYPE-POOLS: slis,ole2.
TABLES: sscrfields.


TYPES : BEGIN OF t_file ,

          matnr TYPE matnr,             "2 External_Material_No
          werks TYPE werks,
          extwg TYPE extwg,        "19 External Material Group
          qmpur TYPE qmpur,        "84 QM in Procurement is Active
          ssqss TYPE ssqss,        "85 QM Control Key
*          art   TYPE rmqam-art,    "86 Inspection Type
*          aktiv TYPE rmqam-aktiv,  "87 inception active

        END OF t_file.


DATA : gt_final TYPE STANDARD TABLE OF t_file,
       wa_final TYPE t_file.

TYPES : BEGIN OF ty_mara,

          matnr TYPE mara-matnr,
          qmpur TYPE mara-qmpur,
          extwg TYPE mara-extwg,
        END OF ty_mara.


TYPES : BEGIN OF ty_marc,

          werks TYPE marc-werks,
          ssqss TYPE marc-ssqss,

        END OF ty_marc.


DATA : it_mara TYPE TABLE OF ty_mara,
       wa_mara TYPE ty_mara,

       it_marc TYPE TABLE OF ty_marc,
       wa_marc TYPE ty_marc.

DATA: gt_quality  TYPE STANDARD TABLE OF bapi1001004_qmat WITH HEADER LINE,
      wa_quality  LIKE LINE OF gt_quality,
      wa_quality1 LIKE LINE OF gt_quality.


DATA : wa_headdata           TYPE bapimathead,
       wa_clientdata         TYPE bapi_mara,
       wa_clientdatax        TYPE bapi_marax,
       wa_plantdata          TYPE bapi_marc,
       wa_plantdatax         TYPE bapi_marcx,
       it_return             TYPE STANDARD TABLE OF bapi_matreturn2,
       it_return_msg         LIKE bapi_matreturn2 OCCURS 0 WITH HEADER LINE,
       wa_return             TYPE bapi_matreturn2,
       w_materialdescription TYPE bapi_makt,
       t_materialdescription TYPE  TABLE OF bapi_makt,
*       it_return_msg         LIKE bapi_matreturn2 OCCURS 0 WITH HEADER LINE,
       ls_msg                LIKE LINE OF it_return_msg.

TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.

DATA : rawdata TYPE truxs_t_text_data.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_file TYPE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
*     FIELD_NAME    = ' '
    IMPORTING
      file_name     = p_file.

START-OF-SELECTION .

  PERFORM get_file .

  DATA : lv_matnr TYPE matnr.
  DATA : lv_ssqss TYPE marc-ssqss.
  DATA : lv_art TYPE rmqam-art.

*  BREAK primus.

  LOOP AT gt_final INTO wa_final.


    SELECT SINGLE matnr FROM mara INTO lv_matnr  WHERE matnr = wa_final-matnr.

    wa_headdata-material = wa_final-matnr .                  "Material

    wa_clientdata-extmatlgrp = wa_final-extwg .              "External Group
    wa_clientdatax-extmatlgrp = 'X' .


    wa_clientdata-qm_procmnt = wa_final-qmpur.                  "QM Pro Active
    wa_clientdatax-qm_procmnt = 'X'.



    wa_plantdata-plant   = wa_final-werks.                  "plant
    wa_plantdatax-plant   = wa_final-werks.

    wa_plantdata-ctrl_key    = wa_final-ssqss.                  "QM Control Key
    wa_plantdatax-ctrl_key   = 'X'.


*    wa_quality-insptype                = wa_final-art.               "Inspection Type

*    wa_quality-ind_insptype_mat_active = wa_final-aktiv.             "Inspection Active
*    wa_quality-ind_insptype_mat_active = 'X'.



*      APPEND w_materialdescription TO t_materialdescription.

*    IF wa_plantdata-ctrl_key IS NOT INITIAL .                    "SSQSS

*    BREAK primus.

    CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
      EXPORTING
        headdata       = wa_headdata
        clientdata     = wa_clientdata
        clientdatax    = wa_clientdatax
        plantdata      = wa_plantdata
        plantdatax     = wa_plantdatax
      IMPORTING
        return         = wa_return
      TABLES
        returnmessages = it_return.

    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

      WRITE : wa_return-message.

    ENDIF.


*    wa_quality-material                = wa_final-matnr.
*    wa_quality-plant                   = wa_final-werks.
*    wa_quality-insptype                = wa_final-art.
*    wa_quality-ind_insptype_mat_active = wa_final-aktiv.


*    IF wa_final-art IS NOT INITIAL.
*
*      SELECT SINGLE art FROM tq34 INTO wa_final  WHERE art =  wa_quality-insptype..
*
*      APPEND wa_quality TO gt_quality.
*    ENDIF.

*    IF gt_quality[] IS NOT INITIAL.
*
*      CALL FUNCTION 'BAPI_MATINSPCTRL_SAVEREPLICA'
*        TABLES
*          return         = it_return_msg
*          inspectionctrl = gt_quality.
*
*    ENDIF.
*
*    IF sy-subrc = 0.
*
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
*        EXPORTING
*          wait = 'X'.
*    ENDIF.

*    IF wa_final-art IS NOT INITIAL.
*
*      EXPORT wa_final-matnr  wa_final-art wa_final-aktiv TO MEMORY ID 'zqual' .
*
*    ENDIF.

*    EXPORT wa_final-matnr TO MEMORY ID 'zcin' .

*    IF wa_final-art IS NOT INITIAL.
*      SUBMIT zmm_upload_mat_qm_view AND RETURN.
*      SUBMIT ZMM02_QM AND RETURN .
*    ENDIF.

    CLEAR : wa_clientdata, wa_clientdatax, wa_plantdata, it_return, wa_headdata, wa_plantdatax, wa_quality.


  ENDLOOP.
*&---------------------------------------------------------------------*
*&      Form  GET_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_file .

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = rawdata
      i_filename           = p_file
    TABLES
      i_tab_converted_data = gt_final
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.



ENDFORM.
