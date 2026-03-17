*&---------------------------------------------------------------------*
*& Report ZBDC_F_02_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZBDC_F_02_NEW.

*******************TABLE DECLARATION
TABLES : bkpf,bseg,rf05a,cobl.
TYPES: truxs_fileformat        TYPE trtm_format.
TYPES: truxs_t_text_data(4096) TYPE c OCCURS 0.
DATA : it_raw                  TYPE truxs_t_text_data.
DATA : bdcdata                 TYPE STANDARD TABLE OF bdcdata WITH HEADER LINE.
DATA : count(4)                TYPE n.
DATA : filename                TYPE string.
DATA : f_file        TYPE string,
       wa_bdcmsgcoll TYPE bdcmsgcoll,
       it_bdcmsgcoll TYPE STANDARD TABLE OF bdcmsgcoll.
DATA : ctu_mode.
DATA : input TYPE string.
DATA : v_options TYPE ctu_params.
DATA: flag_x TYPE flag.

*******************DATA DECLARATION
TYPES: BEGIN OF itab_types ,
         BLART(10),
         BUKRS(10),
         bldat(10),              "Document Date
         budat(10),              "Posting Date
         MONAT(10),
         WAERS(10),
         XBLNR(10),
         newbs(02),              "Posting Key
         newko(17),              "Account No
*         newum(01),              "Special GL Indicator
         wrbtr(13),              "Amount
         MWSKZ(10),
         kostl(10),              "Cost Center
*         zfbdt(10),              "Due on date
         sgtxt(50),              "Text
         prctr(10),              "Profit Center
       END OF itab_types .

DATA : itab_upload TYPE TABLE OF itab_types,
       itab        TYPE itab_types.
DATA : dd(02),
       mm(02),
       yyyy(04),
       bldat_output(10),
       dd1(02),
       mm1(02),
       yyyy1(04),
       budat_output(10).

************************INTERNAL TABLE DECLARATION***********************
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : mod LIKE ctu_params-dismode DEFAULT 'E'.
PARAMETERS : upd LIKE ctu_params-updmode DEFAULT 'L'.
PARAMETERS : in_put LIKE rlgrap-filename." DEFAULT 'C:\Documents and Settings\Admin\Desktop\FI_Salary_06.02.2010\SAL_TEXT.txt'.
SELECTION-SCREEN END   OF BLOCK b1.



AT SELECTION-SCREEN ON VALUE-REQUEST FOR in_put.
  count = 0.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = in_put.
  IF sy-subrc <> 0.
  ENDIF.

START-OF-SELECTION.
*----------------------------------------------------------------------*
*                        START  OF    SELECTION                        *
*---------------------------------------------------------------------*
START-OF-SELECTION.
*  input = in_put.
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*     I_FIELD_SEPERATOR    =
*     I_LINE_HEADER        =
      i_tab_raw_data       = it_raw
      i_filename           = in_put
    TABLES
      i_tab_converted_data = itab_upload
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

********************PERMANENT VENDOR****************************
  DELETE itab_upload INDEX 1.
*if per = 'X' OR temp = 'X'.                      "PERMANENT VENDOR
  LOOP AT itab_upload INTO itab.

    CLEAR: flag_x.
    IF itab-newbs EQ '50'.
      flag_x = 'X'.
    ELSE.
      flag_x = space.
    ENDIF.

    PERFORM insert_date.

    count = count + 1.

    IF count EQ 1.

      dd = itab-bldat+6.
      mm = itab-bldat+4.
      yyyy = itab-bldat.

      dd1 = itab-budat+6.
      mm1 = itab-budat+4.
      yyyy1 = itab-budat.

      CONCATENATE dd mm yyyy INTO bldat_output SEPARATED BY '.'.
      CONCATENATE dd1 mm1 yyyy1 INTO budat_output SEPARATED BY '.'.


      PERFORM bdc_dynpro USING 'SAPMF05A' '0100'.
      PERFORM bdc_field USING 'BDC_CURSOR'
                            'RF05A-NEWKO'.
      PERFORM bdc_field USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field USING 'BKPF-BLDAT'
                               itab-bldat.
      PERFORM bdc_field USING 'BKPF-BLART'
                               itab-blart."    'SA'.
      PERFORM bdc_field USING 'BKPF-BUKRS'
                               itab-bukrs."     '1000'.
      PERFORM bdc_field USING 'BKPF-BUDAT'
                               itab-budat.
      perform bdc_field using 'BKPF-MONAT'
                              itab-monat.
      PERFORM bdc_field USING 'BKPF-WAERS'
                               itab-waers."     'INR'.
       PERFORM bdc_field       USING 'BKPF-XBLNR'
                                itab-xblnr.  "'1234'.
      PERFORM bdc_field USING 'RF05A-NEWBS'
                               itab-newbs.
      PERFORM bdc_field USING 'RF05A-NEWKO'
                               itab-newko.
      PERFORM bdc_dynpro USING 'SAPMF05A' '0300'.
      PERFORM bdc_field USING 'BDC_CURSOR'
                              'RF05A-NEWKO'.
      PERFORM bdc_field USING 'BDC_OKCODE'
                                    '/00'.
      PERFORM bdc_field USING 'BSEG-WRBTR'
                               itab-wrbtr.
      PERFORM bdc_field USING 'BSEG-SGTXT'
                                        itab-sgtxt.
       PERFORM bdc_field       USING 'BSEG-MWSKZ'
                               itab-mwskz.    "'V0'.
      IF NOT itab-kostl IS INITIAL.
        PERFORM bdc_field USING 'COBL-KOSTL'
                                 itab-kostl.
      ENDIF.

    ELSE.
      PERFORM bdc_field       USING 'RF05A-NEWBS'           "Posting Key   UNCOMMENTED IT
                                      itab-newbs.
      PERFORM bdc_field       USING 'RF05A-NEWKO'           "Account No    UNCOMMENTED IT
                                      itab-newko.
