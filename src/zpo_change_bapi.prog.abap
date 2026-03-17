
REPORT ZPO_CHANGE_BAPI.

TYPES: BEGIN OF TY_ITAB ,
       EBELN(10)    TYPE C,
       LMAKTX(2500) TYPE C,
*       LMAKTX TYPE string,
       ROW TYPE I,
       TSIZE TYPE I,
   END OF TY_ITAB.

TYPES : BEGIN OF ty_text,
*        ebeln(10)    TYPE C,
        text TYPE char255,
        END OF ty_text.
        DATA : lt_text TYPE TABLE OF ty_text,
               ls_text TYPE ty_text.




*  Data Declarations - Internal Tables
DATA: I_TAB  TYPE STANDARD TABLE OF TY_ITAB  INITIAL SIZE 0,
      WA TYPE TY_ITAB ,
      IT_EXLOAD LIKE ZALSMEX_TABLINE  OCCURS 0 WITH HEADER LINE.

DATA: size TYPE i.
DATA: IT_LINES       LIKE STANDARD TABLE OF TLINE WITH HEADER LINE,
      IT_TEXT_HEADER LIKE STANDARD TABLE OF THEAD WITH HEADER LINE,
      P_ERROR TYPE  SY-LISEL ,
      LEN TYPE I .
*    Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK B1 WITH FRAME TITLE TEXT-002.
PARAMETERS:PFILE TYPE RLGRAP-FILENAME OBLIGATORY.
*           W_BEGIN TYPE I OBLIGATORY,
*           W_END TYPE I OBLIGATORY.
SELECTION-SCREEN END OF BLOCK B1.

AT SELECTION-SCREEN.
  IF PFILE IS INITIAL.
    MESSAGE S368(00) WITH 'Please input filename'. STOP.
  ENDIF.

START-OF-SELECTION.

  REFRESH:I_TAB.
  BREAK primus.
  PERFORM EXCEL_DATA_INT_TABLE.
  PERFORM EXCEL_TO_INT.
*  PERFORM CONTOL_PARAMETER.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR PFILE.
  PERFORM F4_FILENAME.
*&---------------------------------------------------------------------*
*&      Form  F4_FILENAME
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM F4_FILENAME .
  CALL FUNCTION 'F4_FILENAME'
  EXPORTING
    PROGRAM_NAME        = SYST-CPROG
    DYNPRO_NUMBER       = SYST-DYNNR
*   FIELD_NAME          = ' '
  IMPORTING
    FILE_NAME           = PFILE
           .
ENDFORM.                    " F4_FILENAME
*&---------------------------------------------------------------------*
*&      Form  EXCEL_DATA_INT_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM EXCEL_DATA_INT_TABLE .

  CALL FUNCTION 'ZALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      FILENAME    = PFILE
      I_BEGIN_COL = '0001'
      I_BEGIN_ROW = '0002'
      I_END_COL   = '0002'
      I_END_ROW   = '0501'                                   "65536
    TABLES
      INTERN      = IT_EXLOAD.

ENDFORM.                    " EXCEL_DATA_INT_TABLE
*&---------------------------------------------------------------------*
*&      Form  EXCEL_TO_INT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM EXCEL_TO_INT .


  LOOP AT IT_EXLOAD .
    CASE  IT_EXLOAD-COL.
      WHEN '0001'.
        WA-ebeln   = IT_EXLOAD-VALUE.
      WHEN '0002'.
        WA-LMAKTX   = IT_EXLOAD-VALUE.
    ENDCASE.
    AT END OF ROW.
      WA-TSIZE = STRLEN( WA-LMAKTX ) .
      WA-ROW = IT_EXLOAD-ROW .
      APPEND WA TO I_TAB.
      CLEAR WA .
    ENDAT.
  ENDLOOP.
  BREAK primus.


  LOOP AT i_tab INTO wa.

    SPLIT wa-LMAKTX AT CL_ABAP_CHAR_UTILITIES=>NEWLINE INTO TABLE lt_text .

    IT_TEXT_HEADER-TDID     = 'F01'.
    IT_TEXT_HEADER-TDSPRAS  = SY-LANGU .
    IT_TEXT_HEADER-TDNAME   = WA-EBELN.
    IT_TEXT_HEADER-TDOBJECT = 'EKKO'.

