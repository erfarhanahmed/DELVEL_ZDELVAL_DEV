*&---------------------------------------------------------------------*
*& Report ZUS_STOCKFI_HANA_JOINED
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zus_stockfi_hana_joined.
"=== Selection screen (unchanged) ==========================================
DATA: gv_matnr TYPE mara-matnr,
      gv_werks TYPE mard-werks.
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001."
  SELECT-OPTIONS: mat   FOR gv_matnr,
                  plant FOR gv_werks DEFAULT 'US01'.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
  PARAMETERS p_down  AS CHECKBOX.
  PARAMETERS p_folder LIKE rlgrap-filename DEFAULT '/Delval/USA'.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-003.
  SELECTION-SCREEN  COMMENT /1(60) TEXT-004.
  SELECTION-SCREEN  COMMENT /1(70) TEXT-005.
SELECTION-SCREEN END OF BLOCK b3.

"=== Types for the final ALV output (columns you display) ==================
TYPES: BEGIN OF ty_out,
         matnr          TYPE mara-matnr,
         mattxt         TYPE text100,          " built from READ_TEXT
         wrkst          TYPE mara-wrkst,
         brand          TYPE mara-brand,
         zseries        TYPE mara-zseries,
         zsize          TYPE mara-zsize,
         moc            TYPE mara-moc,
         type           TYPE mara-type,
*         vbeln          TYPE vbap-vbeln,      "+
*         posnr          TYPE vbap-posnr,      "+
*         lfgsa          TYPE vbup-lfgsa,      "+
*         vgbel          TYPE lips-vgbel,      "+
*         vgpos          TYPE lips-vgpos,      "+
*         lfimg          TYPE lips-lfimg,      "+
*         werks          TYPE mard-werks,      "+
*         omeng          TYPE vbbe-omeng,      "+
*         bwart          TYPE mseg-bwart,      "+
*         vbeln_im       TYPE mseg-vbeln_im,   "+
*         vbelp_im       TYPE mseg-vbelp_im,   "+
*         mseg_menge     TYPE mseg-menge,      "+
*         mseg_menge1    TYPE mseg-menge,      "+
*         mblnr          TYPE mseg-mblnr,      "+
*         smbln          TYPE mseg-smbln,      "+
*         ebeln          TYPE ekpo-ebeln,      "+
*         ebelp          TYPE ekpo-ebelp,      "+
*         menge          TYPE ekpo-menge,      "+
*         loekz          TYPE ekpo-loekz,      "+
*         elikz          TYPE ekpo-elikz,      "+

         open_qty       TYPE p DECIMALS 0,
         price          TYPE mseg-dmbtr,       " pending SO value (ZPR0 based)
         un_qty         TYPE p DECIMALS 0,     " unrestricted qty = labst + kulab (your UN_QTY logic)
         un_val         TYPE mseg-dmbtr,
         open_qty_v     TYPE mseg-dmbtr,
         labst          TYPE p DECIMALS 0,
         labst_v        TYPE mseg-dmbtr,
         kulab          TYPE p DECIMALS 0,
         kulab_v        TYPE mseg-dmbtr,
         free_stock     TYPE p DECIMALS 0,
         free_stock_v   TYPE mseg-dmbtr,
         tran_qty_new   TYPE p DECIMALS 0,
         tran_qty_v_new TYPE mseg-dmbtr,
         so_fall_qty    TYPE p DECIMALS 0,
         so_fall_qty_v  TYPE mseg-dmbtr,
         pend_po_qty    TYPE p DECIMALS 0,
         po_value       TYPE ekpo-brtwr,      "+
         open_inv       TYPE p DECIMALS 0,
         amount         TYPE mseg-dmbtr,       " last GRN unit price
         value          TYPE mseg-dmbtr,       " avg valuation price
         bklas          TYPE mbew-bklas,
         mtart          TYPE mara-mtart,
         ersda          TYPE mara-ersda,
         menge_104      TYPE mseg-menge,
         qty_104_val    TYPE mseg-dmbtr,
       END OF ty_out.

DATA: lt_out TYPE STANDARD TABLE OF ty_out,
      ls_out TYPE ty_out.

"=== Helper for ALV (reusing your REUSE_ALV_* approach) ====================
TYPE-POOLS: slis.
DATA: gt_fieldcat TYPE slis_t_fieldcat_alv,
      gs_fieldcat TYPE slis_fieldcat_alv,
      gv_col      TYPE i.

"============================ MAIN ========================================

START-OF-SELECTION.
  PERFORM get_data_hana.
  PERFORM enrich_texts.
  PERFORM compute_values_and_totals.
  PERFORM build_fieldcat.
  PERFORM display_alv.
  IF p_down = abap_true.
    PERFORM download_files.
  ENDIF.

  "==================== DB pushdown with CTEs and joins ======================
