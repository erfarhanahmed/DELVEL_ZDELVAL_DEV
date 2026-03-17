@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material deletion and last MM02'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZC_Material_Audit 
   as select from cdhdr as H
    inner join cdpos as P
      on  H.changenr = P.changenr
      and H.objectid = P.objectid
{
  key P.objectid as Product,

      max( case when H.tcode = 'MM02' then H.udate end ) as ModifyDate,

      // deletion info comes from the LVORM change rows
      max( case when P.fname = 'LVORM' then H.udate end ) as DelDate,
      max( case when P.fname = 'LVORM' then H.username end ) as DelUser,
      max( case when P.fname = 'LVORM' then H.tcode   end ) as DelTCode
}
where ( P.tabname = 'MARA' or P.tabname = 'MARC' )
  and P.fname = 'LVORM'
  and P.value_new = 'X'
group by P.objectid;
