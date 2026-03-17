*&---------------------------------------------------------------------*
*& Report  Z_T513S_CLEANUP
*&
*&---------------------------------------------------------------------*
*& -> cleanup report from note 1089040
*&
*&---------------------------------------------------------------------*

REPORT  z_t513s_cleanup.


PARAMETERS: testrun TYPE flag DEFAULT 'X'.

DATA: lt_old TYPE STANDARD TABLE OF t513s,
      ls_old TYPE t513s,
      lt_del TYPE STANDARD TABLE OF t513s,
      lv_del TYPE i VALUE 0.
DATA: l_dtype LIKE dd01v-datatype.

SELECT * FROM t513s INTO TABLE lt_old.

LOOP AT lt_old INTO ls_old.
  CLEAR: l_dtype.
  CALL FUNCTION 'NUMERIC_CHECK'
    EXPORTING
      string_in = ls_old-endda
    IMPORTING
      htype     = l_dtype.
  IF l_dtype <> 'NUMC'.
    INSERT ls_old INTO TABLE lt_del.
    lv_del = lv_del + 1.
  ENDIF.
ENDLOOP.


IF NOT lt_del[] IS INITIAL AND testrun IS INITIAL.
  DELETE t513s FROM TABLE lt_del.
  COMMIT WORK.
ENDIF.

WRITE: / 'Cleanup of table T513S'.
WRITE: / sy-datlo, sy-timlo, sy-uname.
WRITE: /.
WRITE: / 'scrapped records deleted: ', lv_del.
