*---------------------------------------------------------------------*
*       FORM GET_TEXTNAME                                             *
*---------------------------------------------------------------------*
*       get adress textnames
*---------------------------------------------------------------------*
FORM GET_TEXTNAME using    GF_TDNAME
IS_VKORG
CHANGING EF_TXNAM_ADR TYPE TXNAM_ADR
EF_TXNAM_KOP TYPE TXNAM_KOP
EF_TXNAM_FUS TYPE TXNAM_FUS
EF_TXNAM_GRU TYPE TXNAM_GRU
EF_TXNAM_SDB TYPE TXNAM_SDB.

DATA: IS_INVOICE TYPE VBRKVB.
DATA: LF_TEXT_ORG.

* object text name
*GF_TDNAME = IS_BIL_INVOICE-HD_GEN-BIL_NU


* clear textnames
CLEAR: EF_TXNAM_ADR,
EF_TXNAM_KOP,
EF_TXNAM_FUS,
EF_TXNAM_GRU,
EF_TXNAM_SDB.
* invoice number
*  IS_INVOICE-VBELN = IS_BIL_INVOICE-HD_GEN-BIL_NUMBER.
IS_INVOICE-VBELN = GF_TDNAME.

* organisational data
*  IS_INVOICE-VKORG = IS_BIL_INVOICE-HD_ORG-SALESORG.
IS_INVOICE-VKORG = is_vkorg.


* Valid numbers for IF_TABLE:   1     text from sales organisation
*                               2     text from shipping point
*                               3     text from sales office
* default: read text from sales org
LF_TEXT_ORG = '1'.

CALL FUNCTION 'LB_BIL_INVOUTP_TEXT_SELECT'
EXPORTING
IS_INVOICE            = IS_INVOICE
IF_TABLE              = LF_TEXT_ORG
IMPORTING
EF_TDNAME_ADR         = EF_TXNAM_ADR
EF_TDNAME_KOP         = EF_TXNAM_KOP
EF_TDNAME_FUS         = EF_TXNAM_FUS
EF_TDNAME_GRU         = EF_TXNAM_GRU
EF_TDNAME_SDB         = EF_TXNAM_SDB
EXCEPTIONS
RECORDS_NOT_FOUND     = 1
RECORDS_NOT_REQUESTED = 2
OTHERS                = 3.
IF SY-SUBRC <> 0.
ENDIF.

ENDFORM.





