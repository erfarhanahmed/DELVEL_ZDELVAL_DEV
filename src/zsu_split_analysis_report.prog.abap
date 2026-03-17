*&---------------------------------------------------------------------*
*& Report ZSPLIT_ANALYSIS_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_SPLIT_ANALYSIS_REPORT.

TABLES:VBAK.

TYPES: BEGIN OF TY_VBAK,
         VBELN TYPE VBAK-VBELN,
         VKORG TYPE VBAK-VKORG,
         AUART TYPE VBAK-AUART,
         KUNNR TYPE VBAK-KUNNR,
         FAKSK TYPE VBAK-FAKSK,
         OBJNR TYPE VBAK-OBJNR,
       END OF TY_VBAK,

       BEGIN OF TY_VBAP,
         VBELN TYPE VBAP-VBELN,
         POSNR TYPE VBAP-POSNR,
         MATNR TYPE VBAP-MATNR,
         POSEX TYPE VBAP-POSEX,
         FAKSP TYPE VBAP-FAKSP,
         NETPR TYPE VBAP-NETPR,
       END OF TY_VBAP,

       BEGIN OF TY_VAPMA,
         VBELN TYPE VAPMA-VBELN,
         POSNR TYPE VAPMA-POSNR,
         BSTNK TYPE EKKO-EBELN,

       END OF TY_VAPMA,



       BEGIN OF TY_VBKD,
         VBELN TYPE VBKD-VBELN,
         POSNR TYPE VBKD-POSNR,
         INCO1 TYPE VBKD-INCO1,
         INCO2 TYPE VBKD-INCO2,
         ZTERM TYPE VBKD-ZTERM,
         BSTKD TYPE EKKO-EBELN,
         PRSDT TYPE VBKD-PRSDT,
         KURSK TYPE VBKD-KURSK,
       END OF TY_VBKD,

       BEGIN OF TY_EKKO,
         EBELN TYPE EKKO-EBELN,
         BUKRS TYPE EKKO-BUKRS,
         BSART TYPE EKKO-BSART,
         ZTERM TYPE EKKO-ZTERM,
         EKORG TYPE EKKO-EKORG,
         FRGRL TYPE EKKO-FRGRL,
         INCO1 TYPE EKKO-INCO1,
         INCO2 TYPE EKKO-INCO2,
       END OF TY_EKKO,

       BEGIN OF TY_EKPO,
         EBELN TYPE EKPO-EBELN,
         EBELP TYPE EKPO-EBELP,
         MATNR TYPE EKPO-MATNR,
         NETPR TYPE ekpo-NETPR,
       END OF TY_EKPO,

       BEGIN OF TY_NAST,
         OBJKY TYPE NAST-OBJKY,
         KSCHL TYPE NAST-KSCHL,
         ERDAT TYPE NAST-ERDAT,
         ERUHR TYPE NAST-ERUHR,
         AENDE TYPE NAST-AENDE,
       END OF TY_NAST,



       BEGIN OF TY_FINAL,
         VBELN       TYPE VBAK-VBELN,
         VKORG       TYPE VBAK-VKORG,
         AUART       TYPE VBAK-AUART,
         KUNNR       TYPE VBAK-KUNNR,
         POSNR       TYPE VBAP-POSNR,
         MATNR       TYPE VBAP-MATNR,
         POSEX       TYPE VBAP-POSEX,
         INCO1       TYPE VBKD-INCO1,
         INCO2       TYPE VBKD-INCO2,
         ZTERM       TYPE VBKD-ZTERM,
         ZTERM1      TYPE CHAR50,
         EBELN       TYPE EKKO-EBELN,
         EBELP       TYPE EKPO-EBELP,
         PO_ZTERM    TYPE EKKO-ZTERM,
         PO_ZTERM1   TYPE CHAR50,
         PO_EKORG    TYPE EKKO-EKORG,
         PO_FRGRL    TYPE EKKO-FRGRL,
         PO_INCO1    TYPE EKKO-INCO1,
         PO_INCO2    TYPE EKKO-INCO2,
         PO_MATNR    TYPE EKPO-MATNR,
         STATUS      TYPE CHAR10,
         OUTPUT      TYPE CHAR10,
         INCO_MAT    TYPE CHAR10,
         PAY_MAT     TYPE CHAR10,
         INCO_MAT1   TYPE CHAR10,
         PAY_MAT1    TYPE CHAR10,
         ITEM_MAT    TYPE CHAR10,
         PRSDT       TYPE VBKD-PRSDT,
         KURSK       TYPE VBKD-KURSK,
         H_PRSDT     TYPE VBKD-PRSDT,
         H_KURSK     TYPE VBKD-KURSK,
         PRS_MAT     TYPE CHAR10,
         KUR_MAT     TYPE CHAR10,
         H_PRI_BLOCK TYPE CHAR10,
         I_PRI_BLOCK TYPE CHAR10,
         RELASE      TYPE CHAR10,
         po_NETPR    TYPE ekpo-netpr,
         so_NETPR    TYPE ekpo-netpr,
         RATE_MAT    TYPE CHAR10,
         kdgrp       TYPE vbkd-kdgrp,
         KTEXT       TYPE T151T-KTEXT,
         kdtxt       TYPE char50,
       END OF TY_FINAL.



