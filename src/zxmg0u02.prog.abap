*&---------------------------------------------------------------------*
*&  Include           ZXMG0U02
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*
* OBJECT ID              :
* FUNCTIONAL ANALYST     :  ABHINAY GANDHE
* PROGRAMMER             :  RAUT SUNITA
* START DATE             :  12/04/2011
* INITIAL TRANSPORT NO   :
* DESCRIPTION            :  REPORT TO TAKE GRN TAGPRINT.
*----------------------------------------------------------------------*
* INCLUDES               :
* FUNCTION MODULES       : SO_NEW_DOCUMENT_SEND_API1,
*
* LOGICAL DATABASE       :
* TRANSACTION CODE       :
* EXTERNAL REFERENCES    :
*----------------------------------------------------------------------*
*                    MODIFICATION LOG
*----------------------------------------------------------------------*
* DATE      | MODIFIED BY   | CTS NUMBER   | COMMENTS
*----------------------------------------------------------------------*
*BREAK-POINT.

DATA:v_matnr TYPE matnr.
DATA:v_zeinr TYPE dzeinr.
DATA:text   TYPE string,
     text_1 TYPE string,
     text_2 TYPE string.

*WORK AREA DECLARATION FOR SENDING DOCUMENT DATA
DATA:wa_document_data  LIKE  sodocchgi1,
*WORK AREA DECLARATION FOR RECEIVING DOCUMENT DATA
     wa_receivers      LIKE somlreci1,
*IMPORTING PARAMETER.
     new_object_id     LIKE  sofolenti1-object_id,
*WORK AREA DECLARATION FOR MAIN BODY CONTENT.
     wa_object_content LIKE solisti1,
***********************************************************************
*INTERNAL TABLE DECLARATION FOR RECEIVING DOCUMENT DATA
     it_receivers      TYPE TABLE OF somlreci1,
*INTERNAL TABLEDECLARATION FOR MAIN BODY CONTENT.
     it_object_content TYPE TABLE OF solisti1.
***********************************************************************
SELECT SINGLE
matnr
zeinr
FROM mara
INTO (v_matnr,
      v_zeinr)
WHERE matnr = wmara-matnr.
SHIFT wmara-matnr LEFT DELETING LEADING '0'.
CONCATENATE 'THE DOCUMENT DETAILS FOR MATERIAL' wmara-matnr 'HAVE BEEN CHANGED.' INTO text SEPARATED BY space.
CONCATENATE 'OLD DOCUMENT NO :' v_zeinr INTO text_1 SEPARATED BY space.
CONCATENATE 'NEW DOCUMENT NO :' wmara-zeinr INTO text_2 SEPARATED BY space.
***********************************************************************
*POPULATING SUBJECT LINE.
wa_document_data-obj_descr ='DOCUMENT DETAILS CHANGED'.
*POPULATING MAIN BODY.
wa_object_content-line = text.
APPEND wa_object_content TO it_object_content.
wa_object_content-line = text_1.
APPEND wa_object_content TO it_object_content.
wa_object_content-line = text_2.
APPEND wa_object_content TO it_object_content.
CLEAR wa_object_content.
*ASSIGNNING RECEIVERI.I.E.TO WHOM TO SEND.
*WA_RECEIVERS-REC_TYPE = 'U'.
wa_receivers-receiver =  sy-uname.
APPEND wa_receivers TO it_receivers.
CLEAR wa_receivers.
***********************************************************************
IF wmara-zeinr <> v_zeinr.
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
  CLEAR: v_matnr,v_zeinr,text,text_1,text_2.
  CLEAR: wa_document_data,wa_object_content,wa_receivers.
  CLEAR: it_object_content,it_receivers,new_object_id.
