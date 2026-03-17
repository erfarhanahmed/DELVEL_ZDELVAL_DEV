*&---------------------------------------------------------------------*
*& Report ZUS_INBOUND_DELIVERY_REPORT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsa_inbound_delivery_report.
TYPE-POOLS: slis.
TABLES:likp.
TYPES:BEGIN OF ty_likp,
        vbeln TYPE likp-vbeln,
        erdat TYPE likp-erdat,
        verur TYPE likp-verur,
        kunnr TYPE likp-kunnr,
        lifnr TYPE likp-lifnr,
        trspg TYPE likp-trspg,  "AVINASH BHAGAT 01.02.2019
      END OF ty_likp.

DATA : it_likp TYPE TABLE OF ty_likp,
       wa_likp TYPE ty_likp.

TYPES : BEGIN OF ty_vbrp,
          vbeln TYPE vbrp-vbeln,
          vgbel TYPE vbrp-vgbel,
        END OF ty_vbrp.

DATA : it_vbrp TYPE TABLE OF ty_vbrp,
       wa_vbrp TYPE ty_vbrp.
***************************** Change by avinash bhagat 25.01.2019 ref by sachin newade***********************************************
TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbrk-vbeln,
          xblnr TYPE vbrk-xblnr,
        END OF ty_vbrk.

DATA : it_vbrk TYPE TABLE OF ty_vbrk,
       wa_vbrk TYPE ty_vbrk.
****************************** end avinash*********************************************
****************************** Change by avinash bhagat 01.02.2019 ref by sachin newade*********************************************
TYPES : BEGIN OF ty_ttsgt,
          spras TYPE ttsgt-spras,
          trspg TYPE ttsgt-trspg,
          bezei TYPE ttsgt-bezei,
        END OF ty_ttsgt.

DATA : it_ttsgt TYPE TABLE OF ty_ttsgt,
       wa_ttsgt TYPE ty_ttsgt.

********************************************* end avinash***************************************************************************************
TYPES : BEGIN OF ty_final,
          erdat TYPE likp-erdat,
          verur TYPE likp-verur,
          kunnr TYPE likp-kunnr,
          vbeln TYPE likp-vbeln,
          vgbel TYPE vbrp-vgbel,
          inv   TYPE vbrp-vbeln,
          xblnr TYPE vbrk-xblnr, " Change by avinash bhagat 25.01.2019 ref by sachin newade
          taxno TYPE vbrk-xblnr, " Change by avinash bhagat 25.01.2019 ref by sachin newade
          trspg TYPE ttsgt-trspg,  " Change by avinash bhagat 01.02.2019 ref by sachin newade
          bezei TYPE ttsgt-bezei,  " Change by avinash bhagat 01.02.2019 ref by sachin newade
        END OF ty_final.

DATA : it_final TYPE TABLE OF ty_final,
       wa_final TYPE ty_final.

DATA : it_fcat TYPE slis_t_fieldcat_alv .
DATA : wa_fcat LIKE LINE OF it_fcat .

SELECTION-SCREEN:BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS : p_date FOR likp-erdat OBLIGATORY,
                 p1_dno FOR likp-verur ."OBLIGATORY.

SELECTION-SCREEN:END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM get_data.
  PERFORM det_fcat.
  PERFORM get_display.

*PERFORM PROCESS_DATA.
*perform display_fieldcat.
*PERFORM display_data.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  SELECT vbeln
         erdat
         verur
         kunnr
         lifnr
         trspg
    FROM likp INTO TABLE it_likp
    WHERE verur IN  p1_dno
    AND erdat IN  p_date
*    AND lifnr = '0001200000'.
    AND lifnr = '0000600001'.


  SORT it_likp BY vbeln.

  LOOP AT it_likp INTO wa_likp.

    wa_final-vbeln = wa_likp-vbeln.
    wa_final-erdat = wa_likp-erdat.
    wa_final-verur = wa_likp-verur.
    wa_final-trspg = wa_likp-trspg.

    SELECT SINGLE vbeln INTO wa_final-inv FROM vbrp WHERE vgbel = wa_likp-verur AND shkzg NE 'X'.
    SELECT SINGLE xblnr INTO wa_final-taxno FROM vbrk WHERE vbeln = wa_final-inv.                        " Change by avinash bhagat 25.01.2019 ref by sachin newade add xblnr
    SELECT SINGLE  BEZEI INTO WA_FINAL-BEZEI FROM TTSGT WHERE TRSPG = WA_FINAL-TRSPG and SPRAS = 'E'.    " Change by avinash bhagat 01.02.2019 ref by sachin newade add BEZEI DESRC


    APPEND wa_final TO it_final.
    CLEAR : wa_final.
  ENDLOOP.





ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DET_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM det_fcat .

  PERFORM fcat USING :
                         '1'  'VBELN'         'IT_FINAL'  'Inbound Delivery'                           '18',
                         '2'  'BEZEI'         'IT_FINAL'  'Status Of Inbound Delivery'                 '22',  " Change by avinash bhagat 25.01.2019 ref by sachin newade
                         '3'  'VERUR'         'IT_FINAL'  'Outbond Delivry'                            '18',
                         '4'  'ERDAT'         'IT_FINAL'  'Doc Date'                                   '18',
                         '5'  'INV'           'IT_FINAL'  'Invoice No'                                 '18',
                         '6'  'taxno'         'IT_FINAL'  'Tax Invoice No'                             '18'.   " Change by avinash bhagat 25.01.2019 ref by sachin newade




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
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0542   text
*      -->P_0543   text
*      -->P_0544   text
*      -->P_0545   text
*      -->P_0546   text
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
*  wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.


ENDFORM.
