*&---------------------------------------------------------------------*
*& Report ZUS_PROD_ORD_COMPONENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
*&Transaction
*&Functional Cosultant: Shahid Attar
*&Technical Consultant: Jyoti MAhajan
*&TR: 1. DEVK915257       PRIMUSABAP   PRIMUS:USA:101690:ZUS_PROD_DETAILS:PROD ORD COMPONENT WISE
*     2. DEVK915277       PRIMUSABAP   PRIMUS:USA:101690:ZUS_PROD_DETAILS:PROD ORDER COMPONENT WISE
*&Date: 1. 03/12/2024
*&Owner: DelVal Flow Controls
REPORT zus_prod_ord_component.

TABLES:aufk.
************************ALV STRUCTURE
TYPES : BEGIN OF ty_final,
          aufnr     TYPE aufk-aufnr, " Order
          baugr     TYPE resb-baugr, " Finished Material
          fg_desc   TYPE char200, " FINISHED MATERIAL DESCRIPTION
          matnr     TYPE resb-matnr, "Component Material
          component TYPE char200, " Component Material description
          txt04     TYPE string,
          posnr     TYPE resb-posnr, "BOM iTEM
          bdter     TYPE resb-bdter, "REQUIREMENT dATE
          bdmng     TYPE resb-bdmng, "REQUIREMENT QTY
          enmng     TYPE resb-enmng, "QTY WITHDRAWAL
          short_qty TYPE resb-flmng, "SHORTAGE
          lgort     TYPE resb-lgort, "STORAGE LOCATION
          meins     TYPE resb-meins, "UNIT
          aenam     TYPE aufk-aenam,
          aedat     TYPE aufk-aedat,
          gamng     TYPE afko-gamng, "Target Quantity
          igmng     TYPE afko-igmng,
        END OF ty_final.
******************BELOW STRUCTURE FOR DOWNLOAD FILE
TYPES : BEGIN OF ty_down,
          aufnr     TYPE string, " Order
          baugr     TYPE string, " Finished Material
          fg_desc   TYPE string, " FINISHED MATERIAL DESCRIPTION
          matnr     TYPE string, "Component Material
          component TYPE string, " Component Material description
          txt04     TYPE string,
          posnr     TYPE string, "BOM iTEM
          bdter     TYPE string, "REQUIREMENT dATE
          bdmng     TYPE string, "REQUIREMENT QTY
          enmng     TYPE string, "QTY WITHDRAWAL
          short_qty TYPE string, "SHORTAGE
          meins     TYPE string, "UNIT
          gamng     TYPE string, "added by shubhangi on 09.12.24
          igmng     TYPE string,  "added by shubhangi on 09.12.24
          lgort     TYPE string, "STORAGE LOCATION
          aenam     TYPE string, "ORDER CHANGED BY
          aedat     TYPE string, "DATE OF CHANGE
          ref_date  TYPE string,
          ref_time  TYPE string,
        END OF ty_down.

DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final,

       it_down  TYPE TABLE OF ty_down,
       wa_down  TYPE ty_down.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA : i_sort             TYPE slis_t_sortinfo_alv, " SORT
       gt_events          TYPE slis_t_event,        " EVENTS
       i_list_top_of_page TYPE slis_t_listheader,   " TOP-OF-PAGE
       wa_layout          TYPE  slis_layout_alv...

DATA : lv_text TYPE tdobname.
DATA:
  lv_objnr   TYPE caufv-objnr,
  object_tab TYPE bsvx.

***********************************************************************
*                                CONSTANTS                             *
************************************************************************
CONSTANTS:
  c_formname_top_of_page   TYPE slis_formname
                                   VALUE 'TOP_OF_PAGE',
  c_formname_pf_status_set TYPE slis_formname
                                 VALUE 'PF_STATUS_SET',
  c_s                      TYPE c VALUE 'S',
  c_h                      TYPE c VALUE 'H',
  c_spras                  TYPE c VALUE 'E',
  c_werks_low              TYPE char4 VALUE 'US01',
  c_werks_high             TYPE char4 VALUE 'US03',
  c_path                   TYPE char50 VALUE  '/delval/usa' ."' E:/delval/temp5'     .        "'E:\delval\usa'.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_aufnr FOR aufk-aufnr,"OBLIGATORY,
                s_erdat FOR aufk-erdat," OBLIGATORY,
                s_werks FOR aufk-werks OBLIGATORY  MODIF ID bu.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
