"Name: \PR:SAPMV45A\IC:MV45AOZZ\SE:END\EI
ENHANCEMENT 0 ZSD_SCREEN_HD_ADDON.
*
*&---------------------------------------------------------------------*
*&      Module  ZVBAK_FIELD_ADD  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ZVBAK_FIELD_ADD OUTPUT.
*CHAIN.
*FIELD ZHOLD_REASON-ZHOLD_REASON_N.
*ENDCHAIN.

  IF SY-TCODE = 'VA03'.
    LOOP AT SCREEN.
      IF SCREEN-NAME = 'VBAK-ZLDPERWEEK'.
         SCREEN-INPUT = 0.
      ENDIF.
      IF SCREEN-NAME = 'VBAK-ZLDMAX'.
         SCREEN-INPUT = 0.
      ENDIF.
      IF SCREEN-NAME = 'VBAK-ZLDFROMDATE'.
         SCREEN-INPUT = 0.
      ENDIF.

      MODIFY SCREEN.

    ENDLOOP.
  ENDIF.
IF SY-TCODE = 'VA03'.
    LOOP AT SCREEN.
      IF SCREEN-NAME = 'VBAK-ZPAYTAG'.
         SCREEN-INPUT = 0.
      ENDIF.
      IF SCREEN-NAME = 'VBAK-ZADVTAG'.
         SCREEN-INPUT = 0.
      ENDIF.
   IF SCREEN-NAME = 'VBAK-ZPBG'.
         SCREEN-INPUT = 0.
      ENDIF.
      IF SCREEN-NAME = 'VBAK-ZABG'.
         SCREEN-INPUT = 0.
      ENDIF.
      MODIFY SCREEN.

    ENDLOOP.
  ENDIF.

ENDMODULE.                 " ZVBAK_FIELD_ADD  OUTPUT


MODULE ZVBAP_FIELD_ADD OUTPUT.  """""""""Added by Pranit 09.03.2024

   DATA : LS_US_VBAP TYPE VBAP.
*-----------------------Added by Vijay 06.02.2025---------------------------------------------*
   DATA : LV_ID TYPE  VRM_ID,
          LT_VALUES1 TYPE  VRM_VALUES,
          ls_values1 like LINE OF lt_values1.

DATA: BEGIN OF lt_zhold_reason occurs 0,
        zhold_key TYPE zhold_reason-zhold_key,
        zhold_reason_n1 TYPE zhold_reason-zhold_reason_n1,
      END OF lt_zhold_reason,
      ls_zhold_reason like LINE OF lt_zhold_reason.
*-----------------------Ended by Vijay---------------------------------------------*

  IF  ( SY-TCODE EQ 'VA02' OR SY-TCODE EQ 'VA01' OR SY-TCODE EQ 'VA03'  ) .

    SELECT * FROM VBAP INTO LS_US_VBAP  WHERE VBELN = VBAP-VBELN AND POSNR = VBAP-POSNR .
      ENDSELECT.

    IF  LS_US_VBAP-ZBSTKD NE VBAP-ZBSTKD.
       LS_US_VBAP-ZBSTKD = VBAP-ZBSTKD.
    ENDIF.

    IF LS_US_VBAP-ZPOSEX NE VBAP-zposex.
     LS_US_VBAP-ZPOSEX  = VBAP-ZPOSEX .
    ENDIF.

    IF LS_US_VBAP-zmrp_date NE VBAP-zmrp_date.
      LS_US_VBAP-zmrp_date = VBAP-zmrp_date.
    ENDIF.

      IF LS_US_VBAP-zexp_mrp_date1 NE VBAP-zexp_mrp_date1.        """added by Pranit 13.11.2024
      LS_US_VBAP-zexp_mrp_date1 = VBAP-zexp_mrp_date1.
    ENDIF.

**********************Added by jyoti on 26.11.2024*****************
     if LS_US_VBAP-zwhse_back ne vbap-zwhse_back.
       LS_US_VBAP-zwhse_back = vbap-zwhse_back.
     endif.

     if LS_US_VBAP-ztran_delay ne vbap-ztran_delay.
       LS_US_VBAP-ztran_delay = vbap-ztran_delay.
     endif.

     if LS_US_VBAP-ZASSM_BACK ne vbap-ZASSM_BACK.
       LS_US_VBAP-ZASSM_BACK = vbap-ZASSM_BACK.
     endif.

     if LS_US_VBAP-ZLCL_DELAYS ne vbap-ZLCL_DELAYS.
       LS_US_VBAP-ZLCL_DELAYS = vbap-ZLCL_DELAYS.
     endif.

     if LS_US_VBAP-ZOTHER_COMMENT ne vbap-ZOTHER_COMMENT.
       LS_US_VBAP-ZOTHER_COMMENT = vbap-ZOTHER_COMMENT.
     endif.

     if vbap-ZOTHER_COMMENT = 'X'.
    if LS_US_VBAP-ZOTHER_REMARK ne vbap-ZOTHER_REMARK.
       LS_US_VBAP-ZOTHER_REMARK = vbap-ZOTHER_REMARK.
     endif.
     ELSE.
       CLEAR : vbap-ZOTHER_REMARK.
        LS_US_VBAP-ZOTHER_REMARK = vbap-ZOTHER_REMARK.
     endif.

