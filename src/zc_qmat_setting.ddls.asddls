@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Distinct QM settings (QMAT)'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_QMAT_Setting 

with parameters p_werks : werks_d
as select distinct from qmat
{
  key matnr as Product,
  key werks as Plant,
      aktiv as InspActive,
      art   as InspectionType
}
where werks = $parameters.p_werks;
