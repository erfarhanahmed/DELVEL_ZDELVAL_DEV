*&---------------------------------------------------------------------*
*& Report ZMAIL_SEND
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmail_send.
DATA: lt_mailrecipients TYPE STANDARD TABLE OF somlrec90 WITH HEADER LINE,
      lt_mailtxt        TYPE STANDARD TABLE OF soli      WITH HEADER LINE,
      lt_attachment     TYPE STANDARD TABLE OF solisti1  WITH HEADER LINE,
      lt_mailsubject    TYPE sodocchgi1,
      lt_packing_list   TYPE STANDARD TABLE OF sopcklsti1 WITH HEADER LINE,
      gv_cnt            TYPE i,
      c_ret             TYPE c VALUE cl_abap_char_utilities=>cr_lf,
      c_tab             TYPE c VALUE cl_abap_char_utilities=>horizontal_tab.

lt_mailrecipients-rec_type  = 'U'.
lt_mailrecipients-com_type  = 'INT'.
lt_mailrecipients-receiver  = 'snehal.rajale@techsoftsoln.in'.
APPEND lt_mailrecipients .
CLEAR lt_mailrecipients .

lt_mailtxt = 'Hi How are you'.      APPEND lt_mailtxt. CLEAR lt_mailtxt.
lt_mailtxt = 'Here is a test mail'. APPEND lt_mailtxt. CLEAR lt_mailtxt.
lt_mailtxt = 'Thanks'.              APPEND lt_mailtxt. CLEAR lt_mailtxt.

DATA: BEGIN OF lt_po_data_cons OCCURS 0,
        ebeln LIKE ekpo-ebeln,
        ebelp LIKE ekpo-ebelp,
      END OF lt_po_data_cons.

SELECT ebeln ebelp INTO TABLE lt_po_data_cons
UP TO 10 ROWS
FROM ekpo.

CLASS cl_abap_char_utilities DEFINITION LOAD.
CONCATENATE 'PO' 'PO Line'
INTO lt_attachment SEPARATED BY c_tab.
APPEND lt_attachment. CLEAR lt_attachment.

LOOP AT lt_po_data_cons.
  CONCATENATE lt_po_data_cons-ebeln lt_po_data_cons-ebelp
  INTO lt_attachment SEPARATED BY
  c_tab.

  CONCATENATE c_ret lt_attachment
  INTO lt_attachment.

  APPEND lt_attachment. CLEAR lt_attachment.
ENDLOOP.

lt_packing_list-transf_bin  = space.
lt_packing_list-head_start  = 1.
lt_packing_list-head_num    = 0.
lt_packing_list-body_start  = 1.
lt_packing_list-body_num    = lines( lt_mailtxt ).
lt_packing_list-doc_type    = 'RAW'.
APPEND lt_packing_list. CLEAR lt_packing_list.

lt_packing_list-transf_bin  = 'X'.
lt_packing_list-head_start  = 1.
lt_packing_list-head_num    = 1.
lt_packing_list-body_start  = 1.
lt_packing_list-body_num    = lines( lt_attachment ).
lt_packing_list-doc_type    = 'XLS'. " You can give RAW incase if you want just a txt file.
lt_packing_list-obj_name    = 'data.xls'.
lt_packing_list-obj_descr   = 'data.xls'.
lt_packing_list-doc_size    = lt_packing_list-body_num * 255.
APPEND lt_packing_list. CLEAR lt_packing_list.

lt_mailsubject-obj_name     = 'MAILATTCH'.
lt_mailsubject-obj_langu    = sy-langu.
lt_mailsubject-obj_descr    = 'You have got mail'.
lt_mailsubject-sensitivty   = 'F'.
gv_cnt = lines( lt_attachment ).
lt_mailsubject-doc_size     = ( gv_cnt - 1 ) * 255 + strlen(
lt_attachment ).


CALL FUNCTION 'SO_NEW_DOCUMENT_ATT_SEND_API1'
  EXPORTING
    document_data              = lt_mailsubject
  TABLES
    packing_list               = lt_packing_list
    contents_bin               = lt_attachment
    contents_txt               = lt_mailtxt
    receivers                  = lt_mailrecipients
  EXCEPTIONS
    too_many_receivers         = 1
    document_not_sent          = 2
    document_type_not_exist    = 3
    operation_no_authorization = 4
    parameter_error            = 5
    x_error                    = 6
    enqueue_error              = 7
    OTHERS                     = 8.
IF sy-subrc EQ 0.
  COMMIT WORK.
  SUBMIT rsconn01 WITH mode = 'INT' AND RETURN.
ENDIF.
