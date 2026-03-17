class ZCL_IM_WORKORDER_UPDATE definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_WORKORDER_UPDATE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_WORKORDER_UPDATE IMPLEMENTATION.


  method IF_EX_WORKORDER_UPDATE~ARCHIVE_OBJECTS.
*    BREAK-POINT.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~AT_DELETION_FROM_DATABASE.
*    BREAK-POINT.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~AT_RELEASE.
  endmethod.


  METHOD IF_EX_WORKORDER_UPDATE~AT_SAVE.
*    **********added by rushikesh : 09.06.2020***********************************

    DATA: I_STPO  TYPE TABLE OF STPO_API02,
          WA_STPO TYPE STPO_API02.
    DATA: IT_STPO TYPE TABLE OF STPO_API03.
    DATA : WA_STPO1 TYPE STPO_API03.
    DATA: IT_STPO1 TYPE TABLE OF STPO_API03,
          LV_QTY   TYPE GAMNG.
*       DATA : wa_stpo1 like STPO_API03.


    DATA: I_STPO2  TYPE TABLE OF STPO_API02,
          WA_STPO2 TYPE STPO_API02.

    DATA : WA_STKO_NEW TYPE STKO_API01 .

    DATA : TEXT1(70) TYPE C .
    DATA : V_INDX LIKE SY-INDEX.
    DATA : ICOLS    TYPE TABLE OF HELP_VALUE,
           WA_ICOLS TYPE HELP_VALUE.

    TYPES : BEGIN OF ITAB1 ,
              MATNR TYPE MARA-MATNR,
              MTART TYPE MARA-MTART,
            END OF ITAB1.

    TYPES : BEGIN OF ITAB2 ,
              MATNR TYPE MARA-MATNR,
              TEXT  TYPE DFK006B-TEXT,
            END OF ITAB2 .

    DATA : ITAB    TYPE TABLE OF ITAB1,
           WA_ITAB TYPE ITAB1.

    DATA : WA_MBEW TYPE MBEW.
    DATA : I_MBEW TYPE TABLE OF MBEW .
    DATA : ERR_DET    TYPE TABLE OF ITAB2,
           WA_ERR_DET TYPE ITAB2.

    DATA: L_LPLPR TYPE MBEW-LPLPR,
          L_BWTAR TYPE MBEW-BWTAR,
          L_STPRS TYPE MBEW-STPRS,
          L_BWKEY TYPE MBEW-BWKEY.

    DATA : ANS(1) TYPE C.
    CLEAR : L_BWTAR .
    DATA : I_MATNR TYPE MARA-MATNR .
***************ADDED BY JYOTI ON 18.06.2024
    DATA : MATERIAL   TYPE CSAP_MBOM-MATNR,
           WERKS      TYPE CSAP_MBOM-WERKS,
           STLAN      TYPE CSAP_MBOM-STLAN,
           VALID_FROM TYPE CSAP_MBOM-DATUV.
*    DATA : LV_KWMENG TYPE VBAP-KWMENG,
    DATA: LV_LFIMG  TYPE LIPS-LFIMG,
          LV_PSMNG  TYPE AFPO-PSMNG,
          LV_NETQTY TYPE P DECIMALS 3.
    DATA: LV_KAINS TYPE MSKA-KAINS,
          LV_KALAB TYPE MSKA-KALAB.



    DATA : WA_STKO1 TYPE STKO_API02 ."occurs 0 with header line..
    IF IS_HEADER_DIALOG-WERKS = 'PL01' AND ( SY-TCODE = 'CO01' OR SY-TCODE = 'CO02' OR SY-TCODE = 'CO40' ).
      BREAK PRIMUSABAP.
      MESSAGE 'Check Component Overview' TYPE 'W' .
    ENDIF.


    CLEAR : LV_QTY .


    IF IS_HEADER_DIALOG-WERKS = 'PL01'.

      ".................................... added by sakshi
      IF IS_HEADER_DIALOG-KDAUF_AUFK IS NOT INITIAL.
