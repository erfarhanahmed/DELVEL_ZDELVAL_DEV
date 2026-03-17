*&---------------------------------------------------------------------*
*& Report ZSD_CUST_UPLOAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT  zsd_cust_upload NO STANDARD PAGE HEADING
        MESSAGE-ID zdel.

TYPE-POOLS: truxs.
*----------------------------------------------------------------------*
*  Types Declaration
*----------------------------------------------------------------------*
TYPES : BEGIN OF t_record,
          ktokd(4)       TYPE  c,  " Customer Account Group/RF02D-KTOKD
          kunnr(10)      TYPE  c,  "+Customer code
          bukrs(4)       TYPE  c,  " Company Code/RF02D-BUKRS
          vkorg(4)       TYPE  c,  " Sales Organization/RF02D-VKORG
          vtweg(2)       TYPE  c,  " Distribution Channel/RF02D-VTWEG
          spart(2)       TYPE  c,  " Division/RF02D-SPART
          title_medi(30) TYPE  c,  " Title text/ SZA1_D0100-TITLE_MEDI
          name1(35)      TYPE  c,  " Name 1/ ADDR1_DATA-NAME1
          name2(35)      TYPE  c,  " Name 2
          name3(35)      TYPE  c,  "+Name   -BLANK NOT USED
          sort1(10)      TYPE  c,  " Serch Term
          str_suppl1(40) TYPE  c,  " Street 2/ ADDR1_DATA-STR_SUPPL1
          str_suppl2(40) TYPE  c,  " Street 3/ ADDR1_DATA-STR_SUPPL2
          street(40)     TYPE  c,
          str_suppl3(40) TYPE  c,  "+
          house_num1(30) TYPE  c,  " Street/ ADDR1_DATA-STREET
          location(40)   TYPE  c,  "+
          post_code1(10) TYPE  c,  " City postal code/ ADDR1_DATA-POST_CODE1
          city2(30)      TYPE  c,  "+District
          city1(40)      TYPE  c,  " City/ ADDR1_DATA-CITY1
          country(3)     TYPE  c,  " Country Key/ ADDR1_DATA-COUNTRY
          region(3)      TYPE  c,  " Region (State, Province, County)/ TYADDR1_DATA-REGION
          langu(2)       TYPE  c,
*           TIME_ZONE(10)    TYPE  C,
          tel_number(30) TYPE  c,  " First telephone no.: dialling code+number/ SZA1_D0100-TEL_NUMBER
          mob_number(30) TYPE  c,  " First Mobile Telephone No.: Dialing Code + Number/ SZA1_D0100-MOB_NUMBER
          fax_number(20) TYPE  c,  " Fax number
          smtp_addr(241) TYPE  c,  " E-Mail Address/ SZA1_D0100-SMTP_ADDR
          akont(10)      TYPE  c,  " Reconciliation Account in General Ledger/ KNB1-AKONT
          altkn(10)      TYPE  c,  " Previous Acct no.
          zuawa(3)       TYPE  c,  "+Sort Key
          zter1(4)       TYPE  c,  "+Terms of Payment Key/ KNVV-ZTERM
          xverr(1)       TYPE  c,  "+Customer is also vendor
          zwels(10)      TYPE  c,  " Payment Methods
          knrzb(10)      TYPE  c,  "+Alternate Payer
          hbkid(5)       TYPE  c,  "+House Bank
          vkbur(4)       TYPE  c,  " Sales Office/ KNVV-VKBUR
          kdgrp(2)       TYPE  c,  " Customer group
          waers(3)       TYPE  c,  " Currency
          kalks(1)       TYPE  c,  " Pricing procedure assigned to this customer/KNVV-KALKS
          versg(2)       TYPE  c,  " Customer statistics group
          kvgr1(2)       TYPE  c,  "+Customer group1
          lprio(2)       TYPE  c,  " Delivery Priority
          vsbed(2)       TYPE  c,  " Shipping Conditions/ KNVV-VSBED
          vwerk(4)       TYPE  c,  " Delivering Plant (Own or External)/ KNVV-VWERK
