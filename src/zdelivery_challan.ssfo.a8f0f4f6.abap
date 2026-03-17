
*BREAK fujiabap.
SELECT SINGLE bktxt FROM MKPF INTO GV_BKTXT
  WHERE MBLNR = GS_J_1IG_SUBCON-MBLNR.
*-----------Added By Abhishek Pisolkar (10.04.2018)
SELECT SINGLE XBLNR INTO GV_XBLNR
  FROM VBRK WHERE VBELN = LS_BIL_INVOICE-HD_GEN-BIL_NUMBER.
*--------------------------------------------------------------------*






