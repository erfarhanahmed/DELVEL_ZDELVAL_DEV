*&---------------------------------------------------------------------*
*& Report ZGLMASTER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&Report: ZGLMASTER
*&Transaction : ZGLMASTER
* Report for Genreal Ledger Information against gl account no.
*&Functional Cosultant: Shradhha Koli
*&Technical Consultant: Jyoti MAhajan
*&TR: 1. DEVK915104       PRIMUSABAP   PRIMUS:INDIA:101690:ZFG_RACK:DISPATCH FG RACK LOCATION
*&Date: 1. 27/01/2025
*&Owner: DelVal Flow Controls
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zglmaster.
***below tables used in report
TABLES : ska1, skb1, skat.

**********Below structure for alv display**********
TYPES: BEGIN OF ty_final,
         bukrs     TYPE skb1-bukrs,
         saknr     TYPE skb1-saknr,
         begru     TYPE skb1-begru,
         busab     TYPE skb1-busab,
         datlz     TYPE skb1-datlz,
         erdat     TYPE skb1-erdat,
         ernam     TYPE skb1-ernam,
         fdgrv     TYPE skb1-fdgrv,
         fdlev     TYPE skb1-fdlev,
         fipls     TYPE skb1-fipls,
         fstag     TYPE skb1-fstag,
         hbkid     TYPE skb1-hbkid,
         hktid     TYPE skb1-hktid,
         kdfsl     TYPE skb1-kdfsl,
         mitkz     TYPE skb1-mitkz,
         mwskz     TYPE skb1-mwskz,
         stext     TYPE skb1-stext,
         vzskz     TYPE skb1-vzskz,
         waers     TYPE skb1-waers,
         wmeth     TYPE skb1-wmeth,
         xgkon     TYPE skb1-xgkon,
         xintb     TYPE skb1-xintb,
         xkres     TYPE skb1-xkres,
         xloeb     TYPE skb1-xloeb,
         xnkon     TYPE skb1-xnkon,
         xopvw     TYPE skb1-xopvw,
         xspeb     TYPE skb1-xspeb,
         zindt     TYPE skb1-zindt,
         zinrt     TYPE skb1-zinrt,
         zuawa     TYPE skb1-zuawa,
         altkt     TYPE skb1-altkt,
         xmitk     TYPE skb1-xmitk,
         recid     TYPE skb1-recid,
         fipos     TYPE skb1-fipos,
         xmwno     TYPE skb1-xmwno,
         xsalh     TYPE skb1-xsalh,
         bewgp     TYPE skb1-bewgp,
         infky     TYPE skb1-infky,
         togru     TYPE skb1-togru,
         xlgclr    TYPE skb1-xlgclr,
         mcakey    TYPE skb1-mcakey,
         ktopl     TYPE ska1-ktopl,
         xbilk     TYPE ska1-xbilk,
         sakan     TYPE ska1-sakan,
         bilkt     TYPE ska1-bilkt,
         gvtyp     TYPE ska1-gvtyp,
         ktoks     TYPE ska1-ktoks,
         mustr     TYPE ska1-mustr,
         vbund     TYPE ska1-vbund,
         xloev     TYPE ska1-xloev,
         xspea     TYPE ska1-xspea,
         xspep     TYPE ska1-xspep,
         mcod1     TYPE ska1-mcod1,
         func_area TYPE ska1-func_area,
         txt20     TYPE skat-txt20,
         txt50     TYPE skat-txt50,
         txt30     TYPE t077z-txt30,
*         LINE_INDEX TYPE
       END OF ty_final.

