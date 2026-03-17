FUNCTION zmtr1.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(LV_EBELN) TYPE  EKPO-EBELN OPTIONAL
*"  TABLES
*"      LT_FINAL STRUCTURE  ZSTR_FINAL1 OPTIONAL
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------
  TYPES : BEGIN OF ty_ekpo,
            mandt TYPE ekpo-mandt,
            ebeln TYPE ekpo-ebeln,
            ebelp TYPE ekpo-ebelp,
            loekz TYPE ekpo-loekz,
            matnr TYPE ekpo-matnr,
            werks TYPE ekpo-werks,
            menge TYPE ekpo-menge,
            knttp TYPE ekpo-knttp,
          END OF ty_ekpo,

          BEGIN OF ty_ausp,
            objek TYPE ausp-objek,
            atinn TYPE ausp-atinn,
            atwrt TYPE ausp-atwrt,
          END OF ty_ausp,

          BEGIN OF ty_ekkn,
            ebeln TYPE ekkn-ebeln,
            ebelp TYPE ekkn-ebelp,
            vbeln TYPE ekkn-vbeln,
            vbelp TYPE ekkn-vbelp,
          END OF ty_ekkn,

          BEGIN OF ty_vbak,
            vbeln TYPE vbak-vbeln,
            bstnk TYPE vbak-bstnk,
            bstdk TYPE vbak-bstdk,
            kunnr TYPE vbak-kunnr,
          END OF ty_vbak,

          BEGIN OF ty_vbap,
            vbeln TYPE vbap-vbeln,
            posnr TYPE vbap-posnr,
            matnr TYPE vbap-matnr,
          END OF ty_vbap,

          BEGIN OF ty_vbap1,
            vbeln TYPE vbap-vbeln,
            posnr TYPE vbap-posnr,
            matnr TYPE ausp-objek,
          END OF ty_vbap1,

          BEGIN OF ty_makt,
            matnr TYPE makt-matnr,
            maktx TYPE makt-maktx,
          END OF ty_makt,

          BEGIN OF ty_mara,
            matnr TYPE mara-matnr,
            zsize TYPE mara-zsize,
          END OF ty_mara,

          BEGIN OF ty_kna1,
            kunnr TYPE kna1-kunnr,
            name1 TYPE kna1-name1,
          END OF ty_kna1.

  DATA : lt_ekpo          TYPE TABLE OF ty_ekpo,
         ls_ekpo          TYPE          ty_ekpo,

         lt_vbak          TYPE TABLE OF ty_vbak,
         ls_vbak          TYPE          ty_vbak,

         lt_vbap          TYPE TABLE OF ty_vbap,
         ls_vbap          TYPE          ty_vbap,

         lt_vbap1         TYPE TABLE OF ty_vbap1,
         ls_vbap1         TYPE          ty_vbap1,

         lt_makt          TYPE TABLE OF ty_makt,
         ls_makt          TYPE          ty_makt,

         lt_mara          TYPE TABLE OF ty_mara,
         ls_mara          TYPE          ty_mara,

         lt_kna1          TYPE TABLE OF ty_kna1,
         ls_kna1          TYPE          ty_kna1,

         lt_ekkn          TYPE TABLE OF ty_ekkn,
         ls_ekkn          TYPE          ty_ekkn,

         lt_ausp          TYPE TABLE OF ty_ausp,
         ls_ausp          TYPE          ty_ausp,

         lt_ausp1         TYPE TABLE OF ty_ausp,
         ls_ausp1         TYPE          ty_ausp,

         wa_cawn          TYPE          cawn,

         lt_zppcompliance TYPE TABLE OF zppcompliance,
         ls_zppcompliance TYPE  zppcompliance,

