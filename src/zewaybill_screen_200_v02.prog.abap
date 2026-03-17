*&---------------------------------------------------------------------*
*&  Include           ZEWAYBILL_SCREEN_200
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0200  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0200 OUTPUT.
*  SET PF-STATUS 'xxxxxxxx'.
*  SET TITLEBAR 'xxx'.
*BREAK primus.
    DATA:
          lt_tab TYPE STANDARD TABLE OF tline.

    DATA:
          lv_id   TYPE  thead-tdid,
          lv_lang TYPE thead-tdspras VALUE 'E',
          lv_obj  TYPE thead-tdobject,
          lv_name  TYPE thead-tdname.
DATA :gv_distance TYPE ZDISTNACE-TIME_DISTANCE,
      gv_kunnr    TYPE kna1-kunnr,
      gv_pin      TYPE kna1-PSTLZ.
  IF r1 IS INITIAL AND r2 IS INITIAL AND r3 IS INITIAL.
    r1 = 'X'.
  ENDIF.
  IF r1 EQ 'X'.
    LOOP AT SCREEN.
      IF screen-group1 = 'PB'.
        screen-active = 0.
      ENDIF.
      MODIFY SCREEN .
    ENDLOOP.
  ENDIF.

IF r2 = 'X'.
  IF zeway_bill IS INITIAL.

    READ TABLE lt_final INTO ls_final WITH KEY selection = 'X'.
    IF sy-subrc = 0.
      SELECT
      vbeln,posnr,vgbel
       FROM vbrp
            INTO TABLE @DATA(lt_vbrp_eway)
            FOR ALL ENTRIES IN @lt_final
            WHERE vbeln = @lt_final-vbeln.

      IF lt_vbrp_eway is NOT INITIAL.

       select vbeln,posnr,parvw,lifnr
         FROM vbpa INTO TABLE @DATA(lt_vbpa_eway)
         FOR ALL ENTRIES IN @lt_vbrp_eway
         WHERE vbeln = @lt_vbrp_eway-vgbel and
               parvw = 'LF'.

         IF lt_vbpa_eway is NOT INITIAL.
           select lifnr,name1,stcd3 from
           lfa1 INTO TABLE @DATA(lt_lfa1_eway)
            FOR ALL ENTRIES IN @lt_vbpa_eway
             WHERE lifnr = @lt_vbpa_eway-lifnr.
         ENDIF.

         select vbeln,traid FROM likp
           INTO TABLE @DATA(lt_likp_eway)
           FOR ALL ENTRIES IN @lt_vbrp_eway
           WHERE vbeln = @lt_vbrp_eway-vgbel.

      ENDIF.

     READ TABLE lt_vbrp_eway INTO DATA(ls_vbrp_eway) WITH KEY vbeln  = ls_final-vbeln.
      IF sy-subrc eq 0.

        READ TABLE lt_likp_eway INTO DATA(ls_likp) WITH KEY  vbeln = ls_vbrp_eway-vgbel.
        IF sy-subrc eq 0.
        zeway_bill-vehical_no        =  ls_likp-traid.

           lv_id   = 'Z003'.
           lv_obj  = 'VBBK'.
           lv_name = ls_likp-vbeln.

           CALL FUNCTION 'READ_TEXT'
             EXPORTING
*              CLIENT                        = SY-MANDT
               id                            = lv_id
               language                      = lv_lang
               NAME                          = lv_name
               OBJECT                        = lv_obj
*              ARCHIVE_HANDLE                = 0
*              LOCAL_CAT                     = ' '
*            IMPORTING
*              HEADER                        =
*              OLD_LINE_COUNTER              =
             TABLES
               lines                         = lt_tab
            EXCEPTIONS
              ID                            = 1
              LANGUAGE                      = 2
              NAME                          = 3
              NOT_FOUND                     = 4
              OBJECT                        = 5
              REFERENCE_CHECK               = 6
              WRONG_ACCESS_TO_ARCHIVE       = 7
              OTHERS                        = 8
                     .
           IF sy-subrc <> 0.
*     Implement suitable error handling here
           ELSE.
             READ TABLE lt_tab INTO DATA(ls_tab) INDEX 1.
             IF sy-subrc = 0.
               zeway_bill-trans_name = ls_tab-tdline.
             ENDIF.
           ENDIF.

           lv_id   = 'Z001'.
           lv_obj  = 'VBBK'.

           CALL FUNCTION 'READ_TEXT'
             EXPORTING
