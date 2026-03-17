*----------------------------------------------------------------------*
***INCLUDE LZMGD1I02.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  F4_EQ  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE f4_eq INPUT.
*BREAK-POINT.
  TYPES : BEGIN OF ty_status,
            status TYPE char15,

          END OF ty_status.

  DATA : gt_status TYPE TABLE OF  ty_status, "ZBOM_MANTAIN,
         gs_status TYPE           ty_status.
  CLEAR : gt_status , gs_status.

  SELECT * FROM zbom_mantain INTO CORRESPONDING FIELDS OF TABLE gt_status.



  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
*     DDIC_STRUCTURE  = ' '
      retfield        = 'STATUS'
*     PVALKEY         = ' '
      dynpprog        = 'SAPLMZMGD1'
      dynpnr          = sy-dynnr
      dynprofield     = 'MARA-BOM'
*     STEPL           = 0
*     WINDOW_TITLE    =
*     VALUE           = ' '
      value_org       = 'S'
*     MULTIPLE_CHOICE = ' '
*     DISPLAY         = ' '
*     CALLBACK_PROGRAM       = ' '
*     CALLBACK_FORM   = ' '
*     CALLBACK_METHOD =
*     MARK_TAB        =
* IMPORTING
*     USER_RESET      =
    TABLES
      value_tab       = gt_status
*     FIELD_TAB       =
*     RETURN_TAB      =
*     DYNPFLD_MAPPING =
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*BREAK-POINT.

*  IF gs_status-status IS INITIAL.
*    IF mara-zpen_item IS INITIAL OR mara-zre_pen_item IS INITIAL.
*      MESSAGE 'Please fill in Pending item and Reason for pending items' TYPE 'W'.
*    ENDIF.
*  ENDIF.
*    LOOP AT SCREEN.
*      IF screen-name = 'MARA-zpen_item' AND screen-name = 'mara-zre_pen_item'. "(Screen input field name)
*
**LOOP AT SCREEN.
*
*        screen-input = '0'.
*
*        MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*
*  ENDIF.

*  IF mara-bom IS NOT INITIAL.
*    IF mara-zpen_item IS INITIAL OR mara-zre_pen_item IS INITIAL.
*      MESSAGE 'Please fill in Pending item and Reason for pending items' TYPE 'W'.
*    ENDIF.
**
**   ELSE.
**exit.
*  ENDIF.

ENDMODULE.