*           MRNKZ(1)         TYPE  C,
*           PERFK(2)         TYPE  C,
*           PERRL(2)         TYPE  C,
          inco1(3)       TYPE  c,  " Incoterms
          inco2(28)      TYPE  c,  " Incoterms
          zterm(4)       TYPE  c,  "+Terms of Payment Key/ KNVV-ZTERM
          ktgrd(2)       TYPE  c,  " Account assignment group for this customer/ KNVV-KTGRD
          taxkd(1)       TYPE  c,  " Tax classification for customer CST
          txvat(1)       TYPE  c,  "+VAT Tax classificatio
          txser(1)       TYPE  c,  "+Service Tax classificatio
          txtcs(1)       TYPE  c,  "+TCS Tax classificatio
          pfsp(2)        TYPE  c,  "+SP Part function
          pfbp(2)        TYPE  c,  "+BP Part function
          pfpy(2)        TYPE  c,  "+PY Part function
          pfsh(2)        TYPE  c,  "+SH Part function
          pfzc(2)        TYPE  c,  "+ZC Part function
          ktonr(10)      TYPE  c,  "+Partner number
*          KTON2(10)      TYPE  C,  "+Partner number
          j_1iexcd(40)   TYPE  c,  " ECC Number/ J_1IMOCUST-J_1IEXCD
          j_1iexrn(40)   TYPE  c,  " Excise Registration Number/ J_1IMOCUST-J_1IEXRN
          j_1iexrg(60)   TYPE  c,  " Excise Range / J_1IMOCUST-J_1IEXRG
          j_1iexdi(60)   TYPE  c,  " Excise Division/ J_1IMOCUST-J_1IEXDI
          j_1iexco(60)   TYPE  c,  " Excise Commissionerate/ J_1IMOCUST-J_1IEXCO
          j_1iexcicu(1)  TYPE  c,  " Excise tax indicator for customer/ J_1IMOCUST-J_1IEX
          j_1icstno(40)  TYPE  c,  " Central Sales Tax Number/ J_1IMOCUST-J_1ICSTNO
          j_1ilstno(40)  TYPE  c,  " Local Sales Tax Number/ J_1IMOCUST-J_1ILSTNO
          j_1isern(40)   TYPE  c,  " Service Tax Registration Number/ J_1IMOCUST-J_1ISERN
          j_1ipanno(40)  TYPE  c,  " Permanent Account Number/ J_1IMOCUST-J_1IPANNO
          j_1ipanref(40) TYPE  c,  " PAN Reference Number/ J_1IMOCUST-J_1IPANREF
        END OF t_record.

TYPES : BEGIN OF t_result.
    INCLUDE TYPE t_record.
TYPES: msg(220)  TYPE c,                         "Message
       status(1) TYPE c,                 "Status E or Y
       END OF t_result.


TYPES : BEGIN OF t_data,
          line(400),
        END OF t_data.

TYPES : t_bdcdata TYPE bdcdata,
        t_mess    TYPE bdcmsgcoll,
        t_t100    TYPE t100.

TYPES : type_t_records TYPE STANDARD TABLE OF t_record,
        type_t_result  TYPE STANDARD TABLE OF t_result,
        type_t_bdcdata TYPE STANDARD TABLE OF t_bdcdata,
        type_t_mess    TYPE STANDARD TABLE OF t_mess,
        type_t_t100    TYPE STANDARD TABLE OF t_t100,
        type_t_data    TYPE STANDARD TABLE OF t_data.

DATA : it_records TYPE type_t_records,     "Int Table - Uploaded Records
       it_data    TYPE type_t_data,        "Int Table - Comma Sep Recds
       it_result  TYPE type_t_result,      "Int Table - Output Records
       it_bdcdata TYPE type_t_bdcdata.     "Batch input: New table

