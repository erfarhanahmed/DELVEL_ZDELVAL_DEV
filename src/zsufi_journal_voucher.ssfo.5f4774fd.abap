DATA:str TYPE char255.
str = 'شركة دلفال فلو كونترولز الشرق الأوسط المحدودة'.
CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = str
    LANG            = 'A'
 IMPORTING
   RSTRING         = lv_invno.





