*        IF IS_HEADER_DIALOG-AUFNR = '%00000000001'.
        SELECT SINGLE KWMENG , MATNR
          INTO @DATA(WA_VB)
          FROM VBAP
        WHERE VBELN = @IS_HEADER_DIALOG-KDAUF_AUFK
           AND POSNR = @IS_HEADER_DIALOG-KDPOS_AUFK.

        IF WA_VB-KWMENG IS INITIAL.
          WA_VB-KWMENG = 0.
        ENDIF.

        SELECT SUM( LFIMG )
          INTO LV_LFIMG
          FROM LIPS
        WHERE VGBEL = IS_HEADER_DIALOG-KDAUF_AUFK
           AND VGPOS = IS_HEADER_DIALOG-KDPOS_AUFK.

        IF LV_LFIMG IS INITIAL.
          LV_LFIMG = 0.
        ENDIF.


        SELECT SUM( AFPO~PSMNG )
          INTO LV_PSMNG
          FROM AFPO
          INNER JOIN AUFK
            ON AUFK~AUFNR = AFPO~AUFNR
        WHERE AFPO~KDAUF = IS_HEADER_DIALOG-KDAUF_AUFK
           AND AFPO~KDPOS = IS_HEADER_DIALOG-KDPOS_AUFK
           AND AFPO~AUFNR <> IS_HEADER_DIALOG-AUFNR
           AND MATNR  = IS_HEADER_DIALOG-PLNBEZ
           AND AUFK~IDAT2 = '00000000'
           AND AUFK~LOEKZ <> 'X'
          AND AFPO~PSMNG NE AFPO~WEMNG.


        SELECT SUM( AFPO~WEMNG )
          INTO @DATA(LV_WEMNG)
          FROM AFPO
          INNER JOIN AUFK
            ON AUFK~AUFNR = AFPO~AUFNR
        WHERE AFPO~KDAUF = @IS_HEADER_DIALOG-KDAUF_AUFK
           AND AFPO~KDPOS = @IS_HEADER_DIALOG-KDPOS_AUFK
           AND AFPO~AUFNR <> @IS_HEADER_DIALOG-AUFNR
           AND MATNR  = @IS_HEADER_DIALOG-PLNBEZ
           AND AUFK~IDAT2 = '00000000'
           AND AUFK~LOEKZ <> 'X'
          AND AFPO~PSMNG NE AFPO~WEMNG.


        IF LV_PSMNG IS INITIAL.
          LV_PSMNG = 0.
        ENDIF.

        SELECT
            SUM( KAINS ) AS KAINS,
            SUM( KALAB ) AS KALAB
          INTO (@LV_KAINS, @LV_KALAB)
          FROM MSKA
         WHERE VBELN = @IS_HEADER_DIALOG-KDAUF_AUFK
           AND POSNR = @IS_HEADER_DIALOG-KDPOS_AUFK
          AND MATNR  = @IS_HEADER_DIALOG-PLNBEZ.

        IF LV_KAINS IS INITIAL.
          LV_KAINS = 0.
        ENDIF.

        IF LV_KALAB IS INITIAL.
          LV_KALAB = 0.
        ENDIF.

        LV_NETQTY = WA_VB-KWMENG - LV_LFIMG - ( LV_PSMNG - LV_wemng ) - LV_KAINS - LV_KALAB.

        IF WA_VB-MATNR =   IS_HEADER_DIALOG-PLNBEZ  .
          IF IS_HEADER_DIALOG-IDAT2 IS INITIAL OR IS_HEADER_DIALOG-IDAT2 = '00000000' .
            LV_QTY   = IS_HEADER_DIALOG-GAMNG - IS_HEADER_DIALOG-IGMNG .
            IF NOT LV_QTY <= LV_NETQTY.
              MESSAGE 'Order Qty greater than Sales Order NET Qty' TYPE 'E'.
            ENDIF.
          ENDIF.
        ENDIF.
*      ENDIF.
      ENDIF.
      CLEAR LV_QTY .
      ".................................... added by sakshi

