*&---------------------------------------------------------------------*
*& Report ZVENDOR_INFO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvendor_info.

*********************************** Tables **************************************

TABLES eina ##needed.
TABLES eine ##needed.
TYPE-POOLS : slis.
*********************************** Types *************************************
TYPES : BEGIN OF ty_eine,
          infnr TYPE eine-infnr,
          ekorg TYPE eine-ekorg,
          esokz TYPE eine-esokz,
          werks TYPE eine-werks,
          ekgrp TYPE eine-ekgrp,
          bstyp TYPE eine-bstyp,
          netpr TYPE eine-netpr,
          mwskz TYPE eine-mwskz,
          norbm TYPE eine-norbm,
          minbm TYPE eine-minbm,
          loekz TYPE eine-loekz,  "ADDED BY VS ON 06/07/20
        END OF ty_eine,

        BEGIN OF ty_eina,
          infnr TYPE eina-infnr,
          matnr TYPE eina-matnr,
          lifnr TYPE eina-lifnr,
          erdat TYPE eina-erdat,
          loekz TYPE eina-loekz,
          idnlf TYPE eina-idnlf,

        END OF ty_eina,

        BEGIN OF ty_a017,
          lifnr TYPE a017-lifnr,
          matnr TYPE a017-matnr,
          werks TYPE a017-werks,
          esokz TYPE a017-esokz,
          datbi TYPE a017-datbi,
          datab TYPE a017-datab,
          knumh TYPE a017-knumh,
        END OF ty_a017,

        BEGIN OF ty_lfa1,
          lifnr TYPE lfa1-lifnr,
          name1 TYPE lfa1-name1,
          name2 TYPE lfa1-name2,
        END OF ty_lfa1,

        BEGIN OF ty_makt,
          matnr TYPE makt-matnr,
          spras TYPE makt-spras,
          maktx TYPE makt-maktx,
        END OF ty_makt,

*--paresh workbench---material---------------------------------------------------------------*
        BEGIN OF ty_mara,
          matnr   TYPE mara-matnr,
          zseries TYPE mara-zseries,
          zsize   TYPE mara-zsize,
          brand   TYPE mara-brand,
          moc     TYPE mara-moc,
          type    TYPE mara-type,
        END OF ty_mara,
*--------------------------------------------------------------------*
        BEGIN OF ty_konp,
          knumh TYPE konp-knumh,
          kopos TYPE konp-kopos,
          mxwrt TYPE konp-mxwrt,
          gkwrt TYPE konp-gkwrt,
*--------------------------------------------------------------------*paresh workbench
          kbetr TYPE konp-kbetr,                                    "passing this field into netprice.
*--------------------------------------------------------------------*
        END OF ty_konp,

        BEGIN OF ty_final,
          ekorg   TYPE eine-ekorg,
          infnr   TYPE eina-infnr,
          esokz   TYPE eine-esokz,
          lifnr   TYPE eina-lifnr,
          erdat   TYPE eina-erdat,
          loekz1 TYPE eine-loekz,    "ADDED BY VS ON 06/07/20
          name1   TYPE lfa1-name1,
          matnr   TYPE eina-matnr,
          maktx   TYPE makt-maktx,
          ekgrp   TYPE eine-ekgrp,
          netpr   TYPE eine-netpr,
          mxwrt   TYPE konp-mxwrt,
          gkwrt   TYPE konp-gkwrt,
          bstma   TYPE eine-bstma,
          mwskz   TYPE eine-mwskz,
          datbi   TYPE a017-datbi,
          datab   TYPE a017-datab,
          indi    TYPE string,
*--------------------------------------------------------------------*paresh workbench
          loekz   TYPE eina-loekz,                                    "passing this field into netprice.
          zseries TYPE mara-zseries,
          zsize   TYPE  mara-zsize,
          brand   TYPE  mara-brand,
          moc     TYPE  mara-moc,
          type    TYPE mara-type,
*--------------------------------------------------------------------*
          norbm   TYPE eine-norbm,
          minbm   TYPE eine-minbm,
          idnlf   TYPE eina-idnlf,
        END OF ty_final.

