@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Master Composite – Full Parity'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_ItemMaster_Composite_Full 

     with parameters
    p_werks  : werks_d,
    p_spras  : abap.lang,
    p_set_id : abap.char(30)
as select from I_Product as P

left outer join ZC_MARC_Slice( p_werks: $parameters.p_werks ) as _MARC on _MARC.Product = P.Product
left outer join ZC_MBEW_Valuation( p_bwkey: $parameters.p_werks ) as _MBEW on _MBEW.Product = P.Product

 left outer join ZTF_ITEM_CLASS_PIVOT( p_spras  : $parameters.p_spras,
                                       p_set_id : $parameters.p_set_id ) as _Class on _Class.product = P.Product
 left outer join ZTF_ITEM_SLOC_FLAGS( p_werks : $parameters.p_werks )   as _SLoc   on _SLoc.product = P.Product  
 left outer join ZC_QMAT_Setting( p_werks : $parameters.p_werks ) as _QMAT on _QMAT.Product = P.Product
  association [0..1] to I_ProductDescription as _Text
    on _Text.Product  = P.Product and _Text.Language = $parameters.p_spras
  association [0..*] to ZC_MARM_UoM            as _MARM on _MARM.Product = P.Product
                                                       and _MARM.AltUoM = P.BaseUnit  
/*  association [0..1] to marm as _MARM on _MARM.matnr = P.Product and _MARM.meinh = P.BaseUnit */
  
