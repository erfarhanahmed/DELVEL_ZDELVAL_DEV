*&---------------------------------------------------------------------*
*& Report ZFERT_PENDING_WIP_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsu_fert_pending_wip_report.


TABLES : vbak,vbap.

TYPES:BEGIN OF ty_vbak,
        vbeln TYPE vbak-vbeln,
        erdat TYPE vbak-erdat,
        auart TYPE vbak-auart,
        vkorg TYPE vbak-vkorg,
        kunnr TYPE vbak-kunnr,
      END OF ty_vbak,

      BEGIN OF ty_vbap,
        vbeln  TYPE vbap-vbeln,
        posnr  TYPE vbap-posnr,
        matnr  TYPE vbap-matnr,
        fmeng  TYPE vbap-fmeng,
        werks  TYPE vbap-werks,
        abgru  TYPE vbap-abgru,
        zmeng  TYPE vbap-zmeng,
        kwmeng TYPE vbap-kwmeng,
      END OF ty_vbap,


      BEGIN OF ty_vbfa,
        vbelv   TYPE vbfa-vbelv,
        posnv   TYPE vbfa-posnv,
        vbeln   TYPE vbfa-vbeln,
        posnn   TYPE vbfa-posnn,
        vbtyp_n TYPE vbfa-vbtyp_n,
      END OF ty_vbfa,

      BEGIN OF ty_vbrk,
        vbeln TYPE vbrk-vbeln,
        fkart TYPE vbrk-vbeln,
        vbtyp TYPE vbrk-vbtyp,
        fksto TYPE vbrk-fksto,
      END OF ty_vbrk,



      BEGIN OF ty_data,
        vbeln TYPE vbeln,
        posnr TYPE posnr,
        werks TYPE werks,
      END OF ty_data.




TYPES : BEGIN OF ty_afpo,
          aufnr TYPE afpo-aufnr,
          posnr TYPE afpo-posnr,
          kdauf TYPE afpo-kdauf,
          kdpos TYPE afpo-kdpos,
          matnr TYPE afpo-matnr,
          pgmng TYPE afpo-pgmng,
          psmng TYPE afpo-psmng,
          wemng TYPE afpo-wemng,
        END OF ty_afpo.

TYPES : BEGIN OF ty_caufv,
          aufnr TYPE caufv-aufnr,
          objnr TYPE caufv-objnr,
          kdauf TYPE caufv-kdauf,
          kdpos TYPE caufv-kdpos,
          igmng TYPE caufv-igmng,
        END OF ty_caufv .

TYPES : BEGIN OF ty_jest,
          objnr TYPE jest-objnr,
          stat  TYPE jest-stat,
        END OF ty_jest.

TYPES : BEGIN OF ty_final,
          vbeln    TYPE vbap-vbeln,
          posnr    TYPE vbap-posnr,
          matnr    TYPE vbap-matnr,
          kwmeng   TYPE vbap-kwmeng,
          pend_qty TYPE vbap-kwmeng,
          inv_qty  TYPE vbrp-fkimg,
          wip_qty  TYPE vbrp-fkimg,
          igmng    TYPE caufv-igmng,
        END OF ty_final.

TYPES :BEGIN OF ty_down,
         vbeln    TYPE char15,
         posnr    TYPE char15,
         matnr    TYPE char20,
         kwmeng   TYPE char15,
         inv_qty  TYPE char15,
         pend_qty TYPE char15,
         wip_qty  TYPE char15,
         igmng    TYPE char15,
         ref      TYPE char15,
         time     TYPE char10,
       END OF ty_down.



