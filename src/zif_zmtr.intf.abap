interface ZIF_ZMTR
  public .


  types:
    SOBES type C length 000001 .
  types:
    QUNUM type C length 000010 .
  types:
    QUPOS type N length 000003 .
  types:
    PS_PSP_ELE type N length 000008 .
  types:
    PLNUM type C length 000010 .
  types:
    CO_KDAUF type C length 000010 .
  types:
    CO_KDPOS type N length 000006 .
  types:
    KDEIN type N length 000004 .
  types:
    BESKZ type C length 000001 .
  types:
    CO_PSAMG type P length 7  decimals 000003 .
  types:
    CO_PSMNG type P length 7  decimals 000003 .
  types:
    CO_WEMNG type P length 7  decimals 000003 .
  types:
    CO_IAMNG type P length 7  decimals 000003 .
  types:
    CO_AUFME type C length 000003 .
  types:
    LAGME type C length 000003 .
  types:
    CO_MATNR type C length 000018 .
  types:
    AVMNG type P length 7  decimals 000003 .
  types:
    GSMNG type P length 7  decimals 000003 .
  types:
    KNTTP type C length 000001 .
  types:
    TPAUF type C length 000001 .
  types:
    CK_KALNR type N length 000012 .
  types:
    UEBTO type P length 2  decimals 000001 .
  types:
    UEBTK type C length 000001 .
  types:
    UNTTO type P length 2  decimals 000001 .
  types:
    INSMK type C length 000001 .
  types:
    WEPOS type C length 000001 .
  types:
    BWTAR_D type C length 000010 .
  types:
    BWTTY_D type C length 000001 .
  types:
    CO_PWERK type C length 000004 .
  types:
    LGORT_D type C length 000004 .
  types:
    UMREZ type P length 3  decimals 000000 .
  types:
    UMREN type P length 3  decimals 000000 .
  types:
    PLWEZ type P length 2  decimals 000000 .
  types:
    ELIKZ type C length 000001 .
  types:
    SA_AUFNR type C length 000012 .
  types:
    VERID type C length 000004 .
  types:
    SERNR type C length 000008 .
  types:
    TECHS type C length 000012 .
  types:
    WERKS_D type C length 000004 .
  types:
    AUFTYP type N length 000002 .
  types:
    AUFART type C length 000004 .
  types:
    CO_FREI type C length 000001 .
  types:
    CO_DNREL type C length 000001 .
  types:
    SA_VERTL type C length 000004 .
  types:
    SOBKZ type C length 000001 .
  types:
    KZVBR type C length 000001 .
  types:
    WEWRT type P length 7  decimals 000002 .
  types:
    WEUNB type C length 000001 .
  types:
    ABLAD type C length 000025 .
  types:
    WEMPF type C length 000012 .
  types:
    CHARG_D type C length 000010 .
  types:
    GSBER type C length 000004 .
  types:
    CO_WEAE type C length 000001 .
  types:
    CUOBJ type N length 000018 .
  types:
    KBNKZ type C length 000001 .
  types:
    ARSNR type N length 000010 .
  types:
    ARSPS type N length 000004 .
  types:
    RSNUM type N length 000010 .
  types:
    RSPOS type N length 000004 .
  types:
    CCKEY type C length 000023 .
  types:
    RTP01 type C length 000001 .
  types:
    RTP02 type C length 000001 .
  types:
    RTP03 type C length 000001 .
  types:
    RTP04 type C length 000001 .
  types:
    J_OBJNR type C length 000022 .
  types:
    CO_NDISR type C length 000001 .
  types:
    CO_VFMNG type P length 7  decimals 000003 .
  types:
    KZAVC type C length 000001 .
  types:
    KZBWS type C length 000001 .
  types:
    AUFLOEKZ type C length 000001 .
  types:
    SERAIL type C length 000004 .
  types:
    OCM_OBJ_TYPE type C length 000001 .
  types:
    OCM_CH_PROC type C length 000001 .
  types:
    CK_FIXPRKU type C length 000001 .
  types:
    BERID type C length 000010 .
  types:
    SGT_SCAT type C length 000016 .
  types:
    begin of AFPO_INC,
      PSOBS type SOBES,
      QUNUM type QUNUM,
      QUPOS type QUPOS,
      PROJN type PS_PSP_ELE,
      PLNUM type PLNUM,
      STRMP type DATS,
      ETRMP type DATS,
      KDAUF type CO_KDAUF,
      KDPOS type CO_KDPOS,
      KDEIN type KDEIN,
      BESKZ type BESKZ,
      PSAMG type CO_PSAMG,
      PSMNG type CO_PSMNG,
      WEMNG type CO_WEMNG,
      IAMNG type CO_IAMNG,
      AMEIN type CO_AUFME,
      MEINS type LAGME,
      MATNR type CO_MATNR,
      PAMNG type AVMNG,
      PGMNG type GSMNG,
      KNTTP type KNTTP,
      TPAUF type TPAUF,
      LTRMI type DATS,
      LTRMP type DATS,
      KALNR type CK_KALNR,
      UEBTO type UEBTO,
      UEBTK type UEBTK,
      UNTTO type UNTTO,
      INSMK type INSMK,
      WEPOS type WEPOS,
      BWTAR type BWTAR_D,
      BWTTY type BWTTY_D,
      PWERK type CO_PWERK,
      LGORT type LGORT_D,
      UMREZ type UMREZ,
      UMREN type UMREN,
      WEBAZ type PLWEZ,
      ELIKZ type ELIKZ,
      SAFNR type SA_AUFNR,
      VERID type VERID,
      SERNR type SERNR,
      TECHS type TECHS,
      DWERK type WERKS_D,
      DAUTY type AUFTYP,
      DAUAT type AUFART,
      DGLTP type DATS,
      DGLTS type DATS,
      DFREI type CO_FREI,
      DNREL type CO_DNREL,
      VERTO type SA_VERTL,
      SOBKZ type SOBKZ,
      KZVBR type KZVBR,
      WEWRT type WEWRT,
      WEUNB type WEUNB,
      ABLAD type ABLAD,
      WEMPF type WEMPF,
      CHARG type CHARG_D,
      GSBER type GSBER,
      WEAED type CO_WEAE,
      CUOBJ type CUOBJ,
      KBNKZ type KBNKZ,
      ARSNR type ARSNR,
      ARSPS type ARSPS,
      KRSNR type RSNUM,
      KRSPS type RSPOS,
      KCKEY type CCKEY,
      RTP01 type RTP01,
      RTP02 type RTP02,
      RTP03 type RTP03,
      RTP04 type RTP04,
      KSVON type DATS,
      KSBIS type DATS,
      OBJNP type J_OBJNR,
      NDISR type CO_NDISR,
      VFMNG type CO_VFMNG,
      GSBTR type DATS,
      KZAVC type KZAVC,
      KZBWS type KZBWS,
      XLOEK type AUFLOEKZ,
      SERNP type SERAIL,
      ANZSN type INT4,
      OBJTYPE type OCM_OBJ_TYPE,
      CH_PROC type OCM_CH_PROC,
      FXPRU type CK_FIXPRKU,
      CUOBJ_ROOT type CUOBJ,
      BERID type BERID,
      TECHS_COPY type TECHS,
      SGT_SCAT type SGT_SCAT,
    end of AFPO_INC .
  types:
    KUNNR type C length 000010 .
  types:
    begin of ADPM_ROT_KUNNR,
      KUNNR2 type KUNNR,
    end of ADPM_ROT_KUNNR .
  types:
    FSH_SAISJ type C length 000004 .
  types:
    FSH_SAISO type C length 000004 .
  types:
    FSH_COLLECTION type C length 000002 .
  types:
    FSH_THEME type C length 000004 .
  types:
    FSH_SALLOC_QTY type P length 7  decimals 000003 .
  types:
    begin of FSH_AFPODATA_APPEND,
      FSH_SEASON_YEAR type FSH_SAISJ,
      FSH_SEASON type FSH_SAISO,
      FSH_COLLECTION type FSH_COLLECTION,
      FSH_THEME type FSH_THEME,
      FSH_SALLOC_QTY type FSH_SALLOC_QTY,
    end of FSH_AFPODATA_APPEND .
  types:
    MILL_OC_AUFNR_U type C length 000012 .
  types:
    MILL_OC_RUMNG type P length 7  decimals 000003 .
  types:
    MILL_OC_SORT type N length 000008 .
  types:
    begin of MILL_OC,
      MILL_OC_AUFNR_U type MILL_OC_AUFNR_U,
      MILL_OC_RUMNG type MILL_OC_RUMNG,
      MILL_OC_SORT type MILL_OC_SORT,
    end of MILL_OC .
  types:
    MANDT type C length 000003 .
  types:
    AUFNR type C length 000012 .
  types:
    CO_POSNR type N length 000004 .
  types:
    begin of AFPO,
      MANDT type MANDT,
      AUFNR type AUFNR,
      POSNR type CO_POSNR.
    include type AFPO_INC.
    include type ADPM_ROT_KUNNR.
    include type FSH_AFPODATA_APPEND.
    include type MILL_OC.
    types:
    end of AFPO .
  types:
    ATINN type N length 000010 .
  types:
    KDAUF type C length 000010 .
  types:
    BSTNK type C length 000020 .
  types:
    MATNR type C length 000018 .
  types:
    MAKTX type C length 000040 .
  types:
    ZSIZE type C length 000003 .
  types:
    ATWRT type C length 000030 .
  types:
    ZCLASS type C length 000030 .
  types:
    ZSHELL type C length 000030 .
  types:
    ZSEAT type C length 000030 .
  types:
    ZPNEUMATIC type C length 000030 .
  types:
    begin of ZSTR_FINAL,
      MANDT type MANDT,
      AUFNR type AUFNR,
      ATINN type ATINN,
      KDAUF type KDAUF,
      KUNNR type KUNNR,
      BSTNK type BSTNK,
      BSTDK type DATS,
      MATNR type MATNR,
      MAKTX type MAKTX,
      ZSIZE type ZSIZE,
      ATWRT type ATWRT,
      CLASS type ZCLASS,
      SHELL_TEST type ZSHELL,
      SEAT_TEST type ZSEAT,
      PNEUMATIC type ZPNEUMATIC,
    end of ZSTR_FINAL .
  types:
    __ZSTR_FINAL                   type standard table of ZSTR_FINAL                     with non-unique default key .
endinterface.
