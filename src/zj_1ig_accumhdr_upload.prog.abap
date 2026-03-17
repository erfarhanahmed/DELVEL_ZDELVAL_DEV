*&---------------------------------------------------------------------*
*& Report ZJ_1IG_ACCUMHDR_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*


REPORT ZJ_1IG_ACCUMHDR_UPLOAD NO STANDARD PAGE HEADING LINE-SIZE 255.

TYPES : BEGIN OF ty_final,
        THLD_CAT      TYPE J_1IG_THLD_CAT,
        SELLER_PAN    TYPE J_1IG_PANNO,
        BUYER_IDTYPE  TYPE J_1IG_IDTYPE,
        BUYER_ID      TYPE J_1IG_ID,
        KUNNR         TYPE KUNNR,
        VALID_FROM    TYPE J_1IG_VALIDFROM,
        ACCUM_AMT     TYPE J_1IG_ACCUM_AMT,
        END OF ty_final.

DATA : LT_FINAL TYPE TABLE OF TY_FINAL.
DATA : LT_J_1IG_ACCUMHDR TYPE TABLE OF J_1IG_ACCUMHDR,
       LS_J_1IG_ACCUMHDR TYPE J_1IG_ACCUMHDR.
DATA : raw_data(4096) TYPE c OCCURS 0.

SELECTION-SCREEN: BEGIN OF BLOCK bl WITH FRAME TITLE TEXT-000.
PARAMETERS: p_file TYPE rlgrap-filename.
SELECTION-SCREEN: END OF BLOCK bl.


AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
*     FIELD_NAME    = ' '
    IMPORTING
      file_name     = p_file.

START-OF-SELECTION.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
      i_line_header        = 'X'
      i_tab_raw_data       = raw_data
      i_filename           = p_file
    TABLES
      i_tab_converted_data = lt_final
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  LOOP AT LT_FINAL INTO DATA(LS_FINAL).
    MOVE-CORRESPONDING ls_final to LS_J_1IG_ACCUMHDR.
    APPEND LS_J_1IG_ACCUMHDR TO LT_J_1IG_ACCUMHDR.

  ENDLOOP.

 IF LT_J_1IG_ACCUMHDR IS NOT INITIAL.
   MODIFY J_1IG_ACCUMHDR FROM TABLE LT_J_1IG_ACCUMHDR.
   IF SY-SUBRC = 0.
     WRITE :/ 'Data uploaded sccussfully'.
   ENDIF.
 ENDIF.
