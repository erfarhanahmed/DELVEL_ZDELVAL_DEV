*&---------------------------------------------------------------------*
*&  Include           ZGATEOUT_DELETE_TOP
*&---------------------------------------------------------------------*

TYPES : BEGIN OF TY_MPP,
          ZV_DATE        TYPE  ZGATE_OUT-ZV_DATE,
          ZVEH_NUM       TYPE  ZGATE_OUT-ZVEH_NUM,
          ZOUT_TIME      TYPE  ZGATE_OUT-ZOUT_TIME,
          ZOUT_DATE      TYPE  ZGATE_OUT-ZOUT_DATE,
          ZV_DRIVER_NAME TYPE  ZGATE_OUT-ZV_DRIVER_NAME,
          ZTRANS_NAME    TYPE  ZGATE_OUT-ZTRANS_NAME,
          ZINVOICE_NO    TYPE  ZGATE_OUT-ZINVOICE_NO,
          ZCRETED_BY     TYPE  ZGATE_OUT-ZCRETED_BY,
          ZV_REMARK      TYPE  ZGATE_OUT-ZV_REMARK,
          ZNUMBER_01     TYPE  ZGATE_OUT-ZNUMBER_01,
          ZSEC_NAME      TYPE  ZGATE_OUT-ZSEC_NAME,
          ZCHANGE_REMARK TYPE  ZGATE_OUT-ZCHANGE_REMARK,
          zdelete_ind    TYPE  ZGATE_OUT-zdelete_ind,
          zrefe_no       TYPE  ZGATE_OUT-zrefe_no,
        END OF TY_MPP.

DATA : IT_MPP TYPE TABLE OF TY_MPP,
       WA_MPP TYPE TY_MPP.