TYPES : BEGIN OF ty_down,
        EKORG TYPE char10,
        ERDAT TYPE char15,
        INFNR TYPE char15,
        ESOKZ TYPE eine-esokz,
        LIFNR TYPE char15,
        NAME1 TYPE char50,
        MATNR TYPE char20,
        MAKTX TYPE char50,
        EKGRP TYPE char10,
        NETPR TYPE char15,
        MXWRT TYPE char15,
        GKWRT TYPE char15,
        BSTMA TYPE char15,
        MWSKZ TYPE char10,
        DATBI TYPE char15,
        DATAB TYPE char15,
        INDI  TYPE string,
        LOEKZ TYPE eina-loekz,
        ZSERIES TYPE mara-ZSERIES,
        ZSIZE   TYPE mara-ZSIZE ,
        BRAND   TYPE mara-BRAND ,
        MOC     TYPE mara-MOC   ,
        TYPE    TYPE mara-TYPE  ,
        NORBM   TYPE char15,
        MINBM   TYPE char15,
        IDNLF   TYPE char50,
        ref     TYPE char15,
        time    TYPE char10,
        loekz1 type char10,        "added by vs on 06/07/20202.
        END OF ty_down.

DATA : it_down TYPE TABLE OF ty_down,
       wa_down TYPE          ty_down.

***************************************** Internal Tables ********************************************

DATA : lt_konp  TYPE TABLE OF ty_konp ##needed,
       lt_eina  TYPE TABLE OF ty_eina ##needed,
       lt_eine  TYPE TABLE OF ty_eine ##needed,
       lt_makt  TYPE TABLE OF ty_makt ##needed,
       lt_a017  TYPE TABLE OF ty_a017 ##needed,
       lt_lfa1  TYPE TABLE OF ty_lfa1 ##needed,
*--------------------------------------------------------------------*
       lt_mara  TYPE TABLE OF ty_mara  ##needed,
*--------------------------------------------------------------------*
       lt_final TYPE TABLE OF ty_final ##needed.

***************************************** Work Areas ********************************************

DATA : ls_konp  TYPE  ty_konp ##needed,
       ls_eina  TYPE  ty_eina ##needed,
       ls_eine  TYPE  ty_eine ##needed,
       ls_makt  TYPE  ty_makt ##needed,
       ls_mara  TYPE  ty_mara ##needed,
       ls_a017  TYPE  ty_a017 ##needed,
       ls_lfa1  TYPE  ty_lfa1 ##needed,
       ls_final TYPE ty_final ##needed.
***************************************** Constants ********************************************

DATA : indi TYPE string.

***************************************** Data *************************************************

************************************************************************

*Internal Table for field catalog
DATA : t_fieldcat TYPE slis_t_fieldcat_alv WITH HEADER LINE ##needed.
DATA : fs_layout TYPE slis_layout_alv ##needed.

****************************************Selection Screen ***************************************

SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-101.
SELECT-OPTIONS: s_infnr FOR eine-infnr,
                s_lifnr FOR eina-lifnr,
                s_matnr FOR eina-matnr,
                p_ekorg FOR eine-ekorg  NO INTERVALS OBLIGATORY MODIF ID ek,  "DEFAULT '1000'
                p_ekgrp FOR eine-ekgrp NO INTERVALS.

SELECTION-SCREEN : END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-074 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
SELECTION-SCREEN END OF BLOCK b2.

AT SELECTION-SCREEN ON p_ekorg. " ADDED BY MD
****LOOP AT SCREEN.
****IF screen-group1 = 'EK'.
****screen-input = '0'.
****MODIFY SCREEN.
****ENDIF.
****ENDLOOP.
  DATA : lv_ekorg(4) TYPE c.
  DATA : lv_msg(120) TYPE c.
  LOOP AT p_ekorg.
    CASE p_ekorg-low.
      WHEN '1000'.
      WHEN '2000'.
      WHEN OTHERS.
        lv_ekorg = p_ekorg.
        CONCATENATE 'You are not authorised for ' p_ekorg-low ' purchase organization' INTO lv_msg RESPECTING BLANKS.
        MESSAGE  lv_msg TYPE 'E'.
    ENDCASE.
  ENDLOOP.



