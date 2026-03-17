@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales area slice + status text'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_MVKE_SalesArea 
 as select from mvke as a
  left outer join tvmst as b
    on b.vmsta = a.vmsta
   and b.spras = $session.system_language
{
  key a.matnr as Product,
  key a.vkorg as SalesOrg,
   max(cast(
        case when a.vtweg = '10' then a.vtweg
              else '' end as abap.char( 2 ) ) ) as DistChannel_10,
   max(cast(
        case when a.vtweg = '20' then a.vtweg
              else '' end as abap.char( 2 ) ) ) as DistChannel_20,
   max(cast(
        case when a.vtweg = '30' then a.vtweg
              else '' end as abap.char( 2 ) ) ) as DistChannel_30,                            
      a.vmsta as SalesStatus,
      b.vmstb as SalesStatusText
} group by a.matnr, a.vkorg, a.vmsta, b.vmstb
