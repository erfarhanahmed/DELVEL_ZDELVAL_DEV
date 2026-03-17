DATA: lv_name   TYPE thead-tdname,
      lv_lines  TYPE STANDARD TABLE OF tline,
      wa_lines  LIKE tline.
DATA: LV_LENGTH     TYPE STRING.
DATA: LV_LATRS      TYPE C.
DATA: LV_LATRS1     TYPE C.
DATA: LV_INDEX      TYPE SY-INDEX.
DATA: LV_SAFE_LEN   TYPE SY-INDEX.
DATA: LV_LINE       TYPE STRING.
DATA: LV_SPACE      TYPE STRING.
DATA: LV_SPACE1     TYPE STRING.
DATA: LV_SPACE2     TYPE STRING.

CLEAR: lv_lines,  lv_name.
REFRESH lv_lines.
lv_name = ls_bil_invoice-HD_REF-ORDER_NUMB.
CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'ZZ99' "'0009'
          language                = 'E' "'S'
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
            LV_LENGTH = STRLEN( WA_LINES-TDLINE ).
            CLEAR: LV_INDEX,LV_SAFE_LEN,lv_line.
            DO  LV_LENGTH TIMES.
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
        IF LV_LINE IS NOT INITIAL.
          CLEAR WA_LINES-TDLINE.
          WA_LINES-TDLINE = LV_LINE.
        ENDIF.
            CONCATENATE GV_PO wa_lines-tdline INTO GV_PO SEPARATED BY space.
          ENDIF.
        ENDLOOP.
        CONDENSE GV_PO.
      ENDIF.


















