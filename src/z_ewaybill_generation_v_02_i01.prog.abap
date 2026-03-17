*&---------------------------------------------------------------------*
*& Include          Z_EWAYBILL_GENERATION_V_02_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0600  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0600 INPUT.
*CASE sy-ucomm.
*     WHEN '&CAN' OR 'CANCEL'.
*      SET SCREEN '0'.
*      LEAVE SCREEN.
*    WHEN OTHERS.
*  ENDCASE.
*
*  CASE ZEWAY_MULTI_VEH-MULTI_VEH.
*    WHEN 'INITIATE' .
*      CALL SCREEN 700 STARTING AT 05 05.
*      SET SCREEN '0'.
*      LEAVE SCREEN.
*    WHEN 'ADD' .
*      CALL SCREEN 800 STARTING AT 05 05.
*      SET SCREEN '0'.
*      LEAVE SCREEN.
*   WHEN 'CHANGE' .
*      CALL SCREEN 900 STARTING AT 05 05.
*      SET SCREEN '0'.
*      LEAVE SCREEN.
*
*    WHEN OTHERS.
* ENDCASE.
ENDMODULE.
