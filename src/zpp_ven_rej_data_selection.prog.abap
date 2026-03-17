*&---------------------------------------------------------------------*
*&  Include           ZPP_VEN_REJ_DATA_SELECTION
*&---------------------------------------------------------------------*

  REFRESH :it_qals,
           it_qamb,
           it_lfa1,
           it_mseg,
           it_mseg2,
           it_qamb1,
           it_temp2,
           it_mseg3,
           it_makt,
           it_rm01,
           it_rj01,
           it_rwk1,
           it_scr1,
           it_srn1,
           it_line,
           it_val,
           it_final2,
           it_final.

  CLEAR : wa_qals,
          wa_qamb,
          wa_lfa1,
          wa_mseg,
          wa_mseg2,
          wa_qamb1,
          wa_temp2,
          wa_mseg3,
          wa_makt,
          wa_rm01,
          wa_rj01,
          wa_rwk1,
          wa_scr1,
          wa_srn1,
          wa_line,
          wa_final2,
          wa_final.

*&---------------------------------------------------------------------*
*&      Form  SELECT_STATMENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
*BREAK primus.
  FORM select_statments .
    IF s_vendor IS INITIAL.

      SELECT * FROM qals INTO TABLE it_qals
                         WHERE gueltigab IN s_date
                         AND art = p_art   "'01'
*                         AND herkunft = '01'
                         AND lifnr IS NOT NULL
                          AND WERK = 'PL01'.
    ELSE.

      SELECT * FROM qals INTO TABLE it_qals
                         WHERE gueltigab IN s_date
                         AND art = p_art "'01'
*                         AND herkunft = '01'
                         AND lifnr IN s_vendor
                           AND WERK = 'PL01'.
    ENDIF.

    SORT it_qals BY  prueflos.

    IF sy-subrc EQ 0 .


      SELECT  lifnr
              name1
              FROM lfa1 INTO TABLE it_lfa1
              FOR ALL ENTRIES IN it_qals
              WHERE lifnr = it_qals-lifnr.


      SELECT * FROM qamb INTO TABLE it_qamb
               FOR ALL ENTRIES IN it_qals
               WHERE prueflos = it_qals-prueflos
               AND ( typ = '1' OR typ = '3' ).

      SORT it_qamb BY prueflos zaehler.

      MOVE it_qamb TO it_qamb1 .

      DELETE  it_qamb1 WHERE typ <> 3.
      DELETE it_qamb WHERE typ <> 1.

      SORT it_qamb1 BY mblnr.
      SORT it_qamb  BY mblnr.
    ENDIF.


    SELECT  mblnr
            mjahr
            lgort
            menge
            xauto
            matnr
            aufnr
            FROM mseg INTO TABLE it_mseg
            FOR ALL ENTRIES IN it_qamb1
            WHERE mblnr = it_qamb1-mblnr
                AND mjahr = it_qamb1-mjahr.

    IF sy-subrc = 0.

      SORT it_mseg BY   mblnr lgort.
      DELETE it_mseg WHERE xauto <> 'X' .

    ENDIF.


  ENDFORM.                    " SELECT_STATMENTS
*&---------------------------------------------------------------------*
*&      Form  FILTER_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM filter_data .

*loop to transfer data of mseg to mseg2 with additional field of inspection lot
    LOOP AT it_mseg INTO wa_mseg.

      MOVE-CORRESPONDING wa_mseg TO wa_mseg2.
      APPEND wa_mseg2 TO it_mseg2.
    ENDLOOP.

*merging of two tables to get data based mblnr
    LOOP AT it_mseg2 INTO wa_mseg2.

      READ TABLE it_qamb1 INTO wa_qamb1 WITH KEY mblnr = wa_mseg2-mblnr.
      MOVE-CORRESPONDING wa_qamb1 TO wa_mseg2.
      MODIFY it_mseg2 FROM wa_mseg2.

      CLEAR : wa_mseg2 ,
              wa_qamb1.


    ENDLOOP.

*loop to append data in table without mblnr field
    LOOP AT it_mseg2 INTO wa_mseg2.

      wa_temp2-prueflos = wa_mseg2-prueflos .
      wa_temp2-lgort = wa_mseg2-lgort .
      wa_temp2-menge = wa_mseg2-menge .
      wa_temp2-matnr = wa_mseg2-matnr .

      APPEND wa_temp2 TO it_temp2.

    ENDLOOP.

    SORT it_temp2 BY prueflos lgort.