*****Below structure for Refreshable File***********
TYPES: BEGIN OF ty_down,
         bukrs      TYPE string,
         saknr      TYPE string,
         begru      TYPE string,
         busab      TYPE string,
         datlz      TYPE string,
         erdat      TYPE string,
         ernam      TYPE string,
         fdgrv      TYPE string,
         fdlev      TYPE string,
         fipls      TYPE string,
         fstag      TYPE string,
         hbkid      TYPE string,
         hktid      TYPE string,
         kdfsl      TYPE string,
         mitkz      TYPE string,
         mwskz      TYPE string,
         stext      TYPE string,
         vzskz      TYPE string,
         waers      TYPE string,
         wmeth      TYPE string,
         xgkon      TYPE string,
         xintb      TYPE string,
         xkres      TYPE string,
         xloeb      TYPE string,
         xnkon      TYPE string,
         xopvw      TYPE string,
         xspeb      TYPE string,
         zindt      TYPE string,
         zinrt      TYPE string,
         zuawa      TYPE string,
         altkt      TYPE string,
         xmitk      TYPE string,
         recid      TYPE string,
         fipos      TYPE string,
         xmwno      TYPE string,
         xsalh      TYPE string,
         bewgp      TYPE string,
         infky      TYPE string,
         togru      TYPE string,
         xlgclr     TYPE string,
         mcakey     TYPE string,
         ktopl      TYPE string,
         xbilk      TYPE string,
         sakan      TYPE string,
         bilkt      TYPE string,
         gvtyp      TYPE string,
         ktoks      TYPE string,
         mustr      TYPE string,
         vbund      TYPE string,
         xloev      TYPE string,
         xspea      TYPE string,
         xspep      TYPE string,
         mcod1      TYPE string,
         func_area  TYPE string,
         txt20      TYPE string,
         txt50      TYPE string,
         txt30      TYPE string,
*         line_index TYPE string,
         ref_date   TYPE string,
         ref_time   TYPE string,
       END OF ty_down.

*********Below internal table and work area for alv display
DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final,

       it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat,

*********Below internal table and work area for refreshable file
       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE ty_down.

 DATA : i_sort             TYPE slis_t_sortinfo_alv, " SORT
       gt_events          TYPE slis_t_event,        " EVENTS
       i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
       wa_layout          TYPE  slis_layout_alv...


CONSTANTS : c_path                   TYPE char50 VALUE '/delval/temp',     "'/delval/temp',
            c_ktopl                  TYPE char4  VALUE '1000',
            c_spras                  TYPE char2 VALUE 'EN'.

INITIALIZATION.
******Selection screen for company code and  gl account
  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME .
   PARAMETERS : s_bukrs TYPE skb1-bukrs OBLIGATORY."comapny code
   SELECT-OPTIONS            :     s_saknr FOR skb1-saknr. " Gl account no
  PARAMETERS : p_ktoks TYPE ska1-ktoks.  "account Group               .
  SELECTION-SCREEN END OF BLOCK b2.
  SELECTION-SCREEN END OF BLOCK b1.

***********selection screen for download refreshable file********
  SELECTION-SCREEN BEGIN OF BLOCK b5 WITH FRAME TITLE TEXT-002 .
  PARAMETERS p_down AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT c_path.
  SELECTION-SCREEN END OF BLOCK b5.
************Below code for refreshable file name***********************
  SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-062.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-063.
  SELECTION-SCREEN END OF BLOCK b6.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM alv_for_output.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
****Below select query for gl account details
  IF p_ktoks IS INITIAL.
    SELECT  a~bukrs
            a~saknr
            a~begru
            a~busab
            a~datlz
            a~erdat
            a~ernam
            a~fdgrv
            a~fdlev
            a~fipls
            a~fstag
            a~hbkid
            a~hktid
            a~kdfsl
            a~mitkz
            a~mwskz
            a~stext
            a~vzskz
            a~waers
            a~wmeth
            a~xgkon
            a~xintb
            a~xkres
            a~xloeb
            a~xnkon
            a~xopvw
            a~xspeb
            a~zindt
            a~zinrt
            a~zuawa
            a~altkt
            a~xmitk
            a~recid
            a~fipos
            a~xmwno
            a~xsalh
            a~bewgp
            a~infky
            a~togru
            a~xlgclr
            a~mcakey
            b~ktopl
            b~xbilk
            b~sakan
            b~bilkt
            b~gvtyp
            b~ktoks
            b~mustr
            b~vbund
            b~xloev
            b~xspea
            b~xspep
            b~mcod1
            b~func_area
            c~txt20
            c~txt50
            d~txt30
*        ref_date,
*        ref_time
*         INTO TABLE @data(it_data)
             INTO TABLE it_final
             FROM skb1 AS a
             JOIN ska1 AS b ON ( b~saknr = a~saknr )
             JOIN skat AS c ON ( c~saknr = a~saknr AND C~ktopl = b~ktopl )
             JOIN t077z as d on  ( d~ktopl = b~ktopl and d~ktoks = b~ktoks )
             WHERE a~bukrs = s_bukrs
             AND a~saknr IN s_saknr
              and c~ktopl = c_ktopl"'1000'
              AND C~SPRAS = c_Spras"'EN'..
              AND d~SPRAS = c_Spras."'EN'..
