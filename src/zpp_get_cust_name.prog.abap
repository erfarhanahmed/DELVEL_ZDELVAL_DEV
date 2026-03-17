*&---------------------------------------------------------------------*
*& Report ZPP_GET_CUST_NAME
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zpp_get_cust_name.

TABLES : stxh.
DATA: v_htext  TYPE  char2000, "string ,
      v_htext1 TYPE  char2000,
      v_htext2 TYPE  char2000,
      v_htext3 TYPE  char2000,
      v_htext4 TYPE  char2000,
      v_itext  TYPE  char2000,
      v_itext1 TYPE  char2000,
      v_itext2 TYPE  char2000,
      v_itext3 TYPE  char2000,
      v_itext4 TYPE  char2000.
*&---------------------------------------------------------------------*
*&      Form  get_cust_name
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->IN_TAB     text
*      -->OUT_TAB    text
*----------------------------------------------------------------------*
FORM get_cust_name TABLES in_tab STRUCTURE itcsy
              out_tab STRUCTURE itcsy  .
  DATA: v_custname     TYPE kunum,
        v_prodord      TYPE aufnr,
        v_name         TYPE kna1-name1,

        v_prodorder    TYPE afpo-aufnr,
        v_kdauf        TYPE co_kdauf,
        v_kdpos        TYPE co_kdpos,
        lv_matnr       TYPE afpo-matnr,

        v_salesorder   TYPE thead-tdname, "vbeln,
        v_so_item      TYPE thead-tdname, "POSNR


        it_line_header TYPE STANDARD TABLE OF tline,
        wa_line_header TYPE tline,

        it_line_item   TYPE STANDARD TABLE OF tline,
        wa_line_item   TYPE tline.
****Reading customer name from in_tab
  READ TABLE in_tab INDEX 1 .
  v_custname = in_tab-value.
****Reading Production order no from in_tab
  READ TABLE in_tab INDEX 2 .
  v_prodord = in_tab-value.

*****Conversion for customer no.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_custname
    IMPORTING
      output = v_custname.
  .
*****Conversion for Production order no.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_prodord
    IMPORTING
      output = v_prodord.
****Selecting customer name
  SELECT SINGLE name1 INTO v_name FROM kna1 WHERE kunnr = v_custname.

****Selecting Sales order no and item from Production order no.
  SELECT
  aufnr           "Production Order No.
  kdauf           "Sales order no
  kdpos           "Sales Item No
  matnr
  FROM afpo
  INTO (v_prodorder, v_kdauf, v_kdpos, lv_matnr)
  WHERE aufnr = v_prodord.
  ENDSELECT.

*****Conversion for Sales order no.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_kdauf
    IMPORTING
      output = v_kdauf.
*****Conversion for Sales item no.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_kdpos
    IMPORTING
      output = v_kdpos.

  v_salesorder = v_kdauf.
  v_so_item = v_kdpos.
********Reading text at Header level.
***  SELECT SINGLE * FROM stxh CLIENT SPECIFIED
***     WHERE mandt    = sy-mandt
***       AND tdobject = 'VBBK'
***       AND tdname   =  v_salesorder
***       AND tdid     = 'Z999'
***       AND tdspras  = 'E'.
***  IF sy-subrc = 0.
***    CALL FUNCTION 'READ_TEXT'
***      EXPORTING
***        id       = 'Z999'
***        language = 'E'
***        name     = v_salesorder
***        object   = 'VBBK'
***      TABLES
***        lines    = it_line_header.
***    .
***    IF sy-subrc <> 0.
**** MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
****         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
***    ENDIF.
***  ENDIF.

  CONCATENATE v_salesorder v_so_item INTO v_so_item.

*****Reading text at Item level.
  SELECT SINGLE * FROM stxh CLIENT SPECIFIED
     WHERE mandt    = sy-mandt
       AND tdobject = 'VBBP'
       AND tdname   =  v_so_item
       AND tdid     = 'Z888'
       AND tdspras  = 'E'.
  IF sy-subrc = 0.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'Z888'
        language                = 'E'
        name                    = v_so_item
        object                  = 'VBBP'
      TABLES
        lines                   = it_line_item
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.
  ENDIF.

