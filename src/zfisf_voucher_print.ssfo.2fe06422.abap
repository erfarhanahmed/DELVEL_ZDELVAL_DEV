types : begin of t_refdoc,
          augbl type AUGBL,
          gjahr	type gjahr, "	Fiscal Year
          belnr like wa_bseg-belnr,
          budat type budat,
          dmbtr type dmbtr,
          ngtnt,
        end of t_refdoc,

        begin of t_bkpf,
          belnr type BELNR_D,
          gjahr type gjahr,
          blart type blart,
        end of t_bkpf.
data : lv_belnr like wa_bseg-belnr,
        it_refdocs type table of t_refdoc,
        it_refdocs_tmp type table of t_refdoc,
        it_bkpf type table of t_bkpf,
        wa_refdoc  type t_refdoc,
        wa_refdoc_tmp  type t_refdoc,
        wa_bseg_tmp type t_bseg,
        wa_bkpf type t_bkpf,
        lv_tabnam type char30,
        lt_bseg_hist type table of t_bseg,
        wa_bseg_hist type t_bseg,
        modif_flag  type c.
clear : lv_belnr, wa_refdoc, wa_bseg_tmp, lv_tabnam,
        wa_refdoc, wa_bseg_hist, wa_bkpf, modif_flag.
refresh : IT_BSEG1, it_refdocs, lt_bseg_hist,
        it_refdocs_tmp, it_bkpf.

" Extract documents that have got cleared
SELECT BELNR GJAHR AUGBL SHKZG DMBTR qsshb KOSTL REBZG REBZJ
  FROM BSEG
  INTO CORRESPONDING FIELDS OF TABLE IT_BSEG1
*  INTO CORRESPONDING FIELDS OF TABLE IT_BSEG
  WHERE AUGBL = BKPFTAB-BELNR
    AND AUGGJ = BKPFTAB-GJAHR." Clearing fiscal year

IF SY-SUBRC = 0.
  DELETE IT_BSEG1 WHERE BELNR = BKPFTAB-BELNR.
*  DELETE IT_BSEG WHERE BELNR = BKPFTAB-BELNR.
ELSE.
  SELECT BELNR GJAHR AUGBL SHKZG DMBTR KOSTL REBZG
   FROM BSEG
   INTO CORRESPONDING FIELDS OF TABLE IT_BSEG1
*   INTO CORRESPONDING FIELDS OF TABLE IT_BSEG
   WHERE BELNR = BKPFTAB-BELNR.
  DELETE IT_BSEG1 WHERE REBZG EQ SPACE.
endif.

IF IT_BSEG1 IS NOT INITIAL.
  SELECT BELNR BUZEI AUGBL KOART SHKZG DMBTR qsshb KOSTL REBZG REBZJ
    FROM BSEG
    INTO CORRESPONDING FIELDS OF TABLE IT_BSEG
    FOR ALL ENTRIES IN IT_BSEG1
    WHERE BELNR  = IT_BSEG1-BELNR
      AND GJAHR = IT_BSEG1-GJAHR.

  IF SY-SUBRC = 0.

    IF BKPFTAB-BLART = 'BP'."Bank Payment
      REFRESH : IT_BSEG1, IT_BSEG.
      " Extract documents that have got cleared
      SELECT "BELNR GJAHR AUGBL SHKZG DMBTR qsshb KOSTL REBZG REBZJ
          gjahr belnr buzei koart
          shkzg dmbtr qsshb kostl rebzg rebzj rebzz auggj
        FROM BSEG
        INTO CORRESPONDING FIELDS OF TABLE IT_BSEG1
*  INTO CORRESPONDING FIELDS OF TABLE IT_BSEG
        WHERE AUGBL = BKPFTAB-BELNR
          AND AUGGJ = BKPFTAB-GJAHR." Clearing fiscal year

      IF SY-SUBRC = 0.
        DELETE IT_BSEG1 WHERE BELNR = BKPFTAB-BELNR.

