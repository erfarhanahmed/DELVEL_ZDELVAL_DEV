DATA: gv_type TYPE string,
      gv_sub  TYPE string.
CLEAR:GD_SUPPLY.
READ TABLE LT_FINAL_EWAY INTO LS_FINAL_EWAY INDEX 1.
SELECT SINGLE * FROM zeway_res_122 INTO ls_eway
   WHERE belnr = P_VBELN
    AND EWAY_BILL = P_EBILLNO.

SELECT SINGLE * FROM rbkp INTO ls_rbkp WHERE belnr = p_vbeln
                                        AND  bukrs = p_bukrs
                                        AND  gjahr = p_gjahr.

READ TABLE LT_BILLINGTYPES INTO LS_BILLINGTYPES WITH KEY
    fkart = ls_rbkp-blart.

*CASE LS_BILLINGTYPES-ZSUPPLY .
*  WHEN 'O'.
    gv_type = 'Outward'.
*  WHEN 'I'.
*    gv_type = 'Inward'.
*ENDCASE.

CASE LS_BILLINGTYPES-ZSUBSUPPLY.
  WHEN '1'.
    gv_sub = 'Supply'.
  WHEN '2'.
    gv_sub = 'Import'.
  WHEN '3'.
    gv_sub = 'Import'.
  WHEN '4'.
    gv_sub = 'Job Work'.
  WHEN '5'.
    gv_sub = 'For Own Use'.
  WHEN '6'.
    gv_sub = 'Job work Returns'.
  WHEN '7'.
    gv_sub = 'Sales Return'.
  WHEN '8'.
    gv_sub = 'Others'.
  WHEN '9'.
    gv_sub = 'SKD/CKD'.
  WHEN '10'.
    gv_sub = 'Line Sales'.
  WHEN '11'.
    gv_sub = 'Recipient Not Known'.
  WHEN '12'.
    gv_sub = 'Exhibition or Fairs'.
ENDCASE.

CASE LS_BILLINGTYPES-ZDOCTYPE .
  WHEN 'INV'.
    gd_billtype = 'Tax Invoice'.
  WHEN 'BIL'.
    gd_billtype = 'Bill of Supply'.
  WHEN 'BOE'.
    gd_billtype = 'Bill of Entry'.
  WHEN 'CHL'.
    gd_billtype = 'Delivery Challan'.
  WHEN 'CNT'.
    gd_billtype = 'Credit Note'.
  WHEN 'OTH'.
    gd_billtype = 'Others'.
ENDCASE.

CONCATENATE gv_type gv_sub INTO GD_SUPPLY SEPARATED BY '-'.


GD_TRANS = 'Regular'.




