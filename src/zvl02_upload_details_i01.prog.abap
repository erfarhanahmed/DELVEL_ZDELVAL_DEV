*&---------------------------------------------------------------------*
*&  Include           ZVL02_UPLOAD_DETAILS_I01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_1000 INPUT.
  CASE sy-ucomm.
    WHEN 'DISP'.
IF s_vbeln is not INITIAL .

CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
  EXPORTING
    INPUT  = s_vbeln
  IMPORTING
    OUTPUT = s_vbeln.

        REFRESH lt_final.
        SELECT vbeln from likp
        INTO CORRESPONDING FIELDS OF TABLE lt_likp
        WHERE VBELN eq S_VBELN.
          IF lt_likp is NOT INITIAL.
         SELECT venum from vepo
           INTO CORRESPONDING FIELDS OF TABLE lt_vepo
           FOR ALL ENTRIES IN lt_likp
           WHERE vbeln eq lt_likp-vbeln.

           IF lt_vepo  is NOT INITIAL.
             SELECT VHILM_KU venum FROM vekp
               INTO CORRESPONDING FIELDS OF TABLE lt_vekp
               FOR ALL ENTRIES IN lt_vepo
               WHERE venum eq lt_vepo-venum.
               IF lt_vekp is NOT INITIAL.
                 LOOP AT lt_vekp INTO ls_vekp.
                   ls_final-vbeln = S_VBELN.
                   ls_final-VHILM_KU = ls_vekp-VHILM_KU.
                   APPEND ls_final to lt_final.
                   ls_final-mark = ''.
*                   MODIFY lt_final FROM ls_final.
                 ENDLOOP.
                 ELSE.
                   MESSAGE 'Box no does not exists.' TYPE 'I'.

               ENDIF.
            else.
              MESSAGE 'Box no does not exists.' TYPE 'I'.
           ENDIF.
           ELSE.
             MESSAGE 'Delivery no does not exists.' TYPE 'I'.
       ENDIF.
      ELSE.
        MESSAGE 'Please enter Document no.' TYPE 'I'.
      ENDIF.
*  	WHEN .
          WHEN 'UPDATE'.
      IF s_VHILM_KU IS INITIAL.
        MESSAGE 'Kindly select Box.' TYPE 'W'.
        ELSE.
       SET SCREEN 2000.
      ENDIF.
    WHEN OTHERS.
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.
  CASE sy-ucomm.
    WHEN 'SAVE'.

    WHEN 'BACK'.
      SET SCREEN 1000.

      S_VHILM_KU = BOX_NO.


*******************************************
*      BREAK-POINT.
**      IF s_vbeln is not INITIAL .
**
**CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
**  EXPORTING
**    INPUT  = s_vbeln
**  IMPORTING
**    OUTPUT = s_vbeln.
**
**        REFRESH lt_final.
**        SELECT vbeln from likp
**        INTO CORRESPONDING FIELDS OF TABLE lt_likp
**        WHERE VBELN eq S_VBELN.
**          IF lt_likp is NOT INITIAL.
**         SELECT venum from vepo
**           INTO CORRESPONDING FIELDS OF TABLE lt_vepo
**           FOR ALL ENTRIES IN lt_likp
**           WHERE vbeln eq lt_likp-vbeln.
**
**           IF lt_vepo  is NOT INITIAL.
**             SELECT VHILM_KU venum FROM vekp
**               INTO CORRESPONDING FIELDS OF TABLE lt_vekp
**               FOR ALL ENTRIES IN lt_vepo
**               WHERE venum eq lt_vepo-venum.
**               IF lt_vekp is NOT INITIAL.
**                 LOOP AT lt_vekp INTO ls_vekp.
**                   ls_final-vbeln = S_VBELN.
**                   ls_final-VHILM_KU = ls_vekp-VHILM_KU.
**                   ls_final1-vbeln = S_VBELN.
**                   ls_final1-VHILM_KU = ls_vekp-VHILM_KU.
**
**                   APPEND ls_final to lt_final.
**                   APPEND ls_final1 to lt_final1.
**
**                   ls_final-mark = ''.
**                   MODIFY lt_final FROM ls_final.
**                 ENDLOOP.
**                 ELSE.
**                   MESSAGE 'Box no does not exists.' TYPE 'I'.
**
**               ENDIF.
**            else.
**              MESSAGE 'Box no does not exists.' TYPE 'I'.
**           ENDIF.
**           ELSE.
**             MESSAGE 'Delivery no does not exists.' TYPE 'I'.
**       ENDIF.
**      ELSE.
**        MESSAGE 'Please enter Document no.' TYPE 'I'.
**      ENDIF.
**
**
********************************************
**    WHEN OTHERS.
  ENDCASE.



ENDMODULE.
