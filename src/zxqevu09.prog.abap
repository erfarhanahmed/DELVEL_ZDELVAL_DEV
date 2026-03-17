*&---------------------------------------------------------------------*
*&  Include           ZXQEVU09
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*
* OBJECT ID              :
* FUNCTIONAL ANALYST     :  ABHINAY GANDHE
* PROGRAMMER             :  RAUT SUNITA
* START DATE             :  12/04/2011
* INITIAL TRANSPORT NO   :
* DESCRIPTION            :  TO CHECK INSPECTION QUANTITY.
*----------------------------------------------------------------------*
* INCLUDES               :
* FUNCTION MODULES       :
*
* LOGICAL DATABASE       :
* TRANSACTION CODE       :
* EXTERNAL REFERENCES    :
*----------------------------------------------------------------------*
*                    MODIFICATION LOG
*----------------------------------------------------------------------*
* DATE      | MODIFIED BY   | CTS NUMBER   | COMMENTS
*----------------------------------------------------------------------*

TYPES: BEGIN OF ty_ekko,
         ebeln LIKE ekko-ebeln,
         ekgrp LIKE ekko-ekgrp,
       END OF ty_ekko.

TYPES: BEGIN OF ty_t024,
         ekgrp     LIKE t024-ekgrp,
         smtp_addr LIKE t024-smtp_addr,
       END OF ty_t024.

DATA: v_ebeln     LIKE ekko-ebeln,
      v_ekgrp     LIKE ekko-ekgrp,
      v_smtp_addr LIKE t024-smtp_addr.
DATA:text_1   TYPE string,
     text_2   TYPE string,
     text_3   TYPE string,
     text_4   TYPE string,
     text_5   TYPE string,
     text_6   TYPE string,
     text_7   TYPE string,
     text_8   TYPE string,
     text_9   TYPE string,
     v_rejqty TYPE char18.
***********************************************************************
DATA : l_clint  LIKE sy-mandt,
       l_id     LIKE thead-tdid,
       l_lang   LIKE thead-tdspras,
       l_name   LIKE thead-tdname,
       l_object LIKE thead-tdobject,
       l_lines  LIKE tline OCCURS 0 WITH HEADER LINE.
***********************************************************************
DATA:it_ekko TYPE STANDARD TABLE OF ty_ekko,
     wa_ekko TYPE ty_ekko,
     it_t024 TYPE STANDARD TABLE OF ty_t024,
     wa_t024 TYPE ty_t024.
*WORK AREA DECLARATION FOR SENDING DOCUMENT DATA
DATA:wa_document_data  LIKE  sodocchgi1,
*WORK AREA DECLARATION FOR RECEIVING DOCUMENT DATA
     wa_receivers      LIKE somlreci1,
*IMPORTING PARAMETER.
     new_object_id
      LIKE  sofolenti1-object_id,
*WORK AREA DECLARATION FOR MAIN BODY CONTENT.
     wa_object_content LIKE solisti1,
***********************************************************************
*INTERNAL TABLE DECLARATION FOR RECEIVING DOCUMENT DATA
     it_receivers      TYPE TABLE OF somlreci1,
*INTERNAL TABLEDECLARATION FOR MAIN BODY CONTENT.
     it_object_content TYPE TABLE OF solisti1.
***********************************************************************
*IF NOT I_QALS-LMENGE04 IS INITIAL.
IF ( i_rqeva-vmenge01 IS NOT INITIAL ) AND " entred qty <> 0
   ( i_rqeva-qlgo_vm01 = 'RJ01' OR
   i_rqeva-qlgo_vm01 = 'RWK1' OR
   i_rqeva-qlgo_vm01 = 'SCR1' OR
   i_rqeva-qlgo_vm01 = 'SRN1' ) .

****SELECTING USER
  SELECT SINGLE
  ebeln
  ekgrp
  INTO (v_ebeln,
         v_ekgrp)
  FROM ekko
  WHERE ebeln = i_qals-ebeln.

  IF sy-subrc = 0.
    SELECT SINGLE
    ekgrp
    smtp_addr
    INTO (v_ekgrp,
           v_smtp_addr)
    FROM t024
    WHERE ekgrp = v_ekgrp.
  ENDIF.

*  V_REJQTY = I_QALS-LMENGE04.
*  v_rejqty = i_qals-lmenge01.
  v_rejqty = i_rqeva-vmenge01.
  CONDENSE v_rejqty.