*---------------------------------------------------------------------*
* Variable Declaration                                                *
*---------------------------------------------------------------------*
DATA: v_total_rec   TYPE i,                  "Total no.of records
      v_success_rec TYPE i,                  "No of Successful records
      v_error_rec   TYPE i.                  "No of Error records

DATA: gv_filename TYPE rlgrap-filename,
      filename    TYPE string,
      gv_raw      TYPE truxs_t_text_data.

*----------------------------------------------------------------------*
* CONSTANTS
*----------------------------------------------------------------------*
CONSTANTS :
  c_tcode(04) TYPE c VALUE 'XD01',      "Tran. Code - XD01
  c_a(01)     TYPE c VALUE 'A',
  c_e(01)     TYPE c VALUE 'E',       "Indicator - MSG type ERROR
  c_x(01)     TYPE c VALUE 'X',       "Assigning the Value X
  c_1(01)     TYPE c VALUE '1',       "Value 1
*                c_y(01)    TYPE c VALUE 'Y',
  c_s(01)     TYPE c VALUE 'S',       "Indicator for Success Recd
  c_n(01)     TYPE c VALUE 'N'.       "Indicator for Error Record

*----------------------------------------------------------------------*
* SELECTION-SCREEN
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*SELECTION-SCREEN SKIP 1.
PARAMETERS: p_file  TYPE localfile OBLIGATORY,                "File to upload data.
            p_file2 TYPE localfile OBLIGATORY DEFAULT 'C:\'.  "File to download Error Data
*SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
*SELECTION-SCREEN SKIP 1.
PARAMETERS p1 AS CHECKBOX.
*PARAMETERS: p1 no-display RADIOBUTTON GROUP g1 DEFAULT 'X',                "Foreground
*            p2 RADIOBUTTON GROUP g1 .                            "Background
*SELECTION-SCREEN SKIP 1.
SELECTION-SCREEN END OF BLOCK b2.

*---------------------------------------------------------------------*
*  At Selection-screen on value-request for p_file
*---------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
**To provide F4 Help for the file path on the Selection Screen
  PERFORM get_file CHANGING p_file.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file2.
  "To provide F4 Help for the file path on the Selection Screen
  PERFORM get_file CHANGING p_file2.
*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*

START-OF-SELECTION.
* Upload the flat file
  PERFORM upload_file USING p_file
                   CHANGING it_records.
  IF it_records IS INITIAL.
    MESSAGE e000 WITH 'No Data has been Uploaded'.
  ENDIF.

* To validate records uploaded into the internal table
  PERFORM validate_data USING     it_records
                        CHANGING  it_result
                                  v_total_rec
                                  v_success_rec
                                  v_error_rec.

* To transfer the internal table values to the Transaction XDO1
  PERFORM bdc_transaction CHANGING it_result
                                   v_error_rec
                                   v_success_rec.

  PERFORM download.

*&---------------------------------------------------------------------*
*&      Form  get_file
*&---------------------------------------------------------------------*
*       This form is to create F4 help for the file path on the
*       Selection Screen
*----------------------------------------------------------------------*
*      <--RP_FILE  File Path Variable
*----------------------------------------------------------------------*
FORM get_file  CHANGING rp_file TYPE rlgrap-filename.

*F4 for the File Path
  CALL FUNCTION 'F4_FILENAME'
    IMPORTING
      file_name = rp_file.

ENDFORM.                    " get_file

*&---------------------------------------------------------------------*
*&      Form  upload_file
*&---------------------------------------------------------------------*
*       This subroutine uploads the flat file
*----------------------------------------------------------------------*
*      -->  RP_FILE     File Path Variable
*      <--  RT_DATA     Internal Table with records uploaded from
*                       Flat File
*----------------------------------------------------------------------*
FORM upload_file  USING p_file TYPE rlgrap-filename
                  CHANGING it_records TYPE type_t_records.
  "CHANGING it_data TYPE type_t_data.


  gv_filename = p_file.

