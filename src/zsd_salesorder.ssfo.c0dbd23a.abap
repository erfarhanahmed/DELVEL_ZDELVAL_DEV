
select single bstdk bstkd
into (GS_PRINTDATA-bstdk, GS_PRINTDATA-bstkd)
from vbkd
where vbeln eq is_vbak-vbeln.
if sy-subrc is initial.
* do nothing.
endif.

select single kunnr adrnr
into (gs_printdata-kunnr, gs_printdata-adrnr1)
from vbpa
where vbeln eq is_vbak-vbeln
and parvw eq 'AG'.

select single kunnr adrnr
into (gs_printdata-kunag, gs_printdata-adrnr2)
from vbpa
where vbeln eq is_vbak-vbeln
and parvw eq 'WE'.

*sold-to address
select single telf2 from kna1
into  gs_printdata-mobile
where kunnr eq gs_printdata-kunnr.

select single *  from adrc
into gs_adrc1
where ADDRNUMBER eq gs_printdata-adrnr1.

SELECT SINGLE LANDX INTO
GS_PRINTDATA-LANDX1
FROM T005T
WHERE LAND1 EQ GS_ADRC1-country
AND SPRAS EQ 'EN'.
if gs_printdata-kunnr ne gs_printdata-kunag.
* Ship to address
*select single adrnr from kna1
*       into gs_printdata-adrnr1
*       where kunnr eq gs_printdata-kunnr.

select single *
from adrc
into gs_adrc2
where ADDRNUMBER eq gs_printdata-adrnr2.

SELECT SINGLE LANDX INTO
GS_PRINTDATA-LANDX2
FROM T005T
WHERE LAND1 EQ GS_ADRC2-country
AND SPRAS EQ 'EN'.
endif.

select single name1 pafkt
into (gs_printdata-name1, gs_printdata-pafkt)
from knvk
where kunnr eq gs_printdata-kunnr.

select single vtext
into gs_printdata-vtext
from tpfkt
where spras eq 'EN'
and pafkt eq gs_printdata-pafkt.

select single smtp_addr
into gs_printdata-email
from adr6
where ADDRNUMBER eq gs_printdata-adrnr1.

select single  J_1IEXCD J_1ICSTNO J_1ILSTNO J_1IPANNO
into (gs_printdata-J_1IEXCD, gs_printdata-J_1ICSTNO,
gs_printdata-J_1ILSTNO, gs_printdata-J_1IPANNO)
from J_1IMOCUST
where KUNNR eq gs_printdata-kunnr.

select single TATYP TAXKD
into (gs_printdata-tatyp, gs_printdata-taxkd)
from knvi
where kunnr eq gs_printdata-kunnr.

select single vtext
into gs_printdata-vtext1
from tskdt
where spras eq 'EN'
and tatyp eq gs_printdata-tatyp
and taxkd eq gs_printdata-taxkd.


