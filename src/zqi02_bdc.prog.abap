report ZQI02_BDC
       no standard page heading line-size 255.

*include bdcrecx1.

TYPES : BEGIN OF ty_final,
  matnr     TYPE QINF-MATNR,
  LIEFERANT TYPE QINF-LIEFERANT,
  WERK      TYPE QINF-WERK,
  FREI_DAT  TYPE QINF-FREI_DAT,
  NOINSP    TYPE QINF-NOINSP,
  ZGREEN_CHAN(3), "TYPE QINF-zgreen_chan,
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

*TYPES :  fs_struct(4096) TYPE c OCCURS 0.
*
*DATA: w_struct TYPE fs_struct.

  TYPES truxs_t_text_data(4096) TYPE c OCCURS 0.

  DATA: lt_rawdata TYPE truxs_t_text_data.

   DATA: lv_str  TYPE string,
        lv_bool TYPE c.


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
*Read the upload file
 lv_str = p_file .
  CALL METHOD cl_gui_frontend_services=>file_exist
    EXPORTING
      file   = lv_str
    RECEIVING
      result = lv_bool.
IF lv_bool IS NOT INITIAL .
  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
*      i_field_seperator    = 'X'
*      i_line_header        = 'X'
      i_tab_raw_data       = lt_rawdata "w_struct
      i_filename           = p_file
    TABLES
      i_tab_converted_data = lt_final
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
*perform open_group.

endif.
LOOP AT lt_final INTO ls_final .
  REFRESH lt_bdcdata.
  CLEAR ls_bdcdata.
     data: gd_outputdate type string,
                gd_day(2),   "field to store day 'DD'
                gd_month(2), "field to store month 'MM'
                gd_year(4).  "field to store year 'YYYY'
* split date into 3 fields to store 'DD', 'MM' and 'YYYY'
  gd_day(2)   = ls_final-FREI_DAT+6(2).
  gd_month(2) = ls_final-FREI_DAT+4(2).
  gd_year(4)  = ls_final-FREI_DAT(4).

concatenate gd_day gd_month gd_year into gd_outputdate separated by '.'.



perform bdc_dynpro      using 'SAPMQBAA' '0100'.
perform bdc_field       using 'BDC_CURSOR'
                              'QINF-WERK'.
perform bdc_field       using 'BDC_OKCODE'
                              '/00'.
perform bdc_field       using 'QINF-MATNR'
                              ls_final-matnr."'28G12000104EBSW1'.
perform bdc_field       using 'QINF-LIEFERANT'
                              ls_final-LIEFERANT."'100000'.
perform bdc_field       using 'QINF-WERK'
                              ls_final-werk."'pl01'.
perform bdc_dynpro      using 'SAPMQBAA' '0101'.
perform bdc_field       using 'BDC_CURSOR'
                              'QINF-NOINSP'.
perform bdc_field       using 'BDC_OKCODE'
                              '=QMBU'.
perform bdc_field       using 'QINF-FREI_DAT'
                               gd_outputdate."ls_final-FREI_DAT."'19.01.2022'.
perform bdc_field       using 'QINF-QSSYSFAM'
                              '1080'.
perform bdc_field       using 'QINF-NOINSP'
                              ls_final-NOINSP."'X'.
perform bdc_field       using 'BDC_CURSOR'
                              'QINF-ZGREEN_CHAN'.
perform bdc_field       using 'QINF-ZGREEN_CHAN'
                               ls_final-zgreen_chan ."'NO'.

CALL TRANSACTION 'QI02' USING lt_bdcdata "call transaction
     MODE 'N' "N-no screen mode, A-all screen mode, E-error screen mode
     UPDATE 'S' "A-assynchronous, S-synchronous
     MESSAGES INTO lt_msg. "messages

CLEAR ls_final .
CLEAR gd_outputdate.
ENDLOOP.
*perform bdc_transaction using 'QI02'.




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
