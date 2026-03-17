*&---------------------------------------------------------------------*
*& Report ZFI_AR_ROLL_UP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZFI_AR_ROLL_UP.

type-pools: slis.

*Table declaration
tables: BSAD, BSID.

DATA: IT_BSAD  TYPE TABLE OF BSAD,
      IT_BSAD1 TYPE TABLE OF BSAD,
      WA_BSAD  TYPE BSAD,
      WA_BSAD1 TYPE BSAD,
      IT_BSID  TYPE TABLE OF BSID,
      IT_BSID1 TYPE TABLE OF BSID,
      WA_BSID  TYPE BSID,
      WA_BSID1 TYPE BSID.

data: lt_keybalance type table of BAPI3007_3 WITH HEADER LINE,
      lt_return     type bapireturn,
      lv_date type datum.


TYPES: BEGIN OF ty_budat,
       budat TYPE bsad-budat,
       END OF ty_budat.

data: it_budat TYPE TABLE OF TY_BUDAT,
      WA_budat TYPE TY_BUDAT.

TYPES: BEGIN OF ty_kunnr,
       kunnr TYPE knb1-kunnr,
       END OF ty_kunnr.

data: it_kunnr TYPE TABLE OF TY_kunnr,
      WA_kunnr TYPE TY_kunnr.

TYPES: BEGIN OF ty_FINAL,
       budat        TYPE bsad-budat,
       INVOICE      TYPE BSAD-DMBTR,
       CREDIT_MEMO  TYPE BSAD-DMBTR,
       CUST_REFUND  TYPE BSAD-DMBTR,
       CASH_REC     TYPE BSAD-DMBTR,
       DISCOUNT     TYPE BSAD-DMBTR,
       OTHER_DEPOSIT TYPE BSAD-DMBTR,
       TOTAL_DEPOSIT TYPE BSAD-DMBTR,
       opening_bal   TYPE BSAD-DMBTR,
       closing_bal   TYPE BSAD-DMBTR,
       END OF ty_FINAL.

data: it_FINAL TYPE TABLE OF TY_FINAL,
      WA_FINAL TYPE TY_FINAL.
DATA: gl_balan TYPE dmbtr.
DATA: LV_END TYPE BSAD-DMBTR.
data: v_fieldcat type slis_fieldcat_alv,
gt_fieldcat type slis_t_fieldcat_alv,
gt_layout type slis_layout_alv,
gt_sort type slis_sortinfo_alv,
fieldcat like line of gt_fieldcat.


SELECTION-SCREEN: BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-001.
parameters: P_BUKRS TYPE BSAD-BUKRS.
select-options: s_BUDAT for BSAD-BUDAT OBLIGATORY.
SELECTION-SCREEN: END OF BLOCK B1.


start-of-selection.
perform get_data.
perform write_data.
perform fill_fieldcatalog.
PERFORM final_display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT kunnr
         FROM knb1 INTO TABLE it_kunnr
       WHERE bukrs = p_bukrs.

  SELECT *
    FROM BSAD
    INTO TABLE IT_BSAD
    WHERE BUKRS EQ P_BUKRS
    AND BUDAT IN S_BUDAT.

  SELECT *
    FROM BSID
    INTO TABLE IT_BSID
    WHERE BUKRS EQ P_BUKRS
    AND   BUDAT IN S_BUDAT.

   SELECT *
    FROM BSAD
    INTO TABLE IT_BSAD1
    WHERE BUKRS EQ P_BUKRS
    AND   AUGDT IN S_BUDAT.


      LOOP AT IT_BSAD INTO WA_BSAD.
        WA_BUDAT-BUDAT = WA_BSAD-BUDAT.
        APPEND WA_BUDAT TO IT_BUDAT.
      ENDLOOP.
      LOOP AT IT_BSID INTO WA_BSID.
        WA_BUDAT-BUDAT = WA_BSID-BUDAT.
        APPEND WA_BUDAT TO IT_BUDAT.
      ENDLOOP.

      SORT IT_BUDAT BY BUDAT.
      DELETE ADJACENT DUPLICATES FROM IT_BUDAT COMPARING BUDAT.



ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  WRITE_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM write_data .