*              CLIENT                        = SY-MANDT
               id                            = lv_id
               language                      = lv_lang
               NAME                          = lv_name
               OBJECT                        = lv_obj
*              ARCHIVE_HANDLE                = 0
*              LOCAL_CAT                     = ' '
*            IMPORTING
*              HEADER                        =
*              OLD_LINE_COUNTER              =
             TABLES
               lines                         = lt_tab
            EXCEPTIONS
              ID                            = 1
              LANGUAGE                      = 2
              NAME                          = 3
              NOT_FOUND                     = 4
              OBJECT                        = 5
              REFERENCE_CHECK               = 6
              WRONG_ACCESS_TO_ARCHIVE       = 7
              OTHERS                        = 8
                     .
           IF sy-subrc <> 0.
*     Implement suitable error handling here
           ELSE.
             READ TABLE lt_tab INTO ls_tab INDEX 1.
             IF sy-subrc = 0.
               zeway_bill-trans_doc = ls_tab-tdline.
             ENDIF.
           ENDIF.

           lv_id   = 'Z004'.
           lv_obj  = 'VBBK'.

           CALL FUNCTION 'READ_TEXT'
             EXPORTING
*              CLIENT                        = SY-MANDT
               id                            = lv_id
               language                      = lv_lang
               NAME                          = lv_name
               OBJECT                        = lv_obj
*              ARCHIVE_HANDLE                = 0
*              LOCAL_CAT                     = ' '
*            IMPORTING
*              HEADER                        =
*              OLD_LINE_COUNTER              =
             TABLES
               lines                         = lt_tab
            EXCEPTIONS
              ID                            = 1
              LANGUAGE                      = 2
              NAME                          = 3
              NOT_FOUND                     = 4
              OBJECT                        = 5
              REFERENCE_CHECK               = 6
              WRONG_ACCESS_TO_ARCHIVE       = 7
              OTHERS                        = 8
                     .
           IF sy-subrc <> 0.
*     Implement suitable error handling here
           ELSE.
             READ TABLE lt_tab INTO ls_tab INDEX 1.
             IF sy-subrc = 0.
               zeway_bill-trans_id = ls_tab-tdline.
             ENDIF.
           ENDIF.
        ENDIF.

        READ TABLE lt_vbpa_eway INTO DATA(ls_vbpa_eway) WITH KEY vbeln = ls_vbrp_eway-vgbel.
        IF sy-subrc eq 0.
          READ TABLE lt_lfa1_eway INTO DATA(ls_lfa1_eway) WITH KEY lifnr = ls_vbpa_eway-lifnr.
           IF sy-subrc eq 0.
             zeway_bill-trans_id      = ls_lfa1_eway-stcd3.
             zeway_bill-lifnr         = ls_lfa1_eway-lifnr.
           ENDIF.
        ENDIF.
      ENDIF.


      SELECT SINGLE * FROM zeway_bill INTO @DATA(ls_zeway_bill)
                                      WHERE bukrs = @ls_final-bukrs
                                        AND vbeln = @ls_final-vbeln.
      IF sy-subrc = 0.
        zeway_bill-trns_md       = ls_zeway_bill-trns_md.
        zeway_bill-trans_doc     = ls_zeway_bill-trans_doc.
        zeway_bill-lifnr         = ls_zeway_bill-lifnr.
        zeway_bill-doc_dt        = ls_zeway_bill-doc_dt.
        zeway_bill-vehical_type  = ls_zeway_bill-vehical_type.
        zeway_bill-distance      = ls_zeway_bill-distance.

        IF zeway_bill-trans_id  is INITIAL.
        zeway_bill-trans_id      = ls_zeway_bill-trans_id.
        ENDIF.

        IF zeway_bill-trans_name is INITIAL.
        zeway_bill-trans_name    = ls_zeway_bill-trans_name.
        ENDIF.

        IF zeway_bill-vehical_no is INITIAL.
        zeway_bill-vehical_no    = ls_zeway_bill-vehical_no.
        ENDIF.
      ENDIF.

      IF zeway_bill-trans_doc IS NOT INITIAL AND zeway_bill-doc_dt IS INITIAL.
        SELECT SINGLE fkdat
          FROM vbrk
          INTO zeway_bill-doc_dt
          WHERE vbeln = ls_final-vbeln.
      ENDIF.
    ENDIF.
  ENDIF.

  IF zeway_bill-trns_md IS INITIAL.
    zeway_bill-trns_md = 'ROAD'.
  ENDIF.
