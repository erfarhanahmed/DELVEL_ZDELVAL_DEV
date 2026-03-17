@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MARC slice for Plant/MRP'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_MARC_Slice 

with parameters p_werks : werks_d
as select from marc as a
 left outer join mara as b on b.matnr = a.matnr
{
  key a.matnr       as Product,
  key a.werks       as Plant,
      a.beskz       as ProcurementType,
      a.dismm       as MRPType,
      a.dispo       as MRPController,     // DISPO
      a.sobsl       as SpecialProcurement,
      a.lvorm       as PlantDeletionFlag,
      b.zboi        as zboi
}
where a.werks = $parameters.p_werks;
