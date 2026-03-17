@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MBEW valuation full (unit prices, planned)'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_MBEW_Valuation 
    with parameters p_bwkey : bwkey
as select from mbew as a 
    left outer join t001k as b on b.bwkey = a.bwkey
    left outer join t001 as c on c.bukrs = b.bukrs
{
  key a.matnr  as Product,
  key a.bwkey  as ValuationArea,
      a.bklas  as ValuationClass,
      a.vprsv  as PriceDeterminationControl,
       @Semantics.amount.currencyCode: 'Currency'
      a.stprs  as StandardPrice,
       @Semantics.amount.currencyCode: 'Currency'
      a.verpr  as MovingAveragePrice,
       @Semantics.amount.currencyCode: 'Currency'
      a.zplp1  as PlannedPrice1,
      a.zpld1  as PlannedPrice1ValidFromDate,
      b.bukrs  as CompanyCode,
      c.waers   as Currency
}
where a.bwkey = $parameters.p_bwkey;
