*IS_VBDKA-KUNNR
*BREAK primus.
CLEAR: WA_KNMT,GV_OLD.

**********************edited by PJ***************************
**      SELECT vbeln POSNR LFGSA GBSTA FROM VBUP
**        INTO TABLE it_VBUP WHERE vbeln = IS_VBDKA-vbeln.
**
**  IF it_VBUP is NOT INITIAL.
**    LOOP AT it_vbup.
**      IF LFGSA <> C  and GBSTA <> C.

*********old code start********

SELECT SINGLE * FROM knmt INTO wa_knmt
  WHERE matnr = wa_final-matnr
    AND kunnr = IS_VBDKA-KUNNR.

SELECT SINGLE * FROM mara INTO wa_mara
  WHERE matnr = wa_final-matnr.

IF wa_mara-wrkst IS NOT INITIAL.

 CONCATENATE '(' wa_mara-wrkst ')' INTO GV_OLD.

ENDIF.
DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.



CLEAR: lv_lines, GV_TAG,lv_name,wa_lines.
      REFRESH lv_lines.
*      lv_name = IS_VBDKA-VBELN.

CONCATENATE IS_VBDKA-VBELN wa_final-posnr INTO lv_name.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0001'
          language                = sy-langu
          name                    = lv_name
          object                  = 'VBBP'
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

      READ TABLE lv_lines INTO wa_lines INDEX 1.
        IF sy-subrc = 0.
          gv_tag = wa_lines-tdline.
        ENDIF.
*        LOOP AT lv_lines INTO wa_lines.
*          IF NOT wa_lines-tdline IS INITIAL.
*            CONCATENATE  wa_lines-tdline GV_SHIP INTO GV_SHIP SEPARATED BY space.
*          ENDIF.
*        ENDLOOP.
*        CONDENSE GV_SHIP.
      ENDIF.
************    old code end  ************
**     ENDIF.
**
**    ENDLOOP.
**
**
**  ENDIF.
*************************************************









