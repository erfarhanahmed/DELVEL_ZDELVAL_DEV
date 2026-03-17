*break-point.
CLEAR V_text.

*******Start of changes by hasan...
IF wa_item-waers NE 'INR'.
WA_ITEM-KBETR = WA_ITEM-KBETR * wa_hdr-kurrf.
ENDIF.
*******End of changes by Hasan....

*V_text = WA_ITEM-KBETR.
"SHIFT v_amount LEFT DELETING LEADING '0'.
CONDENSE V_text.