*Upload Excel File

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_tab_raw_data       = gv_raw
      i_filename           = gv_filename
    TABLES
      i_tab_converted_data = it_records
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    " upload_file
*&---------------------------------------------------------------------*
*&      Form  validate_data
*&---------------------------------------------------------------------*
*       This from is to validate the records in the internal table
*----------------------------------------------------------------------*
*      -->  RT_RECORDS     Internal table with Uploaed Records
*      <--  RT_RESULT      Internal table with Success & Error Records
*      <--  RV_TOTAL_REC   Total Number of Records
*      <--  RV_SUCCESS_REC Total Number of Success Records
*      <--  RV_ERROR_REC   Total Number of Error Records
*----------------------------------------------------------------------*
FORM validate_data  USING it_records     TYPE type_t_records
                 CHANGING it_result      TYPE type_t_result
                          rv_total_rec   TYPE  i
                          rv_success_rec TYPE  i
                          rv_error_rec   TYPE  i.

  DATA : wa_result  TYPE t_result.     "Work Area for t_result
  DATA : v_msg(100) TYPE c.           "Variable to hold Error Message

  CLEAR : rv_total_rec,
          rv_success_rec,
          rv_error_rec.

  CLEAR wa_result.
  LOOP AT it_records INTO wa_result.

    rv_total_rec = rv_total_rec + c_1.

*Check for Mandatory fields
    IF wa_result-vkorg IS INITIAL OR wa_result-vtweg IS INITIAL OR
       wa_result-spart IS INITIAL.

      MOVE wa_result TO wa_result.
      CONCATENATE 'The Input File Has a missing'
                  'required field' INTO
                  v_msg SEPARATED BY space.

      wa_result-status = c_e.
      wa_result-msg    = v_msg.
      APPEND wa_result TO it_result.
      CLEAR wa_result.
      rv_error_rec = rv_error_rec + c_1.
      CLEAR v_msg.

      CONTINUE.
    ELSE.

*if all the above checks are successfull
      MOVE wa_result TO wa_result.
      wa_result-status = c_s.
      APPEND wa_result TO it_result.
      CLEAR wa_result.
      rv_success_rec = rv_success_rec + c_1.
    ENDIF.
  ENDLOOP.

ENDFORM.                    " validate_data
*&--------------------------------------------------------------------*
*&      Form  bdc_transaction
*&--------------------------------------------------------------------*
*       This form is used to transfer the internal table values to the
*       Transaction AS02
*---------------------------------------------------------------------*
*      <--  RT_RESULT  Internal table with all valid records which are
*                    to Uploaed Using Transaction AS02
*---------------------------------------------------------------------*
FORM bdc_transaction CHANGING it_result  TYPE type_t_result
                              rv_error_rec   TYPE i
                              rv_success_rec TYPE i.

  DATA : wa_result TYPE t_result.

  LOOP AT it_result INTO wa_result WHERE status = c_s.

    REFRESH it_bdcdata.

    SET PARAMETER ID 'KUN' FIELD ' '.

*Begin
    PERFORM bdc_dynpro   USING 'SAPMF02D' '7100'.
    PERFORM bdc_field    USING 'BDC_OKCODE'    '=ENTR'.
    PERFORM bdc_field    USING 'RF02D-KTOKD'   wa_result-ktokd."'0001'.
    PERFORM bdc_field    USING 'RF02D-BUKRS'   wa_result-bukrs."'1000'.
    PERFORM bdc_field    USING 'RF02D-VKORG'   wa_result-vkorg."'1000'.
    PERFORM bdc_field    USING 'RF02D-VTWEG'   wa_result-vtweg."'10'.
    PERFORM bdc_field    USING 'RF02D-SPART'   wa_result-spart."'00'.

