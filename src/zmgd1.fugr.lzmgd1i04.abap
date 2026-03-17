*----------------------------------------------------------------------*
***INCLUDE LZMGD1I04.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  F4_EQ1  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

*BREAK-POINT.
MODULE f4_eq1 INPUT.

TYPES : BEGIN OF ty_dev_status,
         dev_status TYPE char25,

  END OF ty_dev_status.

DATA : gt_dev_status TYPE TABLE OF  ty_dev_status, "ZBOM_MANTAIN,
       gs_dev_status TYPE           ty_dev_status.
CLEAR : GT_dev_STATUS , GS_dev_STATUS.

*BREAK-POINT.

SELECT * FROM ZDEV_STATUS INTO CORRESPONDING FIELDS OF TABLE GT_DEV_STATUS.

CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
  EXPORTING
*   DDIC_STRUCTURE         = ' '
    retfield               = 'DEV_STATUS'
*   PVALKEY                = ' '
   DYNPPROG               = 'SAPLZMGD1'
   DYNPNR                 = SY-DYNNR
   DYNPROFIELD            = 'MARA-DEV_STATUS'
*   STEPL                  = 0
*   WINDOW_TITLE           =
*   VALUE                  = ' '
   VALUE_ORG              = 'S'
*   MULTIPLE_CHOICE        = ' '
*   DISPLAY                = ' '
*   CALLBACK_PROGRAM       = ' '
*   CALLBACK_FORM          = ' '
*   CALLBACK_METHOD        =
*   MARK_TAB               =
* IMPORTING
*   USER_RESET             =
  tables
    value_tab              = GT_DEV_STATUS
*   FIELD_TAB              =
*   RETURN_TAB             =
*   DYNPFLD_MAPPING        =
* EXCEPTIONS
*   PARAMETER_ERROR        = 1
*   NO_VALUES_FOUND        = 2
*   OTHERS                 = 3
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

*if GS_dev_status-dev_status is INITIAL.
READ TABLE gt_dev_status into gs_dev_status INDEX 1.

  if screen-name = 'mara-dev_status'.
    IF gs_dev_status-dev_status = ' '.
    LOOP AT SCREEN.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
      ENDLOOP.
    endif.
  ENDIF.

ENDMODULE.