LOOP AT IT_BUDAT INTO WA_BUDAT.

  WA_FINAL-BUDAT = WA_BUDAT-BUDAT.

              LOOP AT IT_BSAD INTO WA_BSAD WHERE BUDAT EQ WA_BUDAT-BUDAT.
                IF WA_BSAD-shkzg EQ 'H'.
                  WA_BSAD-DMBTR = WA_BSAD-DMBTR * -1.
                ENDIF.
                IF WA_BSAD-BSCHL EQ '01'.     " INVOICE AMOUNT
                  WA_FINAL-INVOICE = WA_FINAL-INVOICE + WA_BSAD-DMBTR.
                ENDIF.

                IF WA_BSAD-BSCHL EQ '12'.     " INVOICE AMOUNT
                  WA_FINAL-INVOICE = WA_FINAL-INVOICE + WA_BSAD-DMBTR.
                ENDIF.

                IF WA_BSAD-BSCHL EQ '11'.     " CREDIT MEMO AMOUNT
                  WA_FINAL-CREDIT_MEMO = WA_FINAL-CREDIT_MEMO + WA_BSAD-DMBTR.
                ENDIF.

                IF WA_BSAD-BSCHL EQ '02'.     " CREDIT MEMO AMOUNT
                  WA_FINAL-CREDIT_MEMO = WA_FINAL-CREDIT_MEMO + WA_BSAD-DMBTR.
                ENDIF.


                IF ( WA_BSAD-BSCHL EQ '09' OR WA_BSAD-BSCHL EQ '19').        " OTHER DEPOSIT
                  WA_FINAL-OTHER_DEPOSIT = WA_FINAL-OTHER_DEPOSIT + WA_BSAD-DMBTR.
                ENDIF.
              ENDLOOP.


              LOOP AT IT_BSID INTO WA_BSID WHERE BUDAT EQ WA_BUDAT-BUDAT.

                IF WA_BSID-REBZG IS NOT INITIAL AND  WA_BSID-BLART = 'DZ'  .
                WA_FINAL-CASH_REC = WA_FINAL-CASH_REC + WA_BSID-DMBTR.   " CASH RECEIPT
                ENDIF.

                IF WA_BSID-shkzg EQ 'H'.
                  WA_BSID-DMBTR = WA_BSID-DMBTR * -1.
                ENDIF.
                IF WA_BSID-BSCHL EQ '01'.         " INVOICE AMOUNT
                  WA_FINAL-INVOICE = WA_FINAL-INVOICE + WA_BSID-DMBTR.
                ENDIF.

                IF WA_BSAD-BSCHL EQ '12'.     " INVOICE AMOUNT
                  WA_FINAL-INVOICE = WA_FINAL-INVOICE + WA_BSAD-DMBTR.
                ENDIF.


                IF WA_BSID-BSCHL EQ '11'.        " CREDIT MEMO
                  WA_FINAL-CREDIT_MEMO = WA_FINAL-CREDIT_MEMO + WA_BSID-DMBTR.
                ENDIF.

                IF WA_BSAD-BSCHL EQ '02'.     " CREDIT MEMO AMOUNT
                  WA_FINAL-CREDIT_MEMO = WA_FINAL-CREDIT_MEMO + WA_BSAD-DMBTR.
                ENDIF.

                IF WA_BSID-BSCHL EQ '19' or WA_BSID-BSCHL EQ '09' .        " OTHER DEPOSIT
                  WA_FINAL-OTHER_DEPOSIT = WA_FINAL-OTHER_DEPOSIT + WA_BSID-DMBTR.
                ENDIF.

              ENDLOOP.


             LOOP AT IT_BSAD1 INTO WA_BSAD1 WHERE AUGDT EQ WA_BUDAT-BUDAT.
             IF WA_BSAD1-shkzg EQ 'H'.
                  WA_BSAD1-DMBTR = WA_BSAD1-DMBTR * -1.
                  IF WA_BSAD1-SKNTO IS NOT INITIAL.
                  WA_BSAD1-SKNTO = WA_BSAD1-SKNTO.
                  ENDIF.
             ENDIF.

             IF WA_BSAD1-BSCHL EQ '11'.        " CUSTOMER REFUND
                  WA_FINAL-CUST_REFUND = WA_FINAL-CUST_REFUND + WA_BSAD1-DMBTR.
             ENDIF.

             IF WA_BSAD1-BSCHL EQ '02'.        " CUSTOMER REFUND
                  WA_FINAL-CUST_REFUND = WA_FINAL-CUST_REFUND - WA_BSAD1-DMBTR.
             ENDIF.

             IF WA_BSAD1-BSCHL EQ '01'.         " CASH RECEIPT AMOUNT
                  WA_FINAL-CASH_REC = WA_FINAL-CASH_REC + WA_BSAD1-DMBTR.
             ENDIF.

             IF WA_BSAD1-BSCHL EQ '12'.         " CASH RECEIPT AMOUNT
               WA_FINAL-CASH_REC = WA_FINAL-CASH_REC + WA_BSAD1-DMBTR.
             ENDIF.

             IF WA_BSAD1-BLART = 'DZ'.         "DISCOUNT
                  WA_FINAL-DISCOUNT = WA_FINAL-DISCOUNT + WA_BSAD1-SKNTO.
             ENDIF.

             IF ( WA_BSAD1-BSCHL EQ '09' OR WA_BSAD1-BSCHL EQ '19').        " OTHER DEPOSIT


                  WA_FINAL-OTHER_DEPOSIT = WA_FINAL-OTHER_DEPOSIT + WA_BSAD1-DMBTR.

             ENDIF.

             ENDLOOP.

           WA_FINAL-CASH_REC = WA_FINAL-CASH_REC - WA_FINAL-DISCOUNT.

           WA_FINAL-TOTAL_DEPOSIT = WA_FINAL-CUST_REFUND + WA_FINAL-CASH_REC - WA_FINAL-OTHER_DEPOSIT.

           IF WA_BUDAT-BUDAT = '20181231'.
             WA_FINAL-TOTAL_DEPOSIT = WA_FINAL-TOTAL_DEPOSIT - 510.
           ENDIF.

          IF SY-TABIX EQ '1'.

           LOOP AT IT_KUNNR INTO WA_KUNNR.

            lv_date = WA_final-BUDAT - 1.
            CALL FUNCTION 'BAPI_AR_ACC_GETKEYDATEBALANCE'
            EXPORTING
              COMPANYCODE        = P_BUKRS
              CUSTOMER           = WA_KUNNR-kunnr
              KEYDATE            = lv_date

            IMPORTING
              RETURN              = lt_return
            TABLES
              KEYBALANCE         = lt_keybalance
          .
          read table  lt_keybalance with KEY currency = 'USD'.
          WA_final-opening_bal = WA_final-opening_bal + lt_keybalance-lc_bal.


          CALL FUNCTION 'BAPI_AR_ACC_GETKEYDATEBALANCE'
             EXPORTING
               COMPANYCODE        = P_BUKRS
               CUSTOMER           = WA_KUNNR-kunnr
               KEYDATE            = lv_date
              BALANCESPGLI       = 'X'
