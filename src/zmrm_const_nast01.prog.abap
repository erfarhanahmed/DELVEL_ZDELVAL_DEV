*&---------------------------------------------------------------------*
*&  Include           ZMRM_CONST_NAST01
*&---------------------------------------------------------------------*


SET EXTENDED CHECK OFF.


CONSTANTS:

*----- Nachrichtenapplikation
  C_KAPPL_MR LIKE T681A-KAPPL VALUE 'MR',

*----- Nachrichtenschema
" c_kalsm_0001 LIKE t683-kalsm VALUE 'MR0001',   "MR01
  C_KALSM_0002 LIKE T683-KALSM VALUE 'MR0002',   "MR1M
  c_kalsm_0003 LIKE t683-kalsm VALUE 'MR0003',   "MRKO
  C_KALSM_0004 LIKE T683-KALSM VALUE 'MR0004',   "MRRL - ERS
  C_KALSM_0005 LIKE T683-KALSM VALUE 'MR0005',   "MRNB - Neubewertung
  C_KALSM_0006 LIKE T683-KALSM VALUE 'MR0006',   "MRIS - RePlan

*----- Nachrichtenart
" c_kschl_eink LIKE nast-kschl VALUE 'EINK',
" c_kschl_mlpp LIKE nast-kschl VALUE 'MLPP',
  C_KSCHL_REKL LIKE NAST-KSCHL VALUE 'REKL',
  C_KSCHL_KONS LIKE NAST-KSCHL VALUE 'KONS',
  C_KSCHL_ERS  LIKE NAST-KSCHL VALUE 'ERS ',

*----- Sendemedium
  C_NACHA_DRUCKER     LIKE NAST-NACHA VALUE '1',
  C_NACHA_TELEFAX     LIKE NAST-NACHA VALUE '2',
  C_NACHA_intmail     LIKE NAST-NACHA VALUE '5',
  C_NACHA_EDI         LIKE NAST-NACHA VALUE '6',
" c_nacha_sapoffice   like nast-nacha value '7',
" c_nacha_sonderfkt   like nast-nacha value '8',
" c_nacha_wf_ereignis like nast-nacha value '9',
  C_NACHA_ALE         LIKE NAST-NACHA VALUE 'A',
" c_nacha_wf_aufgabe  like nast-nacha value 'T',

*----- Gerät (-> Formularausgabe)
  C_DEVICE_PRINTER LIKE ITCPP-TDDEVICE VALUE 'PRINTER',
  C_DEVICE_TELEFAX LIKE ITCPP-TDDEVICE VALUE 'TELEFAX',
" c_device_screen  like itcpp-tddevice value 'SCREEN',

*----- Nachrichten-Verarbeitungsstaus
" c_vstat_neu    like nast-vstat value '0',  "nicht verarbeitet
  C_VSTAT_OK     LIKE NAST-VSTAT VALUE '1',  "erfolgreich verarbeitet
  C_VSTAT_FEHLER LIKE NAST-VSTAT VALUE '2',  "fehlerhaft verarbeitet

*----- Business Objekt Typen
  C_OBJTYP_ORDER  LIKE TOJTB-NAME  VALUE  'BUS2012', " Bestellung
  C_OBJTYP_DELIV  LIKE TOJTB-NAME  VALUE  'LIKP'   , " Lieferung
  C_OBJTYP_NOTIF  LIKE TOJTB-NAME  VALUE  'BUS2078', " Q-Meldung
  C_OBJTYP_OLDIV  LIKE TOJTB-NAME  VALUE  'BUS2068', " Alte Reprü
  C_OBJTYP_LOGIV  LIKE TOJTB-NAME  VALUE  'BUS2081', " Log. Reprü

*----- Sonstiges
  C_BUKRS_UNDEF LIKE T001-BUKRS VALUE '$$$$',
  C_sort_swp    like nast-sort1 value 'SWP'.

SET EXTENDED CHECK ON.
