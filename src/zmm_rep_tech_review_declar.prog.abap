*&---------------------------------------------------------------------*
*&  Include           ZMM_REP_TECH_REVIEW_DECLAR
*&---------------------------------------------------------------------*
tables: ztech_review,
        zcomm_review.

CONSTANTS: line_length TYPE i VALUE 132.
DATA:
*   reference to wrapper class of control
  g_editor1 TYPE REF TO cl_gui_textedit,
  g_editor2 TYPE REF TO cl_gui_textedit,
  g_editor3 TYPE REF TO cl_gui_textedit,
  g_editor4 TYPE REF TO cl_gui_textedit,
  g_editor5 TYPE REF TO cl_gui_textedit,
  g_editor6 TYPE REF TO cl_gui_textedit,
  g_editor7 TYPE REF TO cl_gui_textedit,
  g_editor8 TYPE REF TO cl_gui_textedit,
  g_editor3r TYPE REF TO cl_gui_textedit,
  g_editor4r TYPE REF TO cl_gui_textedit,
  g_editor5r TYPE REF TO cl_gui_textedit,
  g_editor6r TYPE REF TO cl_gui_textedit,
  g_editor7r TYPE REF TO cl_gui_textedit,
  g_editor8r TYPE REF TO cl_gui_textedit,

*   reference to custom container: necessary to bind TextEdit Control
  g_editor_container TYPE REF TO cl_gui_custom_container,
  g_editor_container1 TYPE REF TO cl_gui_custom_container,
  g_editor_container2 TYPE REF TO cl_gui_custom_container,
  g_editor_container3 TYPE REF TO cl_gui_custom_container,


  g_repid LIKE sy-repid,
  g_ok_code LIKE sy-ucomm,       " return code from screen
  g_relink TYPE c,               " to manage relinking
  g_mytable(line_length) TYPE c OCCURS 0,
  g_mytable1(line_length) TYPE c OCCURS 0,
  g_mytable2(line_length) TYPE c OCCURS 0,
  g_mytable3(line_length) TYPE c OCCURS 0,
  g_mytable4(line_length) TYPE c OCCURS 0,
  g_mytable5(line_length) TYPE c OCCURS 0,
  g_mytable6(line_length) TYPE c OCCURS 0,
  g_mytable7(line_length) TYPE c OCCURS 0,
  g_mytable8(line_length) TYPE c OCCURS 0,
  g_mytable3r(line_length) TYPE c OCCURS 0,
  g_mytable4r(line_length) TYPE c OCCURS 0,
  g_mytable5r(line_length) TYPE c OCCURS 0,
  g_mytable6r(line_length) TYPE c OCCURS 0,
  g_mytable7r(line_length) TYPE c OCCURS 0,
  g_mytable8r(line_length) TYPE c OCCURS 0,

  g_mycontainer(30) TYPE c,      " string for the containers
  g_container_linked TYPE i,                                "#EC NEEDED
  wa_ztech_review like ztech_review,
  wa_mytable(132). " like g_mytable.
" container to which control is linked

* necessary to flush the automation queue
CLASS cl_gui_cfw DEFINITION LOAD.

DATA: fcode TYPE TABLE OF sy-ucomm,
   SO LIKE VBAK-VBELN,
   fcode1 TYPE TABLE OF sy-ucomm,
   fcode2 TYPE TABLE OF sy-ucomm,
   fcode3 TYPE TABLE OF sy-ucomm,
   fcode4 TYPE TABLE OF sy-ucomm.
data : it_ztech TYPE STANDARD TABLE OF ztech_review WITH HEADER LINE.
data : it_zcomm TYPE STANDARD TABLE OF zcomm_review WITH HEADER LINE.


data : it_line_1 like TLINE OCCURS 0 WITH HEADER LINE,
    fname1 like THEAD-TDNAME.

data : fname like THEAD-TDNAME ,
       it_line like TLINE OCCURS 0 WITH HEADER LINE.

  data : lt_ztech_review TYPE STANDARD TABLE OF ztech_review WITH HEADER LINE.
  data : lt_zcomm_review TYPE STANDARD TABLE OF zcomm_review WITH HEADER LINE.
