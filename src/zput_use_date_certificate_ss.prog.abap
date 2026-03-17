*&---------------------------------------------------------------------*
*&  Include           ZPUT_USE_DATE_CERTIFICATE_SS
*&---------------------------------------------------------------------*

SELECTION-SCREEN:BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
PARAMETERS: P_BUKRS TYPE MSEG-BUKRS DEFAULT '1000' MODIF ID BU.       ""Company code - 1000.
SELECT-OPTIONS: S_PONO FOR V_PONO,         ""Po NO
                S_POLI FOR V_POLT,         ""PO LINE ITEM NUMBER
                S_MGNO FOR V_MGNO,          ""Po line item
                S_ASCO  FOR V_ASCO.        "" Asset Code.
SELECTION-SCREEN:END OF BLOCK B1.


AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF SCREEN-GROUP1 = 'BU'.
      SCREEN-INPUT = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.
