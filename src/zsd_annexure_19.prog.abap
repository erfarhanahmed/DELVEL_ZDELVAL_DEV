*&---------------------------------------------------------------------*
*& Report  ZSD_ANNEXURE_19
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*                          PROGRAM DETAILS                             *
*----------------------------------------------------------------------*
* PROGRAM NAME         : ZSD_ANNEXURE_19                               *
* TITLE                :                                               *
* CREATED BY           : KANKIT                                        *
* STARTED ON           : 07 July 2011                                  *
* TRANSACTION CODE     : ZSDSAREG                                      *
* DESCRIPTION          : Annexure 19 Report                            *
*----------------------------------------------------------------------*


REPORT  zsd_annexure_19 NO STANDARD PAGE HEADING
                        MESSAGE-ID zdel
                        LINE-SIZE 256.

*=============================================================================================*
*=============================================================================================*
TYPES : BEGIN OF ty_chdr,
          trntyp          TYPE j_1iexchdr-trntyp,
          docyr           TYPE j_1iexchdr-docyr,
          docno           TYPE j_1iexchdr-docno,
          werks           TYPE j_1iexchdr-werks,
          exnum           TYPE j_1iexchdr-exnum,
          bondno          TYPE j_1iexchdr-bondno,
          exdat           TYPE j_1iexchdr-exdat,
          budat           TYPE j_1iexchdr-budat,
          amended_balance TYPE j_1iexchdr-amended_balance,
        END OF ty_chdr,
*=============================================================================================*
*=============================================================================================*
        BEGIN OF ty_t001w,
          werks TYPE t001w-werks,
          adrnr TYPE t001w-adrnr,
        END OF ty_t001w,
*=============================================================================================*
*=============================================================================================*
        BEGIN OF ty_j_1imocomp,
          werks    TYPE j_1imocomp-werks,
          j_1iexcd TYPE j_1imocomp-j_1iexcd,
        END OF ty_j_1imocomp,
*=============================================================================================*
*=============================================================================================*
        BEGIN OF ty_t247,
          spras TYPE t247-spras,
          mnr   TYPE t247-mnr,
          ktx   TYPE t247-ktx,
        END OF ty_t247,
*=============================================================================================*
*=============================================================================================*
        BEGIN OF ty_adrc,
          addrnumber TYPE adrc-addrnumber,
          name1      TYPE adrc-name1,
          city1      TYPE adrc-city1,
          post_code1 TYPE adrc-post_code1,
          street     TYPE adrc-street,
          str_suppl1 TYPE adrc-str_suppl1,
          str_suppl2 TYPE adrc-str_suppl2,
        END OF  ty_adrc,
*=============================================================================================*
*=============================================================================================*
        BEGIN OF ty_j_1ibond,
          bondyr    TYPE j_1ibond-bondyr,
          bondno    TYPE j_1ibond-bondno,
          bondtyp   TYPE j_1ibond-bondtyp,
          werks     TYPE j_1ibond-plant,
          bondnoex  TYPE j_1ibond-bondnoex,
          budat     TYPE j_1ibond-budat,
          bondexpdt TYPE j_1ibond-bondexpdt,
        END OF ty_j_1ibond,
*=============================================================================================*
*=============================================================================================*
        BEGIN OF ty_final,
          sr_no           TYPE i,
          exnum           TYPE j_1iexchdr-exnum,
          budat           TYPE j_1iexchdr-budat,
          amended_balance TYPE j_1iexchdr-amended_balance,
          debit           TYPE string,
          entry_no        TYPE string,
          prf_of_exp      TYPE string,
          details         TYPE string,
        END OF ty_final.
