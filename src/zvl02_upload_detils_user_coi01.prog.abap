*----------------------------------------------------------------------*
***INCLUDE ZVL02_UPLOAD_DETILS_USER_COI01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.
  CASE sy-ucomm.
    WHEN 'SAVE'.
      IF lt_final1 is not INITIAL.
        MESSAGE 'data available' TYPE 'I'.
        ELSE.
        MESSAGE 'data not available' TYPE 'I'.
      ENDIF.
**    WHEN .
*    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
