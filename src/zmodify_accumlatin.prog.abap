*&---------------------------------------------------------------------*
*& Report ZMODIFY_ACCUMLATIN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZMODIFY_ACCUMLATIN.

TABLES : fiwtin_acc_exem.

SELECTION-SCREEN BEGIN OF BLOCK b001 WITH FRAME TITLE text-001.

PARAMETERS: pbukrs LIKE fiwtin_acc_exem-bukrs OBLIGATORY.
PARAMETERS: paccno LIKE fiwtin_acc_exem-accno OBLIGATORY.
PARAMETERS: pwitht LIKE fiwtin_acc_exem-witht OBLIGATORY.
PARAMETERS: pwithcd LIKE fiwtin_acc_exem-wt_withcd OBLIGATORY.
PARAMETERS: psecco LIKE fiwtin_acc_exem-secco OBLIGATORY.
PARAMETERS: pwt_date LIKE fiwtin_acc_exem-wt_date OBLIGATORY .
PARAMETERS: pkoart LIKE fiwtin_acc_exem-koart OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b001.

SELECTION-SCREEN BEGIN OF BLOCK b002 WITH FRAME TITLE text-002.

PARAMETERS: pacc_amt LIKE fiwtin_acc_exem-acc_amt OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b002.


Data: ltfiwtin_acc_exem TYPE fiwtin_acc_exem.


SELECT SINGLE * FROM fiwtin_acc_exem Into ltfiwtin_acc_exem
  WHERE BUKRS eq pbukrs and
        ACCNO eq paccno AND
        WITHT eq pwitht and
        WT_WITHCD eq pwithcd AND
        SECCO eq psecco AND
        WT_DATE eq pwt_date AND
        KOART eq pkoart.

  if sy-subrc <> 0.
    WRITE: 'No such exemption maintained, please check the details in vednor master'.
      exit.
  ENDIF.

ltfiwtin_acc_exem-acc_amt = ltfiwtin_acc_exem-acc_amt - pacc_amt.


UPDATE fiwtin_acc_exem FROM ltfiwtin_acc_exem.

  If sy-subrc eq 0.

    WRITE: 'accumulation amount has been modified'.

  ELSE.

    WRITE: 'could not modify the accumulation.'.
  ENDIF.
