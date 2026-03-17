
 IF bf_konv-waers = '%' .
   CONCATENATE bf_konv-descr ' ('
     bf_konv-kbetr bf_konv-waers ') '
     INTO bf_konv-descr.
 ENDIF.

* IF bf_konv-descr = 'P & F'.
*   v_descr = bf_konv-descr.
* ENDIF.
*
* IF bf_konv-sq_no = '4'.
*   v_vatam = bf_konv-kwert.
* ENDIF.
*
* IF bf_konv-sq_no = '5'.
*   bf_konv-kwert = bf_konv-kwert + v_vatam.
* ENDIF.
