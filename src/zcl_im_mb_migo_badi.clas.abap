class ZCL_IM_MB_MIGO_BADI definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_MB_MIGO_BADI .

  types:
    tt_goitem TYPE STANDARD TABLE OF goitem WITH EMPTY KEY .

  data IT_HEADER type BAPIRET2_T .
  data IT_GOITEM type TT_GOITEM .
  data WA_GOITEM type GOITEM .
protected section.
private section.

  types WA_CS_ITEM type GOITEM .
ENDCLASS.



CLASS ZCL_IM_MB_MIGO_BADI IMPLEMENTATION.


  method IF_EX_MB_MIGO_BADI~CHECK_HEADER.

  endmethod.


 METHOD if_ex_mb_migo_badi~check_item.

   DATA : lv_menge     TYPE mseg-menge,
          lv_menge_new TYPE mseg-menge.

   DATA : lv_tot_menge TYPE mseg-menge,
          lv_chln_qty  TYPE j_1ig_subcon-chln_inv,
          lv_vbeln     TYPE vbrp-vbeln.
   DATA : lv_val TYPE char1.

   BREAK ctplmm.

   DATA: lv_goitem(20) VALUE '(SAPLMIGO)GOITEM'.
   FIELD-SYMBOLS: <fs_goitem>   TYPE goitem .
   ASSIGN (lv_goitem) TO <fs_goitem> .
   DATA(lv_goitem2) = <fs_goitem>.



   "begin of code added by sagar darade on 13.09.2026 "Error 'Check vendor material and challan NO' changed to Information for TVRAVC users.

   DATA: lv_bypass TYPE c.

   SELECT SINGLE low
     INTO @DATA(lv_user)
     FROM tvarvc
    WHERE name = 'ZMM_542_CHALLAN'
      AND low  = @sy-uname.

   IF sy-subrc = 0.
     lv_bypass = 'X'.
   ENDIF.


   "end of code added by sagar darade on 13.09.2026 "Error 'Check vendor material and challan NO' changed to Information for TVRAVC users.




   CLEAR : lv_tot_menge,lv_chln_qty,lv_menge,lv_menge_new.
   FIELD-SYMBOLS: <fs_godynpro> TYPE godynpro.
*    FIELD-SYMBOLS: <FS_GOITEM> TYPE ANY TABLE .

   ASSIGN ('(SAPLMIGO)GODYNPRO') TO <fs_godynpro>.
*    ASSIGN ('(SAPLMIGO)GOITEM') TO <FS_GOITEM>.

   IF <fs_godynpro> IS ASSIGNED.
     DATA: lv_action TYPE char5.
     DATA: lv_refdoc TYPE char5.

     CLEAR : lv_action,lv_refdoc .

     lv_action = <fs_godynpro>-action.
     lv_refdoc = <fs_godynpro>-refdoc.
     " Use lv_action which contains the value of GODYNPRO-ACTION

     EXPORT lv_action FROM lv_action TO MEMORY ID 'LV_ACTION'.
     EXPORT lv_refdoc FROM lv_refdoc TO MEMORY ID 'LV_REFDOC'.

   ENDIF.

   ASSIGN ('(SAPLMIGO)GODYNPRO') TO <fs_godynpro>.

   IF <fs_godynpro> IS ASSIGNED.
     lv_action = <fs_godynpro>-action.
     " Your logic using lv_action
   ENDIF.


   DATA: wa_bapi TYPE bapiret2 .
   DATA : lv_zeile TYPE goitem-zeile .

   READ TABLE it_goitem INTO DATA(wa_gi) WITH KEY global_counter = i_line_id .
   IF sy-subrc EQ 0 .
     IF wa_gi-ebeln IS NOT INITIAL .
       IF wa_gi-ebelp IS  INITIAL .
         wa_bapi-type        = 'E'.
         wa_bapi-id          = 'ZMM' .
         wa_bapi-number      = '000' .
         wa_bapi-message     = 'Please enter Purchase Item.' .
         wa_bapi-row         = wa_gi-zeile .
         wa_bapi-field       =  'Purchase Item' .
         APPEND wa_bapi TO  et_bapiret2 .
       ENDIF.
     ENDIF.

     CLEAR : lv_val .
     IF <fs_godynpro>-action = 'A08'  AND <fs_godynpro>-refdoc = 'R01' .
       lv_val = 'X'.
     ELSEIF <fs_godynpro>-action = 'A03'  AND <fs_godynpro>-refdoc = 'R02' .
       lv_val = 'X'.
     ENDIF.


     IF sy-tcode = 'MIGO' AND wa_gi-bwart = '542'.
       IF  lv_val NE 'X' .