*        SELECT gjahr belnr buzei koart
*            shkzg dmbtr qsshb kostl rebzg rebzj rebzz auggj
*          FROM BSEG
*          appending CORRESPONDING FIELDS OF TABLE IT_BSEG1
*          for all entries in it_bseg1
*          where belnr = it_bseg1-rebzg
*            and gjahr = it_bseg1-rebzj
*            AND KOART in ('D', 'K', 'S').

        SELECT "BELNR BUZEI AUGBL KOART SHKZG DMBTR qsshb KOSTL REBZG REBZJ
            gjahr belnr buzei koart
            shkzg dmbtr qsshb kostl rebzg rebzj rebzz auggj
          FROM BSEG
          INTO CORRESPONDING FIELDS OF TABLE IT_BSEG
          FOR ALL ENTRIES IN IT_BSEG1
          WHERE BELNR = IT_BSEG1-BELNR
            AND GJAHR = IT_BSEG1-GJAHR
            AND KOART in ('D', 'K', 'S').

        SELECT "BELNR GJAHR AUGBL SHKZG DMBTR qsshb KOSTL REBZG REBZJ
            gjahr belnr buzei koart
            shkzg dmbtr qsshb kostl rebzg rebzj rebzz auggj
          FROM BSEG
          appending CORRESPONDING FIELDS OF TABLE IT_BSEG1
*   INTO CORRESPONDING FIELDS OF TABLE IT_BSEG
          WHERE BELNR = BKPFTAB-BELNR
            AND GJAHR = BKPFTAB-GJAHR
            AND REBZG NE SPACE.
        clear : wa_bseg, wa_bseg_tmp.
        LOOP AT it_bseg1 into wa_bseg.
          IF wa_bseg-rebzg is initial.
            read table it_bseg1 into wa_bseg_tmp
            with key rebzg = wa_bseg-belnr
                     rebzj = wa_bseg-gjahr.
          else.
            loop at it_bseg1 into wa_bseg_tmp
                where rebzg = wa_bseg-rebzg
                  and rebzj = wa_bseg-rebzj.
              IF wa_bseg_tmp-belnr = wa_bseg-belnr.
                clear wa_bseg_tmp.
              ENDIF.
            endloop.
          ENDIF.
          IF not wa_bseg_tmp is initial.
            IF wa_bseg-qsshb is INITIAL.
              wa_bseg-qsshb = wa_bseg-dmbtr.
            ENDIF.
            wa_bseg-dmbtr = wa_bseg-dmbtr - wa_bseg_tmp-dmbtr.

            modify it_bseg1 from wa_bseg
              transporting qsshb dmbtr
              where belnr = wa_bseg-belnr
                and gjahr = wa_bseg-gjahr
                and buzei = wa_bseg-buzei.

            delete it_bseg1 where belnr = wa_bseg_tmp-belnr
                              and gjahr = wa_bseg_tmp-gjahr
                              and buzei = wa_bseg_tmp-buzei.
          ENDIF.
          clear : wa_bseg, wa_bseg_tmp.
        ENDLOOP.
      ELSE.
        SELECT "BELNR GJAHR AUGBL SHKZG DMBTR qsshb KOSTL REBZG REBZJ
            gjahr belnr buzei koart
            shkzg dmbtr qsshb kostl rebzg rebzj rebzz auggj
          FROM BSEG
          INTO CORRESPONDING FIELDS OF TABLE IT_BSEG1
*   INTO CORRESPONDING FIELDS OF TABLE IT_BSEG
          WHERE BELNR = BKPFTAB-BELNR
            AND GJAHR = BKPFTAB-GJAHR.
          DELETE IT_BSEG1 WHERE REBZG EQ SPACE.

          SELECT " BELNR BUZEI AUGBL KOART SHKZG
                 " DMBTR qsshb KOSTL REBZG REBZJ
                gjahr belnr buzei koart
                shkzg dmbtr qsshb kostl rebzg rebzj rebzz auggj
            FROM BSEG
              INTO CORRESPONDING FIELDS OF TABLE IT_BSEG
              FOR ALL ENTRIES IN IT_BSEG1
              WHERE BELNR = IT_BSEG1-REBZG
                AND GJAHR = IT_BSEG1-REBZJ.
      ENDIF.
      IF not it_bseg is initial.
        sort it_bseg by BELNR gjahr BUZEI.
        select distinct belnr gjahr blart
          from bkpf
          into table it_bkpf
          for all entries in it_bseg
          where belnr = it_bseg-belnr
            and gjahr = it_bseg-gjahr.
      ENDIF.

      "refresh it_bseg1.
      clear : wa_bseg, wa_bseg1.
      LOOP AT it_bseg into wa_bseg.
        IF not lv_belnr is initial AND lv_belnr <> wa_bseg-belnr.
          read table it_bseg1 into wa_bseg_tmp with key belnr = lv_belnr.
          IF sy-subrc = 0.
             wa_bseg_tmp = wa_bseg1.
