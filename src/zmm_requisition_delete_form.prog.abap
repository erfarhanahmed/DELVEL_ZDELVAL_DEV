*&---------------------------------------------------------------------*
*&  Include           ZMM_REQU1SITION_DELETE_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&  Include           ZMM_REQUISITION_DELETE_FORM
*&---------------------------------------------------------------------*


*&---------------------------------------------------------------------*
*&      Form  CLEAR_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM CLEAR_DATA .

" REFRESHING INTERNAL TABLES "
REFRESH: I_EBAN,
         I_EBAN1,
         I_MDPS,
         I_RETURN,
         I_PRITEM,
         I_PRITEMX,
         I_BAPIEBAND,
         I_OUTPUT.

" CLEARING WORK AREA "
CLEAR:   W_EBAN1,
         W_MDPS,
         W_RETURN,
         W_PRITEM,
         W_PRITEMX,
         W_BAPIEBAND,
         W_OUTPUT.

ENDFORM.                    " CLEAR_DATA







*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM GET_DATA .

" FETCHING DATA FROM TABLE EBAN "
SELECT BANFN " PURCHASE REQ. NO
       BNFPO " ITEM NO OF PR
       BSMNG " QNTY ORDERED AGAINST PR
       PSTYP " ITEM CATEGORY IN PURCHASING REQ
  INTO TABLE I_EBAN
  FROM EBAN
  WHERE MATNR <> ''
  AND EBAKZ = ''
  AND LOEKZ = ''.

" CHECK ON SELECT QUERY ON TABLE EBAN
  IF SY-SUBRC <> 0.
   W_OUTPUT-MESSAGE = TEXT-005.
   APPEND W_OUTPUT TO I_OUTPUT.

  ELSE.

    SORT I_EBAN BY BANFN BNFPO.

" SELECTING DATA FROM TABLE EBAN
  SELECT WERKS " PLANT
         MATNR " MATERIAL NO
      INTO TABLE I_EBAN1
    FROM EBAN
    FOR ALL ENTRIES IN I_EBAN
    WHERE BANFN = I_EBAN-BANFN
    AND   BNFPO = I_EBAN-BNFPO
    AND   MENGE > I_EBAN-BSMNG.

" CHECK ON SELECT QUERY ON TABLE EBAN
    IF SY-SUBRC = 0.
      SORT I_EBAN1 BY MATNR WERKS.
      LOOP AT I_EBAN1 INTO W_EBAN1.

" CALLING FUNCTION FOR FIRMED PR CHECK
        CALL FUNCTION 'MD_STOCK_REQUIREMENTS_LIST_API'
          EXPORTING
            MATNR                          = W_EBAN1-MATNR
            WERKS                          = W_EBAN1-WERKS
         TABLES
           MDPSX                          = I_MDPS
         EXCEPTIONS
           MATERIAL_PLANT_NOT_FOUND       = 1
           PLANT_NOT_FOUND                = 2
           OTHERS                         = 3
                  .

" INNER LOOP TABLE I_MDPS FOR FIX01 CONDITION "
        LOOP AT  I_MDPS INTO W_MDPS WHERE FIX01 = 'X'
        AND DELKZ = 'BA'.

        " CHECK FOR OPTION CLOSE "
        IF RD_CLOS = 'X' .
          READ TABLE I_EBAN INTO W_EBAN WITH KEY BANFN = W_MDPS-DELNR
          BNFPO = W_MDPS-DELPS BINARY SEARCH TRANSPORTING PSTYP.

          " REFRESING I_RETURN, PRITEM AND PRITEMX
          REFRESH: I_RETURN, I_PRITEM, I_PRITEMX.
          CLEAR: W_RETURN, W_PRITEM, W_PRITEMX.

          W_PRITEM-PREQ_ITEM = W_MDPS-DELPS.
          W_PRITEM-ITEM_CAT = W_EBAN-PSTYP.
          W_PRITEM-DELETE_IND = 'X'.
          APPEND W_PRITEM TO I_PRITEM.


          W_PRITEMX-PREQ_ITEM = W_MDPS-DELPS.
          W_PRITEMX-ITEM_CAT = 'X'.
          W_PRITEMX-DELETE_IND = 'X'.
          APPEND W_PRITEMX TO I_PRITEMX.


        " FM BAPI_PR_CHANGE CALLED FOR DELETING PR "
          CALL FUNCTION 'BAPI_PR_CHANGE'
            EXPORTING
              NUMBER                      = W_MDPS-DELNR

           TABLES
             RETURN                      = I_RETURN
             PRITEM                      = I_PRITEM
             PRITEMX                     = I_PRITEMX .


         IF NOT ( I_RETURN IS INITIAL ).
            READ TABLE I_RETURN INTO W_RETURN INDEX 1.
              IF W_RETURN-TYPE = 'E' .
                W_OUTPUT-NOTE = TEXT-011.
               ELSE.
           " BAPI FOR COMMIT CHANGES "
           CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
             EXPORTING
                 WAIT          = 'X'
             IMPORTING
                 RETURN        = RETURN1.

                W_OUTPUT-NOTE = TEXT-012.
              ENDIF.

              W_OUTPUT-BANFN = W_MDPS-DELNR.
              W_OUTPUT-BNFPO = W_MDPS-DELPS.
              W_OUTPUT-MESSAGE = W_RETURN-MESSAGE.

              APPEND W_OUTPUT TO I_OUTPUT.

            ENDIF.

          ELSEIF RD_TEST = 'X'.

            W_OUTPUT-BANFN = W_MDPS-DELNR.
            W_OUTPUT-BNFPO = W_MDPS-DELPS.
            W_OUTPUT-MESSAGE = TEXT-008.
            APPEND W_OUTPUT TO I_OUTPUT.

        ENDIF.

