"Name: \PR:SAPMV45A\FO:USEREXIT_SAVE_DOCUMENT\SE:BEGIN\EI
ENHANCEMENT 0 ZSD_SO_SAVE.
*

*>> Send mail on SO change, status update
DATA: lv_txt1 TYPE string,
      lv_txt2 TYPE string,
      lv_txt3 TYPE string,
      lv_txt4 TYPE string,
      lv_txt5 TYPE string.
*WORK AREA DECLARATION FOR SENDING DOCUMENT DATA
DATA: wa_document_data   LIKE  sodocchgi1,
      wa_document_data1  LIKE  sodocchgi1,
*WORK AREA DECLARATION FOR RECEIVING DOCUMENT DATA
      wa_receivers       LIKE somlreci1,
      wa_receivers1      LIKE somlreci1,
*IMPORTING PARAMETER.
      new_object_id      LIKE  sofolenti1-object_id,
      new_object_id1     LIKE  sofolenti1-object_id,
*WORK AREA DECLARATION FOR MAIN BODY CONTENT.
      wa_object_content  LIKE solisti1,
      wa_object_content1 LIKE solisti1,
***********************************************************************
*INTERNAL TABLE DECLARATION FOR RECEIVING DOCUMENT DATA
      it_receivers       TYPE TABLE OF somlreci1,
      it_receivers1      TYPE TABLE OF somlreci1,
*INTERNAL TABLEDECLARATION FOR MAIN BODY CONTENT.
      it_object_content  TYPE TABLE OF solisti1,
      it_object_content1 TYPE TABLE OF solisti1.
***********************************************************************
IF rv45a-asttx = 'TERC'
  OR rv45a-asttx = 'CMRC'.

  SHIFT vbak-vbeln LEFT DELETING LEADING '0'.
  CONCATENATE 'SALES ORDER' vbak-vbeln 'IS CHANGED BY' sy-uname 'ON' sy-datum INTO lv_txt1 SEPARATED BY space.

*POPULATING SUBJECT LINE.
  wa_document_data-obj_descr ='SALES ORDER CHANGED'.
*POPULATING MAIN BODY.
  wa_object_content-line = lv_txt1.
  APPEND wa_object_content TO it_object_content.
  CLEAR wa_object_content.
*ASSIGNNING RECEIVERI I.E.TO WHOM TO SEND.
*WA_RECEIVERS-REC_TYPE = 'U'.
  wa_receivers-receiver =  sy-uname."V_SMTP_ADDR.
  APPEND wa_receivers TO it_receivers.
  CLEAR wa_receivers.
***********************************************************************
  CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = wa_document_data
    IMPORTING
      new_object_id              = new_object_id
    TABLES
      object_content             = it_object_content
      receivers                  = it_receivers
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7.
  CLEAR: wa_document_data,wa_object_content,wa_receivers,lv_txt1.
  CLEAR: it_object_content,it_receivers,new_object_id.
ENDIF.
***********************************************************************
IF rv45a-asttx = 'UHLD'.
  lv_txt4 = 'UNHOLD'.
  UPDATE vbap SET abgru = ' ' WHERE vbeln = vbak-vbeln AND posnr = rv45a-uepos.
  UPDATE vbap SET holdreldate = sy-datum WHERE vbeln = vbak-vbeln AND posnr = rv45a-uepos.
  UPDATE vbap SET cancelreldate = sy-datum WHERE vbeln = vbak-vbeln AND posnr = rv45a-uepos.
ELSEIF rv45a-asttx = 'HOLD'.
  lv_txt4 = 'HOLD'.
  UPDATE vbap SET abgru = '12' WHERE vbeln = vbak-vbeln AND posnr = rv45a-uepos.
  UPDATE vbap SET holddate = sy-datum WHERE vbeln = vbak-vbeln AND posnr = rv45a-uepos.
ELSEIF rv45a-asttx = 'CANL'.
  lv_txt4 = 'CANCEL'.
  UPDATE vbap SET abgru = '13' WHERE vbeln = vbak-vbeln AND posnr = rv45a-uepos.
  UPDATE vbap SET canceldate = sy-datum WHERE vbeln = vbak-vbeln AND posnr = rv45a-uepos.