ENDIF.
***********************************************************************
********TO GET DATA FOR USER FIELDS IN MM01
*****DATA : v_ser   TYPE mara-zseries,
*****       v_size  TYPE mara-zseries,
*****       v_brand TYPE mara-zseries,
*****       v_moc   TYPE mara-zseries,
*****       v_type  TYPE mara-zseries.
*****
*****IMPORT v_ser v_size v_brand v_moc v_type FROM MEMORY ID 'MM'.
*****
*****cmara-zseries = v_ser.
*****cmara-zsize   = v_size .
*****cmara-brand   = v_brand .
*****cmara-moc     = v_moc.
*****cmara-type    = v_type .

************************Added By Diksha Halve 31.01.2023*******************
*BREAK-POINT.
IF sy-tcode = 'MM02'.
  TYPES : BEGIN OF ty_mara1,
            matnr        TYPE mara-matnr,
            bom          TYPE mara-bom,
            zpen_item    TYPE mara-zpen_item,
            zre_pen_item TYPE mara-zre_pen_item,
          END OF ty_mara1.

  DATA : it_mara1 TYPE STANDARD TABLE OF ty_mara1,
         wa_mara1 TYPE ty_mara1.

  DATA : lv_pen_item TYPE mara-zpen_item.
  DATA : lv_re_pen_item TYPE mara-zre_pen_item.

  FIELD-SYMBOLS : <bom> TYPE any.
  ASSIGN ('(SAPLZMGD1)MARA-BOM') TO <bom>.

  FIELD-SYMBOLS : <pen_item> TYPE any.
  ASSIGN ('(SAPLZMGD1)MARA-ZPEN_ITEM') TO <pen_item>.

  FIELD-SYMBOLS : <re_pen_item> TYPE any.
  ASSIGN ('(SAPLZMGD1)MARA-ZRE_PEN_ITEM') TO <re_pen_item>.

  SELECT matnr
    bom
    zpen_item
    zre_pen_item
    FROM mara INTO TABLE it_mara1
    WHERE matnr = wmara-matnr.

  READ TABLE it_mara1 INTO wa_mara1 WITH KEY matnr = wmara-matnr.


*BREAK PRIMUS.
  IF <bom> IS NOT INITIAL.
    IF <pen_item> IS INITIAL OR <re_pen_item> IS INITIAL.
      MESSAGE 'Please fill in Pending item & Reason for pending item' TYPE 'E'.
    ENDIF.
  ENDIF.

*  BREAK-POINT.
  IF <bom> IS INITIAL.
    IF <pen_item> IS NOT INITIAL OR <re_pen_item> IS NOT INITIAL.
      MESSAGE 'Invalid entry' TYPE 'E'.
    ENDIF.
  ENDIF.

ENDIF.



*BREAK-POINT.
*------------------------commented by DH for Bom dependency TR release-----
*IF sy-tcode = 'MM02'.