*              NOTEDITEMS         = 'X'
            IMPORTING
              RETURN              = lt_return
             TABLES
               KEYBALANCE         = lt_keybalance
                     .



           read table  lt_keybalance with KEY currency = 'USD' SP_GL_IND = 'A' .
           IF sy-subrc = 0.

              gl_balan = gl_balan - lt_keybalance-lc_bal.

           ENDIF.



          ENDLOOP.

          WA_final-opening_bal = WA_final-opening_bal + gl_balan.
          ENDIF.

         IF SY-TABIX NE '1'.
         WA_FINAL-OPENING_BAL = LV_END.
         CLEAR: LV_END.
         ENDIF.


         wa_final-closing_bal = WA_final-opening_bal + wa_final-invoice + wa_final-credit_memo - wa_final-cust_refund - wa_final-cash_rec
                                                                                      + wa_final-other_deposit - wa_final-discount.
          LV_END = WA_FINAL-CLOSING_BAL.
           APPEND WA_FINAL TO IT_FINAL.

           CLEAR: wa_final,WA_BSAD, WA_BSID, WA_BSAD1.

ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FILL_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fill_fieldcatalog .

clear v_fieldcat.
v_fieldcat-col_pos = 1.
v_fieldcat-fieldname = 'BUDAT'.
v_fieldcat-seltext_m = 'POSTING DATE'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.

clear v_fieldcat.
v_fieldcat-col_pos = 2.
v_fieldcat-fieldname = 'OPENING_BAL'.
v_fieldcat-seltext_m = 'OPENING BALANCE'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.

clear v_fieldcat.
v_fieldcat-col_pos = 3.
v_fieldcat-fieldname = 'INVOICE'.
v_fieldcat-seltext_m = 'INVOICES'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.

clear v_fieldcat.
v_fieldcat-col_pos = 4.
v_fieldcat-fieldname = 'CREDIT_MEMO'.
v_fieldcat-seltext_m = 'CREDIT MEMO'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.

clear v_fieldcat.
v_fieldcat-col_pos = 5.
v_fieldcat-fieldname = 'CUST_REFUND'.
v_fieldcat-seltext_m = 'CUSTOMER REFUND'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.

clear v_fieldcat.
v_fieldcat-col_pos = 6.
v_fieldcat-fieldname = 'CASH_REC'.
v_fieldcat-seltext_m = 'CASH RECEIPT'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.

