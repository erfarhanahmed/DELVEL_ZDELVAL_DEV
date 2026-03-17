@EndUserText.label: 'Item Storage-Location Flags'
define table function ZTF_ITEM_SLOC_FLAGS
with parameters
    p_werks : werks_d
returns
{
  mandt     : abap.clnt;
  product   : matnr;
  werks     : werks_d;
  
  flag_rm01 : abap.char( 3 );
  flag_fg01 : abap.char( 3 );
  flag_prd1 : abap.char( 3 );
  flag_rj01 : abap.char( 3 );
  flag_rwk1 : abap.char( 3 );  
  flag_scr1 : abap.char( 3 ); 
  flag_sfg1 : abap.char( 3 );  
  flag_srn1 : abap.char( 3 );
  flag_vld1 : abap.char( 3 );
  flag_plg1 : abap.char( 3 );
  flag_tpi1 : abap.char( 3 );
  flag_sc01 : abap.char( 3 );
  flag_spc1 : abap.char( 3 );
  flag_slr1 : abap.char( 3 );
  flag_mcn1 : abap.char( 3 );
  flag_pn01 : abap.char( 3 );
  flag_kmcn : abap.char( 3 );
  flag_kndt : abap.char( 3 );
  flag_kplg : abap.char( 3 );
  flag_kpr1 : abap.char( 3 );
  flag_kprd : abap.char( 3 );
  flag_krj0 : abap.char( 3 );
  flag_krm0 : abap.char( 3 );
  flag_krwk : abap.char( 3 );
  flag_ksc0 : abap.char( 3 );
  flag_kscr : abap.char( 3 );
  flag_ksfg : abap.char( 3 );
  flag_kslr : abap.char( 3 ); 
  flag_kspc : abap.char( 3 );
  flag_ksrn : abap.char( 3 );
  flag_ktpi : abap.char( 3 );
  flag_kvld : abap.char( 3 );
  flag_kfg0 : abap.char( 3 );      
  flag_kgrp : abap.char( 3 );
}
implemented by method zcl_amdp_item_master=>tf_item_sloc_flags;

