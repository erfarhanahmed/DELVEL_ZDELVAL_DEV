*&---------------------------------------------------------------------*
*& Report ZSU_DELIVERY_CHALLAN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSU_DELIVERY_CHALLAN.

INCLUDE ZSU_DELIVERY_CHALLAN_DEC.

INCLUDE ZSU_DELIVERY_CHALLAN_SS.

INCLUDE ZSU_DELIVERY_CHALLAN_GET.



START-OF-SELECTION.

IF MOD_CRE IS INITIAL.
PERFORM GET_DATA.
PERFORM PROCESS_DATA.
PERFORM DISPLAY_DATA.

ELSE.
  SELECT * FROM ZSU_CHALLANNO INTO TABLE IT_SU_CHALL
                    WHERE MATDOCNO IN S_MBLNR
                     AND   CHALLANNO  NE ' '
                     AND   PLANT     IN S_WERKS.

  CALL TRANSACTION 'ZSU_CHALLAN_DISPLAY'.
ENDIF.