*         lt_final         TYPE TABLE OF zstr_final1,
         ls_final         TYPE          zstr_final1.

  IF lv_ebeln IS NOT INITIAL.

    SELECT mandt
           ebeln
           ebelp
           loekz
           matnr
           werks
           menge
           knttp
      FROM ekpo
      INTO TABLE lt_ekpo
      WHERE ebeln = lv_ebeln.

  ELSE.

    SELECT mandt
           ebeln
           ebelp
           loekz
           matnr
           werks
           menge
           knttp
      FROM ekpo
      INTO TABLE lt_ekpo
      WHERE werks = 'PL01' AND
            knttp = 'E'    AND
            loekz = ' '.

  ENDIF.

  IF lt_ekpo IS NOT INITIAL.

    SELECT ebeln
           ebelp
           vbeln
           vbelp
      FROM ekkn
      INTO TABLE lt_ekkn
      FOR ALL ENTRIES IN lt_ekpo
      WHERE ebeln = lt_ekpo-ebeln AND
            ebelp = lt_ekpo-ebelp.

  ENDIF.

  IF lt_ekkn IS NOT INITIAL.

    SELECT vbeln
           bstnk
           bstdk
           kunnr
      FROM vbak
      INTO TABLE lt_vbak
      FOR ALL ENTRIES IN lt_ekkn
      WHERE vbeln = lt_ekkn-vbeln.

    SELECT vbeln
           posnr
           matnr
      FROM vbap
      INTO TABLE lt_vbap
      FOR ALL ENTRIES IN lt_ekkn
      WHERE vbeln = lt_ekkn-vbeln AND
            posnr = lt_ekkn-vbelp.

  ENDIF.

  lt_vbap1 = lt_vbap.

  IF lt_vbap1 IS NOT INITIAL.

    SELECT matnr
           maktx
      FROM makt
      INTO TABLE lt_makt
      FOR ALL ENTRIES IN lt_vbap
      WHERE matnr = lt_vbap-matnr.

    SELECT matnr
           zsize
      FROM mara
      INTO TABLE lt_mara
      FOR ALL ENTRIES IN lt_vbap
      WHERE matnr = lt_vbap-matnr.

    SELECT objek
    atinn
    atwrt
    FROM ausp
    INTO TABLE lt_ausp
    FOR ALL ENTRIES IN lt_vbap1
    WHERE objek = lt_vbap1-matnr
       AND atinn IN ('0000000815','0000000818','0000000813','0000000822','0000000811')..

  ENDIF.

  IF lt_ausp IS NOT INITIAL.

    SELECT *
      FROM zppcompliance
      INTO TABLE lt_zppcompliance
      FOR ALL ENTRIES IN lt_ausp
      WHERE class = lt_ausp-atwrt .

  ENDIF.

  IF lt_vbak IS NOT INITIAL.

    SELECT kunnr
           name1
      FROM kna1
      INTO TABLE lt_kna1
      FOR ALL ENTRIES IN lt_vbak
      WHERE kunnr = lt_vbak-kunnr.

  ENDIF.
  SORT lt_ekpo BY ebeln ebelp.
  LOOP AT lt_ekpo INTO ls_ekpo.

    READ TABLE lt_ekkn INTO ls_ekkn WITH KEY ebeln = ls_ekpo-ebeln
                                             ebelp = ls_ekpo-ebelp.
    IF sy-subrc = 0.
      READ TABLE lt_vbap1 INTO ls_vbap1 WITH  KEY vbeln = ls_ekkn-vbeln
                                                  posnr = ls_ekkn-vbelp.
      READ TABLE lt_vbap INTO ls_vbap WITH KEY vbeln = ls_ekkn-vbeln
                                               posnr = ls_ekkn-vbelp.
      IF sy-subrc = 0.

        LOOP AT lt_ausp INTO ls_ausp WHERE objek = ls_vbap1-matnr.

          ls_final-mandt = ls_ekpo-mandt.
          ls_final-ebeln = ls_ekpo-ebeln.
          ls_final-menge = ls_ekpo-menge.
