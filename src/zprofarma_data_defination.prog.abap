*&---------------------------------------------------------------------*
*&  Include           ZPROFARMA_DATA_DEFINATION
*&---------------------------------------------------------------------*


FORM GET_DATA
     USING    IS_PRINT_DATA_TO_READ TYPE LBBIL_PRINT_DATA_TO_READ
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
*---------------------------------------------------------------------*
*       FORM SET_PRINT_DATA_TO_READ                                   *
*---------------------------------------------------------------------*
*       General provision of data for the form                        *
*---------------------------------------------------------------------*
FORM SET_PRINT_DATA_TO_READ
         USING    IF_FORMNAME LIKE TNAPR-SFORM
         CHANGING CS_PRINT_DATA_TO_READ TYPE LBBIL_PRINT_DATA_TO_READ
                  CF_RETCODE.

  FIELD-SYMBOLS: <FS_PRINT_DATA_TO_READ> TYPE XFELD.
  DATA: LT_FIELDLIST TYPE TSFFIELDS.

* set print data requirements
  DO.
    ASSIGN COMPONENT SY-INDEX OF STRUCTURE
                     CS_PRINT_DATA_TO_READ TO <FS_PRINT_DATA_TO_READ>.
    IF SY-SUBRC <> 0. EXIT. ENDIF.
    <FS_PRINT_DATA_TO_READ> = 'X'.
  ENDDO.

  CALL FUNCTION 'SSF_FIELD_LIST'
    EXPORTING
      FORMNAME                = IF_FORMNAME
*     VARIANT                 = ' '
    IMPORTING
      FIELDLIST               = LT_FIELDLIST
   EXCEPTIONS
     NO_FORM                  = 1
     NO_FUNCTION_MODULE       = 2
     OTHERS                   = 3.
  IF SY-SUBRC <> 0.
*  error handling
    CF_RETCODE = SY-SUBRC.
    PERFORM PROTOCOL_UPDATE.
  ENDIF.

ENDFORM.                    "SET_PRINT_DATA_TO_READ

*&---------------------------------------------------------------------*
*&      Form  get_addr_key
*&---------------------------------------------------------------------*
FORM GET_ADDR_KEY USING    IT_HD_ADR   TYPE LBBIL_INVOICE-HD_ADR
                  CHANGING CS_ADDR_KEY LIKE ADDR_KEY.

  FIELD-SYMBOLS <FS_HD_ADR> TYPE LINE OF LBBIL_INVOICE-HD_ADR.

  READ TABLE IT_HD_ADR ASSIGNING <FS_HD_ADR>
                       WITH KEY BIL_NUMBER = NAST-OBJKY
                                PARTN_ROLE = NAST-PARVW.
  IF SY-SUBRC = 0.
    CS_ADDR_KEY-ADDRNUMBER = <FS_HD_ADR>-ADDR_NO.
    CS_ADDR_KEY-PERSNUMBER = <FS_HD_ADR>-PERSON_NUMB.
    CS_ADDR_KEY-ADDR_TYPE  = <FS_HD_ADR>-ADDRESS_TYPE.
  ENDIF.

ENDFORM.                               " get_addr_key

*&---------------------------------------------------------------------*
*&      Form  get_dlv_land
*&---------------------------------------------------------------------*
FORM GET_DLV-LAND USING    IT_HD_GEN   TYPE LBBIL_INVOICE-HD_GEN
                  CHANGING CS_DLV-LAND LIKE VBRK-LAND1.

  CS_DLV-LAND = IT_HD_GEN-DLV_LAND.


ENDFORM.                               " get_dlv_land