*  IF zeway_bill-vehical_type IS INITIAL.
*    zeway_bill-vehical_type = 'REGULAR'.
*  ENDIF.
ELSE.
  IF zeway_bill IS INITIAL.
    READ TABLE lt_final INTO ls_final WITH KEY selection = 'X'.
    IF sy-subrc = 0.

      IF ls_final-GJAHR IS NOT INITIAL .
        SELECT SINGLE * FROM zeway_bill INTO ls_zeway_bill
                                      WHERE bukrs = ls_final-bukrs
                                        AND vbeln = ls_final-vbeln
                                        AND GJAHR = ls_final-GJAHR.
      ELSE.
        SELECT SINGLE * FROM zeway_bill INTO ls_zeway_bill
                                      WHERE bukrs = ls_final-bukrs
                                        AND vbeln = ls_final-vbeln.
*                                        AND GJAHR = ls_final-GJAHR.
      ENDIF.


      IF ls_zeway_bill IS NOT INITIAL ."sy-subrc = 0.
*        zeway_bill-trns_md       = ls_zeway_bill-trns_md.
*        zeway_bill-trans_doc     = ls_zeway_bill-trans_doc.
*        zeway_bill-lifnr         = ls_zeway_bill-lifnr.
*        zeway_bill-doc_dt        = ls_zeway_bill-doc_dt.
        zeway_bill-trans_id      = ls_zeway_bill-trans_id.
*        zeway_bill-trans_name    = ls_zeway_bill-trans_name.
*        zeway_bill-vehical_no    = ls_zeway_bill-vehical_no.
*        zeway_bill-vehical_type  = ls_zeway_bill-vehical_type.
        zeway_bill-distance      = ls_zeway_bill-distance.
      ENDIF.
    ENDIF.
*BREAK primus.
*    IF zeway_bill-distance IS INITIAL.
      IF LS_FINAL-FKART = 'ZEXP'.
            DATA : gv_name  TYPE thead-tdname,
                   lt_lines TYPE STANDARD TABLE OF tline,
                   wa_lines LIKE tline,
                   kunnr    TYPE kna1-kunnr.

            CLEAR:kunnr,gv_name,lv_lines,wa_lines.
            gv_name = ls_final-vbeln.
            CALL FUNCTION 'READ_TEXT'
              EXPORTING
                client                  = sy-mandt
                id                      = 'Z350'
                language                = sy-langu
                name                    = gv_name
                object                  = 'VBBK'
              TABLES
                lines                   = lt_lines
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
*               MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*                       WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
            ENDIF.

            IF NOT lt_lines IS INITIAL.
              READ TABLE lt_lines INTO wa_lines INDEX 1.
              IF NOT wa_lines-tdline IS INITIAL.
                kunnr = wa_lines-tdline .
              ENDIF.

            ENDIF.
            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input         = kunnr
             IMPORTING
               OUTPUT        = kunnr.
           IF kunnr IS NOT INITIAL .
            SELECT SINGLE PSTLZ INTO gv_pin FROM kna1 WHERE kunnr = kunnr.
            IF sy-subrc = 0 .

              SELECT SINGLE TIME_DISTANCE INTO gv_distance FROM ZPIN_DIST WHERE werks = ls_final-werks AND PIN_CODE = gv_pin.
                IF sy-subrc = 0.
                  zeway_bill-distance = gv_distance.
                ENDIF.
            ENDIF.
          ENDIF.
      ELSE.
      SELECT SINGLE kunnr INTO gv_kunnr FROM vbpa WHERE vbeln = ls_final-vbeln AND PARVW = 'WE'.
        IF sy-subrc = 0.
          SELECT SINGLE PSTLZ INTO gv_pin FROM kna1 WHERE kunnr = gv_kunnr.
            IF sy-subrc = 0 .

              SELECT SINGLE TIME_DISTANCE INTO gv_distance FROM ZPIN_DIST WHERE werks = ls_final-werks AND PIN_CODE = gv_pin.
                IF sy-subrc = 0.
                  zeway_bill-distance = gv_distance.
                ENDIF.
            ENDIF.
        ENDIF.
      ENDIF.
*    ENDIF.

  ENDIF.
