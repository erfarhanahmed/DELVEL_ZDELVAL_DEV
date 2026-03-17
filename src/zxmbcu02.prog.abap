*&---------------------------------------------------------------------*
*&  Include           ZXMBCU02
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*
* OBJECT ID              :
* FUNCTIONAL ANALYST     :  ABHINAY GANDHE
* PROGRAMMER             :  RAUT SUNITA
* START DATE             :  12/04/2011
* INITIAL TRANSPORT NO   :
* DESCRIPTION            :  TO CHECK THE PO DELIVERY TOLERANCE AND PO RATE.
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

DATA LV_ACTION1 TYPE CHAR5.
DATA LV_REFDOC1 TYPE CHAR5.

IMPORT LV_ACTION TO LV_ACTION1 FROM MEMORY ID 'LV_ACTION'.
IMPORT LV_REFDOC TO LV_REFDOC1 FROM MEMORY ID 'LV_REFDOC'.


IF ( LV_ACTION1 = 'A08'  AND LV_REFDOC1 = 'R10') OR ( LV_ACTION1 = 'A03'  AND LV_REFDOC1 = 'R02')  .
  IF E_SGTXT IS INITIAL.
    E_SGTXT = I_MSEG-SGTXT.
  ENDIF.

  CLEAR : LV_ACTION1, LV_REFDOC1.
ELSE.


*dgsdg
*break primus.
**************************added by jyoti on 22.10.2024**************************
*******below logic for posting date is not future*****************************
  IF SY-TCODE = 'MIGO' OR SY-TCODE = 'MB1A' OR SY-TCODE = 'MB1B' OR SY-TCODE = 'MB1C' .
*  BREAK PRIMUSABAP.
*  if i_mseg-werks = 'PL01'.
    IF I_MKPF-BLDAT GT I_MKPF-BUDAT.
      MESSAGE 'Back dated Posting date is not allowed.' TYPE 'E'.
    ENDIF.
    IF I_MKPF-BUDAT GT SY-DATUM.
      MESSAGE 'Posting date should not be later than the system date.' TYPE 'E'.
    ENDIF.

*  ENDIF.
  ENDIF.



  IF SY-TCODE = 'MIGO'.
*  break primus.
    TYPES: BEGIN OF TY_EKET,
             EBELN LIKE EKET-EBELN,
             EBELP LIKE EKET-EBELP,
             EINDT LIKE EKET-EINDT,
           END OF TY_EKET,

           BEGIN OF TY_EKPO,
             EBELN LIKE EKPO-EBELN,
             EBELP LIKE EKPO-EBELP,
             NETPR LIKE EKPO-NETPR,
             PSTYP LIKE EKPO-PSTYP,
           END OF TY_EKPO,

           BEGIN OF TY_ZENHNS_ACT,
             TITLE     LIKE ZENHNS_ACT-TITLE,
             WERKS     LIKE ZENHNS_ACT-WERKS,
             EXIT_DESC LIKE ZENHNS_ACT-EXIT_DESC,
             VLDTL     LIKE ZENHNS_ACT-VLDTL,
             ACTIV     LIKE ZENHNS_ACT-ACTIV,
           END OF TY_ZENHNS_ACT.

    DATA:IT_EKET TYPE STANDARD TABLE OF TY_EKET,
         WA_EKET TYPE TY_EKET.

    DATA:IT_EKPO TYPE STANDARD TABLE OF TY_EKPO,
         WA_EKPO TYPE TY_EKPO.

    DATA:IT_ZENHNS_ACT TYPE STANDARD TABLE OF TY_ZENHNS_ACT,
         WA_ZENHNS_ACT TYPE TY_ZENHNS_ACT.

    DATA:V_TOLERANCE_AFTER LIKE EKET-EINDT.
    DATA:V_TOLERANCE_BEFORE LIKE EKET-EINDT.
    DATA:V_NETWR TYPE BWERT.