DATA : it_vbak  TYPE TABLE OF ty_vbak,
       wa_vbak  TYPE          ty_vbak,

       it_vbap  TYPE TABLE OF ty_vbap,
       wa_vbap  TYPE          ty_vbap,

       it_vbfa  TYPE TABLE OF ty_vbfa,
       wa_vbfa  TYPE          ty_vbfa,

       it_vbrk  TYPE TABLE OF ty_vbrk,
       wa_vbrk  TYPE          ty_vbrk,

       it_data  TYPE STANDARD TABLE OF ty_data,
       wa_data  TYPE ty_data,

       it_afpo  TYPE TABLE OF ty_afpo,
       wa_afpo  TYPE ty_afpo,

       it_caufv TYPE TABLE OF ty_caufv,
       wa_caufv TYPE ty_caufv,

       it_jest2 TYPE TABLE OF ty_jest,
       wa_jest2 TYPE ty_jest,

       it_final TYPE TABLE OF ty_final,
       wa_final TYPE          ty_final,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE          ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

**********************Dhananjay code 23 feb 2021***********************
CONSTANTS : con_name TYPE dbcon_name VALUE 'SQLSODATA'.
CONSTANTS : schema   TYPE adbc_schema_name VALUE 'DBO'.
DATA : go_con     TYPE REF TO cl_sql_connection,
       gv_line_sz TYPE i.
DATA : po_rs          TYPE REF TO cl_sql_result_set.
DATA : sdate TYPE string,
       stime TYPE string.
******************************************



SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
SELECT-OPTIONS   :  s_date FOR wa_vbak-erdat OBLIGATORY DEFAULT '20170401' TO sy-datum,
                    s_matnr FOR vbap-matnr,
                    s_vbeln FOR vbap-vbeln,
                    s_posnr FOR vbap-posnr.
SELECTION-SCREEN END OF BLOCK b2.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-074 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/Saudi'."Saudi'."saudi'. "'/delval/saudi'.
SELECTION-SCREEN END OF BLOCK b5.

SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
SELECTION-SCREEN END OF LINE.


START-OF-SELECTION.


  PERFORM get_data.
  PERFORM sort_data.
  PERFORM get_fcat.
  PERFORM get_display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT a~vbeln a~posnr "a~werks
      INTO TABLE it_data
      FROM  vbap AS a
      JOIN  vbup AS b ON ( b~vbeln = a~vbeln  AND b~posnr = a~posnr )
      WHERE a~erdat  IN s_date
      AND   a~matnr  IN s_matnr
      AND   a~vbeln  IN s_vbeln         "SHREYAS
      AND   a~posnr  IN s_posnr         "ADDED BY SNEHAL RAJALE ON 19 FEB 2021
      AND   b~lfsta  NE 'C'
      AND   b~lfgsa  NE 'C'
      AND   b~fksta  NE 'C'
      AND   b~gbsta  NE 'C'.
*    AND   A~WERKS  = 'PLO1'.

  IF it_data IS NOT INITIAL.

    SELECT vbeln
           erdat
           auart
           vkorg
           kunnr FROM vbak INTO TABLE it_vbak
           FOR ALL ENTRIES IN it_data
           WHERE vbeln = it_data-vbeln.