START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM arrange_data.
  PERFORM display_data.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .

  SELECT infnr
         ekorg
         esokz
         werks
         ekgrp
         bstyp
         netpr
         mwskz
         norbm
         minbm
         loekz
    FROM eine
    INTO TABLE lt_eine
    WHERE ekorg IN p_ekorg
*     and esokz = '3'.
    AND  ekgrp IN p_ekgrp
*    and ESOKZ = 0 and ESOKZ = 3.
    AND  infnr IN s_infnr
    AND  werks = 'PL01'." ADDED BY MD

  IF lt_eine IS NOT INITIAL.
    SELECT infnr
             matnr
             lifnr
             erdat
             loekz                 "DELETION FLAG
             idnlf
        FROM  eina
         INTO TABLE lt_eina
      FOR ALL ENTRIES IN lt_eine
        WHERE infnr EQ lt_eine-infnr
        AND   matnr IN s_matnr
        AND   lifnr IN s_lifnr.
*        AND  INFNR IN S_INFNR.


    IF lt_eina IS NOT INITIAL.

      SELECT lifnr
             matnr
             werks
             esokz
             datbi
             datab
             knumh
        FROM a017
        INTO TABLE lt_a017
        FOR ALL ENTRIES IN lt_eina
        WHERE lifnr EQ lt_eina-lifnr
        AND matnr EQ lt_eina-matnr
        AND ekorg IN p_ekorg.
*        and esokz = '3'.

    ENDIF.

    SELECT matnr
           spras
           maktx
      FROM makt
      INTO TABLE lt_makt
      FOR ALL ENTRIES IN lt_eina
      WHERE matnr = lt_eina-matnr.

*--------------------------------------------------------------------*

    SELECT matnr
           zseries
           zsize
           brand
           moc
           type
      FROM mara
      INTO TABLE lt_mara
      FOR ALL ENTRIES IN lt_eina
      WHERE matnr = lt_eina-matnr.

*--------------------------------------------------------------------*



    SELECT lifnr
           name1
           name2
      FROM lfa1
      INTO TABLE lt_lfa1
      FOR ALL ENTRIES IN lt_eina
      WHERE lifnr = lt_eina-lifnr.


  ENDIF.


  IF lt_a017 IS NOT INITIAL .

    SELECT knumh
              kopos
              mxwrt
              gkwrt
              kbetr
     FROM konp
     INTO TABLE lt_konp
     FOR ALL ENTRIES IN lt_a017
     WHERE knumh = lt_a017-knumh.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ARRANGE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM arrange_data .

  CLEAR : ls_eina, ls_konp , ls_makt ,ls_lfa1 , ls_eine , ls_a017.



  IF lt_eina IS NOT INITIAL.

    LOOP AT lt_eina INTO ls_eina.

      ls_final-infnr = ls_eina-infnr.
      ls_final-lifnr = ls_eina-lifnr.
      ls_final-matnr = ls_eina-matnr.
      ls_final-erdat = ls_eina-erdat.
      ls_final-idnlf = ls_eina-idnlf.
*--------------------------------------------------------------------*
      ls_final-loekz = ls_eina-loekz.                                "DELETION FLAG
*--------------------------------------------------------------------*
      READ TABLE lt_eine INTO ls_eine WITH KEY infnr = ls_eina-infnr.

      IF ls_eine IS NOT INITIAL.

        ls_final-ekorg = ls_eine-ekorg.
*        ls_final-esokz = ls_eine-esokz.
        ls_final-ekgrp = ls_eine-ekgrp.

        "eine table netpr
*        ls_final-netpr = ls_eine-netpr.

        ls_final-mwskz = ls_eine-mwskz.

*        if ls_eine-esokz eq 3.
*          ls_final-loekz1 = ls_eine-loekz.  "ADDED BY VS ON 06/07/20
*        else.
*        ls_final-loekz1 = 'null'.  "ADDED BY VS ON 06/07/20
*       ENDIF.



      ENDIF.

      READ TABLE lt_mara INTO ls_mara WITH KEY matnr = ls_eina-matnr.
      ls_final-zseries = ls_mara-zseries.
      ls_final-zsize   = ls_mara-zsize.
      ls_final-brand   = ls_mara-brand.
      ls_final-moc     = ls_mara-moc.
      ls_final-type     = ls_mara-type.

      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_eina-matnr.

      IF ls_makt IS NOT INITIAL.

        ls_final-maktx = ls_makt-maktx.

      ENDIF.

      READ TABLE lt_lfa1 INTO ls_lfa1 WITH KEY lifnr = ls_eina-lifnr.

      IF ls_lfa1 IS NOT INITIAL.

        ls_final-name1 = ls_lfa1-name1.

      ENDIF.

