























*FORM trim_number USING i_num CHANGING v_text.
*data V_INT TYPE int4.
*v_int = i_num.
*V_TEXT = V_INT.
*"SHIFT V_TEXT RIGHT DELETING TRAILING '0'.
**SHIFT V_TEXT RIGHT DELETING TRAILING ' '.
**SHIFT V_TEXT LEFT DELETING LEADING ' '.
*CONDENSE V_TEXT.
*ENDFORM.


FORM CONVERT_TIME_TO_TEXT USING t
CHANGING str.
DATA : v_hr(12) type c,
v_min(12) TYPE c,
v_sec(12) TYPE c.

SPLIT t AT ':' INTO v_hr v_min v_sec.

PERFORM num_to_text CHANGING v_hr.
PERFORM num_to_text CHANGING v_min.
PERFORM num_to_text CHANGING v_sec.

CONCATENATE v_hr 'Hours' v_min 'Minutes' v_sec 'Seconds' INTO STR SEPARATED BY ' '.
CONDENSE STR.
PERFORM CONVERT_TO_CAPTALISED_FORMAT CHANGING STR.
endform.

FORM CONVERT_TO_CAPTALISED_FORMAT CHANGING STR.
CONSTANTS:
sm2big(52) VALUE  'aAbBcCdDeEfFgGhHiIjJkKlLmMnNoOpPqQrRsStTuUvVwWxXyYzZ'.

DATA:
prev_space    TYPE c,
my_len        TYPE i,
my_pos        TYPE i,
numc(53)      ,
num(53).

numc = STR.
num = numc.

TRANSLATE num TO LOWER CASE.
my_len = strlen( num ).

prev_space = 'X'.
my_pos = 0.
WHILE my_pos LT my_len.
IF prev_space = 'X'.
CLEAR prev_space.
TRANSLATE num+my_pos(1) USING sm2big.
ELSEIF num+my_pos(1) = ' '.
prev_space = 'X'.
ENDIF.
my_pos = my_pos + 1.
ENDWHILE.
STR = num.
ENDFORM.


form num_to_text CHANGING n.
data txt LIKE spell.
CALL FUNCTION 'SPELL_AMOUNT'
EXPORTING
AMOUNT          = n
*     CURRENCY        = ' '
*     FILLER          = ' '
LANGUAGE        = SY-LANGU
IMPORTING
IN_WORDS        = txt
EXCEPTIONS
NOT_FOUND       = 1
TOO_LARGE       = 2
OTHERS          = 3
.
IF SY-SUBRC <> 0.
MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
ENDIF.

n = txt-word.
ENDFORM.

FORM FORMAT_NUM USING NUM CHANGING V_TEXT.
DATA : V_NUM TYPE P LENGTH 4 DECIMALS 2,
V_INT  TYPE  INT4.
V_NUM = NUM MOD 1.
IF V_NUM NE '0.00'.
v_num = NUM.
V_TEXT = V_NUM.
ELSE.
V_INT = NUM.
V_TEXT = V_INT.
ENDIF.
ENDFORM.

form get_text USING OBJNAME
                    OBJ_TYP
                    TXT_ID
                    LANG TYPE SPRAS
              CHANGING TXT.

  DATA :  TEXT_LINES TYPE TABLE OF TLINE,
          WA_TEXT_LINE TYPE TLINE.

  IF LANG IS INITIAL.
    LANG = 'E'.
  ENDIF.

  CALL FUNCTION 'READ_TEXT'
    EXPORTING
*     CLIENT                        = SY-MANDT
      id                            = TXT_ID
      language                      = LANG
      name                          = OBJNAME
      object                        = OBJ_TYP
*     ARCHIVE_HANDLE                = 0
*     LOCAL_CAT                     = ' '
*   IMPORTING
*     HEADER                        =
    tables
      lines                         = TEXT_LINES
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
*   MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
*         WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ELSE.
    DESCRIBE TABLE TEXT_LINES.
    IF SY-TFILL <> 0.
      LOOP AT TEXT_LINES INTO WA_TEXT_LINE.
        CONCATENATE TXT WA_TEXT_LINE-TDLINE INTO TXT.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.