*         AND auart NE 'ZESS'
*         AND auart NE 'ZSER'.

    SELECT vbeln
           posnr
           matnr
           fmeng
           werks
           abgru
           zmeng
           kwmeng FROM vbap INTO TABLE it_vbap
           FOR ALL ENTRIES IN it_data
           WHERE vbeln = it_data-vbeln
             AND posnr = it_data-posnr
             AND werks = 'SU01'.

  ENDIF.

  IF it_vbak IS NOT INITIAL.

  ENDIF.

  IF it_vbap IS NOT INITIAL.

    SELECT vbelv
           posnv
           vbeln
           posnn
           vbtyp_n FROM vbfa INTO TABLE it_vbfa
           FOR ALL ENTRIES IN it_vbap
           WHERE vbelv = it_vbap-vbeln
             AND posnv = it_vbap-posnr
             AND vbtyp_n IN ( 'M' , 'J' ).



    SELECT aufnr
           posnr
           kdauf
           kdpos
           matnr
           pgmng
           psmng
           wemng FROM afpo
           INTO TABLE it_afpo
           FOR ALL ENTRIES IN it_vbap
           WHERE kdauf = it_vbap-vbeln
             AND kdpos = it_vbap-posnr .
  ENDIF.

  IF it_afpo IS NOT INITIAL.
    SELECT aufnr
           objnr
           kdauf
           kdpos
           igmng FROM caufv
           INTO TABLE it_caufv
           FOR ALL ENTRIES IN it_afpo
           WHERE aufnr = it_afpo-aufnr
            AND  kdauf = it_afpo-kdauf
            AND  kdpos = it_afpo-kdpos
            AND  loekz = space.



  ENDIF.

  IF it_vbfa IS NOT INITIAL.
    SELECT vbeln
           fkart
           vbtyp
           fksto FROM vbrk INTO TABLE it_vbrk
           FOR ALL ENTRIES IN it_vbfa
           WHERE vbeln = it_vbfa-vbeln
            AND  fksto NE 'X'.


  ENDIF.

  LOOP AT it_vbak INTO wa_vbak WHERE auart = 'SU09' OR auart = 'SU10'.
    LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_vbak-vbeln AND abgru NE ' '.
      DELETE it_vbap WHERE vbeln = wa_vbap-vbeln AND posnr = wa_vbap-posnr.
    ENDLOOP.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_data .
  DATA : wa_fkimg_sum TYPE vbrp-fkimg,
         wa_fkimg     TYPE vbrp-fkimg.
  LOOP AT it_vbap INTO wa_vbap  .

    wa_final-vbeln = wa_vbap-vbeln.
    wa_final-posnr = wa_vbap-posnr.
    wa_final-matnr = wa_vbap-matnr.
    wa_final-kwmeng = wa_vbap-kwmeng.
    IF wa_final-kwmeng IS INITIAL.                          "Added By SR on 23 MAR 2021
      wa_final-kwmeng = wa_vbap-zmeng.
    ENDIF.


    LOOP AT it_vbfa INTO wa_vbfa WHERE vbelv = wa_vbap-vbeln
                                   AND posnv = wa_vbap-posnr
                                   AND vbtyp_n = 'M'.

      CLEAR wa_vbrk.
      READ TABLE it_vbrk INTO wa_vbrk WITH KEY   vbeln = wa_vbfa-vbeln.
      IF sy-subrc = 0.
        CLEAR wa_fkimg.
        SELECT SINGLE fkimg FROM vbrp INTO  wa_fkimg  WHERE vbeln = wa_vbrk-vbeln
                                                      AND   aubel = wa_vbap-vbeln
                                                      AND   aupos = wa_vbap-posnr.
      ENDIF.

      wa_fkimg_sum = wa_fkimg_sum + wa_fkimg .
    ENDLOOP.
    wa_final-inv_qty = wa_fkimg_sum.
    wa_final-pend_qty = wa_final-kwmeng - wa_final-inv_qty.

    REFRESH : it_jest2 , it_jest2[] .
    CLEAR : wa_afpo , wa_caufv.

    LOOP AT it_afpo INTO wa_afpo WHERE kdauf = wa_vbap-vbeln
                                   AND kdpos = wa_vbap-posnr
                                   AND matnr = wa_vbap-matnr.


      READ TABLE it_caufv INTO wa_caufv WITH KEY aufnr = wa_afpo-aufnr
                                                 kdauf = wa_afpo-kdauf
                                                 kdpos = wa_afpo-kdpos.
      IF sy-subrc = 0.
        wa_final-igmng = wa_final-igmng + wa_caufv-igmng.
        SELECT objnr stat FROM jest INTO TABLE it_jest2
                              WHERE objnr = wa_caufv-objnr
                                AND inact = ' '.
        CLEAR wa_jest2 .
        READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0012' BINARY SEARCH .
        IF sy-subrc NE 0.
          CLEAR wa_jest2 .
          READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0009' BINARY SEARCH .
          IF sy-subrc NE 0.
            CLEAR wa_jest2 .
            READ TABLE it_jest2 INTO wa_jest2 WITH KEY stat = 'I0002' BINARY SEARCH .
            IF sy-subrc = 0.

              wa_final-wip_qty = wa_final-wip_qty + wa_afpo-psmng - wa_caufv-igmng .

            ENDIF.
          ENDIF.
        ENDIF.

      ENDIF.

    ENDLOOP.
    IF wa_final-wip_qty GT 0. .



    APPEND wa_final TO it_final.
    CLEAR: wa_final,wa_fkimg_sum,wa_fkimg.       "Added By SR ( wa_fkimg) ON 23 MAR 2021

    ENDIF.
  ENDLOOP.
