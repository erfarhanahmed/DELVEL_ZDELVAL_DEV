*&---------------------------------------------------------------------*
*& Report ZUS_INVENTORY_AGEING_DETAILS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zinventory_ageing_details_copy.

TABLES:mara,mard.
TYPE-POOLS: slis.

TYPES:BEGIN OF ty_mara ,
        matnr TYPE mara-matnr,
*        mtart TYPE mara-mtart,
*        werks TYPE mard-werks,
*        lgort TYPE mard-lgort,
*        labst TYPE mard-labst,
        wrkst TYPE mara-wrkst, "Added by sarika Thange 09.05.2019
      END OF ty_mara,

      BEGIN OF ty_mard,
        matnr TYPE mard-matnr,
        werks TYPE mard-werks,
        lgort TYPE mard-lgort,
        labst TYPE mard-labst,
        insme TYPE mard-insme,
      END OF ty_mard,

*      BEGIN OF ty_mska,
*        matnr TYPE mska-matnr,
*        werks TYPE mska-werks,
*        lgort TYPE mska-lgort,
*        sobkz TYPE mska-sobkz,
*        kalab TYPE mska-kalab,
*        kains TYPE mska-kains,
*      END OF ty_mska,

      BEGIN OF ty_mska,
        matnr TYPE mska-matnr,
        werks TYPE mska-werks,
        lgort TYPE mska-lgort,
        CHARG TYPE mska-CHARG,
        sobkz TYPE mska-sobkz,
        vbeln TYPE mska-vbeln,
        posnr TYPE mska-posnr,
        kalab TYPE mska-kalab,
        kains TYPE mska-kains,
      END OF ty_mska,

      BEGIN OF ty_mslb,
        matnr TYPE mslb-matnr,
        werks TYPE mslb-werks,
        sobkz TYPE mslb-sobkz,
        lblab TYPE mslb-lblab,
      END OF ty_mslb,

      BEGIN OF ty_makt,
        matnr TYPE makt-matnr,
        maktx TYPE makt-maktx,
      END OF ty_makt,

      BEGIN OF ty_mseg,
        mblnr      TYPE mseg-mblnr,
        zeile      TYPE mseg-zeile,
        bwart      TYPE mseg-bwart,
        matnr      TYPE mseg-matnr,
        werks      TYPE mseg-werks,
        lgort      TYPE mseg-lgort,
        sobkz      TYPE mseg-sobkz,
        lifnr      TYPE mseg-lifnr,
        shkzg      TYPE mseg-shkzg,
        dmbtr      TYPE mseg-dmbtr,
        menge      TYPE mseg-menge,
        bukrs      TYPE mseg-bukrs,
        budat_mkpf TYPE mseg-budat_mkpf,
      END OF ty_mseg,

      BEGIN OF st_mseg,
        mblnr      TYPE mseg-mblnr,
        zeile      TYPE mseg-zeile,
        bwart      TYPE mseg-bwart,
        matnr      TYPE mseg-matnr,
        werks      TYPE mseg-werks,
        smbln      TYPE mseg-smbln,
     END OF st_mseg,

      BEGIN OF ty_t156t,
      spras TYPE t156t-spras,
      bwart TYPE t156t-bwart,
      sobkz TYPE t156t-sobkz,
      KZBEW TYPE t156t-KZBEW,
      KZZUG TYPE t156t-KZZUG,
      KZVBR TYPE t156t-KZVBR,
      BTEXT TYPE t156t-BTEXT,
      END OF ty_t156t,

      BEGIN OF ty_mbew,
          matnr	TYPE matnr,     " MATERIAL NUMBER
          bwkey TYPE mbew-bwkey,
          lbkum TYPE mbew-lbkum,
          salk3 TYPE mbew-salk3,
          vprsv TYPE vprsv,     " PRICE CONTROL INDICATOR
          verpr TYPE verpr,      "  MOVING AVERAGE PRICE/PERIODIC UNIT PRICE
          stprs	TYPE stprs,	     " STANDARD PRICE
        END OF ty_mbew,

      BEGIN OF ty_ebew,
          matnr	TYPE matnr,     " MATERIAL NUMBER
          bwkey TYPE ebew-bwkey,
          vbeln TYPE ebew-vbeln,
          posnr TYPE ebew-posnr,
          lbkum TYPE ebew-lbkum,
          salk3 TYPE ebew-salk3,
          vprsv TYPE vprsv,     " PRICE CONTROL INDICATOR
          verpr TYPE verpr,      "  MOVING AVERAGE PRICE/PERIODIC UNIT PRICE
          stprs	TYPE stprs,	     " STANDARD PRICE
        END OF ty_ebew,


      BEGIN OF ty_final,
        mblnr TYPE mseg-mblnr,
        zeile TYPE mseg-zeile,
        bwart TYPE mseg-bwart,
        matnr TYPE mseg-matnr,
        werks TYPE mseg-werks,
        lgort TYPE mseg-lgort,
        lifnr TYPE mseg-lifnr,
        dmbtr TYPE mseg-dmbtr,
        dmbtr_so TYPE mseg-dmbtr,
        menge TYPE mseg-menge,
        menge_so TYPE mseg-menge,
        bukrs TYPE mseg-bukrs,
        date  TYPE mkpf-budat,
        bldat TYPE mkpf-bldat,
        day   TYPE int4,
        qty   TYPE mseg-menge,
        text  TYPE string,
        wrkst TYPE mara-wrkst,
        BTEXT TYPE t156t-BTEXT,
      END OF ty_final,

      BEGIN OF ty_down,
        mblnr     TYPE mseg-mblnr,
        matnr     TYPE mseg-matnr,
        bwart     TYPE mseg-bwart,
        BTEXT     TYPE char25,
        werks     TYPE mseg-werks,
        lgort     TYPE mseg-lgort,
        qty       TYPE char15,
        menge     TYPE char15,
        menge_so  TYPE char15,
        dmbtr     TYPE char15,
        dmbtr_so  TYPE char15,
        date      TYPE char15,
        day       TYPE char15,
        wrkst     TYPE mara-wrkst,
        bldat     TYPE char15,
        ref       TYPE char15,
        text      TYPE string,
      END OF ty_down.




