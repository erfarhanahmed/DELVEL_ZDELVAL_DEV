*&---------------------------------------------------------------------*
*& Report ZAP_CHANGE_SALES_ORDER_VA02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zso_target_mrpdate_va02.
type-pools : slis.
types : begin of ty_final,
          salesdocno type  bapivbeln-vbeln,             " Sales Document no
          item_no    type  bapisditm-itm_number,"bapischdl-itm_number,        " Item No
          mrp_date type  zvbap-zmrp_date,          " First date
        end of ty_final.
data : it_final type table of ty_final,
       wa_final type ty_final.

*types : begin of header,
*          sales_org  type  bapisdh1-sales_org,         " Sales Organisation
*          distr_chan type  bapisdh1-distr_chan,         " Distribution channel
*          division   type  bapisdh1-division,         " Division
*        end of header.
types : begin of sch_item,
          item_no    type bapischdl-itm_number,       " Item No
          sch_no     type bapischdl-sched_line,         " Schedule line no
          first_date type bapischdl-req_date,         " First date
        end of sch_item.
data : wa_header   type header,
       it_sch_item type table of sch_item,
       wa_sch_item type sch_item.
types : begin of ty_item,
          salesdocno type vbeln,
          itm_number type bapischdl-itm_number,
          sched_line type bapischdl-sched_line,
*          req_date   TYPE bapischdl-req_date,
            mrp_date type  zvbap-zmrp_date,
        end of ty_item.
data : it_item type table of ty_item,
       wa_item type ty_item.

data : raw_data(4096) type c occurs 0.
data : salesdocument   type bapivbeln-vbeln,       " Sales Document no
       wa_header_data  type bapisdh1,              " Work area for header data
       wa_header_datax type bapisdh1x,             " Work area for update structure
       it_sch_line     type table of bapischdl,    " Internal table for schedule line data
       wa_sch_line     type bapischdl,             " Work area for schedule line data
       it_sch_linex    type table of bapischdlx,   " Internal table for schedule line data update structure
       wa_sch_linex    type  bapischdlx,           " Work area for schedule line data update structure
       it_order_item type TABLE OF BAPISDITM,
       wa_order_item type BAPISDITM,
       return          like bapiret2  occurs 0 with header line.
*--------------Output table-------------------
types : begin of ty_output,
        so_no type ebeln,
        msg(150) type c,
  end of ty_output.

data : it_output type table of ty_output,
       wa_output type ty_output,
       it_fcat type  slis_t_fieldcat_alv,
       wa_fcat type  slis_fieldcat_alv.

data: t_exten like bapiparex occurs 0 with header line.
data: t_extenx like bapiparex occurs 0 with header line.

data: mrp_date like zvbap-zmrp_date.
data: bape_vbap like bape_vbap.

data: bape_vbapx like bape_vbapx.
*--------------------------------------------------------------------*
selection-screen : begin of block b1 with frame.
parameters : file type rlgrap-filename.
selection-screen : end of block b1.
selection-screen : pushbutton 2(20) but1 user-command cmd.
at selection-screen.

  if sy-ucomm = 'CMD'.
    perform download_excel.
    endif.
at selection-screen on value-request for file.
  call function 'F4_FILENAME'
    exporting
      program_name = syst-cprog
    importing
      file_name    = file.
  if sy-subrc <> 0.
    message 'File format does not support...' type 'E'.
  endif.
initialization.
but1 = 'Download Excel'.
start-of-selection.

  call function 'TEXT_CONVERT_XLS_TO_SAP'
    exporting
      i_line_header        = 'X'
      i_tab_raw_data       = raw_data
      i_filename           = file
    tables
      i_tab_converted_data = it_final[]
    exceptions
      conversion_failed    = 1
      others               = 2.
  if sy-subrc <> 0.
    message 'Problem occurs during convertion data' type 'E'.
  endif.
*  BREAK primus.
*----------------Differentiate item data from header----------------
  loop at it_final into wa_final.
    move wa_final-salesdocno to wa_item-salesdocno.
    move wa_final-item_no    to wa_item-itm_number.
    move wa_final-mrp_date to wa_item-mrp_date.
    append wa_item to it_item.
    clear wa_item.
  endloop.
*--------------------------------------------------------------------*
  loop at it_final into wa_final.
*--------------Header data--------------------------------------------

    call function 'CONVERSION_EXIT_ALPHA_INPUT'
      exporting
        input  = wa_final-salesdocno
      importing
        output = salesdocument.
*
    select single * from vbak into @data(wa_vbak)
      where vbeln = @salesdocument.
**********************************************************************

    move wa_vbak-vkorg  to  wa_header_data-sales_org.
.
    move wa_vbak-vtweg to  wa_header_data-distr_chan.
*
    move wa_vbak-spart   to  wa_header_data-division.
*
    move 'U'                 to  wa_header_datax-updateflag.
    move wa_vbak-vkorg  to  wa_header_datax-sales_org.
    move wa_vbak-vtweg to  wa_header_datax-distr_chan.
    move wa_vbak-spart   to  wa_header_datax-division.
