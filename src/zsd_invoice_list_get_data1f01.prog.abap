*----------------------------------------------------------------------*
***INCLUDE ZSD_INVOICE_LIST_GET_DATA1F01 .
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  GET_DATA1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_LS_PRINT_DATA_TO_READ  text
*      <--P_LS_ADDR_KEY  text
*      <--P_LS_DLV_LAND  text
*      <--P_LS_BIL_INVOICE  text
*      <--P_CF_RETCODE  text
*----------------------------------------------------------------------*
FORM GET_DATA1    USING    IS_PRINT_DATA_TO_READ TYPE LBBIL_PRINT_DATA_TO_READ
     CHANGING CS_ADDR_KEY           LIKE ADDR_KEY
              CS_DLV-LAND           LIKE VBRK-LAND1
              CS_BIL_INVOICE        TYPE LBBIL_INVOICE
              CF_RETCODE.



  IF NAST-OBJKY+10 NE SPACE.
    NAST-OBJKY = NAST-OBJKY+16(10).
  ELSE.
    NAST-OBJKY = NAST-OBJKY.
  ENDIF.


* read print data
  CALL FUNCTION 'LB_BIL_INV_OUTP_READ_PRTDATA'
    EXPORTING
      IF_BIL_NUMBER         = NAST-OBJKY
      IF_PARVW              = NAST-PARVW
      IF_PARNR              = NAST-PARNR
      IF_LANGUAGE           = NAST-SPRAS
      IS_PRINT_DATA_TO_READ = IS_PRINT_DATA_TO_READ
    IMPORTING
      ES_BIL_INVOICE        = CS_BIL_INVOICE
    EXCEPTIONS
      RECORDS_NOT_FOUND     = 1
      RECORDS_NOT_REQUESTED = 2
      OTHERS                = 3.
  IF SY-SUBRC <> 0.
*  error handling
    CF_RETCODE = SY-SUBRC.
    PERFORM PROTOCOL_UPDATE.
  ENDIF.

* get nast partner adress for communication strategy
  PERFORM GET_ADDR_KEY USING    CS_BIL_INVOICE-HD_ADR
                       CHANGING CS_ADDR_KEY.

* get delivery land
  PERFORM GET_DLV-LAND USING    CS_BIL_INVOICE-HD_GEN
                       CHANGING CS_DLV-LAND.

ENDFORM.               "GET_DATA
*
