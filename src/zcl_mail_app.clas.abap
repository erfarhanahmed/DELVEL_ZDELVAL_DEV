class ZCL_MAIL_APP definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_tab_attr ,
    border      TYPE string,
    align       TYPE string,
    bgcolor     TYPE string,
    cellpadding TYPE string,
    cellspacing TYPE string,
    width       TYPE string,
    height      TYPE string,
    bordercolor TYPE string,
  END OF ty_tab_attr .
  types:
    BEGIN OF ty_col_attr,
    col_no  TYPE I,
    colspan TYPE string,
    rowspan TYPE string,
    align   TYPE string,
  END OF ty_col_attr .
  types:
    TT_COL_ATTR TYPE TABLE OF ty_col_attr .
  types:
    BEGIN OF ty_row_attr,
    row_no TYPE I,
    align   TYPE string,
    bgcolor TYPE string,
    valign  TYPE string,
  END OF ty_row_attr .
  types:
    TT_row_ATTR TYPE TABLE OF ty_row_attr .
  types:
    BEGIN OF ty_rec,
    email_id TYPE ad_smtpadr,
*          to TYPE boolean,
*    cc       TYPE boolean,
*    bcc      YPE boolean,
*    zto TYPE ad_smtpadr,
*    ZOFFICE TYPE char50,
  END OF ty_rec .
  types:
    tt_rec TYPE TABLE OF ty_rec .

  class-data A_LEFT type STRING value 'LEFT' ##NO_TEXT.
  class-data A_CENTER type STRING value 'CENTER' ##NO_TEXT.
  class-data A_RIGHT type STRING value 'RIGHT' ##NO_TEXT.
  class-data A_JUSTIFY type STRING value 'JUSTIFY' ##NO_TEXT.
  class-data A_BASELINE type STRING value 'BASELINE' ##NO_TEXT.
  class-data A_BOTTOM type STRING value 'BOTTOM' ##NO_TEXT.
  class-data A_MIDDLE type STRING value 'MIDDLE' ##NO_TEXT.
  class-data A_TOP type STRING value 'TOP' ##NO_TEXT.
  class-data C_GREEN type STRING value 'GREEN' ##NO_TEXT.
  class-data C_YELLOW type STRING value 'YELLOW' ##NO_TEXT.

  methods ADD_BODY_MSG
    importing
      !IM_T_MESSAGE type BCSY_TEXT
    changing
      !CH_T_BODY type BCSY_TEXT .
  methods ADD_HTML_TABLE
    importing
      !IM_T_HEADINGS type BCSY_TEXT
      !IM_T_DATA type ANY TABLE
      !IM_S_TAB_ATTR type TY_TAB_ATTR optional
      !IM_T_COL_ATTR type TT_COL_ATTR optional
      !IM_T_ROW_ATTR type TT_ROW_ATTR optional
    changing
      !CH_T_BODY type BCSY_TEXT .
  methods SEND_MAIL
    importing
      !IM_T_RECEIVERS type TT_REC
      !IM_SUBJECT type SO_OBJ_DES
      !IM_T_BODY type BCSY_TEXT optional
      !IM_T_ATTACH_HEX type SOLIX_TAB optional
      !IM_ATT_TYPE type SOODK-OBJTP optional
      !IM_ATT_SUBJ type SO_OBJ_DES optional
      !IM_T_ATTACH_TEXT type SOLI_TAB optional .
  methods CREATE_ATTACHMENT
    importing
      !IM_T_HEADINGS type BCSY_TEXT optional
      !IM_T_DATA type ANY TABLE
      !IM_V_PDF type FPCONTENT optional
    exporting
      !EX_T_SOLIX type SOLIX_TAB .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MAIL_APP IMPLEMENTATION.


  method ADD_BODY_MSG.
  endmethod.


  method ADD_HTML_TABLE.

  endmethod.


  method CREATE_ATTACHMENT.

  endmethod.


  method SEND_MAIL.

  endmethod.
ENDCLASS.