*loop to add qty. based on storage location
    LOOP AT it_temp2 INTO wa_temp2.

      lv_qty  = lv_qty + wa_temp2-menge.

      AT END OF lgort.

        wa_temp2-menge = lv_qty.
        MOVE-CORRESPONDING wa_temp2 TO wa_mseg3.
        APPEND wa_mseg3 TO it_mseg3.

        CLEAR : lv_qty,
                wa_temp2-menge.
      ENDAT.

    ENDLOOP.

*loop to get material number.
    LOOP AT it_mseg3 INTO wa_mseg3.

      READ TABLE it_temp2 INTO wa_temp2 WITH KEY  prueflos = wa_mseg3-prueflos.
      wa_mseg3-matnr = wa_temp2-matnr.
      MODIFY it_mseg3 FROM wa_mseg3.

    ENDLOOP.
  ENDFORM.                    " FILTER_DATA
*&---------------------------------------------------------------------*
*&      Form  MATERIAL_DESCRIPTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM material_description .

*select statment to get material number of type 1 mblnr
    SELECT mblnr
          mjahr
          lgort
          menge
          xauto
          matnr
          aufnr
          FROM mseg INTO TABLE it_mseg1
          FOR ALL ENTRIES IN it_qamb
          WHERE mblnr = it_qamb-mblnr
              AND mjahr = it_qamb-mjahr.


*loop to get material Description for type 1 mblnr
    SELECT matnr
           maktx
           FROM makt INTO TABLE it_makt1
           FOR ALL ENTRIES IN it_mseg1
           WHERE matnr = it_mseg1-matnr.

*loop to get material Description for type 3 mblnr
    SELECT matnr
           maktx
           FROM makt INTO TABLE it_makt
           FOR ALL ENTRIES IN it_mseg3
           WHERE matnr = it_mseg3-matnr.

    SELECT mblnr
           mjahr
           zeile
           matnr
           lifnr
           sgtxt
           FROM mseg INTO TABLE lt_mseg
           FOR ALL ENTRIES IN it_qamb
           WHERE mblnr = it_qamb-mblnr.

  ENDFORM.                    " MATERIAL_DESCRIPTION
*&---------------------------------------------------------------------*
*&      Form  POPULATE_FINAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM populate_final .

*loop to store quantity according to storage location in respective tables
    LOOP AT it_mseg3 INTO wa_mseg3.

      wa_final-prueflos = wa_mseg3-prueflos.
      wa_final-matnr    = wa_mseg3-matnr.

      IF wa_mseg3-lgort = 'RM01'.
        wa_rm01-prueflos = wa_mseg3-prueflos.
        wa_rm01-menge = wa_mseg3-menge.
      ENDIF.

      IF wa_mseg3-lgort = 'RJ01'.
        wa_rj01-prueflos = wa_mseg3-prueflos.
        wa_rj01-menge = wa_mseg3-menge.
      ENDIF.

      IF wa_mseg3-lgort = 'RWK1' .
        wa_rwk1-prueflos = wa_mseg3-prueflos.
        wa_rwk1-menge = wa_mseg3-menge.
      ENDIF.

      IF wa_mseg3-lgort = 'SCR1'.
        wa_scr1-prueflos = wa_mseg3-prueflos.
        wa_scr1-menge = wa_mseg3-menge.
      ENDIF.

      IF wa_mseg3-lgort = 'SRN1'.
        wa_srn1-prueflos = wa_mseg3-prueflos.
        wa_srn1-menge = wa_mseg3-menge.
      ENDIF.

        IF wa_mseg3-lgort = 'TPI1'.
        wa_tpi1-prueflos = wa_mseg3-prueflos.
        wa_tpi1-menge = wa_mseg3-menge.
      ENDIF.

      APPEND wa_TPI1 TO it_tpi1.
      APPEND wa_rm01 TO it_rm01.
      APPEND wa_rj01 TO it_rj01.
      APPEND wa_rwk1 TO it_rwk1.
      APPEND wa_scr1 TO it_scr1.
      APPEND wa_srn1 TO it_srn1.
      APPEND wa_final TO it_final.

    ENDLOOP.