*    MOVE WA-TSIZE TO LEN .

*    LEN =  LEN / 70  + 1.

*    DO LEN TIMES .
LOOP AT lt_text INTO ls_text.

      MOVE '*' TO IT_LINES-TDFORMAT.
      MOVE  ls_text-text TO IT_LINES-TDLINE .
      SHIFT IT_LINES-TDLINE LEFT DELETING LEADING ' '.
      SHIFT IT_LINES-TDLINE LEFT DELETING LEADING ' " '.
      SHIFT IT_LINES-TDLINE RIGHT DELETING TRAILING ' " '.
      CONDENSE IT_LINES-TDLINE.
      APPEND IT_LINES.
      CLEAR IT_LINES .
ENDLOOP.
*    AT END OF ROW.
      CALL FUNCTION 'SAVE_TEXT'
        EXPORTING
          CLIENT          = SY-MANDT
          HEADER          = IT_TEXT_HEADER
          INSERT          = ' '
          SAVEMODE_DIRECT = 'X'
        TABLES
          LINES           = IT_LINES
        EXCEPTIONS
          ID              = 1
          LANGUAGE        = 2
          NAME            = 3
          OBJECT          = 4
          OTHERS          = 5.
* Check the Return Code
      IF SY-SUBRC <> 0.
        MESSAGE ID SY-MSGID TYPE SY-MSGTY
            NUMBER SY-MSGNO
              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 INTO P_ERROR.
        EXIT.
      ENDIF.
      CLEAR: WA ,LEN ,ls_text.
      REFRESH :IT_LINES ,lt_text.
*    ENDAT.
  ENDLOOP.



ENDFORM.                    " EXCEL_TO_INT
*&---------------------------------------------------------------------*
*&      Form  CONTOL_PARAMETER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
**----------------------------------------------------------------------*
*FORM CONTOL_PARAMETER .
*
*  DATA OFF TYPE I VALUE '1'.
*
*
*
*  LOOP AT I_TAB INTO WA.
*
**    * Create Header
*    IT_TEXT_HEADER-TDID     = 'F01'.
*    IT_TEXT_HEADER-TDSPRAS  = SY-LANGU .
*    IT_TEXT_HEADER-TDNAME   = WA-EBELN.
*    IT_TEXT_HEADER-TDOBJECT = 'EKKO'.
*
*    MOVE WA-TSIZE TO LEN .
*
*    LEN =  LEN / 70  + 1.
*
*    DO LEN TIMES .
*      MOVE '*' TO IT_LINES-TDFORMAT.
*      MOVE  WA-LMAKTX+OFF(70) TO IT_LINES-TDLINE .
*      SHIFT IT_LINES-TDLINE LEFT DELETING LEADING ' '.
*
*      OFF = OFF + 70 .
*      APPEND IT_LINES.
*      CLEAR IT_LINES .
*    ENDDO.
*
*    AT END OF ROW.
*      CALL FUNCTION 'SAVE_TEXT'
*        EXPORTING
*          CLIENT          = SY-MANDT
*          HEADER          = IT_TEXT_HEADER
*          INSERT          = ' '
*          SAVEMODE_DIRECT = 'X'
*        TABLES
*          LINES           = IT_LINES
*        EXCEPTIONS
*          ID              = 1
*          LANGUAGE        = 2
*          NAME            = 3
*          OBJECT          = 4
*          OTHERS          = 5.
** Check the Return Code
*      IF SY-SUBRC <> 0.
*        MESSAGE ID SY-MSGID TYPE SY-MSGTY
*            NUMBER SY-MSGNO
*              WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4 INTO P_ERROR.
*        EXIT.
*      ENDIF.
*      CLEAR: WA ,LEN , OFF.
*      REFRESH IT_LINES .
*    ENDAT.
*  ENDLOOP.
*ENDFORM.                    " CONTOL_PARAMETERreport ZPO
