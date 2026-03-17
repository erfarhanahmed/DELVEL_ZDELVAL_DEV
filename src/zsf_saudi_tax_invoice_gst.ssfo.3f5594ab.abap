DATA:str TYPE char255.
*BREAK-POINT.


str = 'شركة ديلفال فلو كنترولز الشرق الأوسط المحدودة' .



LV_TAX = REVERSE( str ).

**LV_TAX1 = 'شركة ديلفال فلو كنترولز ال
**LV_TAX2 = .

SPLIT LV_TAX AT ' ' INTO LV_TAX1 LV_TAX2.

CONDENSE LV_TAX1 NO-GAPS.
CONDENSE LV_TAX2 NO-GAPS.

**CONDENSE LV_TAX NO-GAPS.





















