*&---------------------------------------------------------------------*
*&  Include           ZGATEOUT_DELETE_DATA
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

   CASE ABAP_TRUE.
    WHEN ABAP_TRUE.
      PERFORM DISPLAY_ENTRY.
      CALL SCREEN 0101.

  ENDCASE.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ENTRY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_entry .

   select single max( ZSER_NO ) from ZGATE_OUT into @DATA(lv_sr) where ZNUMBER_01 = @P_NUMBER.

 DATA(lv_sr1) = lv_sr.

SELECT SINGLE ZV_DATE
                ZVEH_NUM
                ZOUT_TIME
                ZOUT_DATE
            max( zser_no )
                ZV_DRIVER_NAME
                ZTRANS_NAME
                ZINVOICE_NO
                ZCRETED_BY
                ZV_REMARK
                ZNUMBER_01
                ZSEC_NAME
                ZCHANGE_REMARK
                zrefe_no
                        FROM ZGATE_OUT INTO CORRESPONDING FIELDS OF ZGATE_OUT
                WHERE ZNUMBER_01 EQ P_NUMBER
                and ZSER_NO = lv_sr1
                GROUP BY ZV_DATE ZVEH_NUM ZOUT_TIME ZOUT_DATE zser_no ZV_DRIVER_NAME ZTRANS_NAME ZINVOICE_NO ZCRETED_BY
                ZV_REMARK ZNUMBER_01 ZSEC_NAME ZCHANGE_REMARK zrefe_no.



  WA_MPP-ZV_DATE         = ZGATE_OUT-ZV_DATE.
  WA_MPP-ZVEH_NUM        = ZGATE_OUT-ZVEH_NUM.
  WA_MPP-ZOUT_TIME       = ZGATE_OUT-ZOUT_TIME.
  WA_MPP-ZOUT_DATE       = ZGATE_OUT-ZOUT_DATE.
  WA_MPP-ZV_DRIVER_NAME  = ZGATE_OUT-ZV_DRIVER_NAME.
  WA_MPP-ZTRANS_NAME     = ZGATE_OUT-ZTRANS_NAME.
*  WA_MPP-ZINVOICE_NO     = ZGATE_OUT-ZINVOICE_NO.
  WA_MPP-ZCRETED_BY      = ZGATE_OUT-ZCRETED_BY.
  WA_MPP-ZV_REMARK       = ZGATE_OUT-ZV_REMARK.
  WA_MPP-ZNUMBER_01      = ZGATE_OUT-ZNUMBER_01.
  WA_MPP-ZSEC_NAME       = ZGATE_OUT-ZSEC_NAME.
  WA_MPP-ZCHANGE_REMARK  = ZGATE_OUT-zchange_remark.
  WA_MPP-zrefe_no        = ZGATE_OUT-zrefe_no.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DELETE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM delete_data .

  select single max( ZSER_NO ) from ZGATE_OUT into @DATA(lv_sr) where ZNUMBER_01 = @P_NUMBER.

     DATA(lv_sr1) = lv_sr.

  SELECT SINGLE ZV_DATE
                ZVEH_NUM
                ZOUT_TIME
                ZOUT_DATE
            max( zser_no )
                ZV_DRIVER_NAME
                ZTRANS_NAME
                ZINVOICE_NO
                ZCRETED_BY
                ZV_REMARK
                ZNUMBER_01
                ZSEC_NAME
                ZCHANGE_REMARK FROM ZGATE_OUT INTO CORRESPONDING FIELDS OF ZGATE_OUT
                WHERE ZNUMBER_01 EQ P_NUMBER
                and ZSER_NO = lv_sr1
                GROUP BY ZV_DATE ZVEH_NUM ZOUT_TIME ZOUT_DATE zser_no ZV_DRIVER_NAME ZTRANS_NAME ZINVOICE_NO ZCRETED_BY
                ZV_REMARK ZNUMBER_01 ZSEC_NAME ZCHANGE_REMARK .

  ZGATE_OUT-zdelete_ind = 'X'.

  WA_MPP-zdelete_ind  = ZGATE_OUT-zdelete_ind.

  UPDATE ZGATE_OUT
  SET zdelete_ind = 'X'
  WHERE ZNUMBER_01 EQ P_NUMBER.

    ZGATE_OUT-zdelete_date = sy-datum.
    ZGATE_OUT-zdelete_name = sy-uname.
    ZGATE_OUT-zdelete_time = sy-uzeit.

    modify ZGATE_OUT from ZGATE_OUT .
  commit work and wait.

IF  SY-SUBRC IS INITIAL .

  MESSAGE |Delete entry Successfully : | && ZGATE_OUT-ZNUMBER_01 TYPE 'S'.

ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Module  ZNUMBER_01  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