*  TYPES : BEGIN OF ty_mara,
*            matnr   TYPE mara-matnr,
*            matkl   TYPE mara-matkl,
*            meins   TYPE mara-meins,
*            zseries TYPE mara-zseries,
*            zsize   TYPE mara-zsize,
*            brand   TYPE mara-brand,
*            type    TYPE mara-type,
*            moc     TYPE mara-moc,
*            zeinr   TYPE mara-zeinr,
*            zeivr   TYPE mara-zeivr,
*            tragr   TYPE mara-tragr,
*          END OF ty_mara.
*
*  TYPES : BEGIN OF ty_marc,
*            matnr TYPE marc-matnr,
*            mtvfp TYPE marc-mtvfp,
*            ladgr TYPE marc-ladgr,
*            prctr TYPE marc-prctr,
*            ekgrp TYPE marc-ekgrp,
*            dismm TYPE marc-dismm,
*            dispo TYPE marc-dispo,
*            disls TYPE marc-disls,
*            beskz TYPE marc-beskz,
*            fhori TYPE marc-fhori,
*            ssqss TYPE marc-ssqss,
*          END OF ty_marc.
*
*  TYPES : BEGIN OF ty_mbew,
*            matnr TYPE mbew-matnr,
*            bklas TYPE mbew-bklas,
*            vprsv TYPE mbew-vprsv,
*            verpr TYPE mbew-verpr,
*            stprs TYPE mbew-stprs,
*          END OF ty_mbew.
*
*  TYPES : BEGIN OF ty_final,
*            matnr   TYPE mara-matnr,
*            matkl   TYPE mara-matkl,
*            meins   TYPE mara-meins,
*            zseries TYPE mara-zseries,
*            zsize   TYPE mara-zsize,
*            brand   TYPE mara-brand,
*            type    TYPE mara-type,
*            moc     TYPE mara-moc,
*            zeinr   TYPE mara-zeinr,
*            zeivr   TYPE mara-zeivr,
*            tragr   TYPE mara-tragr,
*
*            mtvfp   TYPE marc-mtvfp,
*            ladgr   TYPE marc-ladgr,
*            prctr   TYPE marc-prctr,
*            ekgrp   TYPE marc-ekgrp,
*            dismm   TYPE marc-dismm,
*            dispo   TYPE marc-dispo,
*            disls   TYPE marc-disls,
*            beskz   TYPE marc-beskz,
*            fhori   TYPE marc-fhori,
*            ssqss   TYPE marc-ssqss,
*
*            bklas   TYPE mbew-bklas,
*            vprsv   TYPE mbew-vprsv,
**            verpr   TYPE mbew-verpr,
*            verpr   TYPE string,
**            stprs   TYPE mbew-stprs,
*            stprs   TYPE string,
*          END OF ty_final.
*
*  DATA : it_final TYPE STANDARD TABLE OF ty_final,
*         wa_final TYPE ty_final.
*
*  DATA : it_mbew TYPE STANDARD TABLE OF ty_mbew,
*         wa_mbew TYPE ty_mbew.
*
*  DATA : it_marc TYPE STANDARD TABLE OF ty_marc,
*         wa_marc TYPE ty_marc.
*
*  DATA : it_mara TYPE STANDARD TABLE OF ty_mara,
*         wa_mara TYPE ty_mara.
*
*  FIELD-SYMBOLS : <moc> TYPE mara-moc.
*  ASSIGN ('(SAPLZMGD1)MARA-MOC') TO <moc>.
*
*  SELECT matnr
*         matkl
*         meins
*         zseries
*         zsize
*         brand
*         type
*         moc
*         zeinr
*         zeivr
*         tragr
*    FROM mara INTO TABLE it_mara
*    WHERE matnr = wmara-matnr.
*
*  SELECT matnr
*         mtvfp
*         ladgr
*         prctr
*         ekgrp
*         dismm
*         dispo
*         disls
*         beskz
*         fhori
*         ssqss
*    FROM marc INTO TABLE it_marc
*    FOR ALL ENTRIES IN it_mara
*    WHERE matnr = it_mara-matnr.
*
*  SELECT matnr
*         bklas
*         vprsv
*         verpr
*         stprs
*    FROM mbew INTO TABLE it_mbew
*    FOR ALL ENTRIES IN it_mara
*    WHERE matnr = it_mara-matnr.
*
*
*  LOOP AT it_mara INTO wa_mara.
*
*    wa_final-matnr = wa_mara-matnr.
*    wa_final-matkl = wa_mara-matkl.
*    wa_final-meins = wa_mara-meins.
*    wa_final-zseries = wa_mara-zseries.
*    wa_final-zsize = wa_mara-zsize.
*    wa_final-brand = wa_mara-brand.
*    wa_final-type = wa_mara-type.
**  wa_final-moc = wa_mara-moc.
*    wa_final-moc = <moc>.
*    wa_final-zeinr = wa_mara-zeinr.
*    wa_final-zeivr = wa_mara-zeivr.
*    wa_final-tragr = wa_mara-tragr.
*
*    READ TABLE it_marc INTO wa_marc WITH KEY matnr = wa_mara-matnr.
*    wa_final-mtvfp = wa_marc-mtvfp.
*    wa_final-ladgr = wa_marc-ladgr.
*    wa_final-prctr = wa_marc-prctr.
*    wa_final-ekgrp = wa_marc-ekgrp.
*    wa_final-dismm = wa_marc-dismm.
*    wa_final-dispo = wa_marc-dispo.
*    wa_final-disls = wa_marc-disls.
*    wa_final-beskz = wa_marc-beskz.
*    wa_final-fhori = wa_marc-fhori.
*    wa_final-ssqss = wa_marc-ssqss.
*
*    READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mara-matnr.
*    wa_final-bklas = wa_mbew-bklas.
*    wa_final-vprsv = wa_mbew-vprsv.
*    wa_final-verpr = wa_mbew-verpr.
*    wa_final-stprs = wa_mbew-stprs.
*
*    APPEND wa_final TO it_final.
*    CLEAR wa_final.
*  ENDLOOP.
*
*  DATA : lv_date  TYPE sy-datum,
*         lv_time  TYPE sy-uzeit,
*         lv_dt    TYPE string,
*         lv_temp  TYPE string,
*         lv_title TYPE string.
*
**  DATA : line(400) TYPE c.
*  DATA : line TYPE string.
*
**  data : line TYPE string.
*
*
*  lv_date = sy-datum.
*  lv_time = sy-uzeit.
*  CONCATENATE sy-datum sy-uzeit INTO lv_dt.
*
*  CONCATENATE 'products_updates' lv_dt '.txt' INTO lv_temp SEPARATED BY '_'.
*
**  CONCATENATE 'E:\Delval\Mindglow\Masters\Custom\' lv_temp INTO lv_title.
*
*  CONCATENATE 'E:\Delval\Mindglow\Masters\Material\' lv_temp INTO lv_title.
*
*
**  IF wa_final-mandt = '020' OR wa_final-mandt = '050' OR wa_final-mandt = '060'.
*
*  OPEN DATASET lv_title FOR OUTPUT IN BINARY MODE.
*
*  CONCATENATE 'Material No.'
*              'EXT. MAT. GRP'
*              'Basic UoM'
*              'SERIES'
*              'SIZE'
*              'Brand'
*              'Type'
*              'MOC'
*              'Drawing No.'
*              'Revision No.'
*              'Transportation Group'
*              'Checking Group for Availability Check'
*              'Loading Group'
*              'Profit Centre'
*              'Purchasing Group'
*              'MRP Type'
*              'MRP Controler'
*              'Lot Size'
*              'Procurement Type'
*              'SCHED Margin Key'
*              'QM Control Key'
*              'Valuation Class'
*              'Price Control'
*              'Moving Price'
*              'Standard Price'
*              INTO line SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
*  CONCATENATE line cl_abap_char_utilities=>newline INTO line.
*  TRANSFER line TO lv_title.   "LENGTH 400.
*
*  LOOP AT it_final INTO wa_final.
*
*    CONCATENATE wa_final-matnr
*                wa_final-matkl
*                wa_final-meins
*                wa_final-zseries
*                wa_final-zsize
*                wa_final-brand
*                wa_final-type
*                wa_final-moc
*                wa_final-zeinr
*                wa_final-zeivr
*                wa_final-tragr
*                wa_final-mtvfp
*                wa_final-ladgr
*                wa_final-prctr
*                wa_final-ekgrp
*                wa_final-dismm
*                wa_final-dispo
*                wa_final-disls
*                wa_final-beskz
*                wa_final-fhori
*                wa_final-ssqss
*                wa_final-bklas
*                wa_final-vprsv
*                wa_final-verpr
*                wa_final-stprs
*              INTO line SEPARATED BY cl_abap_char_utilities=>horizontal_tab.
*
*    TRANSFER line TO lv_title.   "LENGTH 400.
*  ENDLOOP.
*  CLOSE DATASET lv_title.
*    ENDIF.
*ENDIF.
*********************End of Addition by Diksha Halve**********************
*-----------------------------------------------------------end of comment-----------