FORM calculate_tax USING  p_ebeln TYPE ekpo-ebeln
                          p_ebelp TYPE ekpo-ebelp
                   CHANGING p_mwsbp TYPE komp-mwsbp .

  TYPES : t_ekko TYPE ekko,
          t_ekpo TYPE ekpo,
          t_t001 TYPE t001.

  DATA : ekko TYPE t_ekko,
         ekpo TYPE t_ekpo,
         t001 TYPE t_t001,
         komk TYPE komk,
         komp TYPE komp,

         taxcom TYPE taxcom ,
         t_konv TYPE TABLE OF komv,

         tkomv TYPE TABLE OF komv,

         tkomvd TYPE TABLE OF komvd.

  CONSTANTS:  bstyp-info VALUE 'I',
              bstyp-ordr VALUE 'W',
              bstyp-banf VALUE 'B',
              bstyp-best VALUE 'F',
              bstyp-anfr VALUE 'A',
              bstyp-kont VALUE 'K',
              bstyp-lfpl VALUE 'L',
              bstyp-lerf VALUE 'Q'.

  SELECT SINGLE *
    INTO ekko
    FROM ekko
    WHERE ebeln = p_ebeln .

  SELECT SINGLE *
    INTO ekpo
    FROM ekpo
    WHERE ebeln = p_ebeln
          AND ebelp = p_ebelp .

  SELECT SINGLE *
    INTO t001
    FROM t001
    WHERE bukrs = ekko-bukrs .

  taxcom-bukrs = ekpo-bukrs.
  taxcom-budat = ekko-bedat.
  taxcom-waers = ekko-waers.
  taxcom-kposn = ekpo-ebelp.
  taxcom-mwskz = ekpo-mwskz.
  taxcom-txjcd = ekpo-txjcd.
  taxcom-shkzg = 'H'.
  taxcom-xmwst = 'X'.

  IF ekko-bstyp EQ bstyp-best.
    taxcom-wrbtr = ekpo-netwr.
  ELSE.
    taxcom-wrbtr = ekpo-zwert.
  ENDIF.

  taxcom-lifnr = ekko-lifnr.
  taxcom-land1 = ekko-lands.
  taxcom-ekorg = ekko-ekorg.
  taxcom-hwaer = t001-waers.
  taxcom-llief = ekko-llief.
  taxcom-bldat = ekko-bedat.
  taxcom-matnr = ekpo-ematn.
  taxcom-werks = ekpo-werks.
  taxcom-bwtar = ekpo-bwtar.
  taxcom-matkl = ekpo-matkl.
  taxcom-meins = ekpo-meins.

  IF ekko-bstyp EQ bstyp-best.
    taxcom-mglme = ekpo-menge.
  ELSE.
    IF ekko-bstyp EQ bstyp-kont AND ekpo-abmng GT 0.
      taxcom-mglme = ekpo-abmng.
    ELSE.
      taxcom-mglme = ekpo-ktmng.
    ENDIF.
  ENDIF.

  IF taxcom-mglme EQ 0.
    taxcom-mglme = 1000.
  ENDIF.

  taxcom-mtart = ekpo-mtart.

  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  CALL FUNCTION 'J_1BSA_COMPONENT_ACTIVE'
    EXPORTING
      bukrs                = ekko-bukrs
      component            = 'BR'
    EXCEPTIONS
      component_not_active = 1
      OTHERS               = 2.

  IF sy-subrc IS INITIAL.
    komk-mandt = ekko-mandt.
    komk-kalsm = ekko-kalsm.
    IF ekko-kalsm = ''.
      komk-kalsm = 'RM0000'.
    ENDIF.
    komk-kappl = 'M'.
    komk-waerk = ekko-waers.
    komk-knumv = ekko-knumv.
    komk-lifnr = ekko-lifnr.
    komp-kposn = ekpo-ebelp.
    komp-matnr = ekpo-matnr.
    komp-werks = ekpo-werks.
    komp-matkl = ekpo-matkl.
    komp-infnr = ekpo-infnr.
    komp-evrtn = ekpo-konnr.
    komp-evrtp = ekpo-ktpnr.

    CALL FUNCTION 'RV_PRICE_PRINT_ITEM'
      EXPORTING
        comm_head_i = komk
        comm_item_i = komp
        language    = 'E'
      TABLES
        tkomv       = tkomv
        tkomvd      = tkomvd.

    CALL FUNCTION 'J_1B_NF_PO_DISCOUNTS'
      EXPORTING
        i_kalsm = ekko-kalsm
        i_ekpo  = ekpo
      IMPORTING
        e_ekpo  = ekpo
      TABLES
        i_konv  = t_konv.

    IF NOT ekko-llief IS INITIAL.
      taxcom-lifnr = ekko-llief.
    ENDIF.
  ENDIF.

  CALL FUNCTION 'FIND_TAX_SPREADSHEET'
    EXPORTING
      buchungskreis = t001-bukrs
    EXCEPTIONS
      not_found     = 1
      OTHERS        = 2.

  CALL FUNCTION 'CALCULATE_TAX_ITEM'
    EXPORTING
      i_taxcom            = taxcom
    IMPORTING
      e_taxcom            = taxcom
    EXCEPTIONS
      mwskz_not_defined   = 1
      mwskz_not_found     = 2
      mwskz_not_valid     = 3
      steuerbetrag_falsch = 4
      country_not_found   = 5
      OTHERS              = 6.

  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  p_mwsbp = taxcom-wmwst .

