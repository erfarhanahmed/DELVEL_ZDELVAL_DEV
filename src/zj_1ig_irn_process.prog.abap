*&---------------------------------------------------------------------*
*& Include          J_1IG_IRN_PROCESS
*&---------------------------------------------------------------------*

 IF go_ref IS NOT BOUND.
   CREATE OBJECT go_ref
     EXPORTING
       im_ob_inv     = p_ob_inv
       im_ccode            = P_CCode
       im_fyear            = p_fyear
       im_disp_fyear       = p_fyear1
       im_bp               = p_bp
       im_date             = s_date[]
       im_file             = p_file
       im_doc              = s_doc[]
       im_status           = s_stat[]
       im_ob_dis           = p_ob_dis
       im_sing       = p_sing
       im_bulk       = p_bulk
       im_fg         = p_fg
       im_bg         = p_bg
       im_dir              = p_dir
       im_odn              = s_odn[]
       im_bupla            = s_bp[]
       im_dir1             = p_dir1
       im_manual_process   = p_sl_man
       im_automate_process = p_sl_aut .


 ENDIF.

 IF go_ref IS BOUND.
   go_ref->main( ).
 ENDIF.
