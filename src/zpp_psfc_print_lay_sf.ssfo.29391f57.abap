data : lv_mtart TYPE mara-mtart.

 CLEAR: gs_mard, gv_qty, gv_qty1,gv_lgpbe,gv_lgort.

 SELECT SINGLE mtart
   from mara
   into lv_mtart
   where matnr eq gs_comp-MATNR.

 if header-auart eq 'AUT1' and lv_mtart EQ 'FERT'.

    SELECT SINGLE KALAB
      FROM MSKA
      INTO GV_QTY
      WHERE MATNR EQ gs_comp-MATNR
      and   WERKS EQ gs_comp-werks
     and   VBELN EQ HEADER-VBELN
     and   POSNR EQ HEADER-VBELP.
********************added by jyoti on 07.01.2024
*       SELECT SINGLE KALAB
*      FROM MSKA
*      INTO GV_QTY1
*      WHERE MATNR EQ gs_comp-MATNR
*      and   WERKS EQ gs_comp-werks
*     and   VBELN EQ HEADER-VBELN
*     and   POSNR EQ HEADER-VBELP.

CLEAR :lv_mtart.
   ELSE."""""""""""""""""""""""""""""""""""""""""""""

 SELECT SINGLE * FROM mard INTO gs_mard
   WHERE matnr = gs_comp-matnr
     AND werks = gs_comp-werks
     AND lgort = gs_comp-lgort.

CLEAR gv_maktx.
 SELECT SINGLE maktx INTO gv_maktx
   FROM makt
   WHERE matnr = gs_comp-matnr
     AND spras = sy-langu.

gv_qty = gs_mard-labst.
****************added by jyoti on 07.01.2024*************
if gs_comp-lgort+0(1) = 'K'.
  GV_LGORT = 'RM01'.
elseif gs_comp-lgort = 'RM01'.
   GV_LGORT = 'KRM0'.
ENDIF.
*BREAK-POINT.
select SINGLE lgpbe from mard
  into gv_lgpbe
  WHERE MATNR EQ gs_comp-MATNR
      and   WERKS EQ gs_comp-werks
      and lgort eq GV_LGORT.
*     and   VBELN EQ HEADER-VBELN
*     and   POSNR EQ HEADER-VBELP.


 SELECT SINGLE labst
      FROM mard
      INTO GV_QTY1
      WHERE MATNR EQ gs_comp-MATNR
      and   WERKS EQ gs_comp-werks
      and lgort eq GV_LGORT.
*     and   VBELN EQ HEADER-VBELN
*     and   POSNR EQ HEADER-VBELP.

CLEAR : lv_mtart.
endif.
if gs_comp-lgort is INITIAL.
  clear :GV_LGORT, gv_lgpbe.
endif.

CLEAR :GS_MARA-MTART.


