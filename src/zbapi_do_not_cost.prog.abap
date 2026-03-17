*&---------------------------------------------------------------------*
*& Report ZBAPI_DO_NOT_COST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBAPI_DO_NOT_COST.
*&---------------------------------------------------------------------*
*& Report ZMM02_BAPI_COST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*REPORT zmm02_bapi_cost.

TYPES : BEGIN OF ty_final,
          matnr(18),   " Material No
          plant(4),
          ncost(1),
        END OF ty_final.

DATA : gt_final TYPE STANDARD TABLE OF ty_final,
       wa_final TYPE ty_final.

TYPES : BEGIN OF ty_marc,
          matnr TYPE marc-matnr,
          werks TYPE marc-werks,
          ncost TYPE marc-ncost,
        END OF ty_marc.

DATA : gt_marc TYPE STANDARD TABLE OF ty_marc,
       wa_marc TYPE ty_marc.

DATA : it_raw TYPE truxs_t_text_data.

DATA : it_return TYPE bapiret2,
       mat_head  TYPE bapimathead,
       wa_sbin   TYPE bapi_marc,
       wa_sbin1  TYPE bapi_marcx.
DATA : v_ncost TYPE marc-ncost.

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

  LOOP AT gt_final INTO wa_final.

    SELECT SINGLE ncost FROM marc INTO v_ncost
      WHERE matnr  = wa_final-matnr
            AND werks = 'PL01'.


    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input        = wa_final-matnr
      IMPORTING
        output       = mat_head-material
      EXCEPTIONS
        length_error = 1
        OTHERS       = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    IF wa_final-plant = 'PL01' .
break primus.
      IF v_ncost eq 'X'.
        wa_sbin-plant       = wa_final-plant.
        wa_sbin-no_costing    = space.
*        clear wa_sbin-no_costing   ." = space.

        wa_sbin1-plant       = wa_final-plant.
        wa_sbin1-no_costing    = 'X'.
*        clear wa_sbin1-no_costing    ."= space.

      ELSE.

        wa_sbin-plant       = wa_final-plant.
        wa_sbin-no_costing    = 'X'.

        wa_sbin1-plant       = wa_final-plant.
        wa_sbin1-no_costing    = 'X'.


      ENDIF.



      CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
        EXPORTING
          headdata   = mat_head
          plantdata  = wa_sbin
          plantdatax = wa_sbin1
        IMPORTING
          return     = it_return.

      IF sy-subrc EQ 0.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

        WRITE : it_return-message.
      ENDIF.

    ELSE.
      WRITE: 'Please Enter Valid Plant'.
    ENDIF.



    IF  it_return-message IS INITIAL.
      WRITE: 'PLANT NOT EXISTS FOR THIS MATERIAL'.
    ENDIF.
    CLEAR : wa_sbin, wa_sbin1, mat_head, it_return.

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
      i_tab_raw_data       = it_raw
      i_filename           = p_file
    TABLES
      i_tab_converted_data = gt_final
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.                    " GET_FILE