*           and b~ktoks = @p_ktoks.
  ELSE.
    SELECT  a~bukrs
            a~saknr
            a~begru
            a~busab
            a~datlz
            a~erdat
            a~ernam
            a~fdgrv
            a~fdlev
            a~fipls
            a~fstag
            a~hbkid
            a~hktid
            a~kdfsl
            a~mitkz
            a~mwskz
            a~stext
            a~vzskz
            a~waers
            a~wmeth
            a~xgkon
            a~xintb
            a~xkres
            a~xloeb
            a~xnkon
            a~xopvw
            a~xspeb
            a~zindt
            a~zinrt
            a~zuawa
            a~altkt
            a~xmitk
            a~recid
            a~fipos
            a~xmwno
            a~xsalh
            a~bewgp
            a~infky
            a~togru
            a~xlgclr
            a~mcakey
            b~ktopl
            b~xbilk
            b~sakan
            b~bilkt
            b~gvtyp
            b~ktoks
            b~mustr
            b~vbund
            b~xloev
            b~xspea
            b~xspep
            b~mcod1
            b~func_area
            c~txt20
            c~txt50
            d~txt30
*         ref_date
*         ref_time
             INTO TABLE it_final
             FROM skb1 AS a
             JOIN ska1 AS b ON ( b~saknr = a~saknr )
             JOIN skat AS c ON ( c~saknr = a~saknr AND C~ktopl = b~ktopl )
             JOIN t077z as d on  ( d~ktopl = b~ktopl and d~ktoks = b~ktoks )
             WHERE a~bukrs = s_bukrs
               AND a~saknr IN s_saknr
            AND b~ktoks = p_ktoks
             and c~ktopl = c_ktopl"'1000'
             AND C~SPRAS = c_Spras"'EN'.
             AND d~SPRAS = c_Spras."'EN'.
  ENDIF.

*  if it_data is INITIAL.
  IF it_final IS INITIAL.
    MESSAGE e001(zdelval_mesaage).
  ENDIF.

*  it_final = it_data.
break primusabap.
  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final .
*    wa_down = wa_final.
      wa_down-bukrs     = wa_FINAL-bukrs     .
      wa_down-saknr     = wa_FINAL-saknr     .
      wa_down-begru     = wa_FINAL-begru     .
      wa_down-busab     = wa_FINAL-busab     .
*      wa_down-datlz     = wa_FINAL-datlz     .
*   wa_down-erdat     = wa_down-erdat     .
      wa_down-ernam     = wa_FINAL-ernam     .
      wa_down-fdgrv     = wa_FINAL-fdgrv     .
      wa_down-fdlev     = wa_FINAL-fdlev     .
      wa_down-fipls     = wa_FINAL-fipls     .
      wa_down-fstag     = wa_FINAL-fstag     .
      wa_down-hbkid     = wa_FINAL-hbkid     .
      wa_down-hktid     = wa_FINAL-hktid     .
      wa_down-kdfsl     = wa_FINAL-kdfsl     .
      wa_down-mitkz     = wa_FINAL-mitkz     .
      wa_down-mwskz     = wa_FINAL-mwskz     .
      wa_down-stext     = wa_FINAL-stext     .
      wa_down-vzskz     = wa_FINAL-vzskz     .
      wa_down-waers     = wa_FINAL-waers     .
      wa_down-wmeth     = wa_FINAL-wmeth     .
      wa_down-xgkon     = wa_FINAL-xgkon     .
      wa_down-xintb     = wa_FINAL-xintb     .
      wa_down-xkres     = wa_FINAL-xkres     .
      wa_down-xloeb     = wa_FINAL-xloeb     .
      wa_down-xnkon     = wa_FINAL-xnkon     .
      wa_down-xopvw     = wa_FINAL-xopvw     .
      wa_down-xspeb     = wa_FINAL-xspeb     .
      wa_down-zindt     = wa_FINAL-zindt     .
      wa_down-zinrt     = wa_FINAL-zinrt     .
      wa_down-zuawa     = wa_FINAL-zuawa     .
      wa_down-altkt     = wa_FINAL-altkt     .
      wa_down-xmitk     = wa_FINAL-xmitk     .
      wa_down-recid     = wa_FINAL-recid     .
      wa_down-fipos     = wa_FINAL-fipos     .
      wa_down-xmwno     = wa_FINAL-xmwno     .
      wa_down-xsalh     = wa_FINAL-xsalh     .
      wa_down-bewgp     = wa_FINAL-bewgp     .
      wa_down-infky     = wa_FINAL-infky     .
      wa_down-togru     = wa_FINAL-togru     .
      wa_down-xlgclr    = wa_FINAL-xlgclr    .
      wa_down-mcakey    = wa_FINAL-mcakey    .
      wa_down-ktopl     = wa_FINAL-ktopl     .
      wa_down-xbilk     = wa_FINAL-xbilk     .
      wa_down-sakan     = wa_FINAL-sakan     .
      wa_down-bilkt     = wa_FINAL-bilkt     .
      wa_down-gvtyp     = wa_FINAL-gvtyp     .
      wa_down-ktoks     = wa_FINAL-ktoks     .
      wa_down-mustr     = wa_FINAL-mustr     .
      wa_down-vbund     = wa_FINAL-vbund     .
      wa_down-xloev     = wa_FINAL-xloev     .
      wa_down-xspea     = wa_FINAL-xspea     .
      wa_down-xspep     = wa_FINAL-xspep     .
      wa_down-mcod1     = wa_FINAL-mcod1     .
      wa_down-func_area = wa_FINAL-func_area .
      wa_down-txt20     = wa_FINAL-txt20     .
      wa_down-txt50     = wa_FINAL-txt50     .
      wa_down-txt30     = wa_FINAL-txt30     .

      IF wa_FINAL-datlz IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_FINAL-datlz
          IMPORTING
            output = wa_down-datlz.
         CONCATENATE wa_down-datlz+0(2) wa_down-datlz+2(3) wa_down-datlz+5(4)
                       INTO wa_down-datlz SEPARATED BY '-'.
      ENDIF.