*deleting duplicate entries
    DELETE ADJACENT DUPLICATES FROM it_rm01.
    DELETE ADJACENT DUPLICATES FROM it_tpi1.
    DELETE ADJACENT DUPLICATES FROM it_rj01.
    DELETE ADJACENT DUPLICATES FROM it_rwk1.
    DELETE ADJACENT DUPLICATES FROM it_scr1.
    DELETE ADJACENT DUPLICATES FROM it_srn1.
    DELETE ADJACENT DUPLICATES FROM it_final.

*deleting blank fields from tables
    DELETE it_rm01 WHERE prueflos = 0.
    DELETE it_tpi1 WHERE prueflos = 0.
    DELETE it_rj01 WHERE prueflos = 0.
    DELETE it_rwk1 WHERE prueflos = 0.
    DELETE it_scr1 WHERE prueflos = 0.
    DELETE it_srn1 WHERE prueflos = 0.

*loop to enter quantity according to s.locaton in final table
*    break primus.
    LOOP AT it_final INTO wa_final.
* BREAK fujiabap.
      READ TABLE it_qals INTO wa_qals WITH KEY prueflos = wa_final-prueflos.
      IF sy-subrc = 0.
        wa_final-gueltigab = wa_qals-gueltigab.
        wa_final-lifnr     = wa_qals-lifnr.
        wa_final-losmenge  = wa_qals-losmenge.
        wa_final2-lifnr   = wa_qals-lifnr.
        wa_final2-losmenge  = wa_qals-losmenge.
      ENDIF.

      READ TABLE it_rm01 INTO wa_rm01 WITH KEY prueflos = wa_final-prueflos.
      IF sy-subrc = 0.
        wa_final-rm01 = wa_rm01-menge.
        wa_final2-rm01 = wa_rm01-menge.
      ENDIF.

      READ TABLE it_rj01 INTO wa_rj01 WITH KEY prueflos = wa_final-prueflos.
      IF  sy-subrc = 0.
        wa_final-rj01 = wa_rj01-menge.
        wa_final2-rj01 = wa_rj01-menge.
      ENDIF.

      READ TABLE it_rwk1 INTO wa_rwk1 WITH KEY prueflos = wa_final-prueflos.
      IF  sy-subrc = 0.
        wa_final-rwk1 = wa_rwk1-menge.
        wa_final2-rwk1 = wa_rwk1-menge.
      ENDIF.

      READ TABLE it_scr1 INTO wa_scr1 WITH KEY prueflos = wa_final-prueflos.
      IF  sy-subrc = 0.
        wa_final-scr1 = wa_scr1-menge.
        wa_final2-scr1 = wa_scr1-menge.
      ENDIF.

      READ TABLE it_srn1 INTO wa_srn1 WITH KEY prueflos = wa_final-prueflos.
      IF  sy-subrc = 0.
        wa_final-srn1 = wa_srn1-menge.
        wa_final2-srn1 = wa_srn1-menge.
      ENDIF.

      READ TABLE it_tpi1 INTO wa_tpi1 WITH KEY prueflos = wa_final-prueflos.
      IF  sy-subrc = 0.
        wa_final-tpi1 = wa_tpi1-menge.
        wa_final2-tpi1 = wa_tpi1-menge.
      ENDIF.

      READ TABLE it_qamb INTO wa_qamb WITH KEY prueflos = wa_final-prueflos.
      IF sy-subrc = 0.
        wa_final-mblnr = wa_qamb-mblnr.
      ENDIF.


      READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_final-lifnr.
      IF sy-subrc = 0.
        wa_final-name1 = wa_lfa1-name1.
      ENDIF.

      READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_final-matnr.
      IF sy-subrc = 0.
        wa_final-maktx = wa_makt-maktx.
      ENDIF.

      READ TABLE lt_mseg INTO ls_mseg WITH KEY mblnr = wa_final-mblnr
                                               matnr = wa_final-matnr
                                               lifnr = wa_final-lifnr.
      IF sy-subrc = 0 .
         wa_final-sgtxt = ls_mseg-sgtxt.
      ENDIF.

      SORT it_qamb1 BY prueflos cpudt DESCENDING.

      READ TABLE it_qamb1 INTO wa_qamb1 WITH KEY  prueflos = wa_final-prueflos .

      wa_final-cpudt = wa_qamb1-cpudt.

      wa_final-rew = ( wa_final-rwk1 / wa_final-losmenge ) * 100.

      wa_final-t_rej = ( ( wa_final-rj01 + wa_final-scr1 + wa_final-srn1 ) / wa_final-losmenge ) *  100.

      CONCATENATE lv_clint wa_final-prueflos 'L' INTO lv_name.

