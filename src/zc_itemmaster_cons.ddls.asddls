@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Master Consumption'

define view entity ZC_ItemMaster_Cons
 with parameters
    p_werks  : werks_d,
    p_spras  : abap.lang,
    p_set_id : abap.char(30)
as select from ZC_ItemMaster_Composite(
    p_werks : $parameters.p_werks,
    p_spras : $parameters.p_spras,
    p_set_id: $parameters.p_set_id
) as C
{
  key C.Product,
      C.ProductDescription,
      C.ProductType,
      C.IndustrySector,
      C.BaseUnit,
      C.CreationDate,
      C.IsMarkedForDeletion,

      C.Plant,
      C.ValuationArea,
      C.ValuationClass,
      C.PriceControl,
      
      @EndUserText.label: 'RM01'  
      C.Flag_RM01, 
      @EndUserText.label: 'FG01'
      C.Flag_FG01, 
      @EndUserText.label: 'PRD1'
      C.Flag_PRD1, 
      @EndUserText.label: 'K_GRP'
      C.Flag_K_GRP,
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
              
      C.ClassType, 
      @EndUserText.label: 'Class'
      @EndUserText.quickInfo: 'Class'
      C.ClassNo,
      @EndUserText.label: 'Stem'
      @EndUserText.quickInfo: 'Stem'
      C.Stem, 
      @EndUserText.label: 'Seat'
      @EndUserText.quickInfo: 'Seat'
      C.Seat, 
      @EndUserText.label: 'Body'
      @EndUserText.quickInfo: 'Body'
      C.Body, 
      @EndUserText.label: 'Disc'
      @EndUserText.quickInfo: 'Disc'
      C.Disc, 
      @EndUserText.label: 'Ball'
      @EndUserText.quickInfo: 'Ball'
      C.Ball, 
      @EndUserText.label: 'Rating'
      @EndUserText.quickInfo: 'Rating'
      C.Rating, 
      @EndUserText.label: 'Air_Fail_Position'
      @EndUserText.quickInfo: 'Air Fail Position'
      C.AirFail, 
      @EndUserText.label: 'Min_Air_Pressure'
      @EndUserText.quickInfo: 'Min Air Pressure'
      C.MainAir, 
      @EndUserText.label: 'Class Desc'
      @EndUserText.quickInfo: 'Class Description'
      C.ClassDesc
}