*      wa_down-datlz     = wa_FINAL-datlz
      IF wa_final-erdat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-erdat
          IMPORTING
            output = wa_down-erdat.
      ENDIF.

      CONCATENATE wa_down-erdat+0(2) wa_down-erdat+2(3) wa_down-erdat+5(4)
                       INTO wa_down-erdat SEPARATED BY '-'.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_date.

      CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
                      INTO wa_down-ref_date SEPARATED BY '-'.

      wa_down-ref_time = sy-uzeit.
      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.

*        wa_down = wa_final.
      APPEND wa_down TO it_down.
      CLEAR :wa_down, wa_final.

    ENDLOOP.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
FORM alv_for_output .
  PERFORM build_fieldcat USING 'BUKRS'          'X' '1'   TEXT-005          '04'     '' .
  PERFORM build_fieldcat USING 'SAKNR'          'X' '2'   TEXT-006          '18'     '' .
  PERFORM build_fieldcat USING 'BEGRU'          'X' '3'   TEXT-007          '15'     '' .
  PERFORM build_fieldcat USING 'BUSAB'          'X' '4'   TEXT-008          '18'     '' .
  PERFORM build_fieldcat USING 'DATLZ'          'X' '5'   TEXT-009          '15'     '' .
  PERFORM build_fieldcat USING 'ERDAT'          'X' '7'   TEXT-010          '15'     '' .
  PERFORM build_fieldcat USING 'ERNAM'          'X' '8'   TEXT-011          '15'     '' .
  PERFORM build_fieldcat USING 'FTGRV'          'X' '9'   TEXT-012          '15'     '' .
  PERFORM build_fieldcat USING 'FDLEV'          'X' '10'  TEXT-013          '15'     '' .
  PERFORM build_fieldcat USING 'FIPLS'          'X' '11'  TEXT-014          '15'     '' .
  PERFORM build_fieldcat USING 'FSTAG'          'X' '12'  TEXT-015          '15'     '' .
  PERFORM build_fieldcat USING 'HBKID'          'X' '13'  TEXT-016          '15'     '' .
  PERFORM build_fieldcat USING 'HKTID'          'X' '14'  TEXT-017           '15'    '' .      "added by shubhangi 09.12.2024
  PERFORM build_fieldcat USING 'KDFSL'          'X' '15'  TEXT-018          '15'     '' .      "added by shubhangi
  PERFORM build_fieldcat USING 'MIDKZ'          'X' '16'  TEXT-019          '15'     '' .
  PERFORM build_fieldcat USING 'MWSKZ'          'X' '17'  TEXT-020          '15'     '' .
  PERFORM build_fieldcat USING 'STEXT'          'X' '18'  TEXT-021          '15'     '' .
  PERFORM build_fieldcat USING 'VZSKZ'          'X' '19'  TEXT-022          '15'     '' .
  PERFORM build_fieldcat USING 'WAERS'          'X' '20'  TEXT-023          '15'     '' .
  PERFORM build_fieldcat USING 'WMETH'          'X' '21'  TEXT-024          '15'     '' .
  PERFORM build_fieldcat USING 'XGKON'          'X' '22'  TEXT-025          '15'     '' .
  PERFORM build_fieldcat USING 'XINTB'          'X' '23'  TEXT-026          '15'     '' .
  PERFORM build_fieldcat USING 'XKRES'          'X' '24'  TEXT-027          '15'     '' .
  PERFORM build_fieldcat USING 'XLOEB'          'X' '25'  TEXT-028          '15'     '' .
  PERFORM build_fieldcat USING 'XNKON'          'X' '26'  TEXT-029          '15'     '' .
  PERFORM build_fieldcat USING 'XOPVW'          'X' '27'  TEXT-030          '15'     '' .
  PERFORM build_fieldcat USING 'XSPEB'          'X' '28'  TEXT-031          '15'     '' .
  PERFORM build_fieldcat USING 'ZINDT'          'X' '29'  TEXT-032          '15'     '' .
  PERFORM build_fieldcat USING 'ZINRT'          'X' '30'  TEXT-033          '15'     '' .
  PERFORM build_fieldcat USING 'ZUAWA'          'X' '31'  TEXT-034          '15'     '' .
  PERFORM build_fieldcat USING 'ALTKT'          'X' '32'  TEXT-035         '15'     '' .
  PERFORM build_fieldcat USING 'XMITK'          'X' '33'  TEXT-036          '15'     '' .
  PERFORM build_fieldcat USING 'RECID'          'X' '34'  TEXT-037          '15'     '' .
  PERFORM build_fieldcat USING 'FIPOS'          'X' '35'  TEXT-038          '15'     '' .
  PERFORM build_fieldcat USING 'XMWNO'          'X' '36'  TEXT-039          '15'     '' .
  PERFORM build_fieldcat USING 'XSALH'          'X' '37'  TEXT-040          '15'     '' .
  PERFORM build_fieldcat USING 'BEWGP'          'X' '38'  TEXT-041          '15'     '' .
  PERFORM build_fieldcat USING 'INFKY'          'X' '39'  TEXT-042          '15'     '' .
  PERFORM build_fieldcat USING 'TOGRU'          'X' '40'  TEXT-043          '15'     '' .
  PERFORM build_fieldcat USING 'XLGCLR'         'X' '41'  TEXT-044          '15'     '' .
  PERFORM build_fieldcat USING 'MCAKEY'         'X' '42'  TEXT-045          '15'     '' .
  PERFORM build_fieldcat USING 'KTOPL'          'X' '43'  TEXT-046         '15'     '' .
  PERFORM build_fieldcat USING 'XBILK'          'X' '44'  TEXT-047          '15'     '' .
  PERFORM build_fieldcat USING 'SAKAN'          'X' '45'  TEXT-048          '15'     '' .
  PERFORM build_fieldcat USING 'BILKT'          'X' '46'  TEXT-049          '15'     '' .
  PERFORM build_fieldcat USING 'GVTYP'          'X' '47'  TEXT-050          '15'     '' .
  PERFORM build_fieldcat USING 'KTOKS'          'X' '48'  TEXT-051          '15'     '' .
  PERFORM build_fieldcat USING 'MUSTR'          'X' '49'  TEXT-052          '15'     '' .
  PERFORM build_fieldcat USING 'VBUND'          'X' '50'  TEXT-053          '15'     '' .
  PERFORM build_fieldcat USING 'XLOEV'          'X' '51'  TEXT-054          '15'     '' .
  PERFORM build_fieldcat USING 'XSPEA'          'X' '52'  TEXT-055          '15'     '' .
  PERFORM build_fieldcat USING 'XSPEP'          'X' '53'  TEXT-056          '15'     '' .
  PERFORM build_fieldcat USING 'MCOD1'          'X' '54'  TEXT-057          '15'     '' .
  PERFORM build_fieldcat USING 'FUNC_AREA'      'X' '55'  TEXT-058          '15'     '' .
  PERFORM build_fieldcat USING 'TXT20'          'X' '56'  TEXT-059          '15'     '' .
  PERFORM build_fieldcat USING 'TXT50'          'X' '57'  TEXT-060         '15'     '' .
  PERFORM build_fieldcat USING 'TXT30'          'X' '58'  TEXT-061         '15'     '' .
