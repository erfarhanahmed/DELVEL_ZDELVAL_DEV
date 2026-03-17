*&---------------------------------------------------------------------*
*& Report ZBAPI_MM02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBAPI_MM02.

TYPES : BEGIN OF ty_final,
        matnr(18),   " Material No
        PLANT(4),
        STG_LOC(4),
        sbin TYPE LGPBE,
       END OF TY_FINAL.

DATA : GT_FINAL TYPE STANDARD TABLE OF TY_FINAL,
       WA_FINAL TYPE TY_FINAL.

TYPES : BEGIN OF ty_mard,
        matnr TYPE mard-matnr,
        werks TYPE mard-werks,
        lgort TYPE mard-lgort,
        END OF TY_mard.

DATA : GT_mard TYPE STANDARD TABLE OF TY_mard,
       WA_mard TYPE TY_mard.

DATA : IT_RAW TYPE truxs_t_text_data.

DATA :
       IT_RETURN TYPE BAPIRET2,
       mat_head   TYPE bapimathead,
       wa_SBIN   TYPE BAPI_MARD,
       wa_SBIN1  TYPE BAPI_MARDX.

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS : p_file TYPE rlgrap-filename OBLIGATORY.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file .

CALL FUNCTION 'F4_FILENAME'
 EXPORTING
   PROGRAM_NAME        = SYST-CPROG
   DYNPRO_NUMBER       = SYST-DYNNR
*   FIELD_NAME          = ' '
 IMPORTING
   FILE_NAME           = P_FILE
          .

START-OF-SELECTION .

PERFORM GET_FILE .

LOOP AT GT_FINAL INTO WA_FINAL.

CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
  EXPORTING
    input              = WA_FINAL-MATNR
 IMPORTING
   OUTPUT             = mat_head-MATERIAL
 EXCEPTIONS
   LENGTH_ERROR       = 1
   OTHERS             = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

*mat_head-MATERIAL   = WA_FINAL-MATNR.
WA_SBIN-PLANT       = WA_FINAL-PLANT.

if WA_FINAL-STG_LOC is not INITIAL.

select matnr werks lgort
  from mard
  into TABLE gt_mard
  where matnr eq mat_head-MATERIAL
  and   werks eq wa_final-plant.

 clear: wa_mard.
 LOOP AT gt_mard into wa_mard.

 if WA_FINAL-STG_LOC eq wa_mard-lgort.
 WA_SBIN-STGE_LOC    = WA_FINAL-STG_LOC.
WA_SBIN-STGE_BIN   = WA_FINAL-SBIN.



WA_SBIN1-PLANT       = WA_FINAL-PLANT.
WA_SBIN1-STGE_LOC    = WA_FINAL-STG_LOC.
WA_SBIN1-STGE_BIN    = 'X'.





  CALL FUNCTION 'BAPI_MATERIAL_SAVEDATA'
    EXPORTING
      HEADDATA                = MAT_HEAD
    STORAGELOCATIONDATA            = WA_SBIN
     STORAGELOCATIONDATAX           = WA_SBIN1

 IMPORTING
   RETURN                     = IT_RETURN

  .
IF SY-SUBRC EQ 0.
  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
   EXPORTING
     WAIT          = 'X'                                            " ADDED BY PRATYANCHA ON 28.06.2024
*   IMPORTING
*     RETURN        =
            .
  WAIT UP TO 3 SECONDS.                                             " ADDED BY PRATYANCHA ON 28.06.2024 LOGIC BY MANOJ VYAVAHARE.
WRITE : IT_RETURN-MESSAGE.
ENDIF.

 endif.
 endloop.

 IF  IT_RETURN-MESSAGE IS INITIAL.

   WRITE: 'STORAGE LOCATION NOT EXISTS FOR THIS MATERIAL'.
   ENDIF.
 clear : wa_sbin, wa_sbin1, mat_head, it_return.

endif.


 clear : wa_sbin, wa_sbin1, mat_head, it_return.
ENDLOOP.
*&---------------------------------------------------------------------*
*&      Form  GET_FILE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form GET_FILE .

CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
  EXPORTING
*   I_FIELD_SEPERATOR          =
   I_LINE_HEADER              = 'X'
    i_tab_raw_data             = IT_RAW
    i_filename                 = P_FILE
  TABLES
    i_tab_converted_data       = GT_FINAL
 EXCEPTIONS
   CONVERSION_FAILED          = 1
   OTHERS                     = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.


endform.                    " GET_FILE
