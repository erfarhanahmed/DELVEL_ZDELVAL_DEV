*----------------------------------------------------------------------*
***INCLUDE LZFG_OFMF02.
*----------------------------------------------------------------------*
FORM on_save_new.

  TYPES : BEGIN OF ty_vbak,
            vbeln TYPE vbak-vbeln,
            erdat TYPE vbak-erdat,
            knumv TYPE vbak-knumv,
            vkbur TYPE vbak-vkbur,
          END OF ty_vbak.

  TYPES : BEGIN OF ty_konv,
            knumv TYPE konv-knumv,
            kposn TYPE konv-kposn,
            kschl TYPE konv-kschl,
            kwert TYPE konv-kwert,
          END OF ty_konv.

  DATA : ls_vbak TYPE ty_vbak,
         ls_konv TYPE ty_konv,
         lt_konv TYPE TABLE OF ty_konv,
         ls_curr TYPE zcurr_tab.

  DATA : sum_kwert TYPE konv-kwert,
         sum_book  TYPE zofm_booking-zbook_value,
         diff_book TYPE string,
         usd_rate  TYPE  zcurr_tab-zex_rate,
         lv_msg    TYPE string.

  DATA : year TYPE i.
  BREAK primusabap.

  SELECT SINGLE vbeln                                                        "check whether the entered sales order is present in sap
                erdat
                knumv
                vkbur
           FROM vbak
           INTO ls_vbak
           WHERE vbeln EQ zofm_booking-zsoref.

  IF sy-subrc = 0.
   zofm_booking-branch = ls_vbak-vkbur.

    SELECT knumv
           kposn
           kschl
           kwert
      FROM PRCD_ELEMENTS
*      FROM konv
      INTO TABLE lt_konv
      WHERE knumv = ls_vbak-knumv AND
            kschl = 'ZPR0'.

    LOOP AT lt_konv INTO ls_konv.
      sum_kwert = sum_kwert + ls_konv-kwert.
    ENDLOOP.

    zofm_booking-zprice = sum_kwert.                                             "Base Price from Sales Order

    IF zofm_booking-zbooking_curr IS INITIAL.
      MESSAGE 'Please Maintain the Booking Currency' TYPE 'E' DISPLAY LIKE 'E'.
    ENDIF.

    year = ls_vbak-erdat+0(4).

    SELECT SINGLE *
      FROM zcurr_tab
      INTO ls_curr
      WHERE zyear = year AND
            zcurr = zofm_booking-zbooking_curr.

    zofm_booking-zcur_conv = ls_curr-zex_rate.                                     "Currency Conversion

    zofm_booking-zinr_val = zofm_booking-zbook_value * ls_curr-zex_rate.           "to get the value in home currency

    SELECT SINGLE zex_rate
      FROM zcurr_tab
      INTO usd_rate
      WHERE zyear = year AND zcurr = 'USD'.

*    IF zofm_booking-zbooking_curr = 'USD'.
*      zofm_booking-zagrr_val = zofm_booking-zbook_value.                           "value in agreed currency usd
    zofm_booking-zagrr_val = zofm_booking-zinr_val / usd_rate.
*    ENDIF.

    sum_book = zofm_booking-zbutt + zofm_booking-zball_vales + zofm_booking-zoffset_val    "Booking value is segregated in this 5 values check
                                  + zofm_booking-zact_cnt + zofm_booking-zservice.

    diff_book = zofm_booking-zbook_value - sum_book.                                       "to check if any difference between this two

    IF diff_book < 0.
      diff_book = -1 * diff_book.
    ENDIF.

    IF zofm_booking-zscope NE 'COMMISSIONS' OR zofm_booking-zscope NE 'LATE DELIVERY'.
      IF sum_book GT zofm_booking-zbook_value.                                                          "respective error messages
        CONCATENATE 'Sum of values greater than the booking value by difference' diff_book INTO lv_msg SEPARATED BY space.
        MESSAGE lv_msg TYPE 'E'.
      ELSEIF sum_book LT zofm_booking-zbook_value.
        CONCATENATE 'Sum of values less than the booking value by difference' diff_book INTO lv_msg SEPARATED BY space.
        MESSAGE lv_msg TYPE 'E'.
      ENDIF.
    ENDIF.

  ELSE.
    MESSAGE 'Please Enter Correct Sales Order in Column No. 1' TYPE 'E' DISPLAY LIKE 'E'.

  ENDIF.
*ENDSELECT.

ENDFORM.
