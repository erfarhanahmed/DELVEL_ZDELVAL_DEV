*----------------------------------------------------------------------*
***INCLUDE LZMGD1I01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  GET_DATA  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE get_data INPUT.
*  BREAK-POINT.

*   IF mara-bom IS not INITIAL.
*
*    IF mara-zpen_item IS INITIAL OR mara-zre_pen_item IS INITIAL.
*      MESSAGE 'Please fill in Pending item and Reason for pending items' TYPE 'W'.
*    ENDIF.
**
**   ELSE.
**exit.
*  ENDIF.

*  if sy-tcode = 'MM02'.
*    IF MARA-BOM IS INITIAL.
*      LOOP AT SCREEN.
*        IF SCREEN-NAME = 'MARA-ZPEN_ITEM'.
**          LOOP AT SCREEN.
*          SCREEN-INPUT = 0.
*          MODIFY SCREEN.
**          ENDLOOP.
*          ENDIF.
*        ENDLOOP.
*      ENDIF.
*    ENDIF.
****  DATA : v_ser   TYPE mara-zseries,
****         v_size  TYPE mara-zseries,
****         v_brand TYPE mara-zseries,
****         v_moc   TYPE mara-zseries,
****         v_type  TYPE mara-zseries.
****  v_ser   =  mara-zseries.
****  v_size  =  mara-zsize.
****  v_brand =  mara-brand.
****  v_moc   =  mara-moc.
****  v_type  =  mara-type.
****  EXPORT v_ser v_size v_brand v_moc v_type TO MEMORY ID 'MM'.
ENDMODULE.
