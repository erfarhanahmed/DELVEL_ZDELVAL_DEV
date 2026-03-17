*&---------------------------------------------------------------------*
*& Report  ZVENDOR_MASTER_BDC
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

*REPORT  ZVENDOR_MASTER_BDC.

*
*%&%& RDIRZVENDOR_MASTER_BDC
*ZVENDOR_MASTER_BDC                        X           1         IDMCABAP    20101202IDMCABAP    20101204000016700 T200EX 2010120410013820101204100138                    X
*%&%& REPOZVENDOR_MASTER_BDC
REPORT ZVENDOR_MASTER_UPLOAD
       NO STANDARD PAGE HEADING LINE-SIZE 255.

*&---------------------------------------------------------------------*
*& Report  ZMM01_BDC
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*


**********************************************************************************************
*                 PROGRAM FOR UPLOAD EQUIPMENT DETAILS TCODE EQ01
**********************************************************************************************
* Program Name          :  ZIE01_BDC
* Functional Analyst    :  shylesh   MM consultant
* Programmer            :  SHANMUGASUNDARAM
* Start date            :
* Initial CTS           :
* Description           :  Program for  UPLOAD SPLIT VALUATION FOR  MM
*--------------------------------------------------------------------------------------------*

TABLES :SSCRFIELDS.

TYPE-POOLS: truxs.
TYPES: BEGIN OF it_itab,
        bukrs(004),
        ekorg(004),
        ktokk(004),
        name1(040),
        sort1(020),
        sort2(020),
        street(040),
        STR_SUPPL3(040),
        location(040),
        city2(040),
        post_code1(010),
        city1(040),
        country(003),
        region(003),
        TEL_NUMBER(030),
        MOB_NUMBER(030),
        FAX_NUMBER(030),
        SMTP_ADDR(241),
        J_1IEXCD(040),
        J_1IEXRN(040),
        J_1IEXRG(060),
        J_1IEXDI(060),
        J_1IEXCO(060),
        J_1IVTYP(002),
        J_1IEXCIVE(001),
        J_1ICSTNO(040),
        J_1ILSTNO(040),
        J_1ISERN(040),
        J_1IPANNO(040),
        AKONT(010),
        zterm(004),
        waers(005),
        INCO1(003),
        INCO2(028),
        KALSK(002),
        VERKF(030),
        TELF1(016),
        WEBRE(001),
        LEBRE(001),

       END OF it_itab.


TYPE-POOLS: truxs.

TYPES: BEGIN OF it_itab1,
        number(10)      TYPE c,
        ersuc(10)       TYPE c,
        desc(100)       TYPE c,
        bukrs(004),
        ekorg(004),
        ktokk(004),
        name1(040),
        sort1(020),
        sort2(020),
        street(040),
        STR_SUPPL3(040),
        location(040),
        city2(040),
        post_code1(010),
        city1(040),
        country(003),
        region(003),
        TEL_NUMBER(030),
        MOB_NUMBER(030),
        FAX_NUMBER(030),
        SMTP_ADDR(241),
        J_1IEXCD(040),
        J_1IEXRN(040),
        J_1IEXRG(060),
        J_1IEXDI(060),
        J_1IEXCO(060),
        J_1IVTYP(002),
        J_1IEXCIVE(001),
        J_1ICSTNO(040),
        J_1ILSTNO(040),
        J_1ISERN(040),
        J_1IPANNO(040),
        AKONT(010),
        zterm(004),
        waers(005),
        INCO1(003),
        INCO2(028),
        KALSK(002),
        VERKF(030),
        TELF1(016),
        WEBRE(001),
        LEBRE(001),

       END OF it_itab1.