*            wa_bseg_tmp-tdsamt = wa_bseg1-tdsamt.
*            wa_bseg_tmp-qsshb = wa_bseg1-qsshb.
             modify it_bseg1 from wa_bseg_tmp
               transporting tdsamt
               where belnr = wa_bseg1-belnr
                 and gjahr = wa_bseg1-gjahr.
          else.
            append wa_bseg1 to it_bseg1.
          ENDIF.
***          read table it_bseg1 into wa_bseg_tmp with key belnr = lv_belnr.
***          IF sy-subrc = 0.
***            delete it_bseg1 where belnr = lv_belnr and gjahr = wa_bseg1-gjahr.
***          ENDIF.

          clear : wa_bseg_tmp, wa_bseg1.
          "lv_belnr = wa_bseg-belnr.
        ENDIF.

        read table it_bkpf into wa_bkpf
          with key belnr = wa_bseg-belnr
                   gjahr = wa_bseg-gjahr.
        IF wa_bkpf-blart = 'KG'.
          IF wa_bseg-koart = 'K' OR wa_bseg-koart = 'D'.
            wa_bseg1 = wa_bseg.
            clear lv_belnr.
          elseif wa_bseg-koart = 'S'.
*            IF wa_bseg-shkzg = 'H'.
*              wa_bseg-dmbtr = wa_bseg-dmbtr * -1.
*            ENDIF.
            IF lv_belnr is initial.
              lv_belnr = wa_bseg-belnr.
              wa_bseg1-kostl = wa_bseg-kostl.
              wa_bseg1-netamt = wa_bseg-dmbtr.
              wa_bseg1-qsshb = wa_bseg-dmbtr.
            else.
              wa_bseg1-tdsamt = wa_bseg1-tdsamt + wa_bseg-dmbtr.
            ENDIF.
          ENDIF.
        else.
          IF wa_bseg-koart = 'K' OR wa_bseg-koart = 'D'.
            wa_bseg1 = wa_bseg.
            clear lv_belnr.
          elseif wa_bseg-koart = 'S'.
            IF lv_belnr is initial.
              lv_belnr = wa_bseg-belnr.
              wa_bseg1-kostl = wa_bseg-kostl.
              read table IT_BSEG1 into wa_bseg_tmp
                with key rebzg = wa_bseg-belnr
                               rebzj = wa_bseg-gjahr.
              IF sy-subrc = 0.
                wa_bseg1-netamt = wa_bseg-dmbtr - wa_bseg_tmp-dmbtr.
                delete IT_BSEG1 where rebzg = wa_bseg_tmp-rebzg
                                  and rebzj = wa_bseg_tmp-rebzj
                                  and rebzz = wa_bseg_tmp-rebzz
.
              else.
                wa_bseg1-netamt = wa_bseg-dmbtr.
              ENDIF.
            else.
              IF wa_bseg-shkzg = 'H'.
                wa_bseg1-tdsamt = wa_bseg1-tdsamt + wa_bseg-dmbtr.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
        clear : wa_bseg, wa_bkpf.
      ENDLOOP.
      IF not lv_belnr is initial and NOT WA_BSEG1 IS INITIAL.
         read table it_bseg1 into wa_bseg_tmp with key belnr = lv_belnr.
          IF sy-subrc = 0.
             wa_bseg_tmp = wa_bseg1.
*            wa_bseg_tmp-tdsamt = wa_bseg1-tdsamt.
*            wa_bseg_tmp-qsshb = wa_bseg1-qsshb.

            modify it_bseg1 from wa_bseg_tmp
              transporting tdsamt
              where belnr = wa_bseg1-belnr
                and gjahr = wa_bseg1-gjahr.
          else.
            append wa_bseg1 to it_bseg1.
          ENDIF.
***          read table it_bseg1 into wa_bseg_tmp with key belnr = lv_belnr.
***          IF sy-subrc = 0.
***            delete it_bseg1 where belnr = lv_belnr and gjahr = wa_bseg1-gjahr.
***          ENDIF.

        clear : wa_bseg_tmp, wa_bseg1.
      ENDIF.
      LOOP AT it_bseg1 into wa_bseg1.