clear v_fieldcat.
v_fieldcat-col_pos = 7.
v_fieldcat-fieldname = 'DISCOUNT'.
v_fieldcat-seltext_m = 'DISCOUNT'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.

clear v_fieldcat.
v_fieldcat-col_pos = 8.
v_fieldcat-fieldname = 'OTHER_DEPOSIT'.
v_fieldcat-seltext_m = 'OTHER DEPOSITS'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.

clear v_fieldcat.
v_fieldcat-col_pos = 9.
v_fieldcat-fieldname = 'TOTAL_DEPOSIT'.
v_fieldcat-seltext_m = 'TOTAL DEPOSITS'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.


clear v_fieldcat.
v_fieldcat-col_pos = 10.
v_fieldcat-fieldname = 'CLOSING_BAL'.
v_fieldcat-seltext_m = 'CLOSING BALANCE'.
v_fieldcat-outputlen = '25'.
append v_fieldcat to gt_fieldcat.

CLEAR V_FIELDCAT.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page .

*ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c,
        l_period_from TYPE char10,
        l_period_to   TYPE char10.
.

  DATA : date TYPE sy-datum,
         time TYPE sy-uzeit.
*  Title
  wa_header-typ  = 'H'.
  wa_header-info = 'AR ROLL UP'.
  APPEND wa_header TO t_header.
  CLEAR wa_header.

*  Date
  wa_header-typ  = 'S'.
  wa_header-key  = 'Date: '.

  date = sy-datum.
  CONCATENATE wa_header-info date+6(2) '.' date+4(2) '.' date(4) INTO wa_header-info.
  APPEND wa_header TO t_header.
  CLEAR: wa_header.

  PERFORM convert_date_to_external
          USING    s_budat-low
          CHANGING l_period_from.

  PERFORM convert_date_to_external
          USING    s_budat-high
          CHANGING l_period_to.

  wa_header-typ  = 'S'.
  wa_header-key  = 'Run Period: '.
  CONCATENATE l_period_from 'to'(049) l_period_to INTO wa_header-info SEPARATED BY space.
  APPEND  wa_header TO t_header.
  clear: wa_header.

***************time *************


  DATA it_list_commentary TYPE slis_t_listheader.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary       = t_header
*      i_logo                   = 'CORP'
*   I_END_OF_LIST_GRID       =
*   I_ALV_FORM               =
            .

ENDFORM.                    " TOP_OF_PAGE

form final_display .

CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING
*   I_INTERFACE_CHECK                 = ' '
*   I_BYPASSING_BUFFER                = ' '
*   I_BUFFER_ACTIVE                   = ' '
   I_CALLBACK_PROGRAM                = sy-repid
   I_CALLBACK_USER_COMMAND           = 'USER_COMMAND'
   I_CALLBACK_TOP_OF_PAGE            = 'TOP_OF_PAGE'
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   IS_LAYOUT                         = gt_LAYOUT
   IT_FIELDCAT                       = gt_fieldcat[]
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
*   I_SAVE                            = ' '
*   IS_VARIANT                        =
*   IT_EVENTS                         =
*   IT_EVENT_EXIT                     =
*   IS_PRINT                          =
*   IS_REPREP_ID                      =
*   I_SCREEN_START_COLUMN             = 0
*   I_SCREEN_START_LINE               = 0
*   I_SCREEN_END_COLUMN               = 0
*   I_SCREEN_END_LINE                 = 0
*   I_HTML_HEIGHT_TOP                 = 0
*   I_HTML_HEIGHT_END                 = 0
*   IT_ALV_GRAPHICS                   =
*   IT_HYPERLINK                      =
*   IT_ADD_FIELDCAT                   =
*   IT_EXCEPT_QINFO                   =
*   IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*   E_EXIT_CAUSED_BY_CALLER           =
*   ES_EXIT_CAUSED_BY_USER            =
  TABLES
    t_outtab                          = IT_FINAL
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.

endform. " final_display

*&---------------------------------------------------------------------*
*&      Form  CONVERT_DATE_TO_EXTERNAL
*&---------------------------------------------------------------------*
*       Convert Internal date to external format
*----------------------------------------------------------------------*
*      -->U_DATE  Internal Date
*      <--C_DATE  External Date
*----------------------------------------------------------------------*
FORM convert_date_to_external
     USING    u_date TYPE datum
     CHANGING c_date TYPE char10.

  CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
    EXPORTING
      date_internal            = u_date
    IMPORTING
      date_external            = c_date
    EXCEPTIONS
      date_internal_is_invalid = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.
  ENDFORM.
