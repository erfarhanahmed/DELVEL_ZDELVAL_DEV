"Name: \PR:SAPLV60A\FO:USEREXIT_FILL_VBRK_VBRP\SE:BEGIN\EI
ENHANCEMENT 0 ZIN_EXCHANGE_RATE_AG.










*----------------Enhancement for Material Check in J1IGSUBCON------------------------------
*--------------By Abhishek Pisolkar (31.05.2018)-------------------------------------------
TYPES : BEGIN OF ty_mseg,
     mblnr TYPE mseg-mblnr,
     mjahr TYPE mseg-mjahr,
     matnr TYPE mseg-matnr,
     END OF ty_mseg.
data : it_mseg TYPE TABLE OF ty_mseg,
       wa_mseg type ty_mseg,
       msg TYPE string,
       mtart TYPE mara-mtart.
clear : it_mseg[], wa_mseg.
if vbrk-fkart = 'ZSN'.
  select mblnr
         mjahr
         matnr from mseg into TABLE it_mseg
         WHERE mblnr = vbrp-vbeln.
  IF it_mseg is NOT INITIAL.
  LOOP AT  it_mseg INTO wa_mseg.
    SELECT SINGLE mtart INTO mtart from mara WHERE matnr = wa_mseg-matnr.
      IF  mtart = 'UNBW'
         or  mtart = 'ZCON'
         or mtart = 'ERSA'.
        CONCATENATE  'Creating challan is not allowed for the following material type' wa_mseg-matnr
        INTO msg SEPARATED BY space.
      MESSAGE msg TYPE 'E'.
      ENDIF.
      clear wa_mseg.
  ENDLOOP.
  ENDIF.
  ELSEIF vbrk-fkart = 'ZSP'.
   select mblnr
          mjahr
          matnr from mseg into TABLE it_mseg
          WHERE mblnr = vbrp-vbeln.
  IF it_mseg is NOT INITIAL.
  LOOP AT  it_mseg INTO wa_mseg.
    SELECT SINGLE mtart INTO mtart from mara WHERE matnr = wa_mseg-matnr.
      IF     mtart = 'HALB'
         or  mtart = 'FERT'
         or  mtart = 'ROH'.
*      IF not mtart = 'UNBW'
*          or mtart = 'ZCON'.
        CONCATENATE  'Creating invoice is not allowed for the following material type' wa_mseg-matnr
        INTO msg SEPARATED BY space.
      MESSAGE msg TYPE 'E'.
      ENDIF.
      clear wa_mseg.
  ENDLOOP.
  ENDIF.
    ENDIF.
*--------------------------------------------------------------------*
IF vbrk-vkorg = '1000'. " For Sales Organization 1000

TVCPF-KNPRS = 'G'. """" While creating billing documemt, change the pricing type to 'G' copy without redetermining.

IF VBRK-WAERK ne VBRK-STWAE."'INR'. If Document Currency is not equal to Sales Organization 1000 Currency

CALL FUNCTION 'READ_EXCHANGE_RATE'
  EXPORTING
    CLIENT                  = SY-MANDT
    DATE                    = VBRK-ERDAT     " First VBRK-FKDAT"
    FOREIGN_CURRENCY        = VBRK-WAERK " Document Currency
    LOCAL_CURRENCY          = VBRK-STWAE "'INR' Sales Organization 6000 Currency
    TYPE_OF_RATE            = VBRK-KURST
*   EXACT_DATE              = ' '
 IMPORTING
   EXCHANGE_RATE           = VBRK-KURRF
*   FOREIGN_FACTOR          =
*   LOCAL_FACTOR            =
*   VALID_FROM_DATE         =
*   DERIVED_RATE_TYPE       =
*   FIXED_RATE              =
*   OLDEST_RATE_FROM        =
* EXCEPTIONS
*   NO_RATE_FOUND           = 1
*   NO_FACTORS_FOUND        = 2
*   NO_SPREAD_FOUND         = 3
*   DERIVED_2_TIMES         = 4
*   OVERFLOW                = 5
*   ZERO_RATE               = 6
*   OTHERS                  = 7
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.



CALL FUNCTION 'READ_EXCHANGE_RATE'
  EXPORTING
    CLIENT                  = SY-MANDT
    DATE                    = VBRK-ERDAT         " First VBRK-FKDAT"
    FOREIGN_CURRENCY        = VBRK-WAERK " Document Currency
    LOCAL_CURRENCY          = VBRK-STWAE "'INR' Sales Organization 1000 Currency
    TYPE_OF_RATE            = VBRK-KURST
*   EXACT_DATE              = ' '
 IMPORTING
   EXCHANGE_RATE           = VBRP-KURSK
*   FOREIGN_FACTOR          =
*   LOCAL_FACTOR            =
*   VALID_FROM_DATE         =
*   DERIVED_RATE_TYPE       =
*   FIXED_RATE              =
*   OLDEST_RATE_FROM        =
* EXCEPTIONS
*   NO_RATE_FOUND           = 1
*   NO_FACTORS_FOUND        = 2
*   NO_SPREAD_FOUND         = 3
*   DERIVED_2_TIMES         = 4
*   OVERFLOW                = 5
*   ZERO_RATE               = 6
*   OTHERS                  = 7
          .
IF SY-SUBRC <> 0.
* Implement suitable error handling here
ENDIF.

ENDIF.
ENDIF.

*ENDIF.



IF vbrk-bukrs = '1000' and ( vbrk-fkart = 'ZSN' OR vbrk-fkart = 'ZSP' ).

tvcpf-knprs = 'C'.

ENDIF.

ENDENHANCEMENT.