*          IF <FS_GODYNPRO>-REFDOC NE 'R01' .
         SELECT matnr,
                mtart
                FROM mara
                INTO TABLE @DATA(it_mara)
                WHERE matnr = @wa_gi-matnr.

         READ TABLE it_mara INTO DATA(wa_mara) WITH KEY matnr = wa_gi-matnr.

         IF ( wa_mara-mtart = 'UNBW' OR wa_mara-mtart = 'ZCON') .


           IF wa_gi-sgtxt IS INITIAL.

             wa_bapi-type        = 'E'.
             wa_bapi-id          = 'ZMM' .
             wa_bapi-number      = '001' .
*            WA_BAPI-MESSAGE     = 'Maintain challan NO' .
             wa_bapi-row         = wa_gi-zeile .
             wa_bapi-field       = 'Text' .
             APPEND wa_bapi TO  et_bapiret2 .
*            MESSAGE 'Maintain challan NO' TYPE 'E'.
           ENDIF.
         ENDIF.

         SELECT matnr     ,
                lifnr     ,
                chln_inv  ,
                menge
                FROM j_1ig_subcon
                INTO TABLE @DATA(it_j_1ig_subcon)
                WHERE matnr = @wa_gi-matnr
*               AND   LIFNR = @WA_GI-LIFNR
                AND   lifnr = @wa_gi-ummat_lifnr
                AND   chln_inv = @wa_gi-sgtxt.

         READ TABLE it_j_1ig_subcon INTO DATA(wa_j_1ig_subcon) WITH KEY matnr    = wa_gi-matnr
                                                                  lifnr          = wa_gi-ummat_lifnr
                                                                  chln_inv       = wa_gi-sgtxt.
         IF sy-subrc = 0.
           lv_chln_qty = wa_j_1ig_subcon-menge.
         ENDIF.
         IF sy-subrc = 4.
"begin of code added by sagar darade on 13.09.2026 "Error 'Check vendor material and challan NO' changed to Information for TVRAVC users.
           IF lv_bypass = 'X'.
             wa_bapi-type = 'I'.
           ELSE.
             wa_bapi-type = 'E'.
           ENDIF.
"end of code added by sagar darade on 13.09.2026 "Error 'Check vendor material and challan NO' changed to Information for TVRAVC users.
*
*          wa_bapi-type        = 'E'. Commented by sagar darade on 13.03.206
           wa_bapi-id          = 'ZMM' .
           wa_bapi-number      = '002' .
*          WA_BAPI-MESSAGE     = 'Maintain challan NO' .
           wa_bapi-row         = wa_gi-zeile .
           wa_bapi-field       = 'Text' .
           APPEND wa_bapi TO  et_bapiret2 .
*          MESSAGE 'check vendor material and challan NO' TYPE 'E'.
         ELSE.
           SELECT mblnr    ,
                  mjahr    ,
                  zeile    ,
                  bwart    ,
                  xauto    ,
                  matnr    ,
                  werks    ,
                  lifnr    ,
                  shkzg    ,
                  menge    ,
                  sgtxt
                  FROM mseg
                  INTO TABLE @DATA(lt_mseg)
                  WHERE bwart IN ('541','542')
                  AND   xauto = ''
                  AND   matnr = @wa_gi-matnr
                  AND   werks = @wa_gi-werks
                  AND   lifnr = @wa_gi-ummat_lifnr
                  AND   sgtxt = @wa_gi-sgtxt.
