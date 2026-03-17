class ZCL_IM_ME_PURCHDOC_POSTED2 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_ME_PURCHDOC_POSTED .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_ME_PURCHDOC_POSTED2 IMPLEMENTATION.


      METHOD if_ex_me_purchdoc_posted~posted.
*  method IF_EX_ME_PURCHDOC_POSTED~POSTED.

        INCLUDE mm_messages_mac.
        DATA : lt_ekko TYPE TABLE OF ekko,
               ls_ekko TYPE ekko.
        DATA : lt_eket TYPE TABLE OF eket,
               ls_eket TYPE eket,
               lt_ekpo TYPE TABLE OF ekpo,
               ls_ekpo TYPE ekpo.

        MOVE im_ekpo TO lt_ekpo.
        READ TABLE lt_ekpo INTO ls_ekpo INDEX 1.

        IF sy-subrc = 0.
          IF ls_ekpo-werks = 'PL01' OR ls_ekpo-werks = 'US01'.
            MOVE im_eket TO lt_eket.
            LOOP AT lt_eket INTO ls_eket.
              IF ls_eket-eindt LT im_ekko-aedat .
                MESSAGE 'Delivery date Should Not be in Past' TYPE 'E' .
              ENDIF.
              CLEAR ls_eket.
            ENDLOOP.
          ENDIF.
        ENDIF.

*  endmethod.
      ENDMETHOD.
ENDCLASS.
