*&---------------------------------------------------------------------*
*& Report ZITEM_MASTER_REPORT_2
*&---------------------------------------------------------------------*
*& Report ZITEM_MASTER_REPORT_2 (CTE + Joins, SALV, dynamic table)
*&---------------------------------------------------------------------*
REPORT zitem_master_report_2.

*TABLES mara.
** Types
TYPES: BEGIN OF ty_final,
         matnr        TYPE matnr,
         mtart        TYPE mtart,
         ersda        TYPE char11,      "to get date in dd-mmm-yyyy format
         ernam        TYPE ernam,
         bismt        TYPE bismt,
         extwg        TYPE extwg,          "Ex.Mat.Group
         matkl        TYPE matkl,          "Mat.group
         spart        TYPE spart,          "Division
         brgew        TYPE brgew,          "Gross weight
         meins        TYPE meins,          "UOM
         ntgew        TYPE ntgew,          "Net Weight
         mtpos_mara   TYPE mtpos_mara,     "Item.Cat.Group
         tragr        TYPE tragr,          "Transport.Group
         magrv        TYPE magrv,          "Mat.Grp pack
         bstme        TYPE bstme,          "PO unit
         zseries      TYPE zser_code,      "Series code
         zsize        TYPE zsize,          "Size
         brand        TYPE zbrand,         "Brand
         moc          TYPE zmoc,           "MOC
         type         TYPE ztyp,           "TYPE
         qmpur        TYPE qmpur,          "QM Proc.Active
         pstat        TYPE pstat_d,        "Maintain Status
         raube        TYPE raube,          "Stor.Cond
         zeinr        TYPE dzeinr,         "Drawing no
         zeivr        TYPE dzeivr,         "REv.no
         maktx        TYPE  makt-maktx,
         werks        TYPE  marc-werks,
         mtvfp        TYPE  marc-mtvfp,     "Availability check
         ladgr        TYPE  marc-ladgr,     "Loading group
         prctr        TYPE  marc-prctr,     "Profit center
         sernp        TYPE  marc-sernp,     "Ser.No.Prof
         ekgrp        TYPE  marc-ekgrp,     "Pur.Group
         dismm        TYPE  marc-dismm,
         dispo        TYPE  marc-dispo,
         bstmi        TYPE  marc-bstmi,
         disls        TYPE  marc-disls,     "Lot Sizing
         beskz        TYPE  marc-beskz,
         sobsl        TYPE  marc-sobsl,
         wzeit        TYPE  marc-wzeit,
         plifz        TYPE  marc-plifz,     "Plan.Del.Time
         fhori        TYPE  marc-fhori,
         strgr        TYPE  marc-strgr,
         vrmod        TYPE  marc-vrmod,
         vint1        TYPE  marc-vint1,
         vint2        TYPE  marc-vint2,
         sbdkz        TYPE  marc-sbdkz,
         fevor        TYPE  marc-fevor,
         sfcpf        TYPE  marc-sfcpf,
         dzeit        TYPE  marc-dzeit,
         ausme        TYPE  marc-ausme,
         losgr        TYPE  marc-losgr,
         steuc        TYPE  marc-steuc,
         ssqss        TYPE  marc-ssqss,
         miskz        TYPE  marc-miskz,
         lgort        TYPE  mard-lgort,
         lgpbe        TYPE  mard-lgpbe,
         vkorg        TYPE  mvke-vkorg,
         vtweg        TYPE  mvke-vtweg,
         dwerk        TYPE  mvke-dwerk,
         versg        TYPE  mvke-versg,
         ktgrm        TYPE  mvke-ktgrm,
         mtpos        TYPE  mvke-mtpos,
         meinh        TYPE  marm-meinh,
         umrez        TYPE  marm-umrez,
         umren        TYPE  marm-umren,
         bklas        TYPE  mbew-bklas,
         vprsv        TYPE  mbew-vprsv,

*         verpr        TYPE  mbew-verpr,
*         stprs        TYPE  mbew-stprs,
         verpr        TYPE  char13,
         stprs        TYPE  char13,
         ekalr        TYPE  mbew-ekalr,
         taxm1        TYPE  mlan-taxm1,
         taxm2        TYPE  mlan-taxm2,
         taxm3        TYPE  mlan-taxm3,
         taxm4        TYPE  mlan-taxm4,
         j_1icapind   TYPE  j_1imtchid-j_1icapind,
         j_1isubind   TYPE  j_1imtchid-j_1isubind,
         j_1igrxref   TYPE  j_1imtchid-j_1igrxref,
         art          TYPE  qmat-art,
         aktiv        TYPE  qmat-aktiv,
*         j_1ivalass   TYPE  j_1iassval-j_1ivalass,
         j_1ivalass   TYPE  char15,
         j_1imoom     TYPE  j_1imoddet-j_1imoom,
         mattxt       TYPE  text300,
*         span         TYPE  text100,

         class        TYPE  klah-class,
         stem         TYPE  text100,
         seat         TYPE  text100,
         body         TYPE  text100,
         disc         TYPE  text100,
         ball         TYPE  text100,
         rating       TYPE  text100,
         clas         TYPE  text100,
         air_f        TYPE  text100,
         main_air     TYPE  text100,
         lvorm        TYPE  mara-lvorm,
         ref          TYPE  char11,
         bom          TYPE  mara-bom,
         ncost        TYPE  marc-ncost,
         sobsk        TYPE  marc-sobsk,
         rm01         TYPE  char03,
         fg01         TYPE  char03,
         prd1         TYPE  char03,
         rj01         TYPE  char03,
         rwk1         TYPE  char03,
         scr1         TYPE  char03,
         sfg1         TYPE  char03,
         srn1         TYPE  char03,
         vld1         TYPE  char03,
         plg1         TYPE  char03,
         tpi1         TYPE  char03,
         sc01         TYPE  char03,
         spc1         TYPE  char03,
         slr1         TYPE  char03,
         dis10        TYPE  char03,
         dis20        TYPE  char03,
         dis30        TYPE  char03,
         zzeds        TYPE  mara-zzeds,
         zzmss        TYPE  mara-zzmss,
         vmsta        TYPE  mvke-vmsta,
         vmstb        TYPE  tvmst-vmstb,
         username     TYPE  cdhdr-username,
         udate        TYPE  char11,
         tcode        TYPE  cdhdr-tcode,
         taxm8        TYPE  mlan-taxm8,
         cap          TYPE  mara-cap_lead,
*         zplp3        TYPE  mbew-zplp3,
         zplp3        TYPE  char13,
         zpld3        TYPE  char11,
         item_type    TYPE  mara-item_type,
         air_pressure TYPE  mara-air_pressure,
         air_fail     TYPE  mara-air_fail,
         actuator     TYPE  mara-actuator,
         vertical     TYPE  mara-vertical,
         pprdl        TYPE  mbew-pprdl,
         pdatl        TYPE  mbew-pdatl,
*         lplpr        TYPE  mbew-lplpr,
         lplpr        TYPE  char13,
         pprdv        TYPE  mbew-pprdv,
         pdatv        TYPE  mbew-pdatv,
*         vplpr        TYPE  mbew-vplpr,         "Previous Planned Price
         vplpr        TYPE  char13,         "Previous Planned Price
         kzkfg        TYPE  mara-kzkfg,
         modify_date  TYPE  char11,
         dev_status   TYPE  mara-dev_status,
         zkanban      TYPE  mara-zkanban,
         zpen_item    TYPE  mara-zpen_item,
         zre_pen_item TYPE  mara-zre_pen_item,
         mcn1         TYPE  char03,
         pn01         TYPE  char03,
         zqap         TYPE  mara-qap_no,
         rev_no       TYPE  mara-rev_no,
         zboi         TYPE  char03,
         time         TYPE  sy-uzeit,
         wrkst        TYPE  mara-wrkst,
         kmcn         TYPE  char03,
         kndt         TYPE  char03,
         kplg         TYPE  char03,
         kpr1         TYPE  char03,
         kprd         TYPE  char03,
         krj0         TYPE  char03,
         krm0         TYPE  char03,
         krwk         TYPE  char03,
         ksc0         TYPE  char03,
         kscr         TYPE  char03,
         ksfg         TYPE  char03,
         kslr         TYPE  char03,
         kspc         TYPE  char03,
         ksrn         TYPE  char03,
         ktpi         TYPE  char03,
         kvld         TYPE  char03,
         kfg0         TYPE  char03,
         zitem_class  TYPE  mara-zitem_class,
         span         TYPE  string,

       END   OF ty_final,
       tty_final TYPE STANDARD TABLE OF ty_final.

DATA: gv_matnr TYPE matnr.
"---------------- Selection screen (unchanged) -------------------------

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_mat  FOR gv_matnr,
                  s_date FOR sy-datum.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
  PARAMETERS p_down   AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/India'.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
SELECTION-SCREEN END OF BLOCK b2.

*SELECTION-SCREEN :BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
*  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
*SELECTION-SCREEN: END OF BLOCK b3.

PARAMETERS p_hidden TYPE char8 NO-DISPLAY.

" dynamic result set (inferred from SELECT)
DATA: gt_final TYPE REF TO data,
      gt_csv   TYPE truxs_t_text_data.

" helper for texts
DATA: gv_tdname TYPE thead-tdname,
      gt_tline  TYPE STANDARD TABLE OF tline,
      gs_tline  TYPE tline.

"---------------- Driver -------------------------

START-OF-SELECTION.
  PERFORM get_data .
  PERFORM show_salv.
  IF p_down = 'X'.
    PERFORM download USING p_folder.
  ENDIF.

  "======================================================================
  " GET_DATA: one big set-based read using CTEs + joins
  "======================================================================
FORM get_data.

