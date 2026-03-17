*&---------------------------------------------------------------------*
*&  Include           ZJ_1IG_SUB_DATA_DECL
*&---------------------------------------------------------------------*

TABLES: t001w,
        lfa1,
        mkpf,
        j_1ig_sub_inv.

TYPES: BEGIN OF ty_matdoc,
         mblnr TYPE mblnr,
         mjahr TYPE mjahr,
         zeile TYPE mblpo,
         chln  TYPE vbeln_vf,
         budat TYPE budat,
         werks TYPE werks_d,
         menge TYPE menge_d,
         meins TYPE meins,
         bwart TYPE bwart,
         matnr TYPE matnr,
         emlif TYPE emlif,                       " 2528484
         sobkz TYPE sobkz,
       END OF ty_matdoc.

TYPES: BEGIN OF ty_grxsub,
         box.
    INCLUDE STRUCTURE j_1ig_subcon.
TYPES: END OF ty_grxsub.

DATA: wa_matdoc     TYPE ty_matdoc,
      wa_canc       TYPE mseg,
      wa_t001w      TYPE t001w,
      wa_vbsk       TYPE vbsk,
      wa_lfa1       TYPE lfa1,
      wa_grxsub     TYPE ty_grxsub,
      wa_mvmt       TYPE j_1ig_subcon_mvmt,
      wa_grxsub_upd TYPE j_1ig_subcon,
      wa_layout     TYPE slis_layout_alv,
      wa_keyinfo    TYPE slis_keyinfo_alv.


DATA: it_matdoc     TYPE STANDARD TABLE OF ty_matdoc,
      it_canc       TYPE STANDARD TABLE OF mseg,
      it_lfa1       TYPE STANDARD TABLE OF lfa1,
      it_t001w      TYPE STANDARD TABLE OF t001w,
      it_grxsub     TYPE STANDARD TABLE OF ty_grxsub,
      it_mvmt       TYPE J_1IG_TT_SUB_MVMT,  "STANDARD TABLE OF j_1ig_subcon_mvmt,
      it_grxsub_upd TYPE STANDARD TABLE OF j_1ig_subcon,
      it_komv       TYPE STANDARD TABLE OF komv,
      it_log_handle TYPE bal_t_logh,
      it_fieldcat   TYPE STANDARD TABLE OF slis_fieldcat_alv.

DATA: gv_country    TYPE land1,
      gv_err        TYPE c,
      gv_matnr      TYPE matnr,
      gv_fkart      TYPE fkart,
      gv_tab_header TYPE slis_tabname VALUE 'IT_LFA1',
      gv_tab_item   TYPE slis_tabname VALUE 'IT_GRXSUB',
      gv_box        TYPE slis_fieldname VALUE 'BOX',
      gv_log_handle TYPE balloghndl,
      gv_badi       TYPE REF TO badi_j_1ig_subcon.