*****************************added by jyoti on 18.06.2024***************************************
* if IS_HEADER_DIALOG-WERKS = 'PL01'.
* BREAK PRIMUSABAP.
*   CALL FUNCTION 'CSAP_MAT_BOM_READ'
*EXPORTING
*MATERIAL = IS_HEADER_DIALOG-MATNR
*PLANT = IS_HEADER_DIALOG-WERKS
*BOM_USAGE = IS_HEADER_DIALOG-STLAN
**ALTERNATIVE = '1'
**VALID_FROM =
**VALID_TO =
**CHANGE_NO =
**REVISION_LEVEL =
**FL_DOC_LINKS =
**FL_DMU_TMX =
**IMPORTING
**FL_WARNING =
*TABLES
*T_STPO = it_stpo
**T_STKO = WA_STKO1
**
**T_DEP_DATA =
**
**T_DEP_DESCR =
**
**T_DEP_ORDER =
**
**T_DEP_SOURCE =
**
**T_DEP_DOC =
**
**T_DOC_LINK =
**
**T_DMU_TMX =
**
**T_LTX_LINE =
**
**T_STPU =
*
*EXCEPTIONS
*
*ERROR = 1
*
*OTHERS = 2
*
*.
*
*IF SY-SUBRC <> 0.
*
*MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*
*WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*
*ENDIF.
*
*
*    material = IS_HEADER_DIALOG-MATNR.
*        werks    = IS_HEADER_DIALOG-WERKS.
*        stlan   =  IS_HEADER_DIALOG-STLAN.
*
**        VALID_FROM = '18.06.2024'.
**
*
*
**CALL FUNCTION 'CSAP_MAT_BOM_OPEN'
**  EXPORTING
**    MATERIAL               = material
**   PLANT                   = werks
**    BOM_USAGE              = stlan
**   VALID_FROM             = VALID_FROM
** IMPORTING
**   O_STKO                 = WA_STKO1
** TABLES
**   T_STPO                 = it_stpo
** EXCEPTIONS
**   ERROR                  = 1
**   OTHERS                 = 2
**          .
**IF SY-SUBRC <> 0.
*** Implement suitable error handling here
**ENDIF.
*

*loop at it_stpo into wa_stpo1.
**  if wa_stpo1-ISSUE_LOC is NOT INITIAL.
*
*   if IS_HEADER_DIALOG-AUART+0(1) = 'K'.
*     WA_STPO1-ISSUE_LOC = 'KRM0'.
**    MODIFY I_stpo FROM wa_stpo TRANSPORTING ISSUE_LOC WHERE COMPONENT = wa_stpo-COMPONENT .
*     APPEND wa_stpo1 TO it_stpo1.
*    clear wa_stpo1.
*  endif.
**  endif.
*endloop.

*
*  CALL FUNCTION 'CSAP_MAT_BOM_MAINTAIN'
*    EXPORTING
*      MATERIAL                  = material
*     PLANT                      = werks
*      BOM_USAGE                 = stlan
**     VALID_FROM                 = VALID_FROM
*      I_STKO                    = wa_stko_new
**     FL_COMMIT_AND_WAIT        = 'X'
**   IMPORTING
**     O_STKO                    = wa_stko1
*   TABLES
*     T_STPO                    = IT_STPO1
*   EXCEPTIONS
*     ERROR                     = 1
*     OTHERS                    = 2
*            .
*  IF SY-SUBRC <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  data : wa_ret2 TYPE bapiret2,
*         it_ret2 TYPE table of bapiret2.
*
*  call function 'BAPI_TRANSACTION_COMMIT'
*   exporting
*     wait      = 'X'
*   importing
*     return    = it_ret2.
**  ENDIF.

*************************************************************************************************


      IF IS_HEADER_DIALOG-MATNR IS NOT INITIAL.
*  BREAK PRIMUSABAP.

*Start of check for Standard price of material And its BOM component part-1

        CALL FUNCTION 'CSAP_MAT_BOM_READ'
          EXPORTING
            MATERIAL  = IS_HEADER_DIALOG-MATNR
            PLANT     = IS_HEADER_DIALOG-WERKS
            BOM_USAGE = IS_HEADER_DIALOG-STLAN
*ALTERNATIVE = '1'
*VALID_FROM =
*VALID_TO =
*CHANGE_NO =
*REVISION_LEVEL =
*FL_DOC_LINKS =
*FL_DMU_TMX =
*IMPORTING
*FL_WARNING =
          TABLES
            T_STPO    = I_STPO
*T_STKO = WA_STKO1
*
*T_DEP_DATA =
*
*T_DEP_DESCR =
*
*T_DEP_ORDER =
*
*T_DEP_SOURCE =
*
*T_DEP_DOC =
*
*T_DOC_LINK =
*
*T_DMU_TMX =
*
*T_LTX_LINE =
*
*T_STPU =
          EXCEPTIONS
            ERROR     = 1
            OTHERS    = 2.

        IF SY-SUBRC <> 0.

          MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO

          WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.

        ENDIF.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            INPUT  = IS_HEADER_DIALOG-MATNR
          IMPORTING
            OUTPUT = WA_STPO-COMPONENT.

        APPEND WA_STPO TO I_STPO.

        CLEAR WA_STPO .

*End of check for Standard price of material And its BOM component part-1

*Start of check for Standard price of material And its BOM component part-2


        LOOP AT I_STPO INTO WA_STPO.