*        IF wa_bseg1-koart = 'K' and wa_bseg1-shkzg = 'S'.
*          wa_bseg1-dmbtr = wa_bseg1-dmbtr * -1.
*        ENDIF.
        if wa_bseg1-qsshb is initial.
          modif_flag = 'X'.
          wa_bseg1-qsshb = wa_bseg1-dmbtr.
        endif.
        IF ( wa_bseg1-koart = 'K' and wa_bseg1-shkzg = 'S' )
            OR ( wa_bseg1-koart = 'D' and wa_bseg1-shkzg = 'H' ).
            modif_flag = 'X'.
            wa_bseg1-dmbtr  = wa_bseg1-dmbtr  * -1.
            wa_bseg1-qsshb  = wa_bseg1-qsshb  * -1.
            wa_bseg1-tdsamt = wa_bseg1-tdsamt * -1.
*            modify it_bseg1 from wa_bseg1
*              transporting dmbtr qsshb tdsamt
*              where belnr = wa_bseg1-belnr
*                and gjahr = wa_bseg1-gjahr.
          ENDIF.
          if modif_flag = 'X'.

            modify table it_bseg1 from wa_bseg1 transporting dmbtr qsshb tdsamt.
          endif.
      ENDLOOP.
    elseif bkpftab-blart = 'BR'. "BANK RECEIPT"
      data : it_bseg_inst type table of t_bseg,
             it_bseg_part type table of t_bseg,
             it_bseg_clrd type table of t_bseg,
             wa_bseg_inst type t_bseg.
      refresh : it_bseg_inst, it_bseg, lt_bseg_hist,
                it_bseg_clrd, it_bseg_part.
      clear : wa_bseg, wa_bseg_tmp, wa_bseg_inst.

      IF gv_koart = 'D'. " Transaction with Customer
        lv_tabnam = 'BSID'.
      elseif gv_koart = 'K'." Transaction with Vendor
        lv_tabnam = 'BSIK'.
      ENDIF.

      " Get partial payments
      select gjahr belnr buzei
        "koart
             shkzg dmbtr rebzg rebzj rebzz auggj
        from (lv_tabnam) "bseg
        into corresponding fields of table it_bseg_part
        where gjahr = bkpftab-gjahr
          and belnr = bkpftab-belnr.

      LOOP AT it_bseg_part into wa_bseg.
        IF NOT WA_BSEG-REBZG IS INITIAL.
          wa_bseg_tmp-augbl = wa_bseg-belnr.
          wa_bseg_tmp-auggj = wa_bseg-gjahr.
          wa_bseg_tmp-belnr = wa_bseg-rebzg.
          wa_bseg_tmp-buzei = wa_bseg-rebzz.
          wa_bseg_tmp-gjahr = wa_bseg-rebzj.
          wa_bseg_tmp-rebzg = wa_bseg-rebzg.
          wa_bseg_tmp-rebzj = wa_bseg-rebzj.
          wa_bseg_tmp-rebzz = wa_bseg-rebzz.

          IF not wa_bseg-rebzg is initial.
            while not wa_bseg_tmp-rebzg is initial.
              select single budat dmbtr rebzg rebzj rebzz
                from (lv_tabnam)
                into (wa_bseg_tmp-budat, wa_bseg_tmp-dmbtr,
                      wa_bseg_tmp-rebzg, wa_bseg_tmp-rebzj,
                      wa_bseg_tmp-rebzz)
                where gjahr = wa_bseg-rebzj
                  and belnr = wa_bseg-rebzg
                  and buzei = wa_bseg-rebzz.
              IF sy-subrc <> 0.
                exit.
              ENDIF.
              IF not wa_bseg_tmp-rebzg is initial.
                wa_bseg-rebzg = wa_bseg_tmp-rebzg.
                wa_bseg-rebzj = wa_bseg_tmp-rebzj.
                wa_bseg-rebzz = wa_bseg_tmp-rebzz.
              else.
                wa_refdoc-belnr = wa_bseg-rebzg.
                wa_refdoc-gjahr = wa_bseg-rebzj.
                wa_refdoc-budat = wa_bseg_tmp-budat.
                wa_refdoc-dmbtr = wa_bseg_tmp-dmbtr.
                append wa_refdoc to it_refdocs.
              ENDIF.
            ENDWHILE.
          ENDIF.
          IF WA_BSEG-SHKZG = 'H'.
            wa_bseg-clramt = wa_bseg-dmbtr.
            clear wa_bseg-dmbtr.
          ENDIF.
          wa_bseg-augbl = wa_bseg_tmp-augbl.
          wa_bseg-auggj = wa_bseg_tmp-auggj.
          wa_bseg-belnr = wa_bseg_tmp-belnr.
          wa_bseg-buzei = wa_bseg_tmp-buzei.
          wa_bseg-gjahr = wa_bseg_tmp-gjahr.

          clear wa_bseg_tmp.
        ENDIF.
        append wa_bseg to it_bseg_inst.
        clear : wa_bseg, wa_bseg_tmp.
      ENDLOOP.

      refresh it_bseg_part.
      it_bseg_part = it_bseg_inst.
      " Extract past clearance record for each invoice
      IF not it_bseg_part is initial.
        select BELNR GJAHR augdt AUGBL SHKZG DMBTR KOSTL REBZG REBZJ AUGGJ
          from bseg "(lv_tabnam)
          into corresponding fields of table lt_bseg_hist
          for all entries in it_bseg_part
          WHERE ( ( belnr = it_bseg_part-rebzg
            AND   gjahr = it_bseg_part-REBZJ
            AND   buzei = it_bseg_part-rebzz )
            OR ( rebzg ne space
            AND REBZG = it_bseg_part-rebzg
            AND REBZJ = it_bseg_part-REBZJ
            AND rebzz = it_bseg_part-rebzz ) ).
            " AND augdt <= it_bseg_part-augdt.
        IF sy-subrc = 0.
