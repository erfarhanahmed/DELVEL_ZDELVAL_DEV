FUNCTION zmtr.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(LV_AUFNR) TYPE  AFPO-AUFNR OPTIONAL
*"  TABLES
*"      LT_FINAL STRUCTURE  ZSTR_FINAL OPTIONAL
*"      RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------
**Developed By Sarika Thange 17.08.2018



  TYPES : BEGIN OF ty_vbap,
            vbeln TYPE vbap-vbeln,
            matnr TYPE ausp-objek,
          END OF ty_vbap.
  TYPES : BEGIN OF ty_vbap1,
            vbeln TYPE vbap-vbeln,
            matnr TYPE vbap-matnr,

          END OF ty_vbap1.
  TYPES : BEGIN OF ty_mara,
            matnr TYPE mara-matnr,
            zsize TYPE mara-zsize,
          END OF ty_mara.
  TYPES : BEGIN OF ty_makt,
            matnr TYPE makt-matnr,
            maktx TYPE makt-maktx,
          END OF ty_makt.
  TYPES : BEGIN OF ty_kna1,
            kunnr TYPE kna1-kunnr,
            name1 TYPE kna1-name1,
          END OF ty_kna1.

  DATA : lt_afpo          TYPE TABLE OF afpo,
         ls_afpo          TYPE  afpo,
         lt_vbak          TYPE TABLE OF vbak,
         ls_vbak          TYPE          vbak,
         lt_vbap          TYPE TABLE OF ty_vbap1,
         ls_vbap          TYPE          ty_vbap1,
         lt_vbap1         TYPE TABLE OF ty_vbap,
         ls_vbap1         TYPE          ty_vbap,
         lt_makt          TYPE TABLE OF ty_makt,
         ls_makt          TYPE ty_makt,
         lt_mara          TYPE TABLE OF ty_mara,
         ls_mara          TYPE ty_mara,
         lt_ausp          TYPE TABLE OF ausp,
         ls_ausp          TYPE          ausp,
         wa_cawn          TYPE          cawn,
         lt_kna1          TYPE TABLE OF ty_kna1,
         ls_kna1          TYPE          ty_kna1,
         lt_zppcompliance TYPE TABLE OF zppcompliance,
         ls_zppcompliance TYPE  zppcompliance.

  DATA : ls_final LIKE LINE OF lt_final.

*********************ADDED BY SUKANYA MUNGASE***********************
  DATA : wa_ret TYPE bapiret2.
********************************************************************
  IF lv_aufnr IS NOT INITIAL.
    SELECT * FROM afpo INTO TABLE lt_afpo WHERE aufnr EQ lv_aufnr.
  ELSE.
    SELECT * FROM afpo INTO TABLE lt_afpo.
  ENDIF.

  IF lt_afpo IS NOT INITIAL.
    SELECT *
            FROM vbak
            INTO TABLE lt_vbak
            FOR ALL ENTRIES IN lt_afpo
            WHERE vbeln = lt_afpo-kdauf.

    SELECT vbeln
           matnr
          FROM vbap
          INTO TABLE lt_vbap
          FOR ALL ENTRIES IN lt_afpo
          WHERE vbeln = lt_afpo-kdauf
          AND posnr = lt_afpo-kdpos .

**********************Added By Sukanya Mungase************************
  ELSE .

    wa_ret-type = 'E'.
    wa_ret-message = 'Please Enter Valid Production Order'.
    APPEND wa_ret TO return.

*********************************************************************
  ENDIF.

  lt_vbap1 =  lt_vbap.

  IF lt_vbap1 IS NOT INITIAL.
    SELECT *
           FROM ausp
           INTO TABLE lt_ausp
           FOR ALL ENTRIES IN lt_vbap1
           WHERE objek = lt_vbap1-matnr
           AND atinn IN ('0000000815','0000000818','0000000813','0000000822','0000000811').

    SELECT matnr
           zsize
           FROM mara
           INTO TABLE lt_mara
           FOR ALL ENTRIES IN lt_vbap
           WHERE matnr = lt_vbap-matnr.

    SELECT matnr
           maktx
           FROM makt
           INTO TABLE lt_makt
           FOR ALL ENTRIES IN lt_vbap
           WHERE matnr = lt_vbap-matnr.

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
           WHERE kunnr EQ lt_vbak-kunnr  .
  ENDIF.

  LOOP AT lt_afpo INTO ls_afpo.
    READ TABLE lt_vbak INTO ls_vbak WITH KEY vbeln = ls_afpo-kdauf.
    READ TABLE lt_vbap1 INTO ls_vbap1 WITH  KEY vbeln = ls_vbak-vbeln.
    READ TABLE lt_kna1 INTO ls_kna1 WITH  KEY kunnr = ls_vbak-kunnr.
    LOOP AT lt_ausp INTO ls_ausp WHERE objek = ls_vbap1-matnr.

      ls_final-mandt = ls_afpo-mandt.
      ls_final-aufnr = ls_afpo-aufnr.
      ls_final-kdauf = ls_afpo-kdauf.
      ls_final-psmng = ls_afpo-psmng.
      ls_final-kunnr = ls_vbak-kunnr.
      ls_final-bstdk = ls_vbak-bstdk.
      ls_final-bstnk = ls_vbak-bstnk.
      ls_final-name1 = ls_kna1-name1.
      IF ls_ausp-atinn EQ '0000000818' OR ls_ausp-atinn = '0000000813' OR ls_ausp-atinn = '0000000822'  OR ls_ausp-atinn = '0000000811'.
        ls_final-atinn = ls_ausp-atinn.
        ls_final-matnr = ls_ausp-objek.
        SELECT SINGLE * FROM  cawn INTO wa_cawn WHERE  atinn EQ ls_ausp-atinn AND atwrt EQ ls_ausp-atwrt..
        SELECT SINGLE atwtb FROM  cawnt INTO ls_final-atwrt WHERE atzhl EQ wa_cawn-atzhl AND atinn EQ wa_cawn-atinn.
      ENDIF.

      READ TABLE lt_mara INTO ls_mara WITH  KEY matnr = ls_ausp-objek.
      ls_final-zsize = ls_mara-zsize.

      READ TABLE lt_makt INTO ls_makt WITH  KEY matnr = ls_ausp-objek.
      ls_final-maktx = ls_makt-maktx.


      READ TABLE lt_zppcompliance INTO ls_zppcompliance WITH KEY class = ls_ausp-atwrt.
      IF ls_ausp-atinn EQ '0000000815'.
        ls_final-atinn = '0000000815'.
        ls_final-class = ls_zppcompliance-class.
        ls_final-shell_test = ls_zppcompliance-shell_test.
        ls_final-seat_test = ls_zppcompliance-seat_test.
        ls_final-pneumatic = ls_zppcompliance-pneumatic.
        ls_final-matnr = ls_ausp-objek.
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

    ls_FINAL-tdline = ls_mattxt.

CLEAR ls_mattxt.



      APPEND ls_final TO lt_final.
      CLEAR : ls_final,ls_zppcompliance,ls_ausp,ls_mara,ls_makt,wa_cawn.
    ENDLOOP.
    CLEAR : ls_afpo,ls_vbak,ls_vbap1,ls_kna1.
  ENDLOOP.




ENDFUNCTION.
