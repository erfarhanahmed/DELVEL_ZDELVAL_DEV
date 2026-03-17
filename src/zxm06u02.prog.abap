*&---------------------------------------------------------------------*
*&  Include           ZXM06U02
*&---------------------------------------------------------------------*

DATA: w_e1edkt1 TYPE e1edkt1,
      w_e1edkt2 TYPE e1edkt2.

DATA: w_e1edpt1 TYPE e1edpt1.
DATA: w_e1edk01 TYPE e1edk01.

DATA: lt_e1edkt2 TYPE TABLE OF e1edkt2.

DATA: w_edidd TYPE edidd.
DATA: w_sdata TYPE edi_sdata.

STATICS: l_added TYPE xfeld,
         l_count TYPE i.

DATA: gv_tabix TYPE sy-tabix.
DATA: lt_lines TYPE TABLE OF tline.
DATA: w_name TYPE thead-tdname.
**--------------------------------------------------------------------**

** Payment Term
READ TABLE int_edidd INTO w_edidd WITH KEY segnam = 'E1EDK01'.
IF sy-subrc = 0.
  gv_tabix = sy-tabix.
  w_e1edk01 = w_edidd-sdata.
  CLEAR w_e1edk01-zterm.

  w_edidd-sdata   = w_e1edk01.
  MODIFY int_edidd FROM w_edidd INDEX gv_tabix.
  CLEAR: w_edidd, gv_tabix.
ENDIF.

READ TABLE int_edidd INTO w_edidd WITH KEY segnam = 'E1EDK18'.
IF sy-subrc = 0.
  DELETE int_edidd WHERE segnam = 'E1EDK18'.
ENDIF.



**--------------------------------------------------------------------**
** For Header Text Element Change For SO
READ TABLE int_edidd INTO w_edidd WITH KEY segnam = 'E1EDKT1'.
IF sy-subrc = 0.
  gv_tabix = sy-tabix.
  w_e1edkt1 = w_edidd-sdata.
  w_e1edkt1-tdid         = 'Z060'.
  w_e1edkt1-tsspras      = 'E'.
  w_e1edkt1-tsspras_iso  = 'EN'.
  w_e1edkt1-tdobject     = 'VBBK'.

  w_edidd-sdata   = w_e1edkt1.
  MODIFY int_edidd FROM w_edidd INDEX gv_tabix.
  CLEAR: w_edidd, gv_tabix.
ENDIF.

** For Item Text Element Chanfe For SO
LOOP AT int_edidd INTO w_edidd WHERE segnam = 'E1EDPT1'.
  IF sy-subrc = 0.
    gv_tabix = sy-tabix.
    w_e1edpt1 = w_edidd-sdata.

    w_e1edpt1-tdid         = 'Z061'.
    w_e1edkt1-tsspras      = 'E'.
    w_e1edkt1-tsspras_iso  = 'EN'.
*    w_e1edpt1-tdobject     = 'VBBP'.

    w_edidd-sdata   = w_e1edpt1.
    MODIFY int_edidd FROM w_edidd INDEX gv_tabix.
    CLEAR: w_edidd, gv_tabix.
  ENDIF.

ENDLOOP.

**--------------------------------------------------------------------**
**READ TABLE int_edidd WITH KEY segnam = 'E1EDP01'.
**IF sy-subrc = 0.
**  gv_tabix = sy-tabix.
**  IF int_edidd-segnam = 'E1EDP01'.
**    IF l_added IS INITIAL.
**      IF l_count EQ 1.
**
**        w_name = xekko-ebeln.
**
**        CALL FUNCTION 'READ_TEXT'
**          EXPORTING
**            client                  = sy-mandt
**            id                      = 'F01'
**            language                = 'E'                    "sy-langu
**            name                    = w_name
**            object                  = 'EKKO'
***           ARCHIVE_HANDLE          = 0
***           LOCAL_CAT               = ' '
***     IMPORTING
***           HEADER                  =
***           OLD_LINE_COUNTER        =
**          TABLES
**            lines                   = lt_lines
**          EXCEPTIONS
**            id                      = 1
**            language                = 2
**            name                    = 3
**            not_found               = 4
**            object                  = 5
**            reference_check         = 6
**            wrong_access_to_archive = 7
**            OTHERS                  = 8.
**        IF sy-subrc = 0.
**          w_e1edkt1-tdid         = 'F01'.
**          w_e1edkt1-tsspras      = 'E'.
**          w_e1edkt1-tsspras_iso  = 'EN'.
**          w_e1edkt1-tdobject     = 'EKKO'.
**          w_e1edkt1-tdobname     = w_name.
**
**          w_edidd-mandt   = sy-mandt.
***      w_edidd-DOCNUM  =.
***      w_edidd-SEGNUM  = 000012.
**          w_edidd-segnam  = 'E1EDKT1'.
***      w_edidd-PSGNUM  = .
**          w_edidd-hlevel  = '02'.
***      w_edidd-DTINT2  =.
**          w_edidd-sdata   = w_e1edkt1.
**
***          APPEND w_edidd TO int_edidd.
**          INSERT w_edidd INTO int_edidd INDEX gv_tabix.
**          CLEAR: w_edidd, w_e1edkt1.
**
*****************************************************************
**
**          APPEND LINES OF lt_lines TO lt_e1edkt2.
**
**
**          w_edidd-mandt   = sy-mandt.
***          w_edidd-SEGNUM  = 000013.
**          w_edidd-segnam  = 'E1EDKT2'.
**          w_edidd-hlevel  = '03'.
**
**          LOOP AT lt_e1edkt2 INTO w_e1edkt2.
**            gv_tabix = gv_tabix + 1.
**
**            w_edidd-sdata   = w_e1edkt2.
***            APPEND w_edidd TO int_edidd.
**            INSERT w_edidd INTO int_edidd INDEX gv_tabix.
**            CLEAR: w_e1edkt2, w_edidd-sdata.
**          ENDLOOP.
**        ENDIF.
**        l_added  = 'X'.
**      ENDIF.
**      l_count = l_count + 1.
**    ENDIF.
**  ENDIF.
**ENDIF.