****passing customer name to out_tab------------------------*
  READ TABLE out_tab INDEX 1 .
  out_tab-value = v_name.
  MODIFY out_tab INDEX 1.
****passing Header Text to out_tab--------------------------*

  DATA lv_txname LIKE  thead-tdname.
  lv_txname = lv_matnr.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                  = SY-MANDT
      id                      = 'GRUN'
      language                = 'E'
      name                    = lv_txname
      object                  = 'MATERIAL'
*     ARCHIVE_HANDLE          = 0
*     LOCAL_CAT               = ' '
*   IMPORTING
*     HEADER                  =
*     OLD_LINE_COUNTER        =
    TABLES
      lines                   = it_line_header
    EXCEPTIONS
      id                      = 1
      language                = 2
      name                    = 3
      not_found               = 4
      object                  = 5
      reference_check         = 6
      wrong_access_to_archive = 7
      OTHERS                  = 8.
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.


  "if no header text present then data should be printed for item only w/o leaving spaces.
  LOOP AT it_line_header INTO wa_line_header.
    CONCATENATE v_htext wa_line_header-tdline   INTO v_htext SEPARATED BY space.
  ENDLOOP.
  IF v_htext IS NOT INITIAL.

    IF v_htext IS NOT INITIAL.
      v_htext1 = v_htext+0(80).
      v_htext2 = v_htext+80(80).
*      v_htext3 = v_htext+160(240).
*      v_htext4 = v_htext+240(320).

      IF NOT  v_htext1 IS INITIAL.
        READ TABLE out_tab INDEX 3 .
        out_tab-value = v_htext1. "WA_LINE_HEADER.
        MODIFY out_tab INDEX 3.
      ENDIF.

      IF NOT  v_htext2 IS INITIAL.
        READ TABLE out_tab INDEX 4 .
        out_tab-value = v_htext2. "WA_LINE_HEADER.
        MODIFY out_tab INDEX 4.
      ENDIF.
***
***      IF NOT  v_htext3 IS INITIAL.
***        READ TABLE out_tab INDEX 5 .
***        out_tab-value = v_htext3. "WA_LINE_HEADER.
***        MODIFY out_tab INDEX 5.
***      ENDIF.
***
***      IF NOT  v_htext4 IS INITIAL.
***        READ TABLE out_tab INDEX 6 .
***        out_tab-value = v_htext4. "WA_LINE_HEADER.
***        MODIFY out_tab INDEX 6.
***      ENDIF.
    ENDIF.
*-----------------------------------------------------------*
****passing Item Text to out_tab
    LOOP AT it_line_item INTO wa_line_item.
      CONCATENATE v_itext wa_line_item-tdline   INTO v_itext SEPARATED BY space.
    ENDLOOP.

    IF v_itext IS NOT INITIAL.
      v_itext1 = v_itext+0(70).
      v_itext2 = v_itext+70(150).
      v_itext3 = v_itext+150(230).
      v_itext4 = v_itext+230(310).

      READ TABLE out_tab INDEX 7 . "WA_LINE_item.
      out_tab-value = v_itext1.
      MODIFY out_tab INDEX 7.

      READ TABLE out_tab INDEX 8 .
      out_tab-value = v_itext2.
      MODIFY out_tab INDEX 8.

      READ TABLE out_tab INDEX 9 .
      out_tab-value = v_itext3.
      MODIFY out_tab INDEX 9.

      READ TABLE out_tab INDEX 10 .
      out_tab-value = v_itext4.
      MODIFY out_tab INDEX 10.
    ENDIF.
  ELSE.