DATA: it_mara  TYPE TABLE OF ty_mara,
      wa_mara  TYPE          ty_mara,

      it_mseg  TYPE TABLE OF ty_mseg,
      wa_mseg  TYPE          ty_mseg,

      it_mseg_so  TYPE TABLE OF ty_mseg,
      wa_mseg_so  TYPE          ty_mseg,

      gt_mseg    TYPE TABLE OF st_mseg,
      gs_mseg    TYPE          st_mseg,

      gt_mseg_so    TYPE TABLE OF st_mseg,
      gs_mseg_so    TYPE          st_mseg,

      it_mard  TYPE TABLE OF ty_mard,
      wa_mard  TYPE          ty_mard,

      it_mslb  TYPE TABLE OF ty_mslb,
      wa_mslb  TYPE          ty_mslb,

      it_mska  TYPE TABLE OF ty_mska,
      wa_mska  TYPE          ty_mska,

      it_t156t TYPE TABLE OF ty_t156t,
      wa_t156t TYPE          ty_t156t,

      it_mbew TYPE TABLE OF ty_mbew,
      wa_mbew TYPE          ty_mbew,

      it_ebew TYPE TABLE OF ty_ebew,
      wa_ebew TYPE          ty_ebew,

      it_final TYPE TABLE OF ty_final,
      wa_final TYPE          ty_final,

      it_down  TYPE TABLE OF ty_down,
      wa_down  TYPE          ty_down,

      it_makt  TYPE TABLE OF ty_makt,
      wa_makt  TYPE          ty_makt.

DATA : ls_qamb TYPE qamb,
       wa_qamb TYPE qamb.

DATA: it_fcat TYPE slis_t_fieldcat_alv,
      wa_fcat LIKE LINE OF it_fcat.

DATA : lv_text TYPE tdobname.
DATA : lt_lines TYPE TABLE OF tline,
       ls_lines TYPE tline.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
SELECT-OPTIONS: s_matnr FOR mara-matnr,
                s_werks FOR mard-werks OBLIGATORY DEFAULT 'PL01'.
PARAMETERS    : p_lgort TYPE mard-lgort OBLIGATORY.

SELECTION-SCREEN: END OF BLOCK b1.

*SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002 .
*PARAMETERS p_down AS CHECKBOX.
*PARAMETERS p_folder LIKE rlgrap-filename DEFAULT 'E:\delval\temp'.
*SELECTION-SCREEN END OF BLOCK b2.
*
*SELECTION-SCREEN BEGIN OF LINE.
*  SELECTION-SCREEN COMMENT 5(63) TEXT-005.
*SELECTION-SCREEN END OF LINE.
*
*SELECTION-SCREEN BEGIN OF LINE.
*  SELECTION-SCREEN COMMENT 5(63) TEXT-006.
*SELECTION-SCREEN END OF LINE.


LOOP AT s_werks.
IF s_werks-low = 'US01'.
   s_werks-low = ' '.
ENDIF.
IF s_werks-high = 'US01'.
   s_werks-high = ' '.
ENDIF.

IF s_werks-low = 'US02'.
   s_werks-low = ' '.
ENDIF.
IF s_werks-high = 'US02'.
   s_werks-high = ' '.
ENDIF.

MODIFY s_werks.
ENDLOOP.


START-OF-SELECTION.

  PERFORM get_data.
  PERFORM sort_data.
  PERFORM display.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .
  IF p_lgort IS NOT INITIAL.
    SELECT matnr
           werks
           lgort
           labst
           insme FROM mard INTO TABLE it_mard
           WHERE matnr IN s_matnr
             AND lgort = p_lgort
             AND werks IN s_werks.


   SELECT matnr
          werks
          lgort
          CHARG
          sobkz
          vbeln
          posnr
          kalab
          kains
     FROM mska INTO TABLE it_mska
          WHERE matnr IN s_matnr
            AND lgort = p_lgort
            AND werks IN s_werks
            AND sobkz = 'E'.
  ELSE.
    SELECT matnr
           werks
           lgort
           labst
           insme FROM mard INTO TABLE it_mard
           WHERE matnr IN s_matnr
             AND werks IN s_werks.

   SELECT matnr
          werks
          lgort
          CHARG
          sobkz
          vbeln
          posnr
          kalab
          kains
     FROM mska INTO TABLE it_mska
          WHERE matnr IN s_matnr
            AND werks IN s_werks
            AND sobkz = 'E'.
  ENDIF.

  IF it_mard IS NOT INITIAL.
    SELECT matnr
           wrkst
           FROM mara
           INTO TABLE it_mara
           FOR ALL ENTRIES IN it_mard
           WHERE matnr = it_mard-matnr.

    SELECT matnr
           bwkey
           lbkum
           salk3
           vprsv
           verpr
           stprs
      FROM mbew
      INTO TABLE it_mbew
      FOR ALL ENTRIES IN it_mard
      WHERE matnr = it_mard-matnr
        AND bwkey = it_mard-werks.
  ENDIF.

  IF  it_mara IS NOT INITIAL.
    SELECT matnr
           maktx
           FROM makt
           INTO TABLE it_makt
           FOR ALL ENTRIES IN it_mara
           WHERE matnr = it_mara-matnr.
  ENDIF.


  IF it_mard IS NOT INITIAL.

*    SELECT matnr
*           werks
*           sobkz
*           lblab FROM mslb INTO TABLE it_mslb
*           WHERE matnr IN s_matnr
*            AND werks IN s_werks
*            AND sobkz = 'O'.


    SELECT mblnr
           zeile
           bwart
           matnr
           werks
           lgort
           sobkz
           lifnr
           shkzg
           dmbtr
           menge
           bukrs
           budat_mkpf FROM mseg INTO TABLE it_mseg
           FOR ALL ENTRIES IN it_mard
           WHERE matnr = it_mard-matnr
             AND lgort = it_mard-lgort
             AND bukrs = '1000'
             AND bwart IN ('101','105','561','309','311','321','411','412','501','531','653','701','Z11','542','262',
                           '602','301','413','344','Z42','202','343','312','544','166')
             AND sobkz <> 'E'
             AND shkzg = 'S'.

  ENDIF.

IF it_mseg IS NOT INITIAL.
  SELECT mblnr
         zeile
         bwart
         matnr
         werks
         smbln FROM mseg INTO TABLE gt_mseg
         FOR ALL ENTRIES IN it_mseg
         WHERE smbln = it_mseg-mblnr
           AND bwart = '322'.