*Name and address
    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'   '=$AOC'.
    PERFORM bdc_field    USING 'ADDR1_DATA-COUNTRY'  wa_result-country."'IN'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'   '=$2OC'.
    PERFORM bdc_field    USING 'SZA1_D0100-TITLE_MEDI'  wa_result-title_medi."'Company'.
    PERFORM bdc_field    USING 'ADDR1_DATA-NAME1'  wa_result-name1."'Raut and Ansari Pvt. Ltd'.
    PERFORM bdc_field    USING 'ADDR1_DATA-NAME2'  wa_result-name2."'Raut & Ansari'.
    PERFORM bdc_field    USING 'ADDR1_DATA-NAME3'  wa_result-name3.
*    PERFORM bdc_field    USING 'ADDR1_DATA-NAME4'  wa_result-name4.
    PERFORM bdc_field    USING 'ADDR1_DATA-SORT1'       wa_result-sort1."'R&A'.
    PERFORM bdc_field    USING 'ADDR1_DATA-STR_SUPPL1'  wa_result-str_suppl1."'Express Highway'.
    PERFORM bdc_field    USING 'ADDR1_DATA-STR_SUPPL2'  wa_result-str_suppl2."
    PERFORM bdc_field    USING 'ADDR1_DATA-STREET'      wa_result-street."'Express Highway'.
    PERFORM bdc_field    USING 'ADDR1_DATA-HOUSE_NUM1'  wa_result-house_num1+0(10)."'Express Highway'.
    PERFORM bdc_field    USING 'ADDR1_DATA-STR_SUPPL3'  wa_result-str_suppl3."'Express Highway'.
    PERFORM bdc_field    USING 'ADDR1_DATA-LOCATION'    wa_result-location."'Express Highway'.
    PERFORM bdc_field    USING 'ADDR1_DATA-POST_CODE1'  wa_result-post_code1. "'123456'.
    PERFORM bdc_field    USING 'ADDR1_DATA-CITY2'  wa_result-city2. "District
    PERFORM bdc_field    USING 'ADDR1_DATA-CITY1'  wa_result-city1."'Pune'.
*    PERFORM bdc_field    USING 'ADDR1_DATA-COUNTRY' wa_result-country."'IN'.
    PERFORM bdc_field    USING 'ADDR1_DATA-REGION'  wa_result-region."'13'.
    PERFORM bdc_field    USING 'ADDR1_DATA-LANGU'   wa_result-langu."'EN'.

    PERFORM bdc_field    USING 'SZA1_D0100-TEL_NUMBER'  wa_result-tel_number."'02032456789'.
    PERFORM bdc_field    USING 'SZA1_D0100-MOB_NUMBER'  wa_result-mob_number."'899898989'.
    PERFORM bdc_field    USING 'SZA1_D0100-FAX_NUMBER'  wa_result-fax_number."'02024687498'.
    PERFORM bdc_field    USING 'SZA1_D0100-SMTP_ADDR'   wa_result-smtp_addr."'mna@abc.com'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=TAB02'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=TAB03'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=TAB04'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'   '=TAB05'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'   '=TAB06'.
    PERFORM bdc_field    USING 'BDC_CURSOR'  'KNVA-ABLAD(01)'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'   '=TAB07'.
    PERFORM bdc_field    USING 'BDC_CURSOR'   'RF02D-KUNNR'.
    PERFORM bdc_field    USING 'KNA1-CIVVE'   'X'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'   '=FISEG'.
    PERFORM bdc_field    USING 'BDC_CURSOR'   'KNVK-NAME1(01)'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'   '=TAB02'.
    PERFORM bdc_field    USING 'BDC_CURSOR'  'KNB1-AKONT'.
    PERFORM bdc_field    USING 'KNB1-AKONT'  wa_result-akont. "'430019'.
    PERFORM bdc_field    USING 'KNB1-ZUAWA'  wa_result-zuawa.
    PERFORM bdc_field    USING 'KNB1-ALTKN'  wa_result-altkn.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'   '=TAB03'.
    PERFORM bdc_field    USING 'KNB1-ZTERM'   wa_result-zter1. "  '0001'.
    PERFORM bdc_field    USING 'BDC_CURSOR'   'KNB1-ZWELS'.
    PERFORM bdc_field    USING 'KNB1-ZWELS'   wa_result-zwels."'C'.
    PERFORM bdc_field    USING 'KNB1-KNRZB'   wa_result-knrzb.
    PERFORM bdc_field    USING 'KNB1-HBKID'   wa_result-hbkid.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=TAB04'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=TAB05'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=SDSEG'.
    PERFORM bdc_field    USING 'BDC_CURSOR'  'RF02D-KUNNR'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=TAB02'.
