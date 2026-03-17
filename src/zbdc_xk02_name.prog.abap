report ZBDC_XK02_NAME
       no standard page heading line-size 255.

TABLES : sscrfields.

TYPES  : BEGIN OF t_error,
           infnr TYPE eina-infnr, "info type
         END OF t_error.

DATA : gt_error TYPE STANDARD TABLE OF t_error,
       gs_error TYPE t_error.

DATA : lt_bdcdata TYPE TABLE OF bdcdata WITH HEADER LINE, "BDCDATA
       ls_bdcdata LIKE lt_bdcdata . "work area BDCDATA

DATA : lt_msg     TYPE TABLE OF bdcmsgcoll,   " Collecting Error messages
       ls_msg     TYPE bdcmsgcoll,
       w_msg1(51).

TYPES : BEGIN OF ty_lfa1,
          LIFNR TYPE lfa1-LIFNR,
          Bukrs TYPE bkpf-Bukrs,
          EKORG TYPE ekko-EKORG,
          name3 TYPE lfa1-name3,
          name4 TYPE lfa1-name4,
        END OF ty_lfa1.

DATA : lt_lfa1 TYPE TABLE OF ty_lfa1,
       ls_lfa1 TYPE ty_lfa1.

TYPES :  fs_struct(4096) TYPE c OCCURS 0.

DATA: w_struct TYPE fs_struct.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS : p_file TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      program_name  = syst-cprog
      dynpro_number = syst-dynnr
      field_name    = ' '
    IMPORTING
      file_name     = p_file.

start-of-selection.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_field_seperator    = 'X'
      i_line_header        = 'X'
      i_tab_raw_data       = w_struct
      i_filename           = p_file
    TABLES
      i_tab_converted_data = lt_lfa1
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

*include bdcrecx1.


*perform open_group.

 LOOP AT lt_lfa1 INTO ls_lfa1 .

perform bdc_dynpro      using 'SAPMF02K' '0101'.
perform bdc_field       using 'BDC_CURSOR'
                              'RF02K-D0110'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'RF02K-LIFNR'
                              ls_lfa1-LIFNR."'100015'.
perform bdc_field       using 'RF02K-BUKRS'
                              ls_lfa1-BUKRS."'1000'.
perform bdc_field       using 'RF02K-EKORG'
                              ls_lfa1-EKORG."'1000'.
perform bdc_field       using 'RF02K-D0110'
                              'X'.
perform bdc_dynpro      using 'SAPMF02K' '0110'.
*perform bdc_field       using 'BDC_CURSOR'
*                              'LFA1-NAME4'.
perform bdc_field       using 'BDC_OKCODE'
                              '=UPDA'.
*perform bdc_field       using 'LFA1-NAME1'
*                              'Test for BDC Recording'.
*perform bdc_field       using 'LFA1-SORTL'
*                              'TEST1'.
perform bdc_field       using 'LFA1-NAME3'
                              ls_lfa1-name3."'AVL'.
perform bdc_field       using 'LFA1-NAME4'
                              ls_lfa1-name4."'Onsite'.
*perform bdc_field       using 'LFA1-STRAS'
*                              '81, new dhanmandi'.
*perform bdc_field       using 'LFA1-ORT01'
*                              'Kota'.
*perform bdc_field       using 'LFA1-PSTLZ'
*                              '324007'.
*perform bdc_field       using 'LFA1-ORT02'
*                              'Pune'.
*perform bdc_field       using 'LFA1-LAND1'
*                              'IN'.
*perform bdc_field       using 'LFA1-REGIO'
*                              '13'.
*perform bdc_field       using 'LFA1-SPRAS'
*                              'EN'.
*perform bdc_field       using 'LFA1-TELF1'
*                              '0321-987899'.
*perform bdc_field       using 'LFA1-TELFX'
*                              '0123-234678'.
*perform bdc_field       using 'LFA1-TELF2'
*                              '978376781'.
*perform bdc_transaction using 'XK02'.

ENDLOOP.
  CALL TRANSACTION 'XK02' USING lt_bdcdata "call transaction
        MODE 'N' "N-no screen mode, A-all screen mode, E-error screen mode
        UPDATE 'A' "A-assynchronous, S-synchronous
        MESSAGES INTO lt_msg. "messages

*perform close_group.

*----------------------------------------------------------------------*
*        Start new screen                                              *
*----------------------------------------------------------------------*
FORM bdc_dynpro USING program dynpro.
  CLEAR lt_bdcdata.
  lt_bdcdata-program  = program.
  lt_bdcdata-dynpro   = dynpro.
  lt_bdcdata-dynbegin = 'X'.
  APPEND lt_bdcdata.
ENDFORM.

*----------------------------------------------------------------------*
*        Insert field                                                  *
*----------------------------------------------------------------------*
FORM bdc_field USING fnam fval.
*  IF fval <> space.
    CLEAR lt_bdcdata.
    lt_bdcdata-fnam = fnam.
    lt_bdcdata-fval = fval.
*    SHIFT lt_bdcdata-fval LEFT DELETING LEADING space.
    APPEND lt_bdcdata.
*  ENDIF.
ENDFORM.