ENDIF.

  IF it_mska IS NOT INITIAL.

    SELECT matnr
           bwkey
           vbeln
           posnr
           lbkum
           salk3
           vprsv
           verpr
           stprs
      FROM ebew
      INTO TABLE it_ebew
      FOR ALL ENTRIES IN it_mska
      WHERE matnr = it_mska-matnr
        AND bwkey = it_mska-werks
        AND vbeln = it_mska-vbeln
        AND posnr = it_mska-posnr.

    SELECT mblnr
           zeile
           bwart
           matnr
           werks
           lgort
           sobkz
           lifnr
           shkzg
           dmbtr
           menge
           bukrs
           budat_mkpf FROM mseg INTO TABLE it_mseg_so
           FOR ALL ENTRIES IN it_mska
           WHERE matnr = it_mska-matnr
             AND lgort = it_mska-lgort
             AND bukrs = '1000'
             AND bwart IN ('101','105','561','309','311','321','411','412','501','531','653','701','Z11','542','262',
                           '602','301','413','344','Z42','202','343','312','544','166')
             AND sobkz = 'E'
             AND shkzg = 'S'.
  ENDIF.

IF it_mseg_so IS NOT INITIAL.
  SELECT mblnr
         zeile
         bwart
         matnr
         werks
         smbln FROM mseg INTO TABLE gt_mseg_so
         FOR ALL ENTRIES IN it_mseg_so
         WHERE smbln = it_mseg_so-mblnr
           AND bwart = '322'.
ENDIF.


  LOOP AT it_mseg INTO wa_mseg WHERE bwart = '321'.
    READ TABLE gt_mseg INTO gs_mseg WITH KEY smbln = wa_mseg-mblnr.
    IF sy-subrc = 0.
      DELETE it_mseg WHERE mblnr = wa_mseg-mblnr.
    ENDIF.
  ENDLOOP.

  LOOP AT it_mseg_so INTO wa_mseg_so WHERE bwart = '321'.
    READ TABLE gt_mseg_so INTO gs_mseg_so WITH KEY smbln = wa_mseg_so-mblnr.
    IF sy-subrc = 0.
      DELETE it_mseg_so WHERE mblnr = wa_mseg-mblnr.
    ENDIF.
  ENDLOOP.

  LOOP AT it_mseg INTO wa_mseg." WHERE bwart = '321'.
    SELECT SINGLE * FROM qamb INTO wa_qamb WHERE mblnr = wa_mseg-mblnr.
     IF sy-subrc = 0.
       SELECT SINGLE * FROM qamb INTO ls_qamb WHERE PRUEFLOS = wa_qamb-PRUEFLOS AND typ NE '3'.
         IF sy-subrc = 0.
           DELETE it_mseg WHERE mblnr = ls_qamb-mblnr AND zeile = ls_qamb-zeile.
         ENDIF.
     ENDIF.
  ENDLOOP.
  CLEAR :wa_qamb,ls_qamb.
  LOOP AT it_mseg_so INTO wa_mseg_so WHERE bwart = '321'.
    SELECT SINGLE * FROM qamb INTO wa_qamb WHERE mblnr = wa_mseg_so-mblnr.
     IF sy-subrc = 0.
       SELECT SINGLE * FROM qamb INTO ls_qamb WHERE PRUEFLOS = wa_qamb-PRUEFLOS AND typ NE '3'.
         IF sy-subrc = 0.
           DELETE it_mseg_so WHERE mblnr = ls_qamb-mblnr  AND zeile = ls_qamb-zeile.
         ENDIF.
     ENDIF.
  ENDLOOP.

  SORT it_mseg BY matnr budat_mkpf DESCENDING.
  SORT it_mseg_so BY matnr budat_mkpf DESCENDING.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SORT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM sort_data .
  DATA :tmp_qty TYPE mard-labst.
*  DATA : zrate   TYPE zrate.
  DATA : zrate   TYPE p DECIMALS 6.
  DATA : value   TYPE ebew-salk3.
  DATA: stock TYPE ebew-lbkum.
  LOOP AT it_mseg INTO wa_mseg.

    ON CHANGE OF wa_mseg-matnr.
      CLEAR: tmp_qty,zrate .
      LOOP AT it_mard INTO wa_mard WHERE matnr = wa_mseg-matnr.
        tmp_qty = tmp_qty + wa_mard-labst.
        tmp_qty = tmp_qty + wa_mard-insme.
      ENDLOOP.