*FM to fetch reason according to inspection lot
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = lv_clint
          id                      = lv_id
          language                = lv_lang
          name                    = lv_name
          object                  = lv_object
*         ARCHIVE_HANDLE          = 0
*         LOCAL_CAT               = ' '
*   IMPORTING
*         HEADER                  =
        TABLES
          lines                   = it_line[]
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

      CLEAR sy-tabix.
      LOOP AT it_line INTO wa_line.

        IF sy-tabix = '1'.
          lv_a = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '2'.
          lv_b = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '3'.
          lv_d = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '4'.
          lv_e = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '5'.
          lv_l = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '6'.
          lv_g = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '7'.
          lv_h = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '8'.
          lv_i = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '9'.
          lv_j = wa_line-tdline.
        ENDIF.

        IF sy-tabix = '10'.
          lv_k = wa_line-tdline.
        ENDIF.

      ENDLOOP.

      CONCATENATE lv_a lv_b lv_d lv_e lv_l lv_g lv_h lv_i lv_j lv_k INTO lv_f SEPARATED BY space.

      wa_final-reason = lv_f.

      MODIFY it_final FROM wa_final.
      APPEND wa_final2 TO it_final2.

      REFRESH it_line.
      CLEAR : wa_final2,
              wa_final-reason,
              lv_a,
              lv_b,
              lv_d,
              lv_e,
              lv_l,
              lv_g,
              lv_h,
              lv_i,
              lv_j,
              lv_k,
              lv_f.

    ENDLOOP.

*loop to enter inspection lot of typ 1 mblnr in final table
    LOOP AT it_qamb INTO wa_qamb.

      READ TABLE it_final INTO wa_final WITH KEY prueflos = wa_qamb-prueflos.

      IF sy-subrc <> 0.

        CLEAR : wa_final-lifnr,
                wa_final-matnr,
                wa_final-maktx,
                wa_final-mblnr,
                wa_final-gueltigab,
                wa_final-cpudt,
                wa_final-rm01,
                wa_final-rj01,
                wa_final-rwk1,
                wa_final-rew,
                wa_final-scr1,
                wa_final-srn1,
                wa_final-t_rej,
                wa_final-srn,
                wa_final-reason.



        wa_final-prueflos =  wa_qamb-prueflos.
        wa_final-mblnr = wa_qamb-mblnr.
READ TABLE it_mseg1 INTO wa_mseg1 WITH KEY mblnr = wa_final-mblnr.
IF sy-subrc = 0.


          READ TABLE it_makt1 INTO wa_makt1 WITH KEY matnr = wa_mseg1-matnr.
          if sy-subrc = 0.
          wa_final-matnr = wa_mseg1-matnr.
          wa_final-maktx = wa_makt1-maktx.
          ENDIF.
        ENDIF.
ENDIF.
        READ TABLE it_qals INTO wa_qals WITH KEY prueflos = wa_final-prueflos.
        IF sy-subrc = 0.
          wa_final-gueltigab = wa_qals-gueltigab.
          wa_final-lifnr     = wa_qals-lifnr.
          wa_final-losmenge  = wa_qals-losmenge.
          wa_final2-lifnr    = wa_qals-lifnr.
          wa_final2-losmenge  = wa_qals-losmenge.
        ENDIF.

        READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_final-lifnr.
        IF sy-subrc = 0.
          wa_final-name1 = wa_lfa1-name1.
        ENDIF.

        CONCATENATE lv_clint wa_final-prueflos 'L' INTO lv_name.

*FM to fetch reason according to inspection lot
        CALL FUNCTION 'READ_TEXT'
          EXPORTING
            client                  = lv_clint
            id                      = lv_id
            language                = lv_lang
            name                    = lv_name
            object                  = lv_object
