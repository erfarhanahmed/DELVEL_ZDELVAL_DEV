class ZCL_IM_SD_COND_SAVE_A definition
  public
  final
  create public .

public section.

  interfaces IF_EX_SD_COND_SAVE_A .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_SD_COND_SAVE_A IMPLEMENTATION.


  METHOD if_ex_sd_cond_save_a~condition_save_exit.
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Created On            : 27.04.2017
    " Technical Consultant  : Ketan D.
    " Finctional Comsultant : Saroj
    " Module                : SD
    " Transport Request     : DEVK901299
    " Description           : SD : VK11 Tax code validation - WB - 0 - 25.04.2017
    """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    DATA : it_konpdb TYPE TABLE OF konpdb,
           wa_konpdb TYPE konpdb.

    REFRESH : it_konpdb , it_konpdb[] .
    CLEAR : wa_konpdb .

    IF ct_konpdb_new IS NOT INITIAL.
      it_konpdb[] = ct_konpdb_new[] .
      DELETE it_konpdb WHERE mwsk1 IS NOT INITIAL AND loevm_ko = 'X'.

      IF it_konpdb IS NOT INITIAL .
        LOOP AT it_konpdb INTO wa_konpdb WHERE ( kschl = 'ZLST' OR kschl = 'ZCST' ).
          IF wa_konpdb-mwsk1 IS INITIAL.
            MESSAGE 'Maintain Tax Code' TYPE 'E' DISPLAY LIKE 'I'  .
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