*                 AND   shkzg = 'S'.
           SORT lt_mseg ASCENDING  BY mblnr.
           SELECT mblnr  ,
                  mjahr  ,
                  zeile  ,
                  bwart  ,
                  xauto  ,
                  matnr  ,
                  werks  ,
                  lifnr  ,
                  shkzg  ,
                  menge  ,
                  sgtxt
                  FROM mseg
                  INTO TABLE @DATA(lt_mseg_new)
                  WHERE bwart IN ('541','542')
                  AND   xauto = ''
                  AND   matnr = @wa_gi-matnr
                  AND   werks = @wa_gi-werks
*                  AND   LIFNR = @WA_GI-LIFNR
                  AND   lifnr = @wa_gi-ummat_lifnr
                  AND   sgtxt = @wa_gi-sgtxt
                  AND   shkzg = 'H'.

           lv_vbeln = wa_gi-sgtxt.

           SELECT SINGLE fkimg INTO @DATA(lv_fkimg) FROM vbrp
             WHERE         vbeln = @lv_vbeln
                     AND   matnr = @wa_gi-matnr
                     AND   werks = @wa_gi-werks
                     AND   vkorg_auft = @wa_gi-bukrs.

           IF lt_mseg IS INITIAL.
             IF lv_fkimg IS NOT INITIAL.
               IF wa_gi-menge <= lv_fkimg.

               ELSE.
                 wa_bapi-type        = 'E'.
                 wa_bapi-id          = 'ZMM' .
                 wa_bapi-number      = '003' .
*                WA_BAPI-MESSAGE     = 'Maintain challan NO' .
                 wa_bapi-row         = wa_gi-zeile .
                 wa_bapi-field       = 'Text' .
                 APPEND wa_bapi TO  et_bapiret2 .
*                MESSAGE 'Quntity is greater than challan qty' TYPE 'E'.
               ENDIF.
             ENDIF.
           ELSE.
             LOOP AT lt_mseg INTO DATA(ls_mseg).

               IF ls_mseg-bwart = '541'.

                 lv_menge_new = lv_menge_new + ls_mseg-menge.
                 lv_menge = lv_menge - lv_menge_new.
*                 lv_menge = lv_menge * -1.
               ELSE.
                 lv_menge = lv_menge + ls_mseg-menge.
               ENDIF.

*              READ TABLE it_mseg INTO DATA(ls_mseg1) WITH KEY matnr = ls_mseg-matnr
*                                                              bwart = ls_mseg-bwart
*                                                              shkzg = ls_mseg-shkzg.
*              DATA(tot_chal_menge) = lv_menge + ls_mseg1-menge.
             ENDLOOP.
             IF lv_menge < '0'.
               lv_menge = lv_menge * -1.
               DATA(tot_chal_menge) = lv_menge.
             ELSE.
               tot_chal_menge = lv_menge.
               tot_chal_menge = tot_chal_menge +  wa_gi-menge.
             ENDIF.
             IF tot_chal_menge > lv_chln_qty.
               wa_bapi-type        = 'E'.
               wa_bapi-id          = 'ZMM' .
               wa_bapi-number      = '004' .
*          WA_BAPI-MESSAGE     = 'Maintain challan NO' .
               wa_bapi-row         = wa_gi-zeile .
               wa_bapi-field       = 'Text' .
               APPEND wa_bapi TO  et_bapiret2 .

*              MESSAGE 'Quntity is greater than challan qty' TYPE 'E'.
             ENDIF.
           ENDIF.

         ENDIF.
       ENDIF.
