DATA:
  ls_conditions TYPE t_conditions.

gv_qty = gs_item-fkimg.

clear gv_kdmat.
SELECT SINGLE kdmat
         FROM vbap
         INTO gv_kdmat
         WHERE vbeln = gs_item-aubel
         AND   posnr = gs_item-aupos.

SELECT SINGLE steuc
            FROM marc
            INTO gv_steuc
            WHERE matnr = gs_item-matnr.

READ TABLE gt_mat_desc INTO gs_mat_desc
           WITH KEY matnr = gs_item-matnr.

READ TABLE gt_conditions INTO ls_conditions
              WITH KEY kposn = gs_item-posnr
                       kschl = 'ZPR0'.
IF sy-subrc IS INITIAL.
  gv_rate = ls_conditions-kwert / gs_item-fkimg.
  gv_amt  = ls_conditions-kwert.
ENDIF.

gv_tot_amt = gv_tot_amt + gv_amt.
gv_tot_qty = gv_tot_qty + gs_item-fkimg.

DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline,
      ls_itmtxt  TYPE tline,
      ls_mattxt  TYPE tline.
DATA: LV_LENGTH  TYPE STRING.
DATA: LV_LATRS      TYPE C.
DATA: LV_LATRS1     TYPE C.
DATA: LV_INDEX      TYPE SY-INDEX.
DATA: LV_SAFE_LEN   TYPE SY-INDEX.
DATA: LV_LINE       TYPE STRING.
DATA: LV_SPACE      TYPE STRING.
DATA: LV_SPACE1     TYPE STRING.
DATA: LV_SPACE2     TYPE STRING.

*BREAK fujiabap.

CLEAR: lv_lines, ls_mattxt, lv_name,gv_span.
REFRESH lv_lines.

*BREAK-POINT.
*CONCATENATE gs_item-vbeln gs_item-posnr INTO lv_name.
CONCATENATE gs_item-aubel gs_item-AUPOS INTO lv_name.
*      lv_name = gs_item-vbeln.


      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = '0001' "'0009'
          language                = 'E' "'S'
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
        LOOP AT lv_lines INTO wa_lines.
          IF NOT wa_lines-tdline IS INITIAL.
            LV_LENGTH = STRLEN( wa_LINEs-TDLINE ).
      CLEAR: LV_INDEX,LV_SAFE_LEN,lv_line.
           DO lv_length TIMES.
             CLEAR: LV_LATRS.
          LV_INDEX    = SY-INDEX - 1.
          LV_SAFE_LEN = LV_LENGTH - LV_INDEX.
          LV_LATRS = WA_LINES-TDLINE+LV_INDEX(LV_SAFE_LEN).
          LV_LATRS1 = LV_LATRS.
          TRANSLATE LV_LATRS TO UPPER CASE.

          IF LV_LATRS CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890' OR
               LV_LATRS CA ' ! @ # $ % \^ & * ( ) - _ = + {} [] | : ; " < > , . ? / \  ~'  OR
               LV_LATRS CA ' ' OR LV_LATRS EQ ' ' OR LV_LATRS EQ SPACE OR
               LV_LATRS CA ''''''.
           IF LV_LATRS EQ ' '.
             CONCATENATE LV_LINE LV_LATRS1 INTO LV_LINE SEPARATED BY ' '.
            ELSE.
              CONCATENATE LV_LINE LV_LATRS1 INTO LV_LINE.
            ENDIF.
           ENDIF.
           ENDDO.
            "
           "CONCATENATE gv_span wa_lines-tdline INTO gv_span SEPARATED BY space.
          IF LV_LINE IS NOT INITIAL.
            CLEAR WA_LINES-TDLINE.
            wa_lines-TDLINE = LV_LINE.
          ENDIF.
          CONCATENATE gv_span wa_lines-tdline INTO gv_span SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE gv_span.
      ENDIF.
if gv_span is INITIAL.
 gv_maktx = gs_mat_desc-maktx.
ENDIF.

