*break-point.

tables: vepo.
*data: l_vbeln type vbeln.
data: begin of lt_box occurs 0,
VENUM like VEPO-VENUM,
end of lt_box.

select VENUM from vepo
into table lt_box
where vbeln = IS_BIL_INVOICE-HD_REF-DELIV_NUMB.

delete adjacent duplicates from lt_box.
loop at lt_box.
G_BOX = G_BOX + 1.
ENDLOOP.




