*  PERFORM build_fieldcat USING 'LINE_INDEX'      X' '58'  TEXT-061         '15'     '' .

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program       = sy-repid
*     i_structure_name         = 'OUTPUT'
      is_layout                = wa_layout
      it_fieldcat              = it_fcat
      it_sort                  = i_sort
      i_callback_pf_status_set = 'PF_STATUS_SET'
*     i_callback_user_command  = 'USER_COMMAND'
*     i_default                = 'A'
*     i_save                   = 'A'
      i_save                   = 'X'
      it_events                = gt_events[]
    TABLES
      t_outtab                 = it_final
    EXCEPTIONS
      program_error            = 1
      OTHERS                   = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  IF p_down = 'X'.

    PERFORM download.
  ENDIF.
ENDFORM.
FORM pf_status_set USING extab TYPE slis_t_extab.
  SET PF-STATUS 'STANDARD'.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*

FORM build_fieldcat  USING    v1  v2 v3 v4 v5 v6.
  wa_fcat-fieldname   = v1 ." 'VBELN'.
  wa_fcat-tabname     = 'IT_FINAL'.  "'IT_FINAL_NEW'.
  wa_fcat-key         =  v2 ."  'X'.
  wa_fcat-seltext_l   =  v4.
  wa_fcat-outputlen   =  v5." 20.
  wa_fcat-col_pos     =  v3.
  wa_fcat-edit     =  v6.
  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.                    " BUILD_FIELDCAT