*----------------------------------------------------------------------------------------------
*                 DATA DELARATION
*-----------------------------------------------------------------------------------------------
DATA :  it_raw      TYPE truxs_t_text_data.
DATA :  git_itab    TYPE  STANDARD TABLE OF  it_itab WITH HEADER LINE.
DATA :  wa_itab     TYPE  it_itab.
DATA :  p_table     TYPE  it_itab  OCCURS 0 WITH HEADER LINE.
DATA :  gwa_error   TYPE  STANDARD TABLE  OF  it_itab1 WITH HEADER LINE.
DATA :  git_error   TYPE  STANDARD  TABLE  OF  it_itab1.
DATA :  gwa_success  TYPE  STANDARD TABLE  OF  it_itab1 WITH HEADER LINE.
DATA :  git_success  TYPE  STANDARD  TABLE  OF  it_itab1.
DATA :  git_log      TYPE  STANDARD TABLE OF bdcmsgcoll .
DATA :  gwa_log      TYPE  bdcmsgcoll.


DATA :  g_vendor(4).
DATA:   bdcdata LIKE bdcdata    OCCURS 0 WITH HEADER LINE.
DATA:  nodata TYPE c VALUE ' '.

DATA: g_file        TYPE string,
      g_inc(7)      TYPE c,
      g_desc(100),
      g_error(10),
      g_success(10).


DATA :  gd_scol TYPE i VALUE '1',
        gd_srow TYPE i VALUE '2',
        gd_ecol TYPE i VALUE '256',
        gd_erow TYPE i VALUE '65536'.

DATA :  it_tab   TYPE filetable,
        gd_subrc TYPE i.


FIELD-SYMBOLS : <fs>.

*********************************************************************
*Selection screen definition
*********************************************************************

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS:    p_file LIKE rlgrap-filename.
*               DEFAULT 'c:\test.xls' OBLIGATORY.   " File Name
SELECTION-SCREEN END OF BLOCK b1.


PARAMETERS: call RADIOBUTTON GROUP r1 DEFAULT 'X',
            sess RADIOBUTTON GROUP r1.

PARAMETERS group(12).

SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN PUSHBUTTON (25) W_BUTTON USER-COMMAND BUT1.
SELECTION-SCREEN END OF LINE.

INITIALIZATION.
* Add displayed text string to buttons
  W_BUTTON = 'Download Excel Template'.


AT SELECTION-SCREEN.
  IF SSCRFIELDS-UCOMM EQ 'BUT1' .
    SUBMIT  ZVENDOR_EXCEL VIA SELECTION-SCREEN .
  ENDIF.

***********************************************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'P_FILE'
    IMPORTING
      file_name  = p_file.
************************************************************************


START-OF-SELECTION.

  REFRESH : git_itab.

  PERFORM upload_excel_file TABLES   git_itab
                             USING   p_file
                                     gd_scol
                                     gd_srow
                                     gd_ecol
                                     gd_erow.

END-OF-SELECTION.

  CLEAR :  wa_itab.
  IF sess = 'X'.
    PERFORM open_group.
  ENDIF.
  LOOP AT git_itab INTO wa_itab.
    ADD 1 TO g_inc.
    PERFORM bdc_process USING
    wa_itab-bukrs
        wa_itab-ekorg
        wa_itab-ktokk
        wa_itab-name1
        wa_itab-sort1
        wa_itab-sort2
        wa_itab-street
        wa_itab-STR_SUPPL3
        wa_itab-location
        wa_itab-city2
        wa_itab-post_code1
        wa_itab-city1
        wa_itab-country
        wa_itab-region
        wa_itab-TEL_NUMBER
        wa_itab-MOB_NUMBER
        wa_itab-FAX_NUMBER
        wa_itab-SMTP_ADDR
        wa_itab-J_1IEXCD
        wa_itab-J_1IEXRN
        wa_itab-J_1IEXRG
        wa_itab-J_1IEXDI
        wa_itab-J_1IEXCO
        wa_itab-J_1IVTYP
        wa_itab-J_1IEXCIVE
        wa_itab-J_1ICSTNO
        wa_itab-J_1ILSTNO
        wa_itab-J_1ISERN
        wa_itab-J_1IPANNO
        wa_itab-AKONT
        wa_itab-zterm
        wa_itab-waers
        wa_itab-INCO1
        wa_itab-INCO2
        wa_itab-KALSK
        wa_itab-VERKF
        wa_itab-TELF1
        wa_itab-WEBRE
        wa_itab-LEBRE.

  ENDLOOP.
if sess = 'X'.
  PERFORM close_group.
endif.