*      READ TABLE lt_a017 INTO ls_a017 WITH KEY lifnr = ls_eina-lifnr matnr = ls_eina-matnr.
      LOOP AT lt_a017 INTO ls_a017 WHERE  lifnr = ls_eina-lifnr AND matnr = ls_eina-matnr.

        IF ls_a017 IS NOT INITIAL.
          ls_final-datbi = ls_a017-datbi.
          ls_final-datab = ls_a017-datab.
          ls_final-esokz = ls_a017-esokz.

*          IF ls_final-datbi < sy-datum.
*            ls_final-indi = 'X'.
*          ENDIF.
          IF ls_eina-loekz = 'X'.
            ls_final-indi = 'X'.

          ELSE.
            IF sy-datum > ls_final-datbi.
              ls_final-indi = 'X'.
            ELSE.
              ls_final-indi = ' '.
            ENDIF.
          ENDIF.

          READ TABLE lt_eine INTO ls_eine WITH KEY infnr = ls_eina-infnr esokz = ls_a017-esokz.
          IF  sy-subrc = 0.

            ls_final-norbm = ls_eine-norbm.
            ls_final-minbm = ls_eine-minbm.
            ls_final-mwskz = ls_eine-mwskz.

            if ls_eine-esokz eq 3 or ls_eine-esokz eq 0.
             ls_final-loekz1 = ls_eine-loekz.  "ADDED BY VS ON 06/07/20
*           else.
*            ls_final-loekz1 = 'null'.  "ADDED BY VS ON 06/07/20
            ENDIF.
*
          ENDIF.

          READ TABLE lt_konp INTO ls_konp WITH KEY knumh = ls_a017-knumh. "index sy-tabix. "WITH KEY knumh = ls_a017-knumh and datbi ls_a017-datbi .

          IF ls_a017 IS NOT INITIAL.

            ls_final-mxwrt = ls_konp-mxwrt.
            ls_final-gkwrt = ls_konp-gkwrt.
* paresh workbech
            ls_final-netpr = ls_konp-kbetr.

          ENDIF.

        ENDIF.


********************************************

        IF ls_final-infnr IS NOT INITIAL.

          APPEND ls_final TO lt_final.
        ENDIF.
**************************************************
*       CLEAR : ls_final.
      ENDLOOP.

      CLEAR : ls_final.

    ENDLOOP.
  ENDIF.



IF p_down = 'X'.
LOOP AT lt_final INTO ls_final.
wa_down-EKORG = ls_final-EKORG.
*wa_down-ERDAT = ls_final-ERDAT.
IF ls_final-ERDAT IS NOT INITIAL.

CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = ls_final-ERDAT
   IMPORTING
     OUTPUT        = wa_down-ERDAT
            .

CONCATENATE wa_down-ERDAT+0(2) wa_down-ERDAT+2(3) wa_down-ERDAT+5(4)
                INTO wa_down-ERDAT SEPARATED BY '-'.

ENDIF.

wa_down-INFNR = ls_final-INFNR.
wa_down-ESOKZ = ls_final-ESOKZ.
wa_down-LIFNR = ls_final-LIFNR.
wa_down-NAME1 = ls_final-NAME1.
wa_down-MATNR = ls_final-MATNR.
wa_down-MAKTX = ls_final-MAKTX.
wa_down-EKGRP = ls_final-EKGRP.
wa_down-NETPR = ls_final-NETPR.
wa_down-MXWRT = ls_final-MXWRT.
wa_down-GKWRT = ls_final-GKWRT.
wa_down-BSTMA = ls_final-BSTMA.
wa_down-MWSKZ = ls_final-MWSKZ.

*wa_down-DATBI = ls_final-DATBI.

IF ls_final-DATBI IS NOT INITIAL.

CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = ls_final-DATBI
   IMPORTING
     OUTPUT        = wa_down-DATBI
            .

CONCATENATE wa_down-DATBI+0(2) wa_down-DATBI+2(3) wa_down-DATBI+5(4)
                INTO wa_down-DATBI SEPARATED BY '-'.

ENDIF.


*wa_down-DATAB = ls_final-DATAB.
IF ls_final-DATAB IS NOT INITIAL.

CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = ls_final-DATAB
   IMPORTING
     OUTPUT        = wa_down-DATAB
            .

CONCATENATE wa_down-DATAB+0(2) wa_down-DATAB+2(3) wa_down-DATAB+5(4)
                INTO wa_down-DATAB SEPARATED BY '-'.

ENDIF.


wa_down-INDI  = ls_final-INDI .
wa_down-LOEKZ = ls_final-LOEKZ.

wa_down-ZSERIES = ls_final-ZSERIES.
wa_down-ZSIZE   = ls_final-ZSIZE  .
wa_down-BRAND   = ls_final-BRAND  .
wa_down-MOC     = ls_final-MOC    .
wa_down-TYPE    = ls_final-TYPE   .
wa_down-NORBM   = ls_final-NORBM  .
wa_down-MINBM   = ls_final-MINBM  .
wa_down-IDNLF   = ls_final-IDNLF  .
wa_down-LOEKZ1 = ls_final-LOEKZ1.  " added by vs on 06/07/2020

CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input         = sy-datum
   IMPORTING
     OUTPUT        = wa_down-ref
            .

CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                INTO wa_down-ref SEPARATED BY '-'.

CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO wa_down-time SEPARATED BY ':'.

APPEND wa_down TO it_down.
CLEAR wa_down.
ENDLOOP.
ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .

  PERFORM dis_fieldlog.
  PERFORM dis_layout.
  PERFORM dis_alv.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  T_FIELDCATLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0660   text
*      -->P_0661   text
*      -->P_0662   text
*      -->P_0663   text
*----------------------------------------------------------------------*
FORM t_fieldcatlog  USING    VALUE(p1) ##PERF_NO_TYPE
                             VALUE(p2) ##PERF_NO_TYPE
                             VALUE(p3) ##PERF_NO_TYPE
                             VALUE(p4) ##PERF_NO_TYPE.

  t_fieldcat-col_pos = p1.
  t_fieldcat-fieldname = p2.
  t_fieldcat-tabname = p3.
  t_fieldcat-seltext_l = p4.

  APPEND t_fieldcat.
  CLEAR t_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DIS_FIELDLOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dis_fieldlog .
  PERFORM t_fieldcatlog USING  '1'    'EKORG'   'LT_FINAL'      'Purchase organisation '               ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '2'    'ERDAT'   'LT_FINAL'      'Created Date '                        ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '3'    'INFNR'   'LT_FINAL'      'Info Record'                          ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '4'    'ESOKZ'   'LT_FINAL'      'Infor Record '                        ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '5'    'LIFNR'   'LT_FINAL'      'Type  Vendor  '                       ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '6'    'NAME1'   'LT_FINAL'      'Vendor Name'                          ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '7'    'MATNR'   'LT_FINAL'      'Material'                             ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '8'    'MAKTX'   'LT_FINAL'      'Material Description'                 ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '9'    'EKGRP'   'LT_FINAL'      'Purchasing Group'                     ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '10'   'NETPR'   'LT_FINAL'      'Net Price'                            ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '11'   'MXWRT'   'LT_FINAL'      'Lower limit '                         ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '12'   'GKWRT'   'LT_FINAL'      'Upper limit '                         ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '13'   'BSTMA'   'LT_FINAL'      'MOQ '                                 ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '14'   'MWSKZ'   'LT_FINAL'      'Tax Code'                             ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '15'   'DATBI'   'LT_FINAL'      'Valid Upto'                           ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '16'   'DATAB'   'LT_FINAL'      'Valid From'                           ##NO_TEXT.
  PERFORM t_fieldcatlog USING  '17'   'INDI'    'LT_FINAL'      'Indicator'                            ##NO_TEXT.
