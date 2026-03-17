"Name: \PR:SAPMV45A\FO:USEREXIT_SAVE_DOCUMENT_PREPARE\SE:BEGIN\EI
ENHANCEMENT 0 ZVALIDATION_MRP_DATE.

Data : wa_vbap1 type VBAP.
**************Va01 code commented  by jyoti on 27.06.2024 for idoc testing
* IF  SY-TCODE EQ 'VA01'.
*Data : wa_vbap1 type VBAP.
*  LOOP AT XVBAP[] INTO wa_vbap1 .
*IF wa_vbap1-WERKS EQ 'PL01'.
*IF wa_vbap1-zmrp_date lt sy-datum.
*  MESSAGE | The MRP Date is in the past. | TYPE 'W'. "DISPLAY LIKE 'E'.
*ENDIF.
*ENDIF.
*  ENDLOOP.                                             """"ADDED BY PRANIT 26.06.2024
* ENDIF.

 IF  SY-TCODE EQ 'VA02'.
   if VBAK-ERDAT GE '20240701'.
  LOOP AT XVBAP[] INTO wa_vbap1 .
      SELECT SINGLE ERDAT FROM VBAK INTO wa_vbap1-ERDAT WHERE VBELN = wa_vbap1-vbelN.
IF wa_vbap1-WERKS EQ 'PL01'.
  IF wa_vbap1-zmrp_date IS INITIAL .
     MESSAGE | Please maintain MRP Date. | TYPE 'E'.
   ENDIF.

IF wa_vbap1-zmrp_date lt wa_vbap1-ERDAT.
  MESSAGE | The MRP Date is in the past. | TYPE 'E'. "DISPLAY LIKE 'E'.
ENDIF.
ENDIF.
  ENDLOOP.
  endif.

     if VBAK-ERDAT GE '20241113'.                 """"added by Pranit 13.11.2024
  LOOP AT XVBAP[] INTO wa_vbap1 .
      SELECT SINGLE ERDAT FROM VBAK INTO wa_vbap1-ERDAT WHERE VBELN = wa_vbap1-vbelN.
IF wa_vbap1-WERKS EQ 'PL01'.
  IF wa_vbap1-zexp_mrp_date1 IS INITIAL .
     MESSAGE | Please maintain Expected MRP Date. | TYPE 'E'.
   ENDIF.

IF wa_vbap1-zexp_mrp_date1 lt wa_vbap1-ERDAT.
  MESSAGE | The Expected MRP Date is in the past. | TYPE 'E'. "DISPLAY LIKE 'E'.
ENDIF.
ENDIF.
  ENDLOOP.
  endif.


                                          """"ADDED BY PRANIT 26.06.2024
 ENDIF.
ENDENHANCEMENT.