*perform bdc_field       using 'KNVV-AWAHR' '100'.
    PERFORM bdc_field    USING 'KNVV-VKBUR'   wa_result-vkbur."'PN'.
    PERFORM bdc_field    USING 'KNVV-KDGRP'   wa_result-kdgrp."'03'.
    PERFORM bdc_field    USING 'KNVV-WAERS'   wa_result-waers."'INR'.
*    PERFORM bdc_field    USING 'BDC_CURSOR'  'KNVV-VERSG'.
    PERFORM bdc_field    USING 'KNVV-KALKS'   wa_result-kalks."'1'.
    PERFORM bdc_field    USING 'KNVV-VERSG'   wa_result-versg."'1'.
    PERFORM bdc_field    USING 'LINK_KNVH-VALID_FROM'   '01.04.2017'.
    PERFORM bdc_field    USING 'LINK_KNVH-VALID_TO'     '31.12.9999'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  'TAB03'.
    PERFORM bdc_field    USING 'BDC_CURSOR'  'KNVV-VWERK'.
    PERFORM bdc_field    USING 'KNVV-LPRIO'   wa_result-lprio."'1'.
    PERFORM bdc_field    USING 'KNVV-KZAZU'   'X'.
    PERFORM bdc_field    USING 'KNVV-VSBED'   wa_result-vsbed."'01'.
    PERFORM bdc_field    USING 'KNVV-VWERK'   wa_result-vwerk."'PL03'.
*perform bdc_field       using 'KNVV-ANTLF'   '9'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=OPFI'.
    PERFORM bdc_field    USING 'KNVV-MRNKZ'  'X'.
    PERFORM bdc_field    USING 'KNVV-PERFK'  'IN'.
    PERFORM bdc_field    USING 'KNVV-PERRL'  'IN'.
    PERFORM bdc_field    USING 'KNVV-INCO1'   wa_result-inco1."'C&F'.
    PERFORM bdc_field    USING 'KNVV-INCO2'   wa_result-inco2."'Cost and Freight'.
    PERFORM bdc_field    USING 'KNVV-ZTERM'   wa_result-zterm."'0001'.
    PERFORM bdc_field    USING 'KNVV-KTGRD'   wa_result-ktgrd."'10'.
    PERFORM bdc_field    USING 'BDC_CURSOR'   'KNVI-TAXKD(04)'.
*    IF wa_result-taxkd = 1.
    PERFORM bdc_field    USING 'KNVI-TAXKD(01)'  wa_result-taxkd.   "'1'.
*    ENDIF.
*    IF wa_result-txvat = 1.
    PERFORM bdc_field    USING 'KNVI-TAXKD(02)'  wa_result-txvat.   "'1'.
*    ENDIF.
*    IF wa_result-txser = 1.
    PERFORM bdc_field    USING 'KNVI-TAXKD(03)'  wa_result-txser.    "'1'.
