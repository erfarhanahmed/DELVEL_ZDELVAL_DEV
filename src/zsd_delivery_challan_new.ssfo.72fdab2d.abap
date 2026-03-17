CLEAR LV_CHALLANNO.




LOOP AT GT_MSEG INTO GS_MSEG.


IF GS_MSEG-MBLNR IS NOT INITIAL.

  SELECT SINGLE CHALLANNO
           FROM ZSU_CHALLANNO
           INTO LV_CHALLANNO
           WHERE MATDOCNO = GS_MSEG-MBLNR
           AND PLANT = GS_MSEG-WERKS.

ENDIF.

*BREAK-POINT.
IF LV_CHALLANNO IS INITIAL.
*DATA NR_RANGE_NR TYPE INRI-NRRANGENR.
*DATA OBJECT      TYPE INRI-OBJECT.
DATA LV_NUM    TYPE ZSU_CHALLANNO-CHALLANNO.

CALL FUNCTION 'NUMBER_GET_NEXT'
  EXPORTING
    NR_RANGE_NR                   = '01'
    OBJECT                        = 'ZSU_CH02'
   QUANTITY                      = '00000000000000000001'
*   SUBOBJECT                     = ' '
   TOYEAR                        = GS_MSEG-Gjahr "'2024'
*   IGNORE_BUFFER                 = ' '
 IMPORTING
   NUMBER                        = LV_NUM
*   QUANTITY                      = QUANTITY
*   RETURNCODE                    = RETURNCODE
 EXCEPTIONS
   INTERVAL_NOT_FOUND            = 1
   NUMBER_RANGE_NOT_INTERN       = 2
   OBJECT_NOT_FOUND              = 3
   QUANTITY_IS_0                 = 4
   QUANTITY_IS_NOT_1             = 5
   INTERVAL_OVERFLOW             = 6
   BUFFER_OVERFLOW               = 7
   OTHERS                        = 8
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

      LV_CHALLANNO  =  LV_NUM.


  DATA: wa_challanno TYPE  ZSU_CHALLANNO.

    wa_challanno-YEAR1 = GS_MSEG-Gjahr.
    wa_challanno-PLANT = GS_MSEG-WERKS.
    wa_challanno-MATDOCNO = GS_MSEG-MBLNR.
    wa_challanno-CHALLANNO = LV_CHALLANNO.

  wa_challanno-CHALLAN_DATE = SY-DATUM.
ENDIF.

   INSERT ZSU_CHALLANNO FROM wa_challanno.
ENDLOOP.

IF LV_CHALLANNO IS NOT INITIAL.

  LV_DATE = SY-DATUM.
  ENDIF.

CLEAR:GS_MSEG,WA_CHALLANNO.


