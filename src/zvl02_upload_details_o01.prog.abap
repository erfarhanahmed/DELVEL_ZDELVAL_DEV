*&---------------------------------------------------------------------*
*&  Include           ZVL02_UPLOAD_DETAILS_O01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_1000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_1000 OUTPUT.
  SET PF-STATUS 'PF1'.
  SET TITLEBAR 'T1'.

  CASE sy-ucomm.
     WHEN 'UPDATE'.
      IF s_VHILM_KU IS INITIAL.
        MESSAGE 'Kindly select Box.' TYPE 'W'.
        ELSE.
       SET SCREEN 2000.
      ENDIF.


    WHEN 'BACK'. ".OR 'CANCEL' OR 'EXIT'.
      SET SCREEN 1000.


      when 'CANCEL' OR 'EXIT'.
        SET SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  STATUS_2000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_2000 OUTPUT.
  SET PF-STATUS 'PF2'.
  SET TITLEBAR 'T2'.

  CASE SY-UCOMM.
    WHEN 'UPDATE'.
     BOX_NO  = S_VHILM_KU.
      REFRESH LT_FINAL1.
    WHEN 'SAVE' .
      IF lt_final2 is not INITIAL.

*        LOOP AT lt_final2 INTO ls_final2.
*          INSERT ZMATQUAN FROM LS_FINAL2.

           MODIFY ZMATQUAN FROM TABLE lt_final2[].
           MESSAGE 'Material Updated.' TYPE 'S'.
*           CLEAR lS_final2.
*        ENDLOOP.

      ENDIF.

    WHEN 'BACK' .
*      CLEAR : s_VHILM_KU.
*      CLEAR LS_FINAL-MARK.
*
*      REFRESH LT_FINAL1.
*      SET SCREEN 1000.
*
*      S_VHILM_KU = BOX_NO.
*      call TRANSACTION 'ZLOOSE_MATERIAL'.

    WHEN 'CANCEL' OR 'EXIT'.
      SET SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