FORM get_data_hana.
  " One-shot set-based aggregation to material level (across selected plants)
  WITH
    +base AS (
      SELECT DISTINCT
        a~matnr,
*        B~WERKS,
        a~wrkst,
        a~brand,
        a~zseries,
        a~zsize,
        a~moc,
        a~type,
        a~ersda,
        a~mtart
      FROM mara AS a
      INNER JOIN mard AS b
        ON b~matnr = a~matnr
      WHERE a~matnr IN @mat
        AND b~werks IN @plant

    ),

    +stock AS (
      SELECT matnr,
*             werks,
             SUM( labst ) AS labst
      FROM mard
      WHERE matnr IN @mat AND werks IN @plant
      GROUP BY matnr  ", werks
    ),

    +cons AS (
      SELECT matnr,
*      werks,
      SUM( kulab ) AS kulab
      FROM msku
      WHERE matnr IN @mat AND werks IN @plant
      GROUP BY matnr  ", werks
    ),

    +so_open AS (
      SELECT a~matnr,
*          a~werks,
             SUM( a~kwmeng ) AS vbap_qty,
             SUM( b~lfimg ) AS lips_qty
      FROM vbap AS a
        LEFT OUTER JOIN lips AS b ON b~vgbel = a~vbeln
                                 AND b~vgpos = a~posnr
      WHERE a~matnr IN @mat
        AND a~werks IN @plant
        AND a~abgru = ''        " not rejected
        AND a~lfsta <> 'C'      " not fully delivered
      GROUP BY a~matnr  ", a~werks
    ),

*    +SO_DEL AS (
*      " delivered qty credited to SO
*      SELECT L~MATNR, L~WERKS, SUM( L~LFIMG ) AS LIPS_QTY
*      FROM LIPS AS L
**      INNER JOIN VBUP AS U
**        ON U~VBELN = L~VBELN AND U~POSNR = L~POSNR
**        INNER  JOIN +SO_OPEN AS D
**          ON L~VGBEL = D~VBELN AND L~VGPOS = D~POSNR
*      WHERE L~MATNR IN @MAT
*        AND L~WERKS IN @PLANT
**        AND L~FKSTA <> 'C'      " not fully billed (open invoice perspective below uses vkbur filter)
*      GROUP BY L~MATNR, L~WERKS
*    ),

    +open_inv AS (
      " your 'open invoice qty' scope with sales offices
      SELECT l~matnr,
*             l~werks,
             SUM( l~lfimg ) AS open_inv
      FROM lips AS l
*      INNER JOIN VBUP AS U
*        ON U~VBELN = L~VBELN AND U~POSNR = L~POSNR

      WHERE l~matnr IN @mat
        AND l~werks IN @plant
        AND l~vkbur IN ( 'US01','US02','US03' )
        AND l~fksta <> 'C'
      GROUP BY l~matnr  ", l~werks
    ),

    +vbak_map AS (
      SELECT vbeln, knumv
      FROM vbak
      WHERE vbeln IN ( SELECT vbeln FROM vbap WHERE matnr IN @mat )
        AND vbtyp IN ( 'C','I','H' )
    ),

    +price_zpr0 AS (
      " pending SO value by ZPR0 * (ordered - delivered), ignore PSTYV = 'ZKLN'
      SELECT a~matnr,
*              a~werks,
             CAST( SUM( ( a~kwmeng - coalesce( d~lfimg, 0 ) ) * c~kbetr ) AS DEC( 31,2 ) ) AS pending_so_val
      FROM vbap AS a
*        INNER JOIN VBUP AS B
*          ON B~VBELN = A~VBELN AND B~POSNR = A~POSNR AND B~LFSTA <> 'C'
        LEFT  JOIN lips AS d
          ON d~vgbel = a~vbeln AND d~vgpos = a~posnr
        INNER JOIN +vbak_map AS h
          ON h~vbeln = a~vbeln
        INNER JOIN prcd_elements AS c
          ON c~knumv = h~knumv AND c~kposn = a~posnr AND c~kschl = 'ZPR0'
      WHERE a~matnr IN @mat
        AND a~werks IN @plant
        AND a~abgru = ''
        AND a~pstyv <> 'ZKLN'
        AND a~lfsta <> 'C'
      GROUP BY a~matnr    ", a~werks
    ),

