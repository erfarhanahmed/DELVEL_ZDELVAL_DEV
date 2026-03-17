@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Master Composite (S/4HANA)'

define view entity ZC_ItemMaster_Composite
  with parameters
    p_werks  : werks_d,
    p_spras  : abap.lang,
    p_set_id : abap.char(30)
as select from I_Product as P
 left outer join ZTF_ITEM_CLASS_PIVOT( p_spras  : $parameters.p_spras,
                                       p_set_id : $parameters.p_set_id ) as _Class on _Class.product = P.Product
 left outer join ZTF_ITEM_SLOC_FLAGS( p_werks : $parameters.p_werks )   as _SLoc   on _SLoc.product = P.Product                                     
 
  association [0..1] to I_ProductDescription    as _ProdText
    on  _ProdText.Product  = P.Product
    and _ProdText.Language = $parameters.p_spras

  association [0..1] to I_ProductPlant          as _Plant
    on  _Plant.Product = P.Product
    and _Plant.Plant   = $parameters.p_werks

  association [0..1] to I_ProductValuationBasic as _ValB
    on  _ValB.Product       = P.Product
    and _ValB.ValuationArea = $parameters.p_werks

/*  association [0..1] to ZTF_ITEM_CLASS_PIVOT  as _Class  on _Class.product = P.Product 
  association [0..1] to ZTF_ITEM_SLOC_FLAGS   as _SLoc   on _SLoc.product = P.Product */
{
  key P.Product                               as Product,
      P.ProductType                           as ProductType,
      P.IndustrySector                        as IndustrySector,
/*      @Semantics.unitOfMeasure: true */
      P.BaseUnit                              as BaseUnit,
      P.CreationDate                          as CreationDate,
      P.IsMarkedForDeletion                   as IsMarkedForDeletion,

      _ProdText.ProductDescription            as ProductDescription,

      _Plant.Plant                            as Plant,

      _ValB.ValuationArea                     as ValuationArea,
      _ValB.ValuationClass                    as ValuationClass,
      _ValB.PriceDeterminationControl         as PriceControl,

      _SLoc.flag_rm01                         as Flag_RM01,
      _SLoc.flag_fg01                         as Flag_FG01,
      _SLoc.flag_prd1                         as Flag_PRD1,
      _SLoc.flag_kgrp                         as Flag_K_GRP,

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

      _Class.class_type                       as ClassType,
      _Class.class_no                         as ClassNo,
      _Class.stem                             as Stem,
      _Class.seat                             as Seat,
      _Class.body                             as Body,
      _Class.disc                             as Disc,
      _Class.ball                             as Ball,
      _Class.rating                           as Rating,
      _Class.air_fail                         as AirFail,
      _Class.main_air                         as MainAir,
      _Class.class_desc                       as ClassDesc

  /* explicit parameterized association exposure */
/*  _Class( p_spras: $parameters.p_spras, p_set_id: $parameters.p_set_id ), 
  _SLoc ( p_werks: $parameters.p_werks ) */
}
