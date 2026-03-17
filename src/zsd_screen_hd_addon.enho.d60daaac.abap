"Name: \PR:SAPMV45A\IC:MV45AIZZ\SE:END\EI
ENHANCEMENT 0 ZSD_SCREEN_HD_ADDON.
*
*&---------------------------------------------------------------------*
*&      Module  PAI_8309  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE PAI_8309 INPUT.


ENDMODULE.                 " PAI_8309  INPUT
MODULE PAI_8459 INPUT.
***CHAIN.
***  FIELD ZHOLD_REASON-ZHOLD_REASON_N.
***ENDCHAIN.

*  IF VBAK-vkorg EQ 'US00'.
*  BREAK PRIMUSABAP.
*  IF VBAP-zother_comment NE 'X'.
*    LOOP AT SCREEN.
*      IF SCREEN-GROUP1 = 'MR6'.
*      SCREEN-ACTIVE  = 0.
*      MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*ENDIF.

*loop at SCREEN.
*     if SCREEN-NAME = 'VBAP-ZOTHER_REMARK' .      ""Added by pRANIT  18.11.2024
*     SCREEN-INPUT = 0.
*     endif.
*     MODIFY SCREEN.
*  ENDLOOP.

*IF VBAP-WERKS EQ 'US01'.
IF VBAK-vkorg EQ 'US00'.
*  BREAK-POINT.
  if sy-ucomm = 'ZFB1'.
   IF VBAP-zother_comment NE 'X'.
     CLEAR : VBAP-ZOTHER_REMARK.
    LOOP AT SCREEN.
*      IF SCREEN-GROUP1 = 'MR6'.
*      SCREEN-ACTIVE  = 0.
      if SCREEN-NAME = 'VBAP-ZOTHER_REMARK' .
     SCREEN-INPUT = 0.
      MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    else.
      LOOP AT SCREEN.
        if SCREEN-NAME = 'VBAP-ZOTHER_REMARK' .
     SCREEN-INPUT = 1.
      MODIFY SCREEN.
      ENDIF.
      endloop.
  ENDIF.
  ENDIF.
*if sy-ucomm = 'ZFB1'.
**  sy-ucomm = 'T\14'.
*  sy-ucomm = 'SHLI'.
*endif.
                                            """ADDED BY PRANIT 11.01.2024
IF VBAP-CUSTDELDATE lt sy-datum.
  MESSAGE | The Customer Del Date is in the past. | TYPE 'W'. "DISPLAY LIKE 'E'.
ENDIF.
ENDIF.
*if vbak-vkorg = '1000'.
*  DATA : LV_ID_1 TYPE  VRM_ID,
*          LT_VALUES_new TYPE  VRM_VALUES,
*          ls_values_new like LINE OF lt_values_new.
*DATA: BEGIN OF lt_zhold_reason1 occurs 0,
*        zhold_key TYPE zhold_reason-zhold_key,
*        zhold_reason_n TYPE zhold_reason-zhold_reason_n,
*      END OF lt_zhold_reason1,
*      ls_zhold_reason1 like LINE OF lt_zhold_reason1.
*      sELECT zhold_key
*       zhold_reason_n FROM ZHOLD_REASON INTO TABLE LT_ZHOLD_REASON1.
*
*      LOOP AT LT_ZHOLD_REASON1 INTO lS_ZHOLD_REASON1.
*        LS_VALUES_new-KEY  = LS_ZHOLD_REASON1-zhold_key.
*        LS_VALUES_new-TEXT = LS_ZHOLD_REASON1-zhold_reason_n.
*        APPEND LS_VALUES_new TO LT_VALUES_new.
*        CLEAR : LS_VALUES_new, LS_ZHOLD_REASON1.
*      ENDLOOP.
*
*LV_ID_1 = 'VBAP-ZHOLD_REASON_N'.
**LV_ID = 'ZHOLD_REASON-ZHOLD_REASON_N'.
*
*    CALL FUNCTION 'VRM_SET_VALUES'
*      EXPORTING
*        ID              = LV_ID_1
*        VALUES          = LT_VALUES_new
*      EXCEPTIONS
*        ID_ILLEGAL_NAME = 1
*        OTHERS          = 2.
*    IF SY-SUBRC <> 0.
** Implement suitable error handling here
*    ENDIF.
*
*endif.
ENDMODULE.                 " PAI_8459  INPUT

*MODULE ZCUSTDELDATE .

*  IF VBAP-WERKS EQ 'US01'.                                              """"ADDED BY PRANIT 11.01.2024
*IF VBAP-CUSTDELDATE lt sy-datLO.
*  CLEAR SY-UCOMM.
*  MESSAGE | The Customer Del Date is in the past. | TYPE 'E'. "DISPLAY LIKE 'E'.
*ENDIF.
*ENDIF.

**  ENDMODULE.
*MODULE OTHER_COMMENT.
*IF VBAK-vkorg EQ 'US00'.
*  BREAK PRIMUSABAP.
*  IF VBAP-zother_comment NE 'X'.
*    LOOP AT SCREEN.
*      IF SCREEN-GROUP1 = 'MR6'.
*      SCREEN-ACTIVE  = 0.
*      MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*    else.
*      LOOP AT SCREEN.
*      IF SCREEN-GROUP1 = 'MR6'.
*      SCREEN-ACTIVE  = 1.
*      MODIFY SCREEN.
*      ENDIF.
*    ENDLOOP.
*  ENDIF.
*ENDIF.
*if sy-ucomm = 'FB1'.
*  clear : sy-ucomm.
*endif.
*ENDMODULE.

ENDENHANCEMENT.