*        ENDIF.
     ENDIF.

   ENDIF.


   """""""""""""""""""""""" Validate Sales Order Line Item """""""""""""""""""""""""""""""""""""""


   IF <fs_godynpro>-action = 'A08' AND <fs_godynpro>-refdoc = 'R10'  AND ( <fs_godynpro>-sobkz = 'E' OR lv_goitem2-sobkz = 'E' )
      AND   lv_goitem2-bwart = 'Z11' .

*     IF  LV_GOITEM2-MAT_KDPOS  NE   LV_GOITEM2-UMMAT_KDPOS .
*
*       WA_BAPI-TYPE        = 'E'.
*       WA_BAPI-ID          = 'ZMM' .
*       WA_BAPI-NUMBER      = '005' .
**          WA_BAPI-MESSAGE     = 'Maintain challan NO' .
*       WA_BAPI-ROW         = LV_GOITEM2-ZEILE .
*       WA_BAPI-FIELD       = 'Text' .
*       APPEND WA_BAPI TO  ET_BAPIRET2 .
*
*     ENDIF.


*     LOOP AT IT_GOITEM INTO WA_GI .
     IF  wa_gi-ummat_kdpos NE wa_gi-mat_kdpos .
       wa_bapi-type        = 'E'.
       wa_bapi-id          = 'ZMM' .
       wa_bapi-number      = '005' .
*          WA_BAPI-MESSAGE     = 'Maintain challan NO' .
       wa_bapi-row         = lv_goitem2-zeile .
       wa_bapi-field       = 'Text' .
       APPEND wa_bapi TO  et_bapiret2 .
       CLEAR : wa_gi .
     ENDIF.
*     ENDLOOP.


   ENDIF.






   CLEAR : lv_goitem2 .






   """""""""""""""""""""""" Validate Sales Order Line Item """""""""""""""""""""""""""""""""""""""


 ENDMETHOD.


  method IF_EX_MB_MIGO_BADI~HOLD_DATA_DELETE.
  endmethod.


  method IF_EX_MB_MIGO_BADI~HOLD_DATA_LOAD.
  endmethod.


  method IF_EX_MB_MIGO_BADI~HOLD_DATA_SAVE.
  endmethod.


  method IF_EX_MB_MIGO_BADI~INIT.

  endmethod.


  method IF_EX_MB_MIGO_BADI~LINE_DELETE.
  endmethod.


  METHOD IF_EX_MB_MIGO_BADI~LINE_MODIFY.

    READ TABLE IT_GOITEM INTO DATA(WA_DT) WITH KEY EBELN = CS_GOITEM-EBELN
                                                   EBELP = CS_GOITEM-EBELP
                                                   ZEILE = CS_GOITEM-ZEILE.

    IF SY-SUBRC EQ 0 .
      LOOP AT IT_GOITEM  INTO DATA(WA_IT)  WHERE EBELN = CS_GOITEM-EBELN
                                                   AND   EBELP = CS_GOITEM-EBELP
                                                   AND   ZEILE = CS_GOITEM-ZEILE.

        MOVE-CORRESPONDING CS_GOITEM to WA_IT.

        WA_IT-EBELP = CS_GOITEM-EBELP .
        WA_IT-SGTXT = CS_GOITEM-SGTXT .
        WA_IT-BWART = CS_GOITEM-BWART .
        WA_IT-MATNR = CS_GOITEM-MATNR .
        WA_IT-UMMAT_LIFNR = CS_GOITEM-UMMAT_LIFNR .
        WA_IT-UMMAT_KDPOS = CS_GOITEM-UMMAT_KDPOS .
        WA_IT-MAT_KDPOS = CS_GOITEM-MAT_KDPOS .
        MODIFY IT_GOITEM FROM WA_IT TRANSPORTING  MAT_KDPOS UMMAT_KDPOS EBELP SGTXT BWART MATNR MENGE ZEILE BWART MATNR LIFNR WERKS UMMAT_LIFNR.

      ENDLOOP.
    ELSE.

      APPEND CS_GOITEM TO IT_GOITEM .

    ENDIF.
    WA_GOITEM = CS_GOITEM .



  ENDMETHOD.


  method IF_EX_MB_MIGO_BADI~MAA_LINE_ID_ADJUST.
  endmethod.


  method IF_EX_MB_MIGO_BADI~MODE_SET.

  endmethod.


  method IF_EX_MB_MIGO_BADI~PAI_DETAIL.
  endmethod.


  METHOD IF_EX_MB_MIGO_BADI~PAI_HEADER.
*
*
*    FIELD-SYMBOLS: <FS_GODYNPRO> TYPE GODYNPRO.
*    ASSIGN ('(SAPLMIGO)GODYNPRO') TO <FS_GODYNPRO>.
**
*    IF <FS_GODYNPRO> IS ASSIGNED.
**        DATA: LV_ACTION TYPE SY-SUBRC.
**       , LV_ACTION = <FS_GODYNPRO>-ACTION.
*      " Use lv_action which contains the value of GODYNPRO-ACTION
*      IF <FS_GODYNPRO>-PO_NUMBER IS NOT INITIAL.
*        IF <FS_GODYNPRO>-PO_ITEM IS INITIAL .
*
*    ENDIF.
*    ENDIF.
*    ENDIF.



  ENDMETHOD.


  method IF_EX_MB_MIGO_BADI~PBO_DETAIL.
  endmethod.


  method IF_EX_MB_MIGO_BADI~PBO_HEADER.
