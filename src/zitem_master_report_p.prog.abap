*&---------------------------------------------------------------------*
*& Report ZITEM_MASTER_REPORT_P
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zitem_master_report_p.
TABLES : mara.

DATA:
  lv_xml    TYPE string.


DATA : functioncall1(1) TYPE c,
        system      TYPE rzlli_apcl,
       taskname(8) TYPE c,
       index(3)    TYPE c,
       index1      TYPE i,
       snd_jobs    TYPE i,
       rcv_jobs    TYPE i,
       exc_flag    TYPE i,
       mess        TYPE c LENGTH 80.
DATA: it_csv TYPE truxs_t_text_data,
      wa_csv TYPE LINE OF truxs_t_text_data,
      hd_csv TYPE LINE OF truxs_t_text_data.

DATA: lv_per_chunk TYPE i,
      lv_index     TYPE i VALUE 0,
      lv_remainder TYPE i.


DATA :   i_mara   TYPE STANDARD TABLE OF mara.

CONSTANTS: done(1) TYPE c VALUE 'X'.

DATA: s_mat TYPE TABLE OF rsmatnr WITH HEADER LINE.

FIELD-SYMBOLS: <fs_mara> TYPE mara.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_matnr FOR mara-matnr,
                  s_date FOR mara-ersda.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
SELECTION-SCREEN END OF BLOCK b2.

*DATA: it_WPINFO TYPE TABLE OF  WPINFO .
*
*CALL FUNCTION 'TH_WPINFO'
** EXPORTING
**   SRVNAME             = ' '
**   WITH_CPU            = 0
**   WITH_MTX_INFO       = 0
**   MAX_ELEMS           = 0
*  TABLES
*    wplist              = it_WPINFO
** EXCEPTIONS
**   SEND_ERROR          = 1
**   OTHERS              = 2
*          .
*IF sy-subrc <> 0.
** Implement suitable error handling here
*ENDIF.


*DELETE it_wpinfo WHERE wp_typ <> 'BGD' OR wp_status <> 'Waiting'.
*DESCRIBE TABLE it_wpinfo LINES DATA(lv_availablewp).
*lv_availablewp = lv_availablewp / 2.
SELECT * FROM mara INTO TABLE i_mara WHERE matnr IN s_matnr AND ersda IN s_date.
*SELECT * FROM mara INTO TABLE i_mara UP TO 40 ROWS.
DESCRIBE TABLE i_mara LINES DATA(lv_lines).
*lv_per_chunk = lv_lines DIV lv_availablewp.
*lv_remainder = lv_lines MOD lv_availablewp.
lv_per_chunk = lv_lines DIV 10.
lv_remainder = lv_lines MOD 10.
IF lv_per_chunk = 0.
  lv_per_chunk = 1.
ENDIF.

**********************************************************************************
* RFC Server Group created from transaction RZ12
* It will be the config for Parallel processing.
* We can keep it as DEFAULT. In our case it is 'parallel_generators'
**********************************************************************************
system = 'parallel_generators'.

LOOP AT i_mara ASSIGNING <fs_mara>.
  lv_index =  lv_index + 1.
  s_mat-sign = 'I'.
  s_mat-option = 'EQ'.
  s_mat-low = <fs_mara>-matnr.
  APPEND s_mat.
  IF ( lv_index MOD lv_per_chunk = 0 AND lv_index < lv_lines )  OR ( lv_index = lv_lines ).
    index = index + 1.
    CONCATENATE 'Task' index INTO taskname. "Generate Unique Task Name

**********************************************************************************
* Below is the SYNTAX for calling our own FM (For which we need Papallel processing)
*
* CALL FUNCTION func STARTING NEW TASK task
*              [DESTINATION {dest|{IN GROUP {group|DEFAULT}}}]
*              parameter_list
*              [{PERFORMING subr}|{CALLING meth} ON END OF TASK].
*
* We can keep the syntax as DESTINATION IN GROUP DEFAULT instead of
*                           DESTINATION IN GROUP system
*
* The above syntaxes will creates Different task name TASK in a     separate work process.
* Each such task executes “process_parallel” in a separate work process.
*
**********************************************************************************
    CALL FUNCTION 'ZPARALLEL_PROCESSING_FM'
      STARTING NEW TASK taskname
*DESTINATION IN GROUP system
*DESTINATION IN GROUP 390
      DESTINATION 'NONE'
      PERFORMING process_parallel ON END OF TASK
      EXPORTING
        p_hidden              = taskname
      TABLES
        material              = s_mat
      EXCEPTIONS
        system_failure        = 1 MESSAGE mess
        communication_failure = 2 MESSAGE mess
        resource_failure      = 3.

    CASE sy-subrc.
      WHEN 0.
        snd_jobs = snd_jobs + 1.
        WAIT UP TO 1 SECONDS.
      WHEN 1 OR 2.
        MESSAGE mess TYPE 'I'.
      WHEN 3.
        IF snd_jobs >= 1 AND
        exc_flag = 0.
          exc_flag = 1.
          WAIT UNTIL rcv_jobs >= snd_jobs UP TO 10 SECONDS.
        ENDIF.

        IF sy-subrc = 0.
          exc_flag = 0.
        ELSE.
          MESSAGE 'Resource failure' TYPE 'I'.
        ENDIF.
      WHEN OTHERS.
        MESSAGE 'Other error' TYPE 'I'.
    ENDCASE.

    CLEAR: s_mat,s_mat[].
  ENDIF.

ENDLOOP.

WAIT UNTIL rcv_jobs >= snd_jobs .


*&---------------------------------------------------------------------*
*&      Form  process_parallel
*&---------------------------------------------------------------------*
* Each task will execute “process_parallel” in a separate work process.
*----------------------------------------------------------------------
FORM process_parallel USING taskname.

  rcv_jobs = rcv_jobs + 1.

  RECEIVE RESULTS FROM FUNCTION 'ZPARALLEL_PROCESSING_FM'
  IMPORTING
   lv_json        =  lv_xml.
  functioncall1 = done.

ENDFORM.
