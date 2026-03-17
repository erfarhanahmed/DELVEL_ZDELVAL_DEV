*&---------------------------------------------------------------------*
*&  Include           ZGATEOUT_CHANGE_DATA
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_ENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_ENTRY .

  CASE ABAP_TRUE.
    WHEN ABAP_TRUE.
      PERFORM CHANGE_ENTRY.
      CALL SCREEN 0101.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHANGE_ENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CHANGE_ENTRY .

  SELECT SINGLE MAX( ZSER_NO ) FROM ZGATE_OUT INTO @DATA(LV_SR) WHERE ZNUMBER_01 = @P_NUMBER.

  DATA(LV_SR1) = LV_SR.

  SELECT SINGLE ZV_DATE
                ZVEH_NUM
                ZOUT_TIME
                ZOUT_DATE
            MAX( ZSER_NO )
                ZV_DRIVER_NAME
                ZTRANS_NAME
                ZINVOICE_NO
                ZCRETED_BY
                ZV_REMARK
                ZNUMBER_01
                ZSEC_NAME
                ZCHANGE_REMARK
                ZREFE_NO
                ZFSTORAGE_LOC       " ADD BY SUPRIYA 05.07.2024
                ZTSTORAGE_LOC    " ADD BY SUPRIYA 05.07.2024

                         FROM ZGATE_OUT INTO CORRESPONDING FIELDS OF ZGATE_OUT
                WHERE ZNUMBER_01 EQ P_NUMBER

                AND ZSER_NO = LV_SR1
                GROUP BY ZV_DATE ZVEH_NUM ZOUT_TIME ZOUT_DATE ZSER_NO ZV_DRIVER_NAME ZTRANS_NAME ZINVOICE_NO ZCRETED_BY
                ZV_REMARK ZNUMBER_01 ZSEC_NAME ZCHANGE_REMARK ZREFE_NO ZFSTORAGE_LOC ZTSTORAGE_LOC.


* Start Added by supriya on 06.07.2024
  SELECT VBELN,
         POSNR,
         VGBEL
    FROM VBRP
    INTO TABLE @DATA(IT_VBRP)
    WHERE VBELN = @ZGATE_OUT-ZINVOICE_NO.

  IF IT_VBRP IS NOT INITIAL.
    SELECT  MBLNR,
            MJAHR,
            ZEILE,
            LGORT,
            XAUTO
      FROM MSEG FOR ALL ENTRIES IN @IT_VBRP
      WHERE MBLNR = @IT_VBRP-VGBEL
      INTO TABLE @DATA(LT_MSEG).

    READ TABLE IT_VBRP INTO DATA(LS_VBRP) WITH KEY VBELN = ZGATE_OUT-ZINVOICE_NO.
    IF SY-SUBRC = 0.
      LOOP AT LT_MSEG INTO DATA(LS_MSEG) WHERE MBLNR = LS_VBRP-VGBEL.
        IF LS_MSEG-XAUTO IS INITIAL.
          ZGATE_OUT-ZFSTORAGE_LOC = LS_MSEG-LGORT.
        ELSEIF LS_MSEG-XAUTO IS NOT INITIAL.

          IF LS_MSEG-LGORT IS NOT INITIAL.
            ZGATE_OUT-ZTSTORAGE_LOC = LS_MSEG-LGORT.
          ELSEIF LS_MSEG-LGORT IS INITIAL.
            ZGATE_OUT-ZTSTORAGE_LOC = 'Other'.
          ENDIF.

        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDIF.

*End Added by supriya on 06.07.2024


  WA_MPP-ZV_DATE         = ZGATE_OUT-ZV_DATE.
  WA_MPP-ZVEH_NUM        = ZGATE_OUT-ZVEH_NUM.
*  WA_MPP-ZOUT_TIME      = ZGATE_OUT-ZOUT_TIME.
  WA_MPP-ZOUT_TIME       = SY-UZEIT.
  WA_MPP-ZOUT_DATE       = ZGATE_OUT-ZOUT_DATE.
  WA_MPP-ZV_DRIVER_NAME  = ZGATE_OUT-ZV_DRIVER_NAME.
  WA_MPP-ZTRANS_NAME     = ZGATE_OUT-ZTRANS_NAME.
