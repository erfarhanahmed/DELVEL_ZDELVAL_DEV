class ZCL_IM_ME_GUI_PO_CUST definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ME_GUI_PO_CUST .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ME_GUI_PO_CUST IMPLEMENTATION.


  method IF_EX_ME_GUI_PO_CUST~EXECUTE.
  endmethod.


  method IF_EX_ME_GUI_PO_CUST~MAP_DYNPRO_FIELDS.

  FIELD-SYMBOLS: <mapping> LIKE LINE OF ch_mapping.

  LOOP AT ch_mapping ASSIGNING <mapping>.

    CASE <mapping>-fieldname.

      WHEN 'MENGE'.
        <mapping>-metafield = mmmfd_quantity.

    ENDCASE.

  ENDLOOP.
  endmethod.


  method IF_EX_ME_GUI_PO_CUST~SUBSCRIBE.
  endmethod.


  method IF_EX_ME_GUI_PO_CUST~TRANSPORT_FROM_DYNP.
  endmethod.


  method IF_EX_ME_GUI_PO_CUST~TRANSPORT_FROM_MODEL.
  endmethod.


  method IF_EX_ME_GUI_PO_CUST~TRANSPORT_TO_DYNP.
  endmethod.


  method IF_EX_ME_GUI_PO_CUST~TRANSPORT_TO_MODEL.
  endmethod.
ENDCLASS.