*=============================================================================================*
*=============================================================================================*
DATA : it_chdr       TYPE STANDARD TABLE OF ty_chdr,
       wa_chdr       TYPE ty_chdr,

       it_t001w      TYPE STANDARD TABLE OF ty_t001w,
       wa_t001w      TYPE ty_t001w,

       it_j_1imocomp TYPE STANDARD TABLE OF ty_j_1imocomp,
       wa_j_1imocomp TYPE ty_j_1imocomp,

       it_t247       TYPE STANDARD TABLE OF ty_t247,
       wa_t247       TYPE ty_t247,

       it_adrc       TYPE STANDARD TABLE OF ty_adrc,
       wa_adrc       TYPE ty_adrc,

       it_j_1ibond   TYPE STANDARD TABLE OF ty_j_1ibond,
       wa_j_1ibond   TYPE ty_j_1ibond,

       it_final      TYPE STANDARD TABLE OF ty_final,
       wa_final      TYPE ty_final.

*=============================================================================================*
*=============================================================================================*

DATA: lc_msg       TYPE REF TO   cx_salv_msg,
      alv_obj      TYPE REF TO   cl_salv_table,
      lyot_txt     TYPE REF TO   cl_salv_form_layout_grid,
      lyot_lbl     TYPE REF TO   cl_salv_form_label,
      lyot_flow    TYPE REF TO   cl_salv_form_layout_flow,
      lyot_func    TYPE REF TO   cl_salv_functions,
      lyot_disp    TYPE REF TO   cl_salv_display_settings,
      lyot_columns TYPE REF TO   cl_salv_columns_table,
      lyot_column  TYPE REF TO   cl_salv_column_table,
      lyot_add     TYPE REF TO   cl_salv_aggregations,
      lyot_lout    TYPE REF TO   cl_salv_layout,
      lyot_key     TYPE          salv_s_layout_key,
      txt          TYPE          string,
      v_datelow    TYPE          char10,
      v_datehigh   TYPE          char10,
      var_i        TYPE          i VALUE '1',
      sr_no(3)     TYPE          c VALUE '1'.

*=============================================================================================*
*=============================================================================================*

DATA : c_val   TYPE sy-datum,
       lv_dat1 TYPE char10, "SY-DATUM,
       lv_dat2 TYPE char10, "SY-DATUM,
       b_dat   TYPE sy-datum,
       e_dat   TYPE sy-datum,
       v1(4)   TYPE c,
       v2(2)   TYPE c,
       v3(2)   TYPE c.
*=============================================================================================*
*=============================================================================================*
SELECTION-SCREEN : BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
*PARAMETERS : pa_mnr TYPE /bi0/oicalmonth OBLIGATORY.  "-Jayant19Feb17
PARAMETERS : pa_mnr TYPE pno_edg_calendar_month OBLIGATORY.
SELECTION-SCREEN : END OF BLOCK b1.
*=============================================================================================*
*=============================================================================================*
c_val = pa_mnr.

CONCATENATE :  c_val '01' INTO c_val.

v1 = c_val+0(4).
v2 = c_val+4(2).
v3 = c_val+6(2).
*=============================================================================================*
*=============================================================================================*
CALL FUNCTION 'HRWPC_BL_DATES_MONTH_INTERVAL'
  EXPORTING
    datum          = c_val
    month_pst      = '0'
    month_ftr      = '0'
  IMPORTING
    begda          = b_dat
    endda          = e_dat
  EXCEPTIONS
    invalid_values = 1
    OTHERS         = 2.
IF sy-subrc <> 0.
  MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
ENDIF.
*=============================================================================================*
*=============================================================================================*

SELECT  trntyp
        docyr
        docno
        exdat
        werks
        exnum
        budat
        bondno
        amended_balance
  FROM  j_1iexchdr
  INTO CORRESPONDING FIELDS OF TABLE it_chdr
  WHERE trntyp = 'ARE1'
  AND   exdat BETWEEN b_dat AND e_dat.
*=============================================================================================*
*=============================================================================================*
IF sy-subrc = 0.
  SELECT  werks
          adrnr
  FROM    t001w
    INTO CORRESPONDING FIELDS OF TABLE it_t001w
    FOR ALL ENTRIES IN it_chdr
    WHERE werks = it_chdr-werks .
*=============================================================================================*
*=============================================================================================*
  SELECT
         werks
         j_1iexcd
    FROM j_1imocomp
    INTO CORRESPONDING FIELDS OF TABLE it_j_1imocomp
    FOR ALL ENTRIES IN it_t001w
    WHERE werks = it_t001w-werks.
  READ TABLE it_j_1imocomp INTO wa_j_1imocomp INDEX 1.
