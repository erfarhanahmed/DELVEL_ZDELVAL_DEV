*&---------------------------------------------------------------------*
*&  Include           ZSD_FORMC_CLS
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION .
  PUBLIC SECTION.
    METHODS : handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
                                    IMPORTING e_row_id e_column_id es_row_no,

              handle_data_change_validity FOR EVENT DATA_CHANGED_FINISHED OF CL_GUI_ALV_GRID
                                            IMPORTING ET_GOOD_CELLS.

*              HANDLE_SUBTOTAL_TXT FOR EVENT SUBTOTAL_TEXT OF CL_GUI_ALV_GRID
*                                    IMPORTING "ES_SUBTOTTXT_INFO
*                                              E_EVENT_DATA
*                                              EP_SUBTOT_LINE.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_hotspot_click.
    PERFORM handle_hotspot_click TABLES it SUBLIST USING e_row_id e_column_id es_row_no.
  ENDMETHOD.

  METHOD handle_data_change_validity.
    IF NOT ET_GOOD_CELLS IS INITIAL.
      REFRESH IT_CHNGS.
      IT_CHNGS[] = ET_GOOD_CELLS[].
      REFRESH ET_GOOD_CELLS.
    ENDIF.
    PERFORM check_data_validity TABLES IT IT_CHNGS "USING ET_GOOD_CELLS
                                CHANGING CHK.
  ENDMETHOD.
ENDCLASS.

* class lcl_friend
*  SET_CURRENT_CELL_BASE
*  SET_CURRENT_CELL_ID
*  SET_CURRENT_CELL_ID2
*  SET_CURRENT_CELL_ROWPOS_COLID

CLASS LCL_GUI_ALV_GRID DEFINITION INHERITING FROM CL_GUI_ALV_GRID.
  PUBLIC SECTION.
    METHODS : SET_FOCUS_CELL IMPORTING FCAT TYPE LVC_T_FCAT
                                        ROW_ID TYPE INT4
                                        COL_NAME TYPE CHAR30.
ENDCLASS.

CLASS LCL_GUI_ALV_GRID IMPLEMENTATION.
  METHOD SET_FOCUS_CELL.
   DATA : WA_FCAT TYPE LVC_S_FCAT.
   CLEAR WA_FCAT.
   READ TABLE FCAT INTO WA_FCAT WITH KEY FIELDNAME = COL_NAME.
   IF SY-SUBRC EQ 0.
     CALL METHOD ME->SET_CURRENT_CELL_BASE
       EXPORTING
         ROW    = ROW_ID
         COL = WA_FCAT-COL_POS
       EXCEPTIONS
         ERROR  = 1
         others = 2
             .
     IF SY-SUBRC <> 0.
       MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
     ENDIF.



*     CALL METHOD ME->SET_CURRENT_CELL_BASE
*       EXPORTING
*         ROW    = ROW_ID
*         COL    = WA_FCAT-COL_POS
*       EXCEPTIONS
*         ERROR  = 1
*         OTHERS = 2
*             .
*     IF SY-SUBRC <> 0.
*      MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                 WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
*     ENDIF.
   ENDIF.
 ENDMETHOD.
ENDCLASS.
