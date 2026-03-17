*&---------------------------------------------------------------------*
*& Report ZTDS_REPORT_ACCUMU
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZTDS_REPORT_ACCUMU.


TYPES:     BEGIN OF ts_fiwtin_acc_exem,
               mandt     TYPE fiwtin_acc_exem-mandt,
               bukrs     TYPE fiwtin_acc_exem-bukrs,
               accno     TYPE fiwtin_acc_exem-accno,
               witht     TYPE fiwtin_acc_exem-witht,
               wt_withcd TYPE fiwtin_acc_exem-wt_withcd,
               secco     TYPE fiwtin_acc_exem-secco,
               wt_date   TYPE fiwtin_acc_exem-wt_date,
               koart     TYPE fiwtin_acc_exem-koart,
               pan_no    TYPE fiwtin_acc_exem-pan_no,
               acc_amt   TYPE fiwtin_acc_exem-acc_amt,
             END OF ts_fiwtin_acc_exem.

types : BEGIN OF ts_fiwtin_tan_exem,
        mandt            TYPE fiwtin_tan_exem-mandt,
        bukrs            TYPE fiwtin_tan_exem-bukrs,
        koart            TYPE fiwtin_tan_exem-koart,
        accno            TYPE fiwtin_tan_exem-accno,
        fiwtin_tanex_sub TYPE fiwtin_tan_exem-fiwtin_tanex_sub,
        seccode          TYPE fiwtin_tan_exem-seccode,
        witht            TYPE fiwtin_tan_exem-witht,
        wt_withcd        TYPE fiwtin_tan_exem-wt_withcd,
        wt_exdf          TYPE fiwtin_tan_exem-wt_exdf,
        pan_no           TYPE fiwtin_tan_exem-pan_no,
        wt_exdt          TYPE fiwtin_tan_exem-wt_exdt,
        wt_exnr          TYPE fiwtin_tan_exem-wt_exnr,
        wt_exrt          TYPE fiwtin_tan_exem-wt_exrt,
        wt_wtexrs        TYPE fiwtin_tan_exem-wt_wtexrs,
        fiwtin_exem_thr  TYPE fiwtin_tan_exem-fiwtin_exem_thr,
        waers            TYPE fiwtin_tan_exem-waers,
      END OF ts_fiwtin_tan_exem.

TYPES:     BEGIN OF ts_final,
               mandt            TYPE MANDT,
               bukrs            TYPE bukrs,
*               bukrs1           TYPE bukrs,
               accno            TYPE wt_acno,
               witht            TYPE witht,
               wt_withcd        TYPE wt_withcd,
               secco            TYPE secco,
               wt_date          TYPE WT_VALID,
               koart            TYPE koart,
               pan_no           TYPE J_1IPANNO,
               acc_amt          TYPE WT_BS,
               fiwtin_tanex_sub TYPE fiwtin_tanex_sub,
               SECCODE          TYPE SECCO,
               wt_exdf          TYPE wt_exdf,
               wt_exdt          TYPE wt_exdt,
               wt_exnr          TYPE wt_exnr,
               wt_exrt          TYPE wt_exrt,
               wt_wtexrs        TYPE wt_wtexrs,
               fiwtin_exem_thr  TYPE fiwtin_exem_thr,
               waers            TYPE waers,

             END OF ts_final.




data : gt_fiwtin_tan_exem TYPE STANDARD TABLE OF ts_fiwtin_tan_exem,
       gs_fiwtin_tan_exem TYPE ts_fiwtin_tan_exem.

DATA : gt_fiwtin_acc_exem TYPE STANDARD TABLE OF ts_fiwtin_acc_exem,   " Global Internal table.
       gs_fiwtin_aac_exem TYPE ts_fiwtin_acc_exem.

DATA : gt_final TYPE STANDARD TABLE OF ts_final,   " Global Internal table.
       gs_final TYPE ts_final.

PARAMETERS : p_BUKRS TYPE BUKRS.
PARAMETERS : p_GJAHR TYPE GJAHR.

TYPE-POOLS :  slis.

* TYPES
TYPES : t_fieldcat TYPE slis_fieldcat_alv,
        t_heading  TYPE slis_t_listheader.

*INTERNAL TABLES

DATA : i_fieldcat TYPE STANDARD TABLE OF t_fieldcat,
       it_heading TYPE                   t_heading.

*WORKAREAS

DATA : w_fieldcat TYPE t_fieldcat,
       W_HEADING  TYPE SLIS_LISTHEADER.

"Sorting