DATA: IT_VBAK  TYPE TABLE OF TY_VBAK,
      WA_VBAK  TYPE          TY_VBAK,

      IT_VBAP  TYPE TABLE OF TY_VBAP,
      WA_VBAP  TYPE          TY_VBAP,

      IT_VBKD  TYPE TABLE OF TY_VBKD,
      WA_VBKD  TYPE          TY_VBKD,

      IT_VAPMA TYPE TABLE OF TY_VAPMA,
      WA_VAPMA TYPE          TY_VAPMA,

      IT_EKKO  TYPE TABLE OF TY_EKKO,
      WA_EKKO  TYPE          TY_EKKO,

      IT_EKPO  TYPE TABLE OF TY_EKPO,
      WA_EKPO  TYPE          TY_EKPO,

      IT_NAST  TYPE TABLE OF TY_NAST,
      WA_NAST  TYPE          TY_NAST,

      WA_JEST  TYPE JEST,

      IT_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE          TY_FINAL.


DATA: IT_FCAT TYPE SLIS_T_FIELDCAT_ALV,
      WA_FCAT LIKE LINE OF IT_FCAT.


SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : S_VBELN FOR VBAK-VBELN OBLIGATORY.
SELECT-OPTIONS : S_VKORG FOR VBAK-VKORG default '1000' no intervals modif id bu.
*                 p_kunnr TYPE vbak-kunnr.
SELECTION-SCREEN:END OF BLOCK B1.

at selection-screen output. " ADDED BY MD
  loop at screen.
    if screen-group1 = 'BU'.
      screen-input = '0'.
      modify screen.
    endif.
  endloop.

START-OF-SELECTION.
  PERFORM GET_DATA.
  PERFORM SORT_DATA.
  PERFORM GET_FCAT.
  PERFORM GET_DISPLAY.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

  SELECT VBELN
         VKORG
         AUART
         KUNNR
         FAKSK
         OBJNR FROM VBAK INTO TABLE IT_VBAK
         WHERE VBELN IN S_VBELN
          AND  VKORG IN S_VKORG
          AND  KUNNR = '0000300315'.


  IF  IT_VBAK IS NOT INITIAL.

    SELECT VBELN
           POSNR
           MATNR
           POSEX
           FAKSP
           NETPR FROM VBAP INTO TABLE IT_VBAP
           FOR ALL ENTRIES IN IT_VBAK
           WHERE VBELN = IT_VBAK-VBELN.


  ENDIF.

  IF IT_VBAP IS NOT INITIAL.

    SELECT VBELN
           POSNR
           BSTNK
            FROM VAPMA INTO TABLE IT_VAPMA
           FOR ALL ENTRIES IN IT_VBAP
           WHERE VBELN = IT_VBAP-VBELN
             AND POSNR = IT_VBAP-POSNR.

    SELECT VBELN
           POSNR
           INCO1
           INCO2
           ZTERM
           BSTKD
           PRSDT
           KURSK FROM VBKD INTO TABLE IT_VBKD
           FOR ALL ENTRIES IN IT_VBAP
           WHERE VBELN = IT_VBAP-VBELN.
