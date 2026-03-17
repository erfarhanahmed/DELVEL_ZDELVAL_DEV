BREAK PRIMUSABAP.
DATA :day TYPE i.
IF wa_t052-ZPRZ1 IS NOT INITIAL.
  day = wa_t052-ZTAG2.
ELSE.
  day = wa_t052-ZTAG1.
ENDIF.

SELECT SINGLE * FROM vbrK INTO wa_vbrK
  WHERE vbeln = wa_hdr-BIL_NUMBER.

  SELECT SINGLE AUBEL FROM VBRP INTO @WA_HDR-BIL_NUMBER
    WHERE VBELN = @wa_hdr-BIL_NUMBER.
*DUE_DATE = WA_HDR-BIL_DATE + Day.

DUE_DATE = wa_vbrk-fkdat + Day.

*CLEAR WA_T247.
*CALL FUNCTION 'IDWT_READ_MONTH_TEXT'
*  EXPORTING
*    langu         = sy-langu
*    month         = DUE_DATE+4(2)
* IMPORTING
*   T247          = WA_T247
*          .

TRANSLATE wa_t247-ktx+1(2) TO LOWER CASE.
concatenate DUE_DATE+4(2)  DUE_DATE+6(2) DUE_DATE+0(4)
                INTO GV_DUE_DATE SEPARATED BY '.'.






