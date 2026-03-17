CLEAR : ls_mara, ls_marc, DEL_FLAG.
*BREAK-POINT.
SELECT SINGLE * FROM mara INTO ls_mara
  WHERE matnr = wa_stpox-IDNRK.

SELECT SINGLE * FROM marc INTO ls_marc
  WHERE matnr = wa_stpox-IDNRK
    AND werks = wa_stpox-werks.

IF ls_mara-lvorm IS NOT INITIAL.
*CONCATENATE '(' 'Status:Deleted' ')' INTO DEL_FLAG.
DEL_FLAG =  '(Status:Deleted)' .
ENDIF.

*CLEAR DEL_FLAG.

IF ls_marc-lvorm IS NOT INITIAL.
*CONCATENATE '(' 'Status:Deleted' ')' INTO DEL_FLAG.
DEL_FLAG =  '(Status:Deleted)' .
ENDIF.

*CLEAR DEL_FLAG.

*if ls_mara-dev_status = 'NEW PRODUCT DEVELOPMENT' OR ls_mara-dev_status = 'PARITAL DEVELOPMENT'.
*
*
*endif.