*  WA_MPP-ZINVOICE_NO    = ZGATE_OUT-ZINVOICE_NO.
  WA_MPP-ZCRETED_BY      = ZGATE_OUT-ZCRETED_BY.
  WA_MPP-ZV_REMARK       = ZGATE_OUT-ZV_REMARK.
  WA_MPP-ZNUMBER_01      = ZGATE_OUT-ZNUMBER_01.
  WA_MPP-ZSEC_NAME       = ZGATE_OUT-ZSEC_NAME.
  WA_MPP-ZCHANGE_REMARK  = ZGATE_OUT-ZCHANGE_REMARK.
  WA_MPP-ZREFE_NO        = ZGATE_OUT-ZREFE_NO.
  WA_MPP-ZFSTORAGE_LOC  =  ZGATE_OUT-ZFSTORAGE_LOC.  " ADD BY SUPRIYA 05.07.2024
  WA_MPP-ZTSTORAGE_LOC  =  ZGATE_OUT-ZTSTORAGE_LOC . " ADD BY SUPRIYA 05.07.2024
  ZGATE_OUT-ZSER_NO = LV_SR + 1.

  DATA LV_INV_NO TYPE ZGATE_OUT-ZINVOICE_NO.

  LV_INV_NO = WA_MPP-ZINVOICE_NO.

  IF LV_INV_NO IS NOT INITIAL.

    SELECT POSNR,
           ARKTX,
           VRKME,
           NETWR ,
           MATNR,
           VKORG_AUFT,
           MWSBP,
           WERKS,
           AUBEL,
           FKIMG
      FROM VBRP
      INTO TABLE @DATA(IT_DATA_N)
      WHERE VBELN = @ZGATE_OUT-ZINVOICE_NO.

    LOOP AT IT_DATA_N INTO DATA(WA_DATA_N).
      WA_DATA-WERKS = WA_DATA_N-WERKS.
      WA_DATA-VKORG_AUFT = WA_DATA_N-VKORG_AUFT.
      WA_DATA-AUBEL = WA_DATA_N-AUBEL.
      WA_DATA-POSNR = WA_DATA_N-POSNR.
      WA_DATA-MATNR = WA_DATA_N-MATNR.
      WA_DATA-ARKTX = WA_DATA_N-ARKTX.
      WA_DATA-FKIMG = WA_DATA_N-FKIMG.
      WA_DATA-VRKME = WA_DATA_N-VRKME.
      APPEND WA_DATA TO IT_DATA.
    ENDLOOP.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CHANGE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CHANGE_DATA .

  IF ZGATE_OUT IS NOT INITIAL.
    ZGATE_OUT-ZCHANG_DATE = SY-DATUM.
    ZGATE_OUT-ZCHANG_NAME = SY-UNAME.
    ZGATE_OUT-ZCHANG_TIME = SY-UZEIT.

    MODIFY ZGATE_OUT FROM ZGATE_OUT.
    COMMIT WORK.
    MESSAGE |Save data successfully for GATEOUT No. :| && ZGATE_OUT-ZNUMBER_01 TYPE 'E' DISPLAY LIKE 'S'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  ZTRANS_NAME  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ZTRANS_NAME INPUT.

  IF  ZGATE_OUT-ZTRANS_NAME IS NOT INITIAL.

    SELECT
         ZTRANS_NAME_01
    FROM ZTRANSPORTERCODE
    WHERE ZTRANS_NAME_01 = @ZGATE_OUT-ZTRANS_NAME
    INTO @DATA(WA_TRANS).
    ENDSELECT.

    IF  WA_TRANS NE ZGATE_OUT-ZTRANS_NAME .

      MESSAGE 'Invalid Transporter Name' TYPE 'E' .
    ENDIF.
  ENDIF.


ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  ZVEH_NUM  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE ZVEH_NUM INPUT.


  DATA  LV_QR TYPE CHAR50.

  DATA(LV_STR) = STRLEN( LV_QR ).

  DATA(LV_COUNT) = STRLEN( ZGATE_OUT-ZVEH_NUM ).

  IF LV_COUNT LT 10.
    MESSAGE |Vehicle number is less than 10 characterstics.| TYPE 'E'.
  ENDIF.

ENDMODULE.