DATA : I_SORT TYPE SLIS_T_SORTINFO_ALV,
       WA_SORT LIKE LINE OF I_SORT.

DATA : E_FIRST_DAY TYPE SY-DATUM,
       E_LAST_DAY TYPE SY-DATUM.

TYPES : ty_fieldcat TYPE slis_fieldcat_alv,
        ty_layout   TYPE slis_layout_alv.

DATA  : it_fieldcat TYPE STANDARD TABLE OF ty_fieldcat,
        wa_fieldcat TYPE ty_fieldcat,
        it_layout   TYPE STANDARD TABLE OF ty_layout,
        wa_layout   TYPE ty_layout.

PERFORM get_data.
PERFORM fieldcatlog.
PERFORM display_data.
*&---------------------------------------------------------------------*
*& Form GET_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM get_data .

clear : e_first_day,e_last_day.
if p_GJAHR is not INITIAL.
CALL FUNCTION 'FIRST_AND_LAST_DAY_IN_YEAR_GET'
  EXPORTING
    i_gjahr              = p_GJAHR
    i_periv              = 'V3'
 IMPORTING
   E_FIRST_DAY          = E_FIRST_DAY
   E_LAST_DAY           = E_LAST_DAY
 EXCEPTIONS
   INPUT_FALSE          = 1
   T009_NOTFOUND        = 2
   T009B_NOTFOUND       = 3
   OTHERS               = 4
          .
IF sy-subrc <> 0.
* Implement suitable error handling here
ENDIF.
endif.

select   mandt
         bukrs
         accno
         witht
         wt_withcd
         secco
         wt_date
         koart
         pan_no
         acc_amt
         from FIWTIN_ACC_EXEM into CORRESPONDING FIELDS OF TABLE gt_fiwtin_acc_exem
         where bukrs = p_bukrs.

if gt_fiwtin_acc_exem is not INITIAL.
  select     mandt
             bukrs
             koart
             accno
             fiwtin_tanex_sub
             seccode
             witht
             wt_withcd
             wt_exdf
             pan_no
             wt_exdt
             wt_exnr
             wt_exrt
             wt_wtexrs
             fiwtin_exem_thr
             waers
         from FIWTIN_TAN_EXEM into table  gt_fiwtin_tan_exem FOR ALL ENTRIES in gt_FIWTIN_acc_EXEM
         where bukrs = gt_FIWTIN_acc_EXEM-bukrs
         AND wt_exdf = E_FIRST_DAY.
    endif.
*

loop at gt_fiwtin_acc_exem into gs_fiwtin_aac_exem.
  MOVE-CORRESPONDING gs_fiwtin_aac_exem to gs_final.
  APPEND gs_final to gt_final.
  clear : gs_fiwtin_aac_exem,gs_final.
ENDLOOP.


loop at gt_fiwtin_tan_exem into gs_fiwtin_tan_exem.
  MOVE-CORRESPONDING gs_fiwtin_tan_exem to gs_final.
  APPEND gs_final to gt_final.
  clear : gs_fiwtin_tan_exem,gs_final.
ENDLOOP.


*      read table gt_fiwtin_tan_exem into gs_fiwtin_tan_exem WITH KEY = p_bukrs.
*        gs_final-fiwtin_tanex_sub = gs_fiwtin_tan_exem-fiwtin_tanex_sub.
*        gs_final-seccode   = gs_fiwtin_tan_exem-seccode  .
*        gs_final-wt_exdf  = gs_fiwtin_tan_exem-wt_exdf .
*        gs_final-wt_exdt = gs_fiwtin_tan_exem-wt_exdt.
*        gs_final-wt_exnr   = gs_fiwtin_tan_exem-wt_exnr  .
*        gs_final-wt_exrt  = gs_fiwtin_tan_exem-wt_exrt .
*        gs_final-wt_wtexrs     = gs_fiwtin_tan_exem-wt_wtexrs    .
*        gs_final-fiwtin_exem_thr = gs_fiwtin_tan_exem-fiwtin_exem_thr.
*        gs_final-waers     = gs_fiwtin_tan_exem-waers    .
*        gs_final-bukrs = gs_fiwtin_aac_exem-bukrs.
*        append gs_final to gt_final.
*
*
*
*
*      read table gt_fiwtin_acc_exem into gs_fiwtin_aac_exem with key = p_bukrs."where  bukrs = gs_final-bukrs.
*        gs_final-mandt = gs_fiwtin_aac_exem-mandt.
*        gs_final-bukrs = gs_fiwtin_aac_exem-bukrs.
*        gs_final-accno = gs_fiwtin_aac_exem-accno.
*        gs_final-witht = gs_fiwtin_aac_exem-witht.
*        gs_final-wt_withcd = gs_fiwtin_aac_exem-wt_withcd.
*        gs_final-secco = gs_fiwtin_aac_exem-secco.
*        gs_final-wt_date = gs_fiwtin_aac_exem-wt_date.
*        gs_final-koart = gs_fiwtin_aac_exem-koart.
*        gs_final-pan_no = gs_fiwtin_aac_exem-pan_no.
*        gs_final-acc_amt = gs_fiwtin_aac_exem-acc_amt.
*append gs_final to gt_final.