*           ARCHIVE_HANDLE          = 0
*           LOCAL_CAT               = ' '
*   IMPORTING
*           HEADER                  =
          TABLES
            lines                   = it_line[]
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

        CLEAR sy-tabix.
        LOOP AT it_line INTO wa_line.
          IF sy-tabix = '1'.
            lv_a = wa_line-tdline.
          ENDIF.

          IF sy-tabix = '2'.
            lv_b = wa_line-tdline.
          ENDIF.

          IF sy-tabix = '3'.
            lv_d = wa_line-tdline.
          ENDIF.

          IF sy-tabix = '4'.
            lv_e = wa_line-tdline.
          ENDIF.

          IF sy-tabix = '5'.
            lv_l = wa_line-tdline.
          ENDIF.

          IF sy-tabix = '6'.
            lv_g = wa_line-tdline.
          ENDIF.

          IF sy-tabix = '7'.
            lv_h = wa_line-tdline.
          ENDIF.

          IF sy-tabix = '8'.
            lv_i = wa_line-tdline.
          ENDIF.

          IF sy-tabix = '9'.
            lv_j = wa_line-tdline.
          ENDIF.

          IF sy-tabix = '10'.
            lv_k = wa_line-tdline.
          ENDIF.
        ENDLOOP.

        CONCATENATE lv_a lv_b lv_d lv_e lv_l lv_g lv_h lv_i lv_j lv_k INTO lv_f SEPARATED BY space.

        wa_final-reason = lv_f.

        APPEND wa_final TO it_final.
        APPEND wa_final2 TO it_final2.

        REFRESH it_line.
        CLEAR : wa_final-reason,
                lv_a,
                lv_b,
                lv_d,
                lv_e,
                lv_l,
                lv_g,
                lv_h,
                lv_i,
                lv_j,
                lv_k,
                lv_f.
*      ENDIF.

      CLEAR : wa_final,
              wa_qamb.
    ENDLOOP.

    SORT it_final BY lifnr.

    FIELD-SYMBOLS <fs_fin> TYPE t_final.
    DATA ls_mara TYPE mara.

    LOOP AT it_final ASSIGNING <fs_fin>.
      CLEAR ls_mara.
      SELECT SINGLE * FROM mara INTO ls_mara
        WHERE matnr = <fs_fin>-matnr.
      <fs_fin>-zseries      = ls_mara-zseries.
      <fs_fin>-zsize        = ls_mara-zsize.
      <fs_fin>-brand        = ls_mara-brand.
      <fs_fin>-moc          = ls_mara-moc.
      <fs_fin>-type         = ls_mara-type.
    ENDLOOP.


*****    Added by ABhay 10.04.2017

    select matnr lgpbe from mard INTO TABLE it_mard
                       FOR ALL ENTRIES IN it_final
                       WHERE matnr = it_final-matnr and lgort = 'RM01'.

      loop at it_final INTO wa_final.

        READ TABLE it_mard INTO wa_mard with key matnr = wa_final-matnr.
        IF sy-subrc = 0.

          wa_final-lgpbe = wa_mard-lgpbe.

        modify it_final FROM wa_final.
*        CLEAR : WA_FINAL2, WA_MARD.
        endif.

       endloop.



  ENDFORM.                    " POPULATE_FINAL