ENDLOOP.
ENDLOOP.

" CHECK IF I_OUTPUT IS INITITAL "
IF I_OUTPUT[] IS INITIAL .
W_OUTPUT-MESSAGE = TEXT-005.
APPEND W_OUTPUT TO I_OUTPUT.
ENDIF.

  ENDIF.

  ENDIF.
ENDFORM.                    " GET_DATA









*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM DISPLAY_DATA .

REFRESH : I_FIELDCAT.
CLEAR: W_FIELDCAT.


" FIELD CATALOGUE BUILD "
W_FIELDCAT-FIELDNAME = 'BANFN'.
W_FIELDCAT-SELTEXT_M = TEXT-001.
W_FIELDCAT-COL_POS = 1.
W_FIELDCAT-OUTPUTLEN = 10.
APPEND W_FIELDCAT TO I_FIELDCAT.
CLEAR: W_FIELDCAT.


" FIELD CATALOGUE BUILD "
W_FIELDCAT-FIELDNAME = 'BNFPO'.
W_FIELDCAT-SELTEXT_M = TEXT-002.
W_FIELDCAT-COL_POS = 2.
W_FIELDCAT-OUTPUTLEN = 10.
APPEND W_FIELDCAT TO I_FIELDCAT.
CLEAR: W_FIELDCAT.

" FIELD CATALOGUE BUILD "
W_FIELDCAT-FIELDNAME = 'NOTE'.
W_FIELDCAT-SELTEXT_M = TEXT-010.
W_FIELDCAT-COL_POS = 3.
IF RD_TEST = 'X'.
W_FIELDCAT-TECH = 'X'.
ENDIF.
W_FIELDCAT-OUTPUTLEN = 15.
APPEND W_FIELDCAT TO I_FIELDCAT.
CLEAR: W_FIELDCAT.


" FIELD CATALOGUE BUILD "
W_FIELDCAT-FIELDNAME = 'MESSAGE'.
W_FIELDCAT-SELTEXT_M = TEXT-003.
W_FIELDCAT-COL_POS = 4.
W_FIELDCAT-OUTPUTLEN = 220.
APPEND W_FIELDCAT TO I_FIELDCAT.
CLEAR: W_FIELDCAT.




" ALV LAYOUT BUILD "
LAYOUT-NO_INPUT = 'X'.
LAYOUT-COLWIDTH_OPTIMIZE = 'X'.
LAYOUT-HEADER_TEXT = TEXT-006.



CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
 EXPORTING

   I_CALLBACK_PROGRAM                = SY-REPID
*   I_CALLBACK_PF_STATUS_SET          = ' '
*   I_CALLBACK_USER_COMMAND           = ' '
*   I_CALLBACK_TOP_OF_PAGE            = ' '
*   I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*   I_CALLBACK_HTML_END_OF_LIST       = ' '
*   I_STRUCTURE_NAME                  =
*   I_BACKGROUND_ID                   = ' '
*   I_GRID_TITLE                      =
*   I_GRID_SETTINGS                   =
   IS_LAYOUT                         = LAYOUT
   IT_FIELDCAT                       = I_FIELDCAT[]
*   IT_EXCLUDING                      =
*   IT_SPECIAL_GROUPS                 =
*   IT_SORT                           =
*   IT_FILTER                         =
*   IS_SEL_HIDE                       =
*   I_DEFAULT                         = 'X'
   I_SAVE                            = 'X'
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
    T_OUTTAB                          = I_OUTPUT
 EXCEPTIONS
   PROGRAM_ERROR                     = 1
   OTHERS                            = 2
          .
IF SY-SUBRC <> 0.
MESSAGE TEXT-007 TYPE 'E'.
ENDIF.



ENDFORM.                    " DISPLAY_DATA
