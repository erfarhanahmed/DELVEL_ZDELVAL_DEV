report ZCREDIT_LIMIT
       no standard page heading line-size 255.

*include bdcrecx1.
*
*start-of-selection.
*
*perform open_group.

TYPES : BEGIN OF ty_final,
        KUNNR TYPE RF02L-KUNNR,
        KKBER TYPE RF02L-KKBER,
        KLIMK TYPE string,
  END OF ty_final.

DATA: lt_final TYPE TABLE Of ty_final,
      ls_final TYPE ty_final.

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
      i_tab_converted_data = lt_final
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

*BREAK-POINT.
LOOP AT lt_final INTO ls_final .
  REFRESH lt_bdcdata.
  CLEAR ls_bdcdata.

perform bdc_dynpro      using 'SAPMF02C' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'RF02L-D0210'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'RF02L-KUNNR'
                              ls_final-KUNNR."'0001100000'.
perform bdc_field       using 'RF02L-KKBER'
                              ls_final-KKBER."'US00'.
perform bdc_field       using 'RF02L-D0210'
                              'X'.
perform bdc_dynpro      using 'SAPMF02C' '0210'.
perform bdc_field       using 'BDC_CURSOR'
                              'KNKK-KLIMK'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'KNKK-KLIMK'
                              ls_final-KLIMK."'50000'.
perform bdc_dynpro      using 'SAPLSPO1' '0300'.
perform bdc_field       using 'BDC_OKCODE'
                              '=YES'.


CALL TRANSACTION 'FD32' USING lt_bdcdata "call transaction
     MODE 'N' "N-no screen mode, A-all screen mode, E-error screen mode
     UPDATE 'A' "A-assynchronous, S-synchronous
     MESSAGES INTO lt_msg. "messages

CLEAR ls_final .
ENDLOOP.


*perform bdc_transaction using 'FD32'.
*
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