*          ls_final-atinn = ls_ausp-atinn.
          ls_final-vbeln = ls_ekkn-vbeln.
*          ls_final-matnr = ls_vbap-matnr.
*          ls_final-atwrt = ls_ausp-atwrt.
          IF ls_ausp-atinn EQ '0000000818' OR ls_ausp-atinn = '0000000813' OR ls_ausp-atinn = '0000000822'  OR ls_ausp-atinn = '0000000811'.
            ls_final-atinn = ls_ausp-atinn.
            ls_final-matnr = ls_ausp-objek.
            SELECT SINGLE * FROM  cawn INTO wa_cawn WHERE  atinn EQ ls_ausp-atinn AND atwrt EQ ls_ausp-atwrt..
            SELECT SINGLE atwtb FROM  cawnt INTO ls_final-atwrt WHERE atzhl EQ wa_cawn-atzhl AND atinn EQ wa_cawn-atinn.
          ENDIF.


          READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_final-vbeln.
          IF sy-subrc = 0.
            ls_final-kunnr = ls_vbak-kunnr.
            ls_final-bstnk = ls_vbak-bstnk.
            ls_final-bstdk = ls_vbak-bstdk.

          ENDIF.

          READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_ausp-objek.
          IF sy-subrc = 0.
            ls_final-maktx = ls_makt-maktx.
          ENDIF.

          READ TABLE lt_mara INTO ls_mara WITH KEY matnr = ls_ausp-objek.
          IF sy-subrc = 0.
            ls_final-zsize = ls_mara-zsize.
          ENDIF.

          IF ls_ausp-atinn = '0000000815'.
            READ TABLE lt_zppcompliance INTO ls_zppcompliance WITH KEY class = ls_ausp-atwrt.
            IF sy-subrc = 0.
              ls_final-atinn      = '0000000815'.
              ls_final-class      = ls_zppcompliance-class.
              ls_final-shell_test = ls_zppcompliance-shell_test.
              ls_final-seat_test  = ls_zppcompliance-seat_test.
              ls_final-pneumatic  = ls_zppcompliance-pneumatic.
              ls_final-matnr = ls_ausp-objek.
            ENDIF.
          ENDIF.

          READ TABLE lt_kna1 INTO ls_kna1 WITH KEY kunnr = ls_final-kunnr.
          IF sy-subrc = 0.
            ls_final-name1 = ls_kna1-name1.
          ENDIF.

          DATA: lv_name   TYPE thead-tdname,
                lv_lines  TYPE STANDARD TABLE OF tline,
                wa_lines  LIKE tline,
                ls_itmtxt TYPE tline,
                ls_mattxt TYPE tdline.


          lv_name = ls_ausp-objek.

          CALL FUNCTION 'READ_TEXT'
            EXPORTING
              client                  = sy-mandt
              id                      = 'GRUN'
              language                = sy-langu
              name                    = lv_name
              object                  = 'MATERIAL'
            TABLES
              lines                   = lv_lines
            EXCEPTIONS
              id                      = 1
              language                = 2
              name                    = 3
              not_found               = 4
              object                  = 5
              reference_check         = 6
              wrong_access_to_archive = 7
              OTHERS                  = 8.
          IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
          ENDIF.

          LOOP AT lv_lines INTO DATA(ls_line).
            CONCATENATE ls_mattxt ls_line-tdline INTO ls_mattxt.
          ENDLOOP.

          ls_final-tdline = ls_mattxt.

          CLEAR ls_mattxt.


          APPEND ls_final TO lt_final.
          CLEAR : ls_final,ls_zppcompliance,ls_ausp,ls_mara,ls_makt,ls_kna1,ls_vbak.
        ENDLOOP.
      ENDIF.
    ENDIF.
    CLEAR : ls_ekkn,ls_vbap,ls_vbap1.

  ENDLOOP.

ENDFUNCTION.
