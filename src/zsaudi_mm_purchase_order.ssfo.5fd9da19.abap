
BREAK-POINT.
DATA: STRING TYPE CHAR255.
STRING = 'شركة ديلفال فلو كنترولز الشرق الأوسط المحدودة' .

CALL FUNCTION 'STRING_REVERSE'
  EXPORTING
    STRING          = STRING
    LANG            = 'A'
 IMPORTING
   RSTRING         =  LV_INVNO.



.





