*&---------------------------------------------------------------------*
*&      Form  POPULATE_FINAL2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM populate_final2 .

    SORT it_final2 BY lifnr.

    LOOP AT it_final2 INTO wa_final2.

      lv_losmenge   = lv_losmenge  + wa_final2-losmenge.
      lv_rm01       = lv_rm01  + wa_final2-rm01.
      lv_tpi1       = lv_tpi1  + wa_final2-rm01.
      lv_rj01       = lv_rj01  + wa_final2-rj01.
      lv_rwk1       = lv_rwk1  + wa_final2-rwk1.
      lv_scr1       = lv_scr1  + wa_final2-scr1.
      lv_srn1       = lv_srn1  + wa_final2-srn1.

      AT END OF lifnr.
        wa_final2-losmenge      = lv_losmenge.
        wa_final2-rm01          = lv_rm01.
        wa_final2-rj01          = lv_rj01.
        wa_final2-rwk1          = lv_rwk1.
        wa_final2-scr1          = lv_scr1.
        wa_final2-srn1          = lv_srn1.
        wa_final2-tpi1          = lv_tpi1.

        READ TABLE it_lfa1 INTO wa_lfa1 WITH KEY lifnr = wa_final2-lifnr.
        IF sy-subrc = 0.
          wa_final2-name1 = wa_lfa1-name1.
        ENDIF.

        wa_final2-rew = ( wa_final2-rwk1 / wa_final2-losmenge ) * 100.

        wa_final2-t_rej = ( ( wa_final2-rj01 + wa_final2-scr1 + wa_final2-srn1 ) / wa_final2-losmenge ) *  100.

        MODIFY it_final2 FROM wa_final2.

        CLEAR :   lv_losmenge,
                  lv_rm01,
                  lv_rj01,
                  lv_rwk1,
                  lv_scr1,
                  lv_srn1,
                 wa_final2.
      ENDAT.
    ENDLOOP.

    DELETE it_final2 WHERE name1 IS INITIAL.

  ENDFORM.                    " POPULATE_FINAL2

*&---------------------------------------------------------------------*
*&      Form  DATE_FORMAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM date_format .

*converting date to desired format
    CALL FUNCTION 'CONVERSION_EXIT_LDATE_OUTPUT'
      EXPORTING
        input  = s_date-low
      IMPORTING
        output = date_low.

    CALL FUNCTION 'CONVERSION_EXIT_LDATE_OUTPUT'
      EXPORTING
        input  = s_date-high
      IMPORTING
        output = date_high.

  ENDFORM.                    " DATE_FORMAT
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM build_fieldcat .

    IF summary IS INITIAL.

      REFRESH : it_fieldcat.
      CLEAR : wa_fieldcat.


      wa_fieldcat-fieldname = 'LIFNR'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'VENDOR'.
      wa_fieldcat-col_pos   = '1'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'NAME1'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'VENDOR NAME'.
      wa_fieldcat-col_pos   = '2'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'MATNR'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'ITEM CODE'.
      wa_fieldcat-col_pos   = '3'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'MAKTX'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'ITEM DESCRIPTION'.
      wa_fieldcat-col_pos   = '4'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'MBLNR'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'MATERIAL DOCUMENT'.
      wa_fieldcat-col_pos   = '5'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'GUELTIGAB'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'MATERIAL DOCUMENT DATE'.
      wa_fieldcat-col_pos   = '6'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'PRUEFLOS'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'INSPECTION LOT'.
      wa_fieldcat-col_pos   = '7'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'CPUDT'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'INSPECTION DATE'.
      wa_fieldcat-col_pos   = '8'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'LOSMENGE'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'RECEIVED QTY'.
      wa_fieldcat-col_pos   = '9'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'RM01'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'ACCEPTED QTY'.
      wa_fieldcat-col_pos   = '10'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'TPI1'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'TPI Stock'.
      wa_fieldcat-col_pos   = '11'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'RJ01'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'REJECTED QTY'.
      wa_fieldcat-col_pos   = '12'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'RWK1'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'REWORK QTY'.
      wa_fieldcat-col_pos   = '13'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'LGPBE'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'STORAGE BIN'.
      wa_fieldcat-col_pos   = '14'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'REW'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'REW%'.
      wa_fieldcat-col_pos   = '15'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'SCR1'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'SCRAP QTY'.
      wa_fieldcat-col_pos   = '16'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'SRN1'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'SRN QTY'.
      wa_fieldcat-col_pos   = '17'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'T_REJ'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'TOTAL REJ%'.
      wa_fieldcat-col_pos   = '18'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'SRN'.
      wa_fieldcat-tabname    = 'IT_FINAL'.
      wa_fieldcat-seltext_l  = 'SRN VENDOR'.
      wa_fieldcat-col_pos    = '19'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'REASON'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'REASON'.
      wa_fieldcat-col_pos   = '20'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.