*--------------------------------------------------------------------*
*--------------mrp date  data--------------------------------------
*break-point.
    loop at it_item into wa_item where salesdocno = wa_final-salesdocno
                                      and itm_number = wa_final-item_no.
*

      bape_vbap-zmrp_Date = wa_item-mrp_date .
     move wa_item-salesdocno  to bape_vbap-vbeln.
     move wa_item-itm_number  to bape_vbap-posnr .
     t_exten-structure = 'BAPE_VBAP'..
       t_exten-valuepart1 = bape_vbap.
     t_exten+30 = bape_vbap.
     append t_exten.

     bape_vbapx-zmrp_Date = 'X' .
     move wa_item-salesdocno to bape_vbapx-vbeln .
    bape_vbapx-posnr =  wa_item-itm_number.
    t_exten-structure = 'BAPE_VBAPX'.
     t_exten-valuepart1 = bape_vbapx.
    t_exten+30 = bape_vbapx.
*     append t_extenx.
     append t_exten.
    endloop.


   call function 'BAPI_SALESORDER_CHANGE'
  exporting
    salesdocument               = salesdocument
   order_header_in              = wa_header_data
    order_header_inx            = wa_header_datax
*   SIMULATION                  =
*   BEHAVE_WHEN_ERROR           = ' '
*   INT_NUMBER_ASSIGNMENT       = ' '
*   LOGIC_SWITCH                =
*   NO_STATUS_BUF_INIT          = ' '
  tables
    return                      = return[]
*   ORDER_ITEM_IN               =
*   ORDER_ITEM_INX              =
*   PARTNERS                    =
*   PARTNERCHANGES              =
*   PARTNERADDRESSES            =
*   ORDER_CFGS_REF              =
*   ORDER_CFGS_INST             =
*   ORDER_CFGS_PART_OF          =
*   ORDER_CFGS_VALUE            =
*   ORDER_CFGS_BLOB             =
*   ORDER_CFGS_VK               =
*   ORDER_CFGS_REFINST          =
*   SCHEDULE_LINES              =  it_sch_line
*   SCHEDULE_LINESX             =  it_sch_linex
*   ORDER_TEXT                  =
*   ORDER_KEYS                  =
*   CONDITIONS_IN               =
*   CONDITIONS_INX              =
   extensionin                 = t_exten
   EXTENSIONEX                 = T_EXTENX
          .


*BREAK primus.
  delete return[] where number <> '311'.
  read table return index 1.
  if return-type = 'S'.
    call function 'BAPI_TRANSACTION_COMMIT'
      exporting
        wait = 'X'.

     UPDATE vbap SET zmrp_date = wa_final-mrp_date
      WHERE vbeln = salesdocument
            and posnr =  wa_final-item_no  .
    WAIT UP TO  1 SECONDS.

    wa_output-msg = return-message.
    append wa_output to it_output.
    clear wa_output.
    endif.
    if sy-subrc = 0.
      clear : salesdocument, wa_header_data, wa_header_datax, it_sch_line, it_sch_linex, wa_final.
    endif.
*endif.
clear :  return-type .
  endloop.
  wa_fcat-col_pos = '1'.
  wa_fcat-seltext_m = 'Message'.
  wa_fcat-tabname = 'IT_OUTPUT'.
  wa_fcat-fieldname = 'MSG'.
  append wa_fcat to it_fcat.
  clear wa_fcat.
*  BREAK primus.
  call function 'REUSE_ALV_GRID_DISPLAY'
   exporting
     i_callback_program                = sy-repid
*     I_STRUCTURE_NAME                  = 'BAPIRET2'
*     I_DEFAULT                         = 'X'
     i_save                            = 'X'
     it_fieldcat                       = it_fcat[]
    tables
      t_outtab                          = it_output[]
   exceptions
     program_error                     = 1
     others                            = 2.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD_EXCEL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
form download_excel .
type-pools ole2 .

  data: application type ole2_object,
        workbook    type ole2_object,
        sheet       type ole2_object,
        cells       type ole2_object,
        cell1       type ole2_object,
        cell2       type ole2_object,
        range       type ole2_object,
        font        type ole2_object,
        column      type ole2_object,
        shading     type ole2_object,
        border      type ole2_object.

  constants: row_max type i value 256.
  data: index type i.
  data: ld_colindx type i,   "COLUMN INDEX
        ld_rowindx type i.   "ROW INDEX

  types:begin of t_data,
          field1  type string,
          field2  type string,
          field3  type string,
          field4  type string,
          field5  type string,
          field7  type string,
        end of t_data.

  data: it_data type standard table of t_data,
        ls_data like line of it_data.

  field-symbols: <fs>.

*&---------------------------------------------------------------------*
*&      Form  FILL_DATA
*&---------------------------------------------------------------------*

  ls_data-field1 =  'Sales Order No'.
*  ls_data-field2 =  'Sales Org'.
*  ls_data-field3 =  'Dist Channel'.
*  ls_data-field4 =  'Division'.
  ls_data-field2 =  'Item No'.