***CHECKING THE ENHANCEMENT IS ACTIVE OR NOT.
    SELECT
    TITLE
    WERKS
    EXIT_DESC
    VLDTL
    ACTIV
    FROM ZENHNS_ACT
    INTO TABLE IT_ZENHNS_ACT
    WHERE TITLE = 'ZPO_TOL'.

    READ TABLE IT_ZENHNS_ACT INTO WA_ZENHNS_ACT WITH KEY WERKS = I_MSEG-WERKS.

    IF WA_ZENHNS_ACT-ACTIV = 'X'.

      SELECT
      EBELN
      EBELP
      EINDT
      FROM EKET
      INTO TABLE IT_EKET
      WHERE EBELN = I_MSEG-EBELN
      AND EBELP = I_MSEG-EBELP.

      LOOP AT IT_EKET INTO WA_EKET.
        V_TOLERANCE_BEFORE = WA_EKET-EINDT - WA_ZENHNS_ACT-VLDTL.
***COMPARING THE PO DATE WITH SYATEM DATE.
        IF SY-DATUM < V_TOLERANCE_BEFORE.
          MESSAGE E004(ZDEL) WITH WA_EKET-EINDT.
        ENDIF.
        CLEAR V_TOLERANCE_BEFORE.
        CLEAR V_TOLERANCE_AFTER.
        CLEAR WA_EKET.
      ENDLOOP.
      CLEAR WA_ZENHNS_ACT.
    ENDIF.
***********************************************************************
**CHECKING THE ENHANCEMENT IS ACTIVE OR NOT.
    SELECT
    TITLE
    WERKS
    EXIT_DESC
    VLDTL
    ACTIV
    FROM ZENHNS_ACT
    INTO TABLE IT_ZENHNS_ACT
    WHERE TITLE = 'ZPO_RATE'.

    READ TABLE IT_ZENHNS_ACT INTO WA_ZENHNS_ACT WITH KEY WERKS = I_MSEG-WERKS.

    IF WA_ZENHNS_ACT-ACTIV = 'X'.

      SELECT
      EBELN
      EBELP
      NETPR
      PSTYP
      FROM EKPO
      INTO TABLE IT_EKPO
      WHERE EBELN = I_MSEG-EBELN
      AND EBELP = I_MSEG-EBELP.
      BREAK FUJIABAP.
      LOOP AT IT_EKPO INTO WA_EKPO.

        IF WA_EKPO-PSTYP = '0'.
          IF I_MSEG-WEMPF IS INITIAL.

            MESSAGE E040(ZDEL) WITH WA_EKPO-EBELP.

          ENDIF.
        ENDIF.

        IF I_MSEG-BWART = '101'." AND SY-TABIX = 1.
          IF I_MSEG-ABLAD IS INITIAL
            AND WA_EKPO-NETPR IS NOT INITIAL.
            MESSAGE E018(ZDEL).
          ELSE.
            CONDENSE I_MSEG-ABLAD.
            IF I_MSEG-ABLAD CN '1234567890. '.
              MESSAGE 'Unloading Point contains non-numeric characters' TYPE 'E'.

            ENDIF.

          ENDIF.
***COMPARING THE PO RATE WITH CURRENT RATE.

          IF WA_EKPO-NETPR <> I_MSEG-ABLAD .  "" i_mseg-ablad.
            MESSAGE E001(ZDEL).
          ENDIF.
          CLEAR WA_EKPO-NETPR.
        ENDIF.
      ENDLOOP.
      CLEAR WA_ZENHNS_ACT.
    ENDIF.
  ENDIF.

*>>Jayant@Fijutsu for populating Text field in MIGO
  IF E_SGTXT IS INITIAL.

    E_SGTXT = I_MSEG-SGTXT.

  ENDIF.




*TO SEND MAIL FOR THE MISSING PARTS

  DATA: IT_MATVP LIKE MATVP.
  DATA:TEXT TYPE STRING.

  DATA: BEGIN OF XTFEHL OCCURS 10.
          INCLUDE STRUCTURE ATPSL.
  DATA: END   OF XTFEHL.

*WORK AREA DECLARATION FOR SENDING DOCUMENT DATA
  DATA:WA_DOCUMENT_DATA  LIKE  SODOCCHGI1,
*WORK AREA DECLARATION FOR RECEIVING DOCUMENT DATA
       WA_RECEIVERS      LIKE SOMLRECI1,
*IMPORTING PARAMETER.
       NEW_OBJECT_ID     LIKE  SOFOLENTI1-OBJECT_ID,
*WORK AREA DECLARATION FOR MAIN BODY CONTENT.
       WA_OBJECT_CONTENT LIKE SOLISTI1,