* DATA: i_action TYPE GODYNPRO-ACTION,
*       i_refdoc TYPE GODYNPRO-REFDOC.
*    BREAK fujiabap.
*   IF sy-tcode = 'MIGO'.
*     i_action = 'A02'.
*     i_refdoc = 'R02'.
*   ENDIF.


  endmethod.


  METHOD IF_EX_MB_MIGO_BADI~POST_DOCUMENT.
*   if sy-ucomm = 'MIGO'.
*    BREAK PRIMUSABAP.
*   ENDIF.
    DATA: YY(4)      TYPE C,
          XBLNR1     TYPE MKPF-XBLNR,
          FRBNR1     TYPE MKPF-FRBNR,
          BWART1     TYPE MSEG-BWART,
          TEXT1      TYPE STRING,
          REF_GOITEM TYPE GOITEM,
          BWART2     TYPE GOITEM-BWART,
          I_MSEG     TYPE MSEG,
          EBELN      TYPE MSEG-EBELN,
          LV_BNAME   TYPE ZHEAD_USER-BNAME.

    TYPES : BEGIN OF TY_MSEG,
              MBLNR TYPE MSEG-MBLNR,
              MJAHR TYPE MSEG-MJAHR,
              ZEILE TYPE MSEG-ZEILE,
              BWART TYPE MSEG-BWART,
              XAUTO TYPE MSEG-XAUTO,
              MATNR TYPE MSEG-MATNR,
              WERKS TYPE MSEG-WERKS,
              LIFNR TYPE MSEG-LIFNR,
              SHKZG TYPE MSEG-SHKZG,
              MENGE TYPE MSEG-MENGE,
              SGTXT TYPE MSEG-SGTXT,
            END OF TY_MSEG.

    TYPES : BEGIN OF TY_VBRP,
              VBELN TYPE VBRP-VBELN,
              POSNR TYPE VBRP-POSNR,
              FKIMG TYPE VBRP-FKIMG,
              MATNR TYPE VBRP-MATNR,
            END OF TY_VBRP.
    DATA: LT_VBRP  TYPE STANDARD TABLE OF TY_VBRP,
          LS_VBRP  TYPE TY_VBRP,
          LV_VBELN TYPE VBRP-VBELN,
          LV_FKIMG TYPE VBRP-FKIMG.

    DATA : LT_MSEG     TYPE STANDARD TABLE OF TY_MSEG,
           LS_MSEG     TYPE TY_MSEG,
           LT_MSEG_NEW TYPE STANDARD TABLE OF TY_MSEG,
           LS_MSEG_NEW TYPE TY_MSEG.

    DATA : LV_MENGE     TYPE MSEG-MENGE,
           LV_MENGE_NEW TYPE MSEG-MENGE.

    DATA : LV_TOT_MENGE TYPE MSEG-MENGE,
           LV_CHLN_QTY  TYPE J_1IG_SUBCON-CHLN_INV.


*************************Below Enhancement for Green channal Supply ******************
**********Warning message for GREEN SUPPLY & NON-GREEN SUPPLY MATERIAL FOUND IN THIS TRANSACTION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&Transaction
*&Functional Cosultant: MEghana
*&Technical Consultant: Jyoti MAhajan/ Komal Shende
* &Date: 1. 14/1/2025
*&Owner: DelVal Flow Controls
    IF SY-TCODE = 'MIGO'.
      """""""""""""""""""" Added By NC """"""""""""""""""""""""""""""""""""