*-paresh workbench-------------------------------------------------------------------*
  PERFORM t_fieldcatlog USING '18'   'LOEKZ'    'LT_FINAL'      'Delection Flag'.                      "##NO_TEXT.
  PERFORM t_fieldcatlog USING '19'   'ZSERIES'  'LT_FINAL'      'Series code'.                         "##NO_TEXT.
  PERFORM t_fieldcatlog USING '20'   'ZSIZE'    'LT_FINAL'      'Size'.                                "##NO_TEXT.
  PERFORM t_fieldcatlog USING '21'   'BRAND'    'LT_FINAL'      'Brand'.                               "##NO_TEXT.
  PERFORM t_fieldcatlog USING '22'   'MOC'      'LT_FINAL'      'Moc'.                                  "##NO_TEXT.
  PERFORM t_fieldcatlog USING '23'   'TYPE'     'LT_FINAL'      'Type'.
  PERFORM t_fieldcatlog USING '24'   'NORBM'    'LT_FINAL'      'Standard Qty'.
  PERFORM t_fieldcatlog USING '25'   'MINBM'    'LT_FINAL'      'Min Order Qty'.
  PERFORM t_fieldcatlog USING '26'   'IDNLF'    'LT_FINAL'      'Vendor Mat.No.'.

  PERFORM t_fieldcatlog USING '27'   'LOEKZ1'    'LT_FINAL'      'Pur.Org.Delection Flag'.                      "##NO_TEXT.
*-------------------------------------------------------------------------------------*
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DIS_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dis_layout ##needed .

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DIS_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM dis_alv .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      is_layout               = fs_layout
      i_callback_user_command = 'USER_COMMAND'
      i_callback_top_of_page  = 'TOP-OF-PAGE'
      it_fieldcat             = t_fieldcat[]
*     it_sort                 = t_sort[]
      i_save                  = 'X'
    TABLES
      t_outtab                = lt_final
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

IF p_down = 'X'.
    PERFORM download.
ENDIF.
ENDFORM.
FORM top-of-page ##called ##FIELD_HYPHEN.

*ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

* Title
  wa_header-typ  = 'H'.
  wa_header-info = 'Vendor Info Records' ##NO_TEXT.
  APPEND wa_header TO t_header.
  CLEAR wa_header.

* Total No. of Records Selected
  DESCRIBE TABLE lt_final LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc ##NO_TEXT
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
*       i_logo             = 'GANESH_LOGO'.
ENDFORM.                    " top-of-page

FORM user_command USING r_ucomm LIKE sy-ucomm
                        rs_selfield TYPE slis_selfield ##called.
  CASE r_ucomm.
    WHEN '&IC1'. "standard Function code for doubel click
      READ TABLE lt_final INTO ls_final INDEX rs_selfield-tabindex.
      IF sy-subrc = 0.
        SET PARAMETER ID 'INF' FIELD ls_final-infnr. "set parameter id
        CALL TRANSACTION 'ME13' AND SKIP FIRST SCREEN. "call transaction
      ENDIF.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ZVENINFO.TXT'.


  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
    INTO lv_fullfile.

  WRITE: / 'ZVENINFO REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.



*******************************************Second File *************************
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.
  lv_file = 'ZVENINFO.TXT'.

  CONCATENATE p_folder '\' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZVENINFO REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
    TRANSFER hd_csv TO lv_fullfile.
    LOOP AT it_csv INTO wa_csv.
      IF sy-subrc = 0.
        TRANSFER wa_csv TO lv_fullfile.

      ENDIF.
    ENDLOOP.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.
 DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Purchase organisation '
              'Created Date '
              'Info Record'
              'Infor Record '
              'Type  Vendor  '
              'Vendor Name'
              'Material'
              'Material Description'
              'Purchasing Group'
              'Net Price'
              'Lower limit '
              'Upper limit '
              'MOQ '
              'Tax Code'
              'Valid Upto'
              'Valid From'
              'Indicator'
              'Delection Flag'
              'Series code'
              'Size'
              'Brand'
              'Moc'
              'Type'
              'Standard Qty'
              'Min Order Qty'
              'Vendor Mat.No.'
              'Refresh Date'
              'Refresh Time'
              'Pur.Org.Delection Flag'   "added by vs on 06/7/20
              INTO pd_csv
              SEPARATED BY l_field_seperator.

ENDFORM.
