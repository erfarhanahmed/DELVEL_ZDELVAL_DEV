TYPES : BEGIN OF T_VBRK,
          VBELN TYPE VBELN_VF,
          KNUMV TYPE KNUMV,
          FKDAT TYPE FKDAT,
*          RFBSK  TYPE RFBSK, " Status for transfer to accounting
          NETWR	TYPE NETWR, "	Net Value in Doc Curr
          MWSBK	TYPE MWSBP, "	Tax amount in doc curr
          FKSTO type FKSTO, " Billing document is cancelled
        END OF T_VBRK,

        BEGIN OF T_VBRP,
          VBELN TYPE VBELN_VF,  " Billing Document
          AUBEL TYPE VBELN_VA,  " Sales Document
        END OF T_VBRP,

        BEGIN OF T_VBAK,
          VBELN TYPE VBELN_VA,  "	Sales Document
          BSTNK TYPE BSTNK,     " Customer purchase order number
          BSTDK TYPE BSTDK,     " Customer purchase order date
        END OF T_VBAK,

*        BEGIN OF T_KNA1,
*          KUNNR TYPE KUNNR,
*          NAME1 TYPE NAME1_GP, " CUSTOMER NAME
*        END OF T_KNA1,

        BEGIN OF T_KONV,
          KNUMV TYPE KNUMV,
          KPOSN TYPE KPOSN,
          KWERT TYPE KWERT,   " CONDITION VALUE
          WAERS TYPE WAERS,   "	CURRENCY KEY
        END OF T_KONV,

        BEGIN OF T_ZFRMC,
          VBELN TYPE VBELN_VF,
          FRCVD TYPE ZRCVD,
          FRDAT TYPE ZFRDT,
          FRVAL TYPE ZFRVAL,
          CRUNT TYPE WAERS,
        END OF T_ZFRMC,

        BEGIN OF T_RESULT,
          KUNNR TYPE KUNNR,
          NAME1 TYPE NAME1,
          ADRNR TYPE ADRNR,
          QURTR TYPE char9,
          QRTRE TYPE SY-DATUM,
          CST   TYPE J_1ICSTNO,
          LST   TYPE J_1ILSTNO,
        END OF T_RESULT,

        BEGIN OF T_QURTR,
          ID(3) TYPE C,
          B TYPE NUM2,
          E TYPE NUM2,
        END OF T_QURTR,

        TT_QURTR TYPE TABLE OF T_QURTR,

        BEGIN OF T_CNDTN,
          STR(50) TYPE c,
        END OF T_CNDTN,

        BEGIN OF T_RES,
          VBELN TYPE VBELN_VF,
          FKDAT TYPE FKDAT,
          KWERT TYPE KWERT,
          FRVAL TYPE ZFRVAL,
          FRDAT TYPE ZFRDT,
          CRUNT TYPE WAERS,
          QURTR TYPE CHAR9,
          PONUM TYPE BSTNK,     " CUSTOMER PURCHASE ORDER NUMBER
          PODAT TYPE BSTDK,     " CUSTOMER PURCHASE ORDER DATE
        END OF T_RES,

        TT_RES TYPE TABLE OF T_RES,

        begin of t_adrc,
          NAME1	      TYPE AD_NAME1,    " Name
          CITY2	      TYPE AD_CITY2,    "	District
          POST_CODE1  TYPE AD_PSTCD1,   " City postal code
          STREET      TYPE AD_STREET,   " Street
          STR_SUPPL1  TYPE AD_STRSPP1,  " Street 2
          STR_SUPPL2  TYPE AD_STRSPP2,  " Street 3
        end of  t_adrc.