*
*      FIELD-SYMBOLS: <FS_GODYNPRO> TYPE GODYNPRO.
*      FIELD-SYMBOLS: <FS_GOITEM> TYPE ANY TABLE .
*
*      ASSIGN ('(SAPLMIGO)GODYNPRO') TO <FS_GODYNPRO>.
*
*     IF <FS_GODYNPRO> IS ASSIGNED.
*        DATA: LV_ACTION TYPE SY-SUBRC.
*        LV_ACTION = <FS_GODYNPRO>-ACTION.
*        " Use lv_action which contains the value of GODYNPRO-ACTION
*      ENDIF.
*
*      ASSIGN ('(SAPLMIGO)GODYNPRO') TO <FS_GODYNPRO>.
*
*      IF <FS_GODYNPRO> IS ASSIGNED.
*        LV_ACTION = <FS_GODYNPRO>-ACTION.
*        " Your logic using lv_action
*      ENDIF.


*    BREAK PRIMUSABAP.
      DATA(CLASS) = 'ZDELVAL_MESSAGE' .
      READ TABLE IT_MSEG INTO I_MSEG  INDEX 1.
      IF I_MSEG-BUKRS = '1000'.
        DATA: IT_EKPO2 TYPE TABLE OF EKPO.
*data: it_ekpo2 type table of ekpo.
        DATA: IT_EKPO3 TYPE TABLE OF EKPO.
        CONSTANTS: GV_YES TYPE CHAR3 VALUE 'YES',
                   GV_NO  TYPE CHAR2 VALUE 'NO'.

        SELECT EBELN
               EBELP
               ZGREEN_FLD  FROM EKPO
                           INTO CORRESPONDING FIELDS OF TABLE IT_EKPO2
                           FOR ALL ENTRIES IN IT_MSEG
                           WHERE ZGREEN_FLD = GV_YES
                           AND  EBELN = IT_MSEG-EBELN.



        SELECT EBELN
               EBELP
               ZGREEN_FLD  FROM EKPO
                           INTO CORRESPONDING FIELDS OF TABLE IT_EKPO3
                           FOR ALL ENTRIES IN IT_MSEG
                           WHERE ZGREEN_FLD = GV_NO
                           AND  EBELN = IT_MSEG-EBELN.



        IF IT_EKPO2 IS NOT INITIAL AND IT_EKPO3 IS NOT INITIAL.
          MESSAGE 'GREEN SUPPLY & NON-GREEN SUPPLY MATERIAL FOUND IN THIS TRANSACTION' TYPE 'I' DISPLAY LIKE 'W'.
        ENDIF.

      ENDIF.

      READ TABLE IT_MSEG INTO I_MSEG INDEX 1.
      IF SY-SUBRC = 0.
        I_MSEG-INSMK = 'F'.

* MODIFY TABLE IT_MSEG FROM I_MSEG TRANSPORTING INSMK.
      ENDIF.
    ENDIF.

    IF SY-UCOMM = 'OK_CHECK'.
      BREAK PRIMUSABAP.
    ENDIF.

* BREAK PRIMUSABAP.
    READ TABLE IT_MSEG INTO I_MSEG  INDEX 1.
    IF I_MSEG-BUKRS = '1000'.
*      break primusabap.
      IF SY-TCODE = 'MIGO' AND I_MSEG-BWART = '101'.
        IF IS_MKPF-XBLNR IS INITIAL.
          MESSAGE 'Maintain Delivery note NO' TYPE 'E'.
        ENDIF.

        YY = IS_MKPF-BUDAT(4).
        SELECT SINGLE MKPF~XBLNR MSEG~BWART INTO (XBLNR1 ,BWART1 ) FROM MKPF INNER JOIN MSEG ON MKPF~MBLNR = MSEG~MBLNR AND MKPF~MJAHR = MSEG~MJAHR
        WHERE MKPF~MJAHR = YY
        AND MSEG~LIFNR = I_MSEG-LIFNR
        AND MKPF~XBLNR = IS_MKPF-XBLNR
        AND MSEG~BWART = '101'.

        IF SY-SUBRC = 0.

          SELECT SINGLE BNAME FROM ZHEAD_USER INTO LV_BNAME
                        WHERE TRANS = SY-TCODE.

          IF SY-UNAME = LV_BNAME.
            MESSAGE W014(MICK) ."'Delivery note NO is already exist' type 'W'. "MESSAGE e047(zdel) DISPLAY LIKE 'W'.
          ELSE.
            MESSAGE 'Delivery note NO is already exist' TYPE 'E'.
          ENDIF.

        ENDIF.

        IF IS_MKPF-FRBNR IS INITIAL.
          MESSAGE 'Maintain GATE Entry' TYPE 'E'.

        ENDIF.
        YY = IS_MKPF-BUDAT(4).

        SELECT SINGLE FRBNR INTO FRBNR1 FROM MKPF WHERE FRBNR = IS_MKPF-FRBNR.

        IF SY-SUBRC = 0.

          SELECT SINGLE BNAME FROM ZHEAD_USER INTO LV_BNAME
                        WHERE TRANS = SY-TCODE.

          IF SY-UNAME = LV_BNAME.
            MESSAGE W014(MICK) ."'Delivery note NO is already exist' type 'W'. "MESSAGE e047(zdel) DISPLAY LIKE 'W'.
          ELSE.
            MESSAGE 'GATE Entry NO is already exist' TYPE 'E'.
          ENDIF.

        ENDIF.


      ENDIF.
