*&---------------------------------------------------------------------*
*& Report ZOFM_MAINTAIN
*&---------------------------------------------------------------------*
*&Program for TMG SELECTION SCREEN
*&Developed By - Snehal Rajale on 07.05.2021.
*&---------------------------------------------------------------------*
REPORT zofm_maintain.

TABLES: zofm_booking,vbak.     "TMG Table

CONSTANTS: c_view TYPE   char30  VALUE 'ZOFM_BOOKING',
           c_u    TYPE   char1   VALUE 'U',
           c_and  TYPE   char3   VALUE 'AND'.

TYPES : BEGIN OF ty_date,
          sign      TYPE c,
          option(2) TYPE c,
          low       TYPE datum,
          high      TYPE datum,
        END OF ty_date.

FIELD-SYMBOLS : <fs_ebeln> TYPE ty_date.

DATA: gt_seltab    TYPE STANDARD TABLE OF vimsellist.

DATA: g_fieldname  TYPE vimsellist-viewfield.

DATA: gt_exclude  TYPE TABLE OF vimexclfun,
      gwa_exclude TYPE vimexclfun.
*********modified by PJ. on 27-07-21
TYPES : BEGIN OF tv_date,
          sign      TYPE c,
          option(2) TYPE c,
          low       TYPE datum,
          high      TYPE datum,
        END OF tv_date.
* DATA: v_date       TYPE TABLE OF tv_date WITH HEADER LINE.
* DATA: v_date     TYPE VBAK-AUDAT.
***********End


SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.  "Selection Scrren for TMG
SELECT-OPTIONS: s_sono   FOR zofm_booking-zsoref,
                s_date   FOR VBAK-AUDAT."sy-datum.
SELECTION-SCREEN END OF BLOCK b1.
*
*SELECT SINGLE AUDAT FROM VBAK INTO v_date WHERE AUDAT = s_date.


LOOP AT s_date ASSIGNING <fs_ebeln>.        "Convert date to dd.mm.yyyy format same as TMG date format.
  CONCATENATE <fs_ebeln>-low+6(2) <fs_ebeln>-low+4(2) <fs_ebeln>-low+0(4) INTO <fs_ebeln>-low.
  CONCATENATE <fs_ebeln>-high+6(2) <fs_ebeln>-high+4(2) <fs_ebeln>-high+0(4) INTO <fs_ebeln>-high." modified by PJ.
ENDLOOP.

g_fieldname = 'ZSOREF'.

CALL FUNCTION 'VIEW_RANGETAB_TO_SELLIST'        "FM For input values
  EXPORTING
    fieldname          = g_fieldname
    append_conjunction = c_and
  TABLES
    sellist            = gt_seltab
    rangetab           = s_sono.

g_fieldname = 'ZREV_DATE'.

*TYPES : BEGIN OF ty_vbak,
*        audat TYPE vbak-audat,
*  END OF ty_vbak.
*
*DATA :lt_vbak TYPE TABLE OF ty_vbak,
*      ls_vbak TYPE ty_vbak.
*
*SELECT audat from vbak INTO TABLE lt_vbak
*  WHERE audat in s_date.



CALL FUNCTION 'VIEW_RANGETAB_TO_SELLIST'
  EXPORTING
    fieldname          = g_fieldname
    append_conjunction = c_and
  TABLES
    sellist            = gt_seltab
    rangetab           = s_date . "s_date. modified by PJ. on 27-07-21


CALL FUNCTION 'VIEW_MAINTENANCE_CALL'     "FM to Call TMG.
  EXPORTING
    action      = c_u
    view_name   = c_view
  TABLES
    dba_sellist = gt_seltab.
.
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