*      PERFORM bdc_field       USING 'RF05A-NEWUM'           "Special Gl Indicator UNCOMMENTED IT
*                                      itab-newum.


        IF itab-newbs EQ '50'.
          PERFORM bdc_dynpro      USING 'SAPMF05A' '0300'.
          PERFORM bdc_field       USING 'BDC_CURSOR'
                                        'BSEG-SGTXT'.
          PERFORM bdc_field       USING 'BDC_OKCODE'
                                        '=BS'.
          PERFORM bdc_field       USING 'BSEG-WRBTR'
                                         itab-wrbtr.

          PERFORM bdc_field       USING 'COBL-PRCTR'
                                         itab-prctr.
          PERFORM bdc_field       USING 'BSEG-SGTXT'
                                        itab-sgtxt.
          IF NOT itab-kostl IS INITIAL.
          PERFORM bdc_field USING 'COBL-KOSTL'                 "Cost Center
                                     itab-kostl.
          ENDIF.

        ELSE.

          PERFORM bdc_dynpro USING 'SAPMF05A' '0300'.
          PERFORM bdc_field USING 'BDC_CURSOR'
                                'RF05A-NEWKO'.
          PERFORM bdc_field USING 'BDC_OKCODE'
                                        '/00'.
          PERFORM bdc_field USING  'BSEG-WRBTR'                  "Amount
                                    itab-wrbtr.
*             PERFORM bdc_field USING 'COBL-KOSTL'                 "Cost Center
*                                     itab-kostl.
          PERFORM bdc_field       USING 'COBL-PRCTR'
                                         itab-prctr.
          PERFORM bdc_field USING  'BSEG-SGTXT'                  "text
                                 itab-sgtxt." "itab-wrbtr.
          PERFORM bdc_field USING 'RF05A-NEWBS'                  "Posting Key
                                    itab-newbs.
          PERFORM bdc_field USING 'RF05A-NEWKO'                  "Account No
                                    itab-newko.
*          PERFORM bdc_field USING 'RF05A-NEWUM'                  "Special Gl Indicator
*                                    itab-newum.
          IF NOT itab-kostl IS INITIAL.
            PERFORM bdc_field USING 'COBL-KOSTL'                 "Cost Center
                                     itab-kostl.
          ENDIF.

        ENDIF.
**        *******************************


    ENDIF.
******POSTING KEY 31
    AT LAST.

      IF flag_x EQ 'X'.

        PERFORM bdc_dynpro      USING 'SAPMF05A' '0700'.
        PERFORM bdc_field       USING 'BDC_CURSOR'
                                      'RF05A-NEWBS'.
        PERFORM bdc_field USING 'BDC_OKCODE'
                                       '/00'.

        PERFORM bdc_field       USING 'BDC_OKCODE'
                                      '=BU'.
      ELSE.


        PERFORM bdc_dynpro USING 'SAPMF05A' '0304'.        "PERMANENT VENDOR
*        perform bdc_dynpro using 'SAPMF05A' '0302'.
        PERFORM bdc_field USING 'BDC_OKCODE'
                                       '/00'.
        PERFORM bdc_field USING 'BDC_OKCODE'
                                       '=BU'.
      ENDIF.

      v_options-dismode = mod.
      v_options-updmode = upd.
      v_options-nobinpt = 'X'.
      v_options-nobiend = 'X'.
      CALL TRANSACTION 'F-02'
               USING bdcdata
               OPTIONS FROM v_options.
      REFRESH bdcdata.
    ENDAT.
  ENDLOOP .



*&--------------------------------------------------------------------*
*&      Form  INSERT_DATE
*&--------------------------------------------------------------------*
*       text
*---------------------------------------------------------------------*
FORM insert_date.


ENDFORM.                    "INSERT_DATE


*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*

FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*

FORM bdc_field USING fnam fval.
  CLEAR bdcdata.
  bdcdata-fnam = fnam.
  bdcdata-fval = fval.
  APPEND bdcdata.
ENDFORM.                    "BDC_FIELD