**************************************************asset location****************************************
      DATA: MATNR1 TYPE MSEG-MATNR,
            LIFNR1 TYPE MSEG-LIFNR,
            CHALL  TYPE MSEG-SGTXT.

      DATA : LV_QUANTITY TYPE MSEG-MENGE.
      TYPES: BEGIN OF TY_J_1IG_SUBCON,
               MATNR    TYPE J_1IG_SUBCON-MATNR,
               LIFNR    TYPE J_1IG_SUBCON-LIFNR,
               CHLN_INV TYPE J_1IG_SUBCON-CHLN_INV,
               MENGE    TYPE J_1IG_SUBCON-MENGE,
             END OF TY_J_1IG_SUBCON,

             BEGIN OF TY_MARA,
               MATNR TYPE MARA-MATNR,
               MTART TYPE MARA-MTART,
             END OF TY_MARA.

      DATA: IT_J_1IG_SUBCON TYPE TABLE OF TY_J_1IG_SUBCON,
            WA_J_1IG_SUBCON TYPE TY_J_1IG_SUBCON,

            IT_MARA         TYPE TABLE OF TY_MARA,
            WA_MARA         TYPE          TY_MARA.

      READ TABLE IT_MSEG INTO I_MSEG  INDEX 1.

    ENDIF.

