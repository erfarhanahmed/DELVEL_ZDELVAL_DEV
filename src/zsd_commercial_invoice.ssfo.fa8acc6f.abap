SELECT SINGLE xblnr INTO odn FROM vbrk WHERE
  vbeln = IS_BIL_INVOICE-HD_GEN-BIL_NUMBER.

CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
  EXPORTING
    INPUT         = odn
 IMPORTING
   OUTPUT         = odn
          .






















