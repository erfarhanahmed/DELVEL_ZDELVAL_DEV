
TYPES: BEGIN OF TY_KONV,
      knumv TYPE konv-knumv,
      kposn TYPE konv-kposn,
      kschl TYPE konv-kschl,
      kbetr TYPE konv-kbetr,
      waers TYPE konv-waers,
      kwert TYPE konv-kwert,
      kinak TYPE konv-kinak,
      END OF TY_KONV,

      BEGIN OF ty_adr6,
      ADDRNUMBER TYPE adr6-ADDRNUMBER,
      CONSNUMBER TYPE adr6-CONSNUMBER,
      SMTP_ADDR  TYPE adr6-SMTP_ADDR,
      END OF ty_adr6.


types : s_type TYPE konv-kwert," p DECIMALS 2,
        s_type1 TYPE p DECIMALS 2,
        S_TYPE2 TYPE P DECIMALS 2,
        s_type3 type konv-kbetr. "p DECIMALS 2.