*  ls_data-field6 =  'Schedule Line No'.
  ls_data-field3 = 'MRP Date'.
  append ls_data to it_data.

  create object application 'EXCEL.APPLICATION'.
  set property of application 'VISIBLE' = 1.
  call method of
  application
  'WORKBOOKS' = workbook.

* CREATE NEW WORKSHEET
  set property of application 'SHEETSINNEWWORKBOOK' = 1.
  call method of
  workbook
  'ADD'.

* CREATE FIRST EXCEL SHEET
  call method of
  application
  'WORKSHEETS' = sheet
  exporting
    #1 = 1.
  call method of
  sheet
  'ACTIVATE'.
  set property of sheet 'NAME' = 'Sales Order Change'.

  " FILL_DATA
*&---------------------------------------------------------------------*
*&   DOWNLOAD COLUMN NUMBERS DATA TO EXCEL SPREADSHEET
*&---------------------------------------------------------------------*

  ld_rowindx = 1. "START AT ROW 1 FOR COLUMN NUMBERS
    loop at it_data into ls_data.
      ld_rowindx = sy-tabix . "START AT ROW 3 (LEAVE 1ST FOR FOR COLUMN NUMBER , 2ND FOR HEADING & 3RD FOR SUB-HEADING

*   FILL COLUMNS FOR CURRENT ROW
      clear ld_colindx.
      do.
        assign component sy-index of structure ls_data to <fs>.
        if sy-subrc ne 0.
          exit.
        endif.
        ld_colindx = sy-index.
        call method of
        sheet
        'CELLS' = cells
        exporting
          #1 = ld_rowindx
          #2 = ld_colindx.
        set property of cells 'VALUE' = <fs>.
      enddo.
    endloop.

    " DOWNLOAD_DATA
*&---------------------------------------------------------------------*
*&  FORMATTING OF COLUMN NUMBER ROW
*&---------------------------------------------------------------------*

    call method of
    application
    'CELLS' = cell1
    exporting
      #1 = 1     "DOWN
      #2 = 1.    "ACROSS

*END OF RANGE CELL
      call method of
      application
      'CELLS' = cell2
      exporting
        #1 = 1     "DOWN
        #2 = 3.   "COLUMN ACROSS

      call method of
      application
      'RANGE' = range
      exporting
        #1 = cell1
        #2 = cell2.

* SET FONT DETAILS OF RANGE

      get property of range 'FONT' = font.
      set property of font 'SIZE' = 12.

* SET CELL SHADING PROPERTIES OF RANGE
      call method of
      range
      'INTERIOR' = shading.
      set property of shading 'COLORINDEX' = 6. " COLOUR - CHANGE NUMBER FOR DIFF COLOURS
      set property of shading 'PATTERN' = 1.    " PATTERN - SOLID, STRIPED ETC
      free object shading.

      "END OF FORMATTING OF COLUMN NUMBER ROW

*&*--------------------------------------------------------------------*
*&*  MODIFY PROPERTIES OF CELL RANGE
*&*--------------------------------------------------------------------*

      free range.
      call method of application 'CELLS' = cell1  "START CELL
      exporting
        #1 = 1     "DOWN
        #2 = 1.    "ACROSS

      call method of application 'CELLS' = cell2 "END CELL
      exporting
        #1 = 1    "DOWN
        #2 = 3.   "COLUMNS ACROSS

      call method of
      application
      'RANGE' = range
      exporting
        #1 = cell1
        #2 = cell2.


* SET BORDER PROPERTIES OF RANGE
      call method of
      range
      'BORDERS' = border
      exporting
        #1 = '1'.  "LEFT
      set property of border 'LINESTYLE' = '1'. "LINE STYLE SOLID, DASHED...
      set property of border 'WEIGHT' = 1.                      "MAX = 4
      free object border.

      call method of
      range
      'BORDERS' = border
      exporting
        #1 = '2'.  "RIGHT
      set property of border 'LINESTYLE' = '1'.
      set property of border 'WEIGHT' = 2.                      "MAX = 4
      free object border.

      call method of
      range
      'BORDERS' = border
      exporting
        #1 = '3'.   "TOP
      set property of border 'LINESTYLE' = '1'.
      set property of border 'WEIGHT' = 2.                      "MAX = 4
      free object border.

      call method of
      range
      'BORDERS' = border
      exporting
        #1 = '4'.   "BOTTOM
      set property of border 'LINESTYLE' = '1'.
      set property of border 'WEIGHT' = 2.                      "MAX = 4
      free object border.

      " SET COLUMNS TO AUTO FIT TO WIDTH OF TEXT    *

      call method of application
      'COLUMNS' = column.
      call method of column
      'AUTOFIT'.
      free object column.

      " SAVE EXCEL SPEADSHEET TO PARTICULAR FILENAME

      call method of
      sheet'SAVEAS'
      exporting
        #1 = 'C:\VA02.xls'     "FILENAME
        #2 = 1.                "FILEFORMAT

      free object sheet.
      free object workbook.
      free object application.

      " CELL_BORDER

endform.