*  SELECT SINGLE * FROM ZTB_STR INTO @DATA(LS_STR)
*                WHERE RECORD = '1'.
*  IF SY-SUBRC <> 0.
*    LS_STR-RECORD = 1.
*    MODIFY ZTB_STR FROM LS_STR.
*    COMMIT WORK.
*  ENDIF.


  DATA(lv_ref_d)  = sy-datum.
  DATA(lv_ref_t)  = sy-uzeit.

  WITH

    +mara AS (
      SELECT a~matnr, a~mtart, a~ersda, a~ernam, a~bismt, a~extwg, a~matkl, a~spart,
             a~brgew, a~meins, a~ntgew, a~mtpos_mara, a~tragr, a~magrv, a~bstme,
             a~zseries, a~zsize, a~brand, a~moc, a~type, a~qmpur, a~pstat, a~raube,
             a~zeinr, a~zeivr, a~lvorm, a~normt, a~bom, a~zzeds, a~zzmss, a~cap_lead,
             a~item_type, a~air_pressure, a~air_fail, a~actuator, a~vertical,
             a~kzkfg, a~dev_status, a~zkanban, a~zpen_item, a~zre_pen_item,
             a~qap_no, a~rev_no, a~zboi, a~wrkst, a~zitem_class, b~maktx,
* From MARC
             c~werks, c~mtvfp, c~ladgr, c~prctr, c~sernp,
             c~ekgrp, c~dismm, c~dispo, c~bstmi, c~disls, c~beskz,
             c~sobsl, c~wzeit, c~plifz, c~fhori, c~strgr, c~vrmod,
             c~vint1, c~vint2, c~sbdkz, c~fevor, c~sfcpf, c~dzeit,
             c~ausme, c~losgr, c~steuc, c~ssqss, c~miskz, c~lvorm AS lvorm_c,
             c~ncost, c~sobsk
        FROM mara AS a
        INNER JOIN makt AS b ON b~matnr = a~matnr
                            AND b~spras = @sy-langu
        INNER JOIN marc AS c ON c~matnr = a~matnr
*                            and c~werks = 'PL01'
       WHERE a~matnr IN @s_mat
         AND a~ersda IN @s_date
         AND c~werks = 'PL01'
    ),

*    +makt AS (
*      SELECT matnr, maktx
*        FROM makt
*       WHERE spras = @sy-langu
*    ),

*    +marc AS (
*      SELECT matnr, werks, mtvfp, ladgr, prctr, sernp,
*             ekgrp, dismm, dispo, bstmi, disls, beskz,
*             sobsl, wzeit, plifz, fhori, strgr, vrmod,
*             vint1, vint2, sbdkz, fevor, sfcpf, dzeit,
*             ausme, losgr, steuc, ssqss, miskz, lvorm,
*             ncost, sobsk
*        FROM marc
*       WHERE werks = 'PL01'
*    ),

    +mard_raw AS (
      SELECT matnr, lgort, lgpbe, werks
        FROM mard
       WHERE matnr IN @s_mat
         AND werks = 'PL01'
    ),
    +mard_one AS (
      SELECT matnr,
             MIN( lgort ) AS lgort,
             MIN( lgpbe ) AS lgpbe
        FROM +mard_raw
       GROUP BY matnr
    ),
    +mard_flags AS (
      SELECT matnr,
             MAX( CASE WHEN lgort = 'RM01' THEN  1 ELSE 0 END ) AS rm01,
             MAX( CASE WHEN lgort = 'FG01' THEN  1 ELSE 0  END ) AS fg01,
             MAX( CASE WHEN lgort = 'PRD1' THEN  1 ELSE 0  END ) AS prd1,
             MAX( CASE WHEN lgort = 'RJ01' THEN  1 ELSE 0  END ) AS rj01,
             MAX( CASE WHEN lgort = 'RWK1' THEN  1 ELSE 0  END ) AS rwk1,
             MAX( CASE WHEN lgort = 'SCR1' THEN  1 ELSE 0  END ) AS scr1,
             MAX( CASE WHEN lgort = 'SFG1' THEN  1 ELSE 0  END ) AS sfg1,
             MAX( CASE WHEN lgort = 'SRN1' THEN  1 ELSE 0  END ) AS srn1,
             MAX( CASE WHEN lgort = 'VLD1' THEN  1 ELSE 0 END ) AS vld1,
             MAX( CASE WHEN lgort = 'PLG1' THEN  1 ELSE 0 END ) AS plg1,
             MAX( CASE WHEN lgort = 'TPI1' THEN 1 ELSE 0 END ) AS tpi1,
             MAX( CASE WHEN lgort = 'SC01' THEN 1 ELSE 0 END ) AS sc01,
             MAX( CASE WHEN lgort = 'SPC1' THEN 1 ELSE 0 END ) AS spc1,
             MAX( CASE WHEN lgort = 'SLR1' THEN 1 ELSE 0 END ) AS slr1,
             MAX( CASE WHEN lgort = 'MCN1' THEN 1 ELSE 0 END ) AS mcn1,
             MAX( CASE WHEN lgort = 'PN01' THEN 1 ELSE 0 END ) AS pn01,
             MAX( CASE WHEN lgort = 'KMCN' THEN 1 ELSE 0 END ) AS kmcn,
             MAX( CASE WHEN lgort = 'KNDT' THEN 1 ELSE 0 END ) AS kndt,
             MAX( CASE WHEN lgort = 'KPLG' THEN 1 ELSE 0 END ) AS kplg,
             MAX( CASE WHEN lgort = 'KPR1' THEN 1 ELSE 0 END ) AS kpr1,
             MAX( CASE WHEN lgort = 'KPRD' THEN 1 ELSE 0 END ) AS kprd,
             MAX( CASE WHEN lgort = 'KRJ0' THEN 1 ELSE 0 END ) AS krj0,
             MAX( CASE WHEN lgort = 'KRM0' THEN 1 ELSE 0 END ) AS krm0,
             MAX( CASE WHEN lgort = 'KRWK' THEN 1 ELSE 0 END ) AS krwk,
             MAX( CASE WHEN lgort = 'KSC0' THEN 1 ELSE 0 END ) AS ksc0,
             MAX( CASE WHEN lgort = 'KSCR' THEN 1 ELSE 0 END ) AS kscr,
             MAX( CASE WHEN lgort = 'KSFG' THEN 1 ELSE 0 END ) AS ksfg,
             MAX( CASE WHEN lgort = 'KSLR' THEN 1 ELSE 0 END ) AS kslr,
             MAX( CASE WHEN lgort = 'KSPC' THEN 1 ELSE 0 END ) AS kspc,
             MAX( CASE WHEN lgort = 'KSRN' THEN 1 ELSE 0 END ) AS ksrn,
             MAX( CASE WHEN lgort = 'KTPI' THEN 1 ELSE 0 END ) AS ktpi,
             MAX( CASE WHEN lgort = 'KVLD' THEN 1 ELSE 0 END ) AS kvld,
             MAX( CASE WHEN lgort = 'KFG0' THEN 1 ELSE 0 END ) AS kfg0
        FROM +mard_raw
       GROUP BY matnr
    ),

    +mvke_raw AS (
      SELECT matnr, vkorg, vtweg, dwerk, versg, ktgrm, mtpos, vmsta
        FROM mvke
       WHERE matnr IN @s_mat
         AND vkorg = '1000'
    ),
    +mvke_flags AS (
      SELECT matnr,
             MAX( CASE WHEN vtweg = '10' THEN 1 ELSE 0 END ) AS dis10_flag,
             MAX( CASE WHEN vtweg = '20' THEN 1 ELSE 0 END ) AS dis20_flag,
             MAX( CASE WHEN vtweg = '30' THEN 1 ELSE 0 END ) AS dis30_flag,
             MIN( vkorg ) AS vkorg,
             MIN( vtweg ) AS vtweg,
             MIN( dwerk ) AS dwerk,
             MIN( versg ) AS versg,
             MIN( ktgrm ) AS ktgrm,
             MIN( mtpos ) AS mtpos,
             MIN( vmsta ) AS vmsta
        FROM +mvke_raw
       GROUP BY matnr
    ),

    +tvmst AS (
      SELECT vmsta, vmstb
        FROM tvmst
       WHERE spras = @sy-langu
    ),

    +marm_agg AS (
      SELECT matnr,
             MIN( meinh ) AS meinh,
             MIN( umrez ) AS umrez,
             MIN( umren ) AS umren
        FROM marm
        WHERE matnr IN @s_mat
       GROUP BY matnr
    ),

    +mbew AS (
      SELECT matnr, bklas, vprsv, verpr, stprs, ekalr,
             zplp3, zpld3, pprdl, pprdv, pdatl, pdatv, vplpr, lplpr
        FROM mbew
       WHERE matnr IN @s_mat
         AND bwkey = 'PL01'
    ),

    +mlan AS (
      SELECT matnr, taxm1, taxm2, taxm3, taxm4, taxm8
        FROM mlan
       WHERE matnr IN @s_mat
         AND aland = 'IN'
    ),