*          " consider concerened records from the BSAD/BSAK table
*          " while determining the latest history record.
*          it_bseg = lt_bseg_hist.
*          refresh lt_bseg_hist.
*          IF gv_koart = 'D'. " Transaction with Customer
*            lv_tabnam = 'BSAD'.
*          elseif gv_koart = 'K'." Transaction with Vendor
*            lv_tabnam = 'BSAK'.
*          ENDIF.
*          select BELNR GJAHR augdt AUGBL SHKZG DMBTR KOSTL REBZG REBZJ AUGGJ
*           from (lv_tabnam)
*           into corresponding fields of table lt_bseg_hist
*           for all entries in it_bseg_part
*           WHERE ( ( belnr = it_bseg_part-rebzg
*             AND   gjahr = it_bseg_part-REBZJ
*             AND   buzei = it_bseg_part-rebzz )
*             OR ( rebzg ne space
*             AND REBZG = it_bseg_part-rebzg
*             AND REBZJ = it_bseg_part-REBZJ
*             AND rebzz = it_bseg_part-rebzz ) )
*             AND augdt <= it_bseg_part-augdt.
*          IF sy-subrc = 0.
*            append lines of it_bseg to lt_bseg_hist.
*            refresh it_bseg.
*          ENDIF.
          delete lt_bseg_hist where rebzg eq space.
          sort lt_bseg_hist by rebzg rebzj rebzz augdt belnr gjahr augbl descending.
          delete adjacent duplicates from lt_bseg_hist comparing rebzg rebzj rebzz.
          delete lt_bseg_hist where belnr = bkpftab-belnr.
          sort it_bseg by rebzg.
          LOOP AT lt_bseg_hist into wa_bseg.
            read table it_bseg into wa_bseg_tmp with key rebzg = wa_bseg-rebzg.
            IF sy-subrc <> 0.
              append wa_bseg to it_bseg.
            ENDIF.
            clear : wa_bseg, wa_bseg_tmp.
          ENDLOOP.
          "append lines of lt_bseg_hist to it_bseg.
          sort it_bseg by belnr gjahr descending.
        ENDIF.
      ENDIF.

      IF gv_koart = 'D'. " Transaction with Customer
        lv_tabnam = 'BSAD'.
      elseif gv_koart = 'K'." Transaction with Vendor
        lv_tabnam = 'BSAK'.
      ENDIF.

      " Extract cleared docs. Also..
      " Collect invoices having delayed payment-completion
      select AUGBL GJAHR BELNR BUZEI augdt SHKZG DMBTR KOSTL REBZG REBZJ REBZZ AUGGJ
        from (lv_tabnam)
        into corresponding fields of table it_bseg_clrd
        where ( belnr = bkpftab-belnr
          and  gjahr = bkpftab-gjahr
          and  rebzg ne space )
          OR ( augbl = bkpftab-belnr
          and auggj = bkpftab-gjahr ).
      IF sy-subrc = 0.
        sort it_bseg_clrd by belnr descending.
        LOOP AT it_bseg_clrd into wa_bseg.
          IF wa_bseg-augbl = wa_bseg-belnr.
            clear wa_bseg.
            continue.
          ENDIF.

          " Keep latest records and delete others
          delete it_bseg_clrd where augbl = wa_bseg-belnr.

          IF wa_bseg-augbl = bkpftab-belnr.
            append wa_bseg to it_bseg. " rec/ balance before clearance
            wa_bseg-clramt = wa_bseg-dmbtr.
            clear wa_bseg-dmbtr.
          ENDIF.

          IF wa_bseg-rebzg is initial.
            wa_bseg-rebzg = wa_bseg-belnr.
            wa_bseg-rebzj = wa_bseg-gjahr.
            wa_bseg-rebzz = wa_bseg-buzei.
          ENDIF.
          modify it_bseg_clrd from wa_bseg.
          READ TABLE it_bseg_inst INTO wa_bseg_tmp
            with key rebzg = wa_bseg-rebzg.
          IF sy-subrc <> 0.
            APPEND wa_bseg to it_bseg_inst.
          ENDIF.
          clear wa_bseg.
        ENDLOOP.
      ENDIF.

      sort it_bseg_inst by belnr gjahr.

      " Extract past clearance record for each invoice
      select BELNR GJAHR augdt AUGBL SHKZG DMBTR KOSTL REBZG REBZJ AUGGJ
        from (lv_tabnam)
        into corresponding fields of table lt_bseg_hist
        for all entries in it_bseg_inst
        WHERE "AUGBL = it_bseg_inst-BELNR
          "and AUGGJ = it_bseg_inst-GJAHR
          "AND
          ( ( belnr = it_bseg_inst-rebzg
          AND   gjahr = it_bseg_inst-REBZJ
          AND   buzei = it_bseg_inst-rebzz )
          OR ( rebzg ne space
          AND REBZG = it_bseg_inst-rebzg
          AND REBZJ = it_bseg_inst-REBZJ
          AND rebzz = it_bseg_inst-rebzz ) )
          AND augdt <= it_bseg_inst-augdt
          AND belnr <= it_bseg_inst-belnr.
      IF sy-subrc = 0.
        delete lt_bseg_hist where rebzg eq space.