PARAMETERS p_down AS CHECKBOX.
PARAMETERS p_folder LIKE rlgrap-filename DEFAULT c_path ." 'E:\delval\usa'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b6 WITH FRAME TITLE TEXT-005.
SELECTION-SCREEN  COMMENT /1(60) TEXT-076.
SELECTION-SCREEN END OF BLOCK b6.


INITIALIZATION.
************sELECTION SCREEN DEFUALT VAALUE(FIXED VALUE)
  s_werks-sign = 'I'.
  s_werks-option = 'BT'.
  s_werks-low = c_werks_low .
  s_werks-high = c_werks_high.

  APPEND s_werks.

  CLEAR s_werks.

AT SELECTION-SCREEN OUTPUT.

************SELECTION SCREEN GRAYOUT FIXED VALUE
  LOOP AT SCREEN.
    IF screen-group1 = 'BU'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.



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

  SELECT a~aufnr,
         a~auart,
         a~ernam,
         a~erdat,
         a~aenam,
         a~aedat,
         a~bukrs,
         a~werks,
         a~loekz,
         a~kdauf,
         a~kdpos,
         a~objnr,
         b~rsnum,
         b~baugr,
         b~matnr,
         b~posnr,
         b~bdter,
         b~bdmng,
         b~enmng,
         b~flmng,
         b~plnfl,
         b~vornr,
         b~rspos,
         b~lgort,
         b~meins
         FROM aufk AS a
         JOIN resb AS b
         ON ( a~aufnr = b~aufnr )
         INTO TABLE @DATA(it_aufk_resb)
         WHERE a~aufnr IN @s_aufnr
           AND a~erdat IN @s_erdat
           AND a~werks IN @s_werks.

  IF it_aufk_resb IS NOT INITIAL.
    SELECT matnr,
           spras,
           maktx
           FROM makt
           INTO TABLE @DATA(it_makt_fg)
           FOR ALL ENTRIES IN @it_aufk_resb
           WHERE matnr = @it_aufk_resb-baugr
              AND spras = @c_spras.".

    SELECT matnr,
           spras,
           maktx
           FROM makt
           INTO TABLE @DATA(it_makt_comp)
            FOR ALL ENTRIES IN @it_aufk_resb
           WHERE matnr = @it_aufk_resb-matnr
               AND spras = @c_spras."'E'.
  ELSE.

    MESSAGE e001(zus_del_message).

  ENDIF.

*-------------------added by shubhanggi----------------------------
  IF it_aufk_resb IS NOT INITIAL.
    SELECT aufnr ,
           gamng,
           igmng
           FROM afko INTO TABLE @DATA(it_afko)
           FOR ALL ENTRIES IN @it_aufk_resb
           WHERE aufnr = @it_aufk_resb-aufnr.
  ENDIF.
*-------------------added by shubhanggi----------------------------

  """"pORDUCTION ORDER COMPONENET WISE SO BELOW LOOP ON it_aufk_resb
  LOOP AT it_aufk_resb INTO DATA(wa_aufk_resb).

    wa_final-aufnr   =  wa_aufk_resb-aufnr.
    wa_final-baugr   =  wa_aufk_resb-baugr.
    wa_final-matnr   =  wa_aufk_resb-matnr.
    wa_final-posnr   =  wa_aufk_resb-posnr.
    wa_final-bdter   =  wa_aufk_resb-bdter.
    wa_final-bdmng   =  wa_aufk_resb-bdmng.
    wa_final-enmng   =  wa_aufk_resb-enmng.
*   wa_final-flmng   =  wa_aufk_resb-flmng.
    """""""""""shortage qty is requirement qty minus withdrawl qty
    wa_final-short_qty = wa_final-bdmng - wa_final-enmng.  "shortage qty