*&---------------------------------------------------------------------*
*&      Form  BDC_PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->YBUKRS        text
*      -->YEKORG        text
*      -->YKTOKK        text
*      -->YNAME1        text
*      -->YNAME2        text
*      -->YNAME3        text
*      -->YNAME4        text
*      -->YSORT1        text
*      -->YSORT2        text
*      -->YNAME_CO      text
*      -->YSTR_SUPPL1   text
*      -->YSTR_SUPPL2   text
*      -->YSTREET       text
*      -->YHOUSE_NUM1   text
*      -->YSTR_SUPPL3   text
*      -->YLOCATION     text
*      -->YCITY2        text
*      -->YPOST_CODE1   text
*      -->YCITY1        text
*      -->YCOUNTRY      text
*      -->YREGION       text
*      -->YLANGU        text
*      -->YTEL_NUMBER   text
*      -->YMOB_NUMBER   text
*      -->YFAX_NUMBER   text
*      -->YSMTP_ADDR    text
*      -->YNAMEV        text
*      -->YNAME1V       text
*      -->YNAME_LAST    text
*      -->YNAME_FIRST   text
*      -->YLANGU_P      text
*      -->YTEL_NUMBERV  text
*      -->YMOB_NUMBERV  text
*      -->YFAX_NUMBERV  text
*      -->YSMTP_ADDRV   text
*      -->YAKONT        text
*      -->YWAERS        text
*      -->YZTERM        text
*      -->YINCO1        text
*      -->YINCO2        text
*      -->YKALSK        text
*      -->YWEBRE        text
*      -->YGPARN1       text
*      -->YGPARN2       text
*      -->YGPARN3       text
*----------------------------------------------------------------------*
FORM bdc_process USING
        ybukrs
        yekorg
        yktokk
        yname1
        ysort1
        ysort2
        ystreet
        ySTR_SUPPL3
        ylocation
        ycity2
        ypost_code1
        ycity1
        ycountry
        yregion
        yTEL_NUMBER
        yMOB_NUMBER
        yFAX_NUMBER
        ySMTP_ADDR
        yJ_1IEXCD
        yJ_1IEXRN
        yJ_1IEXRG
        yJ_1IEXDI
        yJ_1IEXCO
        yJ_1IVTYP
        yJ_1IEXCIVE
        yJ_1ICSTNO
        yJ_1ILSTNO
        yJ_1ISERN
        yJ_1IPANNO
        yAKONT
        yzterm
        ywaers
        yINCO1
        yINCO2
        yKALSK
        yVERKF
        yTELF1
        yWEBRE
        yLEBRE.




*  --------------------------

perform bdc_dynpro      using 'SAPMF02K' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'USE_ZAV'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'RF02K-LIFNR'
                              ''.
perform bdc_field       using 'RF02K-BUKRS'
                              wa_itab-bukrs.
perform bdc_field       using 'RF02K-EKORG'
                              wa_itab-ekorg.
perform bdc_field       using 'RF02K-KTOKK'
                              wa_itab-ktokk.
perform bdc_field       using 'USE_ZAV'
                               'X'.

perform bdc_dynpro      using 'SAPMF02K' '0111'.
perform bdc_field       using 'BDC_OKCODE'
                              '=OPFI'.
perform bdc_field       using 'ADDR1_DATA-NAME1'
                              wa_itab-name1.
perform bdc_field       using 'ADDR1_DATA-SORT1'
                              wa_itab-sort1.
perform bdc_field       using 'ADDR1_DATA-SORT2'
                              wa_itab-sort2.
perform bdc_field       using 'ADDR1_DATA-STREET'
                              wa_itab-street.
perform bdc_field       using 'ADDR1_DATA-STR_SUPPL3'
                              wa_itab-str_suppl3.
perform bdc_field       using 'ADDR1_DATA-LOCATION'
                              wa_itab-location.
perform bdc_field       using 'ADDR1_DATA-CITY2'
                              wa_itab-city2.
perform bdc_field       using 'ADDR1_DATA-POST_CODE1'
                              wa_itab-post_code1.
perform bdc_field       using 'ADDR1_DATA-CITY1'
                              wa_itab-city1.