*    +mbew_val AS (
*      " price per plant: use verpr if vprsv='V' else stprs; carry bklas + salk3 for valuation sums
*      SELECT matnr,
**             bwkey                      AS werks,
*             MAX( CASE WHEN vprsv = 'V' THEN verpr ELSE stprs END ) AS price,
**              CASE WHEN vprsv = 'V' THEN AVG( verpr ) ELSE AVG( stprs ) END  AS price,
*             MAX( bklas )               AS bklas,
*             SUM( salk3 )               AS salk3_sum
*      FROM mbew
*      WHERE matnr IN @mat AND bwkey IN @plant
*      GROUP BY matnr  "werks
*    ),

    +m103 AS ( SELECT matnr,
*                WERKS,
               SUM( menge ) AS q103
              FROM mseg
              WHERE bwart = '103' AND matnr IN @mat AND werks IN @plant
                    AND smbln IS INITIAL
              GROUP BY matnr  ", werks
              ),
    +m105 AS ( SELECT matnr,
*                  WERKS,
                  SUM( menge ) AS q105
              FROM mseg
              WHERE bwart = '105' AND matnr IN @mat AND werks IN @plant
                    AND smbln IS INITIAL
              GROUP BY matnr  ", werks
              ),
    +m104 AS ( SELECT matnr,
*                  WERKS,
                  SUM( menge ) AS q104
              FROM mseg
              WHERE bwart = '104' AND matnr IN @mat AND werks IN @plant
                    AND smbln IS INITIAL
              GROUP BY matnr  ", werks
              ),

    +transit AS (
      SELECT b~matnr,
*             b~werks,
             coalesce( x~q103,0 ) - coalesce( y~q105,0 ) - coalesce( z~q104,0 ) AS tran_qty
      FROM +base AS b
*      LEFT JOIN +M103 AS X ON X~MATNR = B~MATNR AND X~WERKS = B~WERKS
*      LEFT JOIN +M105 AS Y ON Y~MATNR = B~MATNR AND Y~WERKS = B~WERKS
*      LEFT JOIN +M104 AS Z ON Z~MATNR = B~MATNR AND Z~WERKS = B~WERKS

      LEFT JOIN +m103 AS x ON x~matnr = b~matnr
      LEFT JOIN +m105 AS y ON y~matnr = b~matnr
      LEFT JOIN +m104 AS z ON z~matnr = b~matnr
    ),

    " GRN base and effective (no reversals): 101/105, KZBEW <> 'F'
    +grn_base AS (
      SELECT matnr, werks, mblnr, zeile, dmbtr, menge
      FROM mseg
      WHERE matnr IN @mat AND werks IN @plant
        AND bwart IN ( '101','105' )
        AND kzbew <> 'F'
    ),

    +grn_eff AS (
      SELECT g~matnr, g~werks, g~mblnr, g~zeile, g~dmbtr, g~menge
      FROM +grn_base AS g
      WHERE NOT EXISTS (
        SELECT 1 FROM mseg AS r
        WHERE r~smbln = g~mblnr
          AND r~matnr = g~matnr
      )
    ),

    +grn_value AS (  " sum DMBTR of effective GRNs
      SELECT matnr,
*        werks,
      SUM( dmbtr ) AS grn_value
      FROM +grn_eff
      GROUP BY matnr      ", werks
    ),

    +grn_last_key AS ( " last (max) MBLNR per matnr/werks
      SELECT matnr,   "werks,
             MAX( mblnr ) AS mblnr
      FROM +grn_eff
      GROUP BY matnr      ", werks
    ),

    +grn_last_row AS ( " last row (resolve ZEILE max for last MBLNR)
      SELECT e~matnr, "e~werks,
             e~mblnr, MAX( e~zeile ) AS zeile
      FROM +grn_eff AS e
      INNER JOIN +grn_last_key AS k
        ON k~matnr = e~matnr  "AND k~werks = e~werks
        AND k~mblnr = e~mblnr
      GROUP BY e~matnr,
*               e~werks,
               e~mblnr
    ),

    +grn_last_unit AS (
      SELECT e~matnr,
*          e~werks,
             CASE WHEN e~menge = 0 THEN 0
*                  ELSE E~DMBTR / E~MENGE END AS UNIT_PRICE
                  ELSE division( e~dmbtr, e~menge,2 ) END AS unit_price
      FROM +grn_eff AS e
      INNER JOIN +grn_last_row AS r
        ON r~matnr = e~matnr  "AND r~werks = e~werks
       AND r~mblnr = e~mblnr AND r~zeile = e~zeile
    ),

    " EKPO/EKET: pending PO qty/value components
    +ekpo_open AS (
      SELECT matnr,
*        werks,
        SUM( menge ) AS menge2, SUM( brtwr ) AS po_val
      FROM ekpo
      WHERE matnr IN @mat AND werks IN @plant
        AND loekz <> 'L'
        AND retpo <> 'X'
      GROUP BY matnr  ", werks
    ),

    +ekpo_ret AS (
      SELECT matnr,
*             werks,
             SUM( menge ) AS menge4, SUM( brtwr ) AS po_val1
      FROM ekpo
      WHERE matnr IN @mat AND werks IN @plant
        AND retpo = 'X'
      GROUP BY matnr    ", werks
    ),

    +eket_sum AS (
      SELECT e~matnr,
*             e~werks,
             SUM( k~wemng ) AS menge3
      FROM ekpo AS e
      INNER JOIN eket AS k
        ON k~ebeln = e~ebeln AND k~ebelp = e~ebelp
      WHERE e~matnr IN @mat AND e~werks IN @plant
        AND e~loekz <> 'L'
      GROUP BY e~matnr    ", e~werks
    ),

    " Per plant (matnr/werks) aggregation to feed a material-level rollup
    +per_plant AS (
      SELECT
        b~matnr,
*        b~werks,
        MIN( b~wrkst )                               AS wrkst,
        MIN( b~brand )                               AS brand,
        MIN( b~zseries )                             AS zseries,
        MIN( b~zsize )                               AS zsize,
        MIN( b~moc )                                 AS moc,
        MIN( b~type )                                AS type,
        MIN( b~ersda )                               AS ersda,
        MIN( b~mtart )                               AS mtart,

        coalesce( s~labst,0 )                          AS labst,
        coalesce( c~kulab,0 )                          AS kulab,

        coalesce( so~vbap_qty,0 )                      AS vbap_qty,
        coalesce( so~lips_qty,0 )                      AS lips_qty,
        coalesce( oi~open_inv,0 )                      AS open_inv,

        CAST( 0 AS DEC( 13, 2 ) )  AS price,
        CAST( ' ' AS CHAR( 4 ) )  AS bklas,
        CAST( 0 AS DEC( 13, 2 ) )  AS salk3_sum,
*        coalesce( mv~price,0 )                         AS price,
*        coalesce( mv~bklas,' ' )                        AS bklas,
*        coalesce( mv~salk3_sum,0 )                     AS salk3_sum,

        coalesce( tr~tran_qty,0 )                      AS tran_qty,

        coalesce( gv~grn_value,0 )                     AS grn_value,
        coalesce( gl~unit_price,0 )                    AS last_unit_price,

        coalesce( po~menge2,0 )                        AS menge2,
        coalesce( po~po_val,0 )                        AS po_val,
        coalesce( pr~menge4,0 )                        AS menge4,
        coalesce( pr~po_val1,0 )                       AS po_val1,
        coalesce( ks~menge3,0 )                        AS menge3,

        coalesce( m104~q104,0 )                        AS menge_104

      FROM +base AS b
      LEFT JOIN +stock        AS s   ON s~matnr = b~matnr   " AND s~werks = b~werks
      LEFT JOIN +cons         AS c   ON c~matnr = b~matnr   "AND c~werks = b~werks
      LEFT JOIN +so_open      AS so  ON so~matnr = b~matnr  "AND so~werks = b~werks
*      LEFT JOIN +SO_DEL       AS DL  ON DL~MATNR = B~MATNR AND DL~WERKS = B~WERKS
      LEFT JOIN +open_inv     AS oi  ON oi~matnr = b~matnr  "AND oi~werks = b~werks
*      LEFT JOIN +mbew_val     AS mv  ON mv~matnr = b~matnr  "AND mv~werks = b~werks
      LEFT JOIN +transit      AS tr  ON tr~matnr = b~matnr  "AND tr~werks = b~werks
      LEFT JOIN +grn_value    AS gv  ON gv~matnr = b~matnr  "AND gv~werks = b~werks
      LEFT JOIN +grn_last_unit AS gl ON gl~matnr = b~matnr  "AND gl~werks = b~werks
      LEFT JOIN +ekpo_open    AS po  ON po~matnr = b~matnr  "AND po~werks = b~werks
      LEFT JOIN +ekpo_ret     AS pr  ON pr~matnr = b~matnr  "AND pr~werks = b~werks
      LEFT JOIN +eket_sum     AS ks  ON ks~matnr = b~matnr  "AND ks~werks = b~werks
      LEFT JOIN +m104         AS m104 ON m104~matnr = b~matnr "AND m104~werks = b~werks

    GROUP BY b~matnr,
*             b~werks,
             s~labst, c~kulab, so~vbap_qty,
             so~lips_qty, oi~open_inv,  "mv~price, mv~bklas, mv~salk3_sum,
             tr~tran_qty, gv~grn_value, gl~unit_price, po~menge2,
             po~po_val, pr~menge4, pr~po_val1, ks~menge3, m104~q104
    )