*      LOOP AT it_mska INTO wa_mska WHERE matnr = wa_mseg-matnr.
*        tmp_qty = tmp_qty + wa_mska-kalab.
*        tmp_qty = tmp_qty + wa_mska-kains.
*      ENDLOOP.

*      LOOP AT it_mslb INTO wa_mslb WHERE matnr = wa_mseg-matnr.
*        tmp_qty = tmp_qty + wa_mslb-lblab.
*      ENDLOOP.

      READ TABLE it_mbew INTO wa_mbew WITH KEY matnr = wa_mard-matnr.
       IF sy-subrc = 0.
         zrate = wa_mbew-salk3 / wa_mbew-lbkum.
       ENDIF.

    ENDON.

    wa_final-mblnr = wa_mseg-mblnr.
    wa_final-zeile = wa_mseg-zeile.
    wa_final-bwart = wa_mseg-bwart.
    wa_final-matnr = wa_mseg-matnr.
    wa_final-werks = wa_mseg-werks.
    wa_final-lgort = wa_mseg-lgort.
    wa_final-lifnr = wa_mseg-lifnr.
*    wa_final-dmbtr = wa_mseg-dmbtr.

    IF wa_mseg-menge > tmp_qty.

      wa_final-menge = tmp_qty.
      CLEAR tmp_qty.
    ELSE.
      wa_final-menge = wa_mseg-menge.
      tmp_qty = tmp_qty - wa_mseg-menge.
    ENDIF .
    wa_final-dmbtr = wa_final-menge * zrate .
    wa_final-qty  = wa_mseg-menge.
    wa_final-bukrs = wa_mseg-bukrs.
    wa_final-date  = wa_mseg-budat_mkpf .
    wa_final-day   = sy-datum - wa_mseg-budat_mkpf .


    CASE wa_final-bwart.
      WHEN '101'.
        SELECT SINGLE btext INTO wa_final-btext FROM t156t WHERE spras = 'E' AND bwart = wa_final-bwart AND kzbew = 'B' AND kzzug = ' '.
      WHEN '262'.
        SELECT SINGLE btext INTO wa_final-btext FROM t156t WHERE spras = 'E' AND bwart = wa_final-bwart AND kzbew = 'L'." AND kzzug = ' '.
      WHEN '561'.
        SELECT SINGLE bldat INTO wa_final-bldat FROM mkpf WHERE mblnr = wa_final-mblnr.
      WHEN OTHERS .
        SELECT SINGLE btext INTO wa_final-btext FROM t156t WHERE spras = 'E' AND bwart = wa_final-bwart AND sobkz = ' ' AND kzvbr = ' '.
    ENDCASE.




    READ TABLE it_mara INTO wa_mara WITH  KEY matnr = wa_mseg-matnr.
    wa_final-wrkst = wa_mara-wrkst.

    lv_text = wa_final-matnr .

    IF lv_text IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = 'E'
          name                    = lv_text
          object                  = 'MATERIAL'
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
* Implement suitable error handling here
      ENDIF.

      IF lt_lines IS NOT INITIAL.
        LOOP AT  lt_lines INTO ls_lines.
          CONCATENATE wa_final-text  ls_lines-tdline INTO wa_final-text SEPARATED BY space.
        ENDLOOP.
      ELSE.
        READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara-matnr.
        wa_final-text = wa_makt-maktx.
      ENDIF.

    ENDIF.

    APPEND wa_final TO it_final.
    CLEAR :wa_final,wa_mara,wa_mara,lv_text.
    CLEAR:lt_lines,ls_lines.
  ENDLOOP.

********So Aging*********************
CLEAR :zrate.

LOOP AT it_mseg_so INTO wa_mseg_so.

    ON CHANGE OF wa_mseg_so-matnr.
      CLEAR: tmp_qty,zrate ,value,stock.


      LOOP AT it_mska INTO wa_mska WHERE matnr = wa_mseg_so-matnr.
        tmp_qty = tmp_qty + wa_mska-kalab.
        tmp_qty = tmp_qty + wa_mska-kains.
      ENDLOOP.

      LOOP AT it_ebew INTO wa_ebew WHERE matnr = wa_mska-matnr
                                   AND   bwkey = wa_mska-werks
                                   AND   vbeln = wa_mska-vbeln
                                   AND   posnr = wa_mska-posnr.

        value = value + wa_ebew-salk3.
        stock = stock + wa_ebew-lbkum.
      ENDLOOP.

        zrate = value /  stock.

    ENDON.