*
*          DELETE IT_FINAL INDEX 1 USING KEY WA_FINAL-WIP_QTY.


  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.


      wa_down-vbeln    = wa_final-vbeln    .
      wa_down-posnr    = wa_final-posnr    .
      wa_down-matnr    = wa_final-matnr    .
      wa_down-kwmeng   = wa_final-kwmeng   .
      wa_down-inv_qty  = wa_final-inv_qty  .
      wa_down-pend_qty = wa_final-pend_qty .
      wa_down-wip_qty  = wa_final-wip_qty  .
      wa_down-igmng    = wa_final-igmng    .

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.

* = sy-uzeit.
      CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO wa_down-time SEPARATED BY ':'.
      APPEND wa_down TO it_down.
      CLEAR wa_down.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_fcat .
  PERFORM fcat USING :  '1'  'VBELN '           'IT_FINAL'  'Sale order '                   '18' ,
                        '2'  'POSNR '           'IT_FINAL'  'So Line Item'                 '18' ,
                        '3'  'MATNR '           'IT_FINAL'  'Item Code'                 '18' ,
                        '4'  'KWMENG'           'IT_FINAL'  'SO Qty'                 '18' ,
                        '5'  'INV_QTY'          'IT_FINAL'  'Invoice Qty'                 '18' ,
                        '6'  'PEND_QTY'         'IT_FINAL'  'Pending Qty'                 '18' ,
                        '7'  'WIP_QTY'          'IT_FINAL'  'WIP Qty'                 '18' ,
                        '8'  'IGMNG'            'IT_FINAL'  'Confirm Qty'                 '18' .
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0905   text
*      -->P_0906   text
*      -->P_0907   text
*      -->P_0908   text
*      -->P_0909   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_display .

* if it_final[] is not initial.
**--CONNECT TO MS SQL TO PUSH THE DATA
*   PERFORM get_connection USING con_name CHANGING go_con.
*   CHECK go_con IS NOT INITIAL.
**   INSERT RECORDS IN MSSQL TABLE AND CLOSE THE CONNECTION
*   PERFORM insert_record. "Added by dhananjay ON 24 FEB 2021
* else.  "No data found
*  write / 'No data to display'.
*  exit.
* endif.
*
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = sy-repid
      it_fieldcat        = it_fcat
      i_save             = 'X'
    TABLES
      t_outtab           = it_final.
*
*If file download option is selected then download the file on app server
  IF p_down = 'X'.

    PERFORM download.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*   Download file
*----------------------------------------------------------------------*

FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

*  DATA: lv_folder(150).
  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
      i_tab_sap_data       = it_down
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

  PERFORM cvs_header USING hd_csv.

*  lv_folder = 'D:\usr\sap\DEV\D00\work'.


  lv_file = 'ZSU_FERT_WIP.TXT'.


*  CONCATENATE p_folder '\' lv_file
  CONCATENATE p_folder '/' lv_file
    INTO lv_fullfile.

  WRITE: / 'ZSU_FERT_WIP REPORT started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_548 TYPE string.