*     IF LS_US_VBAP-zmrp_delay NE VBAP-zmrp_delay.        """added by Pranit 23.11.2024
*      LS_US_VBAP-zmrp_delay = VBAP-zmrp_delay.
*    ENDIF.
************************************************************************
*   if LS_US_VBAP-zmrp_delay is NOT INITIAL.
*    DATA(lv_str1) = strlen( LS_US_VBAP-zmrp_delay ).
*   data(lv_count1) = lv_Str1 - 1.
*
*   if LS_US_VBAP-zmrp_delay+LV_count1(1) = ','.
*    LS_US_VBAP-zmrp_delay+LV_count1(1) = ' '.
*   endif.
*   endif.
*-----------------------Added by Vijay 06.02.2025---------------------------------------------*
SELECT zhold_key
       zhold_reason_n1 FROM ZHOLD_REASON INTO TABLE LT_ZHOLD_REASON.
     IF LT_VALUES1 IS INITIAL.
      LOOP AT LT_ZHOLD_REASON INTO lS_ZHOLD_REASON.
        LS_VALUES1-KEY  = LS_ZHOLD_REASON-zhold_key.
        LS_VALUES1-TEXT = LS_ZHOLD_REASON-zhold_reason_n1.
        APPEND LS_VALUES1 TO LT_VALUES1.
        CLEAR : LS_VALUES1, LS_ZHOLD_REASON.
      ENDLOOP.
      ENDIF.
SORT LT_VALUES1 BY KEY.
delete ADJACENT DUPLICATES FROM LT_VALUES1 COMPARING ALL FIELDS.
*LV_ID = 'VBAP-ZHOLD_REASON_N'.
LV_ID = 'VBAP-ZHOLD_REASON_N1'.

    CALL FUNCTION 'VRM_SET_VALUES'
      EXPORTING
        ID              = LV_ID
        VALUES          = LT_VALUES1
      EXCEPTIONS
        ID_ILLEGAL_NAME = 1
        OTHERS          = 2.
    IF SY-SUBRC <> 0.
* Implement suitable error handling here
    ENDIF.
*-----------------------Ended by Vijay---------------------------------------------*
**********ADDED BY PRIMUS JM 14.03.2024******************
     IF LS_US_VBAP-ZINS_LOC NE VBAP-ZINS_LOC.
     LS_US_VBAP-ZINS_LOC  = VBAP-ZINS_LOC .
    ENDIF.
     IF LS_US_VBAP-zhold_reason_n1 NE VBAP-zhold_reason_n1.
     LS_US_VBAP-zhold_reason_n1  = VBAP-zhold_reason_n1 .
    ENDIF.

***************************************************************
*********ADDEDBY JYOTI ON 25.11.2024*********************
* data :   IT_DATA_NEW TYPE TABLE OF ZDELAY_CHECK_MRP.
* SELECT * FROM ZDELAY_CHECK_MRP
*  INTO TABLE IT_DATA_NEW
*  WHERE VBELN = VBAP-VBELN
*    AND POSNR = VBAP-POSNR .
*
  ENDIF.

************ADDED BY PRIMUS JM 14.03.2024***************

   IF VBAP-WERKS NE 'PL01'.

  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'IL1'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.

      LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'MRP'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.

       LOOP AT SCREEN.                      """aDDED BY PRANIT 13.11.2024
    IF SCREEN-GROUP1 = 'EMR'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.

          LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'HRS'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.
      ENDIF.

**********************************************
IF VBAK-vkorg EQ 'US00'.
  BREAK PRIMUSABAP.
*  if sy-ucomm ne 'FB1'.
  IF VBAP-zother_comment Eq ' '.
    CLEAR : VBAP-ZOTHER_REMARK.
    LOOP AT SCREEN.
*      IF SCREEN-GROUP1 = 'MR6'.
*      SCREEN-ACTIVE  = 0.
      if SCREEN-NAME = 'VBAP-ZOTHER_REMARK' .
        screen-input = 0.
      MODIFY SCREEN.
      ENDIF.
    ENDLOOP.
    .
  ENDIF.