*   wa_final-plnfl   =  wa_aufk_resb-plnfl.
*   wa_final-vornr   =  wa_aufk_resb-vornr.
*   wa_final-rspos   =  wa_aufk_resb-rspos.
    wa_final-lgort   =  wa_aufk_resb-lgort.
    wa_final-meins   =  wa_aufk_resb-meins.
    wa_final-aenam   =  wa_aufk_resb-aenam.
    wa_final-aedat   =  wa_aufk_resb-aedat.
    lv_objnr = wa_aufk_resb-objnr.

    READ TABLE it_afko INTO DATA(wa_afko) WITH  KEY aufnr = wa_aufk_resb-aufnr.  "added by shubhangi
    IF sy-subrc = 0.
      wa_final-gamng  = wa_afko-gamng.                                            "added by shubhangi
      wa_final-igmng  = wa_afko-igmng.                                            "added by shubhangi
    ENDIF.

    """"""SYSTEM STAUS FOR PRODUCTON ORDER ******************
    CALL FUNCTION 'STATUS_TEXT_EDIT'
      EXPORTING
        client           = sy-mandt
        flg_user_stat    = 'X'
        objnr            = lv_objnr
        only_active      = 'X'
        spras            = sy-langu
      IMPORTING
        line             = object_tab-sttxt
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
* IMPLEMENT SUITABLE ERROR HANDLING HERE
    ENDIF.

    wa_final-txt04 = object_tab-sttxt.

************ fG mATERIAL dESCRIPTION
    READ TABLE it_makt_fg INTO DATA(wa_makt_fg) WITH KEY matnr = wa_final-baugr.
    IF sy-subrc IS INITIAL.
      wa_final-fg_desc   =  wa_makt_fg-maktx.
    ENDIF.
************ COMPONENT dESCRIPTION
    READ TABLE it_makt_comp INTO DATA(wa_makt_comp) WITH KEY matnr = wa_final-matnr.
    IF sy-subrc IS INITIAL.
      wa_final-component   =  wa_makt_comp-maktx.
    ENDIF.
    APPEND wa_final TO it_final.

  ENDLOOP.
  "bELOW CODE FOR rEFRESHABLE FILE DOWNLOAD*******************************************************
  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.

      wa_down-aufnr   =  wa_final-aufnr .
      wa_down-baugr   =  wa_final-baugr .
      wa_down-fg_desc = wa_final-fg_desc.
      wa_down-matnr   =  wa_final-matnr .
      wa_down-component =  wa_final-component.
      wa_down-posnr   =  wa_final-posnr .
************BELOW LOGIC FOR DATE FORMAT IN REFRESHABLE FILE FORMAT EX. 23-jaN-2024
      IF wa_final-bdter IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-bdter
          IMPORTING
            output = wa_down-bdter.
        CONCATENATE wa_down-bdter+0(2) wa_down-bdter+2(3) wa_down-bdter+5(4)
                        INTO wa_down-bdter SEPARATED BY '-'.
      ENDIF.

      wa_down-bdmng   =  wa_final-bdmng .
      wa_down-enmng   =  wa_final-enmng .
      wa_down-short_qty   =  wa_final-short_qty .
*     wa_down-plnfl   =  wa_final-plnfl .
*     wa_down-vornr   =  wa_final-vornr .
*     wa_down-rspos   =  wa_final-rspos .
*     wa_down-werks   =  wa_final-werks .
      wa_down-lgort   =  wa_final-lgort .
      wa_down-meins   =  wa_final-meins .
      wa_down-gamng   =  wa_final-gamng . " added by shubhangi on 09.12.24
      wa_down-igmng   =  wa_final-igmng . " added by shubhangi on 09.12.24
      wa_down-aenam   =  wa_final-aenam .
      wa_down-txt04 = wa_final-txt04.

      IF wa_final-aedat IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-aedat
          IMPORTING
            output = wa_down-aedat.
        CONCATENATE wa_down-aedat+0(2) wa_down-aedat+2(3) wa_down-aedat+5(4)
                        INTO wa_down-aedat SEPARATED BY '-'.
      ENDIF.


      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref_date.

      CONCATENATE wa_down-ref_date+0(2) wa_down-ref_date+2(3) wa_down-ref_date+5(4)
                      INTO wa_down-ref_date SEPARATED BY '-'.

      wa_down-ref_time = sy-uzeit.
      CONCATENATE wa_down-ref_time+0(2) ':' wa_down-ref_time+2(2)  INTO wa_down-ref_time.


      APPEND wa_down TO it_down.
      CLEAR :wa_down, wa_final.

    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_FOR_OUTPUT
