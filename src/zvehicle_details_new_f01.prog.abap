*&---------------------------------------------------------------------*
*&  Include           ZVEHICAL_DETAILS_NEW_F01
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*   INCLUDE TABLECONTROL_FORMS                                         *
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  USER_OK_TC                                               *
*&---------------------------------------------------------------------*
 form user_ok_tc using    p_tc_name type dynfnam
                          p_table_name
                          p_mark_name
                 changing p_ok      like sy-ucomm.

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
   data: l_ok     type sy-ucomm,
         l_offset type i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

*&SPWIZARD: Table control specific operations                          *
*&SPWIZARD: evaluate TC name and operations                            *
   search p_ok for p_tc_name.
   if sy-subrc <> 0.
     exit.
   endif.
   l_offset = strlen( p_tc_name ) + 1.
   l_ok = p_ok+l_offset.
*&SPWIZARD: execute general and TC specific operations                 *
   case l_ok.
     when 'INSR'.                      "insert row
       perform fcode_insert_row using    p_tc_name
                                         p_table_name.
       clear p_ok.

     when 'DELE'.                      "delete row
       perform fcode_delete_row using    p_tc_name
                                         p_table_name
                                         p_mark_name.
       clear p_ok.

     when 'P--' or                     "top of list
          'P-'  or                     "previous page
          'P+'  or                     "next page
          'P++'.                       "bottom of list
       perform compute_scrolling_in_tc using p_tc_name
                                             l_ok.
       clear p_ok.
*     WHEN 'L--'.                       "total left
*       PERFORM FCODE_TOTAL_LEFT USING P_TC_NAME.
*
*     WHEN 'L-'.                        "column left
*       PERFORM FCODE_COLUMN_LEFT USING P_TC_NAME.
*
*     WHEN 'R+'.                        "column right
*       PERFORM FCODE_COLUMN_RIGHT USING P_TC_NAME.
*
*     WHEN 'R++'.                       "total right
*       PERFORM FCODE_TOTAL_RIGHT USING P_TC_NAME.
*
     when 'MARK'.                      "mark all filled lines
       perform fcode_tc_mark_lines using p_tc_name
                                         p_table_name
                                         p_mark_name   .
       clear p_ok.

     when 'DMRK'.                      "demark all filled lines
       perform fcode_tc_demark_lines using p_tc_name
                                           p_table_name
                                           p_mark_name .
       clear p_ok.

*     WHEN 'SASCEND'   OR
*          'SDESCEND'.                  "sort column
*       PERFORM FCODE_SORT_TC USING P_TC_NAME
*                                   l_ok.

   endcase.
   clear sy-ucomm.
 endform.                              " USER_OK_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_INSERT_ROW                                         *
*&---------------------------------------------------------------------*
 form fcode_insert_row
               using    p_tc_name           type dynfnam
                        p_table_name             .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
   data l_lines_name       like feld-name.
   data l_selline          like sy-stepl.
   data l_lastline         type i.
   data l_line             type i.
   data l_table_name       like feld-name.
   field-symbols <tc>                 type cxtab_control.
   field-symbols <table>              type standard table.
   field-symbols <lines>              type i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

   assign (p_tc_name) to <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
   concatenate p_table_name '[]' into l_table_name. "table body
   assign (l_table_name) to <table>.                "not headerline

*&SPWIZARD: get looplines of TableControl                              *
   concatenate 'G_' p_tc_name '_LINES' into l_lines_name.
   assign (l_lines_name) to <lines>.

*&SPWIZARD: get current line                                           *
   get cursor line l_selline.
   if sy-subrc <> 0.                   " append line to table
     l_selline = <tc>-lines + 1.
*&SPWIZARD: set top line                                               *
     if l_selline > <lines>.
       <tc>-top_line = l_selline - <lines> + 1 .
     else.
       <tc>-top_line = 1.
     endif.
   else.                               " insert line into table
     l_selline = <tc>-top_line + l_selline - 1.
     l_lastline = <tc>-top_line + <lines> - 1.
   endif.
*&SPWIZARD: set new cursor line                                        *
   l_line = l_selline - <tc>-top_line + 1.

*&SPWIZARD: insert initial line                                        *
   insert initial line into <table> index l_selline.
   <tc>-lines = <tc>-lines + 1.
*&SPWIZARD: set cursor                                                 *
   set cursor line l_line.

 endform.                              " FCODE_INSERT_ROW

*&---------------------------------------------------------------------*
*&      Form  FCODE_DELETE_ROW                                         *
*&---------------------------------------------------------------------*
 form fcode_delete_row
               using    p_tc_name           type dynfnam
                        p_table_name
                        p_mark_name   .

*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
   data l_table_name       like feld-name.

   field-symbols <tc>         type cxtab_control.
   field-symbols <table>      type standard table.
   field-symbols <wa>.
   field-symbols <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

   assign (p_tc_name) to <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
   concatenate p_table_name '[]' into l_table_name. "table body
   assign (l_table_name) to <table>.                "not headerline