*    LOOP AT it_mska INTO wa_mska WHERE matnr = wa_mseg_so-matnr.
    wa_final-mblnr = wa_mseg_so-mblnr.
    wa_final-zeile = wa_mseg_so-zeile.
    wa_final-bwart = wa_mseg_so-bwart.
    wa_final-matnr = wa_mseg_so-matnr.
    wa_final-werks = wa_mseg_so-werks.
    wa_final-lgort = wa_mseg_so-lgort.
    wa_final-lifnr = wa_mseg_so-lifnr.
*    wa_final-dmbtr = wa_mseg-dmbtr.

    IF wa_mseg_so-menge > tmp_qty.

      wa_final-menge_so = tmp_qty.
      CLEAR tmp_qty.
    ELSE.
      wa_final-menge_so = wa_mseg_so-menge.
      tmp_qty = tmp_qty - wa_mseg_so-menge.
    ENDIF .
    wa_final-dmbtr_so = wa_final-menge_so * zrate .
    wa_final-qty  = wa_mseg_so-menge.
    wa_final-bukrs = wa_mseg_so-bukrs.
    wa_final-date  = wa_mseg_so-budat_mkpf .
    wa_final-day   = sy-datum - wa_mseg_so-budat_mkpf .
*    ENDLOOP.

    CASE wa_final-bwart.
      WHEN '101'.
        SELECT SINGLE btext INTO wa_final-btext FROM t156t WHERE spras = 'E' AND bwart = wa_final-bwart AND kzbew = 'B' AND kzzug = ' '.
      WHEN '262'.
        SELECT SINGLE btext INTO wa_final-btext FROM t156t WHERE spras = 'E' AND bwart = wa_final-bwart AND kzbew = 'L'." AND kzzug = ' '.
      WHEN '561'.
        SELECT SINGLE bldat INTO wa_final-bldat FROM mkpf WHERE mblnr = wa_final-mblnr.
      WHEN OTHERS .
        SELECT SINGLE btext INTO wa_final-btext FROM t156t WHERE spras = 'E' AND bwart = wa_final-bwart AND sobkz = ' ' AND kzvbr = ' '.
    ENDCASE.




    READ TABLE it_mara INTO wa_mara WITH  KEY matnr = wa_mseg_so-matnr.
    wa_final-wrkst = wa_mara-wrkst.

    lv_text = wa_final-matnr .
    CLEAR:lt_lines,ls_lines.
    IF lv_text IS NOT INITIAL.
      CALL FUNCTION 'READ_TEXT'
        EXPORTING
          client                  = sy-mandt
          id                      = 'GRUN'
          language                = 'E'
          name                    = lv_text
          object                  = 'MATERIAL'
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
* Implement suitable error handling here
      ENDIF.

      IF lt_lines IS NOT INITIAL.
        LOOP AT  lt_lines INTO ls_lines.
          CONCATENATE wa_final-text  ls_lines-tdline INTO wa_final-text SEPARATED BY space.
        ENDLOOP.
      ELSE.
        READ TABLE it_makt INTO wa_makt WITH KEY matnr = wa_mara-matnr.
        wa_final-text = wa_makt-maktx.
      ENDIF.

    ENDIF.

    APPEND wa_final TO it_final.
    CLEAR :wa_final,wa_mara,wa_mara,lv_text,value,stock.

  ENDLOOP.


