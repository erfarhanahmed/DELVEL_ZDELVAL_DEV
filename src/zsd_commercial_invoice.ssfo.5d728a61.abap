
SELECT  VBELN
        WERKS
        FKIMG
        FROM VBRP
        INTO CORRESPONDING FIELDS OF TABLE  IT_VBRP
        WHERE VBELN     = IS_BIL_INVOICE-HD_GEN-BIL_NUMBER.

READ TABLE IT_VBRP INTO WA_VBRP WITH KEY
              VBELN = IS_BIL_INVOICE-HD_GEN-BIL_NUMBER.

V_FKIMG = WA_VBRP-FKIMG.

IF NOT IT_VBRP IS INITIAL.

select  J_1IEXCD
        J_1ICSTNO
        j_1ilstno
  INTO CORRESPONDING FIELDS OF TABLE it_J_1Imocomp
  from j_1imocomp
         WHERE BUKRS = IS_BIL_INVOICE-HD_ORG-COMP_CODE
         AND   WERKS = WA_VBRP-WERKS.

  read table it_J_1Imocomp INTO    wa_J_1Imocomp index 1.
  SHIFT wa_J_1Imocomp-j_1ilstno right up to '/'.
  REPLACE '/' in wa_J_1Imocomp-j_1ilstno with ' '.
  condense wa_J_1Imocomp-j_1ilstno .
   SHIFT wa_J_1Imocomp-j_1icstno right up to '/'.
  REPLACE '/' in wa_J_1Imocomp-j_1icstno with ' '.
  condense wa_J_1Imocomp-j_1icstno .


  SELECT BUKRS
         WERKS
         EXNUM
         EXDAT
         EXCCD
         LSTNO
         CSTNO
         FROM J_1IEXCHDR
         INTO CORRESPONDING FIELDS OF TABLE it_J_1IEXCHDR
         WHERE    rdoc = is_bil_invoice-hd_gen-bil_number.
    read table it_J_1IEXCHDR INTO    wa_J_1IEXCHDR index 1.
ENDIF.