*    +QMAT AS (
*      SELECT MATNR, ART, AKTIV
*        FROM QMAT
*       WHERE WERKS = 'PL01'
 +qmat AS (
      SELECT matnr, MAX( art ) AS art, MAX( aktiv ) AS aktiv
        FROM qmat
       WHERE matnr IN @s_mat
         AND werks = 'PL01'
       GROUP BY matnr
    ),

    +j1imt AS (
      SELECT matnr, j_1icapind, j_1isubind, j_1igrxref
        FROM j_1imtchid
       WHERE matnr IN @s_mat
         AND werks = 'PL01'
    ),

    +j1iav AS (
      SELECT j_1imatnr AS matnr, j_1ivalass
        FROM j_1iassval
       WHERE j_1iwerks = 'PL01'
    ),

    +j1imd AS (
      SELECT j_1imoim AS matnr, j_1imoom
        FROM j_1imoddet
       WHERE werks = 'PL01'
    ),

    +ausp_f AS (
      SELECT objek, atinn, atwrt
        FROM ausp
       WHERE objek IN ( SELECT matnr FROM +mara )
         AND atinn IN (
             '0000000822','0000000812','0000000813','0000000818',
             '0000000811','0000000828','0000000815','0000000817','0000000816'
         )
    ),
    +ausp_pivot AS (
      SELECT objek                        AS matnr,
            STRING_AGG( CASE WHEN atinn = '0000000822' THEN atwrt END, ' '  ) AS stem,
            STRING_AGG( CASE WHEN atinn = '0000000812' THEN atwrt END, ' ' ) AS rating,
            STRING_AGG( CASE WHEN atinn = '0000000813' THEN atwrt END, ' ' ) AS disc,
            STRING_AGG( CASE WHEN atinn = '0000000818' THEN atwrt END, ' ' ) AS body,
            STRING_AGG( CASE WHEN atinn = '0000000811' THEN atwrt END, ' ' ) AS seat,
            STRING_AGG( CASE WHEN atinn = '0000000828' THEN atwrt END, ' ' ) AS ball,
            STRING_AGG( CASE WHEN atinn = '0000000815' THEN atwrt END, ' ' ) AS clas,
            STRING_AGG( CASE WHEN atinn = '0000000817' THEN atwrt END, ' ' ) AS main_air,
            STRING_AGG( CASE WHEN atinn = '0000000816' THEN atwrt END, ' ' ) AS air_f
*             MAX( CASE WHEN ATINN = '0000000812' THEN ATWRT END ) AS RATING,
*             MAX( CASE WHEN ATINN = '0000000813' THEN ATWRT END ) AS DISC,
*             MAX( CASE WHEN ATINN = '0000000818' THEN ATWRT END ) AS BODY,
*             MAX( CASE WHEN ATINN = '0000000811' THEN ATWRT END ) AS SEAT,
*             MAX( CASE WHEN ATINN = '0000000828' THEN ATWRT END ) AS BALL,
*             MAX( CASE WHEN ATINN = '0000000815' THEN ATWRT END ) AS CLAS,
*             MAX( CASE WHEN ATINN = '0000000817' THEN ATWRT END ) AS MAIN_AIR,
*             MAX( CASE WHEN ATINN = '0000000816' THEN ATWRT END ) AS AIR_F
        FROM +ausp_f
       GROUP BY objek
    ),

    +kssk AS ( SELECT objek, clint FROM kssk WHERE objek IN ( SELECT matnr FROM +mara ) ),
    +klah AS ( SELECT clint, class FROM klah ),
    +class_res AS (
      SELECT s~objek AS matnr, MIN( h~class ) AS class
        FROM +kssk AS s
        INNER JOIN +klah AS h ON h~clint = s~clint
       GROUP BY s~objek
    ),

    +cdpos_del AS (
      SELECT objectid, changenr
        FROM cdpos
       WHERE fname     = 'LVORM'
         AND value_new = 'X'
         AND tabname  IN ('MARA','MARC')
         AND objectid IN ( SELECT matnr FROM +mara )
    ),
    +cdhdr_del AS (
      SELECT objectid, changenr, username, udate, tcode
        FROM cdhdr
       WHERE changenr IN ( SELECT changenr FROM +cdpos_del )
    ),
    +del_latest AS (
      SELECT objectid, MAX( udate ) AS udate
        FROM +cdhdr_del
       GROUP BY objectid
    ),
    +del_info AS (
      SELECT d~objectid AS matnr, d~username, d~tcode, d~udate
        FROM +cdhdr_del AS d
        INNER JOIN +del_latest AS x
                ON x~objectid = d~objectid AND x~udate = d~udate
    ),

    +cdhdr_mm02 AS (
      SELECT objectid, udate
        FROM cdhdr
       WHERE objectid IN ( SELECT matnr FROM +mara )
         AND tcode = 'MM02'
    ),
    +mm02_latest AS (
      SELECT objectid AS matnr, MAX( udate ) AS udate
        FROM +cdhdr_mm02
       GROUP BY objectid
    )
*    ,
*    +ZSTR AS (
*      SELECT RECORD AS RECORD,
*             MATTXT,
*             SPAN FROM ZTB_STR
*             WHERE RECORD = '1'
*
*          )

  SELECT
      a~matnr,          "Ext.Material
      a~mtart,          "Mat.Type
      a~ersda,          "Created on
      a~ernam,          "Created by
      a~bismt,          "Old Mat Number
      a~extwg,          "Ex.Mat.Group
      a~matkl,          "Mat.group
      a~spart,          "Division
      a~brgew,          "Gross weight
      a~meins,          "UOM
      a~ntgew,          "Net Weight
      a~mtpos_mara,     "Item.Cat.Group
      a~tragr,          "Transport.Group
      a~magrv,          "Mat.Grp pack
      a~bstme,          "PO unit
      a~zseries,        "Series code
      a~zsize,          "Size
      a~brand,          "Brand
      a~moc,            "MOC
      a~type,           "TYPE
      a~qmpur,          "QM Proc.Active
      a~pstat,          "Maintain Status
      a~raube,          "Stor.Cond
      a~zeinr,          "Drawing no
      a~zeivr,          "REv.no

      a~maktx,         "Mat.Desc

      a~werks,         "Plant
      a~mtvfp,         "Availability check
      a~ladgr,
      a~prctr,
      a~sernp,
      a~ekgrp,
      a~dismm,
      a~dispo,
      a~bstmi,
      a~disls,
      a~beskz,
      a~sobsl,
      a~wzeit,
      a~plifz,
      a~fhori,
      a~strgr,
      a~vrmod,
      a~vint1,
      a~vint2,
      a~sbdkz,
      a~fevor,
      a~sfcpf,
      a~dzeit,
      a~ausme,
      a~losgr,
      a~steuc,

      a~ssqss,
      a~miskz,
      md1~lgort,
      md1~lgpbe,
      mvf~vkorg,
      mvf~vtweg,
      mvf~dwerk,
      mvf~versg,

      mvf~ktgrm,
      mvf~mtpos,
      ma~meinh,
      ma~umrez,
      ma~umren,
      mb~bklas,
      mb~vprsv,
      mb~verpr,
      mb~stprs,
      mb~ekalr,

      ml~taxm1,
      ml~taxm2,
      ml~taxm3,
      ml~taxm4,       "Tax classification 4

      ji~j_1icapind,      "Material Type
      ji~j_1isubind,      "Sub Contractor
      ji~j_1igrxref,      "GR per ei
      qm~art,         "Inspection type
      qm~aktiv,       "InsActive

      jv~j_1ivalass,
      jd~j_1imoom,
      au~stem       AS mattxt,      " placeholders to fill later
      au~stem       AS span,        " Placeholder for span text

      cl~class,
      au~stem,
      au~seat,
      au~body,
      au~disc,
      au~ball,
      au~rating,
      au~clas,
      au~air_f,
      au~main_air,

      a~lvorm,
      @lv_ref_d       AS ref,         " will be formatted on write
      a~bom,
      a~ncost,
      a~sobsk,

      CASE WHEN mf~rm01 = 1 THEN 'Yes' ELSE ' ' END AS rm01,
      CASE WHEN mf~fg01 = 1 THEN 'Yes' ELSE ' ' END AS fg01,
      CASE WHEN mf~prd1 = 1 THEN 'Yes' ELSE ' ' END AS prd1,
      CASE WHEN mf~rj01 = 1 THEN 'Yes' ELSE ' ' END AS rj01,
      CASE WHEN mf~rwk1 = 1 THEN 'Yes' ELSE ' ' END AS rwk1,
      CASE WHEN mf~scr1 = 1 THEN 'Yes' ELSE ' ' END AS scr1,
      CASE WHEN mf~sfg1 = 1 THEN 'Yes' ELSE ' ' END AS sfg1,
      CASE WHEN mf~srn1 = 1 THEN 'Yes' ELSE ' ' END AS srn1,
      CASE WHEN mf~vld1 = 1 THEN 'Yes' ELSE ' ' END AS vld1,
      CASE WHEN mf~plg1 = 1 THEN 'Yes' ELSE ' ' END AS plg1,
      CASE WHEN mf~tpi1 = 1 THEN 'Yes' ELSE ' ' END AS tpi1,
      CASE WHEN mf~sc01 = 1 THEN 'Yes' ELSE ' ' END AS sc01,
      CASE WHEN mf~spc1 = 1 THEN 'Yes' ELSE ' ' END AS spc1,
      CASE WHEN mf~slr1 = 1 THEN 'Yes' ELSE ' ' END AS slr1,

      CASE WHEN mvf~dis10_flag = 1 THEN 'Yes' ELSE ' ' END AS dis10,
      CASE WHEN mvf~dis20_flag = 1 THEN 'Yes' ELSE ' ' END AS dis20,
      CASE WHEN mvf~dis30_flag = 1 THEN 'Yes' ELSE ' ' END AS dis30,
      a~zzeds,
      a~zzmss,
      mvf~vmsta,
      tv~vmstb,
      dl~username,        "Deleted by
      dl~udate,           "Deleted on
      dl~tcode,           "Deleted via TCode
      ml~taxm8,
      a~cap_lead      AS cap,

      mb~zplp3,
      mb~zpld3,
      a~item_type,
      a~air_pressure,
      a~air_fail,
      a~actuator,
      a~vertical,
      CAST( mb~pprdl AS NUMC( 3 ) ) AS pprdl,
      mb~pdatl,
      mb~lplpr,
      CAST( mb~pprdv AS NUMC( 3 ) ) AS pprdv,
      mb~pdatv,
      mb~vplpr,
      a~kzkfg,

      mm~udate        AS modify_date,
      a~dev_status,
      a~zkanban,
      a~zpen_item,
      a~zre_pen_item,
*      mf~mcn1,
*      mf~pn01,
      CASE WHEN mf~mcn1 = 1 THEN 'Yes' ELSE ' ' END AS mcn1,
      CASE WHEN mf~pn01 = 1 THEN 'Yes' ELSE ' ' END AS pn01,
      a~qap_no        AS zqap,
      a~rev_no,
      CASE a~zboi WHEN 'Y' THEN 'Yes' ELSE ' ' END AS zboi,
      a~wrkst,
* Flags
     CASE WHEN  mf~kmcn = 1 THEN 'Yes' ELSE ' ' END AS kmcn,
     CASE WHEN  mf~kndt = 1 THEN 'Yes' ELSE ' ' END AS kndt,
     CASE WHEN       mf~kplg = 1 THEN 'Yes' ELSE ' ' END AS kplg,
     CASE WHEN       mf~kpr1 = 1 THEN 'Yes' ELSE ' ' END AS kpr1,
     CASE WHEN       mf~kprd = 1 THEN 'Yes' ELSE ' ' END AS kprd,
     CASE WHEN       mf~krj0 = 1 THEN 'Yes' ELSE ' ' END AS krj0,
     CASE WHEN       mf~krm0 = 1 THEN 'Yes' ELSE ' ' END AS krm0,
     CASE WHEN       mf~krwk = 1 THEN 'Yes' ELSE ' ' END AS krwk,
     CASE WHEN       mf~ksc0 = 1 THEN 'Yes' ELSE ' ' END AS ksc0,
     CASE WHEN       mf~kscr = 1 THEN 'Yes' ELSE ' ' END AS kscr,
     CASE WHEN       mf~ksfg = 1 THEN 'Yes' ELSE ' ' END AS ksfg,
     CASE WHEN       mf~kslr = 1 THEN 'Yes' ELSE ' ' END AS kslr,
     CASE WHEN       mf~kspc = 1 THEN 'Yes' ELSE ' ' END AS kspc,
     CASE WHEN       mf~ksrn = 1 THEN 'Yes' ELSE ' ' END AS ksrn,
     CASE WHEN       mf~ktpi = 1 THEN 'Yes' ELSE ' ' END AS ktpi,
     CASE WHEN       mf~kvld = 1 THEN 'Yes' ELSE ' ' END AS kvld,
     CASE WHEN       mf~kfg0 = 1 THEN 'Yes' ELSE ' ' END AS kfg0,

      a~zitem_class,

      @lv_ref_t       AS time

    FROM +mara         AS a
*    LEFT JOIN +makt    AS mk   ON mk~matnr   = a~matnr
*    LEFT JOIN +marc    AS mc   ON mc~matnr   = a~matnr
    LEFT JOIN +mard_one   AS md1  ON md1~matnr  = a~matnr
    LEFT JOIN +mard_flags AS mf   ON mf~matnr   = a~matnr
    LEFT JOIN +mvke_flags AS mvf  ON mvf~matnr  = a~matnr
    LEFT JOIN +tvmst      AS tv   ON tv~vmsta   = mvf~vmsta
    LEFT JOIN +marm_agg   AS ma   ON ma~matnr   = a~matnr AND ma~meinh <> a~meins
    LEFT JOIN +mbew       AS mb   ON mb~matnr   = a~matnr
    LEFT JOIN +mlan       AS ml   ON ml~matnr   = a~matnr
    LEFT JOIN +qmat       AS qm   ON qm~matnr   = a~matnr
    LEFT JOIN +j1imt      AS ji   ON ji~matnr   = a~matnr
    LEFT JOIN +j1iav      AS jv   ON jv~matnr   = a~matnr
    LEFT JOIN +j1imd      AS jd   ON jd~matnr   = a~matnr
    LEFT JOIN +ausp_pivot AS au   ON au~matnr   = a~matnr
    LEFT JOIN +class_res  AS cl   ON cl~matnr   = a~matnr
    LEFT JOIN +del_info   AS dl   ON dl~matnr   = a~matnr
    LEFT JOIN +mm02_latest AS mm  ON mm~matnr   = a~matnr
*    LEFT JOIN +ZSTR AS ZSTR ON ZSTR~RECORD = 1
  INTO TABLE @DATA(it_final_tmp).


  SORT it_final_tmp.
  DELETE ADJACENT DUPLICATES FROM it_final_tmp COMPARING ALL FIELDS.
  DELETE ADJACENT DUPLICATES FROM it_final_tmp COMPARING matnr.

* Temp code - Begin
  DATA: lt_final  TYPE tty_final,
        lwa_Final TYPE ty_final.
  LOOP AT it_final_Tmp INTO DATA(lwa_ftemp).
    MOVE-CORRESPONDING lwa_ftemp TO lwa_final.
* To remove thousand separator
*    lwa_final-STPRS = | { lwa_ftemp-STPRS DECIMALS = 2 } |.
* Dae formats
    PERFORM change_Date_format USING lwa_ftemp-ersda CHANGING lwa_final-ersda.
    PERFORM change_Date_format USING lwa_ftemp-ref CHANGING lwa_final-ref.

    PERFORM change_Date_format USING lwa_ftemp-zpld3  CHANGING lwa_final-zpld3.
    PERFORM change_Date_format USING lwa_ftemp-modify_date CHANGING lwa_final-modify_date.
    PERFORM change_Date_format USING lwa_ftemp-udate CHANGING lwa_final-udate.

* To remove thousand separator
    WRITE lwa_ftemp-verpr TO lwa_final-verpr NO-GROUPING.
    WRITE lwa_ftemp-stprs TO lwa_final-stprs NO-GROUPING.
    WRITE lwa_ftemp-j_1ivalass TO lwa_final-j_1ivalass NO-GROUPING.
    WRITE lwa_ftemp-zplp3 TO lwa_final-zplp3 NO-GROUPING.
    WRITE lwa_ftemp-lplpr TO lwa_final-lplpr NO-GROUPING.
    WRITE lwa_ftemp-vplpr TO lwa_final-vplpr NO-GROUPING.

    APPEND lwa_final TO lt_final.
    CLEAR: lwa_final.
  ENDLOOP.
* Temp code - End


  " keep whole result in a data ref for SALV/Download
*  CREATE DATA gt_final LIKE it_final_tmp.
  CREATE DATA gt_final LIKE lt_final.
  ASSIGN gt_final->* TO FIELD-SYMBOL(<gt_final>).

** To clear two of string fields to initial
*  it_final_tmp = VALUE #( LET it_final_T = it_final_tmp IN FOR <fs_tmp> IN
*                                         it_final_t ( VALUE #( BASE <fs_tmp> mattxt = '' span = '' ) ) ).

  lt_final = VALUE #( LET it_final_T = lt_final IN FOR <fs_tmp> IN
                                          it_final_t ( VALUE #( BASE <fs_tmp> mattxt = '' span = '' ) ) ).
  <gt_final> = lt_final.

  "---------------- Post-processing: long texts, small clean-ups -------
  LOOP AT <gt_final> ASSIGNING FIELD-SYMBOL(<row>).

    " Long text EN -> MATTXT
    ASSIGN COMPONENT 'MATNR'  OF STRUCTURE <row> TO FIELD-SYMBOL(<matnr>).
    ASSIGN COMPONENT 'MATTXT' OF STRUCTURE <row> TO FIELD-SYMBOL(<mattxt>).
    IF <matnr> IS ASSIGNED AND <mattxt> IS ASSIGNED.
      CLEAR: <mattxt>, gt_tline.
      gv_tdname = <matnr>.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client   = sy-mandt
          id       = 'GRUN'
          language = sy-langu
          name     = gv_tdname
          object   = 'MATERIAL'
        TABLES
          lines    = gt_tline
        EXCEPTIONS
          OTHERS   = 8.
      IF gt_tline IS NOT INITIAL.
        LOOP AT gt_tline INTO gs_tline.
          IF gs_tline-tdline IS NOT INITIAL.
            REPLACE ALL OCCURRENCES OF '<(>' IN gs_tline-tdline WITH space.
            REPLACE ALL OCCURRENCES OF '<)>' IN gs_tline-tdline WITH space.
            IF <mattxt> IS INITIAL.
              <mattxt> = gs_tline-tdline.
            ELSE.
              CONCATENATE <mattxt> gs_tline-tdline INTO <mattxt> SEPARATED BY space.
            ENDIF.
          ENDIF.
        ENDLOOP.
        CONDENSE <mattxt>.
      ENDIF.
    ENDIF.

    " Long text Spanish 'S' -> SPAN
    ASSIGN COMPONENT 'SPAN' OF STRUCTURE <row> TO FIELD-SYMBOL(<span>).
    IF <span> IS ASSIGNED AND <matnr> IS ASSIGNED.
      CLEAR: <span>, gt_tline.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client   = sy-mandt
          id       = 'GRUN'
          language = 'S'
          name     = gv_tdname
          object   = 'MATERIAL'
        TABLES
          lines    = gt_tline
        EXCEPTIONS
          OTHERS   = 8.
      IF gt_tline IS NOT INITIAL.
        LOOP AT gt_tline INTO gs_tline.
          IF gs_tline-tdline IS NOT INITIAL.
            IF <span> IS INITIAL.
              <span> = gs_tline-tdline.
            ELSE.
              CONCATENATE <span> gs_tline-tdline INTO <span> SEPARATED BY space.
            ENDIF.
          ENDIF.
        ENDLOOP.
        CONDENSE <span>.
      ENDIF.
    ENDIF.

    " Trim weird leading newline (as per your SOC)
    IF <matnr> IS ASSIGNED AND <matnr>+0(1) = cl_abap_char_utilities=>newline.
      SHIFT <matnr> LEFT BY 1 PLACES.
    ENDIF.
    ASSIGN COMPONENT 'J_1IMOOM' OF STRUCTURE <row> TO FIELD-SYMBOL(<oom>).
    IF <oom> IS ASSIGNED AND <oom>+0(1) = cl_abap_char_utilities=>newline.
      SHIFT <oom> LEFT BY 1 PLACES.
    ENDIF.

* ALPHA conversion exit
*  PERFORM convert_alpha.
*    ASSIGN COMPONENT 'PRCTR' OF STRUCTURE <row> TO FIELD-SYMBOL(<f10>).
*    IF <f10> IS ASSIGNED.
*      <f10> = | { <f10> ALPHA = IN } |.
*    ENDIF.
  ENDLOOP.

  CHECK <gt_final> IS ASSIGNED.
*  iT_FINAL_tmp = <gt_final>.
  lT_FINAL = <gt_final>.

  CLEAR: gt_csv.
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
*   EXPORTING
*     I_FIELD_SEPERATOR          =
*     I_LINE_HEADER              =
*     I_FILENAME                 =
*     I_APPL_KEEP                = ' '
    TABLES
*     i_tab_sap_data       = it_final_tmp
      i_tab_sap_data       = lt_final
    CHANGING
      i_tab_converted_data = gT_CSV
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.
  IF sy-subrc <> 0.
*    Implement SUITABLE ERROR HANDLING HERE
  ENDIF.
ENDFORM.

"======================================================================
" SALV display (no field catalog required)
"======================================================================
FORM show_salv.
  DATA: lo_cols TYPE REF TO cl_salv_columns_table.
  ASSIGN gt_final->* TO FIELD-SYMBOL(<tab>).
  IF <tab> IS ASSIGNED.
    TRY.
        DATA: lo_alv TYPE REF TO cl_salv_table.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = lo_alv
          CHANGING
            t_table      = <tab> ).

        lo_alv->get_functions( )->set_all( abap_true ).

        lo_cols = lo_alv->get_columns( ).
        PERFORM add_field_labels CHANGING lo_cols.

        lo_cols->set_optimize( abap_true ).

        " Add record count to title
        DATA(lv_count) = lines( <tab> ).
        DATA(lo_disp) = lo_alv->get_display_settings( ).

        lo_disp->set_list_header( |Item Master Report: Lines #{ lv_count }| ).

        lo_alv->display( ).
      CATCH cx_salv_msg INTO DATA(lx).
        MESSAGE lx->get_text( ) TYPE 'E'.
    ENDTRY.
  ENDIF.
ENDFORM.

"======================================================================
" Download to TXT with header & smart DATS/TIMS formatting
"======================================================================
FORM download USING p_folder TYPE rlgrap-filename.
  TYPE-POOLS truxs.
  DATA: it_csv TYPE truxs_t_text_data,
*        WA_CSV TYPE LINE OF TRUXS_T_TEXT_DATA,
        hd_csv TYPE LINE OF truxs_t_text_data.
  DATA: lv_cell TYPE string,
        lv_d    TYPE dats,
        lv_t    TYPE tims,
        lv_line TYPE string,
        lv_crlf TYPE string.

  ASSIGN gt_final->* TO FIELD-SYMBOL(<tab>).
  IF <tab> IS NOT ASSIGNED OR <tab> IS INITIAL.
    MESSAGE 'No data to download' TYPE 'I'.
    RETURN.
  ENDIF.

  CLEAR: lv_line.
  lv_crlf = cl_abap_char_utilities=>cr_lf.
  LOOP AT gT_CSV INTO DATA(wa_csv).
    IF sy-tabix = 1.
      CONCATENATE LV_line wa_csv INTO LV_line.
    ELSE.
      CONCATENATE LV_line lv_crlf wa_csv INTO LV_line.
    ENDIF.
    CLEAR: wa_csv.
  ENDLOOP.

  DATA lv_fullfile TYPE string.
  CONCATENATE p_folder '/ZITEM1.TXT' INTO lv_fullfile.

  " Build header like your original (labels in the intended order)
  DATA(lv_header) = VALUE string( ).
  PERFORM cvs_header USING lv_header.

* Delete if exists on AL11
  DELETE DATASET lv_fullfile.

  OPEN DATASET lv_fullfile FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc <> 0.
    MESSAGE |Cannot open { lv_fullfile }| TYPE 'E'.
    RETURN.
  ENDIF.

  " write header (unless hidden)
  IF p_hidden IS INITIAL.
    TRANSFER lv_header TO lv_fullfile.
  ENDIF.

  " loop table and dump rows tab-separated
  FIELD-SYMBOLS <wa> TYPE any.
  FIELD-SYMBOLS: <comp> TYPE any,
                 <c>    TYPE abap_componentdescr..

*  LOOP AT <TAB> ASSIGNING <WA>.
*
*    " describe structure and get components (note the CAST!)
**    DATA(LO_STRUC) = CAST cl_abap_structdescr( CL_ABAP_STRUCTDESCR=>DESCRIBE_BY_DATA( <WA> ) ).
*    DATA(LO_STRUC) = CAST CL_ABAP_STRUCTDESCR(
*                         CL_ABAP_TYPEDESCR=>DESCRIBE_BY_DATA( <WA> ) ).
*    DATA(LT_COMP)  = LO_STRUC->GET_COMPONENTS( ).
*
*    LOOP AT LT_COMP ASSIGNING <C>.
*      ASSIGN COMPONENT <C>-NAME OF STRUCTURE <WA> TO <COMP>.
*
*      IF <COMP> IS ASSIGNED.
*        " pretty date/time on write
*        CASE <C>-TYPE->TYPE_KIND.
*          WHEN CL_ABAP_TYPEDESCR=>TYPEKIND_DATE.    " DATS
*            IF <COMP> IS NOT INITIAL.
*              LV_D = <COMP>.
*              CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
*                EXPORTING
*                  INPUT  = LV_D
*                IMPORTING
*                  OUTPUT = LV_CELL.
*              CONCATENATE LV_CELL+0(2) LV_CELL+2(3) LV_CELL+5(4) INTO LV_CELL SEPARATED BY '-'.
*            ENDIF.
*          WHEN CL_ABAP_TYPEDESCR=>TYPEKIND_TIME.    " TIMS
*            IF <COMP> IS NOT INITIAL.
*              LV_T = <COMP>.
*              CONCATENATE LV_T+0(2) LV_T+2(2) INTO LV_CELL SEPARATED BY ':'.
*            ENDIF.
*          WHEN OTHERS.
*            LV_CELL = |{ <COMP> }|.
*        ENDCASE.
*      ENDIF.
*
*      DATA(LV_SEP) = CL_ABAP_CHAR_UTILITIES=>HORIZONTAL_TAB.
*      CONCATENATE LV_LINE LV_SEP LV_CELL INTO LV_LINE.
*
*    ENDLOOP.
*
*    TRANSFER LV_LINE TO LV_FULLFILE.
*    CLEAR: LV_LINE.
*  ENDLOOP.
  TRANSFER lv_line TO lv_fullfile.
  CLOSE DATASET lv_fullfile.
  MESSAGE |File { lv_fullfile } downloaded| TYPE 'S'.

ENDFORM.

"======================================================================
" Header builder (same friendly labels as your original)
"======================================================================
FORM cvs_header USING    pv_header TYPE string.
  DATA sep TYPE c VALUE cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE
    'Ext.Mat.No.'              'Material Type'        'Created On'            'Created By'
    'Old material number'      'Ext.Material Group'   'Material Group'        'Divis'
    'Gross Weight'             'Base Unit of Measure' 'Net Weight'            'Gen.item cat.group'
    'Transportation Group'     'Matl.Grp.Pack.Matls'  'Purc.Ord.Unit'         'series code'
    'Size'                     'Brand'                'MOC'                   'TYPE'
    'QM proc active'           'Mainten status'       'Stor.cond'             'Drawing No'
    'Rev.No'                   'Mat.Descr'            'Plant'                 'Avail.Chk'
    'Load.Group'               'Profit Center'        'Ser.No.Prof'           'Pur.Group'
    'MRP Type'                 'MRP Cont'             'Min.Ord.Quntity'       'Lot size'
    'Procur.Type'              'Spec.proc.type'       'Repl.Lead Time'        'Plan.Del.Time'
    'Sched.Margin'             'strat.group'          'Consum.mode'           'Consum.peri backward'
    'Consum.peri forward'      'Indi/Coll'            'Prod.Sched'            'Prod.Sched.Prof'
    'Prod.Time'                'Unit of issue'        'Costing Lot Size'      'HSN Code'
    'QM Cont.Key'              'Mix.MRP.Ind'          'Stor.Loc'              'Stor.Bin'
    'Sale.Org.'                'Dist.Chan'            'Deli.Plant'            'Mate.stat.group'
    'Ac.Ass'                   'Itm.Cat.grp'          'Alt.UOM'               'Conv Factor'
    'Den.conv'                 'Val.Class'            'Pri.cont.ind'          'Mov.price'
    'Stand.price'              'With Qty Struc'       'Tax clas.mat'          'Tax clas.mat'
    'Tax clas.mat'             'Tax clas.mat'         'Mat.Type'              'Subcontractors'
    'No.of GR per.EI'          'Ins.Type'             'Ins.Active'            'Assessable Value'
    'Output Mat.'              'Long Text'                "'Item.Span.Text'
    'Class'                'Stem'                  'Seat'
    'Body'                     'Disc'                 'Ball'                  'Rating'
    'Class'                    'Air_Fail_Position'    'Min_Air_Pressure'
    'Deletion Ind'             'Refresh File Date'    'BOM Status'            'Do Not Cost'
    'SpecProcurem Costing'
    'RM01' 'FG01' 'PRD1' 'RJ01' 'RWK1' 'SCR1' 'SFG1' 'SRN1' 'VLD1' 'PLG1' 'TPI1' 'SC01' 'SPC1' 'SLR1'
    'Dis.Ch.10' 'Dis.Ch.20' 'Dis.Ch.30' 'EDS' 'MSS' 'Dst.chl.loc' 'Dst.chl.loc Desc'
    'Deleted By' 'Deleted On' 'T-code' 'Tax clas.mat' 'CAP Lead Time' 'Planned Price 3' 'Planned Price Date'
    'Item Type' 'Min Air Supply Pressure' 'Air fail position' 'Actuator sizing done on diff. Pressure' 'Vertical'
    'Current Period' 'Current Fiscal Year' 'Current Planned Price' 'Perivoius Period' 'Previous Fiscal Year' 'Previous Planned Price'
    'Material is Configurable' 'Modify Date' 'Development Status' 'KANBAN Item' 'Pending Item' 'Reason for Pending Item'
    'MCN1' 'PN01' 'QAP Number' 'Revision No.' 'Bought Out Item'
    'Refreshable Time'
    'Basic Material'
    'KMCN' 'KNDT' 'KPLG' 'KPR1' 'KPRD' 'KRJ0' 'KRM0' 'KRWK' 'KSC0' 'KSCR' 'KSFG' 'KSLR' 'KSPC' 'KSRN' 'KTPI' 'KVLD' 'KFG0'
    'ITEM CLASS'
    'Item.Span.txt'
    INTO pv_header SEPARATED BY sep.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_FIELD_LABELS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LO_COLS
*&---------------------------------------------------------------------*
FORM add_field_labels  CHANGING pc_cols TYPE REF TO cl_salv_columns_table.
  DATA: lo_col TYPE REF TO cl_salv_column.
  TRY.
*      pc_cols->set_key_fixation( abap_true ).

*      pc_cols->get_column( 'MATNR' )->set_k
      pc_cols->get_column( 'MATNR' )->set_Short_text( 'Ext.Mat' ).
      pc_cols->get_column( 'MATNR' )->set_long_text( 'Ext.Mat.No.' ).
      pc_cols->get_column( 'MTART' )->set_short_text( 'Mat.Type' ).
      pc_cols->get_column( 'ERSDA' )->set_short_text( 'Created On' ).
      pc_cols->get_column( 'ERNAM' )->set_short_text( 'CreatedBy' ).
      pc_cols->get_column( 'BISMT' )->set_short_text( 'Old.MatNo' ).
      pc_cols->get_column( 'EXTWG' )->set_short_text( 'Ex.MatGrp' ).
      pc_cols->get_column( 'EXTWG' )->set_long_text( 'Ext.Material Group' ).
      pc_cols->get_column( 'MATKL' )->set_short_text( 'Mat.Group' ).
      pc_cols->get_column( 'SPART' )->set_short_text( 'Divis' ).
      pc_cols->get_column( 'SPART' )->set_Medium_text( 'Divis' ).
      pc_cols->get_column( 'SPART' )->set_long_text( 'Divis' ).
*      pc_cols->get_column( 'BRGEW' )->set_short_text( 'GrossWt.' ).
      lo_col = pc_cols->get_column( 'BRGEW' ).
      lo_col->set_short_text( 'GrossWt.' ).
*      lo_col->set_edit_mask( '==FLTPC' ).         "To remove thousand separator
      lo_col->set_edit_mask( '==DECZE' ).         "To remove thousand separator

      pc_cols->get_column( 'MEINS' )->set_short_text( 'BaseUOM' ).
*      pc_cols->get_column( 'NTGEW' )->set_short_text( 'Net.Wt' ).
      lo_col = pc_cols->get_column( 'NTGEW' ).
      lo_col->set_short_text( 'Net.Wt' ).
*      lo_col->set_edit_mask( '==FLTPC' ).         "To remove thousand separator
      lo_col->set_edit_mask( '==DECZE' ).         "To remove thousand separator
      pc_cols->get_column( 'MTPOS_MARA' )->set_short_text( 'Itm.CatGrp' ).
      pc_cols->get_column( 'MTPOS_MARA' )->set_Medium_text( 'Gen.item cat.group' ).
      pc_cols->get_column( 'MTPOS_MARA' )->set_Long_text( 'Gen.item cat.group' ).
      pc_cols->get_column( 'TRAGR' )->set_short_text( 'TRPT.Group' ).
      pc_cols->get_column( 'MAGRV' )->set_short_text( 'MatGrpPK' ).
      pc_cols->get_column( 'MAGRV' )->set_Medium_text( 'Matl.Grp.Pack.Matls' ).
      pc_cols->get_column( 'MAGRV' )->set_Long_text( 'Matl.Grp.Pack.Matls' ).
      pc_cols->get_column( 'BSTME' )->set_short_text( 'PO.Unit' ).
      pc_cols->get_column( 'BSTME' )->set_medium_text( 'Purc.Ord.Unit' ).
      pc_cols->get_column( 'BSTME' )->set_long_text( 'Purc.Ord.Unit' ).
      pc_cols->get_column( 'ZSERIES' )->set_short_text( 'SeriesCd' ).
      pc_cols->get_column( 'ZSIZE' )->set_short_text( 'Size' ).
      pc_cols->get_column( 'BRAND' )->set_short_text( 'Brand' ).
      pc_cols->get_column( 'MOC' )->set_short_text( 'MoC' ).
      pc_cols->get_column( 'TYPE' )->set_short_text( 'Type' ).
      pc_cols->get_column( 'QMPUR' )->set_short_text( 'QMPRActiv' ).
      pc_cols->get_column( 'QMPUR' )->set_medium_text( 'QM proc active' ).
      pc_cols->get_column( 'QMPUR' )->set_long_text( 'QM proc active' ).
      pc_cols->get_column( 'PSTAT' )->set_short_text( 'Maint.Stat' ).
      pc_cols->get_column( 'PSTAT' )->set_Medium_text( 'Mainten status' ).
      pc_cols->get_column( 'PSTAT' )->set_long_text( 'Mainten status' ).
      pc_cols->get_column( 'RAUBE' )->set_short_text( 'Stor.Cond' ).
      pc_cols->get_column( 'RAUBE' )->set_Medium_text( 'Stor.cond' ).
      pc_cols->get_column( 'RAUBE' )->set_Long_text( 'Stor.cond' ).
      pc_cols->get_column( 'ZEINR' )->set_short_text( 'DrawngNo' ).
      pc_cols->get_column( 'ZEINR' )->set_Medium_text( 'Drawing No' ).
      pc_cols->get_column( 'ZEINR' )->set_Long_text( 'Drawing No' ).
      pc_cols->get_column( 'ZEIVR' )->set_short_text( 'Rev.No' ).
      pc_cols->get_column( 'ZEIVR' )->set_Medium_text( 'Rev.No' ).
      pc_cols->get_column( 'ZEIVR' )->set_Long_text( 'Rev.No' ).
      pc_cols->get_column( 'MAKTX' )->set_short_text( 'Mat.Descr' ).
      pc_cols->get_column( 'MAKTX' )->set_long_text( 'Mat.Descr' ).
      pc_cols->get_column( 'WERKS' )->set_short_text( 'Plant' ).
      pc_cols->get_column( 'MTVFP' )->set_short_text( 'Avail.Chk' ).
      pc_cols->get_column( 'MTVFP' )->set_long_text( 'Avail.Chk' ).
* 7 rows
      pc_cols->get_column( 'LADGR' )->set_short_text( 'Load.Group' ).
      pc_cols->get_column( 'LADGR' )->set_long_text( 'Load.Group' ).
*      pc_cols->get_column( 'PRCTR' )->set_medium_text( 'Profit Center' ).
      lo_col = pc_cols->get_column( 'PRCTR' ).
      lo_col->set_medium_text( 'Profit Center' ).
*      lo_col->set_leading_zero( abap_true ).
      lo_col->set_edit_mask( '' ).
      pc_cols->get_column( 'SERNP' )->set_medium_text( 'Ser.No.Prof' ).
      pc_cols->get_column( 'SERNP' )->set_Long_text( 'Ser.No.Prof' ).
      pc_cols->get_column( 'EKGRP' )->set_medium_text( 'Pur.Group' ).
      pc_cols->get_column( 'EKGRP' )->set_long_text( 'Pur.Group' ).
      pc_cols->get_column( 'DISMM' )->set_medium_text( 'MRP Type' ).
      pc_cols->get_column( 'DISPO' )->set_long_text( 'MRP Cont' ).
*      pc_cols->get_column( 'BSTMI' )->set_medium_text( 'Min.Ord.Quntity' ).
      lo_col = pc_cols->get_column( 'BSTMI' ).
      lo_col->set_long_text( 'Min.Ord.Quntity' ).
*      lo_col->set_edit_mask( '==FLTPC' ).         "To remove thousand separator
      lo_col->set_edit_mask( '==DECZE' ).         "To remove thousand separator
      pc_cols->get_column( 'DISLS' )->set_long_text( 'Lot size' ).

      pc_cols->get_column( 'BESKZ' )->set_long_text( 'Procur.Type' ).
      pc_cols->get_column( 'SOBSL' )->set_long_text( 'Spec.proc.type' ).
      pc_cols->get_column( 'WZEIT' )->set_long_text( 'Repl.Lead Time' ).
      pc_cols->get_column( 'PLIFZ' )->set_long_text( 'Plan.Del.Time' ).
      pc_cols->get_column( 'FHORI' )->set_long_text( 'Sched.Margin' ).
      pc_cols->get_column( 'STRGR' )->set_long_text( 'Strat.group' ).
      pc_cols->get_column( 'VRMOD' )->set_long_text( 'Consum.mode' ).
      pc_cols->get_column( 'VINT1' )->set_long_text( 'Consum.peri backward' ).

      pc_cols->get_column( 'VINT2' )->set_long_text( 'Consum.peri forward' ).
      pc_cols->get_column( 'SBDKZ' )->set_long_text( 'Indi/Coll' ).
      pc_cols->get_column( 'FEVOR' )->set_long_text( 'Prod.Sched' ).
      pc_cols->get_column( 'SFCPF' )->set_long_text( 'Prod.Sched.Prof' ).
      pc_cols->get_column( 'DZEIT' )->set_long_text( 'Prod.Time' ).
      pc_cols->get_column( 'AUSME' )->set_long_text( 'Unit of issue' ).
      pc_cols->get_column( 'LOSGR' )->set_long_text( 'Costing Lot Size' ).
      pc_cols->get_column( 'STEUC' )->set_long_text( 'HSN Code' ).

      pc_cols->get_column( 'SSQSS' )->set_long_text( 'QM Cont.Key' ).
      pc_cols->get_column( 'MISKZ' )->set_long_text( 'Mix.MRP.Ind' ).
      pc_cols->get_column( 'LGORT' )->set_long_text( 'Stor.Loc' ).
      pc_cols->get_column( 'LGPBE' )->set_long_text( 'Stor.Bin' ).
      pc_cols->get_column( 'VKORG' )->set_long_text( 'Sale.Org.' ).
      pc_cols->get_column( 'VTWEG' )->set_long_text( 'Dist.Chan' ).
      pc_cols->get_column( 'DWERK' )->set_long_text( 'Deli.Plant' ).
      pc_cols->get_column( 'VERSG' )->set_long_text( 'Mate.Stat.group' ).

      pc_cols->get_column( 'KTGRM' )->set_long_text( 'Ac.Ass' ).
      pc_cols->get_column( 'MTPOS' )->set_long_text( 'Itm.Cat.grp' ).
      pc_cols->get_column( 'MEINH' )->set_long_text( 'Alt.UOM' ).
      pc_cols->get_column( 'UMREZ' )->set_long_text( 'Conv Factor' ).
      pc_cols->get_column( 'UMREN' )->set_long_text( 'Den.conv' ).
      pc_cols->get_column( 'BKLAS' )->set_long_text( 'Val.Class' ).
      pc_cols->get_column( 'VPRSV' )->set_long_text( 'Pri.cont.ind' ).
*      pc_cols->get_column( 'VERPR' )->set_medium_text( 'Mov.price' ).
      lo_col = pc_cols->get_column( 'VERPR' ).
      lo_col->set_short_text( 'Mov.price' ).
      lo_col->set_medium_text( 'Mov.price' ).
      lo_col->set_long_text( 'Mov.price' ).
*      lo_col->set_edit_mask( '==FLTPC' ).         "To remove thousand separator
      lo_col->set_edit_mask( '==DECZE' ).         "To remove thousand separator

*      pc_cols->get_column( 'STPRS' )->set_medium_text( 'Stand.price' ).
      lo_col = pc_cols->get_column( 'STPRS' ).
      lo_col->set_short_text( 'Stand.pric' ).
      lo_col->set_medium_text( 'Stand.price' ).
      lo_col->set_long_text( 'Stand.price' ).
*      lo_col->set_edit_mask( '==FLTPC' ).           "To remove thousand separator
      lo_col->set_edit_mask( '==DECZE' ).           "To remove thousand separator

      pc_cols->get_column( 'EKALR' )->set_long_text( 'With Qty Struc' ).
      pc_cols->get_column( 'TAXM1' )->set_long_text( 'Tax clas.mat' ).
      pc_cols->get_column( 'TAXM2' )->set_long_text( 'Tax clas.mat' ).
      pc_cols->get_column( 'TAXM3' )->set_long_text( 'Tax clas.mat' ).
      pc_cols->get_column( 'TAXM4' )->set_long_text( 'Tax clas.mat' ).
      pc_cols->get_column( 'J_1ICAPIND' )->set_long_text( 'Mat.Type' ).
      pc_cols->get_column( 'J_1ISUBIND' )->set_long_text( 'Subcontractors' ).
      pc_cols->get_column( 'J_1IGRXREF' )->set_long_text( 'No.of GR per.EI' ).
      pc_cols->get_column( 'ART' )->set_long_text( 'Ins.Type' ).
      pc_cols->get_column( 'AKTIV' )->set_long_text( 'Ins.Active' ).
*      pc_cols->get_column( 'J_1IVALASS' )->set_medium_text( 'Assessable Value' ).
      lo_col = pc_cols->get_column( 'J_1IVALASS' ).
      lo_col->set_short_text( 'AssesVal' ).
      lo_col->set_medium_text( 'Assessable Value' ).
      lo_col->set_long_text( 'Assessable Value' ).
*      lo_col->set_edit_mask( '==FLTPC' ).         "To remove thousand separator
      lo_col->set_edit_mask( '==DECZE' ).         "To remove thousand separator
      pc_cols->get_column( 'J_1IMOOM' )->set_long_text( 'Output Mat.' ).

      pc_cols->get_column( 'MATTXT' )->set_medium_text( 'Long Text' ).
      pc_cols->get_column( 'MATTXT' )->set_long_text( 'Long Text' ).
      pc_cols->get_column( 'MATTXT' )->set_output_length( 100 ).
      pc_cols->get_column( 'SPAN' )->set_medium_text( 'Item.Span.txt' ).
      pc_cols->get_column( 'SPAN' )->set_long_text( 'Item.Span.txt' ).
      pc_cols->get_column( 'SPAN' )->set_output_length( 100 ).

      pc_cols->get_column( 'CLASS' )->set_short_text( 'Class' ).
      pc_cols->get_column( 'CLASS' )->set_medium_text( 'Class' ).
      pc_cols->get_column( 'CLASS' )->set_long_text( 'Class' ).
      pc_cols->get_column( 'STEM' )->set_short_text( 'Stem' ).
      pc_cols->get_column( 'STEM' )->set_medium_text( 'Stem' ).
      pc_cols->get_column( 'STEM' )->set_long_text( 'Stem' ).
      pc_cols->get_column( 'SEAT' )->set_short_text( 'Seat' ).
      pc_cols->get_column( 'SEAT' )->set_medium_text( 'Seat' ).
      pc_cols->get_column( 'SEAT' )->set_long_text( 'Seat' ).
      pc_cols->get_column( 'BODY' )->set_short_text( 'Body' ).
      pc_cols->get_column( 'BODY' )->set_medium_text( 'Body' ).
      pc_cols->get_column( 'BODY' )->set_long_text( 'Body' ).
      pc_cols->get_column( 'DISC' )->set_short_text( 'Disc' ).
      pc_cols->get_column( 'DISC' )->set_medium_text( 'Disc' ).
      pc_cols->get_column( 'DISC' )->set_long_text( 'Disc' ).
      pc_cols->get_column( 'BALL' )->set_short_text( 'Ball' ).
      pc_cols->get_column( 'BALL' )->set_medium_text( 'Ball' ).
      pc_cols->get_column( 'BALL' )->set_long_text( 'Ball' ).
      pc_cols->get_column( 'RATING' )->set_short_text( 'Rating' ).
      pc_cols->get_column( 'RATING' )->set_medium_text( 'Rating' ).
      pc_cols->get_column( 'RATING' )->set_long_text( 'Rating' ).
      pc_cols->get_column( 'CLAS' )->set_short_text( 'Class' ).
      pc_cols->get_column( 'CLAS' )->set_medium_text( 'Class' ).
      pc_cols->get_column( 'CLAS' )->set_long_text( 'Class' ).
      pc_cols->get_column( 'AIR_F' )->set_short_text( 'AirFailPos' ).
      pc_cols->get_column( 'AIR_F' )->set_medium_text( 'Air_Fail_Position' ).
      pc_cols->get_column( 'AIR_F' )->set_long_text( 'Air_Fail_Position' ).
      pc_cols->get_column( 'MAIN_AIR' )->set_short_text( 'MinAirPre' ).
      pc_cols->get_column( 'MAIN_AIR' )->set_medium_text( 'Min_Air_Pressure' ).
      pc_cols->get_column( 'MAIN_AIR' )->set_long_text( 'Min_Air_Pressure' ).
      pc_cols->get_column( 'LVORM' )->set_short_text( 'Del.Ind' ).
      pc_cols->get_column( 'LVORM' )->set_medium_text( 'Deletion Ind' ).
      pc_cols->get_column( 'LVORM' )->set_long_text( 'Deletion Ind' ).
      pc_cols->get_column( 'REF' )->set_medium_text( 'Refresh File Date' ).
      pc_cols->get_column( 'REF' )->set_long_text( 'Refresh File Date' ).
      pc_cols->get_column( 'BOM' )->set_medium_text( 'BOM Status' ).
      pc_cols->get_column( 'BOM' )->set_long_text( 'BOM Status' ).
      pc_cols->get_column( 'NCOST' )->set_medium_text( 'Do Not Cost' ).
      pc_cols->get_column( 'NCOST' )->set_long_text( 'Do Not Cost' ).
      pc_cols->get_column( 'SOBSK' )->set_medium_text( 'SpecProcurem Costing' ).
      pc_cols->get_column( 'SOBSK' )->set_long_text( 'SpecProcurem Costing' ).

      pc_cols->get_column( 'RM01' )->set_short_text( 'RM01' ).
      pc_cols->get_column( 'RM01' )->set_medium_text( 'RM01' ).
      pc_cols->get_column( 'RM01' )->set_long_text( 'RM01' ).
      pc_cols->get_column( 'FG01' )->set_short_text( 'FG01' ).
      pc_cols->get_column( 'FG01' )->set_medium_text( 'FG01' ).
      pc_cols->get_column( 'FG01' )->set_long_text( 'FG01' ).
      pc_cols->get_column( 'PRD1' )->set_short_text( 'PRD1' ).
      pc_cols->get_column( 'PRD1' )->set_medium_text( 'PRD1' ).
      pc_cols->get_column( 'PRD1' )->set_long_text( 'PRD1' ).
      pc_cols->get_column( 'RJ01' )->set_short_text( 'RJ01' ).
      pc_cols->get_column( 'RJ01' )->set_long_text( 'RJ01' ).
      pc_cols->get_column( 'RWK1' )->set_short_text( 'RWK1' ).
      pc_cols->get_column( 'RWK1' )->set_long_text( 'RWK1' ).
      pc_cols->get_column( 'SCR1' )->set_short_text( 'SCR1' ).
      pc_cols->get_column( 'SCR1' )->set_long_text( 'SCR1' ).
      pc_cols->get_column( 'SFG1' )->set_short_text( 'SFG1' ).
      pc_cols->get_column( 'SFG1' )->set_long_text( 'SFG1' ).
      pc_cols->get_column( 'SRN1' )->set_short_text( 'SRN1' ).
      pc_cols->get_column( 'SRN1' )->set_long_text( 'SRN1' ).
      pc_cols->get_column( 'VLD1' )->set_short_text( 'VLD1' ).
      pc_cols->get_column( 'VLD1' )->set_long_text( 'VLD1' ).
      pc_cols->get_column( 'PLG1' )->set_short_text( 'PLG1' ).
      pc_cols->get_column( 'PLG1' )->set_long_text( 'PLG1' ).
      pc_cols->get_column( 'TPI1' )->set_short_text( 'TPI1' ).
      pc_cols->get_column( 'TPI1' )->set_long_text( 'TPI1' ).
      pc_cols->get_column( 'SC01' )->set_short_text( 'SC01' ).
      pc_cols->get_column( 'SC01' )->set_long_text( 'SC01' ).
      pc_cols->get_column( 'SPC1' )->set_short_text( 'SPC1' ).
      pc_cols->get_column( 'SPC1' )->set_long_text( 'SPC1' ).
      pc_cols->get_column( 'SLR1' )->set_short_text( 'SLR1' ).
      pc_cols->get_column( 'SLR1' )->set_long_text( 'SLR1' ).

      pc_cols->get_column( 'DIS10' )->set_short_text( 'Dis.Ch.10' ).
      pc_cols->get_column( 'DIS10' )->set_medium_text( 'Dis.Ch.10' ).
      pc_cols->get_column( 'DIS10' )->set_long_text( 'Dis.Ch.10' ).
      pc_cols->get_column( 'DIS20' )->set_short_text( 'Dis.Ch.20' ).
      pc_cols->get_column( 'DIS20' )->set_medium_text( 'Dis.Ch.20' ).
      pc_cols->get_column( 'DIS20' )->set_long_text( 'Dis.Ch.20' ).
      pc_cols->get_column( 'DIS30' )->set_short_text( 'Dis.Ch.30' ).
      pc_cols->get_column( 'DIS30' )->set_medium_text( 'Dis.Ch.30' ).
      pc_cols->get_column( 'DIS30' )->set_long_text( 'Dis.Ch.30' ).
      pc_cols->get_column( 'ZZEDS' )->set_long_text( 'EDS' ).
      pc_cols->get_column( 'ZZMSS' )->set_long_text( 'MSS' ).
      pc_cols->get_column( 'VMSTA' )->set_short_text( 'DstChlLc' ).
      pc_cols->get_column( 'VMSTA' )->set_medium_text( 'Dst.chl.loc' ).
      pc_cols->get_column( 'VMSTA' )->set_long_text( 'Dst.chl.loc' ).

      pc_cols->get_column( 'VMSTB' )->set_short_text( 'DstChDes' ).
      pc_cols->get_column( 'VMSTB' )->set_medium_text( 'Dst.chl.loc Desc' ).
      pc_cols->get_column( 'VMSTB' )->set_long_text( 'Dst.chl.loc Desc' ).
      pc_cols->get_column( 'USERNAME' )->set_short_text( 'DeleteBy' ).
      pc_cols->get_column( 'USERNAME' )->set_medium_text( 'Deleted By' ).
      pc_cols->get_column( 'USERNAME' )->set_long_text( 'Deleted By' ).
      pc_cols->get_column( 'UDATE' )->set_medium_text( 'Deleted On' ).
      pc_cols->get_column( 'TCODE' )->set_short_text( 'T-code' ).
      pc_cols->get_column( 'TCODE' )->set_medium_text( 'T-code' ).
      pc_cols->get_column( 'TAXM8' )->set_long_text( 'Tax clas.mat' ).
      pc_cols->get_column( 'CAP' )->set_medium_text( 'CAP Lead Time' ).
*      pc_cols->get_column( 'ZPLP3' )->set_medium_text( 'Planned.Price 3' ).
      lo_col = pc_cols->get_column( 'ZPLP3' ).
      lo_col->set_medium_text( 'Plannned Price 3' ).
      lo_col->set_short_text( 'Plnd.Prc 3' ).
      lo_col->set_long_text( 'Planned Price 3' ).
*      lo_col->set_edit_mask( '==FLTPC' ).         "To remove thousand separator
      lo_col->set_edit_mask( '==DECZE' ).         "To remove thousand separator

      pc_cols->get_column( 'ZPLD3' )->set_long_text( 'Planned Price Date' ).
      pc_cols->get_column( 'ITEM_TYPE' )->set_medium_text( 'Item Type' ).

      pc_cols->get_column( 'AIR_PRESSURE' )->set_long_text( 'Min Air Supply Pressure' ).
      pc_cols->get_column( 'AIR_FAIL' )->set_long_text( 'Air Fail Position' ).
      pc_cols->get_column( 'ACTUATOR' )->set_long_text( 'Actuator sizing done on diff. Pressure' ).
      pc_cols->get_column( 'VERTICAL' )->set_medium_text( 'Vertical' ).
      pc_cols->get_column( 'PPRDL' )->set_medium_text( 'Current Period' ).
*      pc_cols->get_column( 'PPRDL' )->set_leading_zero( abap_True ).
      pc_cols->get_column( 'PPRDL' )->set_edit_mask( '' ).
      pc_cols->get_column( 'PDATL' )->set_medium_text( 'Current FiscalYear' ).
*      pc_cols->get_column( 'LPLPR' )->set_medium_text( 'Current PlannedPrice' ).
      lo_col = pc_cols->get_column( 'LPLPR' ).
      lo_col->set_short_text( 'CurPlnPrc' ).
      lo_col->set_medium_text( 'Current Plan. Price' ).
      lo_col->set_long_text( 'Current Planned Price' ).
*      lo_col->set_edit_mask( '==FLTPC' ).         "To remove thousand separator
      lo_col->set_edit_mask( '==DECZE' ).         "To remove thousand separator

      pc_cols->get_column( 'PPRDV' )->set_long_text( 'Previous Period' ).
*      pc_cols->get_column( 'PPRDV' )->set_leading_zero( abap_True ).
      pc_cols->get_column( 'PPRDV' )->set_edit_mask( '' ).

      pc_cols->get_column( 'PDATV' )->set_medium_text( 'Prev. Fiscalyear' ).
*      pc_cols->get_column( 'VPLPR' )->set_medium_text( 'Prev. PlannedPrice' ).
      lo_col = pc_cols->get_column( 'VPLPR' ).
      lo_col->set_short_text( 'PrePlnPrc' ).
      lo_col->set_medium_text( 'Previous Plan.Price' ).
      lo_col->set_long_text( 'Previous Planned Price' ).
*      lo_col->set_edit_mask( '==FLTPC' ).         "To remove thousand separator
      lo_col->set_edit_mask( '==DECZE' ).         "To remove thousand separator

      pc_cols->get_column( 'KZKFG' )->set_long_text( 'Material is Configurable' ).
      pc_cols->get_column( 'MODIFY_DATE' )->set_long_text( 'Modify Date' ).

      pc_cols->get_column( 'DEV_STATUS' )->set_long_text( 'Development Status' ).
      pc_cols->get_column( 'ZKANBAN' )->set_medium_text( 'KANBAN Item' ).
      pc_cols->get_column( 'ZPEN_ITEM' )->set_long_text( 'Pending Item' ).
      pc_cols->get_column( 'ZRE_PEN_ITEM' )->set_long_text( 'Reason for Pending Item' ).
      pc_cols->get_column( 'MCN1' )->set_short_text( 'MCN1' ).
      pc_cols->get_column( 'MCN1' )->set_medium_text( 'MCN1' ).
      pc_cols->get_column( 'MCN1' )->set_long_text( 'MCN1' ).
      pc_cols->get_column( 'PN01' )->set_short_text( 'PN01' ).
      pc_cols->get_column( 'PN01' )->set_medium_text( 'PN01' ).
      pc_cols->get_column( 'PN01' )->set_long_text( 'PN01' ).
      pc_cols->get_column( 'ZQAP' )->set_medium_text( 'QAP Number' ).
      pc_cols->get_column( 'REV_NO' )->set_long_text( 'Revision No.' ).
      pc_cols->get_column( 'ZBOI' )->set_short_text( 'BgtOutItm' ).
      pc_cols->get_column( 'ZBOI' )->set_medium_text( 'Bought Out Item' ).
      pc_cols->get_column( 'ZBOI' )->set_long_text( 'Bought Out Item' ).
      pc_cols->get_column( 'WRKST' )->set_medium_text( 'Basic Material' ).

      pc_cols->get_column( 'KMCN' )->set_short_text( 'KMCN' ).
      pc_cols->get_column( 'KMCN' )->set_long_text( 'KMCN' ).
      pc_cols->get_column( 'KNDT' )->set_short_text( 'KNDT' ).
      pc_cols->get_column( 'KNDT' )->set_long_text( 'KNDT' ).
      pc_cols->get_column( 'KPLG' )->set_short_text( 'KPLG' ).
      pc_cols->get_column( 'KPLG' )->set_long_text( 'KPLG' ).
      pc_cols->get_column( 'KPR1' )->set_short_text( 'KPR1' ).
      pc_cols->get_column( 'KPR1' )->set_long_text( 'KPR1' ).
      pc_cols->get_column( 'KPRD' )->set_short_text( 'KPRD' ).
      pc_cols->get_column( 'KPRD' )->set_long_text( 'KPRD' ).
      pc_cols->get_column( 'KRJ0' )->set_short_text( 'KRJ0' ).
      pc_cols->get_column( 'KRJ0' )->set_long_text( 'KRJ0' ).
      pc_cols->get_column( 'KRM0' )->set_short_text( 'KRM0' ).
      pc_cols->get_column( 'KRM0' )->set_long_text( 'KRM0' ).
      pc_cols->get_column( 'KRWK' )->set_short_text( 'KRWK' ).
      pc_cols->get_column( 'KRWK' )->set_long_text( 'KRWK' ).
      pc_cols->get_column( 'KSC0' )->set_short_text( 'KSC0' ).
      pc_cols->get_column( 'KSC0' )->set_long_text( 'KSC0' ).
      pc_cols->get_column( 'KSCR' )->set_short_text( 'KSCR' ).
      pc_cols->get_column( 'KSCR' )->set_long_text( 'KSCR' ).
      pc_cols->get_column( 'KSFG' )->set_short_text( 'KSFG' ).
      pc_cols->get_column( 'KSFG' )->set_long_text( 'KSFG' ).
      pc_cols->get_column( 'KSLR' )->set_short_text( 'KSLR' ).
      pc_cols->get_column( 'KSLR' )->set_long_text( 'KSLR' ).
      pc_cols->get_column( 'KSPC' )->set_short_text( 'KSPC' ).
      pc_cols->get_column( 'KSPC' )->set_long_text( 'KSPC' ).
      pc_cols->get_column( 'KSRN' )->set_short_text( 'KSRN' ).
      pc_cols->get_column( 'KSRN' )->set_long_text( 'KSRN' ).
      pc_cols->get_column( 'KTPI' )->set_short_text( 'KTPI' ).
      pc_cols->get_column( 'KTPI' )->set_long_text( 'KTPI' ).
      pc_cols->get_column( 'KVLD' )->set_short_text( 'KVLD' ).
      pc_cols->get_column( 'KVLD' )->set_long_text( 'KVLD' ).
      pc_cols->get_column( 'KFG0' )->set_short_text( 'KFG0' ).
      pc_cols->get_column( 'KFG0' )->set_long_text( 'KFG0' ).
      pc_cols->get_column( 'ZITEM_CLASS' )->set_short_text( 'Item Class' ).

    CATCH: cx_salv_not_found INTO DATA(ls_msg).
  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form date_convert
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> PU_DATE
*&      <-- PC_DATE
*&---------------------------------------------------------------------*
FORM change_Date_format  USING    pu_date TYPE sy-datum
                         CHANGING pc_udate TYPE char11.
  IF pu_date  IS INITIAL.
    CLEAR: pc_udate.
    RETURN.
  ENDIF.

* To get in DDMMMYY format
  CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
    EXPORTING
      input  = pu_date
    IMPORTING
      output = pc_udate.

* To get in DD-MMM-YYYY format
  CONCATENATE  pc_udate+0(2)  pc_udate+2(3)  pc_udate+5(4)
                 INTO  pc_udate SEPARATED BY '-'.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form convert_alpha
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM convert_alpha .
*CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
*  EXPORTING
*    input         =
** IMPORTING
**   OUTPUT        =
*          .

ENDFORM.
