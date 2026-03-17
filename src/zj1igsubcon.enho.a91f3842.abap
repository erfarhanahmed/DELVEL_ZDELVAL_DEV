"Name: \PR:J_1IG_SUBCON\FO:GET_PRICE\SE:END\EI
ENHANCEMENT 0 ZJ1IGSUBCON.
*


*IF sy-ucomm = '&CLN'.
  DATA : msg TYPE string,
         msg1 TYPE string,
         jocg TYPE string,
         josg TYPE string,
         joig TYPE string.
DATA : lv_region TYPE kna1-regio.

SELECT SINGLE regio INTO lv_region FROM kna1 WHERE kunnr = ls_spr-kunnr.

CONCATENATE 'ZPR0 is Maintained Price is 0' p_wa_grxsub-matnr INTO msg SEPARATED BY space.
CONCATENATE 'ZPR0 is not Maintained' p_wa_grxsub-matnr INTO msg1 SEPARATED BY space.
  IF p_lv_kschl = 'ZPR0' and p_lv_kbetr = 0.
    MESSAGE msg TYPE 'E'.
  ENDIF.


  IF p_lv_kschl NE 'ZPR0'." and p_lv_kbetr = 0.
    MESSAGE msg1 TYPE 'E'.
  ENDIF.

DATA:it_cond TYPE STANDARD TABLE OF komv,
     wa_cond TYPE komv.

CALL FUNCTION 'PRICING'
    EXPORTING
      calculation_type = 'C'
      comm_head_i      = ls_komk
      comm_item_i      = ls_komp
*     PRELIMINARY      = ' '
*     NO_CALCULATION   = ' '
*     IV_NO_MESSAGE_COLLECT_LORD       = ' '
* IMPORTING
*     COMM_HEAD_E      =
*     COMM_ITEM_E      =
    TABLES
      tkomv            = it_cond
*     SVBAP            =
* CHANGING
*     REBATE_DETERMINED                = ' '
    .
BREAK primus.
CONCATENATE 'JOCG Not Maintain' p_wa_grxsub-matnr INTO jocg SEPARATED BY space.
CONCATENATE 'JOSG Not Maintain' p_wa_grxsub-matnr INTO josg SEPARATED BY space.
CONCATENATE 'JOIG Not Maintain' p_wa_grxsub-matnr INTO joig SEPARATED BY space.
IF lv_region = '13'.

READ TABLE it_cond INTO wa_cond WITH KEY kschl = 'JOCG'.
  IF sy-subrc = 4.
    MESSAGE jocg TYPE 'E'.
  ENDIF.

READ TABLE it_cond INTO wa_cond WITH KEY kschl = 'JOSG'.
  IF sy-subrc = 4.
    MESSAGE josg TYPE 'E'.
  ENDIF.

ELSE.

  READ TABLE it_cond INTO wa_cond WITH KEY kschl = 'JOIG'.
  IF sy-subrc = 4.
    MESSAGE joig TYPE 'E'.
  ENDIF.

ENDIF.

REFRESH it_cond.
*ENDIF.
ENDENHANCEMENT.
