*&---------------------------------------------------------------------*
*&  Include           ZXVEDU04
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_posnr,
         posnr TYPE vbap-posnr,
       END OF ty_posnr.

STATICS: lt_pos TYPE TABLE OF ty_posnr,
         ls_pos TYPE ty_posnr.

STATICS: l_added TYPE xfeld,
         l_count TYPE i.
DATA: ls_vbak TYPE vbak.
DATA: ls_knvv TYPE knvv.
IF l_added IS INITIAL.
  IF l_count EQ 1.
    ls_vbak = dxvbak.
    SELECT SINGLE * FROM knvv INTO ls_knvv WHERE kunnr = ls_vbak-kunnr AND vkorg = ls_vbak-vkorg AND vtweg = ls_vbak-vtweg AND spart = ls_vbak-spart.

* Ok code for billing document Screen.

    dxbdcdata-fnam = 'BDC_OKCODE'.
    dxbdcdata-fval = '=KDE3'.
    APPEND dxbdcdata.
    CLEAR: dxbdcdata.

* Billing Document screen
    dxbdcdata-program = 'SAPMV45A'.
    dxbdcdata-dynpro   = '4303'.
    dxbdcdata-dynbegin = 'X'.
    APPEND dxbdcdata.
    CLEAR: dxbdcdata.

    dxbdcdata-program = 'SAPMV45A'.
    dxbdcdata-dynpro   = '4002'.
    dxbdcdata-dynbegin = 'X'.
    APPEND dxbdcdata.
    CLEAR: dxbdcdata.

* Populate data.
    dxbdcdata-fnam = 'VBKD-ZTERM'.
    dxbdcdata-fval = ls_knvv-zterm.  "'D251'.
    APPEND dxbdcdata.
    CLEAR: dxbdcdata.

    dxbdcdata-fnam = 'BDC_OKCODE'.
    dxbdcdata-fval = '/EBACK'.
    APPEND dxbdcdata.
    CLEAR: dxbdcdata.

    l_added  = 'X'.

  ENDIF.
  l_count = l_count + 1.
ENDIF.