*        read table lt_bseg_hist into wa_bseg_hist with key shkzg = 'H'.

*          sort lt_bseg_hist by rebzg rebzj rebzz augdt belnr gjahr augbl descending.
*          delete adjacent duplicates from lt_bseg_hist comparing rebzg rebzj rebzz.
*          CLEAR wa_bseg_hist.
        " Alternative to the abouve SORT and DELETE commands
        LOOP AT lt_bseg_hist into wa_bseg_hist.
          IF not wa_bseg_hist is initial.
            read table lt_bseg_hist into wa_bseg_tmp
              with key belnr = wa_bseg_hist-augbl.
            IF sy-subrc = 0.
              read table it_bseg_inst into wa_bseg
                with key belnr = wa_bseg_tmp-belnr
                         augbl = wa_bseg_tmp-augbl.
              IF sy-subrc = 0.
                delete lt_bseg_hist where belnr = wa_bseg_tmp-belnr
                                    and   augbl = wa_bseg_tmp-augbl.
              else.
                delete lt_bseg_hist where augbl = wa_bseg_hist-augbl
                                    and auggj = wa_bseg_hist-auggj.
              ENDIF.
            ENDIF.
          ENDIF.
          clear : wa_bseg_hist, wa_bseg_tmp.
        ENDLOOP.
        delete lt_bseg_hist where belnr = bkpftab-belnr.
        sort : lt_bseg_hist, it_bseg by rebzg rebzj augdt belnr.

        LOOP AT lt_bseg_hist into wa_bseg_hist.
          IF wa_bseg_hist-rebzg <> wa_bseg-rebzg.
            IF not wa_bseg is initial.
              append wa_bseg to it_bseg.
              clear wa_bseg.
            ENDIF.
            read table it_bseg into wa_bseg_tmp with key rebzg = wa_bseg_hist-rebzg.
            IF sy-subrc = 0.
              continue.
            ENDIF.
          ENDIF.
          IF wa_bseg_hist-shkzg = 'H'.
            wa_bseg-belnr  = wa_bseg_hist-belnr .
            wa_bseg-GJAHR  = wa_bseg_hist-GJAHR .
            wa_bseg-BUZEI  = wa_bseg_hist-BUZEI .
            wa_bseg-AUGDT  = wa_bseg_hist-AUGDT .
            wa_bseg-AUGBL  = wa_bseg_hist-AUGBL .
            wa_bseg-KOART  = wa_bseg_hist-KOART .
            wa_bseg-SHKZG  = wa_bseg_hist-SHKZG .
            wa_bseg-dmbtr  = wa_bseg-dmbtr + wa_bseg_hist-dmbtr .
            wa_bseg-kostl  = wa_bseg_hist-kostl .
            wa_bseg-REBZG  = wa_bseg_hist-REBZG .
            wa_bseg-REBZJ  = wa_bseg_hist-REBZJ .
            wa_bseg-REBZZ  = wa_bseg_hist-REBZZ .
            wa_bseg-AUGGJ  = wa_bseg_hist-AUGGJ .
          ELSE.
            WA_BSEG = WA_BSEG_HIST.
          ENDIF.

          clear : wa_bseg_tmp.
        ENDLOOP.
        IF not wa_bseg is initial.
          read table it_bseg into wa_bseg_tmp with key rebzg = wa_bseg-rebzg.
          IF sy-subrc <> 0.
            append wa_bseg to it_bseg.
            clear wa_bseg.
          ENDIF.
        ENDIF.

        "append lines of lt_bseg_hist to it_bseg.
        sort it_bseg by belnr gjahr descending.
      ENDIF.

      IF not it_bseg_inst is initial.
        " Get Original invoice details
        sort it_bseg_inst by rebzj rebzg.
        select augbl
               gjahr
               belnr
               budat
               dmbtr
          into table it_refdocs_tmp " Invoices/ Credit Memo
          from (lv_tabnam)
          for all entries in it_bseg_inst
          where gjahr = it_bseg_inst-rebzj
            and belnr = it_bseg_inst-rebzg.
        IF sy-subrc = 0.
          LOOP AT it_refdocs_tmp into wa_refdoc.
            read table it_refdocs into wa_refdoc_tmp with key belnr = wa_refdoc-belnr.
            IF sy-subrc <> 0.
              append wa_refdoc to it_refdocs.
            ENDIF.
            clear : wa_refdoc, wa_refdoc_tmp.
          ENDLOOP.
          sort it_refdocs by belnr gjahr.
          break mbhosale.
          refresh it_refdocs_tmp.
          select belnr gjahr
            from bseg
            into corresponding fields of table it_refdocs_tmp
            for all entries in it_refdocs
            where belnr = it_refdocs-belnr
              and gjahr = it_refdocs-gjahr
              and koart in ('D', 'K')
              and shkzg = 'H'.
          IF sy-subrc = 0.
            sort : it_refdocs, it_refdocs_tmp by gjahr belnr.
            LOOP AT it_refdocs_tmp into wa_refdoc_tmp.
              read table it_refdocs into wa_refdoc
                 with key gjahr = wa_refdoc_tmp-gjahr
                          belnr = wa_refdoc_tmp-belnr .
              IF sy-subrc = 0.
                wa_refdoc-ngtnt = 'X'.
                modify it_refdocs
                  from wa_refdoc
                  transporting ngtnt
                  where gjahr = wa_refdoc_tmp-gjahr
                    and belnr = wa_refdoc_tmp-belnr.
              ENDIF.
              clear : wa_refdoc, wa_refdoc_tmp.
            ENDLOOP.
            refresh it_refdocs_tmp.
          ENDIF.
        ENDIF.

        sort : it_bseg_inst by rebzj rebzg.

        refresh it_bseg1.
        clear : wa_bseg_tmp, wa_refdoc, wa_bseg_inst, wa_bseg.
        LOOP AT it_bseg_inst into wa_bseg_inst.
          wa_bseg_tmp = wa_bseg_inst.
