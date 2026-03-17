*&---------------------------------------------------------------------*
*& Report ZOBD_DETAILS
*&---------------------------------------------------------------------*
*&Report: OBD report (Sales order details against Delivery)
*&Functional Comsultant: Tejaswini Kapadnis
*&Technical Consultant: Diksha Halve
*&Date: 31.01.2023
*&Transort Request: DEVK910835
*&---------------------------------------------------------------------*
REPORT zobd_details.

TABLES : likp, vbfa, vbap, vbak, kna1.
TYPE-POOLS:slis.

TYPES : BEGIN OF ty_likp,
          vbeln TYPE likp-vbeln,
          werks TYPE likp-werks,
          erdat TYPE likp-erdat,
        END OF ty_likp.

TYPES : BEGIN OF ty_vbfa,
          vbelv   TYPE vbfa-vbelv,
          posnv   TYPE vbfa-posnv,
          vbeln   TYPE vbfa-vbeln,
          posnn   TYPE vbfa-posnn,
          vbtyp_n TYPE vbfa-vbtyp_n,
          rfmng   TYPE vbfa-rfmng,
        END OF ty_vbfa.

TYPES : BEGIN OF ty_vbap,
          vbeln TYPE vbap-vbeln,
          posnr TYPE vbap-posnr,
          matnr TYPE vbap-matnr,
*          arktx TYPE vbap-arktx,
        END OF ty_vbap.

TYPES : BEGIN OF ty_vbak,
          vbeln TYPE vbak-vbeln,
          kunnr TYPE vbak-kunnr,
        END OF ty_vbak.

TYPES : BEGIN OF ty_kna1,
          kunnr TYPE kna1-kunnr,
          name1 TYPE kna1-name1,
        END OF ty_kna1.

TYPES : BEGIN OF ty_final,
*          vbeln   TYPE likp-vbeln,
          werks   TYPE likp-werks,
          erdat   TYPE likp-erdat,

          vbelv   TYPE vbfa-vbelv,
          posnv   TYPE vbfa-posnv,
          vbeln   TYPE vbfa-vbeln,
          posnn   TYPE vbfa-posnn,
          vbtyp_n TYPE vbfa-vbtyp_n,
          rfmng   TYPE vbfa-rfmng,

*          vbeln   TYPE vbap-vbeln,
          posnr   TYPE vbap-posnr,
          matnr   TYPE vbap-matnr,
*          arktx   TYPE vbap-arktx,
*          kunnr   TYPE vbak-kunnr,
*          name1   TYPE kna1-name1,
        END OF ty_final.

DATA : it_likp TYPE STANDARD TABLE OF ty_likp,
       wa_likp TYPE ty_likp,
       it_vbfa TYPE STANDARD TABLE OF ty_vbfa,
       wa_vbfa TYPE ty_vbfa,
       it_vbap TYPE STANDARD TABLE OF ty_vbap,
       wa_vbap TYPE ty_vbap,
       it_vbak TYPE STANDARD TABLE OF ty_vbak,
       wa_vbak TYPE ty_vbak,
       it_kna1 TYPE STANDARD TABLE OF ty_kna1,
       wa_kna1 TYPE ty_kna1.

DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final.
DATA : it_fcat TYPE slis_t_fieldcat_alv,
       wa_fcat LIKE LINE OF it_fcat.

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS        : s_werks TYPE likp-werks OBLIGATORY DEFAULT 'PL01'.
SELECT-OPTIONS    : s_vbeln FOR likp-vbeln,
                    s_erdat FOR likp-erdat.
SELECTION-SCREEN:END OF BLOCK b1.

AT SELECTION-SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF screen-name EQ 'S_WERKS'.
      screen-input = '0'.
      MODIFY SCREEN.
    ENDIF.
  ENDLOOP.

START-OF-SELECTION.

  PERFORM fetch_data.
  PERFORM get_data.
  PERFORM get_fcat.
  PERFORM display_data.
