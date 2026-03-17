*&---------------------------------------------------------------------*
*&  Include           ZGATEOUT_DELETE_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0101  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0101 INPUT.



    CASE sy-ucomm.
      WHEN 'BACK_0101'.
        leave to screen 0.
      WHEN 'CLOSE_0101'.
        leave to screen 0.
      WHEN 'BACK_0101'.
        leave to screen 0.
      WHEN '&DELETE'.
        PERFORM DELETE_DATA.
    ENDCASE.


ENDMODULE.
