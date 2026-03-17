*&---------------------------------------------------------------------*
*& Report ZR_ITEM_MASTER_S4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR_ITEM_MASTER_S4.

DATA: GV_MATNR TYPE MARA-MATNR.

PARAMETERS: P_WERKS  TYPE WERKS_D DEFAULT 'PL01',
            P_SPRAS  TYPE SYLANGU  DEFAULT SY-LANGU,
            P_SET_ID TYPE CHAR30   DEFAULT 'DEFAULT'.
SELECT-OPTIONS: S_MATNR FOR GV_MATNR,
                S_ERSDA FOR SY-DATUM.


START-OF-SELECTION.
  DATA(LO_RANGES) = NEW CL_SALV_RANGE_TAB_COLLECTOR( ).

  DATA(LO_IDA) = CL_SALV_GUI_TABLE_IDA=>CREATE_FOR_CDS_VIEW( 'ZC_ITEMMASTER_CONS' ).

*  lo_ida->set_view_parameters( VALUE if_salv_gui_table_ida=>ys_view_parameters(
*      ( name = 'P_WERKS' value = CONV string( p_werks ) )
*      ( name = 'P_SPRAS' value = CONV string( p_spras ) ) ) ).

*  LO_IDA->ADD_SELECTION_CONDITION(
*    IV_NAME  = 'Product'
*    IT_RANGE = CL_SALV_RANGE_TAB_COLLECTOR=>FROM_SELOPT( S_MATNR ) ).
*
*  LO_IDA->ADD_SELECTION_CONDITION(
*    IV_NAME  = 'CreationDate'
*    IT_RANGE = CL_SALV_RANGE_TAB_COLLECTOR=>FROM_SELOPT( S_ERSDA ) ).
  TRY.

      DATA(LO_FC) = LO_IDA->FIELD_CATALOG( ).

      LO_IDA->SET_VIEW_PARAMETERS( VALUE #( ( NAME = 'P_WERKS'  VALUE = CONV STRING( P_WERKS ) )
                                            ( NAME = 'P_SPRAS'  VALUE = CONV STRING( P_SPRAS ) )
                                            ( NAME = 'P_SET_ID' VALUE = CONV STRING( P_SET_ID ) ) ) ).

      LO_RANGES->ADD_RANGES_FOR_NAME(
        IV_NAME   = 'PRODUCT'
        IT_RANGES = S_MATNR[] ).
      LO_RANGES->ADD_RANGES_FOR_NAME(
        IV_NAME   = 'CREATIONDATE'
        IT_RANGES = S_ERSDA[] ).

      LO_RANGES->GET_COLLECTED_RANGES( IMPORTING ET_NAMED_RANGES = DATA(IT_RANGES) ).

*  " translate ABAP select-options to IDA ranges
      LO_IDA->SET_SELECT_OPTIONS( IT_RANGES ).

      LO_IDA->FULLSCREEN( )->DISPLAY( ).
*    CATCH CX_SALV_IDA_CDS_NOT_FOUND INTO DATA(LX_NF).
*      MESSAGE LX_NF->GET_TEXT( ) TYPE 'E'.
    CATCH CX_SALV_IDA_CONTRACT_VIOLATION INTO DATA(LX_CV).
      MESSAGE LX_CV->GET_TEXT( ) TYPE 'E'.
  ENDTRY.