/*  association [0..1] to ZC_MBEW_Valuation      with parameters p_bwkey: $parameters.p_werks
    as _MBEW on _MBEW.Product = P.Product
  association [0..n] to ZC_MARM_UoM            as _MARM on _MARM.Product = P.Product 
  association [0..1] to ZC_MLAN_Tax_IN         as _MLAN on _MLAN.Product = P.Product 
  */
  association [0..1] to ZC_MVKE_SalesArea      as _MVKE on _MVKE.Product = P.Product and _MVKE.SalesOrg = '1000'
  association [0..1] to ZC_Material_Audit      as _AUD  on _AUD.Product  = P.Product
  association [0..1] to mlan as _mlan on _mlan.matnr = P.Product and _mlan.aland = 'IN'
{
  /* Identification */
  key P.Product                               as Product,
      P._Text.ProductName                    as ProductDescription,
/*      _Text.ProductDescription                as ProductDescription, */
      P.IndustrySector                        as IndustrySector,
      P.ProductType                           as ProductType,
      P.BaseUnit                              as BaseUnit,
      P.CreationDate                          as CreationDate,
      P.CreatedByUser                         as Createdby,
      P.IsMarkedForDeletion                   as IsMarkedForDeletion,

  /* Plant/MRP (MARC) */
      $parameters.p_werks                     as Plant,
      _MARC.ProcurementType                   as BESKZ,
      _MARC.MRPType                           as DISMM,
      _MARC.MRPController                     as DISPO,
      _MARC.SpecialProcurement                as SOBSL,
      _MARC.PlantDeletionFlag                 as LVORM_Plant,
/* Custom field */
      _MARC.zboi                              as ZBOI_RAW, 
  
  /* Valuation (MBEW full) */
      _MBEW.ValuationArea                     as BWKEY,
      _MBEW.ValuationClass                    as BKLAS,
      _MBEW.PriceDeterminationControl         as VPRSV,
      @Semantics.amount.currencyCode: 'Currency'
      _MBEW.StandardPrice                     as STPRS,
      @Semantics.amount.currencyCode: 'Currency'
      _MBEW.MovingAveragePrice                as VERPR,
      @Semantics.amount.currencyCode: 'Currency'
      _MBEW.PlannedPrice1                     as ZPLP1,
      _MBEW.PlannedPrice1ValidFromDate        as ZPLD1,
      _MBEW.Currency                          as Currency,

  /* Alternate UoM (MARM – representative single row via min AltUoM) */
      _MARM.AltUoM                      as MEINH,
      min( _MARM.Numerator )                  as UMREZ,
      min( _MARM.Denominator )                as UMREN,

  /* Sales Area (MVKE) – representative single row via min key */
      min( _MVKE.SalesOrg )                   as VKORG,
      min( _MVKE.DistChannel_10 )             as VTWEG_10,
      min( _MVKE.DistChannel_20 )             as VTWEG_20,
      min( _MVKE.DistChannel_30 )             as VTWEG_30,
      min( _MVKE.SalesStatusText )            as VMSTB,

  /* Tax IN */
      _mlan.aland                             as LAND1,
      _mlan.taxm1                             as TAXM1,
      _mlan.taxm2                             as TAXM2,
      _mlan.taxm3                             as TAXM3,
      _mlan.taxm4                             as TAXM4,
      _mlan.taxm8                             as TAXM8,

  /* QM */
      _QMAT.InspActive                        as QINSP,
      _QMAT.InspectionType                    as IART,

  /* SLoc flags */
      _SLoc.flag_rm01                         as SL_RM01,
      _SLoc.flag_fg01                         as SL_FG01,
      _SLoc.flag_prd1                         as SL_PRD1,
      _SLoc.flag_kgrp                         as SL_K_GRP,

 _SLoc.flag_rj01    as   flag_rj01 ,
        _SLoc.flag_rwk1    as   flag_rwk1 ,
        _SLoc.flag_scr1    as   flag_scr1 ,
        _SLoc.flag_sfg1    as   flag_sfg1 ,
        _SLoc.flag_srn1    as   flag_srn1 ,
        _SLoc.flag_vld1    as   flag_vld1 ,
        _SLoc.flag_plg1    as   flag_plg1 ,
        _SLoc.flag_tpi1    as   flag_tpi1 ,
        _SLoc.flag_sc01    as   flag_sc01 ,
        _SLoc.flag_spc1    as   flag_spc1 ,
        _SLoc.flag_slr1    as   flag_slr1 ,
        _SLoc.flag_mcn1    as   flag_mcn1 ,
        _SLoc.flag_pn01    as   flag_pn01 ,
        _SLoc.flag_kmcn    as   flag_kmcn ,
        _SLoc.flag_kndt    as   flag_kndt ,
        _SLoc.flag_kplg    as   flag_kplg ,
        _SLoc.flag_kpr1    as   flag_kpr1 ,
        _SLoc.flag_kprd    as   flag_kprd ,
        _SLoc.flag_krj0    as   flag_krj0 ,
        _SLoc.flag_krm0    as   flag_krm0 ,
        _SLoc.flag_krwk    as   flag_krwk ,
        _SLoc.flag_ksc0    as   flag_ksc0 ,
        _SLoc.flag_kscr    as   flag_kscr ,
        _SLoc.flag_ksfg    as   flag_ksfg ,
        _SLoc.flag_kslr    as   flag_kslr ,
        _SLoc.flag_kspc    as   flag_kspc ,
        _SLoc.flag_ksrn    as   flag_ksrn ,
        _SLoc.flag_ktpi    as   flag_ktpi ,
        _SLoc.flag_kvld    as   flag_kvld ,
        _SLoc.flag_kfg0    as   flag_kfg0 ,

  /* Classification (pivot columns) */
      _Class.stem                             as STEM,
      _Class.seat                             as SEAT,
      _Class.body                             as BODY,
      _Class.disc                             as DISC,
      _Class.ball                             as BALL,
      _Class.rating                           as RATING,
      _Class.class_no                         as CLASS,
      _Class.air_fail                         as AIR_FAIL,
      _Class.main_air                         as MAIN_AIR,
      _Class.class_desc                       as CLASS_DESC,

  /* Custom field */
  /*    _ZBOI.ZBOI                              as ZBOI_RAW, */

  /* Change audit (CDHDR/CDPOS) */
      _AUD.DelUser                            as DEL_USER,
      _AUD.DelTCode                           as DEL_TCODE,
      _AUD.DelDate                            as DEL_DATE,
      _AUD.ModifyDate                         as MOD_DATE
     
  /* Expose parameterized associations */

/*  _MARC( p_werks: $parameters.p_werks ),
  _MBEW( p_bwkey: $parameters.p_werks ),
  _QMAT( p_werks: $parameters.p_werks ),
  _Class( p_spras: $parameters.p_spras, p_set_id: $parameters.p_set_id ),
  _SLoc ( p_werks: $parameters.p_werks )  */
}
group by
  P.Product, P._Text.ProductName, P.IndustrySector, P.ProductType, P.BaseUnit, P.CreationDate, P.CreatedByUser, P.IsMarkedForDeletion,
  _MARC.ProcurementType, _MARC.MRPType, _MARC.MRPController, _MARC.SpecialProcurement, _MARC.PlantDeletionFlag, _MARC.zboi,
  _MBEW.ValuationArea, _MBEW.ValuationClass, _MBEW.PriceDeterminationControl,
  _MBEW.StandardPrice, _MBEW.MovingAveragePrice, _MBEW.PlannedPrice1, _MBEW.PlannedPrice1ValidFromDate, _MBEW.Currency, _MARM.AltUoM,
  _mlan.aland, _mlan.taxm1, _mlan.taxm2, _mlan.taxm3, _mlan.taxm4, _mlan.taxm8,
  _QMAT.InspActive, _QMAT.InspectionType,
  _SLoc.flag_rm01, _SLoc.flag_fg01, _SLoc.flag_prd1, _SLoc.flag_kgrp,
   _SLoc.flag_rj01, _SLoc.flag_rwk1, _SLoc.flag_scr1, _SLoc.flag_sfg1,
   _SLoc.flag_srn1, _SLoc.flag_vld1, _SLoc.flag_plg1, _SLoc.flag_tpi1 ,
   _SLoc.flag_sc01, _SLoc.flag_spc1, _SLoc.flag_slr1, _SLoc.flag_mcn1 ,
   _SLoc.flag_pn01, _SLoc.flag_kmcn, _SLoc.flag_kndt, _SLoc.flag_kplg ,
   _SLoc.flag_kpr1, _SLoc.flag_kprd, _SLoc.flag_krj0, _SLoc.flag_krm0 ,      
   _SLoc.flag_krwk, _SLoc.flag_ksc0, _SLoc.flag_kscr, _SLoc.flag_ksfg ,
   _SLoc.flag_kslr, _SLoc.flag_kspc, _SLoc.flag_ksrn, _SLoc.flag_ktpi ,
   _SLoc.flag_kvld, _SLoc.flag_kfg0 ,
  
  _Class.stem, _Class.seat, _Class.body, _Class.disc, _Class.ball, _Class.rating, _Class.class_no, _Class.air_fail, _Class.main_air, _Class.class_desc,
   _AUD.DelUser, _AUD.DelTCode, _AUD.DelDate, _AUD.ModifyDate;
