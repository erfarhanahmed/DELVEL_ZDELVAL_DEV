CLASS zcl_amdp_item_master DEFINITION
  PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS tf_item_class_pivot
      FOR TABLE FUNCTION ztf_item_class_pivot.

    CLASS-METHODS tf_item_sloc_flags
      FOR TABLE FUNCTION ztf_item_sloc_flags.
ENDCLASS.

CLASS zcl_amdp_item_master IMPLEMENTATION.

  METHOD tf_item_class_pivot BY DATABASE FUNCTION
    FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
    USING ausp inob kssk klah zct_atinn_map.

    DECLARE lv_Set_id NVARCHAR( 30 );   --Local variable
    /* local defaulting of set id */
    lv_set_id = COALESCE(:p_set_id, 'DEFAULT');

    atinn_map =
      SELECT UPPER(m.logical_name) AS lname,
             m.atinn               AS atinn
        FROM zct_atinn_map AS m
       WHERE m.set_id = :lv_set_id
         AND UPPER(m.logical_name) IN
             ('STEM','SEAT','BODY','DISC','BALL','RATING','AIR_FAIL','MAIN_AIR');

    inob_m =
      SELECT objek AS product, cuobj
        FROM inob
       WHERE klart = '001'
         AND objek IS NOT NULL
         AND cuobj  IS NOT NULL;

    auspx =
      SELECT i.product,
             a.atinn,
             CASE
               WHEN a.atwrt IS NOT NULL AND a.atwrt <> '' THEN a.atwrt
               ELSE TO_NVARCHAR(a.atflv)
             END AS val
        FROM ausp AS a
        JOIN :inob_m    AS i ON i.cuobj = a.objek
        JOIN :atinn_map AS m ON m.atinn = a.atinn;

    class_jn =
      SELECT DISTINCT i.product, k.clint
        FROM :inob_m AS i
        JOIN kssk    AS k ON k.objek = i.cuobj AND k.klart = '001';

    class_tx =
      SELECT kh.clint, kh.class, TO_NVARCHAR(kh.klart) AS klart_txt
        FROM klah AS kh;

    RETURN
      SELECT SESSION_CONTEXT('CLIENT') AS mandt,
             ax.product                AS product,
             '001'                     AS class_type,
             FIRST_VALUE(ct.class)
               OVER (PARTITION BY ax.product ORDER BY ct.class DESC)     AS class_no,
             MAX(CASE WHEN am.lname = 'STEM'     THEN ax.val END)        AS stem,
             MAX(CASE WHEN am.lname = 'SEAT'     THEN ax.val END)        AS seat,
             MAX(CASE WHEN am.lname = 'BODY'     THEN ax.val END)        AS body,
             MAX(CASE WHEN am.lname = 'DISC'     THEN ax.val END)        AS disc,
             MAX(CASE WHEN am.lname = 'BALL'     THEN ax.val END)        AS ball,
             MAX(CASE WHEN am.lname = 'RATING'   THEN ax.val END)        AS rating,
             MAX(CASE WHEN am.lname = 'AIR_FAIL' THEN ax.val END)        AS air_fail,
             MAX(CASE WHEN am.lname = 'MAIN_AIR' THEN ax.val END)        AS main_air,
             FIRST_VALUE(ct.klart_txt)
               OVER (PARTITION BY ax.product ORDER BY ct.klart_txt DESC) AS class_desc
        FROM :auspx      AS ax
        JOIN :atinn_map  AS am ON am.atinn = ax.atinn
        LEFT JOIN :class_jn AS cj ON cj.product = ax.product
        LEFT JOIN :class_tx AS ct ON ct.clint   = cj.clint
       GROUP BY ax.product, ct.class, ct.klart_txt;

  ENDMETHOD.

  METHOD tf_item_sloc_flags BY DATABASE FUNCTION
    FOR HDB LANGUAGE SQLSCRIPT OPTIONS READ-ONLY
    USING mard zcfg_sloc_flag.

    base =
      SELECT DISTINCT matnr AS product, werks, lgort
        FROM mard
       WHERE werks = :p_werks;

    cfg =
      SELECT flag_name,
             COALESCE(lgort, '')   AS lgort,
             COALESCE(pattern, '') AS pattern
        FROM zcfg_sloc_flag
       WHERE werks  = :p_werks
         AND active = 'X';

/* Below code is to read text */


