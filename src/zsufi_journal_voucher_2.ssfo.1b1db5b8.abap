DATA:str TYPE char255.
*BREAK-POINT.
str = 'شركة دلفال فلو كونترولز الشرق الأوسط المحدودة'.

lv_invno = REVERSE( str ).

*CALL FUNCTION 'STRING_REVERSE'
*  EXPORTING
*    STRING          = str
*    LANG            = 'A'
* IMPORTING
*   RSTRING         = lv_invno.
*lv_invno = lv_invno.





















