@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Master Consumption – Full Parity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_ItemMaster_Cons_Full 
     with parameters
    p_werks  : werks_d,
    p_spras  : abap.lang,
    p_set_id : abap.char(30)
as select from ZC_ItemMaster_Composite_Full(
    p_werks: $parameters.p_werks,
    p_spras: $parameters.p_spras,
    p_set_id: $parameters.p_set_id
) as C
{
  key C.Product,
      C.ProductDescription,
      C.IndustrySector,
      C.ProductType,
      C.BaseUnit,
      C.CreationDate,
      C.Createdby,
      C.IsMarkedForDeletion,
      
      C.Plant,
      C.BESKZ, C.DISMM, C.DISPO, C.SOBSL, C.LVORM_Plant,

      C.BWKEY, C.BKLAS, C.VPRSV, 
      @Semantics.amount.currencyCode: 'Currency'
      C.STPRS, 
      @Semantics.amount.currencyCode: 'Currency'
      C.VERPR, 
      @Semantics.amount.currencyCode: 'Currency'
      C.ZPLP1, 
      C.ZPLD1,
      C.Currency,
      C.MEINH, C.UMREZ, C.UMREN,

      C.VKORG, 
      C.VTWEG_10,
      C.VTWEG_20,
      C.VTWEG_30, 
      C.VMSTB,

      C.LAND1, 
      C.TAXM1, 
      C.TAXM2, 
      C.TAXM3, 
      C.TAXM4, 
      C.TAXM8,

      C.QINSP, C.IART,

 /*     C.SL_RM01, C.SL_FG01, C.SL_PRD1, C.SL_K_GRP, */
      @EndUserText.label: 'RM01'  
      C.SL_RM01, 
      @EndUserText.label: 'FG01'
      C.SL_FG01, 
      @EndUserText.label: 'PRD1'
      C.SL_PRD1, 
      @EndUserText.label: 'K_GRP'
      C.SL_K_GRP,
      @EndUserText.label: 'RJ01'
      C.flag_rj01 ,
      @EndUserText.label: 'RWK1'
        C.flag_rwk1 ,
        @EndUserText.label: 'SCR1'
        C.flag_scr1 ,
        @EndUserText.label: 'SFG1'
        C.flag_sfg1 ,
        @EndUserText.label: 'SRN1'
        C.flag_srn1 ,
        @EndUserText.label: 'VLD1'
        C.flag_vld1 ,
        @EndUserText.label: 'PLG1'
        C.flag_plg1 ,
        @EndUserText.label: 'TPI1'
        C.flag_tpi1 ,
        @EndUserText.label: 'SC01'
        C.flag_sc01 ,
        @EndUserText.label: 'SPC1'
        C.flag_spc1 ,
        @EndUserText.label: 'SLR1'
        C.flag_slr1 ,
        @EndUserText.label: 'MCN1'
        C.flag_mcn1 ,
        @EndUserText.label: 'PN01'
        C.flag_pn01 ,
        @EndUserText.label: 'KMCN'
        C.flag_kmcn ,
        @EndUserText.label: 'KNDT'
        C.flag_kndt ,
        @EndUserText.label: 'KPLG'
        C.flag_kplg ,
        @EndUserText.label: 'KPR1'
        C.flag_kpr1 ,
        @EndUserText.label: 'KPRD'
        C.flag_kprd ,
        @EndUserText.label: 'KRJ0'
        C.flag_krj0 ,
        @EndUserText.label: 'KRM0'
        C.flag_krm0 ,
        @EndUserText.label: 'KRWK'
        C.flag_krwk ,
        @EndUserText.label: 'KSC0'
        C.flag_ksc0 ,
        @EndUserText.label: 'KSCR'
        C.flag_kscr ,
        @EndUserText.label: 'KSFG'
        C.flag_ksfg ,
        @EndUserText.label: 'KSLR'
        C.flag_kslr ,
        @EndUserText.label: 'KSPC'
        C.flag_kspc ,
        @EndUserText.label: 'KSRN'
        C.flag_ksrn ,
        @EndUserText.label: 'KTPI'
        C.flag_ktpi ,
        @EndUserText.label: 'KVLD'
        C.flag_kvld ,
        @EndUserText.label: 'KFG0'
        C.flag_kfg0 ,

      @EndUserText.label: 'Stem'
      @EndUserText.quickInfo: 'Stem'
      C.STEM, 
      @EndUserText.label: 'Seat'
      @EndUserText.quickInfo: 'Seat'      
      C.SEAT, 
      @EndUserText.label: 'Body'
      @EndUserText.quickInfo: 'Body'      
      C.BODY, 
      @EndUserText.label: 'Disc'
      @EndUserText.quickInfo: 'Disc'      
      C.DISC, 
      @EndUserText.label: 'Ball'
      @EndUserText.quickInfo: 'Ball'      
      C.BALL, 
      @EndUserText.label: 'Rating'
      @EndUserText.quickInfo: 'Rating'      
      C.RATING, 
      @EndUserText.label: 'Class'
      @EndUserText.quickInfo: 'Class'
      C.CLASS, 
      @EndUserText.label: 'Air_Fail_Position'
      @EndUserText.quickInfo: 'Air Fail Position'      
      C.AIR_FAIL, 
      @EndUserText.label: 'Min_Air_Pressure'
      @EndUserText.quickInfo: 'Min Air Pressure'      
      C.MAIN_AIR, 
      
      C.CLASS_DESC,

      C.ZBOI_RAW,

      C.DEL_USER,
      C.DEL_TCODE, 
      C.DEL_DATE, 
      C.MOD_DATE,
      cast('' as abap.char( 10 ) ) as zboi_disp,
      cast('' as abap.char( 122 ) ) as MATTEXT_EN,
      cast('' as abap.char( 122 ) ) as MATTEXT_S
}