DELETE IT_FINAL WHERE MENGE = 0 AND MENGE_SO = 0.
*  IF p_down = 'X'.
    LOOP AT it_final INTO wa_final.
      wa_down-mblnr = wa_final-mblnr.
      wa_down-matnr = wa_final-matnr.
      wa_down-bwart = wa_final-bwart.
      wa_down-werks = wa_final-werks.
      wa_down-lgort = wa_final-lgort.
      wa_down-qty = wa_final-qty.
      wa_down-menge = wa_final-menge.
      wa_down-menge_so = wa_final-menge_so.
      wa_down-dmbtr = wa_final-dmbtr.
      wa_down-dmbtr_so = wa_final-dmbtr_so.
      wa_down-day   = wa_final-day.
      wa_down-text   = wa_final-text.
      wa_down-wrkst   = wa_final-wrkst.
      wa_down-btext   = wa_final-btext.

      IF wa_final-date IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-date
          IMPORTING
            output = wa_down-date.

        CONCATENATE wa_down-date+0(2) wa_down-date+2(3) wa_down-date+5(4)
                        INTO wa_down-date SEPARATED BY '-'.

      ENDIF.

      IF wa_final-bldat IS NOT INITIAL.


        CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
          EXPORTING
            input  = wa_final-bldat
          IMPORTING
            output = wa_down-bldat.

        CONCATENATE wa_down-bldat+0(2) wa_down-bldat+2(3) wa_down-bldat+5(4)
                        INTO wa_down-bldat SEPARATED BY '-'.

      ENDIF.

      CALL FUNCTION 'CONVERSION_EXIT_IDATE_OUTPUT'
        EXPORTING
          input  = sy-datum
        IMPORTING
          output = wa_down-ref.

      CONCATENATE wa_down-ref+0(2) wa_down-ref+2(3) wa_down-ref+5(4)
                      INTO wa_down-ref SEPARATED BY '-'.

      APPEND wa_down TO it_down.
      CLEAR wa_down.
    ENDLOOP.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display .
  PERFORM fcat USING :   '1'   'MBLNR'           'IT_FINAL'      'Document No'                 '20' ,
                         '2'   'MATNR'           'IT_FINAL'      'Material No '                '20' ,
                         '3'   'BWART'           'IT_FINAL'      'Movement Type '              '15' ,
                         '4'   'BTEXT'           'IT_FINAL'      'Mov Type Desc'              '15' ,
                         '5'   'WERKS'           'IT_FINAL'      'Plant '                      '05' ,
                         '6'   'LGORT'           'IT_FINAL'      'Storage Loc '                '15' ,
                         '7'   'QTY'             'IT_FINAL'      'Quantity '                   '15' ,
                         '8'   'MENGE'           'IT_FINAL'      'UR Allocated Quantity '         '15' ,
                         '9'   'MENGE_SO'           'IT_FINAL'      'SO Allocated Quantity '         '15' ,
                        '10'   'DMBTR'           'IT_FINAL'      'UR Amount '                     '15' ,
                        '11'   'DMBTR_SO'           'IT_FINAL'      'SO Amount '                     '15' ,
                        '12'   'DATE'            'IT_FINAL'      'Posting Date '               '15' ,
                        '13'   'DAY'             'IT_FINAL'      'Aging Day '                  '15' ,
                        '14'   'TEXT'            'IT_FINAL'      'Material Description'        '100' ,
                        '15'   'WRKST'           'IT_FINAL'      'USA Code'                    '15' ,
                        '16'   'BLDAT'           'IT_FINAL'      'Document Date'                    '15' .


  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
*     I_BYPASSING_BUFFER = ' '
*     I_BUFFER_ACTIVE    = ' '
      i_callback_program = sy-repid
*     I_CALLBACK_PF_STATUS_SET          = ' '
*     I_CALLBACK_USER_COMMAND           = ' '
*     I_CALLBACK_TOP_OF_PAGE            = ' '
*     I_CALLBACK_HTML_TOP_OF_PAGE       = ' '
*     I_CALLBACK_HTML_END_OF_LIST       = ' '
*     I_STRUCTURE_NAME   =
*     I_BACKGROUND_ID    = ' '
*     I_GRID_TITLE       =
*     I_GRID_SETTINGS    =
*     IS_LAYOUT          =
      it_fieldcat        = it_fcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_SCREEN_START_COLUMN             = 0
*     I_SCREEN_START_LINE               = 0
*     I_SCREEN_END_COLUMN               = 0
*     I_SCREEN_END_LINE  = 0
*     I_HTML_HEIGHT_TOP  = 0
*     I_HTML_HEIGHT_END  = 0
*     IT_ALV_GRAPHICS    =
*     IT_HYPERLINK       =
*     IT_ADD_FIELDCAT    =
*     IT_EXCEPT_QINFO    =
*     IR_SALV_FULLSCREEN_ADAPTER        =
*   IMPORTING
*     E_EXIT_CAUSED_BY_CALLER           =
*     ES_EXIT_CAUSED_BY_USER            =
    TABLES
      t_outtab           = it_final