****passing Item Text to out_tab
    LOOP AT it_line_item INTO wa_line_item.
      CONCATENATE v_itext wa_line_item-tdline INTO v_itext SEPARATED BY space.
    ENDLOOP.
    IF v_itext IS NOT INITIAL.
      v_itext1 = v_itext+0(70).
      v_itext2 = v_itext+70(150).
      v_itext3 = v_itext+150(230).
      v_itext4 = v_itext+230(310).

      READ TABLE out_tab INDEX 3 . "WA_LINE_item.
      out_tab-value = v_itext1.
      MODIFY out_tab INDEX 3.

      READ TABLE out_tab INDEX 4 .
      out_tab-value = v_itext2.
      MODIFY out_tab INDEX 4.

      READ TABLE out_tab INDEX 5 .
      out_tab-value = v_itext3.
      MODIFY out_tab INDEX 5.

      READ TABLE out_tab INDEX 6 .
      out_tab-value = v_itext4.
      MODIFY out_tab INDEX 6.
    ENDIF.
  ENDIF.

ENDFORM.                    "get_cust_name


FORM change_maktx TABLES  in_tab STRUCTURE itcsy
                   out_tab STRUCTURE itcsy.

  DATA : v_matkx TYPE char40,
         v_matnr TYPE mara-matnr,
         v_stbin TYPE mard-lgpbe,
         v_stloc TYPE mard-lgort,
         v_werks TYPE mard-werks.
  READ TABLE in_tab INDEX 1 .
  v_matkx = in_tab-value .

  READ TABLE in_tab INDEX 2 .
  v_matnr = in_tab-value .

  READ TABLE in_tab INDEX 3 .
  v_stloc = in_tab-value .

  READ TABLE in_tab INDEX 4 .
  v_werks = in_tab-value .


  SELECT SINGLE lgpbe FROM mard INTO v_stbin WHERE matnr = v_matnr AND
    werks = v_werks AND
    lgort = v_stloc.

  CLEAR out_tab-value.

  REPLACE ALL OCCURRENCES OF ',,' IN v_matkx WITH ' '.
  CONDENSE v_matkx.
  READ TABLE out_tab INDEX 1 .
  out_tab-value = v_matkx.
  MODIFY out_tab INDEX 1.

  READ TABLE out_tab INDEX 2 .
  out_tab-value = v_stbin.
  MODIFY out_tab INDEX 2.


ENDFORM.

FORM get_stock TABLES  in_tab STRUCTURE itcsy
                   out_tab STRUCTURE itcsy.

  DATA :
    v_matnr      TYPE mara-matnr,
    v_salesno    TYPE afpo-kdauf,
    v_salesitem  TYPE afpo-kdpos,
    v_plant      TYPE marc-werks,
    v_sbdkz      TYPE marc-sbdkz,
    v_stock      TYPE labst,
    v_stock1(16) TYPE c.

  READ TABLE in_tab INDEX 1 .
  v_matnr = in_tab-value .

  READ TABLE in_tab INDEX 2 .
  v_salesno = in_tab-value .

  READ TABLE in_tab INDEX 3 .
  v_salesitem = in_tab-value .

  READ TABLE in_tab INDEX 4 .
  v_plant = in_tab-value .

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_salesno
    IMPORTING
      output = v_salesno.

  SELECT SINGLE sbdkz FROM marc INTO v_sbdkz WHERE matnr = v_matnr AND
    werks = v_plant.

  IF v_sbdkz = '1'.
    IF v_salesno NE ' '.
      SELECT SINGLE kalab INTO v_stock FROM mska
        WHERE matnr = v_matnr
          AND vbeln = v_salesno
          AND posnr = v_salesitem
          AND werks = v_plant
          AND sobkz = 'E'.
    ELSE.
      SELECT SINGLE labst INTO v_stock FROM mard
       WHERE matnr = v_matnr
         AND werks = v_plant.
*         AND lgort = 'RM01'.
    ENDIF.
  ELSE.
    SELECT SINGLE labst INTO v_stock FROM mard
       WHERE matnr = v_matnr
         AND werks = v_plant.
*         AND lgort = 'RM01'.
  ENDIF.
  CLEAR out_tab-value.

  v_stock1 = v_stock.
  CONDENSE v_stock1.
  READ TABLE out_tab INDEX 1 .
  out_tab-value = v_stock1.
  MODIFY out_tab INDEX 1.



ENDFORM.
