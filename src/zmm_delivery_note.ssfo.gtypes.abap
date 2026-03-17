
" STRUCTURE FOR ADDRESS "
TYPES: BEGIN OF ty_adrc,
         addrnumber TYPE ad_addrnum, " ADDRESS NUMBER "
         name1      TYPE ad_name1,
         str_suppl1 TYPE ad_strspp1, " STREET 1"
         str_suppl2 TYPE ad_strspp2, " STREET 2 "
         street     TYPE ad_street,  " STREET "
         city1      TYPE ad_city1,   " CITY1"
         post_code1 TYPE ad_pstcd1,  " POSTAL CODE "
         bezei      TYPE bezei20,    " REGION DESRIPTION "
         country    TYPE adrc-country,
         tel_number TYPE adrc-tel_number,
         fax_number TYPE adrc-fax_number,
         extension2 TYPE adrc-extension2,
         smtp_addr  TYPE adr6-smtp_addr,
         landx      TYPE t005t-landx,  "Country name
       END OF ty_adrc.

TYPES: BEGIN OF ty_adr,
         line LIKE adrs-line0,
       END OF ty_adr.