********reading text for rejection reason
  CLEAR: l_id, l_lang, l_name, l_object, l_clint.

  l_clint = sy-mandt.
  l_lang = 'E'.
  l_id = 'QAVE'.
  l_object = 'QPRUEFLOS'.

  CONCATENATE sy-mandt i_qals-prueflos 'L' INTO l_name .

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
      client                  = l_clint
      id                      = l_id
      language                = l_lang
      name                    = l_name
      object                  = l_object
    TABLES
      lines                   = l_lines
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
  ENDIF.



  SHIFT i_qals-prueflos LEFT DELETING LEADING '0'.
  SHIFT i_qals-lifnr LEFT DELETING LEADING '0'.
  SHIFT i_qals-matnr LEFT DELETING LEADING '0'.

  CONCATENATE 'GRN NO. :' i_qals-mblnr INTO text_1 SEPARATED BY space.
  CONCATENATE 'PURCHASE ORDER NO. :' i_qals-ebeln INTO text_2 SEPARATED BY space.
  CONCATENATE 'INSPECTION LOT NO. :' i_qals-prueflos INTO text_3 SEPARATED BY space.
  CONCATENATE 'VENDOR :' i_qals-lifnr INTO text_4 SEPARATED BY space.
  CONCATENATE 'MATERIAL :' i_qals-matnr INTO text_5 SEPARATED BY space.
  CONCATENATE 'PLANT :' i_qals-werk INTO text_6 SEPARATED BY space.
*  CONCATENATE 'QUANTITY REJECTED :' v_rejqty i_qals-mengeneinh 'TO' i_rqeva-qlgo_vm01 INTO text_7 SEPARATED BY space.
  CONCATENATE 'QUANTITY REJECTED :' v_rejqty i_qals-mengeneinh 'TO' i_rqeva-qlgo_vm01 INTO text_7 SEPARATED BY space.

  text_8 = 'REMARK:'.



*POPULATING SUBJECT LINE.
  wa_document_data-obj_descr ='NOTIFICATION FOR GRN REJECTION'.
*POPULATING MAIN BODY.
  wa_object_content-line = 'DETAILS ARE AS BELOW:'.
  APPEND wa_object_content TO it_object_content.

  wa_object_content-line = text_1.
  APPEND wa_object_content TO it_object_content.

  wa_object_content-line = text_2.
  APPEND wa_object_content TO it_object_content.

  wa_object_content-line = text_3.
  APPEND wa_object_content TO it_object_content.

  wa_object_content-line = text_4.
  APPEND wa_object_content TO it_object_content.

  wa_object_content-line = text_5.
  APPEND wa_object_content TO it_object_content.

  wa_object_content-line = text_6.
  APPEND wa_object_content TO it_object_content.

  wa_object_content-line = text_7.
  APPEND wa_object_content TO it_object_content.

  wa_object_content-line = text_8.
  APPEND wa_object_content TO it_object_content.

*MOVE REJECTION REASON TO MAIL BODY
  LOOP AT l_lines.
    text_9 = l_lines-tdline .
    wa_object_content-line = text_9.
    APPEND wa_object_content TO it_object_content.
  ENDLOOP.


  CLEAR wa_object_content.
*ASSIGNNING RECEIVER I.E.TO WHOM TO SEND.
  wa_receivers-rec_type = 'U'.
  wa_receivers-receiver =  sy-uname."V_SMTP_ADDR.
  wa_receivers-rec_type = 'C'.
  wa_receivers-receiver =  'QM001'."Distribution list
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
  CLEAR: v_ebeln, v_ekgrp,v_smtp_addr,text_1,text_2,text_3,text_4,text_5,text_6,text_7.
  CLEAR: wa_document_data,wa_object_content,wa_receivers,wa_ekko,wa_t024.
  CLEAR: it_object_content,it_receivers,it_ekko,it_t024,new_object_id.
ENDIF.

*************ADDED BY SR ON 30.04.2021************
*break primus.
*CLEAR sy-subrc.
*DATA: lv_id TYPE icon-id.
*TABLES: icon.
*
*IF i_qals-werk = 'PL01' AND ( i_qals-art = '01' OR
*                              i_qals-art = '04' OR
*                              i_qals-art = '08' ) .
**  IF i_rqeva-vmenge01 = '0.000'.
*  IF i_rqeva-vmenge01 IS INITIAL.
**    MESSAGE 'Quantity is not posted to Unrestricted Stock' TYPE 'E'." DISPLAY LIKE 'E'.
*    SELECT SINGLE id FROM icon INTO lv_id WHERE name = 'ICON_MESSAGE_ERROR'.
*
*    CALL FUNCTION 'POPUP_TO_INFORM'
*      EXPORTING
*        titel = 'Error'
*        txt1  = lv_id
*        txt2  = 'Quantity is not posted to Unrestricted Stock'.
*
*    LEAVE TO SCREEN 0.
*
*  ENDIF.
*ENDIF.

***********ENDED BY SR ON 30.04.2021******************
