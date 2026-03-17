CLEAR : ls_mara,ls_marc,DEL_FLAG.

SELECT SINGLE * FROM mara INTO ls_mara
  WHERE matnr = p_matnr."wa_stpox-IDNRK.

SELECT SINGLE * FROM marc INTO ls_marc
  WHERE matnr = p_matnr
    AND werks = P_WERKS.

IF ls_mara-lvorm IS NOT INITIAL.
*CONCATENATE '(' 'Status:Deleted' ')' INTO DEL_FLAG.
DEL_FLAG =  '(Status:Deleted)' .
ENDIF.

IF ls_marc-lvorm IS NOT INITIAL.
*CONCATENATE '(' 'Status:Deleted' ')' INTO DEL_FLAG.
DEL_FLAG =  '(Status:Deleted)' .
ENDIF.

if ls_mara-dev_status = 'NEW PRODUCT DEVELOPMENT' AND ls_mara-dev_status = 'PARITAL DEVELOPMENT'.


endif.




