*&---------------------------------------------------------------------*
FORM alv_for_output .
  PERFORM build_fieldcat USING 'AUFNR'          'X' '1'   TEXT-003          '15'     '' .
  PERFORM build_fieldcat USING 'BAUGR'          'X' '2'   TEXT-004          '18'     '' .
  PERFORM build_fieldcat USING 'FG_DESC'        'X' '3'   TEXT-006          '15'     '' .
  PERFORM build_fieldcat USING 'MATNR'          'X' '4'   TEXT-007          '18'     '' .
  PERFORM build_fieldcat USING 'COMPONENT'      'X' '5'   TEXT-008          '15'     '' .
  PERFORM build_fieldcat USING 'TXT04'          'X' '7'   TEXT-009          '15'     '' .
  PERFORM build_fieldcat USING 'POSNR'          'X' '8'   TEXT-010          '15'     '' .
  PERFORM build_fieldcat USING 'BDTER'          'X' '9'   TEXT-011          '15'     '' .
  PERFORM build_fieldcat USING 'BDMNG'          'X' '10'  TEXT-012          '15'     '' .
  PERFORM build_fieldcat USING 'ENMNG'          'X' '11'  TEXT-013          '15'     '' .
  PERFORM build_fieldcat USING 'SHORT_QTY'      'X' '12'  TEXT-014          '15'     '' .
  PERFORM build_fieldcat USING 'MEINS'          'X' '13'  TEXT-015          '15'     '' .
  PERFORM build_fieldcat USING 'GAMNG'          'X' '14'  TEXT-022           '15'    '' .      "added by shubhangi 09.12.2024
  PERFORM build_fieldcat USING 'IGMNG'          'X' '15'  TEXT-023          '15'     '' .      "added by shubhangi
  PERFORM build_fieldcat USING 'LGORT'          'X' '16'  TEXT-016          '15'     '' .
  PERFORM build_fieldcat USING 'AENAM'          'X' '17'  TEXT-017          '15'     '' .
  PERFORM build_fieldcat USING 'AEDAT'          'X' '18'  TEXT-018          '15'     '' .


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
*&      Form  LAYOUT_BUILD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_WA_LAYOUT  text
*----------------------------------------------------------------------*
FORM layout_build  CHANGING p_wa_layout TYPE slis_layout_alv.

  wa_layout-zebra          = 'X'.
  p_wa_layout-zebra          = 'X'.
  p_wa_layout-no_colhead        = ' '.



ENDFORM.                    " LAYOUT_BUILD
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
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*************bELOW LOGIC FOR DOWNLOAD REFRESHABLE FILE NAME AND FILE NAME
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

*  lv_file = 'ZUS_PROD_DETAILS.TXT'.
  lv_file = TEXT-076.

  CONCATENATE p_folder '/' lv_file
     INTO lv_fullfile.

  WRITE: / 'ZUS_PROD_DETAILS.TXT Download started on', sy-datum, 'at', sy-uzeit.
  OPEN DATASET lv_fullfile
    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
  IF sy-subrc = 0.
DATA lv_string_473 TYPE string.
DATA lv_crlf_473 TYPE string.
lv_crlf_473 = cl_abap_char_utilities=>cr_lf.
lv_string_473 = hd_csv.
LOOP AT it_csv INTO wa_csv.
CONCATENATE lv_string_473 lv_crlf_473 wa_csv INTO lv_string_473.
  CLEAR: wa_csv.
ENDLOOP.
TRANSFER lv_string_473 TO lv_fullfile.
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
*******************FILE HEADING FORMAT
  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE TEXT-003
              TEXT-004
              TEXT-006
              TEXT-007
              TEXT-008
              TEXT-009
              TEXT-010
              TEXT-011
              TEXT-012
              TEXT-013
              TEXT-014
              TEXT-015
              TEXT-022  " added by shubhangi on 09.12.24
              TEXT-023  " added by shubhangi on 09.12.24
              TEXT-016
              TEXT-017
              TEXT-018
              TEXT-019
              TEXT-020

*                'Production Order No'
*               'Finished Material'
*               'FG Material Description'
*               'Material No' "
*               'Component Description'
*               'System Status'
*               'BOM Item'
*               'Requirement Date'
*               'Requirement Qty'
*               'Quantity Withdrawl'
*               'Shortage'
*               'Unit'
*               'Storage Location'
*               'Order Changed By'
*               'Date Of Change'
*               'Refeshable Date'
*               'Refreshable Time'

               INTO p_hd_csv
              SEPARATED BY l_field_seperator.
ENDFORM.