*   EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

*  IF p_down = 'X'.
*    PERFORM download.
*  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0383   text
*      -->P_0384   text
*      -->P_0385   text
*      -->P_0386   text
*      -->P_0387   text
*----------------------------------------------------------------------*
FORM fcat USING    VALUE(p1)
                    VALUE(p2)
                    VALUE(p3)
                    VALUE(p4)
                    VALUE(p5).
  wa_fcat-col_pos   = p1.
  wa_fcat-fieldname = p2.
  wa_fcat-tabname   = p3.
  wa_fcat-seltext_l = p4.
*wa_fcat-key       = .
  wa_fcat-outputlen   = p5.

  APPEND wa_fcat TO it_fcat.
  CLEAR wa_fcat.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DOWNLOAD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM download .
*  TYPE-POOLS truxs.
*  DATA: it_csv TYPE truxs_t_text_data,
*        wa_csv TYPE LINE OF truxs_t_text_data,
*        hd_csv TYPE LINE OF truxs_t_text_data.
*
**  DATA: lv_folder(150).
*  DATA: lv_file(30).
*  DATA: lv_fullfile TYPE string,
*        lv_dat(10),
*        lv_tim(4).
*  DATA: lv_msg(80).
*
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_down
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*
*
**  lv_file = 'ZINVAG_DET.TXT'.
*  CONCATENATE 'ZINVAG_DET' P_LGORT '.TXT' INTO LV_FILE.
*
*
*  CONCATENATE p_folder '\' sy-datum sy-uzeit lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZINVAG_DET REPORT started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.
**********************************************SQL UPLOAD FILE *****************************************
*  CALL FUNCTION 'SAP_CONVERT_TO_TXT_FORMAT'
**   EXPORTING
**     I_FIELD_SEPERATOR          =
**     I_LINE_HEADER              =
**     I_FILENAME                 =
**     I_APPL_KEEP                = ' '
*    TABLES
*      i_tab_sap_data       = it_down
*    CHANGING
*      i_tab_converted_data = it_csv
*    EXCEPTIONS
*      conversion_failed    = 1
*      OTHERS               = 2.
*  IF sy-subrc <> 0.
** Implement suitable error handling here
*  ENDIF.
*
*  PERFORM cvs_header USING hd_csv.
*
**  lv_folder = 'D:\usr\sap\DEV\D00\work'.
*
*
**  lv_file = 'ZINVAG_DET.TXT'.
*CONCATENATE 'ZINVAG_DET' P_LGORT '.TXT' INTO LV_FILE.
*
*  CONCATENATE p_folder '\' lv_file
*    INTO lv_fullfile.
*
*  WRITE: / 'ZINVAG_DET REPORT started on', sy-datum, 'at', sy-uzeit.
*  OPEN DATASET lv_fullfile
*    FOR OUTPUT IN TEXT MODE ENCODING DEFAULT.  "NON-UNICODE.
*  IF sy-subrc = 0.
*      IF sy-subrc = 0.
*        TRANSFER wa_csv TO lv_fullfile.
*
*      ENDIF.
*    ENDLOOP.
*    CONCATENATE 'File' lv_fullfile 'downloaded' INTO lv_msg SEPARATED BY space.
*    MESSAGE lv_msg TYPE 'S'.
*  ENDIF.


ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CVS_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_HD_CSV  text
*----------------------------------------------------------------------*
FORM cvs_header  USING    pd_csv.

  DATA: l_field_seperator.
  l_field_seperator = cl_abap_char_utilities=>horizontal_tab.
  CONCATENATE 'Document No'
              'Material No '
              'Movement Type '
              'Mov Type Desc'
              'Plant '
              'Storage Loc '
              'Quantity '
              'UR Allocated Quantity '
              'SO Allocated Quantity '
              'UR Amount '
              'SO Amount '
              'Posting Date '
              'Aging Day '
              'USA Code'
              'Document Date'
              'Refresh Date'
              'Material Description'
              INTO pd_csv
              SEPARATED BY l_field_seperator.


ENDFORM.