*    ENDIF.
*    PERFORM bdc_field    USING 'KNVI-TAXKD(04)' '1'.   "TCS no more required
    PERFORM bdc_dynpro   USING 'SAPLJ1I_MASTER' '0200'.
    PERFORM bdc_field    USING 'BDC_OKCODE' '=CIN_CUSTOMER_FC2'.
    PERFORM bdc_field    USING 'BDC_CURSOR'  'J_1IMOCUST-J_1IEXCICU'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1IEXCD'    wa_result-j_1iexcd."'ECC NUMBER 123456789'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1IEXRN'    wa_result-j_1iexrn."'ERN 123456789'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1IEXRG'    wa_result-j_1iexrg."'ERANGE 123456'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1IEXDI'    wa_result-j_1iexdi."'DIV123'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1IEXCO'    wa_result-j_1iexco."'COM123'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1IEXCICU'  wa_result-j_1iexcicu."'1'.

    PERFORM bdc_dynpro   USING 'SAPLJ1I_MASTER' '0200'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=CIN_CUSTOMER_FC3'.
    PERFORM bdc_field    USING 'BDC_CURSOR' 'J_1IMOCUST-J_1ISERN'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1ICSTNO'  wa_result-j_1icstno."'CST NUMBER 123'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1ILSTNO'  wa_result-j_1ilstno."'LST NUMBER 456'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1ISERN'   wa_result-j_1isern."'SERREG NUM 789'.

    PERFORM bdc_dynpro   USING 'SAPLJ1I_MASTER' '0200'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=BACK'.
    PERFORM bdc_field    USING 'BDC_CURSOR'  'J_1IMOCUST-J_1IPANREF'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1IPANNO'   wa_result-j_1ipanno."'FDSAFDSA23'.
    PERFORM bdc_field    USING 'J_1IMOCUST-J_1IPANREF'  wa_result-j_1ipanref."'FDSFA213'.

    PERFORM bdc_dynpro   USING 'SAPMF02D' '7000'.
    PERFORM bdc_field    USING 'BDC_OKCODE'  '=UPDA'.

    PERFORM call_transaction USING c_tcode  it_bdcdata
                          CHANGING wa_result.

    MODIFY it_result FROM wa_result TRANSPORTING status msg.

    IF wa_result-status = c_n.
      rv_error_rec = rv_error_rec + c_1.
      rv_success_rec = rv_success_rec - c_1.
    ENDIF.

  ENDLOOP.
ENDFORM.                    "BDC_TRANSACTION
*&--------------------------------------------------------------------*
*&      Form  call_transaction
*&--------------------------------------------------------------------*
*       This form is used to Call the Transaction and append the error
*       message to the internal table
*---------------------------------------------------------------------*
*      -->  RC_XD01     Value ( XD01 - Transaction Code )
*      <--  RT_BDCDATA  Internal table with all valid records which are
*                       to Uploaed Using Transaction CJ40
*      <--  RS_RESULT   STRUCTURE OF OUTPUT TABLE
*---------------------------------------------------------------------*
FORM call_transaction  USING rc_tcode    TYPE c
                             it_bdcdata  TYPE type_t_bdcdata
                    CHANGING wa_result   TYPE t_result.

*To hold the message returned from the table BDCMSGGOLL
  DATA: v_mstring(480) TYPE c,
        wa_ctu_params  TYPE ctu_params.
*Internal Table of the type BDCMSGCOLL
  DATA: it_mess TYPE type_t_mess.
*Work Area for the internal table T_MESS and T_T100
  DATA: wa_mess TYPE t_mess,
        wa_t100 TYPE t_t100.

  CLEAR wa_ctu_params.
  IF p1 = 'X'.
    wa_ctu_params-dismode = 'A'.
  ELSE.
    wa_ctu_params-dismode = 'N'.
  ENDIF.
  wa_ctu_params-updmode = 'S'.
  wa_ctu_params-nobinpt = 'X'.

  REFRESH it_mess.

*Call Transaction VBO1 and pass the values
*  CALL TRANSACTION rc_xd01 USING  it_bdcdata
*                           MODE   c_a                   "ctumode
*                           UPDATE c_a                   "cupdate
*                           MESSAGES INTO it_mess.

  CALL TRANSACTION rc_tcode USING it_bdcdata
    OPTIONS FROM wa_ctu_params
    MESSAGES INTO it_mess.

  LOOP AT it_mess INTO wa_mess.