*         AND posnr = it_vbap-posnr.

  ENDIF.


  IF IT_VAPMA IS NOT INITIAL.

    SELECT EBELN
           BUKRS
           BSART
           ZTERM
           EKORG
           FRGRL
           INCO1
           INCO2 FROM EKKO INTO TABLE IT_EKKO
           FOR ALL   ENTRIES IN IT_VAPMA
           WHERE EBELN = IT_VAPMA-BSTNK.

  ENDIF.

  IF  IT_EKKO IS NOT INITIAL.
    SELECT EBELN
           EBELP
           MATNR
           NETPR FROM EKPO INTO TABLE IT_EKPO
           FOR ALL ENTRIES IN IT_EKKO
           WHERE EBELN = IT_EKKO-EBELN.




  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM SORT_DATA .

  LOOP AT IT_VBAP INTO WA_VBAP.
    WA_FINAL-VBELN = WA_VBAP-VBELN.
    WA_FINAL-POSNR = WA_VBAP-POSNR.
    WA_FINAL-MATNR = WA_VBAP-MATNR.
    WA_FINAL-EBELP = WA_VBAP-POSEX.
    WA_FINAL-so_NETPR = WA_VBAP-NETPR.

  SELECT SINGLE kdgrp INTO wa_final-kdgrp FROM vbkd WHERE vbeln = wa_final-vbeln AND posnr = ' '.
  IF wa_final-kdgrp IS NOT INITIAL.
    SELECT SINGLE ktext INTO wa_final-ktext FROM t151t WHERE kdgrp = wa_final-kdgrp AND spras = 'EN'.
  ENDIF.
  CONCATENATE WA_FINAL-KDGRP WA_FINAL-KTEXT INTO WA_FINAL-KDTXT .

    IF WA_VBAP-FAKSP IS NOT INITIAL.
      WA_FINAL-I_PRI_BLOCK = 'YES'.
    ELSE.
      WA_FINAL-I_PRI_BLOCK = 'NO'.
    ENDIF.

    READ TABLE IT_VBAK INTO WA_VBAK WITH KEY VBELN = WA_VBAP-VBELN.
    IF SY-SUBRC = 0.
      WA_FINAL-KUNNR = WA_VBAK-KUNNR.

      IF WA_VBAK-FAKSK IS NOT INITIAL.
        WA_FINAL-H_PRI_BLOCK = 'YES'.
      ELSE.
        WA_FINAL-H_PRI_BLOCK = 'NO'.
      ENDIF.

    ENDIF.

    SELECT SINGLE * FROM JEST INTO WA_JEST WHERE OBJNR = WA_VBAK-OBJNR AND STAT = 'E0005' AND INACT = ' '.

    IF WA_JEST IS NOT INITIAL.
      WA_FINAL-RELASE = 'YES'.
    ELSE.
      WA_FINAL-RELASE = 'NO'.
    ENDIF.

    READ TABLE IT_VAPMA INTO WA_VAPMA WITH KEY VBELN = WA_VBAP-VBELN POSNR = WA_VBAP-POSNR.
    IF SY-SUBRC = 0.

    ENDIF.
    READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_VBAP-VBELN POSNR = WA_VBAP-POSNR.
    IF SY-SUBRC = 0.
      WA_FINAL-INCO1 = WA_VBKD-INCO1.
      WA_FINAL-INCO2 = WA_VBKD-INCO2.
      WA_FINAL-ZTERM = WA_VBKD-ZTERM.
      WA_FINAL-PRSDT = WA_VBKD-PRSDT.
      WA_FINAL-KURSK = WA_VBKD-KURSK.

    ENDIF.
    IF WA_VBKD IS INITIAL.

      READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_VBAP-VBELN POSNR = ' '.
      IF SY-SUBRC = 0.
        WA_FINAL-INCO1 = WA_VBKD-INCO1.
        WA_FINAL-INCO2 = WA_VBKD-INCO2.
        WA_FINAL-ZTERM = WA_VBKD-ZTERM.
        WA_FINAL-PRSDT = WA_VBKD-PRSDT.
        WA_FINAL-KURSK = WA_VBKD-KURSK.
      ENDIF.

    ENDIF.

    CLEAR WA_VBKD.

    READ TABLE IT_VBKD INTO WA_VBKD WITH KEY VBELN = WA_VBAP-VBELN POSNR = ' '.
    IF SY-SUBRC = 0.
      WA_FINAL-H_PRSDT = WA_VBKD-PRSDT.
      WA_FINAL-H_KURSK = WA_VBKD-KURSK.
    ENDIF .



    READ TABLE IT_EKKO INTO WA_EKKO WITH KEY EBELN = WA_VAPMA-BSTNK.
    IF SY-SUBRC = 0.
      WA_FINAL-EBELN    = WA_EKKO-EBELN.
      WA_FINAL-PO_ZTERM = WA_EKKO-ZTERM.
      WA_FINAL-PO_EKORG = WA_EKKO-EKORG.