*     SELECT  A~mandt
*             A~bukrs
*             A~accno
*             A~witht
*             A~wt_withcd
*             A~secco
*             A~wt_date
*             A~koart
*             A~pan_no
*             A~acc_amt
*             B~fiwtin_tanex_sub
*             B~seccode
*             B~wt_exdf
*             B~wt_exdt
*             B~wt_exnr
*             B~wt_exrt
*             B~wt_wtexrs
*             B~fiwtin_exem_thr
*             B~waers
*  into CORRESPONDING FIELDS OF table gt_final
*  from fiwtin_acc_exem as A
*  inner join fiwtin_tan_exem as B
*  on   A~BUKRS = B~BUKRS
*  WHERE ( A~BUKRS = p_bukrs and B~BUKRS = p_bukrs ).


*   SELECT  A~mandt
*             A~bukrs
*             A~accno
*             A~witht
*             A~wt_withcd
*             A~secco
*             A~wt_date
*             A~koart
*             A~pan_no
*             A~acc_amt
*             B~fiwtin_tanex_sub
*             B~seccode
*             B~wt_exdf
*             B~wt_exdt
*             B~wt_exnr
*             B~wt_exrt
*             B~wt_wtexrs
*             B~fiwtin_exem_thr
*             B~waers
*  into CORRESPONDING FIELDS OF table gt_final
*  from fiwtin_acc_exem as A
*  left outer join fiwtin_tan_exem as B
*  on   A~BUKRS = B~BUKRS
*  WHERE ( A~BUKRS = p_bukrs and B~BUKRS = p_bukrs )
**        .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form FIELDCATLOG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM fieldcatlog .
CLEAR:wa_fieldcat,it_fieldcat[].

  wa_fieldcat-fieldname = 'MANDT'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-001.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'BUKRS'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
 wa_fieldcat-seltext_m = text-002.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'ACCNO'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-003.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'WITHT'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-004.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'WT_WITHCD'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-005.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SECCO'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-006.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'WT_DATE'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-007.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'KOART'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-008.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'PAN_NO'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-009.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'ACC_AMT'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-010.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

   wa_fieldcat-fieldname = 'FIWTIN_TANEX_SUB'.
   wa_fieldcat-tabname   = 'GT_FINAL'.
   wa_fieldcat-seltext_m = text-011.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'SECCODE'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-012.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

   wa_fieldcat-fieldname = 'WT_EXDF'.
   wa_fieldcat-tabname   = 'GT_FINAL'.
   wa_fieldcat-seltext_m = text-013.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'WT_EXDT'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-014.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

   wa_fieldcat-fieldname = 'WT_EXNR'.
   wa_fieldcat-tabname   = 'GT_FINAL'.
   wa_fieldcat-seltext_m = text-015.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'WT_EXRT'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-016.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

   wa_fieldcat-fieldname = 'WT_WTEXRS'.
   wa_fieldcat-tabname   = 'GT_FINAL'.
   wa_fieldcat-seltext_m = text-017.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'FIWTIN_EXEM_THR'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-018.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname = 'WAERS'.
  wa_fieldcat-tabname   = 'GT_FINAL'.
  wa_fieldcat-seltext_m = text-019.

  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_data .

  DATA : GD_REPID LIKE SY-REPID.
  GD_REPID = sy-repid.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      I_CALLBACK_PROGRAM      = GD_REPID
      IT_FIELDCAT             = it_fieldcat
*      I_CALLBACK_TOP_OF_PAGE  = 'TOP-OF-PAGE'
*      I_callback_user_command = 'USER_COMMAND'
*      IT_SORT                           =  I_SORT
    TABLES
      T_OUTTAB                = gt_final
* EXCEPTIONS
*     PROGRAM_ERROR           = 1
*     OTHERS                  = 2
    .
  IF SY-SUBRC <> 0.
* Implement suitable error handling here
  ENDIF.


ENDFORM.