DATA lv_crlf_548 TYPE string.
lv_crlf_548 = cl_abap_char_utilities=>cr_lf.
lv_string_548 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_548 lv_crlf_548 wa_csv INTO lv_string_548.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_548 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Sale order '
              'So Line Item'
              'Item Code'
              'SO Qty'
              'Invoice Qty'
              'Pending Qty'
              'WIP Qty'
              'Confirm Qty'
              'Refresh Date'
              'Refresh Time'
               INTO pd_csv
               SEPARATED BY l_field_seperator.
ENDFORM.

***********************************Code Added By Dhananjay as on 23 feb 2021 for SQL Insert**********************************************
*----------------------------------------------------------------------*
*  FORM connect
*----------------------------------------------------------------------*
*  Connects to the database specified by the logical connection name
*  IV_CON_NAME which is expected to be defined in table DBCON. In case
*  of success the form returns in CO_CON a reference to a connection
*  object of class CL_SQL_CONNECTION.
*----------------------------------------------------------------------*
*  --> IV_CON_NAME  logical connection name as defined in table DBCON
*  <-- CO_CON       reference to a connection object
*----------------------------------------------------------------------*
FORM get_connection USING    pv_con_name TYPE dbcon_name
                    CHANGING co_con      TYPE REF TO cl_sql_connection.

  DATA:
    lx_sqlerr TYPE REF TO cx_sql_exception.


* create a connection object
  IF pv_con_name IS INITIAL.
*   default connection
    CREATE OBJECT co_con.
  ELSE.
*   open a secondary connection
    TRY.
        co_con = cl_sql_connection=>get_connection( pv_con_name ).
      CATCH cx_sql_exception INTO lx_sqlerr.
        PERFORM handle_sql_exception USING lx_sqlerr.
        RETURN.
    ENDTRY.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*  FORM handle_sql_exception
*---------------------------------------------------------------------*
*  Writes the SQL error code and error message to the output list.
*---------------------------------------------------------------------*
*  --> PX_SQLERR  the caught SQL exception
*---------------------------------------------------------------------*
FORM handle_sql_exception  USING px_sqlerr TYPE REF TO cx_sql_exception.

  DATA:
    lv_olen TYPE i.

  FORMAT COLOR COL_NEGATIVE.
  IF px_sqlerr->db_error = 'X'.
    WRITE: / 'SQL error occured:', px_sqlerr->sql_code.     "#EC NOTEXT
    lv_olen = strlen( px_sqlerr->sql_message ).
    PERFORM write_cfield USING px_sqlerr->sql_message lv_olen col_negative.
  ELSE.
    WRITE:
      / 'Error from DBI (details in dev-trace):',           "#EC NOTEXT
        px_sqlerr->internal_error.
  ENDIF.

ENDFORM.
*---------------------------------------------------------------------*
*  FORM write_cfield
*---------------------------------------------------------------------*
*  Displays PV_OLEN characters of the given character field at the
*  current list position. If PV_OLEN is greater than the GV_LINE_SZ,
*  then the output is split into several lines.
*---------------------------------------------------------------------*
*  --> PV_CFIELD    a character field
*  --> PV_OLEN      output length
*  --> PV_COLOR     color to be used
*---------------------------------------------------------------------*
FORM write_cfield USING pv_cfield  TYPE c
                        pv_olen    TYPE i
                        pv_color   LIKE col_normal.

  DATA:
    lv_lines TYPE i,
    lv_off   TYPE i,
    lv_len   TYPE i.