ENDIF.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0200 INPUT.

  CASE sy-ucomm.
    WHEN '&CAN' OR 'CANCEL'.
      CLEAR zeway_bill.
      SET SCREEN '0'.
      LEAVE SCREEN.
    WHEN '&SAVE'.
*BREAK primus.
*        **      #validation

      LOOP AT lt_final INTO ls_final WHERE selection = 'X'.
        gs_ewaybill_details-bukrs        =    ls_final-bukrs.
        gs_ewaybill_details-vbeln        =    ls_final-vbeln.
        IF ls_final-GJAHR IS NOT INITIAL.
          gs_ewaybill_details-GJAHR        =    ls_final-GJAHR.
        ENDIF.

        IF r1 = 'X'.
          gs_ewaybill_details-trans_id     =    zeway_bill-trans_id.
          gs_ewaybill_details-distance     =    zeway_bill-distance.
        ELSE.
          gs_ewaybill_details-trns_md      =    zeway_bill-trns_md.
          gs_ewaybill_details-trans_doc    =    zeway_bill-trans_doc.
          gs_ewaybill_details-lifnr        =    zeway_bill-lifnr.
          gs_ewaybill_details-doc_dt       =    zeway_bill-doc_dt.
          gs_ewaybill_details-trans_id     =    zeway_bill-trans_id.
          gs_ewaybill_details-trans_name   =    zeway_bill-trans_name.
          gs_ewaybill_details-vehical_no   =    zeway_bill-vehical_no.
          gs_ewaybill_details-vehical_type =    zeway_bill-vehical_type.
          gs_ewaybill_details-distance     =    zeway_bill-distance.
        ENDIF.
        APPEND gs_ewaybill_details TO gt_ewaybill_details.
      ENDLOOP.

      IF gt_ewaybill_details IS NOT INITIAL.
        MODIFY zeway_bill FROM TABLE gt_ewaybill_details.
        CLEAR : gs_ewaybill_details.
        REFRESH : gt_ewaybill_details.
      ENDIF.

      SET SCREEN '0'.
      LEAVE SCREEN.

    WHEN OTHERS.
  ENDCASE.

ENDMODULE.


*&---------------------------------------------------------------------*
*&      Module  VALIDATE_SUBSCREEN  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE validate_subscreen_vehicalno INPUT.
*BREAK primus.
  IF zeway_bill-trns_md = 'ROAD' AND ( zeway_bill-trans_id IS INITIAL AND zeway_bill-vehical_no IS INITIAL ).
*    MESSAGE 'IF transport mode is road and transporter ID is not entered then vehical number is mandatory' TYPE 'E'.
    MESSAGE 'IF transport mode is road then either transporter ID or  vehical number is mandatory' TYPE 'E'.
  ENDIF.

ENDMODULE.


MODULE validate_subscreen_vehicaltype INPUT.

  IF zeway_bill-trns_md = 'ROAD' AND zeway_bill-vehical_type IS INITIAL.
    MESSAGE e005(zeway).
  ENDIF.

ENDMODULE.

MODULE validate_subscreen_transdoc INPUT.
*          *Transport doc no is MANDATORY if transMode is RAIL/AIR/SHIP.
  IF ( zeway_bill-trns_md = 'RAIL' OR zeway_bill-trns_md = 'AIR' OR zeway_bill-trns_md = 'SHIP' ) AND zeway_bill-trans_doc IS INITIAL .
    MESSAGE e001(zeway).
  ENDIF.

ENDMODULE.

MODULE validate_subscreen_docdt INPUT.
**      *Transport doc date is MANDATORY if transMode is RAIL/AIR/SHIP.
  IF ( zeway_bill-trns_md = 'RAIL' OR zeway_bill-trns_md = 'AIR' OR zeway_bill-trns_md = 'SHIP' ) AND zeway_bill-doc_dt IS INITIAL.
    MESSAGE e002(zeway).
  ENDIF.

  IF zeway_bill-doc_dt IS NOT INITIAL AND zeway_bill-doc_dt LT ls_final-fkdat .
    MESSAGE e009(zeway).
  ENDIF.

ENDMODULE.

MODULE validate_subscreen_distance INPUT.
**      *Transport doc date is MANDATORY if transMode is RAIL/AIR/SHIP.
  IF  zeway_bill-distance > '4000'.
    MESSAGE e008(zeway).
  ENDIF.
ENDMODULE.
