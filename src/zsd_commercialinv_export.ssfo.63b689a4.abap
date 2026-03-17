

L_KBETR = GS_HD_KOND_W-KBETR.

L_KBETR = L_KBETR / 10.

replace '0' in l_kbetr with space.
DATA: L_BUKRS TYPE BUKRS.
*BREAK-POINT.

L_BUKRS = IS_BIL_INVOICE-HD_ORG-COMP_CODE.
*IF GS_HD_KOND_W-KSCHL = 'ZEXC' OR GS_HD_KOND_W-KSCHL = 'ZEC1' OR GS_HD_KOND_W-KSCHL = 'ZCST' OR GS_HD_KOND_W-KSCHL = 'ZVAT'.
L_KWERT = GS_HD_KOND_W-KWERT.
*CALL FUNCTION 'ROUND_AMOUNT'
*  EXPORTING
*    AMOUNT_IN           = L_KWERT
*    COMPANY             = L_BUKRS
*    CURRENCY            = 'INR'
* IMPORTING
*   AMOUNT_OUT          = L_KWERT
*          .
*
*ELSE.
*L_KWERT = GS_HD_KOND_W-KWERT.
*ENDIF.
*
*IF GS_HD_KOND_W-KSCHL = 'ZEXC'.
*L_KWERT1 = GS_HD_KOND_W-KWERT.
*ELSE.
*IF GS_HD_KOND_W-KSCHL = 'ZEC1'.
*L_KWERT2 = GS_HD_KOND_W-KWERT.
*G_TOT = L_KWERT1 + L_KWERT2.
*CALL FUNCTION 'ROUND_AMOUNT'
*  EXPORTING
*    AMOUNT_IN           = G_TOT
*    COMPANY             = L_BUKRS
*    CURRENCY            = 'INR'
* IMPORTING
*   AMOUNT_OUT          = G_TOT
*          .
*
*ENDIF.
*ENDIF.

IF gs_hd_kond_w-kschl EQ 'ZASS' OR
gs_hd_kond_w-kschl EQ 'ZE&C' OR
gs_hd_kond_w-kschl EQ 'ZAS1'.
MOVE space TO l_kbetr.
MOVE space TO gs_hd_kond_w-koein.
ENDIF.

