*Getting the Error Message from the table T100
    SELECT SINGLE * FROM t100 INTO wa_t100
                    WHERE sprsl = wa_mess-msgspra
                     AND  arbgb = wa_mess-msgid
                     AND  msgnr = wa_mess-msgnr.
    IF sy-subrc = 0.
      v_mstring = wa_t100-text.
      IF v_mstring CS '&1'.
        REPLACE '&1' WITH wa_mess-msgv1 INTO v_mstring.
        REPLACE '&2' WITH wa_mess-msgv2 INTO v_mstring.
        REPLACE '&3' WITH wa_mess-msgv3 INTO v_mstring.
        REPLACE '&4' WITH wa_mess-msgv4 INTO v_mstring.
      ELSE.
        REPLACE '&' WITH wa_mess-msgv1 INTO v_mstring.
        REPLACE '&' WITH wa_mess-msgv2 INTO v_mstring.
        REPLACE '&' WITH wa_mess-msgv3 INTO v_mstring.
        REPLACE '&' WITH wa_mess-msgv4 INTO v_mstring.
      ENDIF.
      CONDENSE v_mstring.

      wa_result-status = wa_mess-msgtyp.
      wa_result-msg    = v_mstring.

      IF wa_result-msg CP 'Customer*has been created for company code*'.
        wa_result-status = 'S'.
      ELSE.
        wa_result-status = 'E'.
      ENDIF.

    ENDIF.
  ENDLOOP.
  CLEAR : wa_t100,
          wa_mess.

ENDFORM.                    " call_transaction
*&--------------------------------------------------------------------*
*&      Form  bdc_dynpro
*&--------------------------------------------------------------------*
*       This form is used to start a new screen
*---------------------------------------------------------------------*
*      -->  RPROGRAM Program Name
*      -->  RDYNPRO  Screen Number
*---------------------------------------------------------------------*
FORM bdc_dynpro  USING rprogram TYPE bdc_prog
                       rdynpro  TYPE bdc_dynr.

*Work Area for the Internal table T_BDCDATA
  DATA : wa_bdcdata TYPE t_bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-program  = rprogram.
  wa_bdcdata-dynpro   = rdynpro.
  wa_bdcdata-dynbegin = c_x.
  APPEND wa_bdcdata TO it_bdcdata.

ENDFORM.                    " bdc_dynpro
*&--------------------------------------------------------------------*
*&      Form  bdc_field
*&--------------------------------------------------------------------*
*       This form is used to insert field values
*---------------------------------------------------------------------*
*      -->RFNAM   Field Name
*      -->RFVAL   Field Value
*---------------------------------------------------------------------*
FORM bdc_field  USING rfnam TYPE fnam_____4
                      rfval.
*Work Area for the Internal table T_BDCDATA
  DATA : wa_bdcdata TYPE t_bdcdata.

  CLEAR wa_bdcdata.
  wa_bdcdata-fnam = rfnam.
  wa_bdcdata-fval = rfval.
  APPEND wa_bdcdata TO it_bdcdata.

ENDFORM.                    " bdc_field

FORM download .

*  *& download log
  filename = p_file2.
  "CONCATENATE filename '_LOG.xls' INTO filename.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = filename
      filetype                = 'ASC'
      write_field_separator   = 'X'
      trunc_trailing_blanks   = 'X'
    TABLES
      data_tab                = it_result
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFORM.                    " DOWNLOAD
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
**----------------------------------------------------------------------*
*MODULE user_command_0100 INPUT.
*
*  CASE sy-ucomm.
*    WHEN 'BACK' OR 'EXIT' OR 'CANC'.
*      LEAVE TO SCREEN 0.
*  ENDCASE.
*
*
*ENDMODULE.                 " USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*MODULE status_0100 OUTPUT.
*SET PF-STATUS 'SPACE'.
**  SET PF-STATUS 'CUST'.
**  SET TITLEBAR 'xxx'.

*ENDMODULE.                 " STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  DISPLAY_OUTPUT  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE display_output OUTPUT.
  PERFORM download.
ENDMODULE.                 " DISPLAY_OUTPUT  OUTPUT
