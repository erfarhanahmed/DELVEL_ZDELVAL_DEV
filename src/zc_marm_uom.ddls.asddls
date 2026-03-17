@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MARM alternative UoM'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_MARM_UoM 
    as select from marm
{
  key matnr as Product,
      meinh as AltUoM,
      umrez as Numerator,
      umren as Denominator
}