*=============================================================================================*
*=============================================================================================*
  IF sy-subrc = 0.
    SELECT
           addrnumber
           name1
           city1
           post_code1
           street
           str_suppl1
           str_suppl2
     FROM  adrc
     INTO CORRESPONDING FIELDS OF TABLE it_adrc
     FOR ALL ENTRIES IN it_t001w
     WHERE addrnumber = it_t001w-adrnr.
  ENDIF.
  READ TABLE it_adrc INTO wa_adrc INDEX 1.
*=============================================================================================*
*=============================================================================================*
  IF sy-subrc = 0.
    SELECT  bondyr
            bondno
            bondtyp
            plant
            bondnoex
            budat
            bondexpdt
     FROM   j_1ibond
     INTO CORRESPONDING FIELDS OF TABLE it_j_1ibond
     FOR ALL ENTRIES IN it_chdr
     WHERE  bondyr = it_chdr-docyr
     AND    bondno = it_chdr-bondno
     AND    plant  = it_chdr-werks.
  ENDIF.
ENDIF.
*=============================================================================================*
*=============================================================================================*
SELECT SINGLE
       spras
       mnr
       ktx
  FROM t247
  INTO wa_t247
  WHERE spras = sy-langu
  AND   mnr   = v2.
*=============================================================================================*
*=============================================================================================*
LOOP AT it_j_1ibond INTO wa_j_1ibond.

  wa_final-sr_no          = sr_no.
  READ TABLE it_chdr INTO wa_chdr WITH KEY bondno = wa_j_1ibond-bondno.
  wa_final-exnum           = wa_chdr-exnum.
  wa_final-budat           = wa_chdr-budat.
  wa_final-amended_balance = wa_chdr-amended_balance.

  WRITE : wa_j_1ibond-budat     TO lv_dat1,
          wa_j_1ibond-bondexpdt TO lv_dat2.

  sr_no = sr_no + 1.
  APPEND wa_final TO it_final.
  CLEAR wa_final.