perform bdc_field       using 'ADDR1_DATA-COUNTRY'
                              wa_itab-country.
perform bdc_field       using 'ADDR1_DATA-REGION'
                              wa_itab-region.
****perform bdc_field       using 'ADDR1_DATA-LANGU'
****                              wa_itab-langu.
perform bdc_field       using 'SZA1_D0100-TEL_NUMBER'
                              wa_itab-tel_number.
perform bdc_field       using 'SZA1_D0100-MOB_NUMBER'
                              wa_itab-mob_number.
perform bdc_field       using 'SZA1_D0100-FAX_NUMBER'
                              wa_itab-fax_number.
perform bdc_field       using 'SZA1_D0100-SMTP_ADDR'
                              wa_itab-smtp_addr.

perform bdc_dynpro      using 'SAPLJ1I_MASTER' '0100'.
perform bdc_field       using 'BDC_OKCODE'
                              '=CIN_VENDOR_FC2'.
perform bdc_field       using 'J_1IMOVEND-J_1IEXCD'
                              wa_itab-j_1iexcd.
perform bdc_field       using 'J_1IMOVEND-J_1IEXRN'
                              wa_itab-j_1iexrn.
perform bdc_field       using 'J_1IMOVEND-J_1IEXRG'
                              wa_itab-j_1iexrg.
perform bdc_field       using 'J_1IMOVEND-J_1IEXDI'
                              wa_itab-j_1iexdi.
perform bdc_field       using 'J_1IMOVEND-J_1IEXCO'
                              wa_itab-j_1iexco.
perform bdc_field       using 'J_1IMOVEND-J_1IVTYP'
                              wa_itab-j_1ivtyp.
perform bdc_field       using 'J_1IMOVEND-J_1IEXCIVE'
                              wa_itab-j_1iexcive.
perform bdc_dynpro      using 'SAPLJ1I_MASTER' '0100'.
perform bdc_field       using 'BDC_OKCODE'
                              '=CIN_VENDOR_FC3'.
perform bdc_field       using 'BDC_CURSOR'
                              'J_1IMOVEND-J_1ISERN'.
perform bdc_field       using 'J_1IMOVEND-J_1ICSTNO'
                              wa_itab-j_1icstno.
perform bdc_field       using 'J_1IMOVEND-J_1ILSTNO'
                              wa_itab-j_1ilstno.
perform bdc_field       using 'J_1IMOVEND-J_1ISERN'
                              wa_itab-j_1isern.
perform bdc_dynpro      using 'SAPLJ1I_MASTER' '0100'.
perform bdc_field       using 'BDC_OKCODE'
                              '=BACK'.
perform bdc_field       using 'BDC_CURSOR'
                              'J_1IMOVEND-J_1IPANNO'.
perform bdc_field       using 'J_1IMOVEND-J_1IPANNO'
                              wa_itab-j_1ipanno.
perform bdc_dynpro      using 'SAPMF02K' '0111'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.

perform bdc_dynpro      using 'SAPMF02K' '0120'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
perform bdc_dynpro      using 'SAPMF02K' '0130'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
perform bdc_dynpro      using 'SAPMF02K' '0380'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
perform bdc_dynpro      using 'SAPMF02K' '0210'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
perform bdc_field       using 'LFB1-AKONT'
                              wa_itab-akont.
perform bdc_dynpro      using 'SAPMF02K' '0215'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
perform bdc_field       using 'LFB1-ZTERM'
                              wa_itab-zterm.
perform bdc_dynpro      using 'SAPMF02K' '0220'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
perform bdc_dynpro      using 'SAPMF02K' '0610'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
perform bdc_dynpro      using 'SAPMF02K' '0310'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.
perform bdc_field       using 'LFM1-WAERS'
                              wa_itab-waers.
perform bdc_field       using 'LFM1-ZTERM'
                              wa_itab-zterm.
perform bdc_field       using 'LFM1-INCO1'
                              wa_itab-inco1.
perform bdc_field       using 'LFM1-INCO2'
                              wa_itab-inco2.
perform bdc_field       using 'LFM1-KALSK'
                              wa_itab-kalsk.