***********************************************************************
*INTERNAL TABLE DECLARATION FOR RECEIVING DOCUMENT DATA
       IT_RECEIVERS      TYPE TABLE OF SOMLRECI1,
*INTERNAL TABLEDECLARATION FOR MAIN BODY CONTENT.
       IT_OBJECT_CONTENT TYPE TABLE OF SOLISTI1.
***********************************************************************
  CLEAR IT_MATVP.
  MOVE-CORRESPONDING I_DM07M TO IT_MATVP.
  MOVE-CORRESPONDING I_MSEG  TO IT_MATVP.
  IT_MATVP-MTVFP = I_VM07M-MTVFP.
  IT_MATVP-DISPO = I_VM07M-DISPO.
  IF NOT I_DM07M-KZUML IS INITIAL.
    IT_MATVP-PLIFZ = I_DM07M-UMPLI.
    IT_MATVP-EISBE = I_DM07M-UMEIS.
    IT_MATVP-WEBAZ = I_DM07M-UMWEB.
    IT_MATVP-WZEIT = I_DM07M-UMWZE.
    IT_MATVP-BESKZ = I_DM07M-UMBES.
    IT_MATVP-UMLMC = I_DM07M-UMUML.
*    IT_MATVP-WERKS = F_WERKS.
*    IT_MATVP-MATNR = F_MATNR.
  ENDIF.

  CALL FUNCTION 'MISSING_PARTS_CHECK'
    EXPORTING
      EMATVP            = IT_MATVP
      PRREG             = I_DM07M-PRREG
*     KDAUF             = MAT_KDAUF                          "NOTE 212303
*     KDPOS             = MAT_KDPOS                          "NOTE 212303
*     PSPEL             = MAT_PSPNR                          "NOTE 212303
    IMPORTING
      IMEMPF            = I_VM07M-DUSER
    TABLES
      ATPSLX            = XTFEHL
    EXCEPTIONS
      NO_ENTRY_IN_T441V = 01
      ERROR_MESSAGE     = 01.

  IF SY-SUBRC = 01.
*        PERFORM NACO_ERMITTELN_V4 USING 'M7' '142'
*                                  DM07M-PRREG MATVP-MTVFP SPACE SPACE.
  ENDIF.

  IF NOT  XTFEHL[] IS INITIAL.


    CONCATENATE 'MISSING PART HAS ARRIVED, MATERIAL' I_MSEG-MATNR  INTO TEXT SEPARATED BY SPACE.
***********************************************************************
*POPULATING SUBJECT LINE.
    WA_DOCUMENT_DATA-OBJ_DESCR ='MISSING PART HAS ARRIVED'.
*POPULATING MAIN BODY.
    WA_OBJECT_CONTENT-LINE = TEXT.
    APPEND WA_OBJECT_CONTENT TO IT_OBJECT_CONTENT.
    CLEAR WA_OBJECT_CONTENT.
*ASSIGNNING RECEIVERI.I.E.TO WHOM TO SEND.
    WA_RECEIVERS-REC_TYPE = 'B' ."'U'.
    WA_RECEIVERS-RECEIVER =  SY-UNAME . "I_VM07M-DUSER.
    APPEND WA_RECEIVERS TO IT_RECEIVERS.
    CLEAR WA_RECEIVERS.
