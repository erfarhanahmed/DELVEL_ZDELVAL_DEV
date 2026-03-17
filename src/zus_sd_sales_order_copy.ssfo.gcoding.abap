DATA: wa_vbap like LINE OF IT_VBDPA,
      v_vbeln TYPE vbap-vbeln .

TYPES : BEGIN OF str_matnr,
  matnr TYPE vbap-matnr,
  posnr TYPE string,
  END OF str_matnr,

  BEGIN OF str_vbfa,
    VBELV TYPE vbfa-VBELV,
    posnv TYPE string,
    RFMNG TYPE vbfa-RFMNG,
    END OF str_vbfa.

DATA : it_vbfa TYPE TABLE OF str_vbfa,
      wa_vbfa TYPE str_vbfa.

DATA : it_matnr TYPE TABLE OF str_matnr,
      wa_matnr TYPE str_matnr.

DATA : v_KWMENG TYPE VBfa-RFMNG.
*DATA : v_total TYPE vbap-NETWR.



********************edited by PJ***************************
LOOP AT IT_VBDPA INTO WA_VBAP.
*WA_FINAL-VBELN = WA_VBAP-VBELN." MODIFIED BY PJ
*  BREAK-POINT.
  SELECT posnr matnr from vbap INTO TABLE it_matnr where
    VBELN = IS_VBDKA-VBELN.


    IF SY-SUBRC = 0.
*  BREAK-POINT.
       SELECT vbeln posnr LFGSA  GBSTA FROM VBUP
        INTO TABLE it_VBUP WHERE VBELN = IS_VBDKA-VBELN
        AND LFGSA <> 'C' AND GBSTA <> 'C'.
         if sy-subrc = 0.

READ TABLE it_VBUP INTO wa_vbup WITH KEY posnr = WA_VBAP-POSNR.

IF sy-subrc = 0 .

IF wa_VBUP-GBSTA = 'B' and wa_VBUP-LFGSA = 'B' .
  SELECT VBELV posnv RFMNG from vbfa INTO TABLE it_vbfa
    WHERE VBELV = IS_VBDKA-VBELN and vbtyp_n = 'M'.

    IF sy-subrc = 0 and it_vbfa IS NOT INITIAL.
      CLEAR v_KWMENG.
        LOOP AT it_vbfa INTO wa_vbfa WHERE VBELV = IS_VBDKA-VBELN
          and posnv = wa_VBUP-posnr.
*          v_KWMENG = v_KWMENG + wa_vbfa-RFMNG.
*          WA_VBAP-KWMENG = WA_VBAP-KWMENG - v_KWMENG.


          IF sy-subrc = 0 .
            v_KWMENG = v_KWMENG + wa_VBfa-RFMNG.


          ENDIF.

        ENDLOOP.

    ENDIF.

    ELSE.

ENDIF.
           WA_VBAP-KWMENG = WA_VBAP-KWMENG - v_KWMENG.
           WA_FINAL-POSNR = WA_VBAP-POSNR.
           WA_FINAL-MATNR = WA_VBAP-MATNR.
           WA_FINAL-BRGEW = WA_VBAP-BRGEW.


           WA_FINAL-NETPR = WA_VBAP-NETPR.

           WA_VBAP-NETWR = WA_VBAP-KWMENG * WA_VBAP-NETPR.
           v_total = v_total + WA_VBAP-NETWR.

           WA_FINAL-NETWR = WA_VBAP-NETWR.
           WA_FINAL-KWMENG = WA_VBAP-KWMENG.


           APPEND WA_FINAL TO IT_FINAL.
           CLEAR v_KWMENG.
DELETE ADJACENT DUPLICATES FROM IT_FINAL.

ENDIF.

ENDIF.

* endif.
*ENDLOOp.

      ENDIF.

 ENDLOOP.

*****************************************************

*  IF it_VBUP is NOT INITIAL.
*    LOOP AT it_vbup.
*      IF LFGSA <> C  and GBSTA <> C.





