@EndUserText.label: 'Item Classification Pivot(AUSP→columns)'
/*@ClientHandling.type: #INHERITED*/
define table function ZTF_ITEM_CLASS_PIVOT
  with parameters
    p_spras  : abap.lang,
    p_set_id : abap.char(30)
returns
{
  mandt      : abap.clnt;
  product    : matnr;
  class_type : klassenart;
  class_no   : char18;
  stem       : char40;
  seat       : char40;
  body       : char40;
  disc       : char40;
  ball       : char40;
  rating     : char20;
  air_fail   : char20;
  main_air   : char20;
  class_desc : char60;
}
implemented by method zcl_amdp_item_master=>tf_item_class_pivot;


/*  with parameters
    p_spras     : abap.lang,
    p_atinn_set : abap.char(30)
returns
{
  mandt      : abap.clnt;
  product    : matnr;
  class_type : klassenart;
  class_no   : char18;
  stem       : char40;
  seat       : char40;
  body       : char40;
  disc       : char40;
  ball       : char40;
  rating     : char20;
  air_fail   : char20;
  main_air   : char20;
  class_desc : char60;
}
implemented by method zcl_amdp_item_master=>tf_item_class_pivot; */