/*    rm01_t = SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'RM01' FETCH FIRST 1 ROWS ONLY), 'RM01') AS lg;
    fg01_t = SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'FG01' FETCH FIRST 1 ROWS ONLY), 'FG01') AS lg;
    prd1_t = SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'PRD1' FETCH FIRST 1 ROWS ONLY), 'PRD1') AS lg;
    kgrp_t = SELECT COALESCE( (SELECT pattern FROM :cfg WHERE flag_name = 'KGRP' FETCH FIRST 1 ROWS ONLY), 'K%')   AS pat; */

    rm01_t = SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'RM01' LIMIT 1 ), 'RM01') AS lg from dummy;
    fg01_t = SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'FG01' LIMIT 1 ), 'FG01') AS lg from dummy;
    prd1_t = SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'PRD1' LIMIT 1 ), 'PRD1') AS lg from dummy;

    rj01_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'RJ01' LIMIT 1 ),  'RJ01') AS lg from dummy;
    rwk1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'RWK1' LIMIT 1 ),  'RWK1') AS lg from dummy;
    scr1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'SCR1' LIMIT 1 ),  'SCR1') AS lg from dummy;
    sfg1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'SFG1' LIMIT 1 ),  'SFG1') AS lg from dummy;
    srn1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'SRN1' LIMIT 1 ),  'SRN1') AS lg from dummy;
    vld1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'VLD1' LIMIT 1 ),  'VLD1') AS lg from dummy;
    plg1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'PLG1' LIMIT 1 ),  'PLG1') AS lg from dummy;
    tpi1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'TPI1' LIMIT 1 ),  'TPI1') AS lg from dummy;
    sc01_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'SC01' LIMIT 1 ),  'SC01') AS lg from dummy;
    spc1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'SPC1' LIMIT 1 ),  'SPC1') AS lg from dummy;
    slr1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'SLR1' LIMIT 1 ),  'SLR1') AS lg from dummy;
    mcn1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'MCN1' LIMIT 1 ),  'MCN1') AS lg from dummy;
    pn01_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'PN01' LIMIT 1 ),  'PN01') AS lg from dummy;
    kmcn_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KMCN' LIMIT 1 ),  'KMCN') AS lg from dummy;
    kndt_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KNDT' LIMIT 1 ),  'KNDT') AS lg from dummy;
    kplg_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KPLG' LIMIT 1 ),  'KPLG') AS lg from dummy;
    kpr1_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KPR1' LIMIT 1 ),  'KPR1') AS lg from dummy;
    kprd_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KPRD' LIMIT 1 ),  'KPRD') AS lg from dummy;
    krj0_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KRJ0' LIMIT 1 ),  'KRJ0') AS lg from dummy;
    krm0_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KRM0' LIMIT 1 ),  'KRM0') AS lg from dummy;
    krwk_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KRWK' LIMIT 1 ),  'KRWK') AS lg from dummy;
    ksc0_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KSC0' LIMIT 1 ),  'KSC0') AS lg from dummy;
    kscr_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KSCR' LIMIT 1 ),  'KSCR') AS lg from dummy;
    ksfg_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KSFG' LIMIT 1 ),  'KSFG') AS lg from dummy;
    kslr_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KSLR' LIMIT 1 ),  'KSLR') AS lg from dummy;
    kspc_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KSPC' LIMIT 1 ),  'KSPC') AS lg from dummy;
    ksrn_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KSRN' LIMIT 1 ),  'KSRN') AS lg from dummy;
    ktpi_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KTPI' LIMIT 1 ),  'KTPI') AS lg from dummy;
    kvld_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KVLD' LIMIT 1 ),  'KVLD') AS lg from dummy;
    kfg0_t  =  SELECT COALESCE( (SELECT lgort   FROM :cfg WHERE flag_name = 'KFG0' LIMIT 1 ),  'KFG0') AS lg from dummy;

    kgrp_t = SELECT COALESCE( (SELECT pattern FROM :cfg WHERE flag_name = 'KGRP' LIMIT 1 ), 'K%')   AS pat from dummy;

    /* single-pass aggregation per your suggestion */
    sel_all_flags =
      SELECT b.product,
             b.lgort,
             CASE WHEN b.lgort = (SELECT lg  FROM :rm01_t) THEN 1 ELSE 0 END AS is_rm01,
             CASE WHEN b.lgort = (SELECT lg  FROM :fg01_t) THEN 1 ELSE 0 END AS is_fg01,
             CASE WHEN b.lgort = (SELECT lg  FROM :prd1_t) THEN 1 ELSE 0 END AS is_prd1,

             CASE WHEN b.lgort = (SELECT lg from :rj01_t) THEN 1 ELSE 0 END AS is_rj01,
            CASE WHEN b.lgort = (SELECT lg from :rwk1_t) THEN 1 ELSE 0 END AS is_rwk1,
            CASE WHEN b.lgort = (SELECT lg from :scr1_t) THEN 1 ELSE 0 END AS is_scr1,
            CASE WHEN b.lgort = (SELECT lg from :sfg1_t) THEN 1 ELSE 0 END AS is_sfg1,
            CASE WHEN b.lgort = (SELECT lg from :srn1_t) THEN 1 ELSE 0 END AS is_srn1,
            CASE WHEN b.lgort = (SELECT lg from :vld1_t) THEN 1 ELSE 0 END AS is_vld1,
            CASE WHEN b.lgort = (SELECT lg from :plg1_t) THEN 1 ELSE 0 END AS is_plg1,
            CASE WHEN b.lgort = (SELECT lg from :tpi1_t) THEN 1 ELSE 0 END AS is_tpi1,
            CASE WHEN b.lgort = (SELECT lg from :sc01_t) THEN 1 ELSE 0 END AS is_sc01,
            CASE WHEN b.lgort = (SELECT lg from :spc1_t) THEN 1 ELSE 0 END AS is_spc1,
            CASE WHEN b.lgort = (SELECT lg from :slr1_t) THEN 1 ELSE 0 END AS is_slr1,
            CASE WHEN b.lgort = (SELECT lg from :mcn1_t) THEN 1 ELSE 0 END AS is_mcn1,
            CASE WHEN b.lgort = (SELECT lg from :pn01_t) THEN 1 ELSE 0 END AS is_pn01,
            CASE WHEN b.lgort = (SELECT lg from :kmcn_t) THEN 1 ELSE 0 END AS is_kmcn,
            CASE WHEN b.lgort = (SELECT lg from :kndt_t) THEN 1 ELSE 0 END AS is_kndt,
            CASE WHEN b.lgort = (SELECT lg from :kplg_t) THEN 1 ELSE 0 END AS is_kplg,
            CASE WHEN b.lgort = (SELECT lg from :kpr1_t) THEN 1 ELSE 0 END AS is_kpr1,
            CASE WHEN b.lgort = (SELECT lg from :kprd_t) THEN 1 ELSE 0 END AS is_kprd,
            CASE WHEN b.lgort = (SELECT lg from :krj0_t) THEN 1 ELSE 0 END AS is_krj0,
            CASE WHEN b.lgort = (SELECT lg from :krm0_t) THEN 1 ELSE 0 END AS is_krm0,
            CASE WHEN b.lgort = (SELECT lg from :krwk_t) THEN 1 ELSE 0 END AS is_krwk,
            CASE WHEN b.lgort = (SELECT lg from :ksc0_t) THEN 1 ELSE 0 END AS is_ksc0,
            CASE WHEN b.lgort = (SELECT lg from :kscr_t) THEN 1 ELSE 0 END AS is_kscr,
            CASE WHEN b.lgort = (SELECT lg from :ksfg_t) THEN 1 ELSE 0 END AS is_ksfg,
            CASE WHEN b.lgort = (SELECT lg from :kslr_t) THEN 1 ELSE 0 END AS is_kslr,
            CASE WHEN b.lgort = (SELECT lg from :kspc_t) THEN 1 ELSE 0 END AS is_kspc,
            CASE WHEN b.lgort = (SELECT lg from :ksrn_t) THEN 1 ELSE 0 END AS is_ksrn,
            CASE WHEN b.lgort = (SELECT lg from :ktpi_t) THEN 1 ELSE 0 END AS is_ktpi,
            CASE WHEN b.lgort = (SELECT lg from :kvld_t) THEN 1 ELSE 0 END AS is_kvld,
            CASE WHEN b.lgort = (SELECT lg from :kfg0_t) THEN 1 ELSE 0 END AS is_kfg0,

             CASE WHEN b.lgort LIKE (SELECT pat FROM :kgrp_t) THEN 1 ELSE 0 END AS is_kgrp
        FROM :base AS b;

    RETURN
      SELECT SESSION_CONTEXT('CLIENT') AS mandt,
             product,
             :p_werks AS werks,
             CASE WHEN MAX(is_rm01) = 1 THEN 'Yes' ELSE '' END AS flag_rm01,
             CASE WHEN MAX(is_fg01) = 1 THEN 'Yes' ELSE '' END AS flag_fg01,
             CASE WHEN MAX(is_prd1) = 1 THEN 'Yes' ELSE '' END AS flag_prd1,

            CASE WHEN MAX(is_rj01) = 1 THEN 'Yes' ELSE '' END AS flag_rj01,
            CASE WHEN MAX(is_rwk1) = 1 THEN 'Yes' ELSE '' END AS flag_rwk1,
            CASE WHEN MAX(is_scr1) = 1 THEN 'Yes' ELSE '' END AS flag_scr1,
            CASE WHEN MAX(is_sfg1) = 1 THEN 'Yes' ELSE '' END AS flag_sfg1,
            CASE WHEN MAX(is_srn1) = 1 THEN 'Yes' ELSE '' END AS flag_srn1,
            CASE WHEN MAX(is_vld1) = 1 THEN 'Yes' ELSE '' END AS flag_vld1,
            CASE WHEN MAX(is_plg1) = 1 THEN 'Yes' ELSE '' END AS flag_plg1,
            CASE WHEN MAX(is_tpi1) = 1 THEN 'Yes' ELSE '' END AS flag_tpi1,
            CASE WHEN MAX(is_sc01) = 1 THEN 'Yes' ELSE '' END AS flag_sc01,
            CASE WHEN MAX(is_spc1) = 1 THEN 'Yes' ELSE '' END AS flag_spc1,
            CASE WHEN MAX(is_slr1) = 1 THEN 'Yes' ELSE '' END AS flag_slr1,
            CASE WHEN MAX(is_mcn1) = 1 THEN 'Yes' ELSE '' END AS flag_mcn1,
            CASE WHEN MAX(is_pn01) = 1 THEN 'Yes' ELSE '' END AS flag_pn01,
            CASE WHEN MAX(is_kmcn) = 1 THEN 'Yes' ELSE '' END AS flag_kmcn,
            CASE WHEN MAX(is_kndt) = 1 THEN 'Yes' ELSE '' END AS flag_kndt,
            CASE WHEN MAX(is_kplg) = 1 THEN 'Yes' ELSE '' END AS flag_kplg,
            CASE WHEN MAX(is_kpr1) = 1 THEN 'Yes' ELSE '' END AS flag_kpr1,
            CASE WHEN MAX(is_kprd) = 1 THEN 'Yes' ELSE '' END AS flag_kprd,
            CASE WHEN MAX(is_krj0) = 1 THEN 'Yes' ELSE '' END AS flag_krj0,
            CASE WHEN MAX(is_krm0) = 1 THEN 'Yes' ELSE '' END AS flag_krm0,
            CASE WHEN MAX(is_krwk) = 1 THEN 'Yes' ELSE '' END AS flag_krwk,
            CASE WHEN MAX(is_ksc0) = 1 THEN 'Yes' ELSE '' END AS flag_ksc0,
            CASE WHEN MAX(is_kscr) = 1 THEN 'Yes' ELSE '' END AS flag_kscr,
            CASE WHEN MAX(is_ksfg) = 1 THEN 'Yes' ELSE '' END AS flag_ksfg,
            CASE WHEN MAX(is_kslr) = 1 THEN 'Yes' ELSE '' END AS flag_kslr,
            CASE WHEN MAX(is_kspc) = 1 THEN 'Yes' ELSE '' END AS flag_kspc,
            CASE WHEN MAX(is_ksrn) = 1 THEN 'Yes' ELSE '' END AS flag_ksrn,
            CASE WHEN MAX(is_ktpi) = 1 THEN 'Yes' ELSE '' END AS flag_ktpi,
            CASE WHEN MAX(is_kvld) = 1 THEN 'Yes' ELSE '' END AS flag_kvld,
            CASE WHEN MAX(is_kfg0) = 1 THEN 'Yes' ELSE '' END AS flag_kfg0,

             CASE WHEN MAX(is_kgrp) = 1 THEN 'Yes' ELSE '' END AS flag_kgrp
        FROM :sel_all_flags
       GROUP BY product;

  ENDMETHOD.

ENDCLASS.