*&SPWIZARD: delete marked lines                                        *
   describe table <table> lines <tc>-lines.

   loop at <table> assigning <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
     assign component p_mark_name of structure <wa> to <mark_field>.

     if <mark_field> = 'X'.
       delete <table> index syst-tabix.
       if sy-subrc = 0.
         <tc>-lines = <tc>-lines - 1.



       endif.
     endif.
   endloop.

 endform.                              " FCODE_DELETE_ROW

*&---------------------------------------------------------------------*
*&      Form  COMPUTE_SCROLLING_IN_TC
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*      -->P_OK       ok code
*----------------------------------------------------------------------*
 form compute_scrolling_in_tc using    p_tc_name
                                       p_ok.
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
   data l_tc_new_top_line     type i.
   data l_tc_name             like feld-name.
   data l_tc_lines_name       like feld-name.
   data l_tc_field_name       like feld-name.

   field-symbols <tc>         type cxtab_control.
   field-symbols <lines>      type i.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

   assign (p_tc_name) to <tc>.
*&SPWIZARD: get looplines of TableControl                              *
   concatenate 'G_' p_tc_name '_LINES' into l_tc_lines_name.
   assign (l_tc_lines_name) to <lines>.


*&SPWIZARD: is no line filled?                                         *
   if <tc>-lines = 0.
*&SPWIZARD: yes, ...                                                   *
     l_tc_new_top_line = 1.
   else.
*&SPWIZARD: no, ...                                                    *
     call function 'SCROLLING_IN_TABLE'
       exporting
         entry_act      = <tc>-top_line
         entry_from     = 1
         entry_to       = <tc>-lines
         last_page_full = 'X'
         loops          = <lines>
         ok_code        = p_ok
         overlapping    = 'X'
       importing
         entry_new      = l_tc_new_top_line
       exceptions
*        NO_ENTRY_OR_PAGE_ACT  = 01
*        NO_ENTRY_TO    = 02
*        NO_OK_CODE_OR_PAGE_GO = 03
         others         = 0.
   endif.

*&SPWIZARD: get actual tc and column                                   *
   get cursor field l_tc_field_name
              area  l_tc_name.

   if syst-subrc = 0.
     if l_tc_name = p_tc_name.
*&SPWIZARD: et actual column                                           *
       set cursor field l_tc_field_name line 1.
     endif.
   endif.

*&SPWIZARD: set the new top line                                       *
   <tc>-top_line = l_tc_new_top_line.


 endform.                              " COMPUTE_SCROLLING_IN_TC

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_MARK_LINES
*&---------------------------------------------------------------------*
*       marks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
 form fcode_tc_mark_lines using p_tc_name
                                p_table_name
                                p_mark_name.
*&SPWIZARD: EGIN OF LOCAL DATA-----------------------------------------*
   data l_table_name       like feld-name.

   field-symbols <tc>         type cxtab_control.
   field-symbols <table>      type standard table.
   field-symbols <wa>.
   field-symbols <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

   assign (p_tc_name) to <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
   concatenate p_table_name '[]' into l_table_name. "table body
   assign (l_table_name) to <table>.                "not headerline

*&SPWIZARD: mark all filled lines                                      *
   loop at <table> assigning <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
     assign component p_mark_name of structure <wa> to <mark_field>.

     <mark_field> = 'X'.
   endloop.
 endform.                                          "fcode_tc_mark_lines

*&---------------------------------------------------------------------*
*&      Form  FCODE_TC_DEMARK_LINES
*&---------------------------------------------------------------------*
*       demarks all TableControl lines
*----------------------------------------------------------------------*
*      -->P_TC_NAME  name of tablecontrol
*----------------------------------------------------------------------*
 form fcode_tc_demark_lines using p_tc_name
                                  p_table_name
                                  p_mark_name .
*&SPWIZARD: BEGIN OF LOCAL DATA----------------------------------------*
   data l_table_name       like feld-name.

   field-symbols <tc>         type cxtab_control.
   field-symbols <table>      type standard table.
   field-symbols <wa>.
   field-symbols <mark_field>.
*&SPWIZARD: END OF LOCAL DATA------------------------------------------*

   assign (p_tc_name) to <tc>.

*&SPWIZARD: get the table, which belongs to the tc                     *
   concatenate p_table_name '[]' into l_table_name. "table body
   assign (l_table_name) to <table>.                "not headerline

*&SPWIZARD: demark all filled lines                                    *
   loop at <table> assigning <wa>.

*&SPWIZARD: access to the component 'FLAG' of the table header         *
     assign component p_mark_name of structure <wa> to <mark_field>.

     <mark_field> = space.
   endloop.
 endform.                                          "fcode_tc_mark_lines
