**----------------------------------------------------------------------*
****INCLUDE LZMGD1I06.
**----------------------------------------------------------------------*
**&---------------------------------------------------------------------*
**&      Module  F4_EQ_NEW  INPUT
**&---------------------------------------------------------------------*
**       text
**----------------------------------------------------------------------*
*MODULE f4_eq_new INPUT.
* TYPES : BEGIN OF ty_status_new,
*           ZBOI TYPE CHAR1,
*
*          END OF ty_status_new.
*
*  DATA : gt_status_new TYPE TABLE OF  zboi_1, "ZBOM_MANTAIN,
*         gs_status_new TYPE           zboi_1.
*  CLEAR : gt_status_new , gs_status_new.
*
*  SELECT * FROM zboi_1 INTO CORRESPONDING FIELDS OF TABLE gt_status_new.
*
*
*
*  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*    EXPORTING
**     DDIC_STRUCTURE  = ' '
*      retfield        = 'ZBOI'
**     PVALKEY         = ' '
*      dynpprog        = 'SAPLMZMGD1'
*      dynpnr          = sy-dynnr
*      dynprofield     = 'MARA-ZBOI'
**     STEPL           = 0
**     WINDOW_TITLE    =
**     VALUE           = ' '
*      value_org       = 'S'
**     MULTIPLE_CHOICE = ' '
**     DISPLAY         = ' '
**     CALLBACK_PROGRAM       = ' '
**     CALLBACK_FORM   = ' '
**     CALLBACK_METHOD =
**     MARK_TAB        =
** IMPORTING
**     USER_RESET      =
*    TABLES
*      value_tab       = gt_status_new
**     FIELD_TAB       =
**     RETURN_TAB      =
**     DYNPFLD_MAPPING =
*    EXCEPTIONS
*      parameter_error = 1
*      no_values_found = 2
*      OTHERS          = 3.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*
*
*
*
*
*ENDMODULE.