* split into several lines
  IF gv_line_sz = 0.
    gv_line_sz = pv_olen.
  ENDIF.
  lv_lines = pv_olen DIV gv_line_sz.
  DO lv_lines TIMES.
    WRITE / pv_cfield+lv_off(gv_line_sz) COLOR = pv_color.
    ADD gv_line_sz TO lv_off.
  ENDDO.
  IF lv_off < pv_olen.
    lv_len = pv_olen - lv_off.
    WRITE / pv_cfield+lv_off(lv_len) COLOR = pv_color.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  INSERT_RECORD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM insert_record .
  DATA:
    lo_stmt        TYPE REF TO cl_sql_statement,
    lx_sqlerr      TYPE REF TO cx_sql_exception,
    lv_linno       LIKE sy-linno,
    lv_where       TYPE string,
    lv_quoted_name TYPE string,
    cv_sql         TYPE string,
    kwmeng         TYPE string,
    inv_qty        TYPE string,
    pend_qty       TYPE string,
    wip_qty        TYPE string,
    igmng          TYPE string,
    str1           TYPE string,
    str2           TYPE string,
    str3           TYPE string,
    str4           TYPE string,
    lv_qty         TYPE p LENGTH 16 DECIMALS 2.

  cv_sql = 'TRUNCATE TABLE ZFERT_WIP'.  "This will delete all the data

  TRY.
      lo_stmt = go_con->create_statement( ).  "This will create SQL statement
      po_rs = lo_stmt->execute_query( cv_sql ). "This will execute SQL statement
    CATCH cx_sql_exception INTO lx_sqlerr.
      PERFORM handle_sql_exception USING lx_sqlerr.
  ENDTRY.
  CLEAR cv_sql.
  LOOP AT it_final INTO wa_final.
    lv_qty = wa_final-kwmeng.
    kwmeng = lv_qty.
    CLEAR lv_qty.
    lv_qty = wa_final-inv_qty.
    inv_qty = lv_qty.
    CLEAR lv_qty.
    lv_qty = wa_final-pend_qty.
    pend_qty = lv_qty.
    CLEAR lv_qty.
    lv_qty = wa_final-wip_qty.
    wip_qty = lv_qty.
    CLEAR lv_qty.
    lv_qty = wa_final-igmng.
    igmng = lv_qty.


    CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = sdate.

      CONCATENATE sdate+0(2) sdate+2(3) sdate+5(4)
                      INTO sdate SEPARATED BY '-'.

* = sy-uzeit.
    CONCATENATE sy-uzeit+0(2) sy-uzeit+2(2) INTO stime SEPARATED BY ':'.

    str1 = 'INSERT INTO ZFERT_WIP(Sales_Order_No,So_Line_Item_No,Item_Code,SO_Quantity,Invoice_Quantity,'.
    str2 = 'Pending_Quantity,Wip_Quantity,Confirmed_Quantity,Refreshed_On,Refreshed_Time) VALUES ('.


    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value         = kwmeng
              .

    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value         = inv_qty
              .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value         = pend_qty
              .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value         = wip_qty
              .
    CALL FUNCTION 'CLOI_PUT_SIGN_IN_FRONT'
      CHANGING
        value         = igmng
              .


    CONCATENATE '''' wa_final-vbeln ''','''
                wa_final-posnr
                ''','''
                wa_final-matnr
                ''','
                kwmeng ',' inv_qty ','
                pend_qty ','
                wip_qty ','
                igmng','''
                sdate ''','''
                stime ''' )'
       INTO str3.

    CONDENSE str3 NO-GAPS.

    CONCATENATE  str1 str2 str3
    INTO cv_sql.
*write :/ cv_sql.
    TRY.
        lo_stmt = go_con->create_statement( ).
        po_rs = lo_stmt->execute_query( cv_sql ).
      CATCH cx_sql_exception INTO lx_sqlerr.
        PERFORM handle_sql_exception USING lx_sqlerr.
    ENDTRY.
    CLEAR : kwmeng, inv_qty , pend_qty, wip_qty,
            igmng, str1, str2 , str2 , lv_qty ,
            cv_sql.
  ENDLOOP.
  po_rs->close( ).
ENDFORM.

***************************Code end by Dhananjay as on 23 feb 2021**************************************************