*  " Final roll-up to material (summing over selected plants)
*  SELECT
*    P~MATNR                                         AS MATNR,
*    MIN( P~WRKST )                                  AS WRKST,
*    MIN( P~BRAND )                                  AS BRAND,
*    MIN( P~ZSERIES )                                AS ZSERIES,
*    MIN( P~ZSIZE )                                  AS ZSIZE,
*    MIN( P~MOC )                                    AS MOC,
*    MIN( P~TYPE )                                   AS TYPE,
*    MIN( P~ERSDA )                                  AS ERSDA,
*    MIN( P~MTART )                                  AS MTART,
*    MAX( P~BKLAS )                                  AS BKLAS,
*
*    SUM( P~LABST )                                  AS LABST,
*    SUM( P~KULAB )                                  AS KULAB,
*    SUM( P~VBAP_QTY )                               AS VBAP_QTY,
*    SUM( P~LIPS_QTY )                               AS LIPS_QTY,
*    SUM( P~OPEN_INV )                               AS OPEN_INV,
*
*    AVG( P~PRICE )                                  AS AVG_PRICE,    " valuation price
*    SUM( P~TRAN_QTY )                               AS TRAN_QTY_NEW,
*
*    SUM( P~GRN_VALUE )                              AS GRN_VALUE,
*    AVG( P~LAST_UNIT_PRICE )                        AS LAST_UNIT_PRICE,
*
*    SUM( P~MENGE2 )                                 AS MENGE2,
*    SUM( P~PO_VAL )                                 AS PO_VAL,
*    SUM( P~MENGE4 )                                 AS MENGE4,
*    SUM( P~PO_VAL1 )                                AS PO_VAL1,
*    SUM( P~MENGE3 )                                 AS MENGE3,
*
*    SUM( P~MENGE_104 )                              AS MENGE_104,
*
*    SUM( COALESCE( Q~PENDING_SO_VAL,0 ) )             AS PENDING_SO_VAL
*
*
*  FROM +PER_PLANT AS P
*  LEFT JOIN +PRICE_ZPR0 AS Q
*    ON Q~MATNR = P~MATNR AND Q~WERKS = P~WERKS
*  GROUP BY P~MATNR
*  INTO TABLE @DATA(LT_MAT).