perform bdc_field       using 'LFM1-VERKF'
                              wa_itab-verkf.
perform bdc_field       using 'LFM1-TELF1'
                              wa_itab-telf1.
perform bdc_field       using 'LFM1-WEBRE'
                              wa_itab-webre.
perform bdc_field       using 'LFM1-LEBRE'
                              wa_itab-lebre.
perform bdc_dynpro      using 'SAPMF02K' '0320'.
perform bdc_field       using 'BDC_OKCODE'
                              '=VW'.


  IF call = 'X'.



    CALL TRANSACTION 'XK01' USING bdcdata   MODE 'A' MESSAGES  INTO git_log.

    LOOP AT git_log  INTO  gwa_log.

      IF gwa_log-msgtyp = 'E' OR gwa_log-msgtyp = 'S'.

        CALL FUNCTION 'MESSAGE_TEXT_BUILD'
          EXPORTING
            msgid               = gwa_log-msgid
            msgnr               = gwa_log-msgnr
            msgv1               = gwa_log-msgv1
            msgv2               = gwa_log-msgv2
            msgv3               = gwa_log-msgv3
            msgv4               = gwa_log-msgv4
          IMPORTING
            message_text_output = g_desc.
      ENDIF.

    ENDLOOP.

    IF gwa_log-msgtyp = 'E'.
      ADD 1  TO  g_error.

      gwa_error-number =  g_inc.
      gwa_error-ersuc  =  'E'.
      gwa_error-desc   =  g_desc .

*   *BUKRS EKORG KTOKK NAME1 SORTL NAME2 NAME3 NAME4 STRAS PFACH
      gwa_error-bukrs = ybukrs.
      gwa_error-ekorg = yekorg.
      gwa_error-ktokk = yktokk.
      gwa_error-name1 = yname1.
*   GWA_ERROR-SORTL = YSORTL.

      APPEND gwa_error   TO  git_error.

    ELSEIF gwa_log-msgtyp = 'S'.

      ADD 1  TO  g_success.

      gwa_success-number  =  g_inc.
      gwa_success-ersuc  =  's'.
      gwa_success-desc   =  g_desc .

      gwa_success-bukrs = ybukrs.
      gwa_success-ekorg = yekorg.
      gwa_success-ktokk = yktokk.
      gwa_success-name1 = yname1.
*   GWA_SUCCESS-SORTL = YSORTL.



      APPEND gwa_success  TO git_success.

    ENDIF.
  ENDIF.


  IF sess = 'X'.
*******************for session method
PERFORM session  USING 'XK01'.

  ENDIF.

  REFRESH bdcdata.

*    clear : wa_datatab.

ENDFORM.                    "BDC_PROCESS


*perform close_group.




FORM download_1.
  DATA: u_error   TYPE string,
        u_success TYPE string.

  u_error = 'C:\Users\Dell_Core\Desktop\MM_VENDOR_MASTER_EERROR.XLS'.
  u_success = 'C:\Users\Dell_Core\Desktop\MM_VENDOR_MASTER_SUCCESS.XLS'.

  PERFORM merge USING u_error
                CHANGING git_error.
  PERFORM merge USING u_success
                 CHANGING git_success.

ENDFORM.                                                    "DOWNLOAD_1




*&---------------------------------------------------------------------*
*&      Form  merge
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->U_FILE1    text
*      -->C_TABLE1   text
*----------------------------------------------------------------------*
FORM merge  USING    u_file1 TYPE any
            CHANGING c_table1 TYPE table.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename = u_file1
      filetype = 'DAT'
    TABLES
      data_tab = c_table1.
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.                    "merge

*&---------------------------------------------------------------------*
*&      Form  bdc_field
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->FNAM       text
*      -->FVAL       text
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
  IF fval <> nodata.
    CLEAR bdcdata.
    bdcdata-fnam = fnam.
    bdcdata-fval = fval.
    APPEND bdcdata.
  ENDIF.
ENDFORM.                    "BDC_FIELD

*&---------------------------------------------------------------------*
*&      Form  BDC_DYNPRO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->PROGRAM    text
*      -->DYNPRO     text
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR bdcdata.
  bdcdata-program  = program.
  bdcdata-dynpro   = dynpro.
  bdcdata-dynbegin = 'X'.
  APPEND bdcdata.