ENDFORM. " calculate_tax



FORM APPEND_PRICING TABLES IT_CONDITIONS TYPE TAB_T_CONDTN
                    USING  WA_CONDITION  TYPE T_CONDTN
                           V_WAERK       TYPE WAERK
                           V_KURRF       TYPE KURRF
                    CHANGING TOTAL_INVOICE_AMOUNT TYPE MAXBT.

  CLEAR WA_CONDITION-SQNO.  " To avoid undesired elements from gettingf appended to the table IT_CONDITIONS

  CASE WA_CONDITION-KSCHL.
    WHEN 'ZPFO'.
      WA_CONDITION-SQNO = 2.
      WA_CONDITION-DESCR = 'P & F'.

    WHEN 'ZEXP'.
      WA_CONDITION-SQNO = 3.
      WA_CONDITION-DESCR = 'Cenvat Duty Collected'.

    WHEN 'ZCEP'.
      WA_CONDITION-SQNO = 4.
      WA_CONDITION-DESCR = 'E.Cess'.
*      CLEAR WA_CONDITION-KBETR.

    WHEN 'ZCEH'.
      WA_CONDITION-SQNO = 5.
      WA_CONDITION-DESCR = 'H.E.Cess'.

    WHEN 'ZLST'.
      WA_CONDITION-SQNO = 7.
      WA_CONDITION-DESCR = 'VAT TIN'.

    WHEN 'ZCST'.
      WA_CONDITION-SQNO = 8.
      WA_CONDITION-DESCR = 'CST TIN'.

    WHEN 'ZIN1' OR 'ZIN2'.
      WA_CONDITION-SQNO = 10.
      WA_CONDITION-DESCR = 'Insurance'.

    WHEN 'ZFR1' OR  'ZFR2'.
      WA_CONDITION-SQNO = 11.
      WA_CONDITION-DESCR = 'Freight'.

  ENDCASE.
  IF V_WAERK <> 'INR'.
    WA_CONDITION-KWERT = WA_CONDITION-KWERT * V_KURRF.
  ENDIF.
  TOTAL_INVOICE_AMOUNT = TOTAL_INVOICE_AMOUNT + WA_CONDITION-KWERT.
  APPEND WA_CONDITION TO IT_CONDITIONS.
  CLEAR WA_CONDITION.
ENDFORM.