* Temp


  SELECT
    p~matnr                                    AS matnr,
     p~wrkst                                   AS wrkst,
     p~brand                                   AS brand,
    p~zseries                                 AS zseries,
     p~zsize                                   AS zsize,
     p~moc                                     AS moc,
     p~type                                    AS type,
     p~ersda                                   AS ersda,
     p~mtart                                   AS mtart,
     p~bklas                                   AS bklas,

    p~labst                                   AS labst,
    p~salk3_sum                         AS salk3_sum,
     p~kulab                                   AS kulab,
     p~vbap_qty                                AS vbap_qty,
     p~lips_qty                                AS lips_qty,
    p~open_inv                                AS open_inv,

     p~price                                  AS avg_price,    " valuation price
     p~tran_qty                                AS tran_qty_new,

     p~grn_value                               AS grn_value,
     p~last_unit_price                         AS last_unit_price,

     p~menge2                                  AS menge2,
     p~po_val                                  AS po_val,
    p~menge4                                  AS menge4,
     p~po_val1                                 AS po_val1,
     p~menge3                                  AS menge3,

     p~menge_104                               AS menge_104,

     coalesce( q~pending_so_val,0 )              AS pending_so_val

  FROM +per_plant AS p
  LEFT JOIN +price_zpr0 AS q
    ON q~matnr = p~matnr  "AND q~werks = p~werks
  INTO TABLE @DATA(LT_MAT_temp).

*  SELECT MATNR,
*         BWKEY                      AS WERKS,
*         MAX( CASE WHEN VPRSV = 'V' THEN VERPR ELSE STPRS END ) AS PRICE,
*         MAX( BKLAS )               AS BKLAS,
*         SUM( SALK3 )               AS SALK3_SUM
*  FROM MBEW
*  WHERE MATNR IN @MAT AND BWKEY IN @PLANT
*  GROUP BY MATNR, BWKEY INTO TABLE @DATA(LT_MBEW).

*  SELECT A~VBELN, A~POSNR, A~MATNR, A~WERKS,
*         SUM( A~KWMENG ) AS VBAP_QTY,
*         SUM( B~LFIMG )  AS LIPS_QTY
*  FROM VBAP AS A
*       LEFT OUTER JOIN LIPS AS B ON B~VGBEL = A~VBELN
*                                 AND B~VGPOS = A~POSNR
*  WHERE A~MATNR IN @MAT
*    AND A~WERKS IN @PLANT
*    AND A~ABGRU = ''        " not rejected
*    AND A~LFSTA <> 'C'      " not fully delivered
*  GROUP BY A~VBELN, A~POSNR, A~MATNR, A~WERKS INTO TABLE @DATA(LT_VBAP).
*  IF LT_VBAP IS NOT INITIAL.
*
*
*  ENDIF.
* Temp

  " Map SQL output to our result table skeleton (values that still need formulae)
  CLEAR lt_out.

  SELECT matnr,
         CASE WHEN vprsv = 'V' THEN verpr ELSE stprs END  AS price,
*              CASE WHEN vprsv = 'V' THEN AVG( verpr ) ELSE AVG( stprs ) END  AS price,
         bklas                AS bklas,
         salk3                AS salk3_sum
  FROM mbew
  WHERE matnr IN @mat
    AND bwkey IN @plant
    INTO TABLE @DATA(lt_mbew).
  SORT lt_mbew BY matnr.


  DATA: lv_cnt   TYPE i,
        lv_sum   TYPE verpr,
        lv_avgpr TYPE p LENGTH 16 DECIMALS 2.

  LOOP AT LT_MAT_temp ASSIGNING FIELD-SYMBOL(<m>).

    CLEAR: ls_out, <m>-avg_price, <m>-salk3_sum, lv_cnt, lv_sum, lv_avgpr.

    LOOP AT lt_mbew INTO DATA(ls_mbew) WHERE matnr = <m>-matnr.
      <m>-bklas = ls_mbew-bklas.
      <m>-salk3_sum = <m>-salk3_sum + ls_mbew-salk3_sum.

      lv_sum += ls_mbew-price.
      lv_cnt += 1.
    ENDLOOP.

    IF lv_cnt > 0.
      lv_avgpr = ( lv_sum / lv_Cnt ).
    ENDIF.
    <m>-avg_price = lv_avgpr.
    ls_out-matnr     = <m>-matnr.
    ls_out-wrkst     = <m>-wrkst.
    ls_out-brand     = <m>-brand.
    ls_out-zseries   = <m>-zseries.
    ls_out-zsize     = <m>-zsize.
    ls_out-moc       = <m>-moc.
    ls_out-type      = <m>-type.
    ls_out-ersda     = <m>-ersda.
    ls_out-mtart     = <m>-mtart.
    ls_out-bklas     = <m>-bklas.

    ls_out-labst     = <m>-labst.
    ls_out-kulab     = <m>-kulab.
    ls_out-open_inv  = <m>-open_inv.
    ls_out-value     = <m>-avg_price.
    ls_out-tran_qty_new = <m>-tran_qty_new.
    ls_out-amount    = <m>-last_unit_price.

    " SO quantities
    DATA(vbap_qty) = <m>-vbap_qty.
    DATA(lips_qty) = <m>-lips_qty.
    ls_out-open_qty = vbap_qty - lips_qty.
