*&---------------------------------------------------------------------*
*&  Include           ZRFDB_BRF_ADD_AUTH_BKPF
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*   INCLUDE RFDB_BRF_ADD_AUTH_BKPF                                     *
*----------------------------------------------------------------------*
* This INCLUDE contains one (and only one) FORM routine used by
* logical database BRF. The flag variable DO_IT should be set to YES,
* if authority checks of objects F_BKPF_BE* should be performed at
* node BSEG.
* See OSS note 315271 for further informations.
* This INCLUDE is subject to CUSTOMER changes ONLY!
*----------------------------------------------------------------------*
FORM SWITCH_AUTH_F_BKPF_BEX  USING  DO_IT TYPE C.

  CONSTANTS: YES  TYPE C VALUE 'X',
             NO   TYPE C VALUE SPACE.

  DO_IT = NO.    " no authority check of F_BKPF_BE* (default setting)
* DO_IT = YES.   " additional authority check of F_BKPF_BE*

ENDFORM.
***INCLUDE RFDB_BRF_ADD_AUTH_BKPF