*  ENDIF.
ENDIF.
*  if sy-ucomm = 'FB1'.
**  sy-ucomm = 'T\14'.
*  sy-ucomm = 'SHLI'.
*endif.
**endif.

  IF VBAK-vkorg NE 'US00'.

  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'GP1'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.

   LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'EXD'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.
    """"""""""""""""""""""""""
     LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'MR1'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.
     LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'MR2'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.
     LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'MR3'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.
     LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'MR4'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.
     LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'MR5'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.

     LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'MR6'.
      SCREEN-ACTIVE  = 0.
      MODIFY SCREEN.
    ENDIF.
    ENDLOOP.
    """""""""""""""""""""""""""""""
      ENDIF.
""""""""""""""""""""""""""""""""""Added by Pranit 09.03.2024

  IF SY-TCODE = 'VA03'.
    LOOP AT SCREEN.
      IF SCREEN-NAME = 'VBAP-HOLDDATE'    OR
         SCREEN-NAME = 'VBAP-HOLDRELDATE' OR
         SCREEN-NAME = 'VBAP-CANCELDATE'  OR
         SCREEN-NAME = 'VBAP-DELDATE'     OR
         SCREEN-NAME = 'VBAP-CUSTDELDATE' OR
         SCREEN-NAME = 'VBAP-ZMONO'       OR
         SCREEN-NAME = 'VBAP-ZIBR'        OR
         SCREEN-NAME = 'VBAP-ZUL'         OR
         SCREEN-NAME = 'VBAP-ZSL'         OR
         SCREEN-NAME = 'VBAP-ZCE'         OR
         SCREEN-NAME = 'VBAP-ZAPI6D'      OR
         SCREEN-NAME = 'VBAP-ZAPI60'      OR
         SCREEN-NAME = 'VBAP-ZATEX'       OR
         SCREEN-NAME = 'VBAP-ZTRCU'       OR
         SCREEN-NAME = 'VBAP-ZCRN'        OR
         SCREEN-NAME = 'VBAP-ZMARINE'     OR
         SCREEN-NAME = 'VBAP-ZAPI6A'      OR
         SCREEN-NAME = 'VBAP-ZAPI608'     OR
         SCREEN-NAME = 'VBAP-ZWARS'       OR
         SCREEN-NAME = 'VBAP-ZGAD'        OR
         SCREEN-NAME = 'VBAP-RECEIPT_DATE'OR
         SCREEN-NAME = 'VBAP-REASON'      OR
         SCREEN-NAME = 'VBAP-OFM_DATE'    OR
         SCREEN-NAME = 'VBAP-CTBG'        OR
         SCREEN-NAME = 'VBAP-ZBSTKD'        OR      ""Added by Pranit 09.03.2024
         SCREEN-NAME = 'VBAP-ZPOSEX'        or       ""Added by Pranit 09.03.2024
         SCREEN-NAME = 'VBAP-ZINS_LOC'      OR   ""Added by JM 14.03.2024
         SCREEN-NAME = 'VBAP-ZMRP_DATE'     OR       ""Added by pRANIT  21.06.2024
         SCREEN-NAME = 'VBAP-ZEXP_MRP_DATE1'  OR       ""Added by pRANIT  21.06.2024
         SCREEN-NAME = 'VBAP-ZHOLD_REASON_N1' OR        "ADDED BY JYOTI ON05.02.2025
         SCREEN-NAME = 'VBAP-ZWHSE_BACK'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZTRAN_DELAY'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZASSM_BACK'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZLCL_DELAYS'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZOTHER_COMMENT'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZOTHER_REMARK'  .          ""Added by pRANIT  18.11.2024

         SCREEN-INPUT = 0.
      ENDIF.
       MODIFY SCREEN.
    ENDLOOP.

    if VBAK-vkorg eq 'US00'.
     LOOP AT SCREEN.
       IF SCREEN-NAME = 'VBAP-ZWHSE_BACK'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZTRAN_DELAY'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZASSM_BACK'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZLCL_DELAYS'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZOTHER_COMMENT'      or       ""Added by pRANIT  18.11.2024
         SCREEN-NAME = 'VBAP-ZOTHER_REMARK'      or       ""Added by pRANIT  18.11.2024
         SCREEN-INPUT = 0.
       ENDIF.
     ENDLOOP.
    ENDIF.
  ENDIF.
ENDMODULE.

*MODULE OTHER_COMMENT INPUT.
*IF VBAK-vkorg EQ 'US00'.
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
*if sy-ucomm = 'FB1'.
*  clear : sy-ucomm.
*endif.
*  ENDMODULE.


ENDENHANCEMENT.