ENDLOOP.
*=============================================================================================*
*=============================================================================================*
IF NOT it_final[] IS INITIAL.
  TRY.
      CALL METHOD cl_salv_table=>factory
        IMPORTING
          r_salv_table = alv_obj
        CHANGING
          t_table      = it_final[].
    CATCH cx_salv_msg INTO lc_msg .
  ENDTRY.

  lyot_func = alv_obj->get_functions( ).
  lyot_func->set_all( abap_true ).

  CREATE OBJECT lyot_txt.

  lyot_disp = alv_obj->get_display_settings( ).
  lyot_disp->set_striped_pattern( cl_salv_display_settings=>true ).
  lyot_disp->set_list_header( 'ANNEXURE_19' ).

  lyot_columns = alv_obj->get_columns( ).
  lyot_column ?= lyot_columns->get_column( 'AMENDED_BALANCE' ).
  lyot_add = alv_obj->get_aggregations( ).
  lyot_add->add_aggregation( 'AMENDED_BALANCE' ).
  lyot_column->set_long_text( 'Amount of Duty Including Ed.Cess' ).

  CLEAR lyot_column.
  lyot_column ?= lyot_columns->get_column( 'EXNUM' ).
  lyot_column->set_short_text( 'ARE.1 No.' ).
  lyot_column->set_medium_text( 'ARE.1 No.' ).
  lyot_column->set_long_text( 'ARE.1 No.' ).

  CLEAR lyot_column.
  lyot_column ?= lyot_columns->get_column( 'SR_NO' ).
  lyot_column->set_short_text( 'Serial No.' ).
  lyot_column->set_medium_text( 'Serial No.' ).
  lyot_column->set_long_text( 'Serial No.' ).

  CLEAR lyot_column.
  lyot_column ?= lyot_columns->get_column( 'BUDAT' ).
  lyot_column->set_short_text( 'ARE.1 Date' ).
  lyot_column->set_medium_text( 'ARE.1 Date' ).
  lyot_column->set_long_text( 'ARE.1 Date' ).

  CLEAR lyot_column.
  lyot_column ?= lyot_columns->get_column( 'DEBIT' ).
  lyot_column->set_long_text( 'Debit Serial No. in cenvat register & Dt' ).

  CLEAR lyot_column.
  lyot_column ?= lyot_columns->get_column( 'ENTRY_NO' ).
  lyot_column->set_long_text( 'Entry No. in Daily Stock Account' ).

  CLEAR lyot_column.
  lyot_column ?= lyot_columns->get_column( 'PRF_OF_EXP' ).
  lyot_column->set_long_text( 'Whether Proof of Export Received' ).

  CLEAR lyot_column.
  lyot_column ?= lyot_columns->get_column( 'DETAILS' ).
  lyot_column->set_long_text( 'Details of any Shot-shipment/adjustment' ).

  txt = 'ANNEXURE - 19'.
  lyot_lbl = lyot_txt->create_label( row = var_i column = 1 text = txt ).

  var_i = var_i + 1.
  CONCATENATE 'Date : '  lv_dat1  ' To'  lv_dat2  INTO txt SEPARATED BY '  '.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = txt ).

  var_i = var_i + 1.
  txt = 'STATEMENT REGADING EXPORT OF EXCISABLE GOODS WITHOUT PAYMENT OF DUTY'.
  lyot_lbl = lyot_txt->create_label( row = var_i column = 1 text = txt ).

  var_i = var_i + 1.
  txt = '(UNDER RULE 19)'.
  lyot_lbl = lyot_txt->create_label( row = var_i column = 1 text = txt ).

  var_i = var_i + 1.
  txt = 'Original'.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = txt ).

  var_i = var_i + 1.
  txt = 'Duplicate'.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = txt ).

  var_i = var_i + 1.
  txt = 'Statement for the month of'.
  CONCATENATE txt wa_t247-ktx v1 INTO txt SEPARATED BY ' '.
  lyot_lbl = lyot_txt->create_label( row = var_i column = 1 text = txt ).

  var_i = var_i + 1.
  txt = '1. Name of the Assessee : '.
  CONCATENATE txt wa_adrc-name1  INTO txt SEPARATED BY ' '.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = txt ).

  var_i = var_i + 1.
  txt = '2. Registration No. : '.
  CONCATENATE txt wa_j_1imocomp-j_1iexcd  INTO txt SEPARATED BY ' '.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = txt ).

  var_i = var_i + 1.
  txt = '3. Address : '.
  CONCATENATE txt wa_adrc-str_suppl1 wa_adrc-str_suppl2 wa_adrc-street wa_adrc-city1 wa_adrc-post_code1 INTO txt SEPARATED BY ' '.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = txt ).

  var_i = var_i + 1.
  txt = '4. Details of Excisable goods manufactured and exported, proof of export, duty payment if case Proof of export is not available within satuatory time limit (Part-1 to IV)'.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = txt ).

  var_i = var_i + 1.
  txt = '5. Under Taking 1 Sr. No. : '.
  CONCATENATE txt wa_j_1ibond-bondnoex 'dated' lv_dat1 'Valid up to' lv_dat2 INTO txt SEPARATED BY ' '.
  lyot_flow = lyot_txt->create_flow( row = var_i column = 1 ).
  lyot_flow->create_text( text = txt ).


  var_i = var_i + 1.
  txt = 'PART 1'.
  lyot_lbl = lyot_txt->create_label( row = var_i column = 1 text = txt ).

  var_i = var_i + 1.
  txt = 'Details of removal for export in the current month'.
  CONCATENATE txt wa_t247-ktx v1 INTO txt SEPARATED BY ' '.
  lyot_lbl = lyot_txt->create_label( row = var_i column = 1 text = txt ).

  alv_obj->set_top_of_list( lyot_txt ).

  lyot_lout = alv_obj->get_layout( ).
  lyot_key-report = sy-repid.
  lyot_lout->set_key( lyot_key ).
  lyot_lout->set_save_restriction( cl_salv_layout=>restrict_none ).

  alv_obj->display( ).
ENDIF.