*&---------------------------------------------------------------------*
*&      Form  FETCH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_data .

  SELECT vbelv
         posnv
         vbeln
         posnn
         vbtyp_n
         rfmng
    FROM vbfa INTO TABLE it_vbfa
    WHERE vbeln IN s_vbeln
    AND erdat IN s_erdat
    AND vbtyp_n = 'J'.

  IF it_vbfa IS NOT INITIAL.
    SELECT vbeln
           posnr
           matnr
*           arktx
      FROM vbap INTO TABLE it_vbap
      FOR ALL ENTRIES IN it_vbfa
      WHERE vbeln EQ it_vbfa-vbelv
      AND posnr EQ it_vbfa-posnv.

*    SELECT vbeln
*         kunnr
*    FROM vbak INTO TABLE it_vbak
*    FOR ALL ENTRIES IN it_vbfa
*    WHERE vbeln = it_vbfa-vbelv.
*
*    IF it_vbak IS NOT INITIAL.
*      SELECT kunnr
*             name1
*        FROM kna1 INTO TABLE it_kna1
*        FOR ALL ENTRIES IN it_vbak
*        WHERE kunnr = it_vbak-kunnr.
*    ENDIF.
  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  LOOP AT it_vbfa INTO wa_vbfa.
    wa_final-vbelv = wa_vbfa-vbelv.
    wa_final-posnv = wa_vbfa-posnv.
    wa_final-vbeln = wa_vbfa-vbeln.
    wa_final-posnn = wa_vbfa-posnn.
    wa_final-vbtyp_n = wa_vbfa-vbtyp_n.
    wa_final-rfmng = wa_vbfa-rfmng.

*    READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbfa-vbelv.
*    wa_final-kunnr = wa_vbak-kunnr.
*
*    READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbak-kunnr.
*    wa_final-name1 = wa_kna1-name1.

    LOOP AT it_vbap INTO wa_vbap WHERE vbeln = wa_vbfa-vbelv AND posnr = wa_vbfa-posnv.
*      wa_final-vbeln = wa_vbap-vbeln.
      wa_final-posnr = wa_vbap-posnr.
      wa_final-matnr = wa_vbap-matnr.
*      wa_final-arktx = wa_vbap-arktx.

*      READ TABLE it_vbak INTO wa_vbak WITH KEY vbeln = wa_vbak-vbeln.
*      wa_final-kunnr = wa_vbak-kunnr.

*      READ TABLE it_kna1 INTO wa_kna1 WITH KEY kunnr = wa_vbak-kunnr.
*      wa_final-name1 = wa_kna1-name1.

      APPEND wa_final TO it_final.
      CLEAR wa_final.
    ENDLOOP.

  ENDLOOP.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_data .

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
  IF sy-subrc <> 0.
* Implement suitable error handling here
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

  PERFORM fcat USING : '1'   'VBELV'           'IT_FINAL'      'Sales Order NO'                             '10' ,
                       '2'   'POSNV'           'IT_FINAL'      'Sales Order Line Item'                      '10',
                       '3'   'VBELN'           'IT_FINAL'      'Delivery No'                      '10',
                       '4'   'POSNN'           'IT_FINAL'      'Delivery Line Item No'                      '10',
                       '5'   'RFMNG'           'IT_FINAL'      'Quantity'                      '10',
                       '6'   'MATNR'           'IT_FINAL'      'Material No'                      '20'.
*                       '7'   'ARKTX'           'IT_FINAL'      'Material Description'                      '30',
*                       '8'   'KUNNR'           'IT_FINAL'      'Customer Code'                      '10',
*                       '9'   'NAME1'           'IT_FINAL'      'Customer Name'                      '20'.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0376   text
*      -->P_0377   text
*      -->P_0378   text
*      -->P_0379   text
*      -->P_0380   text
*----------------------------------------------------------------------*
FORM fcat  USING    VALUE(p_0376)
                    VALUE(p_0377)
                    VALUE(p_0378)
                    VALUE(p_0379)
                    VALUE(p_0380).

  wa_fcat-col_pos   = p_0376.
  wa_fcat-fieldname = p_0377.
  wa_fcat-tabname   = p_0378.
  wa_fcat-seltext_l = p_0379.
  wa_fcat-outputlen   = p_0380.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.

ENDFORM.