*          IF not wa_bseg_tmp is initial
*             and ( wa_bseg_inst-rebzg <> WA_bseg_tmp-rebzg
*                OR wa_bseg_inst-rebzj <> wa_bseg_tmp-rebzj ).

            "get org inv info
            IF not wa_bseg_inst-rebzj is initial.
              read table it_refdocs into wa_refdoc
                with key GJAHR = wa_bseg_inst-rebzj
                         belnr = wa_bseg_inst-rebzg.
            else."+++++++
              read table it_refdocs into wa_refdoc
                with key GJAHR = wa_bseg_inst-gjahr
                         belnr = wa_bseg_inst-belnr.
            ENDIF.

            IF not wa_refdoc is initial.
              wa_bseg_tmp-budat = wa_refdoc-budat. " Inv Post Date
              wa_bseg_tmp-netamt = wa_refdoc-dmbtr." Invoice Amount
            else.
              clear : wa_bseg_tmp, wa_refdoc, wa_bseg_inst, wa_bseg.
              continue.
            ENDIF.

            read table it_bseg into wa_bseg
              with key "augbl = wa_bseg_inst-belnr
                       "auggj = wa_bseg_inst-gjahr
                       REBZG = wa_bseg_inst-rebzg
                       REBZJ = wa_bseg_inst-REBZJ.