*
      wa_fieldcat-fieldname = 'ZSERIES'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'Series Code'.
      wa_fieldcat-col_pos   = '21'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'ZSIZE'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'Size'.
      wa_fieldcat-col_pos   = '22'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'BRAND'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'Brand'.
      wa_fieldcat-col_pos   = '23'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'MOC'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'MOC'.
      wa_fieldcat-col_pos   = '24'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'TYPE'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'Type'.
      wa_fieldcat-col_pos   = '25'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'SGTXT'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'TEXT'.
      wa_fieldcat-col_pos   = '25'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

    ELSE.

      REFRESH : it_fieldcat.
      CLEAR : wa_fieldcat.

      wa_fieldcat-fieldname = 'LIFNR'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'VENDOR'.
      wa_fieldcat-col_pos   = '1'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'NAME1'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'VENDOR NAME'.
      wa_fieldcat-col_pos   = '2'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.


      wa_fieldcat-fieldname = 'LOSMENGE'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'RECEIVED QTY'.
      wa_fieldcat-col_pos   = '3'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'RM01'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'ACCEPTED QTY'.
      wa_fieldcat-col_pos   = '4'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'TPI1'.
      wa_fieldcat-tabname   = 'IT_FINAL'.
      wa_fieldcat-seltext_l = 'TPI Stock'.
      wa_fieldcat-col_pos   = '5'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'RJ01'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'REJECTED QTY'.
      wa_fieldcat-col_pos   = '6'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'RWK1'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'REWORK QTY'.
      wa_fieldcat-col_pos   = '7'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

*****      wa_fieldcat-fieldname = 'LGPBE'.
*****      wa_fieldcat-tabname   = 'IT_FINAL2'.
*****      wa_fieldcat-seltext_l = 'STORAGE BIN'.
*****      wa_fieldcat-col_pos   = '7'.
*****      APPEND wa_fieldcat TO it_fieldcat.
*****      CLEAR wa_fieldcat.


      wa_fieldcat-fieldname = 'SCR1'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'SCRAP QTY'.
      wa_fieldcat-col_pos   = '8'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'SRN1'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'SRN QTY'.
      wa_fieldcat-col_pos   = '9'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'REW'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'REW%'.
      wa_fieldcat-col_pos   = '10'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

      wa_fieldcat-fieldname = 'T_REJ'.
      wa_fieldcat-tabname   = 'IT_FINAL2'.
      wa_fieldcat-seltext_l = 'TOTAL REJ%'.
      wa_fieldcat-col_pos   = '11'.
      APPEND wa_fieldcat TO it_fieldcat.
      CLEAR wa_fieldcat.

    ENDIF.

  ENDFORM.                    " BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM build_layout .

    i_layout-colwidth_optimize = 'X'.

  ENDFORM.                    " BUILD_LAYOUT
*&---------------------------------------------------------------------*
*&      Form  ALV_EVENTS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM alv_events .
    CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
      EXPORTING
        i_list_type     = 0
      IMPORTING
        et_events       = it_events[]
      EXCEPTIONS
        list_type_wrong = 1
        OTHERS          = 2.
    IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
    ENDIF.

    READ TABLE it_events WITH KEY name = slis_ev_top_of_page INTO wa_event.

    IF sy-subrc = 0.

      MOVE 'TOP_OF_PAGE' TO wa_event-form.
      APPEND wa_event TO it_events.

    ENDIF.

  ENDFORM.                    " ALV_EVENTS
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM top_of_page .

    REFRESH: it_header.
    CLEAR  : wa_header.

    IF summary IS INITIAL.

      wa_header-typ = 'H'.
      wa_header-info = 'GRN RECEIPT ANALYSIS'.
      APPEND wa_header TO it_header.
      CLEAR wa_header.

    ELSE.

      wa_header-typ = 'H'.
      wa_header-info = 'VENDOR REJECTION ANALYSIS SUMMARY'.
      APPEND wa_header TO it_header.
      CLEAR wa_header.

    ENDIF.

    wa_header-typ = 'S'.
    wa_header-key = 'Date : '.

    IF date_high IS INITIAL.
      wa_header-info = date_low.
    ELSE.
      CONCATENATE date_low 'TO' date_high INTO wa_header-info SEPARATED BY space.
    ENDIF.
    APPEND wa_header TO it_header.
    CLEAR wa_header.


    CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
      EXPORTING
        it_list_commentary = it_header
*       I_LOGO             =
*       I_END_OF_LIST_GRID =
*       I_ALV_FORM         =
      .

  ENDFORM.                    " TOP_OF_PAGE