**---------------------------------------------------------------*Added
*    IF SY-TCODE = 'MIGO' AND I_MSEG-BWART = '542'.
*
*      SELECT MATNR
*             MTART
*             FROM MARA
*             INTO TABLE IT_MARA
*             WHERE MATNR = I_MSEG-MATNR.
*
*      READ TABLE IT_MARA INTO WA_MARA WITH KEY MATNR = I_MSEG-MATNR.
*
*      IF WA_MARA-MTART = 'UNBW' OR WA_MARA-MTART = 'ZCON'.
*
**        IF I_MSEG-SGTXT IS INITIAL.
**          MESSAGE 'Maintain challan NO' TYPE 'E'.
**        ENDIF.
*
*        SELECT MATNR
*               LIFNR
*               CHLN_INV
*               MENGE
*               FROM J_1IG_SUBCON
*               INTO TABLE IT_J_1IG_SUBCON
*               WHERE MATNR = I_MSEG-MATNR
*               AND   LIFNR = I_MSEG-LIFNR
*               AND   CHLN_INV = I_MSEG-SGTXT.
*
*        READ TABLE IT_J_1IG_SUBCON INTO WA_J_1IG_SUBCON WITH KEY MATNR    = I_MSEG-MATNR
*                                                                 LIFNR    = I_MSEG-LIFNR
*                                                                 CHLN_INV = I_MSEG-SGTXT.
*        IF SY-SUBRC = 0.
*          LV_CHLN_QTY = WA_J_1IG_SUBCON-MENGE.
*        ENDIF.
*        IF SY-SUBRC = 4.
*          MESSAGE 'check vendor material and challan NO' TYPE 'E'.
**        ELSE.
*          SELECT MBLNR
*                 MJAHR
*                 ZEILE
*                 BWART
*                 XAUTO
*                 MATNR
*                 WERKS
*                 LIFNR
*                 SHKZG
*                 MENGE
*                 SGTXT
*                 FROM MSEG
*                 INTO TABLE LT_MSEG
*                 WHERE BWART IN ('541','542')
*                 AND   XAUTO = ''
*                 AND   MATNR = I_MSEG-MATNR
*                 AND   WERKS = I_MSEG-WERKS
*                 AND   LIFNR = I_MSEG-LIFNR
*                 AND   SGTXT = I_MSEG-SGTXT.
**                 AND   shkzg = 'S'.
*          SORT LT_MSEG ASCENDING  BY MBLNR.
*          SELECT MBLNR
*                  MJAHR
*                  ZEILE
*                  BWART
*                  XAUTO
*                  MATNR
*                  WERKS
*                  LIFNR
*                  SHKZG
*                  MENGE
*                  SGTXT
*                  FROM MSEG
*                  INTO TABLE LT_MSEG_NEW
*                  WHERE BWART IN ('541','542')
*                  AND   XAUTO = ''
*                  AND   MATNR = I_MSEG-MATNR
*                  AND   WERKS = I_MSEG-WERKS
*                  AND   LIFNR = I_MSEG-LIFNR
*                  AND   SGTXT = I_MSEG-SGTXT
*                  AND   SHKZG = 'H'.
*          LV_VBELN = I_MSEG-SGTXT.
*
*          SELECT SINGLE FKIMG INTO LV_FKIMG FROM VBRP
*            WHERE VBELN = LV_VBELN
*                    AND   MATNR = I_MSEG-MATNR
*                    AND   WERKS = I_MSEG-WERKS
*                    AND   VKORG_AUFT = I_MSEG-BUKRS.
*
*          IF LT_MSEG IS INITIAL.
*            IF LV_FKIMG IS NOT INITIAL.
*              IF I_MSEG-MENGE <= LV_FKIMG.
*
*              ELSE.
*                MESSAGE 'Quntity is greater than challan qty' TYPE 'E'.
*              ENDIF.
*            ENDIF.
*          ELSE.
*            LOOP AT LT_MSEG INTO LS_MSEG.
*
*              IF LS_MSEG-BWART = '541'.
*
*                LV_MENGE_NEW = LV_MENGE_NEW + LS_MSEG-MENGE.
*                LV_MENGE = LV_MENGE - LV_MENGE_NEW.
**                 lv_menge = lv_menge * -1.
*              ELSE.
*                LV_MENGE = LV_MENGE + LS_MSEG-MENGE.
*              ENDIF.
*
**              READ TABLE it_mseg INTO DATA(ls_mseg1) WITH KEY matnr = ls_mseg-matnr
**                                                              bwart = ls_mseg-bwart
**                                                              shkzg = ls_mseg-shkzg.
**              DATA(tot_chal_menge) = lv_menge + ls_mseg1-menge.
*            ENDLOOP.
*            IF LV_MENGE < '0'.
*              LV_MENGE = LV_MENGE * -1.
*              DATA(TOT_CHAL_MENGE) = LV_MENGE.
*            ELSE.
*              TOT_CHAL_MENGE = LV_MENGE.
*              TOT_CHAL_MENGE = TOT_CHAL_MENGE +  I_MSEG-MENGE.
*            ENDIF.
*            IF TOT_CHAL_MENGE > LV_CHLN_QTY.
*              MESSAGE 'Quntity is greater than challan qty' TYPE 'E'.
*            ENDIF.
*          ENDIF.
*
*        ENDIF.
*      ENDIF.
*    ENDIF.
  ENDMETHOD.


  method IF_EX_MB_MIGO_BADI~PROPOSE_SERIALNUMBERS.
  endmethod.


  method IF_EX_MB_MIGO_BADI~PUBLISH_MATERIAL_ITEM.
  endmethod.


  method IF_EX_MB_MIGO_BADI~RESET.

    REFRESH: IT_GOITEM,IT_HEADER.
    CLEAR  : WA_GOITEM .
  endmethod.


  method IF_EX_MB_MIGO_BADI~STATUS_AND_HEADER.

  endmethod.
ENDCLASS.