*  if wa_stpo1-ISSUE_LOC is NOT INITIAL.

          IF IS_HEADER_DIALOG-AUART+0(1) = 'K'.
            WA_STPO-ISSUE_LOC = 'KRM0'.
            MODIFY I_STPO FROM WA_STPO TRANSPORTING ISSUE_LOC WHERE COMPONENT = WA_STPO-COMPONENT .
*     APPEND wa_stpo1 TO it_stpo1.
            CLEAR WA_STPO.
          ENDIF.
*  endif.
        ENDLOOP.






        LOOP AT I_STPO INTO WA_STPO.

          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              INPUT  = WA_STPO-COMPONENT
            IMPORTING
              OUTPUT = I_MATNR.

          SELECT SINGLE * INTO CORRESPONDING FIELDS OF WA_ITAB FROM MARA

          WHERE MATNR = I_MATNR .

          SELECT SINGLE * FROM MBEW INTO WA_MBEW WHERE MATNR = I_MATNR AND

          BWKEY = IS_HEADER_DIALOG-WERKS.

          IF ( WA_ITAB-MTART = 'FERT' OR WA_ITAB-MTART = 'HALB' )." and wa_mbew-vprsv = 'S' .This is reqd only if SFG can have Price control as V

            SELECT SINGLE BWKEY INTO L_BWKEY FROM T001W WHERE WERKS = IS_HEADER_DIALOG-WERKS.

            IF SY-SUBRC = 0 .

              SELECT SINGLE LPLPR STPRS INTO (L_LPLPR, L_STPRS) FROM MBEW WHERE MATNR = WA_ITAB-MATNR

              AND BWKEY = L_BWKEY

              AND BWTAR = L_BWTAR.

              IF L_LPLPR IS INITIAL AND L_STPRS IS INITIAL .

                WA_ERR_DET-MATNR = WA_ITAB-MATNR .

                WA_ERR_DET-TEXT = 'Maintain current planned Price & Standard Price For ' .

              ENDIF.

              IF L_LPLPR IS INITIAL .

                WA_ERR_DET-MATNR = WA_ITAB-MATNR .

                WA_ERR_DET-TEXT = 'Maintain current planned Price' .

              ENDIF.

              IF L_STPRS IS INITIAL .

                WA_ERR_DET-MATNR = WA_ITAB-MATNR .

                WA_ERR_DET-TEXT = 'Maintain Standard Price ' .

              ENDIF.

              IF WA_ERR_DET IS NOT INITIAL.

                APPEND WA_ERR_DET TO ERR_DET.

                CLEAR WA_ERR_DET.

              ENDIF.

            ENDIF.

          ENDIF.

          CLEAR : WA_MBEW, WA_ITAB.

        ENDLOOP.

        SORT ERR_DET BY MATNR.

        WA_ICOLS-TABNAME = 'MARA'.

        WA_ICOLS-FIELDNAME = 'MATNR'.

        WA_ICOLS-SELECTFLAG = 'X'.

        APPEND WA_ICOLS TO ICOLS .

        WA_ICOLS-TABNAME = 'DFK006B'.

        WA_ICOLS-FIELDNAME = 'TEXT'.

        APPEND WA_ICOLS TO ICOLS.

        IF ERR_DET[] IS NOT INITIAL .

          CALL FUNCTION 'MD_POPUP_SHOW_INTERNAL_TABLE'
            EXPORTING
              TITLE   = 'ERROR FOR MATERIALS'
            IMPORTING
              INDEX   = V_INDX
            TABLES
              VALUES  = ERR_DET
              COLUMNS = ICOLS
            EXCEPTIONS
              LEAVE   = 1
              OTHERS  = 2.

          MESSAGE 'Maintain Prices For Listed Material' TYPE 'E'.

        ENDIF.

*END of check for Standard price of material And its BOM component part-2

*      ENDIF.
      ENDIF.
    ENDIF.







  ENDMETHOD.


  method IF_EX_WORKORDER_UPDATE~BEFORE_UPDATE.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~CMTS_CHECK.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~COMP_RQMT_DATE_TIME_SET.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~INITIALIZE.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~IN_UPDATE.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~NUMBER_SWITCH.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~REORG_STATUS_ACTIVATE.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~REORG_STATUS_ACT_CHECK.
  endmethod.


  method IF_EX_WORKORDER_UPDATE~REORG_STATUS_REVOKE.
  endmethod.
ENDCLASS.
