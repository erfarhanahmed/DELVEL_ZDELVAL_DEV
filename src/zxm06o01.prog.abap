*----------------------------------------------------------------------*
***INCLUDE ZXM06O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  STATUS_0111  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0111 OUTPUT.
*  SET PF-STATUS 'xxxxx'.
*  SET TITLEBAR 'xx'.
  BREAK primusabap.




  IF sy-tcode EQ 'ME22N' OR sy-tcode EQ 'ME23N' OR sy-tcode = 'ME29N' .        """"Added by Pranit 24.10.2024
    FIELD-SYMBOLS:<fs> TYPE any .
    ASSIGN ('(SAPLMEGUI)MEPO_TOPLINE-EBELN') TO <fs>.
BREAK primusabap.

    SELECT SINGLE ekorg FROM ekko INTO @DATA(wa_ekorg) WHERE ebeln = @<fs>.
    SELECT SINGLE FRGZU FROM ekko INTO @DATA(wa_FRGZU) WHERE ebeln = @<fs>.
      if wa_FRGZU eq 'X'.
       SELECT SINGLE zgreen_fld
         FROM ekpo INTO @data(wa_green_fld)
         where ebeln = @<fs>.
        EKPO_CI-ZGREEN_FLD = wa_green_fld.
      endif.
    IF wa_ekorg  NE '1000' .
      LOOP AT SCREEN.
        IF screen-name = 'EKPO_CI-ZGREEN_FLD'.
          screen-active  = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.

  ELSEIF sy-tcode = 'ME21N'.
    FIELD-SYMBOLS:<fs_new> TYPE any .
    ASSIGN ('(SAPLMEGUI)MEPO1222-EKORG') TO <fs_new>.
    BREAK PRIMUSABAP.


     IF <fs_new>  NE '1000' .
      LOOP AT SCREEN.
        IF screen-name = 'EKPO_CI-ZGREEN_FLD'.
          screen-active  = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    ENDIF.
*     BREAK primusabap.


    ENDIF.


*  ENDIF.


ENDMODULE.