***********************************************************************

    CALL FUNCTION 'SO_NEW_DOCUMENT_SEND_API1'
      EXPORTING
        DOCUMENT_DATA              = WA_DOCUMENT_DATA
      IMPORTING
        NEW_OBJECT_ID              = NEW_OBJECT_ID
      TABLES
        OBJECT_CONTENT             = IT_OBJECT_CONTENT
        RECEIVERS                  = IT_RECEIVERS
      EXCEPTIONS
        TOO_MANY_RECEIVERS         = 1
        DOCUMENT_NOT_SENT          = 2
        DOCUMENT_TYPE_NOT_EXIST    = 3
        OPERATION_NO_AUTHORIZATION = 4
        PARAMETER_ERROR            = 5
        X_ERROR                    = 6
        ENQUEUE_ERROR              = 7.
    CLEAR: TEXT.
    CLEAR: WA_DOCUMENT_DATA,WA_OBJECT_CONTENT,WA_RECEIVERS.
    CLEAR: IT_OBJECT_CONTENT,IT_RECEIVERS,NEW_OBJECT_ID.
  ENDIF.

  DATA : LV_EBELN TYPE EKKO-EBELN.
  DATA : WA_EKKO TYPE EKKO.
  DATA : WA_EKPO1 TYPE EKPO.

  TYPES: BEGIN OF TY_MARA,
           MATNR TYPE MARA-MATNR,
           MTART TYPE MARA-MTART,
         END OF TY_MARA.

  DATA: IT_MARA TYPE TABLE OF TY_MARA,
        WA_MARA TYPE          TY_MARA.


  IF SY-TCODE = 'MIGO'."'MB1B'.

    SELECT MATNR
           MTART FROM MARA INTO TABLE IT_MARA
           WHERE MATNR = I_MSEG-MATNR.
    READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = I_MSEG-MATNR.
    IF SY-SUBRC = 0.


      IF I_MSEG-BWART = '541' OR I_MSEG-BWART = '542' AND WA_MARA-MTART NE 'UNBW'.
        IF I_MSEG-EBELN IS INITIAL OR I_MSEG-EBELP IS INITIAL.
          MESSAGE 'Enter the subcontracting PO number and Line Item' TYPE 'I' DISPLAY LIKE 'E'.
          SET SCREEN SY-DYNNR.
          LEAVE SCREEN.
        ELSE.

          SELECT SINGLE * FROM EKKO INTO WA_EKKO WHERE EBELN = I_MSEG-EBELN.
          IF SY-SUBRC = 0.

            IF WA_EKKO-FRGKE = 'X'.
*          CLEAR i_mkpf-bktxt.
              MESSAGE E390(ME) WITH I_MSEG-EBELN.
              EXIT.

            ENDIF.
*      ELSE.
*        CLEAR i_mkpf-bktxt.
*        MESSAGE e030(m7) WITH lv_ebeln.
*        EXIT.

          ENDIF.
*
*      select SINGLE * FROM ekpo INTO wa_ekpo1 WHERE ebeln = lv_ebeln.
*        if sy-subrc = 0.
*          if wa_ekpo1-pstyp ne '3'.
*
*         MESSAGE e903(m7) WITH lv_ebeln.
*
*         endif.
*         endif.

        ENDIF.
*    IF i_mseg-wempf IS INITIAL .
*
*      MESSAGE 'Enter PO line item number in Goods recipient field' TYPE 'I' DISPLAY LIKE 'E'.
*      SET SCREEN sy-dynnr.
*      LEAVE SCREEN.
*    ENDIF.

      ENDIF.

    ENDIF.
  ENDIF.


********************************************************* Added By Abhay 24.04.2017  *********************************************************

  IF SY-TCODE = 'MB1B' OR SY-TCODE = 'MIGO'.

    TYPES : BEGIN OF TY_HDR,
              TRNTYP TYPE J_1ITRNTYP,
              WERKS  TYPE WERKS_D,
              EXNUM  TYPE J_1IEXCNUM,
              EXDAT  TYPE J_1IEXCDAT,
              STATUS TYPE J_1ISTATUS,
            END OF TY_HDR.

    DATA : GT_HDR TYPE TABLE OF TY_HDR,
           WA_HDR TYPE TY_HDR.

    DATA : LV_DATE TYPE SY-DATUM.

    DATA : GT_VAL TYPE TABLE OF ZMIGO_VAL,
           WA_VAL TYPE ZMIGO_VAL.



    IF I_MSEG-BWART = '541' .

      SELECT TRNTYP WERKS EXNUM EXDAT STATUS FROM J_1IEXCHDR
        INTO TABLE GT_HDR
        WHERE TRNTYP = '57FC'
        AND   STATUS NE 'C'.

      IF SY-SUBRC = 0.

        SELECT WERKS ZDAYS FROM ZMIGO_VAL
          INTO CORRESPONDING FIELDS OF TABLE GT_VAL
          FOR ALL ENTRIES IN GT_HDR
          WHERE WERKS = GT_HDR-WERKS.

      ENDIF.


      LOOP AT GT_HDR INTO WA_HDR.

        READ TABLE GT_VAL INTO WA_VAL WITH KEY WERKS = WA_HDR-WERKS.

        IF SY-SUBRC = 0.

          LV_DATE = WA_HDR-EXDAT + WA_VAL-ZDAYS.

          IF LV_DATE LT SY-DATUM.

            MESSAGE E042(ZDEL) WITH WA_HDR-EXNUM WA_VAL-ZDAYS.

          ENDIF.

        ENDIF.

      ENDLOOP.

    ENDIF.
  ENDIF.