*    LS_OUT-OPEN_QTY =   <M>-VBAP_QTY.
    IF ls_out-open_qty < 0.  ls_out-open_qty = 0. ENDIF.

    " Pending PO qty & PO value
    DATA(menge2)   = <m>-menge2.
    DATA(menge3)   = <m>-menge3.
    DATA(menge4)   = <m>-menge4.
    DATA(po_val)   = <m>-po_val.
    DATA(po_val1)  = <m>-po_val1.
    DATA(grn_val)  = <m>-grn_value.

    ls_out-pend_po_qty = menge2 - menge3 - menge4.
    IF ls_out-pend_po_qty < 0. ls_out-pend_po_qty = 0. ENDIF.

    DATA(po_val2) = po_val - po_val1.
    IF po_val2 < 0. po_val2 = 0. ENDIF.
    ls_out-po_value = po_val2 - grn_val.
    IF ls_out-po_value < 0. ls_out-po_value = 0. ENDIF.

    " Monetary projections with valuation price
    ls_out-open_qty_v     = ls_out-open_qty     * ls_out-value.
*    LS_OUT-LABST_V        = LS_OUT-LABST        * LS_OUT-VALUE.
    ls_out-kulab_v        = ls_out-kulab        * ls_out-value.   "Stock in hand
    ls_out-labst_v        = <m>-salk3_sum - ls_out-kulab_v.       "Stock in hand value


    " UN_* in your program = cumulative unrestricted incl. consignment
*    LS_OUT-UN_QTY         = LS_OUT-LABST + LS_OUT-KULAB.
*    LS_OUT-UN_VAL         = LS_OUT-LABST_V + LS_OUT-KULAB_V.
    ls_out-un_qty         = ls_out-labst + ls_out-kulab.
    ls_out-un_val         = <m>-salk3_sum .

    " FREE_STOCK = LABST - OPEN_QTY (min 0)
    ls_out-free_stock     = ls_out-labst - ls_out-open_qty.
    IF ls_out-free_stock < 0. ls_out-free_stock = 0. ENDIF.
    ls_out-free_stock_v   = ls_out-free_stock * ls_out-value.

    " Transit value
    ls_out-tran_qty_v_new = ls_out-tran_qty_new * ls_out-value.

    " Shortfall = OPEN_QTY - LABST - TRANSIT (min 0)
    ls_out-so_fall_qty    = ls_out-open_qty - ls_out-labst - ls_out-tran_qty_new.
    IF ls_out-so_fall_qty < 0. ls_out-so_fall_qty = 0. ENDIF.
    ls_out-so_fall_qty_v  = ls_out-so_fall_qty * ls_out-value.

    " Pending SO value by ZPR0
    ls_out-price          = <m>-pending_so_val.

    " 104 totals + value
    ls_out-menge_104      = <m>-menge_104.
    ls_out-qty_104_val    = ls_out-menge_104 * ls_out-value.

    APPEND ls_out TO lt_out.
    CLEAR: ls_out.
*    COLLECT LS_OUT INTO LT_OUT.
  ENDLOOP.
ENDFORM.

"==================== Material long text (GRUN) like your program ==========
FORM enrich_texts.
  DATA: lv_name    TYPE thead-tdname,
        lt_lines   TYPE STANDARD TABLE OF tline,
        ls_line    TYPE tline,
        lv_count   TYPE i,
        lv_value   TYPE dmbtr_cs,
        lv_avg     TYPE p DECIMALS 2,
        lt_out_tmp TYPE STANDARD TABLE OF ty_out.

*  LT_OUT_TMP = LT_OUT.
  DATA(lt_temp1) = lt_out.
  DATA(lt_temp2) = lt_out.
  DELETE lt_Temp1 WHERE amount = 0.
  DELETE lt_Temp2 WHERE value = 0.

  LOOP AT lt_out INTO DATA(ls_out).

    COLLECT ls_out INTO lt_out_tmp.
  ENDLOOP.

  LOOP AT LT_OUT_tmp ASSIGNING FIELD-SYMBOL(<o>).
    CLEAR: lt_lines, <o>-mattxt.