*SELECT KNUMV
*       KPOSN
*       KSCHL
*       KAWRT
*       KBETR
*       KWERT
*       KINAK FROM KONV INTO TABLE IT_KONV
*       FOR ALL ENTRIES IN IT_VBDPA
*       WHERE KPOSN = IT_VBDPA-POSNR
*       AND KNUMV = IS_VBDKA-KNUMV.
*
*SORT IT_KONV BY KPOSN.
*
*LOOP AT IT_KONV INTO WA_KONV.
*  CASE WA_KONV-KSCHL.
*      BREAK-POINT.
*   WA_KONV-KWERT = WA_VBAP-NETWR.
*    WHEN 'ULOC' .
*      WA_FINAL-ULOC = WA_KONV-KWERT.
*    WHEN 'USTA'.
*      WA_FINAL-USTA = WA_KONV-KWERT.
*    WHEN 'UCOU'.
*      WA_FINAL-UCOU = WA_KONV-KWERT.
*    WHEN 'UFR1'.
*      WA_FINAL-UFR1 = WA_KONV-KWERT.
*    WHEN 'UHF1'.
*      WA_FINAL-UHF1 = WA_KONV-KWERT.
*    WHEN 'USC1'.
*      WA_FINAL-USC1 = WA_KONV-KWERT.
*    WHEN 'UMC1'.
*      WA_FINAL-UMC1 = WA_KONV-KWERT.
*    WHEN 'UOTH'.
*      WA_FINAL-UOTH = WA_KONV-KWERT.
*  ENDCASE.
*GV_SALE = GV_SALE + WA_FINAL-ULOC + WA_FINAL-USTA +
*          WA_FINAL-UCOU + WA_FINAL-UOTH.
*GV_FREIGHT = GV_FREIGHT + WA_FINAL-UFR1.
*
*GV_HANDLING = GV_HANDLING + WA_FINAL-UHF1.
*
*GV_SERVICE =  GV_SERVICE + WA_FINAL-USC1.
*
*GV_MOUNTING = GV_MOUNTING + WA_FINAL-UMC1.
*
*CLEAR: WA_FINAL-ULOC,WA_FINAL-USTA,WA_FINAL-UCOU,
*       WA_FINAL-UFR1,WA_FINAL-UMC1,WA_FINAL-USC1,
*       WA_FINAL-UHF1,WA_FINAL-UOTH.
*ENDLOOP.



SELECT SINGLE * FROM VBAK INTO WA_VBAK
  WHERE VBELN = IS_VBDKA-VBELN.

SELECT SINGLE * FROM VBKD INTO WA_VBKD
  WHERE VBELN = IS_VBDKA-VBELN.

SELECT SINGLE * FROM T001W INTO WA_T001W
  WHERE WERKS = WA_VBAP-WERKS.

SELECT SINGLE * FROM ADRC INTO WA_ADRC
  WHERE ADDRNUMBER = WA_T001W-ADRNR.

SELECT SINGLE * FROM TVZBT INTO WA_TVZBT
  WHERE ZTERM = IS_VBDKA-ZTERM AND SPRAS = 'E'.

SELECT SINGLE * FROM TINCT INTO WA_TINCT
  WHERE INCO1 = IS_VBDKA-INCO1 AND SPRAS = 'E'.


DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.

CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = IS_VBDKA-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U001'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE  wa_lines-tdline GV_SHIP INTO GV_SHIP SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_SHIP.
      ENDIF.


CLEAR: lv_lines, ls_mattxt.
      REFRESH lv_lines.
      lv_name = IS_VBDKA-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U002'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE GV_ECCN wa_lines-tdline INTO GV_ECCN SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_ECCN.
      ENDIF.

CLEAR: lv_lines, ls_mattxt,GV_info.
      REFRESH lv_lines.
      lv_name = IS_VBDKA-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U006'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE GV_info wa_lines-tdline  INTO GV_info SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_info.
      ENDIF.

CLEAR: lv_lines, ls_mattxt,GV_REMARK.
      REFRESH lv_lines.
      lv_name = IS_VBDKA-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U005'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lv_lines
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
      IF NOT lv_lines IS INITIAL.
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            CONCATENATE GV_REMARK wa_lines-tdline  INTO GV_REMARK SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_REMARK.
      ENDIF.

CLEAR: lt_lines, ls_mattxt,ls_lines.
      REFRESH lv_lines.
      lv_name = IS_VBDKA-VBELN.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'U005'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBK'
        TABLES
          lines                   = lt_lines
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
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