*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
  FORM alv_display .

    IF summary IS INITIAL.
  SORT IT_FINAL BY prueflos.
  DELETE ADJACENT DUPLICATES FROM IT_FINAL COMPARING prueflos.

      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
*         I_INTERFACE_CHECK      = ' '
*         I_BYPASSING_BUFFER     = ' '
*         I_BUFFER_ACTIVE        = ' '
          i_callback_program     = sy-repid
*         I_CALLBACK_PF_STATUS_SET          = ' '
*         I_CALLBACK_USER_COMMAND           = ' '
          i_callback_top_of_page = 'TOP-OF-PAGE'
*         I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*         I_CALLBACK_HTML_END_OF_LIST       = ' '
*         I_STRUCTURE_NAME       =
*         I_BACKGROUND_ID        = ' '
*         I_GRID_TITLE           =
*         I_GRID_SETTINGS        =
          is_layout              = i_layout
          it_fieldcat            = it_fieldcat[]
*         IT_EXCLUDING           =
*         IT_SPECIAL_GROUPS      =
*         IT_SORT                =
*         IT_FILTER              =
*         IS_SEL_HIDE            =
*         I_DEFAULT              = 'X'
          i_save                 = 'X'
*         IS_VARIANT             =
          it_events              = it_events
*         IT_EVENT_EXIT          =
*         IS_PRINT               =
*         IS_REPREP_ID           =
*         I_SCREEN_START_COLUMN  = 0
*         I_SCREEN_START_LINE    = 0
*         I_SCREEN_END_COLUMN    = 0
*         I_SCREEN_END_LINE      = 0
*         I_HTML_HEIGHT_TOP      = 0
*         I_HTML_HEIGHT_END      = 0
*         IT_ALV_GRAPHICS        =
*         IT_HYPERLINK           =
*         IT_ADD_FIELDCAT        =
*         IT_EXCEPT_QINFO        =
*         IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*         E_EXIT_CAUSED_BY_CALLER           =
*         ES_EXIT_CAUSED_BY_USER =
        TABLES
          t_outtab               = it_final[]
        EXCEPTIONS
          program_error          = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.

    ELSE.

      CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
        EXPORTING
*         I_INTERFACE_CHECK      = ' '
*         I_BYPASSING_BUFFER     = ' '
*         I_BUFFER_ACTIVE        = ' '
          i_callback_program     = sy-repid
*         I_CALLBACK_PF_STATUS_SET          = ' '
*         I_CALLBACK_USER_COMMAND           = ' '
          i_callback_top_of_page = 'TOP-OF-PAGE'
*         I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*         I_CALLBACK_HTML_END_OF_LIST       = ' '
*         I_STRUCTURE_NAME       =
*         I_BACKGROUND_ID        = ' '
*         I_GRID_TITLE           =
*         I_GRID_SETTINGS        =
          is_layout              = i_layout
          it_fieldcat            = it_fieldcat[]
*         IT_EXCLUDING           =
*         IT_SPECIAL_GROUPS      =
*         IT_SORT                =
*         IT_FILTER              =
*         IS_SEL_HIDE            =
*         I_DEFAULT              = 'X'
          i_save                 = 'X'
*         IS_VARIANT             =
          it_events              = it_events
*         IT_EVENT_EXIT          =
*         IS_PRINT               =
*         IS_REPREP_ID           =
*         I_SCREEN_START_COLUMN  = 0
*         I_SCREEN_START_LINE    = 0
*         I_SCREEN_END_COLUMN    = 0
*         I_SCREEN_END_LINE      = 0
*         I_HTML_HEIGHT_TOP      = 0
*         I_HTML_HEIGHT_END      = 0
*         IT_ALV_GRAPHICS        =
*         IT_HYPERLINK           =
*         IT_ADD_FIELDCAT        =
*         IT_EXCEPT_QINFO        =
*         IR_SALV_FULLSCREEN_ADAPTER        =
* IMPORTING
*         E_EXIT_CAUSED_BY_CALLER           =
*         ES_EXIT_CAUSED_BY_USER =
        TABLES
          t_outtab               = it_final2[]
        EXCEPTIONS
          program_error          = 1
          OTHERS                 = 2.
      IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
      ENDIF.
    ENDIF.

  ENDFORM.                    " ALV_DISPLAY