* Average last item price
    CLEAR: lv_value, lv_count, lv_avg.
    IF <o>-amount > 0.
      LOOP AT lt_temp1 INTO DATA(ls_temp) WHERE matnr = <o>-matnr.
        lv_value = LV_value + ls_temp-amount.
        lv_count += 1.
      ENDLOOP.
      IF lv_count > 0.
        lv_avg = lv_value / lv_count.
        <o>-amount = lv_avg.
      ENDIF.
    ENDIF.
    CLEAR: lv_value, lv_count, lv_avg.
    IF <o>-value > 0.
      LOOP AT lt_temp2 INTO ls_temp WHERE matnr = <o>-matnr.
        lv_value = LV_value + ls_temp-value.
        lv_count += 1.
      ENDLOOP.
      IF lv_count > 0.
        lv_avg = lv_value / lv_count.
        <o>-value = lv_avg.
      ENDIF.
    ENDIF.

* End of average amount

    lv_name = <o>-matnr.
    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client   = sy-mandt
        id       = 'GRUN'
        language = sy-langu
        name     = lv_name
        object   = 'MATERIAL'
      TABLES
        lines    = lt_lines
      EXCEPTIONS
        OTHERS   = 1.
    IF sy-subrc = 0 AND lt_lines IS NOT INITIAL.
      LOOP AT lt_lines INTO ls_line.
        IF ls_line-tdline IS NOT INITIAL.
          CONCATENATE <o>-mattxt ls_line-tdline INTO <o>-mattxt SEPARATED BY space.
        ENDIF.
      ENDLOOP.
      CONDENSE <o>-mattxt.
    ENDIF.
  ENDLOOP.

  lt_out = lt_out_tmp.
ENDFORM.

"==================== Final normalizations matching your totals ============
FORM compute_values_and_totals.
  "Your old program also did a 2-plant average of VALUE if multiple plants selected.
  "We already used AVG(price) across plants; nothing else needed here.
ENDFORM.

"==================== ALV helpers (reuse your style) =======================
FORM build_fieldcat.
  DEFINE add_col.
    gv_col = gv_col + 1.
    CLEAR gs_fieldcat.
    gs_fieldcat-col_pos   = gv_col.
    gs_fieldcat-tabname   = 'LT_OUT'.
    gs_fieldcat-fieldname = &1.
    gs_fieldcat-seltext_l = &2.
    gs_fieldcat-outputlen = &3.
    gs_fieldcat-do_sum = &4.
*    CASE &1.
*      WHEN 'VALUE'.
*        gs_fieldcat-DO_SUM = 'C'.
**      WHEN .
*      WHEN OTHERS.
*    ENDCASE.
    APPEND gs_fieldcat TO gt_fieldcat.
  END-OF-DEFINITION.

  gv_col = 0.
  add_col 'MATNR'          'Material Code'           '20' ''.
  add_col 'MATTXT'         'Material Description'    '50' ''.
  add_col 'WRKST'          'USA Material Code'       '20' ''.
  add_col 'BRAND'          'Brand'                    '5' ''.
  add_col 'ZSERIES'        'Series'                   '5' ''.
  add_col 'ZSIZE'          'Size'                     '5' ''.
  add_col 'MOC'            'MOC'                      '5' ''.
  add_col 'TYPE'           'Type'                     '5' ''.
  add_col 'OPEN_QTY'       'Pending SO'              '20' 'X'.
  add_col 'PRICE'          'Pending SO Value'        '20' 'X'.
  add_col 'UN_QTY'         'Unrestricted Quantity'   '20' 'X'.
  add_col 'UN_VAL'         'Unrestricted Value'      '20' 'X'.
  add_col 'OPEN_QTY_V'     'Pending SO Sales Total'  '20' 'X'.
  add_col 'LABST'          'Stock In Hand'           '15' 'X'.
  add_col 'LABST_V'        'Stock In Hand Value'     '20' 'X'.
  add_col 'KULAB'          'Consignment Stock'       '20' 'X'.
  add_col 'KULAB_V'        'Consignment Stock Value' '20' 'X'.
  add_col 'FREE_STOCK'     'Free Stock'              '15' 'X'.
  add_col 'FREE_STOCK_V'   'Free Stock Value'        '15' 'X'.
  add_col 'TRAN_QTY_NEW'   'Transit Qty'             '15' 'X'.
  add_col 'TRAN_QTY_V_NEW' 'Transit Value'           '15' 'X'.
  add_col 'SO_FALL_QTY'    'SO Short Fall Qty'       '20' 'X'.
  add_col 'SO_FALL_QTY_V'  'SO Short Fall Qty Value' '20' 'X'.
  add_col 'PEND_PO_QTY'    'Pending PO Qty'          '20' 'X'.

*  ADD_COL 'PO_VALUE'       'Pending PO Amount'       '20' 'X'.
  add_col 'OPEN_INV'       'Open Invoice Qty'        '20' 'X'.
  add_col 'AMOUNT'         'Last Item Price'         '20' 'C'.    "A= Max value; B=min value; C= Avg
  add_col 'VALUE'          'Moving Price'            '20' 'C'.      "Average
  add_col 'BKLAS'          'Valuation Class'         '20' ''.
  add_col 'MTART'          'Material Type'           '20' ''.
  add_col 'ERSDA'          'Material Created Date'   '20' ''.
  add_col 'MENGE_104'      '104 Qty'                 '15' 'X'.
  add_col 'QTY_104_VAL'    '104 Qty Value'           '15' 'X'.

