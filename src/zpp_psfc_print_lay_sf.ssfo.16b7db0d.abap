******************* ADDED BY AVINASH BHAGAT 14.01.2019 WITH REF ANUJ DESHPANDE***************************************


*   SELECT SINGLE * FROM mara INTO gs_mara
*  WHERE matnr = header-matnr.


     SELECT SINGLE *
       FROM AFPO INTO @DATA(WA_AFPO)
       WHERE AUFNR = @header-aufnr.

IF WA_AFPO IS NOT INITIAL.
SELECT SINGLE *
  FROM  VBAP
  INTO @DATA(gs_mara1)
  where vbeln = @WA_AFPO-KDAUF
  and POSnr = @wa_afpo-KDPOS.
gs_mara-matnr = gs_mara1-MATNR.
ENDIF.



*BREAK-POINT.
  SELECT SINGLE * FROM vbap INTO gs_vbap
  WHERE vbeln = header-vbeln
    AND posnr = header-vbelp.


SELECT SINGLE * FROM vbak INTO gs_vbak
  WHERE vbeln = gs_vbap-vbeln.


CLEAR:gv_soline,gv_mat.
CONCATENATE gs_vbap-vbeln gs_vbap-posnr INTO gv_soline.

CLEAR: lv_lines,wa_lines.
      REFRESH lv_lines.
      lv_name = gv_soline.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0010'
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
      ENDIF.



IF wa_lines-tdline IS NOT INITIAL. .
gv_mat = wa_lines-tdline.

ELSE.
 gv_mat = GS_MARA-WRKST.
ENDIF.







*SELECT SINGLE * FROM knmt INTO gs_knmt
*  WHERE vkorg = ls_vbak-vkorg
*    AND vtweg = ls_vbak-vtweg
*    AND kunnr = header-kunum
*    AND matnr = header-matnr.

CLEAR: lv_lines,wa_lines.
      REFRESH lv_lines.
      lv_name = gv_soline.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'Z102'
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
      ENDIF.



IF wa_lines-tdline IS NOT INITIAL. .
gv_ofm_no = wa_lines-tdline.

ENDIF.
