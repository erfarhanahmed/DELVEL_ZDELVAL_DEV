*&---------------------------------------------------------------------*
*&  Include           ZGATEOUT_CHANGE_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0101 INPUT.


    CASE sy-ucomm.
      WHEN 'BACK_0101'.
        leave to screen 0.
      WHEN 'CLOSE_0101'.
        leave to screen 0.
      WHEN 'BACK_0101'.
        leave to screen 0.
      WHEN '&SAVE_0101'.
        PERFORM CHANGE_DATA.
    ENDCASE.


ENDMODULE.
