*----------------------------------------------------------------------*
***INCLUDE ZMV45A_ZF4O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  ZF4  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ZF4 OUTPUT.




ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ZF4  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ZF4 INPUT.
TYPES : BEGIN OF ty_dev_status,
         ZPAYTAG TYPE VBAK-ZPAYTAG,

  END OF ty_dev_status.

DATA : gt_dev_status TYPE TABLE OF  ty_dev_status, "ZBOM_MANTAIN,
       gs_dev_status TYPE           ty_dev_status.
CLEAR : GT_dev_STATUS , GS_dev_STATUS.

*BREAK-POINT.

SELECT * FROM ZVBAK2 INTO CORRESPONDING FIELDS OF TABLE GT_DEV_STATUS.

CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
  EXPORTING
*   DDIC_STRUCTURE         = ' '
    retfield               = 'ZPAYTAG'
*   PVALKEY                = ' '
   DYNPPROG               = 'SAPMV45A'
   DYNPNR                 = SY-DYNNR
   DYNPROFIELD            = 'VBAK-ZPAYTAG'
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

  if screen-name = 'VBAK-ZPAYTAG'.
    IF gs_dev_status-ZPAYTAG = ' '.
    LOOP AT SCREEN.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
      ENDLOOP.
    endif.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ZF41  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ZF41 INPUT.
TYPES : BEGIN OF ty_dev_status1,
         ZADVTAG TYPE VBAK-ZADVTAG,

  END OF ty_dev_status1.

DATA : gt_dev_status1 TYPE TABLE OF  ty_dev_status1, "ZBOM_MANTAIN,
       gs_dev_status1 TYPE           ty_dev_status1.
CLEAR : GT_dev_STATUS1 , GS_dev_STATUS1.

*BREAK-POINT.

SELECT * FROM ZVBAK3 INTO CORRESPONDING FIELDS OF TABLE GT_DEV_STATUS1.

CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
  EXPORTING
*   DDIC_STRUCTURE         = ' '
    retfield               = 'ZADVTAG'
*   PVALKEY                = ' '
   DYNPPROG               = 'SAPMV45A'
   DYNPNR                 = SY-DYNNR
   DYNPROFIELD            = 'VBAK-ZADVTAG'
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
    value_tab              = GT_DEV_STATUS1
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
READ TABLE gt_dev_status1 into gs_dev_status1 INDEX 1.

  if screen-name = 'VBAK-ZADVTAG'.
    IF gs_dev_status1-ZADVTAG = ' '.
    LOOP AT SCREEN.
      SCREEN-INPUT = 0.
      MODIFY SCREEN.
      ENDLOOP.
    endif.
  ENDIF.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  REASON  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE reason INPUT.
*  IF  vbap-reason = '01'.
*    vbap-reason = 'Hold'.
*    ELSEIF  vbap-reason = '02'.
*      vbap-reason = 'Cancel'.
*    ELSEIF  vbap-reason = '03'.
*      vbap-reason = 'QTY Change'.
*    ELSEIF  vbap-reason = '04'.
*      vbap-reason = 'Quality Change'.
*    ELSEIF  vbap-reason = '05'.
*       vbap-reason = 'Technical Changes'.
*    ELSEIF  vbap-reason = '06'.
*       vbap-reason = 'New Line'.
*    ELSEIF  vbap-reason = '07'.
*       vbap-reason = 'Line added against BCR'.
*    ELSEIF  vbap-reason = '08'.
*     vbap-reason = 'Line added against wrong code given by sales'.
*        ELSEIF  vbap-reason = '09'.
*     vbap-reason = 'Line added for split scheduling'.
*        ELSEIF  vbap-reason = '10'.
*     vbap-reason = 'Clubbed line'.
*        ELSEIF  vbap-reason = '11'.
*     vbap-reason = 'No Pending'.
*
*
*  ENDIF.

ENDMODULE.