*            IF sy-subrc <> 0.
*              read table it_bseg into  wa_bseg
*              with key belnr = wa_bseg_inst-belnr
*                       gjahr = wa_bseg_inst-gjahr
*                       REBZG = wa_bseg_inst-rebzg
*                       REBZJ = wa_bseg_inst-REBZJ.
*            ENDIF.
            IF not wa_bseg is initial.
              wa_bseg_tmp-shkzg = wa_bseg-shkzg.
              IF wa_bseg-shkzg = 'H'.
                wa_bseg_tmp-prebal = wa_bseg-dmbtr.
              else.
                wa_bseg_tmp-prebal = wa_bseg_tmp-netamt - wa_bseg-dmbtr.
              ENDIF.

              IF wa_bseg_inst-clramt IS INITIAL.
                IF wa_bseg-shkzg = 'H'.
                  wa_bseg_tmp-clramt = wa_bseg_inst-dmbtr.
                  wa_bseg_tmp-balanc = wa_bseg_tmp-netamt - ( wa_bseg_tmp-prebal + wa_bseg_tmp-clramt ).
                else.
                  wa_bseg_tmp-clramt = wa_bseg-dmbtr - wa_bseg_inst-dmbtr.
                  wa_bseg_tmp-balanc = wa_bseg_inst-dmbtr.
                endif.
              else.
                wa_bseg_tmp-balanc = wa_bseg_tmp-netamt - ( wa_bseg_tmp-prebal + wa_bseg_tmp-clramt ).
              ENDIF.
            else.
              IF wa_bseg_inst-clramt IS INITIAL.
                IF wa_bseg_inst-shkzg = 'H'.
                  wa_bseg_tmp-clramt = wa_bseg_inst-dmbtr.
                  wa_bseg_tmp-balanc = wa_bseg_tmp-netamt - wa_bseg_inst-dmbtr.
                else.
                  wa_bseg_tmp-clramt = wa_bseg_tmp-netamt - wa_bseg_inst-dmbtr.
                  wa_bseg_tmp-balanc = wa_bseg_inst-dmbtr.
                ENDIF.
              else.
                wa_bseg_tmp-balanc = wa_bseg_tmp-netamt - wa_bseg_inst-clramt.
              ENDIF.

            ENDIF.
            IF wa_bseg_tmp-shkzg = 'H'.
              wa_bseg_tmp-clramt = wa_bseg_tmp-clramt * -1.
            ENDIF.

            IF wa_refdoc-ngtnt = 'X'.
              wa_bseg_tmp-netamt = wa_bseg_tmp-netamt * -1.
            ENDIF.

            append wa_bseg_tmp to it_bseg1.
            clear : wa_bseg_tmp, wa_refdoc, wa_bseg_inst, wa_bseg.
*          ENDIF.
        ENDLOOP.
      ENDIF.
    else.
      DELETE IT_BSEG WHERE SHKZG = 'H'.
    ENDIF.
  ENDIF.
ENDIF.

SORT it_bseg1 by gjahr belnr.
