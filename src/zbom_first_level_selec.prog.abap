*&---------------------------------------------------------------------*
*&  Include           ZBOM_FIRST_LEVEL_SELEC
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-002.
PARAMETERS open_so  RADIOBUTTON GROUP code DEFAULT 'X' USER-COMMAND codegen.
PARAMETERS all_so  RADIOBUTTON GROUP code.
SELECTION-SCREEN END OF BLOCK b3.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.

SELECT-OPTIONS   :  s_date FOR wa_vbak-erdat MODIF ID rb2 OBLIGATORY,
*                    s_matnr FOR wa_vbap-matnr MODIF ID rb2,
                    s_kunnr FOR wa_vbak-kunnr MODIF ID rb1,
                    s_vbeln FOR wa_vbak-vbeln MODIF ID rb1.
PARAMETERS :        p_vkorg TYPE vbrk-vkorg MODIF ID rb3 OBLIGATORY DEFAULT '1000'.

SELECTION-SCREEN END OF BLOCK b1.

*SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-001.
*
*SELECT-OPTIONS   :  s_date FOR wa_vbak-erdat," OBLIGATORY ,
*                    s_matnr FOR wa_vbap-matnr,
*                    s_kunnr1 FOR wa_vbak-kunnr,
*                    s_vbeln1 FOR wa_vbap-vbeln.
*
*SELECTION-SCREEN END OF BLOCK b2.



SELECT-OPTIONS:  s_kschl   FOR  wa_konv-kschl NO-DISPLAY .
SELECT-OPTIONS:  s_stat   FOR  wa_jest1-stat NO-DISPLAY .

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/delval/temp'."'E:/delval/temp162'.
SELECTION-SCREEN END OF BLOCK b5.

AT SELECTION-SCREEN OUTPUT.

LOOP AT SCREEN.
  IF open_so = 'X'.
    CASE screen-group1.
      WHEN 'RB1' .
        screen-active = 1.

        MODIFY SCREEN.
      WHEN 'RB3' .
        screen-active = 1.

        MODIFY SCREEN.
      WHEN 'RB2'.
        screen-active = 0.

        MODIFY SCREEN.

    ENDCASE.




  ENDIF.
ENDLOOP.

DATA wa_kschl LIKE s_kschl.
DATA wa_jest LIKE s_stat.
CLEAR: wa_kschl , wa_jest.

wa_kschl-sign = 'I'.
wa_kschl-option = 'EQ'.
wa_kschl-low = 'ZPRO'.
APPEND wa_kschl TO s_kschl.

wa_kschl-sign = 'I'.
wa_kschl-option = 'EQ'.
wa_kschl-low = 'VPRS'.
APPEND wa_kschl TO s_kschl.

wa_jest-sign = 'I'.
wa_jest-option = 'EQ'.
wa_jest-low = 'E0001'.
APPEND wa_jest TO s_stat.

wa_jest-sign = 'I'.
wa_jest-option = 'EQ'.
wa_jest-low = 'E0002'.
APPEND wa_jest TO s_stat.

wa_jest-sign = 'I'.
wa_jest-option = 'EQ'.
wa_jest-low = 'E0003'.
APPEND wa_jest TO s_stat.