************************************ End of code by Abhay 25.04.2017*******************************************************************************

  """""""""""""""""""""""""""""""""    Added By KD 04.05.2017           """"""""""""""""""""""""""""""""""

  IF SY-TCODE = 'MIGO'."'MB1B'.

    TYPES : BEGIN OF TY_RESB,
              MATNR TYPE RESB-MATNR,
              WERKS TYPE RESB-WERKS,
              BDMNG TYPE RESB-BDMNG,
              EBELN TYPE RESB-EBELN,
              EBELP TYPE RESB-EBELP,
            END OF TY_RESB.

*  TYPES : BEGIN OF ty_mkpf,
*            mblnr TYPE mkpf-mblnr,
*            mjahr TYPE mkpf-mjahr,
*            bktxt TYPE mkpf-bktxt,
*          END OF ty_mkpf.

    TYPES : BEGIN OF TY_MSEG,
              MBLNR TYPE MSEG-MBLNR,
              MJAHR TYPE MSEG-MJAHR,
              BWART TYPE MSEG-BWART,
              XAUTO TYPE MSEG-XAUTO,
              MATNR TYPE MSEG-MATNR,
              WERKS TYPE MSEG-WERKS,
              MENGE TYPE MSEG-MENGE,
              EBELN TYPE MSEG-EBELN,
              EBELP TYPE MSEG-EBELP,
            END OF TY_MSEG.


    DATA : IT_RESB  TYPE TABLE OF TY_RESB,
           WA_RESB  TYPE TY_RESB,
*         it_mkpf  TYPE TABLE OF ty_mkpf,
*         wa_mkpf  TYPE ty_mkpf,
           IT_MSEG  TYPE TABLE OF TY_MSEG,
           WA_MSEG  TYPE TY_MSEG,
           LV_MENGE TYPE MSEG-MENGE,
           LV_TEXT  TYPE CHAR10.

    IF I_MSEG-BWART = '541' OR I_MSEG-BWART = '542'.

      SELECT MATNR
             WERKS
             BDMNG
             EBELN
             EBELP FROM RESB INTO TABLE IT_RESB WHERE EBELN = I_MSEG-EBELN
                                                  AND EBELP = I_MSEG-EBELP.


      SELECT MBLNR
             MJAHR
             BWART
             XAUTO
             MATNR
             WERKS
             MENGE
             EBELN
             EBELP FROM MSEG INTO TABLE IT_MSEG
                                 WHERE EBELN = I_MSEG-EBELN
                                   AND EBELP = I_MSEG-EBELP
*                                 AND xauto = 'X'
                                   AND MATNR = I_MSEG-MATNR .

      IF I_MSEG-BWART = '541' .
        DELETE IT_MSEG WHERE XAUTO NE 'X' .
      ENDIF.

    ENDIF.
    CLEAR WA_MSEG .
    LOOP AT IT_MSEG INTO WA_MSEG.
      IF WA_MSEG-BWART = 541 AND WA_MSEG-XAUTO = 'X'.
        LV_MENGE = LV_MENGE + WA_MSEG-MENGE .
      ELSEIF WA_MSEG-BWART = 542 AND WA_MSEG-XAUTO = 'X'.
        LV_MENGE = LV_MENGE - WA_MSEG-MENGE .
      ELSEIF ( I_MSEG-BWART = 542 AND WA_MSEG-BWART = 543 ).
        LV_MENGE = LV_MENGE - WA_MSEG-MENGE .
      ENDIF.
    ENDLOOP.

    IF I_MSEG-BWART = '541'.
      READ TABLE IT_RESB INTO WA_RESB WITH KEY MATNR = I_MSEG-MATNR .

      IF WA_RESB-BDMNG IS NOT INITIAL.
        LV_MENGE = WA_RESB-BDMNG - LV_MENGE .
      ENDIF.

      """""""   Quantity & Unit Of measure   """""""
      LV_TEXT = LV_MENGE .
      CONDENSE LV_TEXT .
      CONCATENATE LV_TEXT I_MSEG-MEINS INTO LV_TEXT SEPARATED BY ' '.


      IF I_MSEG-ERFMG GT LV_MENGE.
