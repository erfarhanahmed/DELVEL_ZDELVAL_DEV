*&---------------------------------------------------------------------*
*& USER INTERFACE
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE title1.
SELECT-OPTIONS :"S_VTWEG FOR VBRK-VTWEG,
*                S_SPART FOR VBRK-SPART,
*                S_VKBUR FOR VBRP-VKBUR,
*                S_VBELN FOR VBRK-VBELN,
*                S_CHARG FOR VBRP-CHARG,
                s_dt FOR sy-datum OBLIGATORY.   "FOR SY-DATUM .
SELECTION-SCREEN END OF BLOCK b1.

SELECT-OPTIONS:  s_vbtyp   FOR vbrk-vbtyp NO-DISPLAY .
SELECT-OPTIONS:  s_fkart   FOR vbrk-fkart NO-DISPLAY .
SELECT-OPTIONS:  s_kschl   FOR konv-kschl NO-DISPLAY .
SELECT-OPTIONS:  s_ledger FOR tvktt-vtext NO-DISPLAY .


*data: wa_status type vbup-lfsta.
DATA: wa_vbtyp  LIKE s_vbtyp,
      wa_fkart  LIKE s_fkart,
      wa_kschl  LIKE s_kschl,
      wa_ledger LIKE s_ledger.

CLEAR: wa_fkart, wa_vbtyp, wa_kschl, wa_ledger.

****wa_ledger-sign = 'I'.
****wa_ledger-option = 'EQ'.
****wa_ledger-low = 'SALES - FORM CT - 3'.
****APPEND wa_ledger TO s_ledger.
****
****wa_ledger-sign = 'I'.
****wa_ledger-option = 'EQ'.
****wa_ledger-low = 'SALES-FORM CT-3 (MS)'.
****APPEND wa_ledger TO s_ledger.
****
****wa_ledger-sign = 'I'.
****wa_ledger-option = 'EQ'.
****wa_ledger-low = 'SALES-EXPORT (SEZ)'.
****APPEND wa_ledger TO s_ledger.
****
****wa_vbtyp-sign = 'I'.
****wa_vbtyp-option = 'EQ'.
****wa_vbtyp-low = 'M'.
****APPEND wa_vbtyp TO s_vbtyp.
****
****wa_vbtyp-sign = 'I'.
****wa_vbtyp-option = 'EQ'.
****wa_vbtyp-low = 'O'.
****APPEND wa_vbtyp TO s_vbtyp.
****
****wa_vbtyp-sign = 'I'.
****wa_vbtyp-option = 'EQ'.
****wa_vbtyp-low = 'P'.
****APPEND wa_vbtyp TO s_vbtyp.
****
********wa_fkart-sign = 'I'.  "commented by Abhay 13.04.2017
********wa_fkart-option = 'EQ'.
********wa_fkart-low = 'ZDEX'.
********APPEND wa_fkart TO s_fkart.
********
********wa_fkart-sign = 'I'.
********wa_fkart-option = 'EQ'.
********wa_fkart-low = 'ZF1'.
********APPEND wa_fkart TO s_fkart.
********
********wa_fkart-sign = 'I'.
********wa_fkart-option = 'EQ'.
********wa_fkart-low = 'ZF2'.
********APPEND wa_fkart TO s_fkart.
********
********wa_fkart-sign = 'I'.
********wa_fkart-option = 'EQ'.
********wa_fkart-low = 'ZG2'.
********APPEND wa_fkart TO s_fkart.
********
********wa_fkart-sign = 'I'.
********wa_fkart-option = 'EQ'.
********wa_fkart-low = 'ZL2'.
********APPEND wa_fkart TO s_fkart.
********
********wa_fkart-sign = 'I'.
********wa_fkart-option = 'EQ'.
********wa_fkart-low = 'ZRE'.
********APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZASH'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZCR'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZDEX'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZDOM'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZDR'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZEXP'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZFOC'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZFRS'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZRE'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZSER'.
****APPEND wa_fkart TO s_fkart.
****
****wa_fkart-sign = 'I'.
****wa_fkart-option = 'EQ'.
****wa_fkart-low = 'ZSUP'.
****APPEND wa_fkart TO s_fkart.
****
****wa_kschl-sign = 'I'.
****wa_kschl-option = 'EQ'.
****wa_kschl-low = 'ZLST'.
****APPEND wa_kschl TO s_kschl.
****
****wa_kschl-sign = 'I'.
****wa_kschl-option = 'EQ'.
****wa_kschl-low = 'ZCST'.
****APPEND wa_kschl TO s_kschl.


INITIALIZATION.
  title1 = 'Sales Register for the Period of'.