ENDFORM.

FORM display_alv.
  DATA: lt_events TYPE slis_t_event.
*  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
*    IMPORTING
*      ET_EVENTS = LT_EVENTS.
*
**  READ TABLE LT_EVENTS WITH KEY NAME = SLIS_EV_SUBTOTAL_END
*  READ TABLE LT_EVENTS WITH KEY NAME = slis_ev_end_of_list
*                       INTO DATA(LS_EVENT).
*
**  READ TABLE LT_EVENTS INTO DATA(LS_EVENT) INDEX 1.
*  IF SY-SUBRC = 0.
*    LS_EVENT-FORM = 'SUBTOTAL_END'.
*    MODIFY LT_EVENTS FROM LS_EVENT INDEX sy-tabix.
*  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program     = sy-repid
      i_callback_top_of_page = 'TOP-OF-PAGE'
      it_fieldcat            = gt_fieldcat
      i_save                 = 'X'
      it_events              = lt_events
    TABLES
      t_outtab               = lt_out.
ENDFORM.

"==================== Simple export like your program ======================
FORM download_files.


  TYPE-POOLS truxs.
  DATA: it_csv      TYPE truxs_t_text_data,
        wa_csv      TYPE LINE OF truxs_t_text_data,
        hd_csv      TYPE LINE OF truxs_t_text_data,
        lv_file     TYPE string,
        lv_fullfile TYPE string,
        lv_msg(80)  TYPE c.

  " Build header (same titles you show)
  DATA(l_sep) = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE
    'Material Code' 'Material Description' 'USA Material Code' 'Brand' 'Series' 'Size' 'MOC' 'Type'
    'Pending SO' 'Pending So Value' 'Unrestricted Quantity' 'Unrestricted Value' 'Pending So Sales Total'
    'Stock In Hand' 'Stock In Hand Value' 'Consignment Stock' 'Consignment Stock Value'
    'Free Stock' 'Free Stock Value' 'Transit Qty' 'Transit Value'
    'SO Short Fall Qty' 'SO Short Fall Qty Value' 'Pending PO Qty' 'Pending PO Amount'
    'Open Invoice Qty' 'Last Item Price' 'Moving Price' 'Valuation Class' 'Material Type'
    'Material Created Date' '104 Qty' '104 Qty Value'
    INTO hd_csv SEPARATED BY l_sep.

  " Convert internal table to text lines
  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
    TABLES
      i_tab_sap_data       = lt_out
    CHANGING
      i_tab_converted_data = it_csv
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  lv_file = 'ZUS_STOCK_BANK_US01.TXT'.
  CONCATENATE p_folder '/' sy-datum sy-uzeit lv_file INTO lv_fullfile.

  OPEN DATASET lv_fullfile FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    DATA(lv_crlf) = cl_abap_char_utilities=>cr_lf.
    DATA(lv_buf)  = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_buf lv_crlf wa_csv INTO lv_buf.
    ENDLOOP.
    TRANSFER lv_buf TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
    CLOSE DATASET lv_fullfile.
  ENDIF.

  " Flat name version (no timestamp) like your second block
  CONCATENATE p_folder '/' 'ZUS_STOCK_BANK_US01.TXT' INTO lv_fullfile.
  OPEN DATASET lv_fullfile FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.
  IF sy-subrc = 0.
    DATA(lv_buf2) = hd_csv.
    LOOP AT it_csv INTO wa_csv.
      CONCATENATE lv_buf2 lv_crlf wa_csv INTO lv_buf2.
    ENDLOOP.
    TRANSFER lv_buf2 TO lv_fullfile.
    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
    MESSAGE lv_msg TYPE 'S'.
    CLOSE DATASET lv_fullfile.
  ENDIF.
ENDFORM.

FORM top-of-page.
*  ALV Header declarations
  DATA: t_header      TYPE slis_t_listheader,
        wa_header     TYPE slis_listheader,
        t_line        LIKE wa_header-info,
        ld_lines      TYPE i,
        ld_linesc(10) TYPE c.

*  Title
  wa_header-typ  = 'H'.
  wa_header-info = 'Stock Bank Report '.
  APPEND wa_header TO t_header.
  CLEAR wa_header.


  DESCRIBE TABLE lt_out LINES ld_lines.
  ld_linesc = ld_lines.

  CONCATENATE 'Total No. of Records Selected: ' ld_linesc
     INTO t_line SEPARATED BY space.

  wa_header-typ  = 'A'.
  wa_header-info = t_line.
  APPEND wa_header TO t_header.
  CLEAR: wa_header, t_line.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = t_header.
ENDFORM.

*FORM SUBTOTAL_END USING O_DATA_SOURCE
*  BREAK-POINT.
*ENDFORM.