***        MESSAGE E043(ZDEL) WITH I_MSEG-MATNR LV_TEXT I_MKPF-BKTXT I_MSEG-WEMPF." DISPLAY LIKE 'E'. """ NC
      SET SCREEN sy-dynnr.
*      LEAVE SCREEN.
      ELSEIF LV_MENGE = 0 .
        MESSAGE E044(ZDEL) WITH I_MSEG-MATNR I_MSEG-EBELN." DISPLAY LIKE 'E'.  """" NC
*      SET SCREEN sy-dynnr.
*      LEAVE SCREEN.
      ENDIF.
    ELSEIF  I_MSEG-BWART = '542'.
      LV_TEXT = LV_MENGE .
      IF LV_MENGE = 0 .
        MESSAGE I045(ZDEL) WITH I_MSEG-MATNR I_MSEG-EBELN." DISPLAY LIKE 'E'.
*      SET SCREEN SY-DYNNR.
*      LEAVE SCREEN.
      ELSEIF I_MSEG-ERFMG GT LV_MENGE.

        IF SY-UNAME EQ 'DPANDIT'.
          MESSAGE W046(ZDEL) WITH LV_TEXT I_MSEG-MATNR I_MSEG-EBELN.
        ELSEIF SY-UNAME NE 'DPANDIT'.
          MESSAGE E046(ZDEL) WITH LV_TEXT I_MSEG-MATNR I_MSEG-EBELN." DISPLAY LIKE 'E'.
          SET SCREEN SY-DYNNR.
          LEAVE SCREEN.
        ENDIF.
      ENDIF.
    ENDIF .
  ENDIF .
ENDIF .

"""""""""""""""""""""""""""""""""             END                      """""""""""""""""""""""""""""""""

*DATA : lv_bsart TYPE ekko-bsart.
*
*FIELD-SYMBOLS : <F1> TYPE bseg-hkont.        "Field Symbol for GL Account
*DATA : lv_konto(50) VALUE '(SAPMM07M)DM07M-KONTO'.
*
*IF i_mseg-bukrs = '1000'.
*
*  SELECT SINGLE bsart
*                FROM ekko
*                INTO lv_bsart
*                WHERE ebeln = i_mseg-ebeln
*                AND   bukrs = i_mseg-bukrs.
*
*     IF lv_bsart = 'ZAST'.
*      ASSIGN (lv_konto) TO <F1>.
*      MOVE '0000280980' TO <F1>.
*     ENDIF.
*
*ENDIF.
********************* commented by sagar dev 09/11/2022
*
*BREAK-POINT.
*Data: yy(4) type c,
*xblnr1 type mkpf-xblnr,
*bwart1 type mseg-bwart ,
*text1 type string ,
*ref_goitem type goitem ,
*bwart2 type goitem-bwart,
** GOHEAD-LFSNR(15),
*ebeln type mseg-ebeln.
*"pt_goitem TYPE goitem.
*
*
*if sy-tcode = 'MIGO' .
*  IF I_MKPF-xblnr IS INITIAL.
*    MESSAGE 'Maintain Delivery note NO' type 'E'.
*
*  ENDIF.
*yy = i_mkpf-budat(4).
*select single mkpf~xblnr mseg~bwart into (xblnr1 ,bwart1 ) from mkpf inner join mseg on mkpf~mblnr = mseg~mblnr and mkpf~mjahr = mseg~mjahr
*where mkpf~mjahr = yy
*and mseg~lifnr = i_mseg-lifnr
*and mkpf~xblnr = i_mkpf-xblnr
*and mseg~bwart = '101'.
*
*
*if sy-subrc = 0.
*if i_mseg-bwart = '101'.
*  IF sy-uname = 'PRIMUS'.
*              MESSAGE w014(mick) ."'Delivery note NO is already exist' type 'W'. "MESSAGE e047(zdel) DISPLAY LIKE 'W'.
*  ELSE.
*      MESSAGE 'Delivery note NO is already exist' type 'E'.
*  endif.
*endif.
*endif.
*if e_sgtxt is INITIAL.
* e_sgtxt = i_mseg-sgtxt.
*endif.
**ref_goitem = pt_goitem.
*endif.