ENDIF.

IF rv45a-asttx = 'HOLD'
  OR rv45a-asttx = 'CANL'
  OR ( rv45a-asttx = 'UHLD').

  IF rv45a-asttx = 'UHLD'.
    lv_txt5 = 'UHLD'.
  ENDIF.

  SHIFT vbak-vbeln LEFT DELETING LEADING '0'.
  CONCATENATE 'STATUS OF THE SALES ORDER NO.' vbak-vbeln 'HAS BEEN CHANGED ON' sy-datum INTO lv_txt2 SEPARATED BY space.
  CONCATENATE 'MATERIAL NUMBER :' rv45a-mabnr INTO lv_txt3 SEPARATED BY space.
  CONCATENATE 'STATUS CHANGED TO :' lv_txt4 INTO lv_txt5 SEPARATED BY space.

***POPULATING SUBJECT LINE.
  wa_document_data1-obj_descr = lv_txt2.

***POPULATING MAIN BODY.
  wa_object_content1-line = lv_txt3.
  APPEND wa_object_content1 TO it_object_content1.
  wa_object_content1-line = lv_txt5.
  APPEND wa_object_content1 TO it_object_content1.

  CLEAR wa_object_content1.
***ASSIGNNING RECEIVERI.E.TO WHOM TO SEND.
***WA_RECEIVERS-REC_TYPE = 'U'.
  wa_receivers1-receiver =  sy-uname."V_SMTP_ADDR.
  APPEND wa_receivers1 TO it_receivers1.
  CLEAR wa_receivers1.
***********************************************************************
  CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
    EXPORTING
      document_data              = wa_document_data1
    IMPORTING
      new_object_id              = new_object_id1
    TABLES
      object_content             = it_object_content1
      receivers                  = it_receivers1
    EXCEPTIONS
      too_many_receivers         = 1
      document_not_sent          = 2
      document_type_not_exist    = 3
      operation_no_authorization = 4
      parameter_error            = 5
      x_error                    = 6
      enqueue_error              = 7.
  CLEAR: wa_document_data1,wa_object_content1,wa_receivers1,lv_txt2,lv_txt3,lv_txt4,lv_txt5.
  CLEAR: it_object_content1,it_receivers1,new_object_id1.

ENDIF.
***********************************************************************
TYPES: BEGIN OF t_mska,
         vbeln TYPE mska-vbeln,
         posnr TYPE mska-posnr,
         matnr TYPE mska-matnr,
         sobkz TYPE mska-sobkz,
         kalab TYPE mska-kalab,
         kains TYPE mska-kains,
         kaspe TYPE mska-kaspe,
       END OF t_mska.

DATA: it_mska TYPE STANDARD TABLE OF t_mska,
      wa_mska TYPE t_mska.
DATA: lv_qty_total TYPE mska-kalab,
      lv_count     TYPE i.
*IF ( ( VBAP-ABGRU IS NOT INITIAL ) AND ( VBAP-ABGRU NE '12') AND  ( VBAP-ABGRU  NE '13' ) ).
IF rv45a-asttx = 'CANL'.
  SELECT vbeln posnr matnr sobkz kalab kains kaspe
    FROM mska
    INTO TABLE it_mska
    WHERE vbeln = vbap-vbeln
      AND posnr = vbap-posnr
      AND matnr = vbap-matnr
      AND sobkz = vbap-sobkz.

  LOOP AT it_mska INTO wa_mska.
    lv_qty_total = wa_mska-kalab + wa_mska-kains + wa_mska-kaspe.
    IF lv_qty_total > 0.
      MESSAGE e006(zdel) WITH vbap-vbeln vbap-posnr.
    ENDIF.
  ENDLOOP.
  CLEAR: wa_mska,lv_qty_total.
ENDIF.
***********************************************************************
IF ( vbap-abgru EQ '12' OR  vbap-abgru  EQ '13'  ).
  MESSAGE e022(zdel) .
ENDIF.
***********************************************************************
ENDENHANCEMENT.
