PROCESS BEFORE OUTPUT.
 MODULE STATUS_0200.
*
PROCESS AFTER INPUT.

FIELD zeway_bill-vehical_type MODULE validate_subscreen_vehicaltype.
  FIELD zeway_bill-trans_doc MODULE validate_subscreen_transdoc.
  FIELD zeway_bill-doc_dt MODULE validate_subscreen_docdt.
  FIELD zeway_bill-distance MODULE validate_subscreen_distance.

  CHAIN.
   FIELD zeway_bill-vehical_no.
   FIELD zeway_bill-trans_id.
    MODULE validate_subscreen_vehicalno.
  ENDCHAIN.


 MODULE USER_COMMAND_0200.