*&-----------------------------------------------------------------
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
        wa_csv TYPE LINE OF truxs_t_text_data,
        hd_csv TYPE LINE OF truxs_t_text_data.

  DATA: lv_file(30).
  DATA: lv_fullfile TYPE string,
        lv_dat(10),
        lv_tim(4).
  DATA: lv_msg(80).

  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
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
  break primusabap.
  IF S_BUKRS = '1000'.
  lv_file = 'IND_GL.TXT'.
  ELSEIF S_BUKRS = 'SU00'.
      lv_file = 'SAUDI_GL.TXT'.
  ELSEIF S_BUKRS = 'US00'.
      lv_file = 'US_GL.TXT'.
  ENDIF.

  CONCATENATE p_folder '/' lv_file
     INTO lv_fullfile.
*  DATA :GV_STRING TYPE STRING.
*  CONCATENATE  INTO GV_STRING SEPARATED BY ''.
   IF S_BUKRS = '1000'.
  WRITE: / 'IND_GL.TXT Download started on' , sy-datum, 'at', sy-uzeit.
 ELSEIF S_BUKRS = 'SU00'.
     WRITE: / 'SAUDI_GL.TXT Download started on' , sy-datum, 'at', sy-uzeit.
  ELSEIF S_BUKRS = 'US00'.
       WRITE: / 'US_GL.TXT Download started on' , sy-datum, 'at', sy-uzeit.
  ENDIF.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_632 TYPE string.
DATA lv_crlf_632 TYPE string.
lv_crlf_632 = cl_abap_char_utilities=>cr_lf.
lv_string_632 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_632 lv_crlf_632 wa_csv INTO lv_string_632.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_632 TO lv_fullfile.
    CLOSE DATASET lv_fullfile.
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
FORM cvs_header  USING    p_hd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE text-005
              text-006
              text-007
              text-008
              text-009
              text-010
              text-011
              text-012
              TEXT-013
              TEXT-014
              TEXT-015
              TEXT-016
              TEXT-017
              TEXT-018
              TEXT-019
              TEXT-020
              TEXT-021
              TEXT-022
              TEXT-023
              TEXT-024
              TEXT-025
              TEXT-026
              TEXT-027
              TEXT-028
              TEXT-029
              TEXT-030
              TEXT-031
              TEXT-032
              TEXT-033
              TEXT-034
              TEXT-035
              TEXT-036
              TEXT-037
              TEXT-038
              TEXT-039
              TEXT-040
              TEXT-041
              TEXT-042
              TEXT-043
              TEXT-044
              TEXT-045
              TEXT-046
              TEXT-047
              TEXT-048
              TEXT-049
              TEXT-050
              TEXT-051
              TEXT-052
              TEXT-053
              TEXT-054
              TEXT-055
              TEXT-056
              TEXT-057
              TEXT-058
              TEXT-059
              TEXT-060
              TEXT-061
              TEXT-064
              TEXT-065
               INTO p_hd_csv

              SEPARATED BY l_field_seperator.

ENDFORM.