*  wa_final-po_frgrl = wa_ekko-frgrl.
      WA_FINAL-PO_INCO1 = WA_EKKO-INCO1.
      WA_FINAL-PO_INCO2 = WA_EKKO-INCO2.

      IF WA_EKKO-FRGRL = 'X'.
        WA_FINAL-STATUS = 'NO'.
      ELSE.
        WA_FINAL-STATUS = 'YES'.
      ENDIF.
    ENDIF.

    SELECT SINGLE TEXT1 INTO WA_FINAL-ZTERM1 FROM T052U WHERE SPRAS = 'EN' AND ZTERM = WA_FINAL-ZTERM.
    SELECT SINGLE TEXT1 INTO WA_FINAL-PO_ZTERM1 FROM T052U WHERE SPRAS = 'EN' AND ZTERM = WA_FINAL-PO_ZTERM.

    READ TABLE IT_EKPO INTO WA_EKPO WITH KEY EBELN = WA_EKKO-EBELN EBELP = WA_VBAP-POSEX.
    IF SY-SUBRC = 0.
*  wa_final-ebelp = wa_ekpo-ebelp.
      WA_FINAL-PO_MATNR = WA_EKPO-MATNR.
      WA_FINAL-po_NETPR = WA_ekpo-NETPR.
    ENDIF.


    SELECT SINGLE OBJKY
                  KSCHL
                  ERDAT
                  ERUHR
                  AENDE FROM NAST INTO WA_NAST
                  WHERE OBJKY = WA_EKKO-EBELN
                    AND KSCHL = 'SAEU'             "UNEU (SAEU added by Nilay B. on 25.12.2023)
                    AND AENDE = ' '.
    IF WA_NAST IS NOT INITIAL.
      WA_FINAL-OUTPUT = 'YES'.
    ELSE.
      WA_FINAL-OUTPUT = 'NO'.
    ENDIF.

    IF WA_FINAL-PO_INCO1  = WA_FINAL-INCO1.

      WA_FINAL-INCO_MAT = 'YES'.
    ELSE.
      WA_FINAL-INCO_MAT = 'NO'.

    ENDIF.

    IF WA_FINAL-PO_INCO2  = WA_FINAL-INCO2.

      WA_FINAL-INCO_MAT1 = 'YES'.
    ELSE.
      WA_FINAL-INCO_MAT1 = 'NO'.

    ENDIF.

    IF WA_FINAL-PO_MATNR  = WA_FINAL-MATNR.

      WA_FINAL-ITEM_MAT = 'YES'.
    ELSE.
      WA_FINAL-ITEM_MAT = 'NO'.

    ENDIF.

    IF WA_FINAL-ZTERM  = WA_FINAL-PO_ZTERM.

      WA_FINAL-PAY_MAT = 'YES'.
    ELSE.
      WA_FINAL-PAY_MAT = 'NO'.

    ENDIF.

    IF WA_FINAL-ZTERM1  = WA_FINAL-PO_ZTERM1.

      WA_FINAL-PAY_MAT1 = 'YES'.
    ELSE.
      WA_FINAL-PAY_MAT1 = 'NO'.

    ENDIF.


    IF WA_FINAL-PRSDT = WA_FINAL-H_PRSDT.
      WA_FINAL-PRS_MAT = 'YES'.
    ELSE .
      WA_FINAL-PRS_MAT = 'NO'.
    ENDIF.

    IF WA_FINAL-KURSK = WA_FINAL-H_KURSK.
      WA_FINAL-KUR_MAT = 'YES'.
    ELSE .
      WA_FINAL-KUR_MAT = 'NO'.
    ENDIF.

     IF WA_FINAL-PO_NETPR  = WA_FINAL-SO_NETPR.

      WA_FINAL-RATE_MAT = 'YES'.
    ELSE.
      WA_FINAL-RATE_MAT = 'NO'.

    ENDIF.

    APPEND WA_FINAL TO IT_FINAL.
    CLEAR :WA_FINAL,WA_VBKD.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_FCAT .
  PERFORM FCAT USING : '1'   'VBELN'           'IT_FINAL'      'Sales Order '                 '20' ,
                       '2'   'EBELN'           'IT_FINAL'      'Purchase Order'        '20' ,
                       '3'   'INCO1'           'IT_FINAL'      'India_Inco_Terms'        '20' ,
                       '4'   'PO_INCO1'           'IT_FINAL'      'SA_Inco_Terms'        '20' ,
                       '5'   'POSNR'           'IT_FINAL'      'SO_Position_No'        '20' ,
                       '6'   'EBELP'           'IT_FINAL'      'PO_Position_No'        '20' ,
                       '7'   'ZTERM'           'IT_FINAL'      'India_Payment_Terms'        '20' ,
                       '8'   'PO_ZTERM'           'IT_FINAL'      'SA_Payment_Terms'        '20' ,
                       '9'   'ZTERM1'           'IT_FINAL'      'India_Pay_Terms_Desc'        '20' ,
                       '10'   'PO_ZTERM1'           'IT_FINAL'      'SA_Pay_Terms_Desc'        '20' ,
                       '11'   'MATNR'           'IT_FINAL'      'India_Material_No'        '20' ,
                       '12'   'PO_MATNR'           'IT_FINAL'      'SA_Material_Code'        '20' ,
                       '13'   'INCO2'             'IT_FINAL'      'India_Inco_Terms_Description'        '20' ,
                       '14'   'PO_INCO2'           'IT_FINAL'      'SA_Inco_Terms_Description'        '20' ,
                       '15'   'STATUS'           'IT_FINAL'      'PO_Release_Status'        '20' ,
                       '16'   'OUTPUT'           'IT_FINAL'      'PO_Output_Type'         '20' ,
                       '17'   'INCO_MAT'           'IT_FINAL'      'Incoterm Match'         '20' ,
                       '18'   'INCO_MAT1'           'IT_FINAL'      'Incoterm Desc Match'         '20' ,
                       '19'   'PAY_MAT'           'IT_FINAL'      'Payment Term Match'         '20' ,
                       '20'   'PAY_MAT1'           'IT_FINAL'      'Pay Term Desc Match'         '20' ,
                       '21'   'ITEM_MAT'           'IT_FINAL'      'Material Match'         '20' ,
                       '22'   'H_PRSDT'           'IT_FINAL'       'Header Pricing Date'         '20' ,
                       '23'   'PRSDT'             'IT_FINAL'       'Item Pricing Date'         '20' ,
                       '24'   'H_KURSK'           'IT_FINAL'       'Header Exchange Rate'         '20' ,
                       '25'   'KURSK'            'IT_FINAL'       'Item Exchange Rate'         '20' ,
                       '26'   'SO_NETPR'          'IT_FINAL'      'Sale Order Rate'         '20' ,
                       '27'   'PO_NETPR'          'IT_FINAL'      'Purchase Order Rate'         '20' ,
                       '28'   'RATE_MAT'           'IT_FINAL'      'Order Rate Match'         '20' ,
                       '29'   'PRS_MAT'           'IT_FINAL'      'Pricing Date Match'         '20' ,
                       '30'   'KUR_MAT'           'IT_FINAL'      'Exchange Rate Match'         '20' ,
                       '31'   'H_PRI_BLOCK'           'IT_FINAL'      'Header Pricing Block'         '20' ,
                       '32'   'I_PRI_BLOCK'           'IT_FINAL'      'Item Pricing Block'         '20' ,
                       '33'   'RELASE'            'IT_FINAL'        'Commercial Relase'             '15',
                       '34'   'KDTXT'            'IT_FINAL'         'Customer Group'             '20'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DISPLAY .
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      I_CALLBACK_PROGRAM = SY-REPID
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      IT_FIELDCAT        = IT_FCAT
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      T_OUTTAB           = IT_FINAL
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0586   text
*      -->P_0587   text
*      -->P_0588   text
*      -->P_0589   text
*      -->P_0590   text
*----------------------------------------------------------------------*
FORM FCAT   USING    VALUE(P1)
                    VALUE(P2)
                    VALUE(P3)
                    VALUE(P4)
                    VALUE(P5).
  WA_FCAT-COL_POS   = P1.
  WA_FCAT-FIELDNAME = P2.
  WA_FCAT-TABNAME   = P3.
  WA_FCAT-SELTEXT_L = P4.
*wa_fcat-key       = .
  WA_FCAT-OUTPUTLEN   = P5.

  APPEND WA_FCAT TO IT_FCAT.
  CLEAR WA_FCAT.
ENDFORM.