ENDFORM.                    "BDC_DYNPRO


*&---------------------------------------------------------------------*
*&      Form  upload_excel_file
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TABLE    text
*      -->P_FILE     text
*      -->P_SCOL     text
*      -->P_SROW     text
*      -->P_ECOL     text
*      -->P_EROW     text
*----------------------------------------------------------------------*
FORM upload_excel_file TABLES   p_table
                       USING    p_file
                                p_scol
                                p_srow
                                p_ecol
                                p_erow.

  DATA : lt_intern TYPE  kcde_cells OCCURS 0 WITH HEADER LINE.

  DATA : ld_index TYPE i.

* Note: Alternative function module - 'ALSM_EXCEL_TO_INTERNAL_TABLE'
  CALL FUNCTION 'KCD_EXCEL_OLE_TO_INT_CONVERT'
    EXPORTING
      filename                = p_file
      i_begin_col             = p_scol
      i_begin_row             = p_srow
      i_end_col               = p_ecol
      i_end_row               = p_erow
    TABLES
      intern                  = lt_intern
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc <> 0.
    FORMAT COLOR COL_BACKGROUND INTENSIFIED.
    WRITE:/ 'Error Uploading file'.
    EXIT.
  ENDIF.

  IF lt_intern[] IS INITIAL.
    FORMAT COLOR COL_BACKGROUND INTENSIFIED.
    WRITE:/ 'No Data Uploaded'.
    EXIT.
  ELSE.
    SORT lt_intern BY row col.
    LOOP AT lt_intern.
      MOVE lt_intern-col TO ld_index.
      ASSIGN COMPONENT ld_index OF STRUCTURE p_table TO <fs>.
*     lt_intern-value TO <fs>.
      MOVE lt_intern-value TO <fs>.
*     MOVE lt_intern-value TO p_table.
      AT END OF row.
        APPEND p_table.
        CLEAR p_table.
      ENDAT.
    ENDLOOP.
  ENDIF.
ENDFORM.                    "upload_excel_file
*%&%& TEXPZVENDOR_MASTER_BDC
*Error opening dataset, return code:
*Session name
*Open session
*Insert transaction
*Close Session
*Return code =
*Error session created
*Session name
*User
*Keep session
*Lock date
*Processing Mode
*Update Mode
*Generate session
*Call transaction
*Error sessn
*Nodata indicator
*Short log
*BDC program for  Vendor Master Uploading
*%&%& HEADZVENDOR_MASTER_BDC
*DOKU      ZTESTPAY                                                              RE  E                                                  S_DOCU_SHOW     S_DOCUS100002IDMCABAP1       20110613171405                0000000000000007200000  0
*%&%& DOKLZVENDOR_MASTER_BDC
*&---------------------------------------------------------------------*
*&      Form  OPEN_GROUP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM open_group .
  SKIP.
  WRITE: /(20) 'Create group'(i01), group.
  SKIP.
  CALL FUNCTION 'BDC_OPEN_GROUP'
    EXPORTING
      client = sy-mandt
      group  = group
      user   = sy-uname
      keep   = 'X'.
*              HOLDDATE = HOLDDATE.
  WRITE: /(30) 'BDC_OPEN_GROUP'(i02),
    (12) 'returncode:'(i05),
         sy-subrc.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CLOSE_GROUP
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM close_group .


  CALL FUNCTION 'BDC_CLOSE_GROUP'.
  WRITE: /(30) 'BDC_CLOSE_GROUP'(i04),
          (12) 'returncode:'(i05),
               sy-subrc.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SESSION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_1147   text
*----------------------------------------------------------------------*
FORM session   USING tcode.
  CALL FUNCTION 'BDC_INSERT'
    EXPORTING
      tcode     = tcode
    TABLES
      dynprotab = bdcdata.
  WRITE: /(25) 'BDC_INSERT'(i03),
               tcode,
          (12) 'returncode:'(i05),
               sy-subrc.
  REFRESH bdcdata.
ENDFORM.
